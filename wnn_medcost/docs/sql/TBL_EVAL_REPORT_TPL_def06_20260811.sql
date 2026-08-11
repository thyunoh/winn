-- ═══════════════════════════════════════════════════════════════════════════
-- 월분석보고서 — 배뇨관리(def_06) 지표정의 문구 정리 · 2026-08-11
--   요청 : 박혜련 (2026-08-07)
--
-- 왜 :
--   ① 종전 문구의 「분자 인정 = ①… + … ②… + …」 가 **수식처럼 보였다.**
--   ② 제외 대상이 괄호 안에 있어 ***«③ 규칙적 도뇨」에만 걸리는 것처럼*** 읽혔다.
--   ⇒ 문장으로 풀고, 제외는 «단, …» 별도 문장으로 뺐다.
--
-- ★★함정 — 이 문구는 **세 곳에 있다.** 하나만 고치면 화면이 안 바뀐다.
--     ① JSP 내장 기본값 : evalReport.jsp 의 TPL_DEF['06']
--     ② 시드 파일       : docs/sql/TBL_EVAL_REPORT_TPL_seed.sql
--     ③ **운영 DB**     : TBL_EVAL_REPORT_TPL   ← 이번에 이것만 빠져 있었다
--   문구 우선순위가 `병원별 TEXT > TPL > JSP 내장` 이라 **TPL 이 JSP 를 덮는다.**
--   2026-08-10 에 JSP 만 고쳐서 화면에는 옛 문구가 그대로 나오고 있었다.
--   (2026-07-23 「(2026년 2주기 8차 신설)」 제거 때와 **같은 함정** — 그때도 세 곳을 다 고쳤다.)
--
-- ※ 병원별 저장본(TBL_EVAL_REPORT_TEXT · SECT_KEY='def_06')은 **0 건**이라 손댈 것이 없다.
--   (있었다면 그 병원은 저장본이 우선이라 이 수정이 안 먹는다 — 그때는 해당 행을 지워야 한다.)
-- ═══════════════════════════════════════════════════════════════════════════

-- 적용 전 확인
SELECT '적용전' AS chk, SECT_KEY, TPL_CONTENT FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='def_06';

UPDATE TBL_EVAL_REPORT_TPL
   SET TPL_CONTENT = '배뇨조절이 저하된 환자(자주 실금함·조절 못함) 중 배뇨관리를 실시한 환자의 비율. ① 일정하게 짜여진 배뇨계획에 따른 배뇨일지 3일 이상 작성, ② 방광훈련프로그램 시행 및 배뇨일지 3일 이상 작성, ③ 규칙적 도뇨 시행 중 1개 이상을 충족한 경우 분자로 인정함. 단, 의료최고도 및 배뇨 관련 루 관리 대상 등은 제외함.'
 WHERE SECT_KEY = 'def_06';

-- 적용 후 확인 — JSP·시드와 글자까지 같아야 한다
SELECT '적용후' AS chk, SECT_KEY,
       CASE WHEN TPL_CONTENT LIKE '%분자 인정 =%'   THEN '★아직 옛문구'
            WHEN TPL_CONTENT LIKE '%단, 의료최고도%' THEN '새문구 OK'
            ELSE '기타' END AS 판정,
       TPL_CONTENT
  FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='def_06';

-- 혹시 남아 있을 병원별 저장본(있으면 그 병원은 이 수정이 안 먹는다)
SELECT '병원저장본' AS chk, COUNT(*) AS n FROM TBL_EVAL_REPORT_TEXT WHERE SECT_KEY='def_06';


-- ═══════════════════════════════════════════════════════════════════════════
-- 배뇨관리(dir_06) 개선방향 문구 정리 — 같은 요청 건(박혜련 2026-08-07 「개선 방향과 목표 중복」)
--
-- ★중복(구간·점수·필요인원)은 2026-08-10 코드 수정으로 이미 <점수 상향 목표> 줄로 옮겨졌다.
--   남은 것은 **문구 자체를 간결하게** 바꾸는 일이고, JSP 는 이미 새 문구인데
--   ***시드와 운영 DB 가 안 따라갔다*** — def_06 과 같은 함정.
--
-- ⚠종전 문구에 있던 "배뇨일지 7일 미만 작성 시 '아니오' 체크 후 실제 작성일수 기재" 는
--   요청 문구에 없어 **빠진다.** 실무 안내로 필요하면 되살릴 것.
-- ═══════════════════════════════════════════════════════════════════════════
SELECT '적용전' AS chk, SECT_KEY, TPL_CONTENT FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='dir_06';

UPDATE TBL_EVAL_REPORT_TPL
   SET TPL_CONTENT = '배뇨관리계획(일정하게 짜여진 배뇨계획·방광훈련프로그램) 체크 여부와 배뇨일지 작성 여부를 우선 점검하고, 배뇨일지의 실시일자·요실금 여부·배뇨횟수 또는 배뇨량을 의사·간호기록과 일치하도록 관리함.'
 WHERE SECT_KEY = 'dir_06';

SELECT '적용후' AS chk, SECT_KEY,
       CASE WHEN TPL_CONTENT LIKE '%7일 미만%' THEN '★아직 옛문구'
            WHEN TPL_CONTENT LIKE '%우선 점검하고%' THEN '새문구 OK'
            ELSE '기타' END AS 판정, TPL_CONTENT
  FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='dir_06';

-- ★★이 병원은 저장본이 있어 위 수정이 <안 먹는다> — 저장본이 우선이기 때문이다.
--   내용 자체는 구간·점수 없는 「관리내용만」이라 중복 문제는 없지만,
--   **요청한 간결 문구로 바꾸려면 이 행을 지워야** 새 TPL 이 나온다(지우면 자동 문구로 돌아간다).
SELECT '병원저장본_plan06' AS chk, m.HOSP_CD, m.EVAL_YM, LENGTH(t.CONTENT) AS 길이,
       CASE WHEN t.CONTENT LIKE '%mso-%' THEN '워드에서 붙여넣음(HTML 군더더기)' ELSE '-' END AS 비고
  FROM TBL_EVAL_REPORT_TEXT t JOIN TBL_EVAL_REPORT_MST m ON m.REPORT_SEQ=t.REPORT_SEQ
 WHERE t.SECT_KEY='plan_06';
-- 지우려면 (★사용자 확인 후) :
-- DELETE t FROM TBL_EVAL_REPORT_TEXT t JOIN TBL_EVAL_REPORT_MST m ON m.REPORT_SEQ=t.REPORT_SEQ
--  WHERE t.SECT_KEY='plan_06' AND m.HOSP_CD='31286003' AND m.EVAL_YM='202608';


-- ═══════════════════════════════════════════════════════════════════════════
-- 항정처방률(def_07) 지표정의 문구 정리 — 박혜련 요청 2026-08-07
--
-- 왜 : PI 가 무엇인지 설명이 없어 「처방 정도」로만 읽혔다.
--   ⇒ **상병 구성을 보정**한 지표라는 것과 **값이 낮을수록 우수**를 명시하고,
--     기관 자체 처방률 기준(10% 이하 / 40% 이상)을 참고로 덧붙였다.
--
-- ★같은 요청의 "개선 방향·목표 표기 빼주세요" 는 **이미 되어 있다** — 손댈 것 없음 :
--     · 목표      → evalReport.jsp 의 `NO_GOAL = {'07':1,...}` 로 막힘
--     · 개선 방향 → `noPlan = (cd==='07')` + JSP TPL_DIR 에 '07' 없음 + DB 에 dir_07 없음
--   ***되살리지 말 것.*** dir_07 을 넣으면 개선 방향 줄이 다시 나온다.
-- ═══════════════════════════════════════════════════════════════════════════
SELECT '적용전' AS chk, SECT_KEY, TPL_CONTENT FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='def_07';

UPDATE TBL_EVAL_REPORT_TPL
   SET TPL_CONTENT = '환자의 상병 구성을 보정하여 타 기관 대비 항정신성의약품 처방 수준을 평가하는 지표(PI)로, 값이 낮을수록 우수함(0.2 미만 = 5구간 / 1.6 이상 = 1구간). ※ 타 기관의 상병 구성 및 평균 처방률을 확인할 수 없어 WinCheck에서 산출된 PI값은 실제 평가결과와 차이가 있을 수 있으며 참고용으로 활용함. 기관 자체 처방률 기준으로는 10% 이하 시 5구간, 40% 이상 시 1구간 수준으로 참고하여 관리함.'
 WHERE SECT_KEY = 'def_07';

SELECT '적용후' AS chk, SECT_KEY,
       CASE WHEN TPL_CONTENT LIKE '%항정신성의약품 처방 정도%' THEN '★아직 옛문구'
            WHEN TPL_CONTENT LIKE '%상병 구성을 보정%'        THEN '새문구 OK'
            ELSE '기타' END AS 판정, TPL_CONTENT
  FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='def_07';

-- 개선 방향 줄이 다시 나오지 않는지 — dir_07 은 **0 건이어야 정상**
SELECT 'dir_07(0이어야정상)' AS chk, COUNT(*) AS n FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='dir_07';
SELECT '병원저장본_07' AS chk, SECT_KEY, COUNT(*) AS n
  FROM TBL_EVAL_REPORT_TEXT WHERE SECT_KEY IN ('def_07','plan_07','goal_07') GROUP BY SECT_KEY;


-- ═══════════════════════════════════════════════════════════════════════════
-- 욕창처치(def_09) 지표정의 문구 정리 — 박혜련 요청 2026-08-07
--
-- 왜 : ①「4가지 중 수행 시 해당」이 **틀린 설명**이었다 — 실제 인정 기준은 **4개 항목 모두 충족**이다.
--      ②1단계 욕창의 드레싱 예외(시행하지 않아도 실시로 간주)가 빠져 있었다.
--
-- ★같은 요청의 "지표 정의에 「현재 최고 구간으로 추가 개선 여지 없음(유지)」가 들어가면 안 된다" 는
--   **이미 해결됐다** — 2026-08-10 에 그 문장을 <점수 상향 목표> 줄로 옮겼다(evalReport.jsp 3887행).
--   TPL 어디에도 「개선 여지」 문구가 박혀 있지 않은 것도 확인했다(0 건).
--   ⇒ ***지표 정의에는 기관별 분석 결과(현재 점수·구간·개선 가능 여부)를 넣지 않는다*** — 이 원칙을 지킬 것.
--
-- ※요청서의 변경문구는 「단계 이상 욕창」으로 「1」이 빠져 있었다 — 오타로 보아 **「1단계 이상」**으로 넣는다.
-- ═══════════════════════════════════════════════════════════════════════════
SELECT '적용전' AS chk, SECT_KEY, TPL_CONTENT FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='def_09';

UPDATE TBL_EVAL_REPORT_TPL
   SET TPL_CONTENT = '1단계 이상 욕창을 보유한 환자 중 피부문제 처치를 적절히 실시한 환자의 비율. 압력을 줄이는 도구 사용, 체위변경, 욕창 해결을 위한 영양공급, 욕창부위 드레싱의 4개 항목을 모두 충족한 경우 처치 실시로 인정함. 단, 1단계 욕창은 드레싱을 시행하지 않아도 드레싱을 실시한 것으로 간주하여 평가함.'
 WHERE SECT_KEY = 'def_09';

SELECT '적용후' AS chk, SECT_KEY,
       CASE WHEN TPL_CONTENT LIKE '%4가지 중 수행%'      THEN '★아직 옛문구'
            WHEN TPL_CONTENT LIKE '%4개 항목을 모두 충족%' THEN '새문구 OK'
            ELSE '기타' END AS 판정, TPL_CONTENT
  FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY='def_09';

-- 「개선 여지」 문구가 TPL 에 새로 들어오지 않았는지 — **0 건이어야 정상**
SELECT '개선여지문구(0이어야정상)' AS chk, COUNT(*) AS n
  FROM TBL_EVAL_REPORT_TPL WHERE TPL_CONTENT LIKE '%개선 여지%' OR TPL_CONTENT LIKE '%개선여지%';
