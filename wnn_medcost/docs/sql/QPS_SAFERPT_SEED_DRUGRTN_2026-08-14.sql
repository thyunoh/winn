-- ═══════════════════════════════════════════════════════════════════════════
-- safeRpt 유형 추가 — 의약품 반납 신청서 (2026-08-14)
--   설계 : docs/proposals/QPS_safeRpt_반복행서명_설계_2026-08-14.md §3
--   채록 : docs/proposals/QPS_서식판독_간호병동_2026-08-13.md §373 (cap290)
--
-- ⛔⛔ ***아직 돌리지 말 것 — 확인 2건이 남아 있다.***
--
--   1. **[290] 「의약품 반납 신청서」(간호/병동) 와 약국 「병동의약품 반납신청서」가 같은 것인가.**
--      판독 §385 가 ***이름이 다르다***고 적어 두었고, **캡처로 본 것은 간호/병동 판뿐**이다.
--      · 같으면  → 이 파일 그대로(유형 하나, DRUGRTN)
--      · 다르면  → 유형을 둘로 가르고 SUB_COLS·SIGN_LINE 을 각각 맞춘다
--   2. **[274] 「병동의약품 신청서」**(반납이 아니라 신청)는 채록이 `신청 일자·병동` 뿐이라
--      정보가 모자란다. 이 파일에 넣지 않았다.
--
--   ⇒ 위 대조가 끝나면 이 머리말을 지우고 실행한다.
--
-- ⚠전제 : QPS_DDL_SAFERPT_ROWSIGN_2026-08-14.sql 를 먼저 돌려야 한다(표 2개).
-- ⚠기존 시드(QPS_DDL_SAFERPT_2026-08-11.sql)는 ***절대 다시 돌리지 말 것***.
--   재실행 안전(ON DUPLICATE KEY).
-- ═══════════════════════════════════════════════════════════════════════════

-- ── 1. 유형 ─────────────────────────────────────────────────────────────────
INSERT INTO TBL_CODE_DTL
 (CODE_GB, CODE_CD, SUB_CODE, JOB_SEQ, SUB_CODE_NM, START_DT, END_DT, USE_YN, SORT, ACTION_YN, REG_USER) VALUES
 ('Q','QPS_SAFERPT_GB','DRUGRTN',1,'의약품 반납 신청서','20000101','99991231','Y',10,'Y','system')
ON DUPLICATE KEY UPDATE SUB_CODE_NM=VALUES(SUB_CODE_NM), SORT=VALUES(SORT), USE_YN='Y', ACTION_YN='Y';

-- ── 2. 유형별 설정 — 반복행 표 · 서명란 · 정형문구 ──────────────────────────
--   원본 : `약 품 명`·`수량(용량)` 표 / `위와 같이 의약품 ( )을 보고합니다.` / 서명 3줄
--   ★글자는 원본 그대로 둔다(띄어쓰기 포함) — 인쇄물이 원본과 같아야 한다.
INSERT INTO TBL_QPS_SAFERPT_FORM (RPT_GB, SUB_NM, SUB_COLS, SIGN_LINE, FOOT_TXT, USE_YN, REG_USER) VALUES
 ('DRUGRTN', NULL, '약 품 명,수량(용량)', '보고자,부서장,약 사',
  '위와 같이 의약품 (        )을 보고합니다.', 'Y', 'system')
ON DUPLICATE KEY UPDATE SUB_NM=VALUES(SUB_NM), SUB_COLS=VALUES(SUB_COLS),
  SIGN_LINE=VALUES(SIGN_LINE), FOOT_TXT=VALUES(FOOT_TXT), USE_YN='Y';

-- ── 3. 체크 묶음 — 사유 ─────────────────────────────────────────────────────
--   원본 : ☐파손 ☐불량 ☐D/C ☐기타 ( )  — 하나만 고른다(MULTI_YN='N')
INSERT INTO TBL_QPS_SAFERPT_DEF (RPT_GB,GRP_CD,GRP_NM,ITEM_NM,MULTI_YN,ETC_YN,SORT,USE_YN) VALUES
 ('DRUGRTN','RTNRSN','사유','파손','N','N',1,'Y'),
 ('DRUGRTN','RTNRSN','사유','불량','N','N',2,'Y'),
 ('DRUGRTN','RTNRSN','사유','D/C' ,'N','N',3,'Y'),
 ('DRUGRTN','RTNRSN','사유','기타','N','Y',99,'Y')
ON DUPLICATE KEY UPDATE GRP_NM=VALUES(GRP_NM), MULTI_YN=VALUES(MULTI_YN),
  ETC_YN=VALUES(ETC_YN), SORT=VALUES(SORT), USE_YN='Y';

INSERT INTO TBL_QPS_SAFERPT_USE (RPT_GB,GRP_CD,SORT,USE_YN) VALUES
 ('DRUGRTN','RTNRSN',1,'Y')
ON DUPLICATE KEY UPDATE SORT=VALUES(SORT), USE_YN='Y';

-- ── 나머지 칸의 대응 (코드 변경 없음, 참고용) ───────────────────────────────
--   일자        → OCCUR_DT      반납시간 → OCCUR_TM      장소 → PLACE
--   반납경위    → SUMMARY  ★W_* 6칸이 아니다. 원본은 「육하원칙에 따라 기록」이라는
--                 *안내문구가 붙은 큰 칸 하나*지 육하원칙 6칸이 아니다.
--                 6칸으로 쪼개면 인쇄물이 원본과 달라진다.

-- ── 확인 ────────────────────────────────────────────────────────────────────
SELECT '유형'   AS chk, SUB_CODE_NM FROM TBL_CODE_DTL WHERE CODE_CD='QPS_SAFERPT_GB' AND SUB_CODE='DRUGRTN';
SELECT '설정'   AS chk, SUB_COLS, SIGN_LINE, FOOT_TXT FROM TBL_QPS_SAFERPT_FORM WHERE RPT_GB='DRUGRTN';
SELECT '항목'   AS chk, COUNT(*) AS n FROM TBL_QPS_SAFERPT_DEF WHERE RPT_GB='DRUGRTN';
SELECT '묶음사용' AS chk, COUNT(*) AS n FROM TBL_QPS_SAFERPT_USE WHERE RPT_GB='DRUGRTN';
