# TypeSafe(Jev) 검사 도구 — Q&A 검색 재순위 (2026-09-28)

`egovframework/util/TypeSafeUtil.java` 와 `MangrServiceImpl.rerankByTypeSafe` 를 검사하는 자바 두 벌.
JDK 11 단일 파일 컴파일로 돈다(메이븐 불필요). 클래스패스는 이클립스 배포본(tmp1)의 `WEB-INF/lib` + `WEB-INF/classes`.

```bash
LIB='D:\egv\.metadata\.plugins\org.eclipse.wst.server.core\tmp1\wtpwebapps\wnn_medcost\WEB-INF\lib'
CLS='D:\egv\.metadata\.plugins\org.eclipse.wst.server.core\tmp1\wtpwebapps\wnn_medcost\WEB-INF\classes'
mkdir -p out
javac -encoding UTF-8 -nowarn -d out -cp "$LIB\*;$CLS" TsMock.java TsLive.java
```

## TsMock — 키 없이, 가짜 서버로 (11항목)
```bash
java -cp "out;$LIB\*;$CLS" TsMock
```
요청 모양(state.question · candidates[] · questions.cN noul/criteria) · 응답 noul 로 순서 바뀜 · 답 없는 후보는 뒤 ·
후보 밖 항목은 원래 순서 · excerpt 제거 · 질문 마스킹([환자]) · HTTP 500/answers 없음/연결 불가 → null 폴백. `PASS 11 / FAIL 0` 이어야 한다.

## TsLive — 실제 API 로 한국어 판정 품질
```bash
TYPESAFE_API_KEY=... java -cp "out;$LIB\*;$CLS" TsLive
```
후보 6건(실제 KB 제목 흉내) × 질문 5개. 기대 = 「소변줄」→유치도뇨관 · 「기저귀 배뇨훈련」→배뇨일지 · 「6개월 넘게 입원」→장기입원 ·
「직원 식당 메뉴」→전부 낮음(자료 없음, 최고값이 0.5 아래여야 weak 판정이 맞다) · 「청구 파일 느려요」→업로드. 응답 시간(ms)도 찍힌다 —
검색 화면에서 기다리는 자리라 8초(TYPESAFE_QNA_TIMEOUT_MS) 안에 와야 한다.

## 함정
- git-bash 에서 javac 클래스패스는 **Windows 경로 + `;`** 로 준다(/d/… 로 주면 인터페이스를 못 찾아 `@Override` 100개 오류).
- 검사 자바가 예외로 죽어도 HttpServer 스레드가 살아 **프로세스가 안 끝난다** — main 을 try/catch 로 감싸 `System.exit`.
- 출력을 `| tail` 로 받으면 끝날 때까지 아무것도 안 보인다 — 파일로 받아 볼 것.
