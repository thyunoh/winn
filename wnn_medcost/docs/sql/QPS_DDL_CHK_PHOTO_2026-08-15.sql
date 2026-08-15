-- =====================================================================
-- 점검표 엔진 사진칸 — DDL (2026-08-15)
--   왜 : 사진 장치가 safeRpt 쪽에만 있었다. 점검표 서식에도 사진이 원본 요소인 것이
--        둘 나왔다 — XR07 납가운 관리대장(증빙사진 2+보호구 3종) · 응급약품점검기록부
--        p2 봉인스티커 사진판(1~12월). 서식이 칸 이름을 정하면 그 수만큼 칸이 열린다.
--   설계 : safeRpt 사진(2026-08-14)과 같은 장치 —
--        · 서식 칸  : TBL_QPS_CHK_FORM.PHOTO_NMS(쉼표 이름 목록 = 칸 수·라벨. 비면 종전 그대로)
--        · 값 표    : TBL_QPS_CHK_FILE(문서×칸 순번 — 같은 칸 재업로드=교체)
--        · 파일 실체: sftp 파일서버 QPS/{병원}/CHK_PHOTO/{문서번호}/ (새 저장소 없음)
--   더하기만 하는 DDL ⇒ 운영 선적용 안전.
-- =====================================================================

ALTER TABLE TBL_QPS_CHK_FORM
  ADD COLUMN PHOTO_NMS VARCHAR(300) NULL DEFAULT NULL
      COMMENT '사진 칸 이름 목록(쉼표) — 이름 수 = 칸 수(최대 12). 비면 사진 없음' AFTER FOOT_TXT;

CREATE TABLE TBL_QPS_CHK_FILE (
  CHK_SEQ    BIGINT       NOT NULL COMMENT '점검표 문서 번호(TBL_QPS_CHK_DOC)',
  FILE_SEQ   INT          NOT NULL COMMENT '사진 칸 순번(1~12) — PHOTO_NMS 순서',
  FILE_PATH  VARCHAR(300) NOT NULL COMMENT '파일서버 경로',
  ORG_NM     VARCHAR(200) NULL     COMMENT '원본 파일명(표시용)',
  REG_USER   VARCHAR(50)  NULL,
  REG_DTTM   DATETIME     NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (CHK_SEQ, FILE_SEQ)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
  COMMENT='점검표 문서 사진첨부(칸 순번, 재업로드=교체)';
