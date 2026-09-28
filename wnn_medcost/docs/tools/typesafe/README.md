# TypeSafe(Jev) 검사 도구 — Q&A 검색 재순위 · 보고서 유형 추천 · 불만고충 분류 (2026-09-28)

`egovframework/util/TypeSafeUtil.java` 와 `MangrServiceImpl.rerankByTypeSafe` 를 검사하는 자바 여섯 벌.
JDK 11 단일 파일 컴파일로 돈다(메이븐 불필요). 클래스패스는 이클립스 배포본(tmp1)의 `WEB-INF/lib` + `WEB-INF/classes`.

```powershell
$LIB='D:\egv\.metadata\.plugins\org.eclipse.wst.server.core\tmp1\wtpwebapps\wnn_medcost\WEB-INF\lib'
$CLS='D:\egv\.metadata\.plugins\org.eclipse.wst.server.core\tmp1\wtpwebapps\wnn_medcost\WEB-INF\classes'
mkdir out
javac -encoding UTF-8 -nowarn -d out -cp "$LIB\*;$CLS" TsMock.java TsLive.java TsLiveDb.java TsLiveSuggest.java TsLiveCmpl.java TsSsl.java
```

| 도구 | 키 | 무엇을 보나 | 2026-09-28 결과 |
|---|---|---|---|
| **TsMock** | 없어야 함 | 가짜 서버로 코드 흐름 14항목 — 재순위(요청 모양·순서 바뀜·답 없는 후보 뒤·excerpt 제거·질문 마스킹·500/answers 없음/연결 불가 폴백) + **choice**(요청 모양·마스킹·확률 정렬·빈 선택지) | PASS 14 / FAIL 0 |
| **TsLive** | 필요 | 합성 후보 6건 × 질문 5개 — 순위가 맞나, 자료 없는 질문은 납작한가, 응답 시간 | 5/5 정답 1등 · 첫 2.3초·이후 0.23초 · 없는 질문 전부 0.01 |
| **TsLiveDb** | 필요 + DB | 운영 `TBL_QNA_KB` 를 **SELECT 만** 해 `selectQnaSearch` 와 같은 SQL 로 후보 30건을 뽑고 진짜 재순위 함수(리플렉션)를 태움. 질문 로그의 실제 질문도 8개 섞음. A/B 판정 규칙 나란히 계산 | 15/15 호출 성공 · 찾은 질문 1등 0.68~0.98 · 없는 질문 0.02~0.09 |
| **TsLiveSuggest** | 필요 + DB | **보고서 유형 추천**(적용 2호) — 운영 `QPS_SAFERPT_GB` 78종을 SELECT 해 매퍼를 Proxy 로 흉내 내고 진짜 `QpsServiceImpl.suggestRptGb` 를 태움. 자유 글 10문장 → 상위 3·NONE·confidence | 낙상 1.00 · 교육 0.92 · 감염 0.93 · 개인정보 0.94 · 잡담 NONE 0.99 |
| **TsLiveCmpl** | 필요 + DB | **불만고충 분류 추천**(적용 3호) — `QPS_CMPL_TYPE`·`QPS_CMPL_PERSON` 을 SELECT 해 진짜 `suggestCmpl`(Choice 2문 한 요청)을 태움. 불만 글 10줄 → 유형·민원인 구분·NONE | 유형 10/10 기대대로 · 인사 전화 NONE 0.92 · 민원인은 드러날 때만 |
| **TsSsl** | 필요 | TLS 결함 재현 — A 기본 · B `Connection: close` · C `https.protocols` · D `jdk.tls.client.protocols` · E TLS1.2+close 로 8연속 호출 | A 8/8(재사용) · **B 1/8** · C·D·E 8/8 |

```powershell
java -cp "out;$LIB\*;$CLS" TsMock                       # 환경변수 TYPESAFE_API_KEY 를 비우고
$env:TYPESAFE_API_KEY='...'; java -cp "out;$LIB\*;$CLS" TsLive
java "-Dfile.encoding=UTF-8" -cp "out;$LIB\*;$CLS" TsLiveDb <db사용자> <db비밀번호>
java "-Dfile.encoding=UTF-8" -cp "out;$LIB\*;$CLS" TsLiveSuggest <db사용자> <db비밀번호>
java "-Dfile.encoding=UTF-8" -cp "out;$LIB\*;$CLS" TsLiveCmpl <db사용자> <db비밀번호>
java -cp "out;$LIB\*;$CLS" TsSsl E
```

## 실측으로 정한 것
- **weak(못 찾음) 판정은 두 단계** : top ≥ 0.5 찾음 · top < 0.12 못 찾음 · 사이는 top ≥ 2.5×2등 일 때만 찾음.
  운영 후보로는 한 문턱으로도 갈리지만, 본문이 얇은 항목은 정답이라도 0.2~0.3 에 머물면서 2등과는 3배 이상 벌어졌다(TsLive).
- **TLSv1.2 고정** : 이 PC JDK 11+28 은 TLS 1.3 두 번째 새 접속에서 `handshake_failure`/`record_overflow`. TypeSafeUtil 이 자기 접속만 1.2 로 맺는다(TYPESAFE_TLS).
- 재순위는 **SQL 후보 밖을 못 고른다** — 「소변줄」처럼 KB 낱말과 안 겹치는 현장 용어는 정답이 후보에 없어 weak 로 간다(→ Gemini 참고답변 + 용어 변환 길, 종전과 같음).

## 함정
- git-bash 에서 javac 클래스패스는 **Windows 경로 + `;`** 로 준다(/d/… 로 주면 인터페이스를 못 찾아 `@Override` 100개 오류).
- 검사 자바가 예외로 죽어도 HttpServer 스레드가 살아 **프로세스가 안 끝난다** — main 을 try/catch 로 감싸 `System.exit`.
- 출력을 `| tail` 로 받으면 끝날 때까지 아무것도 안 보인다 — 파일로 받아 볼 것.
- TsMock 은 환경변수에 진짜 키가 있으면 「키 없음」 시나리오가 깨져 4건 FAIL 로 보인다 — 코드 결함이 아니다.
- 콘솔의 키 목록은 앞뒤만 보인다(`apikey_2252...46d9`). 전체 키는 **만들 때 한 번만** 복사할 수 있다. 403 authentication_error 면 키가 Inactive 인지 먼저 본다.
