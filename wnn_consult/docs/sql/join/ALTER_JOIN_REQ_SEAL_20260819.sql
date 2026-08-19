/* =====================================================================================
 * 가입신청에 **대표자 직인** 담기
 *   2026-08-19 / 선행 : TBL_JOIN_REQ_20260818.sql
 *
 * [무엇을]
 *   신청 화면에서 대표자 직인 이미지를 파일로 불러와 동의서 「(인)」 자리에 얹는다.
 *   그 이미지를 신청 1건에 하나 보관한다.
 *
 * [왜 TBL_JOIN_SEAL 이 아니라 컬럼인가]
 *   보류해 둔 TBL_JOIN_SIGN_20260819.sql 은 **동의서마다 다른 인영을 찍는** 경우까지
 *   다루느라 표가 3개다. 지금 필요한 건 「신청 1건 = 대표자 직인 1개」 뿐이라
 *   컬럼 4개로 끝낸다. 나중에 동의서별로 갈라야 하면 그때 그 스크립트를 올리고 옮기면 된다.
 *
 * [크기]
 *   화면에서 가로 400px 이하로 줄여 보내므로 보통 30~80KB. mediumblob 이면 충분하다.
 *
 * [★ 도장 이미지를 서버가 갖는다는 뜻]
 *   한 번 받아두면 시스템이 언제든 아무 문서에나 찍을 수 있다.
 *   · 병원이 화면에서 직접 올린 건만 저장한다(서버가 임의로 만들지 않는다).
 *   · SEAL_HASH 로 나중에 바꿔치기를 대조할 수 있게 한다.
 *   · 조회는 위너넷 담당자로 한정할 것 — 승인 화면 만들 때 함께 잡는다.
 *
 * [재실행 안전]
 *   ★MySQL 8 은 ADD COLUMN IF NOT EXISTS 를 지원하지 않는다. **한 번만** 돌린다.
 *     두 번째는 "Duplicate column name" 이 나며, 그 에러가 곧 이미 적용됐다는 뜻이다.
 * ===================================================================================== */

ALTER TABLE `TBL_JOIN_REQ`
  ADD COLUMN `SEAL_IMG`  mediumblob   COMMENT '대표자 직인 이미지(PNG/JPEG)'        AFTER `BIGO`,
  ADD COLUMN `SEAL_MIME` varchar(50)  COMMENT '직인 이미지 MIME'                    AFTER `SEAL_IMG`,
  ADD COLUMN `SEAL_NM`   varchar(200) COMMENT '업로드 원본 파일명'                   AFTER `SEAL_MIME`,
  ADD COLUMN `SEAL_HASH` varchar(64)  COMMENT '직인 이미지 SHA-256(hex) - 대조용'    AFTER `SEAL_NM`;

/* ── 확인 : 네 칸이 보이면 적용된 것 ─────────────────────────────────────────── */
SELECT COLUMN_NAME, COLUMN_TYPE, COLUMN_COMMENT
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE TABLE_SCHEMA = DATABASE()
   AND TABLE_NAME   = 'TBL_JOIN_REQ'
   AND COLUMN_NAME IN ('SEAL_IMG','SEAL_MIME','SEAL_NM','SEAL_HASH')
 ORDER BY ORDINAL_POSITION;
