<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- qpsHelp.jsp — QPS 사용 안내 (2026-08-09)
     · 병원 담당자용 매뉴얼. 정적 화면이라 내용 수정 = 이 파일 교체(재기동 불필요).
     · 화면 캡처 대신 글·표로 쓴다 — 캡처는 화면이 바뀔 때마다 낡는다.
     · ★주의: 이 파일 안에서 Deferred EL 표기(샵+중괄호) 금지 --%>

<div class="dashboard-wrapper">
<div id="qpsHelp">
<style>
  #qpsHelp{ background:#f4f6f8; color:#1f2a30; min-height:100%; padding:14px 16px 60px; max-width:100%; overflow-x:hidden; }
  #qpsHelp *{ box-sizing:border-box; }
  #qpsHelp .qh-wrap{ max-width:900px; }
  #qpsHelp .qh-head{ display:flex; align-items:center; gap:10px; margin-bottom:6px; }
  #qpsHelp .qh-title{ font-size:19px; font-weight:800; color:#20303a; display:flex; align-items:center; gap:8px; }
  #qpsHelp .qh-dot{ width:10px; height:10px; border-radius:50%; background:linear-gradient(135deg,#1f5a4b,#2a7665); }
  #qpsHelp .qh-lede{ font-size:13px; color:#5b6b74; margin:0 0 14px; line-height:1.7; }

  /* 목차 */
  #qpsHelp .qh-toc{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:12px 16px; margin-bottom:16px;
      display:flex; flex-wrap:wrap; gap:6px 14px; font-size:13px; }
  #qpsHelp .qh-toc a{ color:#1f5a4b; text-decoration:none; font-weight:600; }
  #qpsHelp .qh-toc a:hover{ text-decoration:underline; }

  #qpsHelp section{ background:#fff; border:1px solid #e3e9ed; border-radius:10px; padding:16px 18px; margin-bottom:14px;
      scroll-margin-top:14px; }
  #qpsHelp h4{ margin:0 0 10px; font-size:15px; font-weight:800; color:#1f5a4b; padding-bottom:6px; border-bottom:1px solid #e8eef1; }
  #qpsHelp h5{ margin:14px 0 6px; font-size:13.5px; font-weight:800; color:#20303a; }
  #qpsHelp p, #qpsHelp li{ font-size:13.5px; line-height:1.8; color:#2c3a42; }
  #qpsHelp p{ margin:0 0 8px; }
  #qpsHelp ol, #qpsHelp ul{ margin:0 0 8px; padding-left:22px; }
  #qpsHelp b{ color:#1f5a4b; }
  #qpsHelp .qh-tag{ display:inline-block; font-size:11.5px; font-weight:700; border-radius:4px; padding:1px 7px;
      background:#eef2f5; color:#556570; margin-right:3px; }
  #qpsHelp .qh-note{ background:#f7fbf9; border:1px solid #d9e8e2; border-radius:8px; padding:9px 12px;
      font-size:12.5px; color:#3d5049; margin:8px 0; line-height:1.7; }
  #qpsHelp .qh-warn{ background:#fff8f0; border:1px solid #f0dcc0; border-radius:8px; padding:9px 12px;
      font-size:12.5px; color:#8a5a20; margin:8px 0; line-height:1.7; }
  #qpsHelp table{ width:100%; border-collapse:collapse; font-size:12.5px; margin:8px 0; }
  #qpsHelp th, #qpsHelp td{ border:1px solid #dde5ea; padding:6px 9px; text-align:left; vertical-align:top; line-height:1.6; }
  #qpsHelp th{ background:#f2f6f8; font-weight:700; white-space:nowrap; }
  #qpsHelp .st{ font-size:11px; font-weight:700; border-radius:10px; padding:1px 8px; white-space:nowrap; }
  #qpsHelp .st.on{ background:#e4f3ea; color:#1f7a52; }
  #qpsHelp .st.auto{ background:#e7eff8; color:#2f5f96; }
  #qpsHelp .st.off{ background:#f3f5f6; color:#94a3ab; }
  /* -- 글자 크기 (2026-08-18 요청) : QI 계획서(qpsQiPlan)와 같은 모양.같은 조작 */
  #qpsHelp .zz-zoom{ display:inline-flex; gap:4px; align-items:center; margin-left:2px; margin-right:14px; }
  #qpsHelp .zz-zoom button{ border:1px solid #cfd9e0; background:#fff; color:#43555f; border-radius:6px;
                        padding:4px 9px; font-size:13px; font-weight:700; cursor:pointer; }
  #qpsHelp .zz-zoom button:hover{ background:#eef3f6; }
</style>

<div class="qh-wrap">
  <div class="qh-head"><div class="qh-title"><span class="qh-dot"></span>QPS(질향상·환자안전) 사용 안내</div>
  <span style="flex:0 0 12px;"></span>
  <%-- 글자 크기 - 이 PC 이 브라우저에만 저장된다 --%>
  <span class="zz-zoom">
    <button type="button" onclick="zzZoom(-1);" title="글자 작게">가－</button>
    <button type="button" onclick="zzZoom(1);"  title="글자 크게">가＋</button>
    <button type="button" onclick="zzZoom(0);"  title="처음 크기로">↺</button>
  </span>
  </div>
  <p class="qh-lede">
    QPS 는 의료기관 인증평가의 질향상·환자안전 지표를 관리하는 메뉴입니다.
    <b>원천 자료(사고보고·관찰기록·월별 값)만 입력하면 지표는 자동으로 계산됩니다</b> — 율을 손으로 계산해 적는 일이 없습니다.
    분석과 개선계획을 쓰고 결재를 거치면, 인증 심사에 제출할 수 있는 A4 보고서가 나옵니다.
  </p>

  <div class="qh-toc">
    <a href="#h1">1. 시작하기</a><a href="#h2">2. 지표 현황</a><a href="#h3">3. 자료 입력(유형별)</a>
    <a href="#h4">4. 지표분석</a><a href="#h5">5. 결재</a><a href="#h6">6. 인쇄</a>
    <a href="#h7">7. 지표정의서</a><a href="#h8">8. 문제 해결</a>
  </div>

  <section id="h1">
    <h4>1. 시작하기</h4>
    <p>상단의 <b>[QPS]</b> 탭을 누르면 왼쪽 메뉴가 QPS 전용으로 바뀝니다 — <b>지표 현황 · 지표정의서 · 지표분석보고서 · 서식</b>.</p>
    <p>지표 화면 상단 오른쪽의 <b>년도</b>를 바꾸면 그 해 자료로 전환됩니다. 화면 머리의
      <b>🏥 병원 배지</b>는 지금 조회·입력되는 병원입니다.</p>
    <%-- 이 경고는 여러 병원을 오가는 위너넷 계정에만 해당한다 — 일반병원은 자기 병원으로
         로그인하므로 보여줄수록 혼란만 준다(2026-08-09 사용자 지적). --%>
    <c:if test="${wnnYn eq 'Y'}">
    <div class="qh-warn">⚠ 여러 병원을 관리하는 계정(위너넷)은 상단 [병원검색]으로 대상 병원을 먼저 고르세요.
      병원을 바꾸지 않고 입력하면 다른 병원 자료로 저장됩니다. <b>입력 전에 병원 배지를 반드시 확인하세요.</b></div>
    </c:if>
  </section>

  <section id="h2">
    <h4>2. 지표 현황 — 첫 화면</h4>
    <p>지표 18종이 <b>영역별</b>(환자안전 · 감염관리 · 인권·행동제한 · 진료지원·서비스 · 직원안전)로 카드로 나옵니다.
      카드를 누르면 그 지표의 입력·분석 화면으로 들어갑니다.</p>
    <table>
      <tr><th style="width:110px;">표시</th><th>뜻</th></tr>
      <tr><td><span class="st on">입력됨 N</span></td><td>그 해에 입력된 자료가 N 건 있음 (수기형은 건수 없이 <span class="st on">입력됨</span>)</td></tr>
      <tr><td><span class="st auto">자동집계</span></td><td>환자평가표에서 자동 산출 — <b>입력할 것이 없음</b> (욕창·요로감염)</td></tr>
      <tr><td><span class="st off">입력 전</span></td><td>아직 자료가 없어 지표가 '-' 로 나옴</td></tr>
      <tr><td><span class="qh-tag">정의서 미작성</span></td><td>병원 정의서를 아직 안 채움 — 인증 제출 전에 채워야 할 목록</td></tr>
    </table>
  </section>

  <section id="h3">
    <h4>3. 자료 입력 — 지표 유형별</h4>
    <p>지표마다 원천이 달라 입력 탭이 다릅니다. 화면 제목 아래 안내문이 그 지표의 흐름을 알려줍니다.</p>

    <h5>㉮ 사고보고형 — 낙상 · 환자안전사고 · 투약오류 · 학대폭력 · 자살자해 · 직원안전 <span class="qh-tag">사고보고 탭</span></h5>
    <ol>
      <li><b>[사고보고]</b> 탭에서 사고를 건별로 등록합니다. 환자 칸에 등록번호나 성명을 치면 입원환자 후보가 떠서
          고르면 성별·나이·병동이 자동으로 채워집니다(직접 입력도 가능. 직원안전사고는 대상이 직원이라 검색 없음).</li>
      <li><b>[재원일수(분모)]</b> 탭에서 <b>[⚙ 입퇴원 자료로 자동계산]</b>을 누르면 월별 재원일수가 채워집니다.
          값을 확인하고 <b>[저장]</b> — 저장은 항상 사람이 합니다. (직원안전은 재원일수 대신 <b>월별 직원수</b>를 직접 입력)</li>
    </ol>
    <div class="qh-note">✔ 위해등급은 <b>낙상만 Level 2 이상</b>이 지표 분자에 들어가고, 나머지 사고형은 <b>보고된 전건</b>이
      들어갑니다(등급은 분석용). 등록 화면 제목 옆에도 그 지표의 기준이 표시됩니다.</div>

    <h5>㉯ 평가표 자동형 — 욕창 · 요로감염 <span class="qh-tag">입력 없음</span></h5>
    <p>환자평가표에서 자동 집계됩니다. 재원일수(분모)만 있으면 지표가 바로 나옵니다.</p>

    <h5>㉰ 관찰형 — 손위생 · 격리지침 · 강박지침 <span class="qh-tag">관찰 입력 탭</span></h5>
    <p><b>[관찰 입력]</b> 탭에서 관찰일·병동·직군과 <b>관찰(시행)건수·수행건수</b>를 등록합니다.
      수행률 = 수행 ÷ 관찰 × 100 이 자동 계산됩니다. 손위생은 순간(moment)도 고를 수 있습니다.
      재원일수는 쓰지 않습니다.</p>

    <h5>㉱ 월별 수기형 — 신체보호대 · 영상/검체 TAT · 재택복귀 · 불만고충 · 만족도 <span class="qh-tag">월별 입력 탭</span></h5>
    <p>원천 대장(사용대장·TAT 관리대장·처리대장·설문 결과)을 보고 <b>[월별 입력]</b> 탭에 월별 분자·분모를 옮겨 적습니다.
      비워 둔 달은 '자료 없음'으로 처리되어 0 과 구분됩니다.</p>
    <div class="qh-note">✔ TAT 두 지표는 <b>정규/응급 상세 행(선택)</b>이 더 있습니다. 적으면 분석 탭에 정규/응급별
      집계표가 나오고, 안 적어도 지표(총계)는 그대로 나옵니다.</div>
  </section>

  <section id="h4">
    <h4>4. 지표분석 — 자동 산출과 서술</h4>
    <ul>
      <li><b>월별 집계 · 분기/반기/연간 표 · 추이 그래프</b>는 전부 서버가 계산합니다. 분기 율은 월별 율의 평균이 아니라
          <b>분기 분자합 ÷ 분모합</b>입니다.</li>
      <li>값이 <b>'-'</b> 로 나오는 것은 오류가 아니라 <b>그 기간에 분모(자료)가 없다</b>는 뜻입니다 — 발생 0 과 구분합니다.</li>
      <li>아래 <b>분석 · 개선계획 · 개선활동</b> 칸에 서술을 쓰고 <b>[서술 저장]</b> — 기간(분기·반기)마다 따로 저장됩니다.
          안 써도 지표 수치에는 영향이 없습니다.</li>
    </ul>
  </section>

  <section id="h5">
    <h4>5. 결재 — 상신부터 최종승인까지</h4>
    <p>지표분석 탭 아래 <b>[결재]</b> 카드에서 진행합니다. 기본 결재선은 <b>담당 → 팀장 → 부서장 → 이사장</b> 4단계이고,
      병원에 맞게 단계를 줄이거나 이름을 바꿀 수 있습니다(관리자 [결재선 설정]).</p>
    <div class="qh-note">✔ 여러 지표의 결재 상태는 왼쪽 메뉴 <b>[지표분석보고서]</b>에서 기간별로 한눈에 봅니다 —
      어느 보고서가 안 됐는지, 결재중인 문서가 몇 건인지 요약되고, 행을 누르면 그 지표로 바로 이동합니다.</div>
    <table>
      <tr><th style="width:96px;">동작</th><th>언제 · 무엇</th></tr>
      <tr><td><b>상신</b></td><td>작성이 끝났을 때. 상신하면 <b>서술을 고칠 수 없습니다.</b></td></tr>
      <tr><td><b>승인</b></td><td>각 단계 담당자가 차례로 누릅니다. 결재란에 이름·일시가 찍힙니다(전자서명).</td></tr>
      <tr><td><b>반려</b></td><td>사유를 적어 되돌립니다. 수정 후 처음부터 다시 상신합니다.</td></tr>
      <tr><td><b>상신 회수</b></td><td>아무도 승인하기 전이면 상신을 거둘 수 있습니다.</td></tr>
      <tr><td><b>확정 취소</b></td><td>최종승인 뒤에도 사유를 적고 되돌릴 수 있습니다. 이력에 남습니다.</td></tr>
    </table>
    <div class="qh-note">✔ 마지막 단계가 승인되면 <b>그 기간 수치가 확정(동결)</b>됩니다 — 이후 원천 자료가 바뀌어도
      제출한 보고서의 숫자는 변하지 않습니다. 확정을 취소하면 동결도 풀립니다.</div>
  </section>

  <section id="h6">
    <h4>6. 인쇄 — 제출용 A4</h4>
    <ul>
      <li>결재 카드의 <b>[🖨 인쇄(A4)]</b> — 결재란·지표정의·월별/분기표·추이·분석/개선계획이 담긴 보고서가 새 창으로 열립니다.</li>
      <li>인쇄 창에서 <b>'PDF로 저장'</b>을 고르면 파일명이 「지표명 지표분석보고서_병원명_기간」으로 자동 제안됩니다.</li>
      <li>종이 위·아래의 날짜·페이지번호까지 없애려면 인쇄 설정의 <b>[추가 설정] → [머리글 및 바닥글]</b> 체크를 끄세요(한 번 끄면 유지).</li>
      <li>확정(동결)된 기간을 인쇄하면 <b>확정값</b>으로 나가고, 하단에 확정 표시가 붙습니다.</li>
    </ul>
  </section>

  <section id="h7">
    <h4>7. 지표정의서 — 병원이 채우는 양식</h4>
    <ul>
      <li>왼쪽 메뉴 <b>[지표정의서]</b>에서 지표를 골라 선정배경·포함/제외기준·목표값·담당 등을 채우고 <b>[저장]</b> 합니다.</li>
      <li>저장 전에는 <span class="qh-tag">공통 기본값</span>(표준 문구)이 보이고, 저장하면 <span class="qh-tag">우리 병원 정의서</span>가
          됩니다 — <b>다른 병원에는 영향이 없습니다.</b> [공통값으로 되돌리기]로 언제든 초기화됩니다.</li>
      <li>산식·상수·집계방식은 화면에서 바꿀 수 없습니다(지표가 틀어지는 것을 막기 위해 위너넷이 관리).</li>
      <li><b>[🖨 인쇄(A4)]</b>로 결재란이 달린 정의서 1장이 나옵니다.</li>
    </ul>
  </section>

  <section id="h8">
    <h4>8. 문제 해결</h4>
    <table>
      <tr><th style="width:250px;">증상</th><th>원인 · 해결</th></tr>
      <tr><td>지표값이 전부 '-' 로 나온다</td>
          <td><b>분모가 없는 것</b>입니다. [재원일수(분모)] 탭에서 자동계산 후 저장하세요.
              (관찰형은 관찰 기록, 수기형은 월별 값이 분모입니다)</td></tr>
      <tr><td>입력했는데 자료가 안 보인다</td>
          <td>화면 머리의 <b>년도</b>를 확인하세요 — 다른 해를 보고 있는 경우가 대부분입니다.<c:if test="${wnnYn eq 'Y'}">
              여러 병원을 관리하는 계정은 <b>병원 배지</b>도 함께 확인하세요.</c:if></td></tr>
      <tr><td>서술 저장이 안 된다</td>
          <td>결재 상신 중이거나 최종승인된 문서는 잠깁니다. [상신 회수] 또는 [확정 취소] 후 수정하세요.</td></tr>
      <tr><td>승인을 눌렀는데 "N단계 차례입니다"</td>
          <td>다른 사람이 먼저 승인해 단계가 넘어간 것입니다. 화면을 새로고침하면 현재 단계가 맞춰집니다.</td></tr>
      <tr><td>유형 목록에 우리 병원 항목이 없다</td>
          <td>유형·장소·직군 목록은 공통코드로 관리됩니다. 위너넷 고객센터로 추가를 요청하세요(배포 없이 반영).</td></tr>
      <tr><td>인쇄물 위에 주소·날짜가 찍힌다</td>
          <td>브라우저 머리글입니다. 인쇄 설정의 [머리글 및 바닥글] 체크를 끄세요.</td></tr>
    </table>
    <p style="margin-top:10px;">그 밖의 문의는 화면 왼쪽 아래 <b>고객센터(02-6953-2452)</b> 또는 [1:1 문의하기]로 연락 주세요.</p>
  </section>
</div>
<script>

/* === 글자 크기 (2026-08-18 요청) ==========================================
   QI 계획서(qpsQiPlan)의 zzZoom 과 **같은 규칙** - 0.8~1.6배, 0.1 단위, ↺ 는 처음 크기.
   ★고른 크기는 **이 PC 이 브라우저에만** 남는다(localStorage). 키는 화면마다 따로 둔다. */
(function(){
  var W = 'qpsHelp', ZKEY = 'qpsZoom_' + W;
  /* ⚠**같은 화면이 두 벌 붙어 있을 수 있다**(주소 숨김 구조 - content 를 갈아끼운다).
     getElementById 는 「첫 번째 = 보이지 않는 사본」을 잡아 ***눌러도 아무 일이 없다.***
     ⇒ querySelectorAll 로 **붙어 있는 사본 전부**에 건다. */
  function els(){ return [].slice.call(document.querySelectorAll('#' + W)); }
  function zoom(z){
    z = Math.min(1.6, Math.max(0.8, z));
    els().forEach(function(w){ w.style.zoom = z.toFixed(2); });
    return z;
  }
  window.zzZoom = function(d){
    var e0 = els()[0], c0 = parseFloat(e0 && e0.style.zoom) || 1;
    if (d === 0) { zoom(1); try { localStorage.removeItem(ZKEY); } catch (e) {} return; }
    var z = zoom(c0 + d * 0.1);
    try { localStorage.setItem(ZKEY, String(z)); } catch (e) {}
  };
  try { var z = parseFloat(localStorage.getItem(ZKEY)); if (z) zoom(z); } catch (e) {}
})();
</script>
</div><%-- /#qpsHelp --%>
</div><%-- /.dashboard-wrapper --%>
