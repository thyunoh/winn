/* =====================================================================================
 * 신규병원 가입에서 받을 동의를 **2종으로 고정**
 *   2026-08-19 / 선행 : TBL_JOIN_REQ_20260818.sql, AGREE_TEXT_SEED_20260819.sql
 *
 * [무엇을]
 *   가입신청 모달에서 받는 동의를 아래 둘로 줄인다.
 *     · REMOTE_DB  원격접속 및 DB접근에 관한 동의서   [서식2]  (필수)
 *     · PRIV_INFO  개인정보 수집 및 이용에 관한 동의서 [서식3]  (필수)
 *
 *   내리는 것 :
 *     · CONSULT_REQ 컨설팅 의뢰서 — **동의서가 아니라 신청서**다. 신청 자체가 곧 제출이라
 *                                  따로 "의뢰서에 동의합니다" 를 받을 이유가 없다.
 *     · PER_USE     이용약관       — 신규병원 가입 범위 밖(2026-08-19 결정)
 *     · PER_PRO     처리위탁       — 위와 같음
 *
 * [왜 코드가 아니라 데이터로 빼나]
 *   이 목록(selAgreeList)은 **화면이 그리는 근거이자 서버의 필수동의 검증 기준**이다.
 *   한쪽만 빼면 "화면에 없는 항목을 서버가 요구" 해서 신청이 통째로 막힌다.
 *   USE_YN 한 곳만 바꾸면 화면과 검증이 함께 움직인다. 매퍼에는 조건을 두지 않았다.
 *
 * [지우지 않는 이유]
 *   행은 남긴다. PER_USE/PER_PRO 는 LEGACY_COL 로 기존 TBL_MEMBER_MST 컬럼과 이어져 있고,
 *   CONSULT_REQ 는 본문(AGREE_TEXT)을 나중에 쓸 수 있다. 되살리려면 USE_YN='Y' 로 올리면 된다.
 *
 * [재실행 안전] 같은 값으로 다시 쓰는 UPDATE 라 여러 번 돌려도 무해하다.
 * ===================================================================================== */

UPDATE `TBL_AGREE_MST`
   SET `USE_YN`   = 'N',
       `UPD_DTTM` = NOW(),
       `UPD_USER` = 'SYSTEM'
 WHERE `AGREE_CD` IN ('CONSULT_REQ', 'PER_USE', 'PER_PRO');

UPDATE `TBL_AGREE_MST`
   SET `USE_YN`   = 'Y',
       `ESS_YN`   = 'Y',
       `UPD_DTTM` = NOW(),
       `UPD_USER` = 'SYSTEM'
 WHERE `AGREE_CD` IN ('REMOTE_DB', 'PRIV_INFO');

/* ── 확인 : USE_YN='Y' 가 REMOTE_DB · PRIV_INFO 두 건이어야 한다 ─────────────── */
SELECT `AGREE_CD`, `VER_NO`, `AGREE_NM`, `FORM_NO`, `ESS_YN`, `USE_YN`,
       CHAR_LENGTH(IFNULL(`AGREE_TEXT`,'')) AS TXT_LEN
  FROM `TBL_AGREE_MST`
 WHERE `ACTION_YN` = 'Y'
 ORDER BY `USE_YN` DESC, IFNULL(`SORT`,999);
