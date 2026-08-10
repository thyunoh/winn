<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  적정성평가 Q&A — 우측하단 말풍선 (2026-08-05)
    · 이력 : 2026-07-29 플로팅 <채팅창>(qnaChat.jsp) → 2026-08-04 사이드바 메뉴 화면(qnacd.jsp)으로 교체
             → 2026-08-05 사용자 요청으로 <말풍선을 되살리되, 누르면 그 메뉴 화면이 뜨게> 정리.
             ★기존 채팅창(qnaChat.jsp 의 대화 UI·WQA_KB)은 쓰지 않는다(사용자 확정 "기존 채팅창은 무시").
               파일은 지우지 않고 남겨 두었으니 되살리려면 main.jsp 의 include 를 그것으로 바꾸면 된다.
    · 버튼 모양 : 종전 말풍선(#wqaFab) 서식 그대로 — 자리(우측하단 22px)·크기·색·그림자까지 같다.
    · 누르면 : /mangr/qnacd.do 로 <이 창에서> 이동한다 — 메뉴로 들어간 것과 같다(2026-08-05 확정 "메뉴 안으로").
               한동안 새 창(window.open + pop=1 껍데기 감춤)으로 열었었다 — 되돌리려면 git 이력 참고.
               qnacd.jsp 의 팝업 모드(qna-pop)는 남겨 두었다(pop=1 로 열면 여전히 동작).
    · 노출 : main.jsp 에서 위너넷(s_wnn_yn='Y')일 때만 include 한다 — 여기서 또 가리지 않는다.
    ★이 조각에는 taglib(JSTL)를 쓰지 않는다 (2026-08-05) —
      c:if 로 감추게 했더니 Eclipse 가 <이 파일만> 태그를 못 찾아 빨간 오류 표시를 냈다
      (실제 컴파일·동작은 정상이었지만 편집기에 계속 남는다). 감추는 일 하나뿐이라 아래 JS 두 줄로 옮겼다.
      바뀐 점 : Q&A 화면에도 버튼 HTML 은 내려가고 <보이지만 않는다>. 보안·성능에 영향 없다.
--%>
<!-- qnaFloat-build 2026-08-05h : noop on own screen -->
<style>
  #wqaFab{ position:fixed; right:22px; bottom:22px; z-index:12000; display:flex; align-items:center; gap:8px;
           height:50px; padding:0 18px 0 15px; border:none; border-radius:26px; cursor:pointer;
           background:linear-gradient(135deg,#1f6feb,#1746a2); color:#fff; font-size:15.5px; font-weight:700;
           font-family:"Noto Sans KR","Malgun Gothic","맑은 고딕","Apple SD Gothic Neo",sans-serif;
           box-shadow:0 6px 18px rgba(23,70,162,.34); transition:transform .15s ease, box-shadow .15s ease; }
  #wqaFab:hover{ transform:translateY(-2px); box-shadow:0 10px 24px rgba(23,70,162,.42); }
  #wqaFab .ic{ font-size:19px; }
  #wqaFab.wqa-hide{ display:none; }
</style>

<%-- 명칭 2026-08-10 변경: '적정성평가 Q&A' → 'WinCheck 실무 Q&A'
     적정성평가로 한정되지 않고 요양병원 자료·프로그램 사용까지 다루기 때문(사용자 요청). --%>
<button id="wqaFab" type="button" onclick="wqaGo()" title="WinCheck 실무 Q&amp;A 자료 열기">
  <span class="ic">💬</span><span>WinCheck 실무 Q&amp;A</span>
</button>

<script>
  /* 말풍선은 <어느 화면에서든 늘 떠 있다> (2026-08-05 확정 "어느 메뉴를 눌러도 살아있게") —
     Q&A 화면 자신에서 감추던 처리를 걷어냈다(거기서 누르면 같은 화면을 다시 열 뿐, 해는 없다). */

  function wqaGo(){
    /* ★이미 Q&A 화면이면 아무 일도 하지 않는다 (2026-08-05 확정 "자기 화면이면 실행 안되게") —
         같은 화면을 또 읽으면 보던 분류·답변이 초기화되어 버린다.
         판별은 주소가 아니라 <화면 안의 #qnaWrap> 으로 한다 — 이 앱은 주소를 dashboard.do 로 숨긴다. */
    if (document.getElementById('qnaWrap')) return;
    /* 새 창이 아니라 <이 창에서> 연다 — 메뉴에서 들어간 것과 똑같이 헤더·좌측메뉴가 있는 화면.
       (한동안 새 창(window.open + pop=1)으로 열었었다 — 되돌리려면 git 이력 참고) */
    location.href = '/mangr/qnacd.do';
  }
</script>
