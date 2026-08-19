/* =====================================================================================
 * 이용약관·개인정보 처리위탁 본문을 TBL_AGREE_MST 로 옮긴다
 *   2026-08-19 / 선행 : AGREE_TEXT_SEED_20260819.sql (서식1·2·3 본문)
 *
 * [왜]
 *   가입신청 모달의 '기타 약관'(이용약관·처리위탁)이 **체크박스만 있고 내용이 없다.**
 *   병원이 이용약관을 못 본 채 필수 동의를 눌러야 하는 상태다.
 *
 *   그런데 이 두 약관의 본문은 이미 있다 — 기존 회원가입 모달이 쓰는
 *   **공통코드 TBL_CODE_DTL**(CODE_GB='Z', CODE_CD='PER_USE_CD'/'PER_PRO_CD') 의
 *   SUB_CODE_NM 이 그것이다. (LoginWinCT.jsp 의 openModal() 이 여러 행을 이어 붙여 보여준다)
 *   그래서 새로 쓰지 않고 **그대로 옮겨** 온다.
 *
 * [★ 옮긴 뒤에는 두 곳에 같은 글이 있게 된다]
 *   동의 증빙은 "그때 그 문구" 를 붙들고 있어야 해서 TBL_AGREE_MST 가 버전(VER_NO)을 갖는다.
 *   그래서 참조가 아니라 복사가 맞다. 다만 **공통코드에서 약관을 고치면 화면은 안 바뀐다.**
 *   약관을 고쳤으면 → VER_NO 를 올려 새 행을 넣고 이 스크립트를 그 VER_NO 로 다시 돌린다.
 *   (기존 동의건은 옛 VER_NO 를 가리키므로 그대로 남는다)
 *
 * [주의]
 *   · GROUP_CONCAT 는 기본 1024자에서 잘린다. 이용약관은 그보다 훨씬 길다 →
 *     아래 SET SESSION 을 **같은 세션에서 함께** 실행해야 한다. 따로 돌리면 잘린 채 들어간다.
 *   · 이미 이 문구로 동의받은 신청건이 있으면 UPDATE 하지 말 것(위 [★] 참고).
 *     확인 : SELECT COUNT(*) FROM TBL_JOIN_AGREE WHERE AGREE_CD IN ('PER_USE','PER_PRO');
 * ===================================================================================== */

SET SESSION group_concat_max_len = 1000000;

/* ── 이용약관 ─────────────────────────────────────────────────────────────────── */
UPDATE `TBL_AGREE_MST` A
   SET A.`AGREE_TEXT` = (
         SELECT GROUP_CONCAT(D.`SUB_CODE_NM`
                             ORDER BY IFNULL(D.`SORT`,999), D.`SUB_CODE`
                             SEPARATOR '\n')
           FROM `TBL_CODE_DTL` D
          WHERE D.`CODE_GB`   = 'Z'
            AND D.`CODE_CD`   = 'PER_USE_CD'
            AND IFNULL(D.`ACTION_YN`,'Y') = 'Y'
       ),
       A.`UPD_DTTM` = NOW(),
       A.`UPD_USER` = 'SYSTEM'
 WHERE A.`AGREE_CD` = 'PER_USE' AND A.`VER_NO` = 1;

/* ── 개인정보 처리위탁 ────────────────────────────────────────────────────────── */
UPDATE `TBL_AGREE_MST` A
   SET A.`AGREE_TEXT` = (
         SELECT GROUP_CONCAT(D.`SUB_CODE_NM`
                             ORDER BY IFNULL(D.`SORT`,999), D.`SUB_CODE`
                             SEPARATOR '\n')
           FROM `TBL_CODE_DTL` D
          WHERE D.`CODE_GB`   = 'Z'
            AND D.`CODE_CD`   = 'PER_PRO_CD'
            AND IFNULL(D.`ACTION_YN`,'Y') = 'Y'
       ),
       A.`UPD_DTTM` = NOW(),
       A.`UPD_USER` = 'SYSTEM'
 WHERE A.`AGREE_CD` = 'PER_PRO' AND A.`VER_NO` = 1;

/* ── 확인 : 5건 모두 TXT_LEN 이 0 이 아니어야 한다 ────────────────────────────── */
SELECT `AGREE_CD`, `VER_NO`, `AGREE_NM`, `FORM_NO`, `ESS_YN`,
       CHAR_LENGTH(IFNULL(`AGREE_TEXT`,'')) AS TXT_LEN
  FROM `TBL_AGREE_MST`
 WHERE `ACTION_YN` = 'Y'
 ORDER BY IFNULL(`SORT`,999);
