# QPS 화면 가짜 DOM 시뮬 (jsdom)

QPS 화면의 **인라인 JS 를 소스 JSP 에서 그대로 꺼내** jsdom 에서 돌리는 검사다. 2026-09-02 델파이 대조의 날에
scratch 에서 쓰던 것을 저장소로 옮겼다(scratch 는 세션이 끝나면 사라진다). 브라우저를 열기 전에 **논리 회귀**를 잡는다.

```
cd docs/tools/sim
npm i                 # jsdom 하나 (node_modules 는 커밋 안 함)
node run_all.js       # 전부 — 2026-09-02 밤 기준 6벌 131검사 통과
node sim_qpsChk_ward.js   # 하나만
```

| 파일 | 무엇 | 검사 |
|---|---|---|
| `sim_qpsChk_tools.js` | 점검표 편의기능(더블클릭 토글·줄 토글·일괄 서명·Enter 복사·전체 O/지움·빈 행 흐리게·행 배타·공휴일·주차 채움) | 49 |
| `sim_qpsChk_sel.js` | 선택 칸(INPUT_GB=SEL) — cell/selOpts/collect/인쇄 변환/ckOxOk/nox | 22 |
| `sim_qpsChk_ward.js` | 병동 datalist · 문서 목록 병동 필터(ckDocFill) · 빈 병동 확인(ckSave) | 16 |
| `sim_qpsRptDef.js` | 보고서 체크 묶음 관리 — 카드 순서·공유 경고·저장 요청 본문·병원 계정 숨김 | 22 |
| `sim_qpsCode.js` | 공통코드(QPS) 관리 | 11 |
| `sim_menu_search.js` | 사이드바 메뉴 검색(감춘 줄 유지·Enter/Esc) | 11 |

## 방식 — 두 갈래

- **함수만 꺼내기**(sel · ward · tools) : 정규식으로 `function x(){…}` / `window.x = function(){…}` 블록을 잘라 `new Function(...)` 에 가짜 `document`·`gel`·`_confirmBox`·`post` 를 넣어 돌린다.
  ★실제 페이지에선 `window.x` 가 곧 전역이지만 Function 안에선 아니다 — **별칭**(`var ckDocFill = window.ckDocFill`)을 둔다. `Option` 같은 DOM 생성자도 넘겨야 한다.
- **페이지 통째로**(rptDef · code · menu) : JSP 태그를 지우고 `<c:url>` 을 글자로 바꾼 HTML 을 `runScripts:'dangerously'` 로 연다. jQuery 는 `beforeParse` 에서 가짜 `$`/`$.ajax` 를 심는다(파싱 중에 `$(function)` 이 돌기 때문 — 나중에 넣으면 「$ is not defined」).

## 함정

- 소스의 함수 **머리 모양이 바뀌면**(들여쓰기·인자) 정규식이 못 찾는다 — 「못 찾음: 이름」 오류가 나면 정규식부터 본다.
- 복제본(`cloneNode`)의 `select` 는 고른 상태를 못 믿는다(jsdom·브라우저 다름) — 인쇄 변환은 화면 원본에서 값을 읽는다(sel 검사가 이걸 잡았다).
- jsdom 은 `dblclick` 의 `detail`·포커스 이동을 완전히 흉내 내지 않는다 — 손짓 검사는 이벤트를 직접 만든다.
- 이 폴더는 Eclipse JS 검증에서 빠져 있다(`.settings/org.eclipse.wst.validation.prefs` — docs 전체 제외).
