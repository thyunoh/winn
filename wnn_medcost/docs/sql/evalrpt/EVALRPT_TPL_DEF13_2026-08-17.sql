/* ======================================================================
   월간보고서 지표정의 — 13 당뇨환자 HbA1c 적정범위율 문구 수정
   검수 : 박혜련 (2026-08-13 수정사항)

     이전 : 당뇨병 상병 환자 중 HbA1c 검사결과가 적정범위(…)에 해당하는 …
     이후 : 당뇨 환자   중 HbA1c 검사결과가 적정범위(…)에 해당하는 …

   ⚠지표 정의는 **JSP(evalReport.jsp TPL_DEF)와 이 표를 함께** 고쳐야 한다.
     화면은 TBL_EVAL_REPORT_TPL 이 JSP 기본값을 덮으므로, JSP 만 고치면 안 바뀐다
     (2026-07-23 def_06 · 2026-08-11 def_01~15 때 같은 함정을 두 번 겪었다).

   ★def_13 은 병원별 저장본(TBL_EVAL_REPORT_TEXT)이 **없음을 확인**했으므로
     이 한 줄로 전 병원·전 월에 반영된다(승인본 포함 — 지표 정의는 편집영역이 아니다).

   ★분모 라벨('당뇨병 상병 환자')과 개선방향(dir_13)은 **요청 범위가 아니라 그대로 둔다.**
   ====================================================================== */

UPDATE TBL_EVAL_REPORT_TPL
   SET TPL_CONTENT = REPLACE(TPL_CONTENT, '당뇨병 상병 환자 중', '당뇨 환자 중'),
       UPD_USER    = 'fix20260817'
 WHERE SECT_KEY    = 'def_13'
   AND TPL_CONTENT LIKE '당뇨병 상병 환자 중%';

/* 확인 */
SELECT SECT_KEY, TPL_CONTENT FROM TBL_EVAL_REPORT_TPL WHERE SECT_KEY = 'def_13';
