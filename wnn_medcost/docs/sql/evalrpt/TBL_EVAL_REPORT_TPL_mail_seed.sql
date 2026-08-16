/* ============================================================================
   월보고서 메일 발송 문구 — 표준문구 테이블에 등록                (2026-07-29)

   화면(evalReport.jsp)의 [✉ 메일발송] 창이 이 두 문구를 기본값으로 띄운다.
   담당자가 창에서 그때그때 고칠 수 있고, 상시 문구를 바꾸려면 이 행을 수정하면 된다.

   자리표시자(발송 창을 열 때 실제 값으로 치환됨)
     {hosp} 병원명 · {ym} 2026년 7월 · {total} 종합점수 · {grade} 현재등급
     {goalGrade} 목표등급 · {goalScore} 목표점수 · {gap} 부족점수 · {struct} 구조 · {care} 진료
   ============================================================================ */

INSERT INTO WNN.TBL_EVAL_REPORT_TPL (SECT_KEY, TPL_CONTENT, USE_YN, SORT_NO)
VALUES
('mail_subject', '[{hosp}] {ym} 적정성평가 월간 컨설팅 보고서', 'Y', 900),
('mail_body',
 CONCAT('안녕하십니까. {hosp} 담당자님.\n\n',
        '{ym} 적정성평가 월간 컨설팅 보고서를 보내드립니다.\n',
        '첨부된 PDF를 확인해 주시고, 문의사항은 회신 주시기 바랍니다.\n\n',
        '· 현재 종합점수 : {total}점 ({grade})\n',
        '· 목표 : {goalGrade} ({goalScore}점) · 부족점수 {gap}점\n\n',
        '감사합니다.\nWinCheck⁺ 드림'),
 'Y', 901)
ON DUPLICATE KEY UPDATE TPL_CONTENT = VALUES(TPL_CONTENT), USE_YN = 'Y';

/* 확인 */
-- SELECT SECT_KEY, USE_YN, SORT_NO, TPL_CONTENT FROM WNN.TBL_EVAL_REPORT_TPL WHERE SECT_KEY LIKE 'mail\_%';

/* ※ SECT_KEY 에 UNIQUE 가 없으면 ON DUPLICATE KEY 가 동작하지 않아 행이 중복될 수 있다.
      그 경우 아래로 먼저 지우고 INSERT 할 것.
   DELETE FROM WNN.TBL_EVAL_REPORT_TPL WHERE SECT_KEY IN ('mail_subject','mail_body');
*/
