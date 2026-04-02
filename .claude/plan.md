# 요양병원 인증 프로그램 (wnn_cert) 개발 계획

## 개요
- **프로젝트명**: wnn_cert (요양병원 인증관리 시스템)
- **기반**: wnn_medcost 프로젝트 구조 복제
- **기술스택**: eGovFrame 4.1.0 + Spring 5.3.20 + MyBatis + MySQL + Tiles 3 + JSP
- **위치**: `C:/Users/user/git/winn/wnn_cert/`

---

## 1. DB 테이블 설계 (MySQL)

### 1-1. 인증기준 마스터 (TBL_CERT_DOMAIN) - 영역
| 컬럼 | 타입 | 설명 |
|------|------|------|
| DOMAIN_CD | VARCHAR(10) PK | 영역코드 (D01~D04) |
| DOMAIN_NM | VARCHAR(100) | 영역명 |
| SORT_ORD | INT | 정렬순서 |
| USE_YN | CHAR(1) | 사용여부 |

### 1-2. 인증기준 장 (TBL_CERT_CHAPTER) - 장
| 컬럼 | 타입 | 설명 |
|------|------|------|
| CHAPTER_CD | VARCHAR(10) PK | 장코드 (C01~C12) |
| DOMAIN_CD | VARCHAR(10) FK | 영역코드 |
| CHAPTER_NM | VARCHAR(200) | 장명 |
| SORT_ORD | INT | 정렬순서 |
| USE_YN | CHAR(1) | 사용여부 |

### 1-3. 인증기준 기준 (TBL_CERT_STANDARD) - 기준(60개)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| STANDARD_CD | VARCHAR(20) PK | 기준코드 |
| CHAPTER_CD | VARCHAR(10) FK | 장코드 |
| STANDARD_NM | VARCHAR(500) | 기준명 |
| STANDARD_DESC | TEXT | 기준설명 |
| EVAL_METHOD | VARCHAR(50) | 평가방법(서류/면담/현장) |
| SORT_ORD | INT | 정렬순서 |
| USE_YN | CHAR(1) | 사용여부 |

### 1-4. 조사항목 (TBL_CERT_ITEM) - 조사항목(303개)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| ITEM_CD | VARCHAR(20) PK | 항목코드 |
| STANDARD_CD | VARCHAR(20) FK | 기준코드 |
| ITEM_NM | VARCHAR(500) | 항목명 |
| ITEM_DESC | TEXT | 항목설명 |
| EVAL_TYPE | VARCHAR(20) | 평가유형(상/중/하, Y/N) |
| WEIGHT | DECIMAL(5,2) | 가중치 |
| SORT_ORD | INT | 정렬순서 |
| USE_YN | CHAR(1) | 사용여부 |

### 1-5. 인증평가 (TBL_CERT_EVAL) - 평가 마스터
| 컬럼 | 타입 | 설명 |
|------|------|------|
| EVAL_ID | BIGINT PK AUTO_INCREMENT | 평가ID |
| HOSP_CD | VARCHAR(20) | 병원코드 |
| EVAL_YEAR | VARCHAR(4) | 평가년도 |
| EVAL_CYCLE | VARCHAR(10) | 평가주기(4주기) |
| EVAL_STATUS | VARCHAR(20) | 상태(준비/진행/완료) |
| EVAL_RESULT | VARCHAR(20) | 결과(인증/조건부/불인증) |
| EVAL_START_DT | DATE | 평가시작일 |
| EVAL_END_DT | DATE | 평가종료일 |
| TOTAL_SCORE | DECIMAL(5,2) | 총점 |
| REG_DTTM | DATETIME | 등록일시 |
| REG_USER | VARCHAR(50) | 등록자 |
| UPD_DTTM | DATETIME | 수정일시 |
| UPD_USER | VARCHAR(50) | 수정자 |

### 1-6. 인증평가 상세 (TBL_CERT_EVAL_DTL) - 항목별 평가결과
| 컬럼 | 타입 | 설명 |
|------|------|------|
| EVAL_DTL_ID | BIGINT PK AUTO_INCREMENT | 평가상세ID |
| EVAL_ID | BIGINT FK | 평가ID |
| ITEM_CD | VARCHAR(20) FK | 항목코드 |
| SCORE | DECIMAL(5,2) | 점수 |
| EVAL_GRADE | VARCHAR(10) | 등급(상/중/하) |
| EVIDENCE | TEXT | 근거자료 |
| REMARK | TEXT | 비고 |
| EVAL_USER | VARCHAR(50) | 평가자 |
| EVAL_DTTM | DATETIME | 평가일시 |

### 1-7. 개선활동 (TBL_CERT_IMPROVE) - QPS 개선활동
| 컬럼 | 타입 | 설명 |
|------|------|------|
| IMPROVE_ID | BIGINT PK AUTO_INCREMENT | 개선ID |
| EVAL_DTL_ID | BIGINT FK | 평가상세ID |
| IMPROVE_TITLE | VARCHAR(500) | 개선제목 |
| IMPROVE_DESC | TEXT | 개선내용 |
| IMPROVE_STATUS | VARCHAR(20) | 상태(계획/진행/완료) |
| DUE_DATE | DATE | 목표완료일 |
| COMPLETE_DATE | DATE | 실제완료일 |
| MANAGER | VARCHAR(50) | 담당자 |
| REG_DTTM | DATETIME | 등록일시 |
| REG_USER | VARCHAR(50) | 등록자 |

### 1-8. 사용자 (TBL_CERT_USER)
| 컬럼 | 타입 | 설명 |
|------|------|------|
| USER_ID | VARCHAR(50) PK | 사용자ID |
| USER_NM | VARCHAR(100) | 이름 |
| USER_PW | VARCHAR(200) | 비밀번호 |
| DEPT_NM | VARCHAR(100) | 부서 |
| ROLE_CD | VARCHAR(20) | 역할(ADMIN/EVAL/USER) |
| USE_YN | CHAR(1) | 사용여부 |
| REG_DTTM | DATETIME | 등록일시 |

---

## 2. 프로젝트 구조

```
wnn_cert/
├── pom.xml
├── src/main/java/egovframework/wnn_cert/
│   ├── login/          (로그인)
│   │   ├── web/LoginController.java
│   │   ├── service/LoginService.java
│   │   ├── service/impl/LoginServiceImpl.java
│   │   ├── mapper/LoginMapper.java
│   │   └── model/UserDTO.java
│   ├── cert/           (인증기준관리)
│   │   ├── web/CertController.java
│   │   ├── service/CertService.java
│   │   ├── service/impl/CertServiceImpl.java
│   │   ├── mapper/CertMapper.java
│   │   └── model/DomainDTO.java, ChapterDTO.java, StandardDTO.java, ItemDTO.java
│   ├── eval/           (평가관리)
│   │   ├── web/EvalController.java
│   │   ├── service/EvalService.java
│   │   ├── service/impl/EvalServiceImpl.java
│   │   ├── mapper/EvalMapper.java
│   │   └── model/EvalDTO.java, EvalDtlDTO.java
│   ├── improve/        (개선활동/QPS)
│   │   ├── web/ImproveController.java
│   │   ├── service/ImproveService.java
│   │   ├── service/impl/ImproveServiceImpl.java
│   │   ├── mapper/ImproveMapper.java
│   │   └── model/ImproveDTO.java
│   ├── dashboard/      (대시보드)
│   │   ├── web/DashboardController.java
│   │   ├── service/DashboardService.java
│   │   ├── service/impl/DashboardServiceImpl.java
│   │   └── mapper/DashboardMapper.java
│   └── util/           (공통유틸)
├── src/main/resources/
│   ├── egovframework/
│   │   ├── spring/context-*.xml
│   │   └── sqlmap/
│   │       ├── config/sql-mapper-config.xml
│   │       └── mapper/
│   │           ├── Login_SQL.xml
│   │           ├── Cert_SQL.xml
│   │           ├── Eval_SQL.xml
│   │           ├── Improve_SQL.xml
│   │           └── Dashboard_SQL.xml
│   └── application.properties
└── src/main/webapp/
    └── WEB-INF/
        ├── web.xml
        ├── config/egovframework/
        │   ├── springmvc/dispatcher-servlet.xml
        │   └── tiles/tiles-define.xml
        ├── tiles/ (레이아웃 템플릿)
        └── jsp/
            ├── login/ (로그인 화면)
            └── main/
                ├── cert/ (인증기준 화면)
                ├── eval/ (평가 화면)
                ├── improve/ (개선활동 화면)
                └── dashboard/ (대시보드 화면)
```

---

## 3. 주요 화면

### 3-1. 대시보드
- 인증 진행현황 (영역별 달성률 차트)
- 개선활동 현황
- 최근 평가 내역

### 3-2. 인증기준관리
- 영역/장/기준/조사항목 트리 구조 조회
- 4주기 인증기준 등록/수정/삭제
- 엑셀 일괄등록

### 3-3. 자체평가
- 조사항목별 점수 입력
- 근거자료 등록
- 영역별/장별 점수 집계
- 평가결과 판정 (인증/조건부/불인증)

### 3-4. QPS 개선활동
- 미충족 항목 자동 추출
- 개선계획 등록
- 진행상황 관리
- 완료 확인

### 3-5. 통계/리포트
- 영역별 점수 분석
- 주기별 비교
- 인증결과 리포트 출력

---

## 4. 개발 순서

1. **프로젝트 생성**: wnn_medcost 복제 → wnn_cert로 변환
2. **DB 테이블 생성**: MySQL DDL 실행
3. **인증기준 초기데이터**: 4주기 기준 INSERT
4. **로그인 모듈**: 인증/권한 처리
5. **인증기준관리**: CRUD + 트리조회
6. **자체평가**: 점수입력 + 집계
7. **QPS 개선활동**: 개선계획 관리
8. **대시보드**: 차트 + 현황
9. **통계/리포트**: 분석 + 출력
