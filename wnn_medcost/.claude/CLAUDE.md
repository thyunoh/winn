# Project Memory

## 예정 개발 (회의 후 착수)

### [예정 · 2026-07-14 회의 후 착수] 컨설팅 문서 전산화 (의뢰서·견적서·홍보물·안내문)
- **개요**: 종이·팩스로 오가던 컨설팅 문서 5종을 WinCheck+ 안으로 전산화. **1단계=의뢰서+견적서**(핵심, 수기 접수·견적 제거), 2=홍보물 편집CMS, 3=프로그램안내→도움말/온보딩·연간안내문→공지.
- **계획·DB설계·민감정보 원칙 전부**: [docs/proposals/문서전산화_개발계획.md](docs/proposals/문서전산화_개발계획.md) — 제안 원문(시각) docs/proposals/위너넷_문서전산화_제안_2026-07-12.html · 공유 아티팩트 https://claude.ai/code/artifact/211932ce-00e8-476b-b591-6af1bff156b7 · 원자료 `D:\워너넷자료\제안내용\`(PDF 6종).
- **이어서 작업 시(다른 PC 포함)**: 위 계획 md 읽고 **회의에서 확정된 범위대로 1단계부터** 구현 — 배경 재설명 불필요. 신규 테이블 `TBL_CONSULT_REQ/MANAGER/AGREE`·`TBL_QUOTE/QUOTE_ITEM`·`TBL_PROMO_CONTENT`. 민감정보(프로그램PW·심평원 인증서 암호) 저장최소화+AES-256+마스킹+감사로그. 요양기관기호·병원명 로그인 자동채움, 목표점수·등급 `TBL_GRADE_MST` 연계.

## 장애/수정 이력

### [완료] 샘파일 업로드(TBL_FILES_DATA→각 테이블) 대폭 최적화 — SP_UPLOAD_MAGAM_SAMFILES 재작성 (2026-07-09)
- **증상**: 청구샘파일 업로드가 너무 느림(17,254줄 = 4분16초, 평가파일 417줄 = 11.6초). 병목은 Java INSERT가 아니라 **프로시저의 라인별 처리**.
- **원인 (라인당 반복 비용)**: ① 컬럼 커서가 컬럼(TBL_PATVAL_MST는 240개)마다 lineval 전체를 REPLACE×2+EUC-KR 변환 반복 ② mg_flag='9'는 라인마다 INFORMATION_SCHEMA로 table_update(GROUP_CONCAT) 재계산 ③ 한 줄당 INSERT 1문 → 수천 번 PREPARE/EXECUTE.
- **조치 (DB 프로시저 교체, 앱 로직 무변경)**: [docs/sql/SP_UPLOAD_MAGAM_SAMFILES.sql] = ⓐ 라인 1회만 `@line_bin` 변환 ⓑ 명세서/평가표 라인은 커서 대신 GROUP_CONCAT 셋 기반 1쿼리로 val 목록 생성(TBL_CHUNG_MST 청구서 라인만 원본 커서 유지 — claim_no/M010.1 합계 캡처) ⓒ 같은 그룹 연속 라인 multi-row INSERT 배치(500행/2MB 상한) ⓓ table_update 루프 밖 1회 ⓔ 신규 [SP_EXECUTE_DYNAMIC_SQL2](docs/sql/SP_EXECUTE_DYNAMIC_SQL2.sql) = 기존 실행기의 stmt_text TEXT(64KB 한계) → LONGTEXT (배치 문장이 64KB 초과, **기존 SP_EXECUTE_DYNAMIC_SQL은 다른 호출자용으로 그대로 둠**).
- **함정 2개 (재수정 시 주의)**: ① 배치 INSERT가 64KB 넘으면 구 실행기 stmt_text TEXT에서 잘려 오류 → 반드시 SQL2 사용. ② NOT FOUND 핸들러가 col_done=0/1로 콜/데이터 커서를 구분하는데, 셋 기반 경로는 col_cursor를 안 돌아 col_done=0으로 남음 → **dat FETCH 직전 `SET col_done=1` 필수** (없으면 마지막 줄 중복 처리 → total_cnt+1 → 30000 오류).
- **검증 (가짜 HOSP_CD=99999998로 실데이터 복제, 전 테이블 COUNT+CRC32 체크섬 비교 → 4개 데이터셋 모두 완전 동일)**: GHP 4,260줄 18.0s→2.3s / REP 17,254줄 255.7s→9.3s(27.6배) / 평가 417줄 11.6s→1.7s / 산재 6파일 133줄 0.25s→0.15s.
- **원본 백업**: [docs/sql/SP_UPLOAD_MAGAM_SAMFILES_backup_20260709.sql] (DELIMITER 감싸 실행하면 즉시 원복).
- **부수 변경**: magamFileUpload.jsp 예상시간 공식 80/25줄/초 → 3초+600/120줄/초. (JSP만이라 WAR 재빌드 불필요하나 다음 배포에 포함할 것)
- **후속 (2026-07-09 오후, 대형 파일 90000 실패)**: 4.9MB/2.6만줄 GHP 업로드가 진행바 100% 후 한참 돌다 `90000` 실패. **원인은 자바 쪽 TBL_FILES_DATA 적재** — MyBatis foreach가 2.6만행을 한 문장(6MB+, 파라미터 34만개)으로 생성하다 예외(+ DBCP removeAbandonedTimeout 300초 강제회수 가능성). **조치**: ① [MagamServiceImpl] `insertFilesDataBatch` 신설 = 순수 JDBC 배치(1000행 단위 executeBatch, URL의 rewriteBatchedStatements=true로 multi-row 변환, 단일 커넥션 마지막 commit이라 전체성공/전체취소 유지). `uploadMagamFilesMain`/`uploadMagamFilesOnly` 둘 다 이걸 쓰도록 교체(기존 mapper.uploadMagamFilesMain XML은 잔존·미사용) ② [context-datasource.xml] removeAbandonedTimeout 300→900 (양 프로파일). **주의**: 기존 `jdbcTemplate` 필드는 @Autowired가 없어 null(uploadMagamFilesBatch는 죽은 코드 — 호출하면 NPE) → DataSource 직접 주입 방식 사용. **자바+XML 변경 → WAR 재빌드 필수.**

### [완료] 차등제(01~04) 저장 안됨 + 직전분기 자동복제 + 저장분기 그리드 신설 (2026-07-03)
- **증상 1 (업데이트 안 됨)**: 분기 선택 후 저장해도 값이 이전 그대로. **원인**: `saveHospGrd`가 `INSERT ... ON DUPLICATE KEY UPDATE`인데 TBL_GRADE_MST에 (HOSP_CD,START_YY,QTER_FLAG) UNIQUE 키가 없으면 매 저장이 새 행 추가 → `selectHospGrd`가 `LIMIT 1`(정렬 없음)로 **옛 행**을 읽음. **조치**: [UserServiceImpl.saveHospGrd] = **UPDATE 먼저(`updateHospGrdData` 신설) → 0건이면 INSERT**, `selectHospGrd`에 `ORDER BY UPD_DTTM DESC` 추가. 기존 중복행은 다음 저장 때 전부 같은 값으로 수렴(삭제 불필요).
- **증상 2 (하나 저장했는데 두 분기 생김)**: 컨트롤러 `saveHospGrd.do`가 저장 전에 **직전 분기에도 동일 값 자동복제 저장**(+직전분기 구조영역 재계산). 사용자 요청으로 **제거** — 한 번 저장 = 선택 분기 1건만. `callIndicatorsStructureZone`은 현재 미호출(코드 잔존, 지표 재계산은 화면 fn_CreateData가 수행).
- **신설 (저장분기 그리드)**: assessment.jsp 차등제 폼과 하단 문구 사이에 저장된 분기 목록 그리드(`#grdListWrap`, 전 항목+수정일시, 좌우스크롤). 신규 조회 `selectHospGrdList`(/user/selectHospGrdList.do, 5계층). 동작: **보기 진입=해당년도(평가년월 년도) 내 최종분기 자동선택**(년도 셀렉트는 안 바꿈)·**조회하기=선택한 분기**·그리드는 **선택 년도만 표시**(없으면 "N년 저장된 자료가 없습니다")·행 클릭=폼 적용·저장 후 그리드 자동갱신+우측 카드 유지(fn_CreateData가 card_container 숨기는 것 즉시 복원).
- **배포**: 자바+XML 변경 → WAR 재빌드 필수.

### [완료] 대시보드 500 전 병원 장애 — s_hospid 세션쿠키화 회귀 + 빈 뷰 500 (2026-06-10)
- **증상**: 전 병원에서 `dashboard.do` 가 HTTP 500(흰 화면). 콘솔 `Failed to load ... dashboard.do 500`, 서버로그 `Could not resolve view with name ''`. 개발자 PC만 정상(예전 쿠키 잔존).
- **근본원인 1 (회귀)**: 어제 커밋 `893db73`(06-09 13:40)이 [top.jsp](src/main/webapp/WEB-INF/tiles/main/top.jsp) 에서 `s_hospid`(+s_hospnm/s_conact_gb/s_winconect/s_closeDt1/2) 를 `setCookie(...,1)`(1일 유지) → `setSessionCookie`(세션쿠키)로 변경. **브라우저 종료 시 쿠키 삭제** → 재접속 시 `s_hospid` 쿠키 없음.
- **근본원인 2 (구조적 버그)**: 모든 화면 진입 컨트롤러가 `cookie_value.get("s_hospid").trim()` 호출 → 쿠키 null이면 **NPE → catch → `return ""`** → Spring 빈 뷰 못 찾음 → **500**. 로그인은 세션/ sessionStorage 에만 저장하고 `s_hospid` **쿠키는 top.jsp 병원선택 시에만** 생성되는 구조라, 세션쿠키화가 치명적.
- **조치**:
  1. [top.jsp](src/main/webapp/WEB-INF/tiles/main/top.jsp) L312~ : `setSessionCookie` → `setCookie(...,1)` **원복**(전 병원 즉시 복구)
  2. [UserController.java](src/main/java/egovframework/wnn_medcost/user/web/UserController.java) `main1`(dashboard.do): null-safe(`String s_hospid; if(s_hospid!=null && !trim().isEmpty())`) + 쿠키 없으면 `return ".login/LoginWinCT"`(500 대신 로그인 화면)
  3. **6개 컨트롤러 일괄**: User/Base/Tong/Mangr/Chung/Magam 의 모든 뷰 가드 `return ""`(else+catch, 총 102곳) → `return ".login/LoginWinCT"`. NPE가 나도 catch에서 로그인 화면 반환되어 500 영구 차단. (AJAX 엔드포인트는 `return ""` 미사용 — 영향 없음 확인)
- **주의**: `s_hospid` 를 다시 세션쿠키로 바꾸지 말 것. 로그인 후 `s_hospid` 쿠키를 서버에서 직접 심거나 두 앱 공유 인증토큰을 도입하기 전에는 영구쿠키 유지가 안전. 직접 URL 우회 차단은 컨트롤러의 로그인뷰 반환으로 대체됨.
- **배포**: 자바(.java) 변경 포함 → **WAR 재빌드 후 톰캣 재배포 필수.**
- **[확정 2026-06-10] 직접 URL 접근 차단(로그인 강제) — 안 함**: `…/user/dashboard.do` 를 즐겨찾기로 직접 쓰는 기관/사용자가 실제로 있어, 로그인 강제 시 그들이 매번 로그인해야 함. 사용자 결정으로 **현재(영구 1일 쿠키 + 직접 .do 접근 허용) 유지**. 보안은 쿠키 1일 만료 + 로그아웃 삭제로 최소 확보. **"직접접근 막자/로그인 거쳐야만" 재요청 시 이 방침과 [s_hospid 세션쿠키 금지] 먼저 확인.** 정 강화하려면 s_hospid는 영구 유지한 채 별도 세션쿠키 게이트로만(절대 s_hospid를 세션쿠키화 금지), 로컬 테스트 후 적용.
- **후속 (jsessionid 404 / 크롬 무스타일)**: 세션쿠키(JSESSIONID) 미전송 브라우저(예: 미로그인/쿠키차단 크롬)에서 서버가 전 URL에 `;jsessionid=` 를 붙여(URL 리라이트) 정적 CSS/JS 가 `…css;jsessionid=…` → **404 → 화면 무스타일**. [web.xml](src/main/webapp/WEB-INF/web.xml) 에 `<session-config><tracking-mode>COOKIE</tracking-mode></session-config>` 추가로 URL 리라이트 차단(쿠키 전용 추적). 엣지는 세션쿠키 있어 정상, 크롬은 미로그인/쿠키차단 시 발생. 이 설정으로 쿠키 없어도 정적파일은 정상 로드되어 최소한 스타일은 깨지지 않음. **web.xml 변경도 재배포/재기동 필요.**

### [완료] 마감 샘파일 업로드 — `SP_EXECUTE_DYNAMIC_SQL` "Query was empty" + 핸들러가 진짜오류 은폐 (2026-06-23)
- **증상**: 특정(큰) 청구샘파일 업로드 시 `45000 - SQLSTATE 없음 - MESSAGE 없음` 팝업. 데이터는 정상인데 파일 지우면 다음 줄/파일에서 또 발생. `TBL_DISEASE_MST`, GHP, valsize=78 등에서 반복.
- **근본원인**: [SP_EXECUTE_DYNAMIC_SQL] 이 동적SQL을 `;` 로 분리 실행하는데, **마지막 세미콜론 뒤 개행(`\n`)** 이 빈 문장으로 잡혀 `PREPARE '\n'` → **`Query was empty`(errno 1065)**. 가드가 `LENGTH(stmt_text) > 0` 이라 `"\n"`(길이 1)이 통과. 큰 파일이라 루프 중간 flush(`LENGTH(iuds_sql_nm) > max_insert_length=10MB`)가 발동하며 `;\n` 으로 끝나 노출됨. (작은 파일은 끝이 `TBL_MAGAM_INFO` INSERT의 `;` 라 안 걸림)
- **왜 원인이 안 보였나 (중요)**: 핸들러들이 진짜 오류를 계속 변형/소실시킴.
  1. `SP_EXECUTE_DYNAMIC_SQL` 의 EXIT HANDLER 가 `CONCAT('... ', sql_value)` 에서 **CONCAT 인자 NULL → 전체 NULL → `SIGNAL SET MESSAGE_TEXT = NULL`** → `Variable 'MESSAGE_TEXT' can't be set to the value of 'NULL'` 2차오류로 덮음.
  2. 메인 `SP_UPLOAD_MAGAM_SAMFILES` 의 EXIT HANDLER 는 `NOT FOUND` continue 핸들러가 진단영역을 덮어 `GET DIAGNOSTICS` 가 NULL/빈값 반환 → "SQLSTATE 없음".
- **조치 (확정)**:
  1. **[SP_EXECUTE_DYNAMIC_SQL]** 가드를 `IF stmt_text IS NOT NULL AND stmt_text REGEXP '[^[:space:]]' THEN` 로 변경 → 공백/개행만 있는 조각 스킵(`TRIM` 은 개행 못 지워서 REGEXP 사용). **EXIT HANDLER 3개는 모두 제거(주석)** — 오류는 메인으로 그대로 전파시키는 게 안전(인너는 롤백 기능 없음, 메시지만 변형했음).
  2. **[SP_UPLOAD_MAGAM_SAMFILES] 메인 EXIT HANDLER 복구**: `GET DIAGNOSTICS` + `errcode/errmess`(stage/colVal/lastSQL 디버그필드 포함) + `ROLLBACK`, **RESIGNAL 없음**(앱이 친절한 팝업 띄우게). `NOT FOUND` continue 핸들러는 유지.
- **디버깅 기법(재사용)**: 원인 안 보일 때 ① 메인 errmess 에 `@dbg`(단계마커)·`@sql_val`(실패 동적문장) 추가 → 위치 특정, ② 그래도 안 보이면 **핸들러 전부 주석 + 메인에 `RESIGNAL` 임시추가** → 원본 MySQL 오류를 톰캣 로그/팝업에 그대로 노출. 정리 시 RESIGNAL 제거.
- **주의**: `col_list`/`val_list` 는 LONGTEXT 로 확장해 둠(원래 VARCHAR(4000)). 4000 오버플로우는 이번 원인은 아니었지만 큰 테이블 대비 유지.
- **배포**: 프로시저 2개 `DELIMITER` 재생성. (앱 변경 없음)

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

### [완료] 06.배뇨관리 — 관리항목 컬럼 + 관리여부 색상화 (2026-05-07)
- **내용**:
  - 그리드 헤더: "배뇨상태 → 관리항목 → 관리여부" 순서, **관리항목**은 colspan=3 으로 [일정한 배뇨 / 방광훈련 / 규칙적 도뇨] 묶음 (2-row header)
  - 각 sub-column: `UR_PLAN='1'` / `BLAD_TRAIN='1'` / `REG_CATH='1'` 일 때 **검정 ◯** 표시 (그 외 공란)
  - 관리여부: `manageYn='Y'` (분자 해당) → "**관리**" 파란색 굵게 / 그 외 → "**제외**" 회색
- **변경파일**:
  - `assessment.jsp` cate_cd === "06" 블록: c_Head_Set 1행 → 2행(object[][]) 변환, columnsSet 에 urPlan/bladTrain/regCath 3컬럼 추가, manageYn render 수정
  - `Magam_SQL.xml` `select_CategoryList06`: SELECT 에 `pm.UR_PLAN AS urPlan`, `pm.BLAD_TRAIN AS bladTrain`, `pm.REG_CATH AS regCath` 추가
  - `PatvalDTO.java`: `urPlan`, `bladTrain`, `regCath` 필드 + getter/setter 추가
- **호환성**: `fn_PrependPatvalChangedColumn` 이 1D/2D c_Head_Set 모두 지원하므로 변경 컬럼 prepend 정상 동작

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

### [철회] 유치도뇨관 크로스체크 D7 (2026-04-24 제거)
- **원래 기능**: 오더(M0060) 당월 있으나 당월 평가표 자체가 없는 케이스를 D7 오류로 잡음 (2026-04-23 추가)
- **철회 사유**: "당월 평가표가 없으면 수가가 있어도 무조건 제외" 방침 확정 (2026-04-24 사용자 요청)
- **제거 내역**:
  - Magam_SQL.xml `select_CathCrossCheck`: D7 UNION ALL 블록 전체 삭제
  - assessment.jsp L527, L604: `if (errType !== 'D3' && errType !== 'D7')` → `if (errType !== 'D3')` 로 축소
- **재부활 시 주의**: 사용자 요청으로 제거된 기능이므로, 재도입 요청이 올 때 이 방침 먼저 확인

### [완료] 유치도뇨관 크로스체크 작성일 기준 — D3/D4/D6 검증 기간 (전월 작성일, 당월 작성일] (2026-05-12 최종)
- **배경**: 오더→평가표 크로스체크가 "작성일 이후 오더" + "전월 평가에 속한 오더"까지 오류로 집계 → 차기/전기 평가표에서 반영될 오더를 현재 평가에 책임지우는 문제
- **검증 기간 룰 (모든 D 블록 통일)**: `(전월 평가표 MAX(DOC_DT), 당월 평가표 DOC_DT]`
  - 하한: 전월 평가들 중 **마지막 작성일** 다음날부터 (그 이전 오더는 전월 평가에 반영되었어야 함)
  - 상한: 당월 평가표 작성일까지 (그 이후 오더는 차기 평가에서 반영될 것)
  - 전월 평가표 없으면 하한 미적용 (COALESCE → '00000000')
- **최종 규칙 (작성일 기준, 2026-05-12)**:
  - **D3 (오더O/평가표X)**: `MED_START > 전월 MAX(DOC_DT) AND <= 당월 MAX(PX.DOC_DT)` — 당월 평가표 없으면 상한이 NULL → 자동 제외
  - **D4 (날짜불일치)**: `MED_START > 전월 MAX(DOC_DT) AND <= P.DOC_DT` — 해당 평가표 작성일 이후 + 전월 마지막 평가 이전 오더 모두 검증 제외
  - **D6 (평가표O/오더X, 날짜 단위)**: CAT_IN_1~10 10-way UNION ALL + 기간 필터 (상한 당월 MAX(DOC_DT), 하한 **전월 MAX(DOC_DT)+1일** ← 2026-05-12 MIN→MAX 변경)
  - 당월 평가표 없는 환자는 전 블록에서 자동 제외 (D7 철회와 일관)
- **사례 (2026-05-12 사용자 보고)**: 남서울요양 8월 김창*, 7월 평가 작성일 7/28, 8월 평가 작성일 8/18, 오더 삽입일 7/14 → 7월 평가 기간(7/28까지) 안 기록이므로 8월 D4 오류에서 제외되어야 함. 이전 코드는 상한만 있어 7/14를 8월 D4로 오탐
- **우측하단 수가(M0060) 패널 필터 (assessment.jsp `_cath05RenderSpcsuga`)**:
  - 행 클릭 시 선택 행의 `data-docdt` 캡처 → `_cath05LoadDetail(patId, admitDt, docDt)` → `_cath05RenderSpcsuga(rows, maxDocDt)`
  - `r.medStart > maxDocDt` 행은 렌더링에서 제외 (오류체크 로직과 동일 기준)
- **XML 주의**: `<=` 는 `<![CDATA[ <= ]]>` 로 감싸야 파싱됨. `>=` 는 그대로 OK
- **클라이언트 JS 동작**: D6는 A1/A2가 아니므로 1·입원평가 필터에서 자동 제외됨
- **관련파일**: Magam_SQL.xml(select_CathCrossCheck), assessment.jsp(fn_ShowCath05Modal 행 렌더 L766, _cath05BindRowClick, _cath05LoadDetail, _cath05RenderSpcsuga)

### [대기] 유치도뇨관 오류점검 — 평가구분별 오류 추가/제외 규칙 (2026-04-?? 요청)
- **ADD (새 오류로 잡을 케이스)**:
  - 평가구분 1·입원평가 + **당월 입원환자가 아닌데 입원평가로 체크된 경우** (errType 예: `A1`)
  - 평가구분 1·입원평가 + **당월 이미 입원평가가 있는데 또 입원평가로 체크된 경우** (errType 예: `A2`)
  - **[철회 2026-05-12] 우측 패널 prevMaxDocDt 필터**: 한 번 추가했으나 사용자 요청으로 원복. 우측 수가오더 패널은 **상한(maxDocDt)만** 필터링하고 하한 미적용 — 사용자가 모든 오더를 시각적으로 확인할 수 있게 유지. 오류 검출(SQL)에서만 검증 기간 적용
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

## 샘파일 자동수집 에이전트 (구상)

### [대기] 병원 PC 에이전트 — 샘파일 생성 감지·자동 업로드 (2026-07-03 구상, 착수 보류)
- **배경**: 샘파일이 심평원 제출 후에는 암호화되어 복호화가 복잡 → 제출 전 생성 직후 원본 확보. 위너넷(웹) 미실행 상태에서도 수집되도록 **별도 에이전트 설치 방식** 채택 결정.
- **구성안**: 병원 PC 상주 에이전트(C#/.NET 트레이 + FileSystemWatcher 권장) — 병원별 감시폴더 기준정보, 새 샘파일 감지→쓰기완료 대기→HTTPS 업로드→재시도·중복방지(해시). 서버는 **기존 업로드 경로(/main/uploadMagamFiles.do) 재활용** 검토(에이전트용 토큰 인증만 추가), 병원별 기준정보(HOSP_CD·폴더·토큰)+수신이력 테이블.
- **핵심 체크**: ①개인정보(주민번호 포함) 전송·저장 보안 및 처리 위탁계약 ②병원 방화벽·설치 정책 ③청구SW별 샘파일 생성폴더·파일명 규칙(병원별 상이).
- **상태**: 개발 가능 판단 완료. 착수 시점은 추후 결정.
