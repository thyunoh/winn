-- 배뇨일지 답변(ask-pat-udiary-content)에서 문장 삭제 (2026-08-05 사용자 요청, 화면 표시분)
--   삭제: "확인란에 'V' 표시만 하면 … 기록 보완 요구가 나옵니다. 실금이 있으면 실금량(mL)까지 … 원칙입니다."
UPDATE TBL_QNA_KB
   SET BODY = REPLACE(BODY, '확인란에 <b>''V'' 표시만 하면 배뇨횟수·배뇨량을 확인할 수 없어 기록 보완 요구</b>가 나옵니다. 실금이 있으면 실금량(mL)까지 확인되도록 작성하는 것이 원칙입니다.\n', '')
 WHERE KB_CODE = 'ask-pat-udiary-content';

-- 확인: 0이어야 정상(문장이 남아 있지 않음)
SELECT COUNT(*) FROM TBL_QNA_KB WHERE KB_CODE='ask-pat-udiary-content' AND BODY LIKE '%기록 보완 요구%';
