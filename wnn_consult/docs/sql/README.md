# wnn_consult/docs/sql

위너넷(컨설팅) 쪽 DB 스크립트. 주제별 폴더에 넣고, 파일명은 `주제_무엇_날짜.sql`.

| 폴더 | 무엇 |
|---|---|
| [join/](join/) | 신규병원 회원가입(가입신청 → 승인 → 계약) |

## 규칙

- 머리말에 **무엇을·왜·재실행 안전 여부**를 적는다. 반년 뒤 그 파일을 여는 사람은 나다.
- **운영 DB 를 본다.** 로컬 profile 도 운영 DB 라 테스트 INSERT 가 운영에 들어간다. 실행 전에 대상 확인.
- DDL 은 `IF NOT EXISTS`, 시드는 `INSERT IGNORE` / `ON DUPLICATE KEY UPDATE` 로 재실행 안전하게 쓴다.

## join/ — 신규병원 가입

[TBL_JOIN_REQ_20260818.sql](join/TBL_JOIN_REQ_20260818.sql) — 아직 **운영 미적용**.

기존 회원가입은 `TBL_HOSP_MST` 에 등록된 병원만 가능해서 신규병원은 순서가 거꾸로였다.
신청서(의뢰서 [서식1]) + 동의 3종을 받아 두고, 위너넷이 승인할 때
**`TBL_HOSP_MST` 를 새로 만들고 `TBL_USER_MST` 를 연계**한다. 계약(`TBL_HOSPCONT_MST`)은 승인 뒤 기존 화면에서 건다.

만드는 표 : `TBL_AGREE_MST`(동의서·버전) · `TBL_JOIN_REQ`(신청) · `TBL_JOIN_MGR`(담당자) ·
`TBL_JOIN_AGREE`(동의내역) · `TBL_JOIN_HIS`(처리이력).
기존 표는 **ALTER 하지 않는다** — 연계키는 `TBL_JOIN_REQ.CFM_*` 가 들고 있다.
