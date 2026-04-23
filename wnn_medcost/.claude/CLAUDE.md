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

### [완료] 환자평가표 조회 버튼 활성화 (2026-04-23)
- **상태**: **활성화됨** — `viewTable` 렌더 후 DataTable 버튼 영역(.dt-buttons)에 "환자평가표 조회" 버튼 표시
- **적용 내역**:
  - CSS `#btnPatvalView { display:none !important }` 규칙 제거
  - `fn_AttachPatvalBtnToDt` 의 숨김 블록 제거, 부착+`_show` 클래스 부여 블록 활성화
- **관련파일**: assessment.jsp(fn_AttachPatvalBtnToDt, fn_ShowPatvalModal, _pvBuildHtml 등), Magam_SQL.xml(select_PatvalMst), MagamController.java(/main/select_PatvalMst.do)
- **재숨김이 필요할 때**: `fn_AttachPatvalBtnToDt` 의 `(1) 환자평가표 조회 버튼` 블록을 이전 숨김 로직(pvBtn 원위치 복귀)으로 되돌리고 CSS `#btnPatvalView { display:none !important }` 재추가

### [확정] 유치도뇨관 오류점검 — 필터 없음 + 정보 컬럼 표시 방식 (2026-04-18 최종)
- **최종 방침**: 자동 필터링 대신 사용자가 직접 판단하도록 **모달에 정보 컬럼 표시**
  - 컬럼: 환자ID · 성명 · 입원일 · **환자분류군(PAT_CLASS)** · **평가구분(EVAL_TYPE 코드·설명)** · **유치도뇨관 삽입(INDWELL_CATH)** · 점검항목
  - 평가구분 포맷: "1·입원 평가" / "2·계속 입원 중인 환자 평가" / "3·이전 환자평가표를 적용하는 경우" (PDF 명세서식 2024.7.1.~)
- **필터 상태**: select_assesCheck00/02, select_CathCrossCheck, select_PrevMonthMissing05 **모두 필터 없음** (원상태)
- **모달 UI**: 폭 1400px, 제목바 드래그로 이동 가능
- **관련파일**: Magam_SQL.xml, assessment.jsp (fn_ShowCath05Modal, _cath05EnableDrag, _EVAL_TYPE_MAP)
- **재수정 주의**: 이전에 그리드 필터를 적용했다가 사용자 선택으로 철회함. 재적용 요청 시 이 방침 먼저 확인

### [완료] 유치도뇨관 크로스체크 D3/D4 기간 필터 + D6 신규 추가 (2026-04-23)
- **배경**: 오더→평가표 크로스체크가 입원건 전체 기간의 오더를 다 대조해서, 당월 조회인데 다른 달 오더까지 오류로 집계되는 문제
- **규칙 (당월 기준)**:
  - 기간 상한 = 당월 평가표 `MAX(DOC_DT)`
  - 기간 하한 = 전월 평가표 `MIN(DOC_DT) + 1일`, 전월 평가표 없으면 **전월 1일(YYYYMM01)**
  - 당월 평가표 자체가 없는 환자 → 오류 제외
- **변경내역 (Magam_SQL.xml `select_CathCrossCheck`)**:
  - **D3 (오더O/평가표X)**: EXISTS(당월 평가표) + S.MED_START 기간 필터 추가
  - **D4 (날짜불일치)**: S.MED_START 기간 필터 추가 (INNER JOIN이라 EXISTS는 이미 보장됨)
  - **D6 신규 추가** (평가표O/오더X, 날짜 단위): CAT_IN_1~10 각 날짜가 오더 M0060에 없으면 오류
    - 파생테이블 PX로 CAT_IN_1~10을 10-way UNION ALL 펼침
    - 빈값/`00000000` 제외, 기간 필터 동일 적용
    - 수가자료 자체가 없는 환자는 D5 영역이므로 제외 (EXISTS M0060)
    - 메시지: `[D6] [평가표O/오더X] 평가표 삽입일(YYYYMMDD)에 해당하는 오더(M0060) 기록 없음`
- **XML 주의**: `<=` 는 `<![CDATA[ <= ]]>` 로 감싸야 파싱됨. `>=` 는 그대로 OK
- **클라이언트 JS**: 수정 불필요 — D6는 A1/A2가 아니므로 1·입원평가 필터에서 자동 제외됨
- **관련파일**: Magam_SQL.xml(select_CathCrossCheck)

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
