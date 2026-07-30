<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- evalCompare.jsp — 적정성평가 '전체 비교' 화면 (2026-07-28 요청). 위너넷 전용.
     진입 = assessment.jsp 지표표 머리글 맨 오른쪽 칸의 [비교] 버튼.

     ★왜 별도 화면인가 — 적정성평가 화면에 붙이면 조회할 때마다 전체 집계가 같이 돈다.
       가끔 보는 자료라 버튼으로 열게 했다. 안 누르면 쿼리도 안 돈다(2026-07-28 사용자 확정).

     ★대상 = 조회기간 자료가 있고 + 그 기간 환자평가표가 있는 병원 − 제외 기관기호(테스트).
       평균은 병원별 값의 단순평균이고, 값이 0 인 병원도 포함한다.
       (근거는 Magam_SQL.xml 의 select_EvalCmpAvg 주석에 수치와 함께 남겨 뒀다)

     ★[2026-07-30] 평가년월 → **평가년도 + 기간(시작월~종료월)**. 년도는 그대로 두고 월만 두 칸이다.
       · 시작월 = 종료월 → 예전 한 달 조회와 값이 완전히 같다(202607 로 18개 지표 전부 대조 확인).
       · 여러 달 → **월평균**(한 달씩 값을 구해 달수로 나눔, 2026-07-30 사용자 확정).
         ★자료 없는 달은 달수에서 뺀다 — TBL_PAT_INDI 는 자료가 없어도 행이 생기고 값이 0 이라,
           그냥 나누면 빈 달이 값을 끌어내린다(실측: 지표09 89.01 → 35.36 반토막). 이 처리를 빼지 말 것.
       · 병원 목록의 구조·진료·종합 점수도 달별 점수의 평균이다(0~100 척도라 더하면 100을 넘는다).
         ★그 달 환자평가표가 있는 달만 평균한다 — 평가표 없는 달은 진료가 기본값(7.80)이라 그대로 나누면
           진료·종합이 실제보다 낮아진다(실측: 부산대성요양병원 진료 34.80 → 15.51). 지표값과 같은 원칙.

     ★주의: 이 파일 안에서 Deferred EL 표기(샵 + 중괄호) 금지 — 변환에러로 content 타일이 빈 화면이 된다 --%>

<%-- ★[반드시 유지] .dashboard-wrapper 로 감싼다 — sidebar.jsp 가 이 클래스에만 margin-left:280px 을 준다.
     이걸 빼면 화면이 left:0 에서 시작해 **왼쪽 280px 이 사이드바에 가려진다**(지표명칭 칸이 안 보였던 원인, 2026-07-28).
     스크롤이 밀린 것처럼 보이지만 페이지 scrollX 는 0 이다 — 가려진 것과 밀린 것을 혼동하지 말 것.
     assessment.jsp 등 기존 화면도 모두 이 래퍼로 시작한다. --%>
<div class="dashboard-wrapper">
<div id="evalCompare">
<style>
  /* ★가로로 절대 넘치지 않게 (2026-07-28) — 넘치면 페이지가 통째로 오른쪽으로 밀려
       왼쪽 지표명칭 칸과 첫 요약 카드가 화면 밖으로 나간다(실제로 그렇게 나왔다).
       표가 길면 페이지가 아니라 **표 안쪽**(.ec-tbwrap)에서만 스크롤되게 한다. */
  #evalCompare{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 8px 50px; font-family:inherit;
                max-width:100%; overflow-x:hidden; }
  #evalCompare *{ box-sizing:border-box; }
  #evalCompare .ec-head{ display:flex; align-items:center; gap:10px; margin-bottom:12px; flex-wrap:wrap; }
  #evalCompare .ec-title{ font-size:18px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #evalCompare .ec-title .ec-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  /* 위너넷 뱃지 — 한 단계 크게(2026-07-28 요청) */
  #evalCompare .ec-role{ font-size:12.5px; font-weight:700; color:#fff; background:linear-gradient(135deg,#1f5a4b,#2a7665); padding:4px 12px; border-radius:20px; }
  #evalCompare .ec-back{ margin-left:auto; }

  #evalCompare .ec-bar{ display:flex; flex-wrap:wrap; align-items:center; gap:8px; padding:10px 12px; background:#fff;
    border:1px solid #e2e7ea; border-left:4px solid #2a7665; border-radius:8px; box-shadow:0 2px 6px rgba(16,22,29,.05); margin-bottom:12px; }
  #evalCompare .ec-bar label{ font-size:12.5px; font-weight:800; color:#54636c; }
  #evalCompare select.ec-sel{ font-family:inherit; font-size:13px; padding:6px 8px; border:1px solid #d5dbdf; border-radius:6px; background:#fff; color:#1f2a30; font-weight:700; }
  #evalCompare select.ec-sel:hover{ border-color:#2a7665; }
  #evalCompare .ec-btn{ font-family:inherit; font-size:13px; font-weight:800; cursor:pointer; padding:7px 14px; border-radius:6px;
    border:1px solid transparent; background:#2a7665; color:#fff; }
  #evalCompare .ec-btn:hover{ background:#1f5a4b; }
  #evalCompare .ec-btn.ec-ghost{ background:#fff; color:#2a7665; border-color:#bcd6cf; }
  #evalCompare .ec-btn.ec-ghost:hover{ background:#eef6f4; }

  /* 요약 칩 — 대상/비대상 내역을 숫자로 먼저 보여 준다.
     ★[2026-07-28 요청] 카드가 너무 크고 글자도 컸다. 늘어나지 않게(flex:0 0 auto) 내용 폭만 쓰고,
       라벨과 숫자를 **한 줄에** 붙여 한 줄짜리 띠로 만든다 — 카드 안 빈 자리가 사라지고 표와 균형이 맞는다. */
  /* ★글자 크기는 세 번 만져 여기서 맞췄다 — 처음 19px 은 너무 컸고 14px 은 너무 작았다(2026-07-28).
       칩 구조(늘어나지 않음·한 줄)는 그대로 두고 글자만 읽기 편한 크기로 되돌린 값이다. */
  /* ★조회줄 안 오른쪽에 붙는다(2026-07-28) — 줄 하나를 아낀다.
     ★오른쪽 끝에 딱 붙으니 답답해서 조금 왼쪽으로 물렸다(2026-07-28 2차 요청).
       margin-right 값만 키우면 더 왼쪽으로 간다(0 이면 오른쪽 끝에 붙음). */
  #evalCompare .ec-kpi{ display:flex; gap:8px; flex-wrap:wrap; align-items:center;
                        margin:0 90px 0 auto; justify-content:flex-end; }
  #evalCompare .ec-kpi div{ flex:0 0 auto; border:1px solid #e2e7ea; border-radius:6px; padding:5px 12px; background:#fff;
                            display:flex; align-items:baseline; gap:7px; white-space:nowrap; }
  /* 라벨·숫자 한 단계 더 크게(2026-07-28 3차 요청). 19px→14px→17px→18px 로 오간 값이니
     또 만질 때는 이 이력을 보고 판단할 것 — 표 글자(좌 14.5 / 우 13.5)와의 균형이 기준이다. */
  #evalCompare .ec-kpi span{ font-size:13.5px; color:#54636c; font-weight:700; }
  #evalCompare .ec-kpi b{ font-size:18px; color:#1f5a4b; font-weight:800; }
  #evalCompare .ec-kpi b.warn{ color:#b7791f; }
  #evalCompare .ec-kpi b.excl{ color:#c0392b; }

  /* 2단 — 왼쪽 지표별 비교(남는 폭 전부) / 오른쪽 병원 목록(고정폭).
     ★한쪽을 고정해 둔다. 둘 다 늘리면 창 폭에 따라 어느 한쪽이 잘린다. */
  /* ★두 카드를 **구조적으로 같은 높이**로 만든다 (2026-07-28 요청 — 몇 px 어긋나는 것을 숫자로 밀지 말고 구조로).
       align-items:stretch + 카드에 고정 높이 + 표 영역이 남은 자리를 flex 로 채우는 방식이다.
       이러면 좌(15줄)·우(51줄) 줄 수와 무관하게 제목줄·표·아래줄이 모두 같은 자리에 온다.
     ★표 높이를 각각 계산하던 방식(height/max-height)으로 되돌리지 말 것 — 줄 수에 따라 또 어긋난다. */
  #evalCompare .ec-two{ display:flex; gap:12px; align-items:stretch; flex-wrap:nowrap; max-width:100%; }
  #evalCompare .ec-two > .ec-l{ flex:1 1 0; min-width:0; }
  #evalCompare .ec-two > .ec-l, #evalCompare .ec-two > .ec-r{ display:flex; }
  #evalCompare .ec-two > .ec-l > .ec-card, #evalCompare .ec-two > .ec-r > .ec-card{
    display:flex; flex-direction:column; flex:1 1 auto; height:calc(100vh - 250px); min-height:300px; }
  /* ★flex-shrink 를 1 로 둔다(0 이면 폭이 모자랄 때 안 줄어들어 화면이 통째로 밀린다 — 2026-07-28).
     폭은 520 — 병원 목록은 5칸(병원명·구분·구조·진료·종합)이라 이만큼이면 다 들어온다(실측). */
  #evalCompare .ec-two > .ec-r{ flex:0 1 780px; min-width:0; }
  /* ★우측 구조·진료·종합 칸 넓게 (2026-07-28 요청) — 6칸 = 1 체크 · 2 병원명 · 3 구분 · 4 구조 · 5 진료 · 6 종합.
       min-width 를 깔면 표(width:100%)가 남는 자리를 병원명 대신 이 세 칸에 준다.
     ★[함정] 위치(nth-child) 기준이라 **칸 순서가 바뀌면 여기도 같이 고쳐야 한다**(체크 칸이 맨 앞에 붙어 4·5·6). */
  #evalCompare .ec-r table.ec-tb th:nth-child(4), #evalCompare .ec-r table.ec-tb td:nth-child(4),
  #evalCompare .ec-r table.ec-tb th:nth-child(5), #evalCompare .ec-r table.ec-tb td:nth-child(5),
  #evalCompare .ec-r table.ec-tb th:nth-child(6), #evalCompare .ec-r table.ec-tb td:nth-child(6){ min-width:88px; }
  /* 체크 칸은 좁게 고정 — 넓힐 필요가 없는 칸이 자리를 먹지 않게 */
  #evalCompare .ec-r table.ec-tb th:nth-child(1), #evalCompare .ec-r table.ec-tb td:nth-child(1){ width:34px; }
  @media (max-width:1400px){
    #evalCompare .ec-two{ flex-wrap:wrap; }
    #evalCompare .ec-two > .ec-l, #evalCompare .ec-two > .ec-r{ flex:1 1 100%; }
  }
  #evalCompare .ec-card{ background:#fff; border:1px solid #e2e7ea; border-radius:8px; padding:11px 12px; }
  #evalCompare .ec-cardtit{ display:flex; align-items:center; justify-content:space-between; gap:8px; margin-bottom:8px;
    font-size:13.5px; font-weight:800; color:#20303a; }
  /* 카드 부제(우리 병원 · 전체 평균(51곳) · 차이 / 비대상도 보기) — 한 단계 크게(2026-07-28 요청) */
  #evalCompare .ec-cardtit small{ font-weight:600; color:#6a7a75; font-size:12.5px; }
  /* ★좌우 표 높이를 **같은 값으로 고정**한다 (2026-07-28 요청 — "정확하게 우측하고 맞게").
       max-height 로 두면 줄 수에 따라 좌(15줄)·우(51줄) 높이가 달라져 아래줄이 몇 px 어긋난다.
       height 로 못박으면 줄 수와 무관하게 같아지고, 남는 자리는 비워 둔다(우측은 넘쳐서 스크롤).
       ★한쪽만 고정하면 안 된다 — 반드시 양쪽 같은 규칙을 써야 아래줄이 정확히 맞는다. */
  /* 표 영역 — 카드 안에서 **남은 자리를 전부** 차지한다(제목줄·아래줄을 뺀 나머지).
     양쪽 카드 높이가 같으므로 표 영역도 자동으로 같아진다. 높이를 직접 주지 않는 것이 요점이다. */
  #evalCompare .ec-tbwrap{ flex:1 1 auto; min-height:0; overflow:auto;
                           border:1px solid #e6ebee; border-radius:6px; }
  /* ★[안 됨] 표에 height:100% + 빈 채움줄로 tfoot 을 바닥까지 밀려 했는데, **sticky 가 깨져** 고정줄이
       칸 밖(아래 168px)으로 나갔다(2026-07-28 실측). 표 안에서 억지로 내리지 말 것.
       → 구조·진료·종합은 표 밖 아래줄(#ec-lpager)로 옮겼다. 우측 '행수' 줄과 같은 자리다. */
  #evalCompare #ec-lpager{ font-weight:800; color:#1f5a4b; background:#eef3f1;
                           border:1px solid #e6ebee; border-radius:6px; padding:0 12px; }

  /* 표 기본 글자 — 우측 병원 목록도 한 단계 크게(2026-07-28 요청). 좌측은 아래에서 한 단계 더 키운다. */
  #evalCompare table.ec-tb{ width:100%; border-collapse:collapse; font-size:13.5px; white-space:nowrap; }
  /* ★머리글은 모두 가운데 (2026-07-28 요청) — 지표명칭·병원명도 포함. 본문 칸 정렬(왼쪽/오른쪽)은 그대로 둔다.
       종전엔 그 두 칸만 인라인 style 로 왼쪽이었는데, 인라인이 CSS 를 이기므로 마크업에서 걷어냈다. */
  /* ★[함정] 스크롤할 때 **데이터가 머리글을 뚫고 보였다**(2026-07-28).
       border-collapse:collapse 인 표에서 sticky 머리글은 겹침 순서가 약해, 본문 칸(배경 있는 줄·뱃지)이
       위로 올라온다. 그래서 ① 머리글 z-index 를 본문·합계줄보다 확실히 높이고(6)
       ② 배경을 불투명하게 유지하고 ③ 아래쪽 경계를 box-shadow 로 그려 테두리가 사라지는 것도 막는다
       (collapse 표에서는 sticky 요소의 border 가 함께 스크롤돼 사라진다). */
  /* ★top:-1px 가 핵심 — top:0 이면 머리글 위에 **1px 틈**이 남아 그 사이로 지나가는 행이 비쳐 보인다
       (실측: 칸 top 34 / 머리글 top 35 → 틈 1px, 그 틈에 4번째 줄이 걸림). collapse 표의 공유 테두리 탓이다.
       1px 위로 붙여 틈을 없앤다. 아래쪽 경계는 box-shadow 로 그린다(sticky 요소의 border 는 같이 스크롤돼 사라진다). */
  #evalCompare table.ec-tb th{ background:#eef3f1; border:1px solid #e0e6e4; padding:5px 6px; position:sticky; top:-1px; z-index:6;
                               font-weight:700; text-align:center; box-shadow:0 1px 0 #cfe0db; }
  #evalCompare table.ec-tb td{ border:1px solid #e6ebee; padding:4px 6px; text-align:right; }
  #evalCompare table.ec-tb td.txt{ text-align:left; }
  #evalCompare table.ec-tb td.ctr{ text-align:center; }
  /* ★지표명칭은 **자르지 않고 전부 보여 준다**(2026-07-28 확정).
       한때 150px 에서 … 로 잘랐는데("유치도뇨관이 있는 ...") 이름을 다 보는 쪽이 낫다는 요청으로 되돌렸다.
       칸은 이름 길이에 맞춰 늘어난다 — 가장 긴 이름이 '욕창 처치를 실시한 환자분율'(13자)이라 200px 안쪽이다.
       다시 자르자는 얘기가 나오면 이 이력을 먼저 확인할 것. */
  #evalCompare table.ec-tb td.txt .nm{ white-space:nowrap; }
  #evalCompare table.ec-tb tbody tr:hover td{ background:#f5faf8; }
  #evalCompare .ec-msg{ padding:28px 14px; text-align:center; color:#6a7a75; font-size:13px; }
  /* 정렬 가능한 머리글 — 누를 수 있다는 것이 보이게 */
  #evalCompare table.ec-tb th.srt{ cursor:pointer; user-select:none; }
  #evalCompare table.ec-tb th.srt:hover{ color:#1f5a4b; background:#e4efeb; }
  /* 평균 포함 체크 — 끄면 그 병원을 평균에서 뺀다. 꺼진 줄은 흐리게 해서 눈으로 바로 갈린다. */
  #evalCompare table.ec-tb td .ec-ck{ margin:0; cursor:pointer; }
  #evalCompare table.ec-tb tbody tr.ec-off td{ color:#a9b4be; background:#fafbfc; }
  #evalCompare table.ec-tb tbody tr.ec-off td .ec-gb{ opacity:.5; }
  /* 하단 정보줄(페이징 대신) */
  /* 행수 + [모두 표시] 만 두는 줄. 평균은 표 안 고정줄(tfoot)에 있다.
     ★flex 를 쓰지 않는다 — 안에 글자와 <b> 가 섞여 있어 flex 로 두면 항목마다 흩어진다. */
  /* ★좌우 카드 바닥을 맞추려면 이 줄의 **높이가 양쪽 같아야** 한다(2026-07-28).
       우측에는 [모두 표시] 버튼이 들어가 저절로 더 높아지고, 좌측은 빈 줄이라 낮아서 카드가 어긋났다.
       → min-height 를 버튼이 들어갈 높이로 고정하고 가운데 정렬한다. 버튼 크기를 바꾸면 이 값도 함께 볼 것.
     ★flex 를 써도 되는 이유 — 안쪽 내용을 항상 span 하나로 감싸서 넣는다(ecHInfo). 그냥 넣으면 항목이 흩어진다. */
  #evalCompare .ec-pager{ margin-top:7px; font-size:13.5px; color:#5a6b7a;
                          min-height:30px; display:flex; align-items:center; }
  /* 평균 고정줄 — 표 맨 아래에 붙어 스크롤해도 따라온다. 머리글과 같은 색으로 '기준값' 임을 보인다. */
  /* 평균 고정줄 — 머리글(6)보다 낮고 본문보다 높게. 위쪽 경계는 box-shadow 로(머리글과 같은 이유) */
  #evalCompare table.ec-tb tfoot tr.ec-favg td{ position:sticky; bottom:-1px; z-index:4;
    background:#eef3f1; font-weight:800; color:#1f5a4b; box-shadow:0 -2px 0 #cfe0db; }
  #evalCompare .ec-pager b{ color:#20303a; }
  #evalCompare .ec-pager button{ margin-left:8px; font-family:inherit; font-size:11.5px; font-weight:700;
    cursor:pointer; padding:3px 10px; border:1px solid #bcd6cf; border-radius:5px; background:#fff; color:#2a7665; }
  #evalCompare .ec-pager button:hover{ background:#eef6f4; }
  /* ★좌측 지표별 비교 — 줄이 15개뿐이라 우측 병원 목록보다 표가 짧아 균형이 안 맞았다(2026-07-28 요청).
       **왼쪽 표만** 행 높이와 글자를 키워 우측과 눈높이를 맞춘다(우측은 줄 수가 많아 그대로 둔다).
       글자는 우측(13.5px)보다 한 단계 큰 14.5px — 지표명은 매달 읽는 값이라 조금 커야 편하다. */
  #evalCompare .ec-l table.ec-tb{ font-size:14.5px; }
  #evalCompare .ec-l table.ec-tb th{ padding:9px 8px; }
  #evalCompare .ec-l table.ec-tb td{ padding:9px 8px; }

  /* 우리 병원 줄 강조 — 51곳 사이에서 우리가 어디쯤인지 바로 찾게 */
  #evalCompare table.ec-tb tbody tr.ec-me td{ background:#fff5d6; font-weight:800; }
  #evalCompare table.ec-tb tbody tr.ec-me:hover td{ background:#ffefc0; }

  /* 차이 — 평균보다 높으면 파랑, 낮으면 빨강. ★'좋다/나쁘다'가 아니라 방향만 표시한다
     (지표마다 높을수록 좋은 것과 낮을수록 좋은 것이 섞여 있어 색으로 우열을 말하면 오해가 된다) */
  #evalCompare .ec-up{ color:#1565c0; font-weight:700; }
  #evalCompare .ec-dn{ color:#c0392b; font-weight:700; }
  #evalCompare .ec-eq{ color:#8a95a1; }

  #evalCompare .ec-gb{ display:inline-block; font-size:11px; font-weight:800; padding:2px 8px; border-radius:12px; border:1px solid transparent; }
  #evalCompare .ec-gb.gb-y{ background:#eaf5ec; color:#2e7d32; border-color:#bfe0c4; }
  #evalCompare .ec-gb.gb-nopat{ background:#fbf3e2; color:#b7791f; border-color:#ead9b0; }
  #evalCompare .ec-gb.gb-excl{ background:#fdecea; color:#c0392b; border-color:#f2c3bd; }
</style>

  <div class="ec-head">
    <span class="ec-title"><span class="ec-dot"></span>적정성평가 — 전체 비교</span>
    <span class="ec-role">위너넷</span>
    <span class="ec-back"><button class="ec-btn ec-ghost" onclick="ecBack()">← 적정성평가로</button></span>
  </div>

  <div class="ec-bar">
    <%-- ★[2026-07-30] 한 달 → 기간(시작월~종료월) 조회. 년도는 그대로 두고 월만 두 칸으로 나눴다.
             · 시작월 = 종료월 이면 예전 한 달 조회와 **완전히 같은 값**이다(실측 대조 확인).
             · 여러 달을 고르면 **월평균** — 한 달씩 값을 구해 달수로 나눈다(자료 없는 달은 달수에서 제외).
               계산 규칙과 그 근거(실측 수치)는 Magam_SQL.xml 의 evalCmpIntegrated 주석에 있다. --%>
    <label>평가년도</label>
    <select id="ec-year" class="ec-sel" onchange="ecLoad()"></select>
    <label style="margin-left:6px;">기간</label>
    <select id="ec-month" class="ec-sel" onchange="ecMonthFix('fr')" title="시작월"></select>
    <span style="font-weight:800; color:#54636c;">~</span>
    <select id="ec-month2" class="ec-sel" onchange="ecMonthFix('to')" title="종료월"></select>
    <button class="ec-btn" onclick="ecLoad()">조회</button>
    <span id="ec-stat" style="font-size:12px; font-weight:700; color:#6a7a75; margin-left:6px;"></span>

    <%-- ★요약 칩을 조회줄 **오른쪽 끝**으로 올려붙였다(2026-07-28 요청) — 한 줄을 통째로 아꼈다.
         .ec-kpi 의 margin-left:auto 가 오른쪽으로 밀어낸다. --%>
    <div class="ec-kpi">
      <div><span>평균 대상 병원</span><b id="ec-k1">—</b></div>
      <div><span>환자평가표 없음</span><b id="ec-k2" class="warn">—</b></div>
      <div><span>제외 기관기호</span><b id="ec-k3" class="excl">—</b></div>
      <div><span>기간 전체 병원</span><b id="ec-k4">—</b></div>
    </div>
  </div>

  <div class="ec-two">
    <div class="ec-l">
      <div class="ec-card">
        <div class="ec-cardtit"><span>지표별 비교</span><small id="ec-sub1">우리 병원 · 전체 평균 · 차이</small></div>
        <div class="ec-tbwrap"><table class="ec-tb" id="ec-ind"></table></div>
        <%-- 선택 병원의 구조·진료·종합 — 우측 '행수 · 모두 표시' 줄과 **같은 자리**다.
             표 안 tfoot 으로 넣었다가 sticky 가 깨져(칸 밖으로 나감) 여기로 옮겼다(2026-07-28). --%>
        <div class="ec-pager" id="ec-lpager"></div>
      </div>
    </div>
    <div class="ec-r">
      <div class="ec-card">
        <div class="ec-cardtit"><span>병원 목록</span>
          <small>
            <label style="font-weight:700; cursor:pointer;">
              <input type="checkbox" id="ec-showall" onchange="ecRenderHosp()"> 비대상도 보기
            </label>
          </small>
        </div>
        <div class="ec-tbwrap" id="ec-hospwrap"><table class="ec-tb" id="ec-hosp"></table></div>
        <%-- 하단 정보줄 — 매출내역·재고현황(konet lzInfo)과 같은 방식.
             페이지 버튼 대신 '몇 행까지 나왔는지' + [모두 표시]를 둔다(Ctrl+F 검색·전체 복사용). --%>
        <div class="ec-pager" id="ec-hpager"></div>
      </div>
    </div>
  </div>

<%-- ★화면 아래 설명 4줄은 뺐다(2026-07-28 요청) — 배경색과 겹쳐 읽히지도 않았다.
     설명 내용(대상 기준·평균 규칙·차이 색·점수 계산식)은 지운 것이 아니라
     Magam_SQL.xml 의 select_EvalCmpAvg 주석과 이 파일 각 함수 주석에 근거와 수치까지 남아 있다. --%>

<script>
jQuery(function(){
  "use strict";
  var ctx = (typeof CommonUtil !== 'undefined' && CommonUtil.getContextPath) ? CommonUtil.getContextPath() : '';
  function el(id){ return document.getElementById(id); }
  function esc(s){ return String(s==null?'':s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }
  function n(v){ var x=Number(v); return isNaN(x)?0:x; }
  function f2(v){ return (Math.round(n(v)*100)/100).toFixed(2); }
  function ck(nm){ try{ if(typeof getCookie==='function') return (getCookie(nm)||'').trim(); }catch(e){}
    var m=document.cookie.match('(^|;)\\s*'+nm+'\\s*=\\s*([^;]+)'); return m?decodeURIComponent(m.pop()).trim():''; }

  /* 비교 기준 병원 = **병원검색으로 고른 그 병원**.
       위너넷 관리자는 병원검색으로 병원을 바꿔가며 보므로, 로그인 계정이 아니라 고른 병원이 기준이어야 한다.
       top.jsp 가 선택 결과를 쿠키 hospid / s_hospnm 에 넣고 전역 hospid·hospnm 으로도 노출한다
       — 적정성평가 화면이 조회에 쓰는 그 값과 **같은 것**을 쓴다(두 화면 숫자가 어긋나지 않게).
     ★[2026-07-28] 라벨이 '우리 병원' 으로 고정돼 있어 관리자 화면에서 어느 병원인지 알 수 없었다
       → 표 머리글·고정줄·부제 모두 **선택한 병원 이름**으로 바꿨다. */
  var myHosp = (typeof hospid !== 'undefined' && hospid) ? String(hospid).trim() : ck('s_hospid');
  var myHospNm = (typeof hospnm !== 'undefined' && hospnm) ? String(hospnm).trim() : ck('s_hospnm');
  if(!myHospNm) myHospNm = myHosp || '선택 병원';

  /* 지표코드 → 이름. 서버 평균 응답에는 코드만 있어 화면 이름을 여기서 붙인다.
     ★적정성평가 지표표(select_Eval_Indi 의 cate_nm)와 같은 이름이어야 두 화면을 나란히 볼 수 있다.
       지표가 바뀌면 여기도 같이 고칠 것. 모르는 코드는 코드 그대로 보여 준다(빠뜨려도 화면은 안 깨진다). */
  var IND_NM = {
    '01':'의사 1인당 환자수', '02':'간호사 1인당 환자수', '03':'간호인력 1인당 환자수',
    '04':'약사 재직일수율',   '05':'유치도뇨관이 있는 환자분율', '06':'배뇨관리 실시 환자분율',
    '07':'항정신성의약품 처방률', '08':'DUR 점검률', '09':'욕창 처치를 실시한 환자분율',
    '10':'욕창이 새로생긴 환자분율', '11':'욕창개선환자분율', '12':'일상생활수행능력ADL',
    '13':'당뇨환자 HbA1c 적정', '14':'장기입원181일 이상', '15':'지역사회 복귀율'
  };
  /* 단위 — 적정성평가 화면과 같은 규칙(01·02·03 은 '명', 나머지는 '%'). 99 는 합계행이라 화면에 안 낸다. */
  function unit(cd){ return (['01','02','03'].indexOf(cd)>=0) ? '명' : '%'; }

  var _avg = [], _hosp = [], _mine = {};   // _mine = 우리 병원 지표별 현황값(cateCd → cal_val)
  var _raw = [], _excl = {};               // _raw = 병원별 지표값(낟알) / _excl = 체크로 뺀 병원(hospCd → true)

  /* ★평균을 화면에서 계산한다 (2026-07-28 요청 — 병원마다 체크로 평균에서 빼기).
       서버 평균(select_EvalCmpAvg)과 **같은 규칙**이어야 한다 — 병원별 현황값의 단순평균,
       현황값 0 인 병원도 포함, 제외 체크한 병원만 뺀다. 체크할 때마다 서버를 부르지 않는다. */
  function ecCalcAvg(){
    var m = {}, ord = [];
    for(var i=0;i<_raw.length;i++){
      var r=_raw[i], cd=String(r.cateCd||'');
      if(!cd) continue;
      if(_excl[String(r.hospCd||'')]) continue;      // 체크로 뺀 병원
      if(!m[cd]){ m[cd]={ cateCd:cd, sum:0, cnt:0, min:null, max:null }; ord.push(cd); }
      var v=n(r.calVal), t=m[cd];
      t.sum+=v; t.cnt++;
      if(t.min===null || v<t.min) t.min=v;
      if(t.max===null || v>t.max) t.max=v;
    }
    ord.sort();
    _avg = ord.map(function(cd){
      var t=m[cd];
      return { cateCd:cd, hospCnt:t.cnt, avgVal:(t.cnt?t.sum/t.cnt:0),
               minVal:(t.min===null?0:t.min), maxVal:(t.max===null?0:t.max) };
    });
  }
  /* 제외 체크 토글 — 평균·요약·양쪽 표를 다시 그린다(서버 호출 없음) */
  window.ecExcl = function(cd, on){
    if(on) delete _excl[cd]; else _excl[cd]=true;    // 체크됨 = 평균에 포함
    ecCalcAvg(); ecRenderKpi(); ecRenderInd(); ecRenderHosp();
  };
  /* 머리글 전체 체크 (2026-07-28 요청) — 대상(Y) 병원 전부를 한 번에 켜고 끈다.
     ★'비대상도 보기'로 화면에 보이는 줄만이 아니라 **대상 전체**에 적용한다 —
       안 보이는 병원이 몰래 평균에 남아 있으면 숫자를 못 믿게 된다. */
  window.ecExclAll = function(on){
    for(var i=0;i<_hosp.length;i++){
      var r=_hosp[i];
      if(String(r.targetGb||'')!=='Y') continue;      // 평가표없음·제외는 애초에 평균에 없다
      var cd=String(r.hospCd||'');
      if(on) delete _excl[cd]; else _excl[cd]=true;
    }
    ecCalcAvg(); ecRenderKpi(); ecRenderInd(); ecRenderHosp();
  };
  /* 전체 체크의 모양 — 전부 켜짐/전부 꺼짐/섞임(밑줄 표시)을 그려 준다.
     indeterminate 는 HTML 속성으로 못 주므로 표를 그린 뒤 코드로 넣는다. */
  function ecCkAllState(){
    var box=el('ec-ckall'); if(!box) return;
    var tot=0, on=0;
    for(var i=0;i<_hosp.length;i++){
      if(String(_hosp[i].targetGb||'')!=='Y') continue;
      tot++; if(!_excl[String(_hosp[i].hospCd||'')]) on++;
    }
    box.checked = (tot>0 && on===tot);
    box.indeterminate = (on>0 && on<tot);
    box.title = (tot>0 && on===tot) ? '전부 평균에 포함 — 누르면 전부 뺍니다'
              : (on===0)            ? '전부 평균에서 빠짐 — 누르면 전부 넣습니다'
              :                       on+' / '+tot+'곳만 평균에 포함 — 누르면 전부 넣습니다';
  }
  /* 병원 목록 정렬 상태 — 기본 병원명 가나다순(2026-07-28 사용자 지정).
     같은 머리글을 다시 누르면 오르내림이 바뀐다. 숫자 칸은 처음 누를 때 **큰 값부터**가 자연스럽다. */
  var _hsort = { key:'hospNm', desc:false };
  window.ecHSort = function(k){
    if(_hsort.key===k) _hsort.desc = !_hsort.desc;
    else _hsort = { key:k, desc:(k!=='hospNm' && k!=='targetGb') };
    ecRenderHosp();
  };

  (function initSel(){
    var now=new Date(), y=now.getFullYear();
    var qy=(location.search.match(/[?&]ym=(\d{6})/)||[])[1];
    var defY = qy ? qy.substring(0,4) : String(y);
    var defM = qy ? qy.substring(4,6) : ('0'+(now.getMonth()+1)).slice(-2);
    var yh=''; for(var yy=y; yy>=y-9; yy--) yh+='<option value="'+yy+'">'+yy+'</option>';
    el('ec-year').innerHTML=yh; el('ec-year').value=defY;
    var mh=''; for(var mo=1;mo<=12;mo++){ var mm=('0'+mo).slice(-2); mh+='<option value="'+mm+'">'+mm+'월</option>'; }
    /* 시작월·종료월 둘 다 진입한 달로 시작한다 — 적정성평가에서 [평가비교] 로 들어오면
       그 달만 보이는 게 기존 동작이고, 기간은 사용자가 넓히는 것이 자연스럽다. */
    el('ec-month').innerHTML=mh;  el('ec-month').value=defM;
    el('ec-month2').innerHTML=mh; el('ec-month2').value=defM;
  })();

  /* 시작월 > 종료월 이 되면 방금 고른 쪽을 기준으로 다른 쪽을 맞춰 준다(오류창을 띄우지 않는다).
     which = 'fr'(시작월을 바꿨다) / 'to'(종료월을 바꿨다) */
  window.ecMonthFix = function(which){
    var fr=el('ec-month'), to=el('ec-month2');
    if(fr.value > to.value){ if(which==='fr') to.value = fr.value; else fr.value = to.value; }
    ecLoad();
  };

  /* [← 적정성평가로] — ★돌아갈 때 '재생성 확인' 팝업이 뜨지 않게 한다(2026-07-28 요청).
       적정성평가 화면은 진입 시 자료가 있으면 "다시 생성하시겠습니까?"를 묻는데, 보던 화면으로
       되돌아가는 길에서까지 물으면 방해가 된다. 월보고서 종료(erExit)가 쓰는 그 마커를 그대로 쓴다
       — sessionStorage 'skipRegenConfirm' = '1' 이면 그 진입 1회만 묻지 않고 기존 자료를 보여 준다.
     ★년·월도 넘겨준다 — 적정성평가는 assessment_year/assessment_month(sessionStorage)로 기억하므로
       여기서 보던 달이 그대로 열린다(ym 파라미터만으로는 안 맞춰진다). */
  window.ecBack = function(){
    var yy = el('ec-year').value, mm = el('ec-month').value;
    try {
      sessionStorage.setItem('skipRegenConfirm', '1');
      sessionStorage.setItem('assessment_year',  yy);
      sessionStorage.setItem('assessment_month', mm);
    } catch(e) { }
    location.href = ctx + '/main/assessment.do?ym=' + yy + mm;
  };

  /* 기간의 달 목록 — 시작월~종료월 (같으면 한 달) */
  function ecMonths(){
    var yy=el('ec-year').value, mf=el('ec-month').value, mt=el('ec-month2').value;
    if(mf > mt){ var t=mf; mf=mt; mt=t; }
    var out=[];
    for(var mo=parseInt(mf,10); mo<=parseInt(mt,10); mo++) out.push(yy+('0'+mo).slice(-2));
    return out;
  }

  /* 기준 병원(선택 병원)의 기간값 — **서버(Magam_SQL.xml evalCmpIntegrated)와 똑같은 규칙**이어야 한다.
       · 월평균 : 달마다의 현황값을 더해 달수로 나눈다(분자합/분모합 아님 — 2026-07-30 사용자 확정).
       · **자료 없는 달은 달수에서 뺀다** : 자료가 없어도 행은 생기고 값이 0 이라, 그냥 나누면 값이 꺼진다.
         '자료 있는 달' = 분모가 있거나(dtorval>0), 분모 없이 값만 정해지는 지표(07·08·15)라 값이 0 이 아닌 달.
       · 모든 달이 빈 달이면 0.
     ★서버 조회(select_Eval_Indi)가 한 달 단위라 달마다 부른 뒤 여기서 합친다. 규칙이 어긋나면
       왼쪽(선택 병원)과 오른쪽(전체 평균)의 기준이 달라지므로, 한쪽만 고치지 말 것. */
  function ecMergeMine(perMonthRows){
    var acc = {};
    perMonthRows.forEach(function(rows){
      (rows||[]).forEach(function(r){
        var cd = String(r.cate_cd||r.cateCd||''); if(!cd) return;
        var a = acc[cd] || (acc[cd] = { sum:0, cnt:0 });
        var d = n(r.dtorval), v = n(r.cal_val);
        if(d > 0 || v !== 0){ a.sum += v; a.cnt++; }      // 자료 있는 달만 센다
      });
    });
    var out = {};
    Object.keys(acc).forEach(function(cd){
      var a = acc[cd];
      out[cd] = a.cnt ? Math.round(a.sum/a.cnt*100)/100 : 0;
    });
    return out;
  }

  window.ecLoad = function(){
    var months = ecMonths();
    var ymFr = months[0], ymTo = months[months.length-1];
    el('ec-stat').textContent = '조회 중…';
    el('ec-ind').innerHTML  = '<tbody><tr><td class="ec-msg">읽는 중…</td></tr></tbody>';
    el('ec-hosp').innerHTML = '<tbody><tr><td class="ec-msg">읽는 중…</td></tr></tbody>';

    /* ①전체평균(낟알) ②병원목록 은 기간 파라미터를 그대로 넘긴다 — 서버가 기간 통합으로 계산한다.
         jobyymm 도 같이 보낸다(기간 파라미터를 모르는 예전 쿼리와의 호환 — 값은 시작월).
       ③기준 병원 지표는 적정성평가 화면이 쓰는 그 조회를 달마다 재사용한다(같은 값이 나와야 하므로 새로 만들지 않는다). */
    var prm   = { jobyymm:ymFr, jobyymmFr:ymFr, jobyymmTo:ymTo };
    var pAvg  = jQuery.ajax({ url:ctx+'/main/select_EvalCmpRaw.do',  type:'POST', dataType:'json', data:prm });
    var pHosp = jQuery.ajax({ url:ctx+'/main/select_EvalCmpHosp.do', type:'POST', dataType:'json', data:prm });
    var pMine = months.map(function(ym){
      return jQuery.ajax({ url:ctx+'/main/select_Eval_Indi.do', type:'POST', dataType:'json',
                           data:{ hosp_cd:myHosp, jobyymm:ym } });
    });

    jQuery.when.apply(jQuery, [pAvg, pHosp].concat(pMine)).done(function(){
      var args = Array.prototype.slice.call(arguments);
      var a = args[0], h = args[1], mine = args.slice(2);
      _raw  = ((a[0]&&a[0].list) || []);   // 병원별 지표값(낟알) — 평균은 이걸로 화면에서 낸다
      _excl = {};                          // 기간을 바꾸면 제외 체크는 초기화한다
      _hosp = ((h[0]&&h[0].list) || []);
      _mine = ecMergeMine(mine.map(function(m){ return (m[0] && (m[0].data || m[0].list || m[0])) || []; }));
      ecCalcAvg(); ecRenderKpi(); ecRenderInd(); ecRenderHosp();
      el('ec-stat').textContent = (months.length > 1)
            ? (ymFr.substring(0,4)+'.'+ymFr.substring(4,6)+' ~ '+ymTo.substring(4,6)+'월 · '+months.length+'개월 월평균')
            : '';
    }).fail(function(){
      el('ec-stat').textContent = '조회에 실패했습니다.';
      el('ec-ind').innerHTML  = '<tbody><tr><td class="ec-msg">자료를 읽지 못했습니다.</td></tr></tbody>';
      el('ec-hosp').innerHTML = '<tbody><tr><td class="ec-msg">자료를 읽지 못했습니다.</td></tr></tbody>';
    });
  };

  function ecRenderKpi(){
    var y=0, nopat=0, excl=0;
    for(var i=0;i<_hosp.length;i++){
      var g=String(_hosp[i].targetGb||''), cd=String(_hosp[i].hospCd||'');
      if(g==='Y'){ if(!_excl[cd]) y++; }             // 체크로 뺀 병원은 대상에서 뺀다
      else if(g==='NOPAT') nopat++; else if(g==='EXCL') excl++;
    }
    el('ec-k1').textContent = y.toLocaleString()+' 곳';
    el('ec-k2').textContent = nopat.toLocaleString()+' 곳';
    el('ec-k3').textContent = excl.toLocaleString()+' 곳';
    el('ec-k4').textContent = _hosp.length.toLocaleString()+' 곳';
    el('ec-sub1').textContent = myHospNm + ' · 전체 평균(' + y + '곳) · 차이';
  }

  function ecRenderInd(){
    var t=el('ec-ind');
    if(!_avg.length){ t.innerHTML='<tbody><tr><td class="ec-msg">이 기간에는 집계할 자료가 없습니다.</td></tr></tbody>'; return; }
    /* ★병원수 칸은 빼고 **위 요약에 한 번만** 낸다(2026-07-28 요청) — 지표마다 같은 값(51)이 줄마다 반복돼
         칸만 먹었다. 혹시 지표별로 병원수가 다르면 그 줄의 '전체 평균' 칸에 마우스를 올리면 나온다. */
    var h='<thead><tr><th>지표명칭</th><th>'+esc(myHospNm)+'</th><th>전체 평균</th>'
        + '<th title="'+esc(myHospNm)+' − 전체 평균">차이</th><th>최소</th><th>최대</th></tr></thead><tbody>';
    var shown=0;
    for(var i=0;i<_avg.length;i++){
      var r=_avg[i], cd=String(r.cateCd||'');
      if(cd==='99') continue;                       // 합계행 — 지표가 아니다
      if(!IND_NM[cd]) continue;                     // 화면 지표표에 없는 코드(M1·M3·M4 등)는 내지 않는다
      shown++;
      var u=unit(cd), av=n(r.avgVal);
      var has = (_mine[cd] !== undefined && _mine[cd] !== null && _mine[cd] !== '');
      var mv = has ? n(_mine[cd]) : null;
      var d  = has ? (mv-av) : null;
      var dc = (d===null) ? 'ec-eq' : (Math.abs(d)<0.005 ? 'ec-eq' : (d>0 ? 'ec-up' : 'ec-dn'));
      var ds = (d===null) ? '-' : ((d>0?'+':'')+f2(d));
      h += '<tr>'
         + '<td class="txt" title="'+esc(IND_NM[cd])+'"><span class="nm">'+esc(IND_NM[cd])+'</span></td>'
         + '<td>'+(has ? (f2(mv)+u) : '-')+'</td>'
         + '<td title="'+n(r.hospCnt).toLocaleString()+'곳 평균">'+f2(av)+u+'</td>'
         + '<td class="'+dc+'">'+ds+'</td>'
         + '<td>'+f2(r.minVal)+'</td>'
         + '<td>'+f2(r.maxVal)+'</td>'
         + '</tr>';
    }
    t.innerHTML = shown ? (h+'</tbody>')
      : '<tbody><tr><td class="ec-msg">표시할 지표가 없습니다.</td></tr></tbody>';
    ecMyFoot();          // 구조·진료·종합 — 표 밖 아래줄에 그린다
  }

  /* 좌측 표 맨 아래 고정줄 — **우리 병원의 구조·진료·종합**.
       · 우리 병원 점수는 병원 목록(_hosp)에 이미 들어 있다(76곳 전부를 받으므로 우리도 그 안에 있다).
         적정성평가 화면 상단 카드와 같은 계산식이라 두 화면 숫자가 맞는다.
       · 전체 평균은 우측 평균 고정줄과 **같은 모집단**(대상 Y · 체크 켜짐)이라 체크를 끄면 같이 바뀐다.
       · 차이 색은 방향만 — 지표에 따라 높은 쪽이 좋을 수도, 낮은 쪽이 좋을 수도 있어 우열로 칠하지 않는다. */
  /* ★우측 평균줄과 **같은 라인**에 놓기 위해 표 밖 div 가 아니라 **표 안 tfoot** 으로 넣는다(2026-07-28 요청).
       우측은 표 안 고정줄이라, 좌측을 표 밖에 두면 한 줄 아래로 내려가 눈높이가 어긋났다.
       좌측 표는 칸 구성이 달라(지표명칭·우리병원·전체평균·차이·최소·최대) 구조·진료·종합에 대응하는 칸이 없으므로
       colspan 으로 한 칸에 펼친다. 스타일은 우측과 같은 .ec-favg 를 그대로 쓴다(색·굵기·sticky 동일). */
  function ecMyFoot(){
    var box=el('ec-lpager'); if(!box) return;
    var me=null;
    for(var i=0;i<_hosp.length;i++){ if(String(_hosp[i].hospCd||'')===String(myHosp)){ me=_hosp[i]; break; } }
    if(!me){ box.innerHTML=''; return; }
    var s=0, c=0, t=0, k=0;
    for(var j=0;j<_hosp.length;j++){
      var r=_hosp[j];
      if(String(r.targetGb||'')!=='Y' || _excl[String(r.hospCd||'')]) continue;
      s+=n(r.structScore); c+=n(r.careScore); t+=n(r.totalScore); k++;
    }
    function d(mv, av){
      if(!k) return '';
      var v=n(mv)-av/k, cl=(Math.abs(v)<0.005)?'ec-eq':(v>0?'ec-up':'ec-dn');
      return ' <span class="'+cl+'">('+(v>0?'+':'')+f2(v)+')</span>';
    }
    /* ★'전체 평균 51곳 …' 은 붙이지 않는다(2026-07-28) — 우측 평균 고정줄과 **중복**이다.
         괄호 안 차이값만 남기면 비교는 그대로 되고 화면은 짧아진다. 다시 붙이자는 얘기가 나오면 이 이력을 볼 것. */
    box.innerHTML = '<span>'
      + esc(myHospNm)
      + ' &nbsp;구조 <b>'+f2(me.structScore)+'</b>'+d(me.structScore, s)
      + ' &nbsp;· 진료 <b>'+f2(me.careScore)+'</b>'+d(me.careScore, c)
      + ' &nbsp;· 종합 <b>'+f2(me.totalScore)+'</b>'+d(me.totalScore, t)
      + '</span>';
  }

  window.ecRenderHosp = function(){
    var t=el('ec-hosp'), all=el('ec-showall').checked;
    if(!_hosp.length){ t.innerHTML='<tbody><tr><td class="ec-msg">이 달에는 자료가 있는 병원이 없습니다.</td></tr></tbody>'; return; }

    /* ★머리글을 눌러 정렬 (2026-07-28 요청) — 기본은 **병원명 가나다순**.
         서버가 아니라 화면에서 정렬한다(이미 받아온 자료라 다시 조회할 필요가 없다).
         병원명은 한글 정렬(localeCompare 'ko'), 나머지는 숫자로 비교한다.
         구분은 대상 → 평가표없음 → 제외 순서가 되게 값에 순번을 매겨 정렬한다. */
    var rows = _hosp.filter(function(r){ return all || String(r.targetGb||'')==='Y'; });
    var GBORD = { 'Y':0, 'NOPAT':1, 'EXCL':2 };
    var sk=_hsort.key, sd=_hsort.desc?-1:1;
    rows.sort(function(a,b){
      if(sk==='hospNm'){
        var x=String(a.hospNm||a.hospCd||''), y=String(b.hospNm||b.hospCd||'');
        return x.localeCompare(y,'ko') * sd;
      }
      if(sk==='targetGb'){
        var ga=GBORD[String(a.targetGb||'')], gb2=GBORD[String(b.targetGb||'')];
        if(ga===gb2) return String(a.hospNm||'').localeCompare(String(b.hospNm||''),'ko');
        return (ga-gb2) * sd;
      }
      var na=n(a[sk]), nb=n(b[sk]);
      if(na===nb) return String(a.hospNm||'').localeCompare(String(b.hospNm||''),'ko');
      return (na<nb?-1:1) * sd;
    });

    function ah(k){ return _hsort.key===k ? (_hsort.desc?' ▼':' ▲') : ''; }
    var h='<thead><tr>'
        + '<th><input type="checkbox" id="ec-ckall" class="ec-ck"'
        +   ' onclick="ecExclAll(this.checked)"></th>'
        + '<th class="srt" onclick="ecHSort(\'hospNm\')" title="병원명 순으로 정렬">병원명'+ah('hospNm')+'</th>'
        + '<th class="srt" onclick="ecHSort(\'targetGb\')" title="대상 → 평가표없음 → 제외 순">구분'+ah('targetGb')+'</th>'
        + '<th class="srt" onclick="ecHSort(\'structScore\')">구조'+ah('structScore')+'</th>'
        + '<th class="srt" onclick="ecHSort(\'careScore\')">진료'+ah('careScore')+'</th>'
        + '<th class="srt" onclick="ecHSort(\'totalScore\')">종합'+ah('totalScore')+'</th>'
        + '</tr></thead><tbody>';
    if(!rows.length){
      t.innerHTML='<tbody><tr><td class="ec-msg">대상 병원이 없습니다. <b>비대상도 보기</b>를 켜 보세요.</td></tr></tbody>';
      el('ec-hpager').innerHTML=''; _hrows=[]; _hfrom=0;
      return;
    }
    /* ★페이지 버튼 대신 '몇 행까지 나왔는지 + [모두 표시]' (2026-07-28 요청 — konet 매출내역과 같은 방식).
         처음 EC_ROWS 행만 찍고, 표 안을 스크롤해 바닥 근처에 오면 다음 묶음을 이어붙인다. */
    _hrows = rows; _hfrom = 0;
    t.innerHTML = h + '</tbody>' + ecHFoot();   // 평균 고정줄은 tbody 뒤에 붙인다
    ecHFill();                       // 첫 묶음
    ecHBind();
    /* 첫 묶음이 표 높이보다 짧으면 스크롤이 안 생겨 영영 안 채워진다 — 찰 때까지 미리 붙인다 */
    var wrap=el('ec-hospwrap');
    for(var g=0; _hfrom<_hrows.length && wrap.scrollHeight<=wrap.clientHeight+2 && g<200; g++) ecHFill();
    ecCkAllState();                  // 머리글 전체 체크 모양(켜짐/꺼짐/섞임) 맞추기
  };

  var EC_ROWS = 20;                  // 한 번에 붙이는 줄 수
  var _hrows = [], _hfrom = 0;

  function ecHRow(r){
    var g=String(r.targetGb||'');
    var gb = (g==='Y')     ? '<span class="ec-gb gb-y">대상</span>'
           : (g==='NOPAT') ? '<span class="ec-gb gb-nopat" title="이 달 환자평가표가 없어 평균에서 빠졌습니다">평가표 없음</span>'
           :                 '<span class="ec-gb gb-excl" title="제외하도록 지정된 기관기호입니다(테스트 계정)">제외</span>';
    var cd = String(r.hospCd||'');
    var cls = [];
    if(cd===String(myHosp)) cls.push('ec-me');
    if(_excl[cd])           cls.push('ec-off');     // 평균에서 뺀 줄 — 흐리게
    var me = cls.length ? (' class="'+cls.join(' ')+'"') : '';
    /* 평균 체크 — 대상(Y) 병원만 켜고 끌 수 있다.
       평가표없음·제외는 애초에 평균에 안 들어가므로 체크박스를 두지 않고 '−' 로 둔다(잘못 눌러 헷갈리지 않게). */
    var ckCell = (String(r.targetGb||'')==='Y')
      ? '<td class="ctr"><input type="checkbox" class="ec-ck"'+(_excl[cd]?'':' checked')
        + ' onclick="ecExcl(\''+esc(cd).replace(/'/g,"\\'")+'\', this.checked)"'
        + ' title="끄면 이 병원을 평균에서 뺍니다"></td>'
      : '<td class="ctr" style="color:#c3ccd6">−</td>';
    return '<tr'+me+'>'
         + ckCell
         + '<td class="txt" title="'+esc(r.hospCd)+(n(r.patCnt)?(' · 환자평가표 '+n(r.patCnt).toLocaleString()+'건'):'')+'">'
         +   esc(r.hospNm || r.hospCd) + '</td>'
         + '<td class="ctr">'+gb+'</td>'
         + '<td>'+f2(r.structScore)+'</td>'
         + '<td>'+f2(r.careScore)+'</td>'
         + '<td>'+f2(r.totalScore)+'</td>'
         + '</tr>';
  }
  function ecHFill(){
    if(_hfrom >= _hrows.length){ ecHInfo(); return; }
    var tb=el('ec-hosp').tBodies[0]; if(!tb){ ecHInfo(); return; }
    var to=Math.min(_hfrom+EC_ROWS, _hrows.length), s='';
    for(var i=_hfrom;i<to;i++) s+=ecHRow(_hrows[i]);
    tb.insertAdjacentHTML('beforeend', s);
    _hfrom=to; ecHInfo();
  }
  window.ecHShowAll = function(){    // [모두 표시] — 남은 줄을 한 번에 (검색·복사용)
    if(_hfrom >= _hrows.length) return;
    var tb=el('ec-hosp').tBodies[0]; if(!tb) return;
    var s=''; for(var i=_hfrom;i<_hrows.length;i++) s+=ecHRow(_hrows[i]);
    tb.insertAdjacentHTML('beforeend', s);
    _hfrom=_hrows.length; ecHInfo();
  };
  function ecHBind(){
    var wrap=el('ec-hospwrap'); if(!wrap || wrap._ecBound) return;
    wrap._ecBound=1;               // 컨테이너는 그대로 있고 안쪽만 갈리므로 한 번만 건다
    wrap.addEventListener('scroll', function(){
      if(_hfrom >= _hrows.length) return;
      if(wrap.scrollTop + wrap.clientHeight >= wrap.scrollHeight - 60) ecHFill();   // 바닥 60px 전에 미리
    });
  }
  /* 구조·진료·종합 **평균** — 표 맨 아래 고정줄(2026-07-28 요청).
       ★글로 늘어놓지 않고 **표의 칸에 맞춰** 찍는다 — 숫자가 구조·진료·종합 머리글 바로 아래로 온다.
         (칸 순서: 1 체크 · 2 병원명 · 3 구분 · 4 구조 · 5 진료 · 6 종합)
       ★모집단은 좌측 지표 평균과 **같다** — 대상(Y) 이고 체크가 켜진 병원만.
         그래서 체크를 끄면 이 줄도 같이 바뀌어 좌측 지표 평균과 늘 짝이 맞는다.
       ★스크롤해도 보이게 sticky 로 바닥에 붙인다(51곳을 훑는 동안 기준값이 사라지면 소용없다). */
  function ecHFoot(){
    var s=0, c=0, t=0, k=0;
    for(var i=0;i<_hosp.length;i++){
      var r=_hosp[i], cd=String(r.hospCd||'');
      if(String(r.targetGb||'')!=='Y' || _excl[cd]) continue;
      s+=n(r.structScore); c+=n(r.careScore); t+=n(r.totalScore); k++;
    }
    if(!k) return '';
    return '<tfoot><tr class="ec-favg">'
         + '<td></td>'
         + '<td class="txt">평균 <b>'+k+'</b>곳</td>'
         + '<td></td>'
         + '<td>'+f2(s/k)+'</td>'
         + '<td>'+f2(c/k)+'</td>'
         + '<td>'+f2(t/k)+'</td>'
         + '</tr></tfoot>';
  }
  function ecHInfo(){
    var pg=el('ec-hpager'); if(!pg) return;
    var tot=_hrows.length, shown=Math.min(_hfrom, tot), left;
    if(shown >= tot){
      left = (tot > EC_ROWS) ? ('총 <b>'+tot.toLocaleString()+'</b>행 — 모두 표시됨') : '';
    } else {
      left = shown.toLocaleString()+' / <b>'+tot.toLocaleString()+'</b>행'
           + ' <span style="color:#9aa7b3">— 아래로 스크롤하면 이어서 나옵니다</span>'
           + ' <button type="button" onclick="ecHShowAll()" title="남은 행을 한 번에 펼칩니다(검색·복사용)">모두 표시</button>';
    }
    /* ★반드시 한 덩어리(span)로 넣는다 — .ec-pager 가 flex 라 글자와 <b> 가 **각각 항목**이 되어
         "총   51   행" 처럼 좌우로 흩어진다(2026-07-28 실제로 그렇게 나왔다). */
    pg.innerHTML = '<span>'+left+'</span>';   // 평균은 표 안 고정줄(tfoot)로 옮겼다 — 여기는 행수·[모두 표시]만
  }

  /* ★[이력] 왼쪽이 가려지던 문제는 가로 스크롤이 아니라 **래퍼 누락**이었다(2026-07-28).
       화면 맨 위 .dashboard-wrapper 주석 참고. 한때 scrollRestoration·scrollLeft 되돌리기를 넣었다가
       진단 결과(페이지 scrollX = 0, 이 화면 left = 0, 밀린 곳 없음)로 원인이 아님이 확인돼 전부 걷어냈다.
       같은 증상이 또 보이면 **먼저 래퍼부터** 확인할 것 — 스크롤을 의심하면 또 시간을 버린다. */

  ecLoad();
});
</script>
</div>
</div><%-- /.dashboard-wrapper --%>
