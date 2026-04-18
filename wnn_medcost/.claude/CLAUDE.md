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

### [대기/토글예정] 유치도뇨관 크로스체크 필터 — 제외 환자 보기 옵션
- **배경(2026-04-18 적용)**: 오류점검(D3/D4/D5) 결과에 그리드(select_CategoryList05)에 없는 환자가 나와 혼선 → 그리드와 동일 필터 추가로 대상자 일치시킴
- **현재 적용 필터 (select_CathCrossCheck 내 D4/D5)**:
  - `IFNULL(P.PAT_CLASS,'') NOT LIKE 'A%'`    ← 환자군 A(경증군) 제외
  - `P.EVAL_TYPE = '2'`                       ← 계속입원 평가만
    OR `P.EVAL_TYPE = '3'` + MED_START 1일 + DOC_DT 7~10일 + 전월 동일 DOC_DT 없음
  - `S.MED_START LIKE CONCAT(#{jobYymm},'%')` ← 당월 오더만
  - D5는 `CAT_IN_1~10 중 하나라도 당월` 조건 (전월 이전 삽입은 제외)
- **D3(오더O/평가표X)**: PAT_CLASS/EVAL_TYPE은 적용 안함(평가표 자체가 없으므로). `S.MED_START LIKE jobYymm%`만 적용
- **추후 요청 대응 방향**: "제외된 환자도 보여달라"고 사용자가 요청하면
  1. 모달/버튼에 "전체 보기" 토글 스위치 추가
  2. AJAX data에 `includeAll=Y` 전달
  3. SQL에서 `<if test="includeAll != 'Y'">...필터...</if>`로 감싸 선택적으로 적용
- **관련파일**: Magam_SQL.xml(select_CathCrossCheck), assessment.jsp(fn_ShowCath05Modal), MagamController.java(select_CathCrossCheck)
