# Project Memory

## 적정성평가 (assessment.jsp) 요구사항

### [대기] 유치도뇨관 전월 대상자 당월 추적 기능
- **내용**: 전월 유치도뇨관 있는 대상자(제거 대상자 포함)를 당월 화면에서 체크박스로 확인 가능하도록
- **구현방향**: 당월 cate_cd='05' 환자 목록에 "전월에도 유치도뇨관 있었음" 체크박스 컬럼 추가
- **필요작업**: 전월 대상자 조회 SQL 추가 → 당월 목록 렌더링 시 매칭 표시
- **관련파일**: assessment.jsp, Magam_SQL.xml

### [대기] 유치도뇨관 엑셀 업로드 오류 크로스체크 기능
- **내용**: EMR/OCS의 유치도뇨관 삽입 오더 내역을 엑셀로 업로드하면, 평가표 상 삽입일자/제거일자와 자동 대조하여 오류 검출
- **오류 케이스**:
  - 오더에 삽입 있는데 평가표에 누락
  - 오더 삽입일 ≠ 평가표 개시일 (날짜 불일치)
  - 오더에 제거 기록 있는데 평가표에 제거일 미입력
  - 평가표에 있는데 오더에 해당 삽입코드 없음
- **구현방향**: 엑셀 파싱 → 평가표 데이터 조회 → 환자별 매칭 비교 → 오류 목록 표시
- **관련파일**: assessment.jsp, Magam_SQL.xml

### [대기] 특정수가현황(TBL_SPCSUGA_INFO) ↔ 환자평가표 크로스체크
- **내용**: magamFileUpload.jsp에서 업로드한 특정수가현황(M0060 등) 데이터를 환자평가표(TBL_PAT_INDI/assessment)와 대사하여 누락/불일치 검출
- **엑셀 필수컬럼**: 요양기관기호, 입원일, 주민번호, 환자성명, 보험/수가코드(정의코드/청구코드), 내원일(여러개-쉼표/공백 구분 MM-DD 형식)
- **업로드 시 처리규칙**:
  - 내원일 여러개인 경우 개수만큼 행 확장하여 저장
  - 내원일 연도는 같은 행 입원일의 연도로 채움 (MM-DD → YYYY-MM-DD)
  - 엑셀의 요양기관기호와 로그인 병원 일치 여부 확인, 불일치 시 경고(저장은 세션 hosp_cd로 강제)
- **관련파일**: magamFileUpload.jsp, MagamController.java(saveSpcsugaDatas), Magam_SQL.xml, SpcsugaDTO.java, assessment.jsp

### [대기/히든] 환자평가표 조회 버튼 오픈
- **상태(2026-04-18)**: 협의 전까지 **히든 처리** — assessment.jsp `fn_AttachPatvalBtnToDt` 내 부착 블록 주석 처리됨
- **재오픈 방법**: 해당 함수 `(1) 환자평가표 조회 버튼` 블록의 주석 해제 + `_hidePv.style.display='none'` 두 줄 제거
- **관련파일**: assessment.jsp(fn_AttachPatvalBtnToDt, fn_ShowPatvalModal, _pvBuildHtml 등), Magam_SQL.xml(select_PatvalMst), MagamController.java(/main/select_PatvalMst.do)
- **남아있는 기능**: Controller·SQL·모달 JS는 모두 유지됨. 버튼만 숨김

### [확정] 유치도뇨관 오류점검 — 필터 없음 + 정보 컬럼 표시 방식 (2026-04-18 최종)
- **최종 방침**: 자동 필터링 대신 사용자가 직접 판단하도록 **모달에 정보 컬럼 표시**
  - 컬럼: 환자ID · 성명 · 입원일 · **환자분류군(PAT_CLASS)** · **평가구분(EVAL_TYPE 코드·설명)** · **유치도뇨관 삽입(INDWELL_CATH)** · 점검항목
  - 평가구분 포맷: "1·입원 평가" / "2·계속 입원 중인 환자 평가" / "3·이전 환자평가표를 적용하는 경우" (PDF 명세서식 2024.7.1.~)
- **필터 상태**: select_assesCheck00/02, select_CathCrossCheck, select_PrevMonthMissing05 **모두 필터 없음** (원상태)
- **모달 UI**: 폭 1400px, 제목바 드래그로 이동 가능
- **관련파일**: Magam_SQL.xml, assessment.jsp (fn_ShowCath05Modal, _cath05EnableDrag, _EVAL_TYPE_MAP)
- **재수정 주의**: 이전에 그리드 필터를 적용했다가 사용자 선택으로 철회함. 재적용 요청 시 이 방침 먼저 확인

### [대기] 유치도뇨관 오류점검 — 평가구분별 오류 추가/제외 규칙 (2026-04-?? 요청)
- **ADD (새 오류로 잡을 케이스)**:
  - 평가구분 1·입원평가 + **당월 입원환자가 아닌데 입원평가로 체크된 경우** (errType 예: `A1`)
  - 평가구분 1·입원평가 + **당월 이미 입원평가가 있는데 또 입원평가로 체크된 경우** (errType 예: `A2`)
- **EXCLUDE (오류에서 제외)**:
  - 평가구분 2·계속입원중 환자 중 **전월 평가표 상 유치도뇨관이 제거된 대상자**
  - **당월 평가표가 없는 대상자** (현 _prevMissingData / 전월대상자 당월미존재)
- **3가지 대상자는 오류에서 제외** (요청자 표현)
- **필요 서버 작업**:
  - Magam_SQL.xml: select_assesCheck00(또는 신규) 에 A1/A2 케이스 SELECT UNION
  - 판정 조건: (1) 당월 입원환자는 TBL_IPWON_INFO 로 체크, (2) 당월 입원평가 중복 여부는 TBL_PATVAL_MST evalType='1' 카운트로 체크
  - select_CathCrossCheck 등에서 evalType='2' + 전월 indwellCath 제거 케이스 제외 조건 추가
- **필요 클라이언트 작업**:
  - assessment.jsp fn_ShowCath05Modal 의 _prevMissingData 루프 제거 또는 조건부 스킵
  - A1/A2 errType에 대한 라벨 매핑 추가
- **관련파일**: Magam_SQL.xml, MagamController.java, assessment.jsp
