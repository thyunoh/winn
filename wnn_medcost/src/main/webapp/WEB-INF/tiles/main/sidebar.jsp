<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<link href="/images/icons/winnernet.ico" rel="icon" type="image/x-icon" >
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<!-- 리치에디터 -->

<!--  
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
-->

<link   href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/lang/summernote-ko-KR.min.js"></script>
<!-- 리치에디터 -->
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!-- ============================================================== -->
<!-- sidebar start -->
<style>
.nav-left-sidebar {
    overflow-y: auto !important;
    overflow-x: hidden !important;
    height: calc(100vh - 60px) !important;
    background-color: white !important;
    width: 280px !important;
}
.dashboard-wrapper {
    margin-left: 280px !important;
}
.dashboard-main-wrapper .main-content {
    margin-left: 280px !important;
}
.nav-left-sidebar .submenu .nav-link {
    white-space: normal !important;
    word-break: keep-all;
    line-height: 1.2;
    padding-top: 3px !important;
    padding-bottom: 3px !important;
}
/* 선택된 메뉴 항목 활성 스타일 */
.nav-left-sidebar .navbar-nav .nav-link.active {
    background-color: #e2e2eb !important;
    color: #3d405c !important;
    font-weight: 600 !important;
    border-radius: 4px;
}
.dashboard-content {
    padding: 10px 10px 60px 10px !important;
}
.nav-left-sidebar .fixed-sidebar-info-box {
    position: sticky;
    bottom: 0;
    background-color: white;
    z-index: 10;
}
/* 파일찾기 버튼 빨간색 제거 */
#asq_main .btn-outline-secondary,
#asq_main .btn-outline-secondary:hover,
#asq_main .btn-outline-secondary:focus,
#asq_main .btn-outline-secondary:active,
#asq_main .btn-outline-secondary:active:focus,
#asq_main .btn-outline-secondary.active {
    color: #000 !important;
    background-color: #fff !important;
    border-color: #bbb !important;
    outline: none !important;
    box-shadow: none !important;
}
#asq_main .btn:focus,
#asq_main .btn:active,
#asq_main .btn:active:focus {
    outline: none !important;
    box-shadow: none !important;
}
</style>
<div class="nav-left-sidebar">
    <div class="menu-list">
        <nav class="navbar navbar-expand-lg navbar-white">
            <a class="d-xl-none d-lg-none" href="#">Dashboard</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" 
                                                                         aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <%-- 자주 쓰는 메뉴 (2026-08-05 최종 확정) — 사이드바 탭이 아니라 <화면과 별개의 상단 고정 가로 바>.
                     관리자(위너넷)에게만 보이고, 접기(›) 상태·클릭수 모두 localStorage(PC별, DB 없음).
                     아래 #wnnFavBar 마크업·스크립트 참조. 사이드바는 종전 그대로. --%>
                <ul class="navbar-nav flex-column" id="sbAllMenu">
                    <li class="nav-divider">
                        Menu
                    </li>
                    <%-- id 는 QPS 탭이 숨겼다 복원하는 데 쓴다(top.jsp) — QPS 화면에서는 대시보드가 무관하다 --%>
                    <li class="nav-item " id="menu-dashboard">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/user/dashboard.do"><i class="fas fa-chart-bar"></i>DashBoard</a>
                    </li>
                    
                    <li class="nav-item menu-section" id="menu-b">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#file-upload" aria-controls="file-upload">
                                                                                      <i class="fas fa-cloud-upload-alt"></i>자료올리기</a>
                        <div id="file-upload" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/main/magamFileUpload.do">청구.평가 업로드</a>
                                </li>
                                <%-- 청구·평가 업로드(현황) — 위너넷 관리자 전용(2026-08-05 요청).
                                     기본은 숨김(display:none), 아래 스크립트가 s_wnn_yn='Y' 일 때만 보인다.
                                     ※ 메뉴만 감추면 주소를 직접 쳐서 들어올 수 있어 컨트롤러에서도 막아 두었다. --%>
                                <li class="nav-item" id="adminUploadStatMenu" style="display:none;">
                                    <a class="nav-item nav-link"  href="/main/uploadStat.do">샘파일 업로드 현황</a>
                                </li>
                                <li class="nav-item">
                              <a class="nav-item nav-link" href="#" data-toggle="collapse" aria-expanded="false" 
                                data-target="#lic_excel" aria-controls="lic_excel">기타.자료 업로드
                              </a>
                              <div id="lic_excel" class="collapse submenu" style="background-color: white;">
                                  <ul class="nav flex-column">
                                      <li class="nav-item">
                                          <a class="nav-item nav-link" href="/user/licexcel.do">인력신고현황 엑셀</a>
                                      </li>
                                  </ul>
                              </div>
                        </li>                                     
                            </ul>
                        </div>
                    </li>
                    
                    <li class="nav-item menu-section" id="menu-c">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/total_Report.do" ><i class="fa fa-calculator"></i>진료비-분석 현황</a>
                    </li>

                    <li class="nav-item menu-section" id="menu-d">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/assessment.do" >
                        <i class="fa fa-list-ol" aria-hidden="true"></i>적정성-평가 현황</a>
                    </li>

                    <!-- 적정성평가 월간보고서 목록 — 2단계: 전원 노출(위너넷·일반병원 무관). menu-section 이 아니라 top.jsp 탭/계약 필터 영향 없음.
                         일반병원(거래처)은 listEvalReport 컨트롤러가 hospCd 를 본인(s_hospid)으로 강제 → 본인 병원만 조회됨(위너넷만 전체). -->
                    <li class="nav-item" id="menu-evalreport" style="display:none;">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/evalReportList.do" ><i class="fa fa-file-text"></i>적정성평가 월간보고서</a>
                    </li>
                    
                    <li class="nav-item" id="simulation">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/simulation.do" >
                        <i class="fa fa-cart-plus" aria-hidden="true"></i>적정성-Simulation</a>
                    </li>
                    
                    
                    <li class="nav-item menu-section" id="menu-e">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/main/assesCheck.do"><i class="fa fa-check-circle"></i>적정성-평가 점검</a>
                    </li>

                    <!-- ===== QPS(질향상·환자안전) — 적정성평가와 별개 업무 =====
                         ★2026-08-09 메뉴 정리: 지표 18종을 여기 늘어놓지 않는다.
                           [지표 현황] 화면 하나로 모으고 그 안에서 영역별로 고르게 했다 —
                           지표를 늘려도 메뉴는 그대로이고, 정의서·분석보고서·서식이 들어갈 자리가 생긴다.
                         ★기본 숨김. 위너넷(s_wnn_yn='Y') + 개발자 플래그일 때만 보인다(입력칸 밖에서 q·p·s 타이핑).
                         ★menu-section 이 아니다 — top.jsp 탭/계약 필터의 영향을 받지 않게.
                         ★정식 오픈 시 : style 의 display:none 과 아래 qpsDev 게이트를 걷어내고
                           계약구분(s_conact_gb)에 QPS 코드를 추가해 top.jsp 탭으로 태운다. -->
                    <li class="nav-item" id="menu-qps" style="display:none;">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="#" data-toggle="collapse"
                           aria-expanded="false" data-target="#qps-sub" aria-controls="qps-sub">
                        <i class="fa fa-heartbeat" aria-hidden="true"></i>QPS-환자안전</a>
                        <%-- ★2026-08-11 메뉴 2단화 — 기존 시스템의 업무 폴더 구조를 그대로 따른다.
                             (사용자 제공 원본 트리: QI / QPS / 감염 / 보고서 / 환자만족도 조사 / 불만고충 / QPS공유)
                             평면 18줄이 한계에 달해 갈랐다. 그룹 하나가 원본 폴더 하나다 —
                             ***항목 이름도 원본 폴더의 문서명을 쓴다***(우리 화면 이름이 아니라).
                             그래야 병원 담당자가 종이 서식 이름으로 메뉴를 찾는다.
                             ★한 화면이 여러 폴더에 걸리는 것이 있다(계획서·회의록·라운딩은 구분값으로 갈린다)
                               — 그래서 감염 그룹의 링크에는 ?gb=I 가 붙는다. 붙이지 않으면 감염 메뉴로
                               들어가도 질향상 문서가 열린다.
                             ★QPS공유는 여기 없다 — 하위가 「간호」·「방사선」이라 계정 공유가 아니라
                               ***부서별 공유 폴더***다(2026-08-11 확인). 부서 업무는 2차 범위라 그때 붙인다. --%>
                        <div id="qps-sub" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">

                                <%-- ── QI (원본 6종) — 통째로 미구현. 링크를 걸면 404 라 안내만 둔다 ── --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-qi" aria-controls="qps-g-qi"
                                       style="font-weight:600;">▸ QI</a>
                                    <div id="qps-g-qi" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsQiPlan.do">QI 계획서</a></li>
                                            <%-- QI 회의록 — 서식 1호(회의록)에 구분 J 로 흡수했다. 주제·차수는 회의명에 적는다 --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=J">QI 회의록</a></li>
                                            <%-- 중간·최종보고서는 한 화면이다(최종이 중간의 상위집합) --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsQiRpt.do">QI 중간·최종보고서</a></li>
                                            <%-- 주제선정 기준표 + 우선순위 집계표 = 한 화면 두 탭.
                                                 원본의 (전년도)/(당해년도)는 연도 셀렉트로 덮인다 --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsQiTopic.do">QI 주제선정 · 우선순위</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsQiFund.do">활동 자원지원 내역</a></li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── QPS (원본 8종) ── --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-qps" aria-controls="qps-g-qps"
                                       style="font-weight:600;">▸ QPS</a>
                                    <div id="qps-g-qps" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsPlan.do">연간 활동계획서</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do">QPS 위원회</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsIndex.do">지표 현황</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsRpt.do">지표분석목록</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsDef.do">지표정의서</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsRound.do">환자안전관리 라운딩 점검표</a></li>
                                            <%-- 격리·강박 시행일지(2026-08-18) — ★지표 ISOLATION/SECLUSION 의 <원천 대장>이다.
                                                 저장하면 그 달 준수율 집계가 함께 갱신된다. 이 자료 없이는 지표가 빈 표다. --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSecLog.do">격리 · 강박 시행일지</a></li>
                                            <%-- RCA — 근본원인 분석 보고서. 회의록은 서식 1호에 구분 R 로 흡수 --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsRca.do">RCA 근본원인 분석</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=R">RCA 회의록</a></li>
                                            <%-- FMEA — 계획서·보고서가 한 화면(문서구분). 회의록은 서식 1호에 구분 F 로 흡수 --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsFmea.do">FMEA 계획서·보고서</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=F">FMEA 회의록</a></li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── 감염 (원본 10종 — 전부 커버됨) ──
                                     계획서·위원회·라운딩은 QPS 와 같은 화면이고 구분(FORM_GB)만 I 다. --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-inf" aria-controls="qps-g-inf"
                                       style="font-weight:600;">▸ 감염</a>
                                    <div id="qps-g-inf" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsPlan.do?gb=I">감염관리계획서</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=I">감염관리위원회</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsRound.do?gb=I">감염라운딩</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsFall.do?indi=INFEXP">직원감염노출사고분석보고서</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsFall.do?indi=HANDWASH">손위생수행률</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsFall.do?indi=UTI">요로감염</a></li>
                                            <%-- 유치도뇨관 월별 기록지(2026-08-18) — ★바로 위 요로감염 지표의 <분모>다.
                                                 보유 환자 수의 월 합계가 유치도뇨관 일수(device-day)로 넘어간다. --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsCathDay.do">유치도뇨관 월별 기록지</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsInfRisk.do">감염관리 우선순위 사정 도구</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsInfStaff.do">감염관리 전담자(담당)</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsInfPat.do">감염병환자</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsInfRpt.do">감염종합보고</a></li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── 부서별 점검표 (2026-08-15 — 담당자 위주 직관 메뉴) ──────
                                     ★담당자가 제 부서를 눌러 바로 제 점검표로 들어간다.
                                     화면은 전부 qpsChk 하나 — dept 파라미터가 부서 셀렉트를 미리 골라 준다.
                                     ⚠부서코드는 QPS_CHK_DEPT 공통코드와 같아야 한다(모르는 값이면 전체로 열림).
                                     주소가 서로 달라(쿼리 상이) 강조 중복 함정 없음.
                                     ★★***점검표가 <있는> 부서만 건다*** (2026-08-15 점검에서 잡음) —
                                       부서 코드 15개 중 **감염관리·진료는 그 부서 점검표가 0종**이다
                                       (감염관리는 전용 화면 묶음으로 구현됐고, 진료 3종은 safeRpt·중복 제외로 갔다).
                                       ⚠빈 화면이 나오는 게 아니라 **공통 서식(MSDS 2종)만** 뜬다(실측) —
                                         담당자가 「우리 부서 점검표는 이것뿐인가」로 잘못 읽는다. 그래서 뺐다.
                                     ★★[2026-08-18] ***손으로 줄을 더하고 빼는 일을 없앴다*** —
                                       `qps/deptMenu.do` 가 **서식이 있는 부서만** 돌려주고 아래 스크립트가 다시 그린다.
                                       (실제로 08-15 에 손으로 지운 감염관리가 08-18 에 서식이 생겨 다시 넣어야 했다.)
                                       ***아래 하드코딩 줄은 폴백이니 지우지 말 것.*** --%>
                                <%-- ★★[2026-08-18 사용자 지시] ***중복 메뉴라 감춘다.***
                                     이 14줄은 전부 `qpsChk.do?dept=코드` — **[점검표 작성]과 같은 화면**이고,
                                     그 화면에도 부서 셀렉트가 있다. 게다가 [우리 병원 사용 서식]이 **부서 축**으로 바뀌어
                                     「부서별로 고른다」는 그쪽에서 한다. ⇒ 메뉴만 길어지고 하는 일이 겹친다.
                                     ★***지우지 않고 감췄다*** — 줄과 자동 채우기(deptMenu)는 그대로다.
                                       되살리려면 아래 li 의 `style="display:none;"` 한 군데만 지우면 된다. --%>
                                <li class="nav-item" id="qps-g-dept-li" style="display:none;">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-dept" aria-controls="qps-g-dept"
                                       style="font-weight:600;">▸ 부서별 점검표</a>
                                    <div id="qps-g-dept" class="collapse submenu" style="background-color:#fff;">
                                        <%-- ★[2026-08-18] 이 줄들은 **자료에서 다시 그려진다**(qpsDeptMenu 아래 스크립트).
                                             아래 하드코딩은 ***폴백***이다 — 조회를 못 하면 이 줄이 그대로 보인다.
                                             ⚠지우지 말 것. 메뉴가 통째로 비면 업무가 멈춘다. --%>
                                        <ul class="nav flex-column" id="qps-dept-list">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=NURSE">간호 · 병동</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=PHARM">약국</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=NUTRI">영양</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=FACIL">시설</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=LAB">진단검사</a></li>
                                            <%-- 감염관리 : 점검표 0종 — [QPS] 그룹의 감염관리 묶음이 전용 화면이다 --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=HEALTH">보건관리자</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=ADMIN">원무 · 총무</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=RENAL">인공신장</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=MEDREC">의무기록</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=RADIO">방사선</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=REHAB">물리재활</a></li>
                                            <%-- 진료 : 점검표 0종 — DR01 은 당직일지(중복 제외), DR02·03 은 [보고서·서식]의 영양상담 --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=SOCIAL">사회복지</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=COMMON">공통</a></li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── 부서 위원회 (2026-08-12) ──────────────────────────────
                                     ★***회의록은 화면 하나다.*** 약사·영양관리·소방안전관리 회의록이
                                     우리 회의록 화면과 **판박이**라 구분(FORM_GB)만 다르다 —
                                     ***새 화면이 아니라 링크 세 줄이 전부다***
                                     (약국 판정 §3-2 · 영양 판정 §1-4 · 시설 판정 §5).
                                     ⚠조직도·내규는 여기가 아니다 — **그림·자유 문서**라 자료실로 간다. --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-cmt" aria-controls="qps-g-cmt"
                                       style="font-weight:600;">▸ 부서 위원회</a>
                                    <div id="qps-g-cmt" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=P">약사위원회</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=N">영양관리위원회</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=S">소방안전관리위원회</a></li>
                                            <%-- ★다학제 평가팀(2026-08-13) — 간호/병동 캡처 246·248(정기/임시=M)·292(개최에 따른=K).
                                                 K 는 원본에만 있는 「격리 및 강박 시행시간」 칸이 있다(SEC_TIME). --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=M">다학제 평가팀</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=K">다학제(개최)</a></li>
                                            <%-- ★원무총무 3형제(2026-08-14) — w01~06 운영위 여섯 판이 한 판(월은 회의 일시가 담는다).
                                                 ⚠인사위원회 gb=H — 'P' 는 약사위원회가 먼저 쓴다(코드 충돌 정정 이력). --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=W">운영위원회</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=C">중독연구소 운영위</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsMinutes.do?gb=H">인사위원회</a></li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── 보고서 (원본 11종) — 미구현. 다음 작업 후보 1순위 ── --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-rpt" aria-controls="qps-g-rpt"
                                       style="font-weight:600;">▸ 보고서 · 서식</a>
                                    <div id="qps-g-rpt" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <%-- 사고 유형별 보고서 — 한 화면 + 유형(체크 묶음은 항목표에서 온다)
                                                 ★계열 링크(2026-08-15) — gb 파라미터가 유형 셀렉트를 미리 골라 준다.
                                                 유형 70종을 담당자가 계열로 찾아 들어가게(셀렉트 안에서도 같은 계열로 묶임). --%>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSafeRpt.do">사고 · 안전 보고서</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSafeRpt.do?gb=EDURPT">교육 · 보건관리 서식</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSafeRpt.do?gb=RULEDRF">인사 · 원무 · 총무 서식</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSafeRpt.do?gb=MRPROXY">의무기록 · 정보보호 서식</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSafeRpt.do?gb=NUTREQ">영양 · 사회복지 서식</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSafeRpt.do?gb=RPTBHEP">검진 · 접종 결과보고서</a></li>
                                            <%-- ★원본은 이 폴더에도 「환자안전관리 라운딩 점검표」를 두지만 링크를 또 걸지 않는다.
                                                 QPS 그룹의 그것과 <같은 문서>이고, 같은 주소를 두 번 걸면
                                                 사이드바 강조가 뒤 링크에 붙는 함정이 있다(2026-08-09 실제로 겪음). --%>
                                            <li class="nav-item">
                                                <span class="nav-item nav-link" style="color:#a8b4bb; font-size:12px; cursor:default;">
                                                    ※ 환자안전관리 라운딩 점검표는 [QPS] 그룹에 있습니다
                                                </span>
                                            </li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── 환자만족도 조사 (원본 6종 → 우리 화면 3개) ──
                                     안내문은 조사 계획서 화면의 카드, 조사결과·지표분석 보고서는 설문 화면의 인쇄다. --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-srv" aria-controls="qps-g-srv"
                                       style="font-weight:600;">▸ 환자만족도 조사</a>
                                    <div id="qps-g-srv" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSrvPlan.do">안내문 · 조사 계획서</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSurvey.do">설문지 · 조사결과 · 지표분석</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsSrvImpr.do">개선활동결과보고서</a></li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── 불만고충 (원본 3종 → 우리 화면 3개) ──
                                     처리대장과 개선활동처리결과는 목록↔상세라 한 화면 두 탭이다. --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-cmpl" aria-controls="qps-g-cmpl"
                                       style="font-weight:600;">▸ 불만고충</a>
                                    <div id="qps-g-cmpl" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsCmplPlan.do">처리계획서</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsCmpl.do">처리대장 · 개선활동처리결과</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsCmplRpt.do">지표분석보고서</a></li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── 점검표 (2차 — 간호/병동·약국·영양·시설 공용 엔진) ──
                                     ★서식은 코드가 아니라 데이터다. 새 점검표는 [서식 관리]에서 등록한다.
                                     ★[서식 관리]는 위너넷 전용 — 아래 스크립트가 s_wnn_yn='Y' 일 때만 보인다.
                                       (컨트롤러에서도 막는다. 주소를 직접 쳐도 병원 계정은 작성 화면으로 간다.) --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-chk" aria-controls="qps-g-chk"
                                       style="font-weight:600;">▸ 점검표</a>
                                    <div id="qps-g-chk" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do">점검표 작성</a></li>
                                            <%-- 우리 병원 사용 서식 — ★[2026-08-18 저녁 사용자 확정] ***우리가 정한다.***
                                                 병원에게는 안 보인다(스스로 고르지 않는다) ⇒ **위너넷 전용**으로 돌렸다.
                                                 위너넷이 [기본 설정] 또는 병원코드로 **대신** 켠다.
                                                 ★되살리려면(병원도 고르게 하려면) : 아래 li 의 id·display 를 지우고
                                                   아래 위너넷 블록의 qpsChkUseMenu 두 줄, 그리고
                                                   QpsController.qpsChkUse 의 isWnn 게이트를 함께 뺀다. --%>
                                            <li class="nav-item" id="qpsChkUseMenu" style="display:none;">
                                                <a class="nav-item nav-link" href="/main/qpsChkUse.do">우리 병원 사용 서식 <span style="font-size:11px;color:#8a99a3;">(위너넷)</span></a></li>
                                            <li class="nav-item" id="qpsChkFormMenu" style="display:none;">
                                                <a class="nav-item nav-link" href="/main/qpsChkForm.do">서식 관리 <span style="font-size:11px;color:#8a99a3;">(위너넷)</span></a></li>
                                            <%-- 부서별 양식(2026-08-18) — ★서식 관리는 한 서식의 모든 칸을 다뤄
                                                 「어느 양식이 어느 부서 것인가」가 한눈에 안 들어온다(사용자).
                                                 그것만 보는 자리. 공통 서식을 고치므로 위너넷 전용이다. --%>
                                            <li class="nav-item" id="qpsDeptFormMenu" style="display:none;">
                                                <a class="nav-item nav-link" href="/main/qpsDeptForm.do">부서별 양식 <span style="font-size:11px;color:#8a99a3;">(위너넷)</span></a></li>
                                            <%-- 부서별 쓰는 분류(2026-08-18) — 서식을 만들 때 고를 분류를 부서마다 정해 둔다.
                                                 ★정한 것이 없는 부서는 전 분류(막는 장치가 아니라 좁혀 주는 장치).
                                                 서식 관리와 같은 갈래라 **위너넷 전용**이다(서버도 막는다). --%>
                                            <%-- ★[2026-08-18] ***메뉴 줄을 뺐다 — 중복이다.***
                                                 이 화면은 **서식을 만들 때** 쓰는 규칙이라 들어가는 길이
                                                 [서식 관리] 분류 칸 옆의 **[부서별 분류 정하기]** 링크로 이미 있다.
                                                 (화면·주소 `main/qpsDeptCate.do` 는 그대로 살아 있다.) --%>
                                            <li class="nav-item" id="qpsDeptCateMenu" style="display:none;" hidden>
                                                <a class="nav-item nav-link" href="/main/qpsDeptCate.do">부서별 쓰는 분류 <span style="font-size:11px;color:#8a99a3;">(위너넷)</span></a></li>
                                            <%-- ★사용자별 담당 부서(2026-08-15) — 담당자가 제 부서 서식만 보게 한다.
                                                 ***등록이 없으면 전 부서*** 라 안 써도 지금과 똑같이 돈다. --%>
                                            <%-- ★[2026-08-18 저녁] 설정 화면이라 **위너넷 전용**으로 돌렸다
                                                 (「병원은 설정 못 한다 — 전산 요원이 없어서」).
                                                 병원 담당자에게는 [점검표 작성] 하나만 남는다. --%>
                                            <li class="nav-item" id="qpsUserDeptMenu" style="display:none;">
                                                <a class="nav-item nav-link" href="/main/qpsUserDept.do">사용자별 담당 부서 <span style="font-size:11px;color:#8a99a3;">(위너넷)</span></a></li>
                                        </ul>
                                    </div>
                                </li>

                                <%-- ── 공통 — 원본에 없는 우리 화면 ── --%>
                                <li class="nav-item">
                                    <a class="nav-item nav-link" href="#" data-toggle="collapse"
                                       aria-expanded="false" data-target="#qps-g-etc" aria-controls="qps-g-etc"
                                       style="font-weight:600;">▸ 공통</a>
                                    <div id="qps-g-etc" class="collapse submenu" style="background-color:#fff;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsLib.do">자료실</a></li>
                                            <li class="nav-item"><a class="nav-item nav-link" href="/main/qpsHelp.do">사용 안내</a></li>
                                        </ul>
                                    </div>
                                </li>

                            </ul>
                        </div>
                    </li>
                    <li class="nav-item menu-section" id="menu-a">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#user-info" aria-controls="user-info">
                                                                                      <i class="fa fa-building" aria-hidden="true"></i></i>요양기관등록</a>
                        <div id="user-info" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item" id="hospuser1">
                                    <a class="nav-item nav-link"  href="/user/license.do">라이센스면허등록</a>
                                </li>
                                <li class="nav-item" id="hospuser2">
                                    <a class="nav-item nav-link"  href="/user/licnumber.do">인력신고현황등록</a>
                                </li>
                                <li class="nav-item" id="hospuser3">
                                    <a class="nav-item nav-link"  href="/user/dietcd.do">가산식대등록</a>
                                </li>
                                
                                
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/pusercd.do">사용자등록</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/user/userauthcd.do">사용자권한관리</a>
                                </li>
                                 
                                <li class="nav-item" id="hospuser4">
                                    <a class="nav-item nav-link"  href="/user/wardcd.do">병동현황등록</a>
                                </li>
                                <li class="nav-item"  id="hospuser5">
                                    <a class="nav-item nav-link"  href="/user/hospgrdcd.do">의사간호사등급현황</a>
                                </li>
                           </ul>
                        </div>
                    </li>
                    
                    <!-- 기준정보 -->
                    <li class="nav-item menu-section" id="menu-h">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info" aria-controls="base-info">
                                                                                                            <i class="fa fa-copyright" aria-hidden="true"></i>기준정보</a>
                        <div id="base-info" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info-1" 
                                                                                                                aria-controls="base-info-1">각종코드 관리</a>
                                    <div id="base-info-1" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item" id = "comcode">
                                                <a class="nav-item nav-link"  href="/base/commcd.do">공통코드</a>
                                            </li>
                                   <li class="nav-item">
                                       <a class="nav-item nav-link" href="#" data-toggle="collapse" aria-expanded="false" 
                                         data-target="#hira-code" aria-controls="hira-code">심평원고시코드
                                       </a>
                                       <div id="hira-code" class="collapse submenu" style="background-color: white;">
                                           <ul class="nav flex-column">
                                               <li class="nav-item">
                                                   <a class="nav-item nav-link" href="/base/sugacd.do">수가코드</a>
                                               </li>
                                               <li class="nav-item">
                                                   <a class="nav-item nav-link" href="/base/yakgacd.do">약가코드</a>
                                               </li>
                                               <li class="nav-item">
                                                   <a class="nav-item nav-link" href="/base/jaeryocd.do">재료대코드</a>
                                               </li>
                                           </ul>
                                       </div>
                                   </li>                                         
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/disecd.do">상병코드</a>
                                            </li>
                                            <li class="nav-item" id = "ratecode">
                                                <a class="nav-item nav-link"  href="/base/claimcd.do">유형별 청구율관리</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item" id="samcode">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info-2" 
                                                                             aria-controls="base-info-2">기준코드 관리</a>
                                    <div id="base-info-2" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/samvercd.do">샘파일 버전</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/samvercdV1.do">샘파일 버젼(v1.0)</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/wvalcd.do">적정성지표</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/base/specsuga.do">특정코드관리</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item"  id="hospcont">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#base-info-3" 
                                                                             aria-controls="base-info-3">병원정보 관리</a>
                                    <div id="base-info-3" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                           <li class="nav-item">
                                               <a class="nav-item nav-link" href="/user/hospcd.do">계약관리</a>
                                           </li>
                                           <%-- 이메일정보 메뉴는 2026-07-30 제거 — 계약관리 화면(hospcd.jsp) 하단
                                                [이메일정보] 패널로 들어갔다(선택한 병원 기준, 계약정보·사용자정보와 같은 자리).
                                                별도 화면(mangr/hospEmail.jsp, /user/hospEmail.do)은 남아 있지만 메뉴에서 빠져 쓰지 않는다. --%>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/user/wnnauthcd.do">위너넷권한관리</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/user/mbrcd.do">회원가입현황</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="">수납관리</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/chung/chgsimsa.do">청구심사조회</a>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                             </ul>
                        </div>
                    </li>
                     <li class="nav-item" id = "wnnauth1">
						<a class="nav-item nav-link" href="#" data-toggle="collapse" aria-expanded="false"
						   data-target="#base-info-4" aria-controls="base-info-4">
						   <i class="fas fa-comments"></i> 고객지원
						</a>
                        <div id="base-info-4" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
								<li class="nav-item">
								    <a class="nav-item nav-link" href="/mangr/noticd.do">공지사항</a>
								</li>
								<li class="nav-item">
								    <a class="nav-item nav-link" href="/mangr/noticd2.do">심 사 방</a>
								</li>
								<li class="nav-item">
								    <a class="nav-item nav-link" href="/mangr/noticd3.do">소 식 지</a>
								</li>                                                                
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/mangr/faqcd.do">자주하는 질문</a>
                                </li>
                                <!--  
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="/mangr/asqcd.do">1:1 문의하기</a>
                                </li>
                                -->
								<%-- ★[2026-08-18] 원격지원상담 = **원격지원 프로그램 내려받기**로 바꿨다.
								     · 파일 = 서버 업로드 폴더의 `REMOTE/win-10.exe`
								       (`/sftp/download.do` 가 `/home/winner/upload/` 아래만 내보낸다 — 경로 탈출은 그 안에서 막는다).
								     ⚠***브라우저는 exe 를 대신 실행해 주지 못한다*** — 우리가 할 수 있는 것은 <내려받기>까지고,
								       실행은 사람이 누른다. 그래서 누르는 순간 **어디를 보고 무엇을 눌러야 하는지** 안내를 띄운다.
								     ★파일 이름이 바뀌면 아래 한 줄만 고친다.
								     · 종전 링크(외부 원격지원 포털) = https://377.co.kr --%>
								<li class="nav-item">
								    <a class="nav-item nav-link" href="/sftp/download.do?filePath=REMOTE%2Fwin-10.exe">원격지원상담 </a>
								</li>
                            </ul>
                        </div>
                    </li>
                    <li class="nav-item" id="adminAsqMenu" style="display:none;">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/mangr/asqcd.do"><i class="fas fa-headset"></i>관리자 1:1 문의하기</a>
                    </li>
                    <li class="nav-item" id="adminVisitAsqMenu" style="display:none;">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/mangr/visitasq.do"><i class="fas fa-building"></i>관리자 1:1 상담하기</a>
                    </li>
                    <%-- [적정성평가 Q&A 자료] 메뉴는 2026-08-05 사용자 요청으로 <내렸다> —
                         종전처럼 우측하단 <말풍선>(tiles/main/qnaChat.jsp, main.jsp 에서 include)으로 되돌렸다.
                         화면(/mangr/qnacd.do)과 서버 API 는 그대로 살아 있어 주소로는 들어갈 수 있다.
                         메뉴를 되살리려면 이 자리에 li#adminQnaMenu 를 다시 넣고 아래 표시 스크립트도 같이 살린다. --%>
                    <!-- 진료비 분석 보고서 -->
                    <li class="nav-item menu-section" id="menu-g">
                        <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management" aria-controls="management">
                                                                                         <i class="fas fa-cogs"></i>분야별통계</a>
                        <div id="management" class="collapse submenu" style="background-color: white;">
                            <ul class="nav flex-column">
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management-1" 
                                                                                                       aria-controls="management-1">진료실적통계</a>
                                    <div id="management-1" class="collapse submenu" style="background-color: white;">
                                        <ul class="nav flex-column">
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_00.do">일당,건당진료비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_02.do">진료과별 건당진료비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_05.do">전문의별 건당진료비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_04.do">다빈도상병 진료구성비</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_06.do">유형별 건당진료비</a>
                                            </li>                                            
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_07.do">전문의별 전월대비진료비</a>
                                            </li> 
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management-2" 
                                                                                                       aria-controls="management-2">진료대비 약제비율</a>
                                    <div id="management-2" class="collapse submenu" style="background-color: white;">
                                      <ul class="nav flex-column">
                                            <li class="nav-item">
                                          <a class="nav-item nav-link" href="/tong/f_tong_08.do">정액환자(비청구분)</a>
                                      </li>
                                      <li class="nav-item">
                                          <a class="nav-item nav-link" href="/tong/f_tong_081.do">정액환자(전체)</a>
                                      </li>
                                      <li class="nav-item">
                                          <a class="nav-item nav-link" href="/tong/f_tong_082.do">행위환자</a>
                                      </li>
                                      <li class="nav-item">
                                          <a class="nav-item nav-link" href="/tong/f_tong_083.do">전체환자</a>
                                      </li>
                                      </ul>
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management-3" 
                                                                                                       aria-controls="management-3">주요지표통계</a>
                                    <div id="management-3" class="collapse submenu" style="background-color: white;">
                                      <ul class="nav flex-column">
                                         <li class="nav-item">
                                              <a class="nav-item nav-link"  href="/tong/f_tong_01.do">진료지표</a>
                                          </li>
                                      </ul>
                                    </div>
                                </li>                                
                                <li class="nav-item">
                                    <a class="nav-item nav-link"  href="#" data-toggle="collapse" aria-expanded="false" data-target="#management-4" 
                                                                                                       aria-controls="management-4">처치항목별통계</a>
                                    <div id="management-4" class="collapse submenu" style="background-color: white;">
                                      <ul class="nav flex-column">
                                             <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_03.do">항목별 건당진료비 구성</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-item nav-link"  href="/tong/f_tong_09.do">정액환자 비청구분 항목비</a>
                                            </li>
                                      </ul>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </li>

                    <%-- 신규병원 가입신청 — 메뉴 맨 아래(분야별통계 다음).
                         ★★class 에 menu-section 을 **넣지 않는다.**
                           top.jsp 의 상단 탭(전체·경영분석·적정성평가…)은 눌릴 때마다
                           `$('.menu-section').hide()` 로 그 클래스를 단 항목을 통째로 숨기고,
                           계약구분에 따라 `#menu-a … #menu-h` 만 골라 다시 켠다.
                           그 목록에 없는 새 메뉴는 **한 번 숨겨지면 영영 안 켜진다** —
                           앞서 menu-section 을 달았다가 메뉴가 안 나온 원인이 이것이다(2026-08-19).
                           같은 이유로 menu-qps 도 menu-section 이 아니다(위쪽 주석 참고).
                         ※권한은 컨트롤러가 세션 MAIN_GU='1' 로 막는다. --%>
                    <li class="nav-item" id="adminJoinReqMenu" style="display:none;">
                        <a class="nav-item nav-link" style="font-size: 15px;" href="/join/joinReq.do">
                            <i class="fas fa-hospital-user"></i>신규병원 가입신청
                            <span id="adminJoinReqCnt" style="background:#d9534f; color:#fff; border-radius:10px;
                                  padding:1px 8px; font-size:11.5px; font-weight:800; margin-left:6px;"></span></a>
                    </li>
                    <%-- ★아직 개발 단계라 **기본 숨김**이다(2026-08-19).
                         **Ctrl+Alt+R** 로 켜고 끈다(2026-08-24 변경 : req → rg → Ctrl+R → Ctrl+Alt+R) —
                         로그인 화면(wnn_consult)의 [신규병원 가입신청] 과 같은 키·같은 저장키(joinReqDev)다.
                         운영은 두 앱이 같은 호스트라 sessionStorage 가 공유된다 →
                         로그인 화면에서 한 번 켜면 여기서도 켜져 있다.
                         (로컬은 포트가 달라 origin 이 달라서 각각 쳐야 한다)
                         옆 배지의 숫자는 처리할 신청 건수다.
                         ★Ctrl+R(새로고침)·Ctrl+Shift+R 은 그대로 둔다 — Alt 를 더해 브라우저 단축키와 안 겹치게 했다.
                         ★정식 오픈 시 : li 의 display:none 과 이 스크립트의 게이트만 지우면 된다. --%>
                    <script>
                    (function(){
                      var KEY = 'joinReqDev';
                      function on(){ try { return sessionStorage.getItem(KEY) === 'Y'; } catch(e){ return false; } }
                      function apply(){
                        var li = document.getElementById('adminJoinReqMenu');
                        if (li) li.style.display = on() ? '' : 'none';
                      }
                      /* 건수 배지 — 메뉴가 켜져 있든 아니든 미리 받아 둔다(켜는 순간 바로 보이게) */
                      try {
                        var x = new XMLHttpRequest();
                        x.open('POST', '/join/joinReqCnt.do', true);
                        x.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                        x.onload = function(){
                          try {
                            var d = JSON.parse(x.responseText);
                            var n = parseInt(d && d.cnt, 10) || 0;
                            var bd = document.getElementById('adminJoinReqCnt');
                            if (bd) bd.textContent = n > 0 ? n : '';
                          } catch (ignore) {}
                        };
                        x.send('');
                      } catch (ignore) {}
                      document.addEventListener('keydown', function(e){
                        /* ★2026-08-24 : 열쇠말 타이핑(req→rg) → Ctrl+Alt+R 로 교체.
                             Ctrl+R(새로고침) 을 뺏지 않으려고 Alt 를 더했다. 파이어폭스 리더모드(Ctrl+Alt+R) 만 겹쳐 preventDefault 로 막는다.
                             ★e.key 는 배열·IME 에 따라 'r' 이 아닐 수 있어 e.code('KeyR') 도 함께 본다. */
                        if (!e.ctrlKey || !e.altKey || e.metaKey || e.shiftKey) return;   // Ctrl+Alt+R 만 (Shift 조합은 통과)
                        if ((e.key || '').toLowerCase() !== 'r' && e.code !== 'KeyR') return;
                        e.preventDefault();
                        try { sessionStorage.setItem(KEY, on() ? 'N' : 'Y'); } catch (ignore) {}
                        apply();
                      });
                      apply();
                    })();
                    </script>
                </ul>
            </div>
        </nav>
        

    </div>
	<div class="fixed-sidebar-info-box">
	    <div class="col-xl-12">
	        <div class="card border-3 border-top border-top-primary">
	            <div class="card-body">
	                <img class="img-fluid" src="/images/winct/time_main.svg" alt="고객센터" style="height: 140px; margin-top: -10px; width: 120%;">
	                <div class="mt-3">
	                    <a href="#" onclick="fnasq_main();" class="btn btn-outline-primary btn-block d-flex align-items-center justify-content-between mb-2"
	                        style="border-radius: 8px; padding: 6px 16px; font-size: 12px; border-width: 2px; margin-right:35px;">
	                        <span><i class="fas fa-headphones" style="opacity: 0.6; margin-right: 10px;"></i> <b>1:1 문의하기</b></span>
	                        <i class="fas fa-chevron-right" style="opacity: 0.6;"></i>
	                    </a>
	                    <a href="#" onclick="loadFaqData();" class="btn btn-outline-primary btn-block d-flex align-items-center justify-content-between"
	                       style="border-radius: 8px; padding: 6px 16px; font-size: 12px; border-width: 2px; margin-right:35px;">
	                        <span><i class="fas fa-clipboard-list" style="opacity: 0.6; margin-right: 10px;"></i> <b>자주하는 질문</b></span>
	                        <i class="fas fa-chevron-right" style="opacity: 0.6;"></i>
	                    </a>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
</div>
<!-- 질의응답스크립트 종료 -->
<!-- FAQ 모달 -->

<div class="modal fade" id="faqModal" tabindex="-1" aria-labelledby="faqModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
  <div class="modal-dialog modal-lg" style="margin-top: 100px;"> <!-- 여기 추가 -->
 
    <div class="modal-content" style="max-height: 900px;"> <!-- 높이 제한 -->
      <div class="modal-header">
        <h5 class="modal-title" id="faqModalLabel">자주 묻는 질문 (FAQ)</h5>
        <button type="button" class="btn btn-outline-dark" data-dismiss="modal" onclick="faqMainClose()">
          닫기 <i class="fas fa-times"></i>
        </button>
      </div>
      <div class="modal-body" style="max-height: 700px; overflow-y: auto;">
        <div class="input-group mb-3">
          <input type="text" id="faqSearchInput" class="form-control" placeholder="검색어를 입력하세요" onkeypress="if(event.keyCode===13) searchFaq();">
          <div class="input-group-append">
            <button class="btn btn-primary" type="button" onclick="searchFaq();">
              <i class="fas fa-search"></i> 검색
            </button>
          </div>
        </div>
        <div id="faqList">
          <p class="text-muted text-center">FAQ 데이터를 불러오려면 버튼을 클릭하세요.</p>
        </div>
      </div>
    </div>
  </div>
</div>
<!-- 기존 1대1 질의응답  -->
<style>
#asq_main_tab .btn-outline-info:hover,
#asq_main_tab .btn-outline-info:active,
#asq_main_tab .btn-outline-info:focus {
   background-color: #1a8fc4 !important;
   border-color: #1a8fc4 !important;
   color: #fff !important;
}
</style>
<div class="modal fade" id="asq_main_tab" tabindex="-1"
   data-bs-backdrop="static" data-bs-keyboard="false" aria-hidden="true">
   <div class="modal-dialog modal-lg modal-dialog-centered" 
      style="max-width: 900px; width: 90%;">
      <!-- 모달 전체 높이를 100vh에서 auto로 변경하고 최대 높이를 제한 -->
      <div class="modal-content shadow-lg rounded-4"
         style="height: auto; max-height: 90vh; border: none;">
         <div class="modal-header bg-light"
            style="height: 35px; padding: 3px 8px;">
            <h5 class="modal-title">상담문의 목록</h5>
         </div>
         <!-- modal-body의 높이를 줄여서 최대 65vh 정도로 제한 -->
         <div class="modal-body bg-light"
            style="max-height: 60vh; overflow-y: auto;">
            <div class="d-flex align-items-center justify-content-between mb-3">
               <div class="d-flex" style="position: relative;">
                  <input type="text" id="searchText"
                     class="form-control rounded-3 border" placeholder="검색어를 입력하세요."
                     onkeypress="if(event.keyCode == 13){fnasq_Search();}"
                     style="width: 250px; font-size: 13px; height: 33px; padding-right: 35px;">
                  <i class="fas fa-search" onclick="fnasq_Search();" style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #888; font-size: 14px;"></i>
               </div>
               <div>
                  <button class="btn btn-outline-info btn-sm" onclick="fn_asqsave('QD');" style="font-size: 13px; padding: 5px 11px; font-weight:600; color:#0a6ebd;">
                     <img src="/images/winct/qnst_c.svg" alt="질문취소" style="width:16px; height:16px; vertical-align:middle; margin-right:4px;">질문취소</button>
                  <button class="btn btn-outline-info btn-sm" onclick="fn_asqsave('QI');" style="font-size: 13px; padding: 5px 11px; font-weight:600; color:#0a6ebd;">
                     <img src="/images/winct/qnst_i.svg" alt="질문등록" style="width:16px; height:16px; vertical-align:middle; margin-right:4px;">질문등록</button>
                  <button class="btn btn-outline-info btn-sm" onclick="fn_asqsave('QU');" style="font-size: 13px; padding: 5px 11px; font-weight:600; color:#0a6ebd;">
                     <img src="/images/winct/qnst_q.svg" alt="질문조회" style="width:16px; height:16px; vertical-align:middle; margin-right:4px;">답변조회(수정)</button>
               </div>
            </div>
            <div class="table-responsive rounded-3 shadow-sm mt-1 border"
               style="height:500px; overflow-y: auto;">
               <table id="asq_infoTable" class="table table-bordered">
                  <colgroup>
                     <col style="width: 30px">
                     <!-- NO -->
                     <col style="width: 60px">
                     <!-- 답변상태 -->
                     <col style="width: 120px">
                     <!-- 질문항목 -->
                     <col style="width: 160px">
                     <!-- 질문내용 -->
                     <col style="width: 80px">
                     <!-- 병원명 -->
                     <col style="width: 60px">
                     <!-- 질문자 -->
                     <col style="width: 110px">
                     <!-- 작성일 -->
                     <col style="width: 30px">
                     <!-- 첨부 -->
                  </colgroup>
                  <thead>
                    <tr style="background: #afd4ec; color: #000; font-weight: 600; font-size: 14px !important;">
                        <th>NO</th>
                        <th>답변상태</th>
                        <th title="질문항목">질문항목</th>
                        <th title="질문내용">질문내용</th>
                        <th>병원명</th>
                        <th>질문자</th>
                        <th>작성일</th>
                        <th>첨부</th>
                     </tr>
                  </thead>
                  <tbody id="asqdataArea" style="background-color: white;">
                     <tr>
                        <td colspan="8" class="text-muted">&nbsp; 검색된 결과가 없습니다.</td>
                     </tr>
                  </tbody>
               </table>
            </div>
         </div>
         <div class="modal-footer" style="background-color: white; padding: 5px 10px; justify-content: center;">
            <button class="btn btn-outline-info" onclick="asqMainClose();" style="font-weight:600; color:#0a6ebd;">닫기 <i class="fas fa-times"></i></button>
         </div>
      </div>
   </div>
</div>
<!--질문응답-->
<div class="modal fade" id="asq_main" tabindex="-1"
   data-bs-backdrop="static" data-keyboard="false" aria-hidden="true">
   <div class="modal-dialog modal-dialog-scrollable modal-lg"
      style="max-width: 910px; width: 90%; margin-top: 30px;">
      <div class="modal-content"
         style="max-height: calc(100vh - 110px); display: flex; flex-direction: column; border: none; border-radius: 12px; overflow: hidden; box-shadow: 0 8px 32px rgba(0,0,0,0.18);">

         <!-- 타이틀 헤더 -->
         <div style="background: #fff; padding: 10px 24px 6px 24px; flex-shrink: 0; border-bottom: 1px solid #eee;">
            <h5 style="margin: 0; font-weight: 700; font-size: 16px; color: #222;">1:1 문의하기</h5>
         </div>

         <!-- 폼 바디 -->
         <form:form commandName="DTO" id="asq_regForm" name="asq_regForm"
            method="post" enctype="multipart/form-data" novalidate="novalidate"
            style="flex-grow: 1; display: flex; flex-direction: column; overflow: hidden; min-height: 0;">
            <div class="modal-body" style="overflow-y: auto; flex-grow: 1; min-height: 0; padding: 0 24px 15px 24px; background: #f9f9f9;">
               <input type="hidden" name="iud"      id="iud" />
               <input type="hidden" name="asqSeq"   id="asqSeq" />
               <input type="hidden" name="fileGb"   id="fileGb" value="4" />
               <input type="hidden" name="fileGb2"  id="fileGb2" value="4" />
               <input type="hidden" name="qstnWan"  id="qstnWan" value="Y" />
               <input type="hidden" name="hospCd2"  id="hospCd2" />
               <input type="hidden" name="regUser"  id="regUser" />
               <input type="hidden" name="updUser"  id="updUser" />
               <input type="hidden" name="regIp"    id="regIp" />
               <input type="hidden" name="updIp"    id="updIp" />

               <!-- 질문제목 섹션 -->
               <div style="margin-top: 15px;">
                  <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     질문제목
                  </div>
                  <div style="background: #fff; border: 1px solid #d0d0d0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                     <textarea id="qstnTitle" name="qstnTitle" required
                        class="form-control" rows="2"
                        style="border: 1px solid #ddd; border-radius: 6px; font-size: 13px; font-weight: normal; resize: vertical;"></textarea>
                  </div>
               </div>

               <!-- 질문내용 섹션 -->
               <div style="margin-top: 12px;">
                  <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     질문내용
                  </div>
                  <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                     <textarea id="qstnConts" name="qstnConts" required
                        class="form-control" rows="4"
                        style="border: 1px solid #ddd; border-radius: 6px; font-size: 13px; font-weight: normal; resize: vertical;"></textarea>
                  </div>
               </div>

               <!-- 질문첨부파일 섹션 -->
               <div style="margin-top: 12px;">
                  <div style="background: #afd4ec; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     질문첨부파일
                  </div>
                  <div id="asq-file-area" style="background: #fff; border: 1px solid #e0e0e0; border-top: 1px solid #ccc; padding: 10px 14px;">
                     <div style="display: flex; align-items: center;">
                        <button type="button" class="btn btn-outline-secondary btn-sm" style="border-radius: 4px; font-size: 13px; padding: 4px 14px; 
                             border-color: #bbb; color: #000; outline: none !important; box-shadow: none !important;" onclick="openAsqFileInput()">파일찾기</button>
                        <span id="asq-file-label" style="margin-left: 14px; color: #999; font-size: 13px;">선택된 파일 없음</span>
                        <input type="file" id="asq-file-input" multiple style="display:none;" onchange="asqHandleFiles(this.files)">
                     </div>
                     <div id="asq-drop-zone" style="border: none; padding: 0; min-height: 0;">
                        <div id="asq-file-list-new" class="file-list-container"></div>
                     </div>
                  </div>
                  <!-- 기존 업로드된 파일 목록 -->
                  <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 0;">
                     <table id="asq-file-table" class="table" style="width: 100%; font-size: 12px; display:none; margin-bottom: 0; border-collapse: collapse;">
                        <thead style="display: none;">
                           <tr>
                              <th>문서제목</th><th>사이즈</th><th>작성일</th><th></th><th></th>
                           </tr>
                        </thead>
                        <tbody id="asq-file-tbody"></tbody>
                     </table>
                  </div>
               </div>

               <!-- 답변내용 섹션 -->
               <div style="margin-top: 12px;">
                  <div style="background: #d4eaf7; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     답변내용
                  </div>
                  <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 12px 14px;">
                     <div id="ansrContsView"
                        style="border: 1px solid #ddd; border-radius: 6px; font-size: 13px; font-weight: normal; min-height:200px; max-height: 400px; 
                                overflow-y: auto; padding: 8px 12px; background: #fff;"></div>
                     <input type="hidden" id="ansrConts" name="ansrConts" value="">
                  </div>
               </div>

               <!-- 답변완료 (숨김처리용) -->
               <div class="form-group" style="margin-top: 0; display: none;">
                  <select id="ansrWan" name="ansrWan" class="custom-select"
                     style="height: 35px; font-size: 14px; width: 120px;">
                     <option value="">선택</option>
                     <option value="Y">Y. 답변완료</option>
                     <option value="N">N. 답변대기ㅣ</option>
                  </select>
               </div>

               <!-- 답변자 첨부파일 섹션 (FILE_GB='5') -->
               <div id="ansr-file-area" style="margin-top: 12px; display:none;">
                  <div style="background: #d4eaf7; color: #000; padding: 8px 16px; border-radius: 8px 8px 0 0; font-weight: 600; font-size: 13px;">
                     답변첨부파일
                  </div>
                  <div style="background: #fff; border: 1px solid #e0e0e0; border-top: none; border-radius: 0 0 8px 8px; padding: 0;">
                     <table id="ansr-file-table" class="table" style="width: 100%; font-size: 12px; margin-bottom: 0; border-collapse: collapse;">
                        <thead style="display: none;">
                           <tr>
                              <th>문서제목</th><th>사이즈</th><th>작성일</th><th></th>
                           </tr>
                        </thead>
                        <tbody id="ansr-file-tbody"></tbody>
                     </table>
                  </div>
               </div>

            </div>

            <!-- 하단 버튼 영역 -->
            <div style="background: #fff; padding: 12px 24px; border-top: 1px solid #eee; text-align: center; flex-shrink: 0;">
               <button type="button" id="save_btn" class="btn"
                  style="background: #fff; border: 1px solid #ccc; border-radius: 6px; padding: 8px 30px; font-size: 14px; font-weight: 500; color: #333; margin-right: 8px;"
                  onClick="fnasq_SaveProc()">저장</button>
               <button type="button" class="btn"
                  style="background: #5bb8e8; border: none; border-radius: 6px; padding: 8px 30px; font-size: 14px; font-weight: 500; color: #fff;"
                  data-dismiss="modal" onClick="asqModalClose()">닫기</button>
            </div>
         </form:form>

      </div>
   </div>
</div>

<script>
// 새 창 없이 파일 다운로드 (iframe 방식)
function fn_fileDown(url) {
    if (!url || url === '#') return;
    var iframe = document.getElementById('hiddenDownFrame');
    if (!iframe) {
        iframe = document.createElement('iframe');
        iframe.id = 'hiddenDownFrame';
        iframe.style.display = 'none';
        document.body.appendChild(iframe);
    }
    iframe.src = url;
}

function loadFaqData(keyword) {
    // 모달 열기
    $('#faqModal').modal('show');

    // FAQ 리스트 초기화
    $("#faqList").html(`<p class="text-muted text-center"></p>`);

    var searchKeyword = keyword || "";

    // AJAX로 FAQ 데이터 요청
    $.ajax({
        url: "/mangr/faqCdList.do",
        type: "POST",
        data: { qstnConts: searchKeyword, ansrConts: searchKeyword },
        dataType: "json",
        success: function (response) {
            if (response.error_code === "0" && Array.isArray(response.data) && response.data.length > 0) {
                $.each(response.data, function (index, faq) {
                    let question = String(faq.qstnConts || "질문이 없습니다.").trim();
                    let answer = String(faq.ansrConts || "답변이 없습니다.").trim();

                    // faq-item 전체 묶음 div
                    let faqItem = $("<div>", { class: "faq-item" });

                    // 질문 div
                    let faqQuestion = $("<div>", {
                        class: "faq-question"
                    }).text(question);

                    // ▼ 아이콘
                    let arrowSpan = $("<span>", { class: "arrow" }).text("▼");
                    faqQuestion.append(arrowSpan);

                    // 답변 div
                    let faqAnswer = $("<div>", {
                        class: "faq-answer",
                        style: "display: none;"
                    });

                    // textarea ID를 유니크하게 생성
                    let textareaId = "faqTextarea_" + index;

                    // textarea 생성
                    let textarea = $("<textarea>", {
                        id: textareaId,
                        class: "faq-textarea"
                    }).val(answer);

                    faqAnswer.append(textarea);
                    faqItem.append(faqQuestion).append(faqAnswer);
                    $("#faqList").append(faqItem);

                    // click 이벤트 바인딩 (각 item별)
                    faqQuestion.on("click", function () {
                        let $thisItem = $(this).closest(".faq-item");

                        if ($thisItem.hasClass("active")) {
                            // 열려있으면 닫기
                            $thisItem.removeClass("active").find(".faq-answer").slideUp();
                            $thisItem.find(".arrow").text("▼");

                            // Summernote 제거
                            if ($("#" + textareaId).hasClass("summernote")) {
                                $("#" + textareaId).summernote('destroy');
                            }
                        } else {
                            // 다른 항목 닫기 및 summernote 제거
                            $(".faq-item").each(function () {
                                $(this).removeClass("active").find(".faq-answer").slideUp();
                                $(this).find(".arrow").text("▼");

                                let $ta = $(this).find("textarea");
                                if ($ta.hasClass("summernote")) {
                                    $ta.summernote('destroy');
                                }
                            });

                            // 현재 항목 열기
                            $thisItem.addClass("active").find(".faq-answer").slideDown();
                            $thisItem.find(".arrow").text("▲");
                            
                            let convertedAnswer = answer.replace(/\n/g, "<br>"); // 줄바꿈 → <br>

	                         // Summernote 적용
	                         $("#" + textareaId).summernote({
	                             height: 300,
	                             lang: 'ko-KR',
	                             toolbar: [
	                                 ['style', ['style']],
	                                 ['font', ['bold', 'italic', 'underline', 'clear']],
	                                 ['fontname', ['fontname']],
	                                 ['fontsize', ['fontsize']],
	                                 ['color', ['color']],
	                             ],
	                             fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New', '맑은 고딕', '굴림체', '돋움체'],
	                             fontNamesIgnoreCheck: ['맑은 고딕', '굴림체', '돋움체'],
	                             callbacks: {
	                                 onInit: function () {
	                                     $('.note-editable').css('font-size', '14px');
	                                     $("#" + textareaId).next(".note-editor").find(".note-toolbar").hide();
	
	                                     // 줄바꿈 처리된 내용 넣기
	                                     $("#" + textareaId).summernote('code', convertedAnswer);
	                                 }
	                             }
	                         });
                        }
                    });
                });
            } else {
                $("#faqList").html(`<p class="text-muted text-center">검색된 결과가 없습니다.</p>`);
            }

            console.log("📢 FAQ 데이터 로드 완료");
        },
        error: function () {
            $("#faqList").html(`<p class="text-danger text-center">FAQ 데이터를 불러오는 중 오류가 발생했습니다.</p>`);
        }
    });
}
// FAQ 검색
function searchFaq() {
    var keyword = $.trim($("#faqSearchInput").val());
    loadFaqData(keyword);
}

// FAQ 모달 닫기
function faqMainClose() {
    console.log("📢 FAQ 모달 닫힘 실행");
    $('#faqModal').modal('hide');
}  
/*질의응답메인*/
function asqMainClose() {
    $('#asq_main_tab').modal('hide');
}   

function fnasq_main() {
    fnasq_Search();
    $('#asq_main_tab').modal('show') ;
    $("#asqdataArea").empty();
    if (document.getElementById('searchText')) {
        document.getElementById('searchText').value = '';
    }

    if ($('#overlay').length === 0) {
        $('body').append('<div id="overlay"></div>');
    }

    $('#asq_main_tab').on('hidden.bs.modal', function () {
        $('#overlay').remove();
    });
}    
  
function fnasq_Search() {
   $("#asq_infoTable tr").attr("class", "");
    if (document.getElementById("asq_regForm")) {
        document.getElementById("asq_regForm").reset();
    }
    $("#asqSeq").val("") ;
    $("#asqdataArea").empty();
    $.ajax({
         url : '/mangr/asqList.do',
         type : 'post',
         data : {hospCd : getCookie("hospid")  , qstnTitle : $("#searchText").val() },
         dataType : "json",
         success : function(data) {
            if(data.error_code != "0") return;

            if(data.resultCnt > 0 ){
             var dataTxt = "";
             for(var i=0 ; i < data.resultCnt; i++){
	    	    dataTxt = '<tr onclick="fn_rowClick(\'' + data.resultLst[i].asqSeq + '\')" ' +
	    	          'ondblclick="fn_rowDblClick(\'' + data.resultLst[i].asqSeq + '\')" ' +
	    	          'id="row_' + data.resultLst[i].asqSeq + '">';
                dataTxt +=  "<td>" + (i+1)  + "</td>" ;
                var statTxt = data.resultLst[i].ansrStat;
                if(statTxt == '답변대기') statTxt = '답변대기';
                else if(statTxt == '답변완료') statTxt = '답변완료';
                dataTxt +=  "<td style='white-space:nowrap;'>" + statTxt    + "</td>" ;
                dataTxt +=  "<td class='txt-left ellips'>" + data.resultLst[i].qstnTitle    + "</td>" ;
                dataTxt +=  "<td class='txt-left ellips'>" + data.resultLst[i].qstnConts    + "</td>" ;
                dataTxt +=  "<td>" + data.resultLst[i].hospNm   + "</td>" ;
                dataTxt +=  "<td>" + data.resultLst[i].userNm   + "</td>" ;
                dataTxt +=  "<td>" + data.resultLst[i].updDttm  + "</td>" ;
                dataTxt +=  "<td>" + (data.resultLst[i].fileYn === 'Y' ? '<img src="/images/winct/filedown.svg" alt="파일 있음" title="파일 있음" style="width:15px; height:15px; vertical-align:middle;">' : '') + "</td>" ;
                dataTxt +=  "</tr>";
                  $("#asqdataArea").append(dataTxt);
               }
            }else{
              $("#asqdataArea").append("<tr><td colspan='8'>검색된 정보가 없습니다.</td></tr>");
           }
         }
   });
}
/*질의응답모달*/
function asqModalOpen() {
   $("#hospCd2").val(getCookie("hospid")  || '') ;
   $("#updUser").val(getCookie("userid") || '') ;
   $("#regUser").val(getCookie("userid") || '') ;
   $("#updIp").val(getCookie("s_connip") || '') ;
   $("#regIp").val(getCookie("s_connip") || '') ;
   $("#iud").val(uidGubun);
    $('#asq_main').modal('show');
} 
function asqModalClose() {
    $('#asq_main').modal('hide');
}
var  lasqSeq  ;
var  lfileGb  ;  
var  lregUser ;
var  lregIp   ;
let clickTimer = null;
function fn_rowClick(asqSeq) {
    // 단일 클릭 시 (delay 후 실행, 만약 더블클릭이면 clearTimeout)
    clickTimer = setTimeout(function () {
        fn_asqDtlSearch(asqSeq);
    }, 250); // 더블클릭보다 살짝 느리게
}

function fn_rowDblClick(asqSeq) {
    // 더블클릭 시: 단일 클릭 취소하고 저장 실행
    clearTimeout(clickTimer);
    fn_asqDtlSearch(asqSeq);  // 필요 시 생략 가능
    fn_asqsave('QU');
}    
function fn_asqDtlSearch(asqSeq) { 
   if (!asqSeq) return;

   $("#asqSeq").val(asqSeq);

   // row 클릭 시 바탕색 변경 처리
   $("#asq_infoTable tr").removeClass("tr-primary"); // 모든 행 클래스 초기화
   $("#row_" + asqSeq).addClass("tr-primary");       // 선택된 행에 강조 클래스 추가
}
function fn_asqsave(iud) {
    $("#iud").val(iud); // 입력(I), 수정(U), 삭제(D)
    var asqSeq = $("#asqSeq").val();

    if (iud.substring(1, 2) === "U" || iud.substring(1, 2) === "D") {
        if (!asqSeq) {
          messageBox("1", "<h6>해당자료를 선택하세요.!!</h6><p></p>", "", "", "");
          return; 
        }
    }
    uidGubun = iud;
    $("#ansrWan").closest(".form-wrap").hide(); // 답변완료 숨기기
    if (iud.substring(1, 2) == "I") {
        document.getElementById("asq_regForm").reset();
        $("#iud").val(iud);
        $("#hospCd2").val(getCookie("hospid"));
        $("#regUser").val(getCookie("userid"));
        $("#updUser").val(getCookie("userid"));
        $("#ansrConts").val("");
        $("#ansrContsView").html("");
        $("#ansrWan").css("pointer-events", "none").css("background-color", "#e9ecef"); // 비활성화된 느낌의 배경색 적용
        $("#save_btn").show(); // 답변내용 보이기
        asqFileClear();
        $("#asq-file-table").show();
        $("#asq-file-tbody").html("<tr><td colspan='5' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>");
        $("#ansr-file-area").show();
        $("#ansr-file-tbody").html("<tr><td colspan='4' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>");
        asqModalOpen();
    } else if (iud.substring(1, 2) == "U") {
        if ($("#asqSeq").val() == "") {
            alert("선택된 정보가 없습니다.!");
            asqModalClose();
            return;
        }
        $("#regDtm").prop("readonly", false);
        $.ajax({
            type: "post",
            url: "/mangr/selectAnsrInfo.do",
            data: { asqSeq: $("#asqSeq").val() },
            dataType: "json",
            success: function (data) {
                if (data.error_code != "0") {
                    alert(data.error_msg);
                    return;
                }
                $("#qstnTitle").val(data.result.qstnTitle);
                $("#qstnConts").val(data.result.qstnConts);
                $("#qstnWan").val(data.result.qstnWan);
                $("#ansrWan").val(data.result.ansrWan); // 답변완료 여부 값 설정
                $("#ansrConts").val(data.result.ansrConts);
                var ansrHtml = (data.result.ansrConts || '').replace(/\n/g, '<br>');
                $("#ansrContsView").html(ansrHtml);
                $("#fileGb").val(data.result.fileGb);
                $("#regDtm").val(data.result.regDtm);

                if ($("#ansrWan").val().trim() === "Y") {
                    $("#save_btn").hide(); // 답변내용 숨기기
                }else{
                   $("#save_btn").show(); // 답변내용 
                  }
                if (uidGubun.substring(0, 1) == "Q") {
                    // 질문
                    $("#qstnTitle").prop("readonly", "");
                    $("#qstnConts").prop("readonly", "");
                    $("#qstnWan").css("pointer-events", "auto").css("background-color", "");
                    // 답변
                    $("#ansrConts").prop("readonly", "true");
                    $("#ansrWan").css("pointer-events", "none").css("background-color", "");
                }
                asqFileClear();
                showAsqFileList($("#asqSeq").val());
                showAnsrFileList($("#asqSeq").val());
                asqModalOpen();
            }
        });
    } else if (iud.substring(1, 2) == "D") {
        // 삭제 전에 ansrWan 상태 확인 후 처리
        $.ajax({
            type: "post",
            url: "/mangr/selectAnsrInfo.do",  // 답변 상태 조회 API
            data: { asqSeq: $("#asqSeq").val() },
            dataType: "json",
            success: function (data) {
                if (data.error_code != "0") {
                    alert(data.error_msg);
                    return;
                }
                var ansrStat = data.result.ansrWan; 
                if (ansrStat.trim() == ""  ||  ansrStat.trim() !== "Y") {
                    lasqSeq  = data.result.asqSeq  ;
                    lfileGb  = data.result.fileGb  ;  
                    lregUser = data.result.regUser ;
                    lregIp   = data.result.regIp ;
                   fnasq_SaveProc(); // 즉시 삭제 실행
                } else if (ansrStat === "Y") {
                   messageBox("1", "<h6>답변완료된 항목은 삭제할 수 없습니다.!!</h6><p></p>", "", "", "");
                } else {
                    alert("답변 상태를 확인할 수 없습니다."); // ansrStat이 null 또는 undefined일 때
                }
            },
            error: function () {
                alert("삭제할 항목의 정보를 불러오는 중 오류가 발생했습니다.");
            }
        });
    }
}
///////데이타 처리 루틴  
function fnasq_SaveProc() {
    var formData = {};
    var msg = "";     
    if (uidGubun.substring(1, 2) != "D") {
        if ( $("#qstnTitle").val() == "") { 
            messageBox("1", "<h6>질문제목을 입력하세요.!!</h6><p></p>", "", "", "");
           return; 
        }         
        if ( $("#qstnConts").val() == "") {
            messageBox("1", "<h6>질문내용을 입력하세요.!!</h6><p></p>", "", "", "");
           return; 
        }         
       formData = $("form[name='asq_regForm']").serialize();
    }else{
        formData = {
                   asqSeq:    lasqSeq,   // 문의글 고유번호
                   fileGb:    lfileGb,   // 파일구분
                   iud:       uidGubun,  // 처리 구분 (삭제: "D")
                   updUser:   getCookie("userid") || '',
                   updIp:     ''
                };
    }
    if (uidGubun.substring(1, 2) === "D") {
        // 모달을 띄우고 "deleteAction"이라는 식별자로 구분
        messageBox("2", "<h6>삭제 하시겠습니까?</h6><p></p>", "", "", "deleteAction");
       
    }else{
        execute() ; 
    }
    window.modalClose = function(flag, jobs, yesno) {
        console.log("modalClose 실행됨! flag:", flag, "jobs:", jobs, "yesno:", yesno);

        if (jobs === "deleteAction") {
            if (flag === "N") {
               $("#messageDialog").modal("hide"); // 모달 닫기
                return; // 'N'을 선택하면 아무 작업도 하지 않음
            }
            if (flag === "Y") {
               execute(); // 삭제 실행 함수 호출
            }
        }
        $("#messageDialog").modal("hide"); // 모달 닫기
    };
    // 실제 삭제 로직을 실행하는 함수
    function execute() {
        $.ajax({
            type: "post",
            url: "/mangr/asqSaveAct.do",
            data: formData,  // formData가 정의되어 있어야 함
            dataType: "json",
            success: function (data) {
                if (data.error_code !== "0") {
                    alert(data.error_msg);
                    return;
                }
                // 파일 업로드 처리
                console.log('=== 파일업로드 디버깅 ===');
                console.log('uidGubun:', uidGubun);
                console.log('data.asqSeq:', data.asqSeq);
                console.log('data.hospCd:', data.hospCd);
                console.log('data.regUser:', data.regUser);
                console.log('data.error_code:', data.error_code, typeof data.error_code);
                var asqFileInput = document.getElementById('asq-file-input');
                console.log('asqFileInput:', asqFileInput);
                console.log('files:', asqFileInput ? asqFileInput.files : 'null');
                console.log('files.length:', asqFileInput && asqFileInput.files ? asqFileInput.files.length : 0);
                if (asqFileInput && asqFileInput.files && asqFileInput.files.length > 0) {
                    var seqVal = '';
                    if (uidGubun === 'QI') {
                        seqVal = data.asqSeq || '';
                    } else if (uidGubun === 'QU') {
                        seqVal = data.asqSeq || $("#asqSeq").val();
                    }
                    console.log('seqVal:', seqVal);
                    if (seqVal) {
                        uploadAsqFiles(seqVal, data.hospCd || getCookie("hospid"), data.regUser || getCookie("userid"), function() {
                            $('#asq_main').modal('hide');
                            fnasq_Search();
                        });
                        return; // 파일 업로드 콜백에서 처리
                    }
                }
                $('#asq_main').modal('hide'); // 파일 없으면 바로 닫기
                fnasq_Search();
            },
            error: function (xhr, status, error) {
                console.log("에러 발생:", error);
                alert("작업 중 오류가 발생했습니다.");
            }
        });
    }

}
$(document).ready(function () {
    // 메뉴 항목 클릭 시 .active 클래스 부여
    $('.nav-item.nav-link').on('click', function () {
        // 현재 사이드바 내 모든 항목에서 active 제거
        $('.nav-item.nav-link').removeClass('active');
        // 현재 클릭한 항목에 active 추가
        $(this).addClass('active');
    });

    // ESC 키로 모달 닫기
    $(document).on('keydown', function(e) {
        if (e.keyCode === 27) {
            if ($('#asq_main').hasClass('show')) {
                asqModalClose();
            } else if ($('#asq_main_tab').hasClass('show')) {
                asqMainClose();
            }
        }
    });
});
   //위너넷만 메뉴가 생성됨   
function hosp_conact() {
    const hospcont  = document.getElementById("hospcont"); 
    const wnnauth1  = document.getElementById("wnnauth1");
    const comcode   = document.getElementById("comcode");
    const ratecode    = document.getElementById("ratecode");
    const samcode     = document.getElementById("samcode");
    const hospuser1   = document.getElementById("hospuser1");
    const hospuser2   = document.getElementById("hospuser2");
    const hospuser3   = document.getElementById("hospuser3");
    const hospuser4   = document.getElementById("hospuser4");
    const hospuser5   = document.getElementById("hospuser5");
    
  //  const simulation  = document.getElementById("simulation");
  
    const hideElementsById = (ids) => {
        ids.forEach(id => {
            const el = document.getElementById(id);
            if (el) el.style.display = "none";
        });
    };

    // 숨기고자 하는 ID 목록
    hideElementsById([
        "samcode",    // 샘버전
        "comcode",    // 공통코드
        "ratecode",   // 청구율
        "hospcont",   // 계약정보
        "wnnauth1",   // 운영정보
        "hospuser1",  // 병원사용
        "hospuser2",
        "hospuser3",
        "hospuser4",
        "hospuser5"

      //  ,"simulation"
    ]);
}
/* ★[2026-08-08] DOMContentLoaded 대기 → 즉시 실행으로 변경 — 메뉴 강조 깜박임의 원인.
     문서 '전체'(콘텐츠 JSP·차트·그리드까지) 파싱이 끝나야 강조가 붙어서, 무거운 화면일수록
     "강조 없음 → 강조" 가 눈에 띄게 깜박였다. 이 스크립트는 사이드바 마크업보다 아래에 있으므로
     즉시 실행해도 필요한 DOM 은 전부 있고, 같은 <script> 안의 함수(sbFavInit·hosp_conact)는
     호이스팅되어 안전하다. getCookie 는 top.jsp(먼저 로드) 정의분. */
(function () {
    // 실제 URL이 숨겨져 있지 않다면(/user/가 아니라면) location.pathname을 우선시한다.
    // 그래야 대시보드(/user/dashboard.do)로 이동 시 sessionStorage에 남은
    // 이전 메뉴 경로로 인해 잘못 강조되는 문제가 발생하지 않는다.
    // URL 숨김 주소가 '/user/dashboard.do' 이므로, 주소가 이 값일 때는 _realPath(실제 표시 중인
    //   화면)를 기준으로 메뉴를 강조한다. (실제 대시보드일 때는 _realPath 도 dashboard.do 라 정상)
    var locPath = window.location.pathname;
    var currentPath;
    if (locPath && locPath !== '/user/' && locPath !== '/' && locPath !== '/user/dashboard.do') {
        currentPath = locPath + (window.location.search || '');
    } else {
        currentPath = sessionStorage.getItem('_realPath') || locPath;
    }
    // ★쿼리 포함 전체 주소도 남겨 둔다 — qpsFall.do?indi=FALL / ?indi=BEDSORE 처럼
    //   경로는 같고 쿼리로만 갈리는 메뉴는 쿼리까지 맞아야 강조된다.
    //   (2026-08-08 실제: 경로만 비교해 마지막 링크가 이겨 낙상을 열어도 욕창이 강조됐다)
    var currentFull = currentPath;
    // 쿼리스트링 제거 (경로만 비교용)
    if (currentPath.indexOf('?') > -1) {
        currentPath = currentPath.substring(0, currentPath.indexOf('?'));
    }

    // 우선 사이드바 내 모든 nav-link에서 active 클래스 제거 (이전 페이지 상태 정리)
    document.querySelectorAll('.nav-left-sidebar .nav-link.active').forEach(function (link) {
        link.classList.remove('active');
    });

    // 모든 nav-link 순회 — 현재 페이지 URL과 일치하는 메뉴에 active 클래스 부여
    var matchedLink = null, exactMatched = false;
    document.querySelectorAll('.nav-left-sidebar .nav-link').forEach(function (link) {
        var href = link.getAttribute('href');
        // href가 없거나, '#'이거나, 빈 문자열이면 건너뛰기
        if (!href || href === '#' || href === '' || href.startsWith('http') || href.startsWith('javascript')) return;
        // 쿼리까지 정확히 일치하면 그 링크가 최우선 — 이후 경로만 일치하는 링크가 덮지 못한다.
        // ★exactMatched 검사가 먼저다 — 뒤에 두면 **같은 주소를 가진 뒤 링크가 계속 덮어써서**
        //   첫 링크가 아니라 마지막 링크가 강조된다(2026-08-09 실제: QPS '지표 현황'을 열었는데
        //   같은 주소를 임시로 가리키던 '서식(준비 중)'이 강조됐다).
        if (exactMatched) return;
        if (currentFull === href) { matchedLink = link; exactMatched = true; return; }

        // 쿼리스트링 제거
        if (href.indexOf('?') > -1) {
            href = href.substring(0, href.indexOf('?'));
        }

        if (currentPath === href) {
            matchedLink = link;
        }
    });

    // 매칭 실패 시 fallback: 대시보드 URL이면 대시보드 링크를 명시적으로 활성화
    if (!matchedLink && (currentPath === '/user/dashboard.do' || currentPath === '/user/' || currentPath === '/')) {
        matchedLink = document.querySelector('.nav-left-sidebar a.nav-link[href="/user/dashboard.do"]');
    }

    if (matchedLink) {
        matchedLink.classList.add('active');

        // 현재 링크 기준으로 상위 submenu 모두 열기
        var parent = matchedLink.closest('.nav-item');
        while (parent) {
            var submenu = parent.querySelector('.submenu');
            if (submenu) {
                submenu.classList.add('show');
            }

            var toggler = parent.querySelector('[data-toggle="collapse"]');
            if (toggler) {
                toggler.setAttribute('aria-expanded', 'true');
            }

            // 다음 상위로 이동
            parent = parent.parentElement.closest('.nav-item');
        }
    }
    let s_wnn_yn = getCookie("s_wnn_yn"); //위너넷여부
    if (s_wnn_yn != 'Y') {
    	hosp_conact();
    }
    // 관리자 1:1 문의하기 메뉴 표시
    var winner = getCookie("s_wnn_yn").trim();
   //   if (winner === 'Y' || winner != 'Y' ) {
     if (winner === 'Y') {

        var adminAsq = document.getElementById("adminAsqMenu");
        if (adminAsq) adminAsq.style.display = "";
        // 점검표 [서식 관리] — 위너넷 전용(사용자 확정 2026-08-11 : 병원은 서식을 못 만든다)
        var chkForm = document.getElementById("qpsChkFormMenu");
        if (chkForm) chkForm.style.display = "";
        // 점검표 [부서별 양식] — 서식 관리와 같은 갈래(2026-08-18)
        var deptForm = document.getElementById("qpsDeptFormMenu");
        if (deptForm) deptForm.style.display = "";
        // 점검표 [우리 병원 사용 서식] — ★[2026-08-18] 병원은 스스로 안 고른다.
        //   ***병원 요구를 듣고 위너넷이 대신 정한다*** ⇒ 위너넷에게만 보인다.
        var chkUse = document.getElementById("qpsChkUseMenu");
        if (chkUse) chkUse.style.display = "";
        // 점검표 [사용자별 담당 부서] — 설정 화면이라 위너넷 전용(2026-08-18)
        var userDept = document.getElementById("qpsUserDeptMenu");
        if (userDept) userDept.style.display = "";
        // 점검표 [부서별 쓰는 분류] — ★2026-08-18 메뉴에서 뺐다(서식 관리 안 링크로 들어간다).
        //   되살리려면 아래 두 줄의 주석을 풀고 li 의 hidden·display:none 을 지운다.
        // var deptCate = document.getElementById("qpsDeptCateMenu");
        // if (deptCate) deptCate.style.display = "";
        var adminVisitAsq = document.getElementById("adminVisitAsqMenu");
        if (adminVisitAsq) adminVisitAsq.style.display = "";
        
        // [적정성평가 Q&A 자료] 메뉴 표시 처리는 2026-08-05 제거 — 말풍선(qnaChat.jsp)으로 되돌아갔다.

        // 샘파일 업로드 현황 — 위너넷 담당자 전용(2026-08-05)
        var adminUpStat = document.getElementById("adminUploadStatMenu");
        if (adminUpStat) adminUpStat.style.display = "";

        
        // 적정성평가 월간보고서(menu-evalreport)는 2단계부터 전원 노출 — li 기본 표시(display 숨김 제거)라 별도 처리 불필요.
        var evalRptMenu = document.getElementById("menu-evalreport");
        if (evalRptMenu) evalRptMenu.style.display = "";

        // 자주 쓰는 메뉴 상단 고정 바 — 관리자만 (2026-08-05 최종)
        sbFavInit();
    }
})();

/* ══ 자주 쓰는 메뉴 — 상단 고정 가로 바 (관리자 전용, 2026-08-05 최종) ══════════
     · 사이드바 탭 방식은 "클릭해서 선택하기 불편" 하다 하여 폐기 — 화면과 별개로 상단에 <고정> 노출.
     · 저장 : localStorage 'wnnFavMenu' = { href:{nm,n,t} } / 접기 'wnnFavBarFold' — PC별, DB 없음.
     · 표시 : 클릭수 많은 순 → 최근 클릭 순 최대 7개. 시딩 없음(실제로 쓴 메뉴만).
     · 접기 : › 단추로 바를 접으면 동그란 ‹ 단추만 남는다(참고 이미지의 접힘 화살표와 동일 발상). */
var SB_FAV_KEY = 'wnnFavMenu', SB_FAV_MAX = 2;   /* 2026-08-12 사용자 요청: 4 → 2건 */

/* ── 저장 계층 (2026-08-11) ────────────────────────────────────────────────
     [증상] 바는 뜨는데 ①옮긴 자리가 페이지를 넘기면 원위치로 돌아가고 ②메뉴가 하나도 안 쌓였다.
     [원인] 둘 다 localStorage 에만 저장했는데, 이 브라우저에서 <사이트 데이터가 차단>돼 있으면
       setItem 이 예외를 던지거나 조용히 버려진다(try/catch 로 삼켜져 아무 표시도 안 났다).
       크롬에서 쿠키/사이트데이터를 막아 두면 이 상태가 된다(JSESSIONID 미전송 건과 같은 뿌리).
     [조치] <쓰고 바로 되읽어> 실제로 저장됐는지 확인하고, 안 되면 쿠키로 대신 저장한다.
       쿠키는 이 시스템이 이미 로그인·병원선택에 쓰고 있어 확실히 동작한다(getCookie/setCookie: top.jsp).
     ※값에 한글·세미콜론이 들어가므로 쿠키에는 반드시 encodeURIComponent 로 담는다. */
function sbStoreSet(k, v){
    try{
        localStorage.setItem(k, v);
        if (localStorage.getItem(k) === v){ return true; }   // 되읽어 확인 — 조용한 실패까지 잡는다
    }catch(e){}
    try{
        var d = new Date(); d.setDate(d.getDate() + 365);
        document.cookie = k + '=' + encodeURIComponent(v) + '; path=/; expires=' + d.toGMTString() + ';';
        return true;
    }catch(e2){ return false; }
}
function sbStoreGet(k){
    try{
        var v = localStorage.getItem(k);
        if (v !== null && v !== undefined) return v;
    }catch(e){}
    try{
        var m = ('; ' + document.cookie).split('; ' + k + '=');
        if (m.length === 2) return decodeURIComponent(m.pop().split(';').shift());
    }catch(e2){}
    return null;
}
function sbStoreDel(k){
    try{ localStorage.removeItem(k); }catch(e){}
    try{ document.cookie = k + '=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT;'; }catch(e2){}
}
/* ★고정 규칙 (2026-08-05 확정) — <먼저 들어온 5개가 고정>.
     5칸이 차면 새 메뉴를 아무리 써도 안 들어온다. 관리자가 × 로 빼서 자리를 비워야 다음 메뉴가 들어온다.
     자리 순서도 등록순 그대로 고정(사용횟수로 자리가 안 바뀜) — 횟수는 툴팁 참고용으로만 계속 센다. */
function sbFavLoad(){ try{ return JSON.parse(sbStoreGet(SB_FAV_KEY)) || null; }catch(e){ return null; } }
function sbFavSave(m){ try{ sbStoreSet(SB_FAV_KEY, JSON.stringify(m)); }catch(e){} }
/* 메뉴 사용 반영 — 이미 등록된 건 횟수만 +1, 빈자리가 있을 때만 새로 등록 */
function sbFavHit(href, nm){
    var mm = sbFavLoad() || {}, k, cnt = 0, maxOrd = 0;
    if (mm[href]){ mm[href].nm = nm || mm[href].nm; mm[href].n = (mm[href].n||0) + 1; mm[href].t = Date.now(); sbFavSave(mm); return; }
    for (k in mm){ if (mm.hasOwnProperty(k)){ cnt++; if ((mm[k].o||0) > maxOrd) maxOrd = mm[k].o||0; } }
    if (cnt >= SB_FAV_MAX) return;                 /* 꽉 참 — 고정, 새로 안 들어옴 */
    mm[href] = { nm:nm, n:1, t:Date.now(), o:maxOrd + 1 };
    sbFavSave(mm);
}
function sbFavInit(){
    /* ★두 번 불려도 바가 겹치지 않게 먼저 치운다 (2026-08-11) —
         겹치면 <나중에 생긴 빈 바>가 위를 덮어, 사용자 눈에는
         "메뉴가 잠깐 보였다가 사라지고 자리도 원위치로 돌아간" 것처럼 보인다.
         (뒤 바는 메뉴가 안 채워진 채 CSS 기본 자리 top:66px/right:14px 에 뜬다) */
    var _old = document.getElementById('wnnFavBar');
    if (_old && _old.parentNode) _old.parentNode.removeChild(_old);

    /* 저장값 정돈 — 옛(순위 변동) 방식 데이터를 고정 방식으로 1회 이행:
         n=0 잔재 제거 → 많이 쓴 순으로 5개만 남기고 등록순번(o) 부여 */
    var m0 = sbFavLoad();
    if (m0){
        var arr0 = [], k0, needOrd = false;
        for (k0 in m0){ if (m0.hasOwnProperty(k0)){
            if (!(m0[k0].n > 0)){ continue; }
            if (!m0[k0].o) needOrd = true;
            arr0.push({ href:k0, v:m0[k0] });
        } }
        if (needOrd || arr0.length > SB_FAV_MAX){
            arr0.sort(function(a,b){ return (a.v.o||999) - (b.v.o||999) || (b.v.n-a.v.n) || (b.v.t-a.v.t); });
            arr0 = arr0.slice(0, SB_FAV_MAX);
            var nm0 = {};
            for (var i0=0;i0<arr0.length;i0++){ arr0[i0].v.o = i0+1; nm0[arr0[i0].href] = arr0[i0].v; }
            /* ★빈 결과로는 절대 덮어쓰지 않는다 — 한 번이라도 비면 쌓아 둔 메뉴가 통째로 날아가
               "보였다가 사라지는" 꼴이 된다. 정돈은 어디까지나 다듬기지 초기화가 아니다. */
            if (Object.keys(nm0).length) sbFavSave(nm0);
        } else if (arr0.length !== Object.keys(m0).length){
            var nm1 = {}; for (var j0=0;j0<arr0.length;j0++) nm1[arr0[j0].href] = arr0[j0].v;
            if (Object.keys(nm1).length) sbFavSave(nm1);
        }
    }
    /* 사이드바 메뉴 클릭 반영 — 진짜 화면 이동 링크(href가 /로 시작)만.
       ★2026-08-11: 링크마다 리스너를 다는 대신 <document 에 한 번만> 달아 위임한다.
         종전 방식은 sbFavInit 이 도는 순간 화면에 있던 #sbAllMenu 링크만 잡아서,
         QPS 탭 전환 등으로 나중에 만들어지거나 그 밖에 있는 메뉴는 눌러도 안 쌓였다. */
    if (!window._sbFavClickBound){          /* 두 번 불려도 리스너는 하나만(클릭수 이중 집계 방지) */
    window._sbFavClickBound = true;
    document.addEventListener('click', function(ev){
        var a = ev.target && ev.target.closest ? ev.target.closest('a') : null;
        if (!a) return;
        if (!a.closest('.nav-left-sidebar, #sbAllMenu')) return;      // 사이드바 안의 링크만
        var href = a.getAttribute('href') || '';
        if (href.charAt(0) !== '/') return;                           // '#'(펼침 토글)·외부링크 제외
        sbFavHit(href, (a.textContent || '').replace(/\s+/g,' ').trim());
        /* 바를 <그 자리에서> 다시 그린다 — 종전에는 다음 화면이 로드될 때만 반영돼,
           새 창·모달로 열리는 메뉴를 누르면 눌러도 바가 그대로라 "안 쌓인다"고 보였다. */
        sbFavRender();
    }, true);
    }
    /* 바 골격을 body 에 직접 붙인다 — 어떤 화면 컨테이너의 영향도 받지 않게(fixed) */
    var bar = document.createElement('div');
    bar.id = 'wnnFavBar';
    bar.innerHTML =
        '<style>'
      + '#wnnFavBar{ position:fixed; top:66px; right:14px; z-index:11000;'   /* 우측 끝 고정(2026-08-05 요청) */
      + '  display:flex; align-items:center; gap:4px; padding:4px 6px 4px 10px; background:#fff;'
      + '  border:1px solid #bcd3f2; border-radius:20px; box-shadow:0 2px 8px rgba(23,70,162,.13);'
      + '  font-family:"Noto Sans KR","Malgun Gothic",sans-serif; white-space:nowrap; }'
      /* 제목표(★ 자주 쓰는 메뉴) = 끌어서 옮기는 손잡이 (2026-08-11 요청 — 월간보고서 편집 툴바를 가림) */
      + '#wnnFavBar .fv-tt{ font-size:15px; font-weight:800; color:#1746a2; margin-right:1px; line-height:1;'
      + '  cursor:move; user-select:none; -webkit-user-select:none; }'   /* 별표 하나 = 끌기 손잡이 */
      + '#wnnFavBar .fv-tt:hover{ color:#e8a400; }'                      /* 잡을 수 있는 곳임을 눈으로 */
      + '#wnnFavBar a.fv{ display:inline-block; padding:3px 10px; border-radius:14px; font-size:12.5px; font-weight:700;'
      + '  color:#3b4a5c; text-decoration:none; background:#f4f8fd; border:1px solid #e3ebf5; }'
      + '#wnnFavBar a.fv:hover{ background:#e8f1fd; color:#1746a2; border-color:#5b8def; }'
      + '#wnnFavBar a.fv.on{ background:#e8f1fd; color:#1746a2; border-color:#1746a2; }'
      + '#wnnFavBar .fv-x{ display:inline-block; margin-left:5px; color:#c0ccdb; font-weight:800; cursor:pointer; }'
      + '#wnnFavBar .fv-x:hover{ color:#e2564a; }'
      + '#wnnFavBar .fv-hint{ font-size:12px; color:#a3b2c5; padding:2px 6px; }'
      + '#wnnFavBar .fv-fold{ flex:0 0 auto; width:22px; height:22px; border:none; border-radius:50%;'
      + '  background:#1f6feb; color:#fff; font-weight:800; cursor:pointer; line-height:1; font-size:12px; }'
      + '#wnnFavBar.fold{ padding:4px; left:auto; right:14px; transform:none; }'   /* 접으면 우측 구석의 단추만 */
      + '#wnnFavBar.fold .fv-tt, #wnnFavBar.fold a.fv, #wnnFavBar.fold .fv-hint{ display:none; }'
      + '</style>'
      /* ★글자('자주 쓰는 메뉴')는 2026-08-11 요청으로 뺐다 — 메뉴가 늘면 바가 너무 길어진다.
           단 이 자리는 <끌어서 옮기는 손잡이>라 통째로 없애면 이동이 안 된다 → 별표만 남긴다. */
      + '<span class="fv-tt" title="자주 쓰는 메뉴 — 끌어서 옮기세요 (두 번 누르면 처음 자리로)">★</span>'
      + '<span id="wnnFavItems"></span>'
      + '<button type="button" class="fv-fold" id="wnnFavFold" title="자주 쓰는 메뉴 접기">›</button>';
    document.body.appendChild(bar);
    document.getElementById('wnnFavFold').addEventListener('click', function(){
        var fold = bar.className.indexOf('fold') < 0;
        bar.className = fold ? 'fold' : '';
        this.innerHTML = fold ? '‹' : '›';
        /* 접힌 동그라미가 뭔지 알 수 있게 툴팁으로 알려준다 (2026-08-05 요청 "팁으로 자주쓰는메뉴도 추가") */
        this.title = fold ? '자주 쓰는 메뉴 펼치기' : '자주 쓰는 메뉴 접기';
        sbStoreSet('wnnFavBarFold', fold ? 'Y' : 'N');
        /* 왼쪽 좌표로 고정해 둔 상태에서 펼치면 폭이 늘어 화면 밖으로 나갈 수 있다 — 안으로 끌어들인다.
           (오른쪽 여백 기준으로 붙여 둔 경우는 폭이 변해도 알아서 안쪽이라 손대지 않는다) */
        if (bar.style.left && bar.style.left !== 'auto'){ var r = bar.getBoundingClientRect(); sbFavPosSet(bar, r.left, r.top); }
    });
    var f = sbStoreGet('wnnFavBarFold') || '';
    if (f === 'Y'){ bar.className = 'fold';
        var fb = document.getElementById('wnnFavFold');
        fb.innerHTML = '‹'; fb.title = '자주 쓰는 메뉴 펼치기';
    }
    /* ★★순서가 중요하다 (2026-08-11 — 옮긴 자리가 계속 원위치로 돌아가던 원인) ★★
         자리 복원(sbFavPosApply)은 화면 밖으로 나가지 않게 clamp 하는데, 그 계산에 <바의 폭>을 쓴다.
         메뉴를 채우기 전에 복원하면 바가 '제목 + 단추' 뿐이라 폭이 150px 남짓 → 오른쪽 한계가
         실제보다 훨씬 왼쪽으로 잡혀, 저장해 둔 1198 이 1050 근처로 당겨졌다(눈에는 원위치로 보인다).
         그래서 <메뉴를 먼저 그려 폭을 확정한 뒤> 자리를 잡는다. */
    sbFavRender();
    sbFavPosApply(bar);      /* 저장해 둔 자리 복원 — 반드시 sbFavRender 뒤 */
    sbFavDragBind(bar);      /* 제목표를 잡고 끌어 옮기기 */
    /* 화면의 다른 스크립트가 늦게 레이아웃을 바꾸는 경우까지 대비해 로드 완료 후 한 번 더 자리를 잡는다 */
    if (document.readyState !== 'complete'){
        window.addEventListener('load', function(){ sbFavRender(); sbFavPosApply(bar); });
    }
}
/* ── 바 위치 옮기기 (2026-08-11 요청) ─────────────────────────────────────────
     월간보고서 편집 툴바(글꼴·크기)와 겹쳐 가려서 쓰기 불편하다 → 제목표(★ 자주 쓰는 메뉴)를 잡고 끌면 옮겨진다.
     · 자리는 localStorage 'wnnFavBarPos'(PC별) 에 남아 다음 접속에도 그대로.
     · 제목표를 <두 번 누르면> 처음 자리(우측 위)로 되돌린다.
     · 창 크기가 줄어 화면 밖으로 나가면 안으로 다시 끌어들인다(sbFavPosClamp).
     ★접힘(.fold) CSS 가 right:14px 를 주므로, 옮긴 뒤에는 반드시 inline right:auto 를 함께 둬야
       접었다 펼 때 자리가 우측으로 튀지 않는다. */
var SB_FAV_POS_KEY = 'wnnFavBarPos';
function sbFavPosClamp(bar, l, t){
    var w = bar.offsetWidth, h = bar.offsetHeight;
    var maxL = Math.max(0, (window.innerWidth  || 0) - w);
    var maxT = Math.max(0, (window.innerHeight || 0) - h);
    return { l: Math.min(Math.max(0, l), maxL), t: Math.min(Math.max(0, t), maxT) };
}
function sbFavPosSet(bar, l, t){
    var p = sbFavPosClamp(bar, l, t);
    bar.style.left = p.l + 'px'; bar.style.top = p.t + 'px'; bar.style.right = 'auto';
    return p;
}
/* ★붙여 둔 <쪽>을 기억한다 (2026-08-11) — 왼쪽 좌표로만 기억하면, 창 폭이 달라졌을 때
     '화면 밖으로 나가지 않게' 하는 보정에 걸려 왼쪽으로 확 당겨진다(= 원위치로 돌아간 것처럼 보임).
     바가 화면 오른쪽 절반에 있으면 <오른쪽 여백>으로, 왼쪽에 있으면 <왼쪽 좌표>로 저장한다. */
function sbFavPosSave(bar){
    var r = bar.getBoundingClientRect(), W = window.innerWidth || 0;
    var v = ((r.left + r.width/2) > W/2)
          ? { r: Math.max(0, Math.round(W - r.right)), t: Math.round(r.top) }
          : { l: Math.round(r.left),                   t: Math.round(r.top) };
    sbStoreSet(SB_FAV_POS_KEY, JSON.stringify(v));
}
function sbFavPosApply(bar){
    var p = null;
    try{ p = JSON.parse(sbStoreGet(SB_FAV_POS_KEY)); }catch(e){}
    if (!p || typeof p.t !== 'number') return;
    if (typeof p.r === 'number'){ bar.style.right = p.r + 'px'; bar.style.left = 'auto'; }
    else if (typeof p.l === 'number'){ bar.style.left = p.l + 'px'; bar.style.right = 'auto'; }
    else return;
    bar.style.top = p.t + 'px';
    /* 세로만 화면 안으로 보정한다. 가로는 위에서 붙인 쪽 기준이라 알아서 안쪽에 있다.
       ★이 시점엔 바 안의 <style> 이 아직 안 먹어 높이가 실제와 다를 수 있어 다음 프레임에 잰다. */
    var fix = function(){
        var h = bar.offsetHeight, maxT = Math.max(0, (window.innerHeight||0) - h);
        var t = Math.min(Math.max(0, p.t), maxT);
        if (t !== p.t) bar.style.top = t + 'px';
    };
    if (window.requestAnimationFrame) window.requestAnimationFrame(fix); else setTimeout(fix, 0);
}
function sbFavPosReset(bar){
    sbStoreDel(SB_FAV_POS_KEY);
    bar.style.left = ''; bar.style.top = ''; bar.style.right = '';
}
function sbFavDragBind(bar){
    var tt = bar.querySelector('.fv-tt'); if (!tt) return;
    var drag = null, saveTm = null;
    function pt(e){ return (e.touches && e.touches[0]) ? e.touches[0] : e; }
    /* 끄는 도중에도 저장해 둔다 — 마우스를 <iframe(PDF 미리보기 등) 위에서> 놓으면
       document 의 mouseup 이 안 와 up() 이 안 돌고, 그러면 자리가 통째로 날아갔다. */
    function saveSoon(){ if (saveTm) clearTimeout(saveTm);
        saveTm = setTimeout(function(){ saveTm = null; sbFavPosSave(bar); }, 150); }
    function down(e){
        var q = pt(e), r = bar.getBoundingClientRect();
        drag = { dx: q.clientX - r.left, dy: q.clientY - r.top };
        sbFavPosSet(bar, r.left, r.top);                 /* right 기준 → left 기준으로 전환 */
        document.body.style.userSelect = 'none';
        if (e.preventDefault) e.preventDefault();
    }
    function move(e){
        if (!drag) return;
        var q = pt(e);
        sbFavPosSet(bar, q.clientX - drag.dx, q.clientY - drag.dy);
        saveSoon();
        if (e.cancelable) e.preventDefault();
    }
    function up(){
        if (!drag) return;
        drag = null;
        document.body.style.userSelect = '';
        sbFavPosSave(bar);
    }
    tt.addEventListener('mousedown', down);
    tt.addEventListener('touchstart', down, { passive:false });
    document.addEventListener('mousemove', move);
    document.addEventListener('touchmove', move, { passive:false });
    document.addEventListener('mouseup', up);
    document.addEventListener('touchend', up);
    tt.addEventListener('dblclick', function(){ sbFavPosReset(bar); });
    /* 화면을 떠나기 직전 한 번 더 — 좌측 메뉴를 눌러 바로 이동하는 경우까지 자리를 붙든다 */
    window.addEventListener('beforeunload', function(){
        if (bar.style.left && bar.style.left !== 'auto') sbFavPosSave(bar);
        else if (bar.style.right && bar.style.right !== 'auto') sbFavPosSave(bar);
    });
    window.addEventListener('resize', function(){
        if (!bar.style.left || bar.style.left === 'auto') return;   /* 기본 자리·우측 고정은 손대지 않는다 */
        var r = bar.getBoundingClientRect();
        sbFavPosSet(bar, r.left, r.top);
        sbFavPosSave(bar);
    });
}
function sbFavRender(){
    var m = sbFavLoad() || {}, arr = [], k;
    for (k in m){ if (m.hasOwnProperty(k)) arr.push({ href:k, nm:m[k].nm, n:m[k].n||0, t:m[k].t||0, o:m[k].o||999 }); }
    arr.sort(function(a,b){ return a.o - b.o; });   /* 등록순 고정 — 사용횟수로 자리 안 바뀜 */
    arr = arr.slice(0, SB_FAV_MAX);
    /* 지금 떠 있는 화면 표시(on) — 주소는 dashboard.do 로 숨겨지므로 _realPath 로 판별(메모리 규칙) */
    var cur = '';
    try{ cur = (sessionStorage.getItem('_realPath') || location.pathname).split('?')[0]; }catch(e){}
    var h = '';
    if (!arr.length) h = '<span class="fv-hint">자주 쓰는 메뉴 — 메뉴를 사용하면 여기에 자동으로 쌓입니다</span>';
    for (var i=0;i<arr.length;i++){
        h += '<a class="fv' + (cur === arr[i].href ? ' on' : '') + '" href="' + arr[i].href + '"'
           + ' onclick="sbFavGo(this)" title="' + (arr[i].n||0) + '회 사용">' + arr[i].nm
           + '<span class="fv-x" title="자주 쓰는 메뉴에서 빼기" onclick="return sbFavDel(event, this)">×</span></a>';
    }
    var box = document.getElementById('wnnFavItems');
    if (box) box.innerHTML = h;
}
/* 바에서 실행 — 클릭수만 쌓고 href 기본 동작으로 자연스럽게 이동 */
function sbFavGo(a){
    var href = a.getAttribute('href') || '';
    var mm = sbFavLoad() || {};
    if (mm[href]){ mm[href].n = (mm[href].n||0) + 1; mm[href].t = Date.now(); sbFavSave(mm); }
}
/* × 로 해당 메뉴 빼기 — 이동은 막고 저장에서 지운 뒤 다시 그린다 (2026-08-05 요청) */
function sbFavDel(e, x){
    if (e){ e.preventDefault(); e.stopPropagation(); }
    var a = x.parentNode, href = a.getAttribute('href') || '';
    var mm = sbFavLoad() || {};
    if (mm[href]){ delete mm[href]; sbFavSave(mm); }
    sbFavRender();
    return false;
}

// ====== 파일업로드 관련 함수 ======
var asqSelectedFiles = new DataTransfer();

function openAsqFileInput() {
    document.getElementById('asq-file-input').click();
}

function asqHandleFiles(files) {
    for (var i = 0; i < files.length; i++) {
        asqSelectedFiles.items.add(files[i]);
    }
    document.getElementById('asq-file-input').files = asqSelectedFiles.files;
    asqShowNewFileList();
}

function asqDropHandler(event) {
    var files = event.dataTransfer.files;
    asqHandleFiles(files);
}

function asqShowNewFileList() {
    var html = '';
    var files = asqSelectedFiles.files;
    for (var i = 0; i < files.length; i++) {
        html += '<div class="file-item" style="display:flex; align-items:center; justify-content:space-between; padding:3px 8px; border-bottom:1px solid #eee;">' +
            '<span><i class="fa fa-file" style="color:#555; margin-right:5px;"></i>' + files[i].name +
            ' (' + Math.round(files[i].size / 1024) + 'KB)</span>' +
            '<button type="button" onclick="asqRemoveNewFile(' + i + ')" class="delete-btn" style="border:none; background:none; color:#333; cursor:pointer; font-size:12px;">삭제</button>' +
            '</div>';
    }
    document.getElementById('asq-file-list-new').innerHTML = html;
}

function asqRemoveNewFile(index) {
    var newDt = new DataTransfer();
    var files = asqSelectedFiles.files;
    for (var i = 0; i < files.length; i++) {
        if (i !== index) newDt.items.add(files[i]);
    }
    asqSelectedFiles = newDt;
    document.getElementById('asq-file-input').files = asqSelectedFiles.files;
    asqShowNewFileList();
}

function uploadAsqFiles(asqSeq, hospCd, regUser, callback) {
    var files = document.getElementById('asq-file-input').files;
    if (!files || files.length === 0) {
        if (typeof callback === 'function') callback();
        return;
    }

    var formData = new FormData();
    for (var i = 0; i < files.length; i++) {
        formData.append('file', files[i]);
    }
    formData.append('hospCd', hospCd || '');
    formData.append('fileGb', '4');
    formData.append('notiSeq', asqSeq);
    formData.append('regUser', regUser || '');
    formData.append('regIp', '');

    $.ajax({
        url: '/sftp/fileupload.do',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(res) {
            console.log('파일 업로드 성공:', res);
            if (typeof callback === 'function') callback();
        },
        error: function(xhr) {
            console.log('파일 업로드 실패:', xhr.responseText);
            alert('파일 업로드 중 오류가 발생했습니다.');
            if (typeof callback === 'function') callback();
        }
    });
}

function showAsqFileList(asqSeq) {
    if (!asqSeq) { $("#asq-file-table").hide(); return; }

    $.ajax({
        url: '/mangr/fileCdList.do',
        type: 'POST',
        data: { fileSeq: asqSeq, fileGb: '4' },
        dataType: 'json',
        success: function(data) {
            var tbody = document.getElementById('asq-file-tbody');
            tbody.innerHTML = '';
            if (data && data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    var subCodeNm = data[i].subCodeNm || '문서';
                    var fileTitle = data[i].fileTitle || '제목 없음';
                    var fileSize  = data[i].fileSize  || '';
                    var regDttm   = data[i].regDttm   || '';
                    var fileUrl   = '#';
                    if (data[i].filePath && data[i].fileTitle) {
                        fileUrl = '/sftp/download.do?filePath=' + encodeURIComponent(data[i].filePath);
                    }
                    var row = '<tr style="border-bottom: 1px solid #eee;">';
                    row += '<td style="padding:6px 8px; text-align:left;"><a href="javascript:void(0);" onclick="fn_fileDown(\'' + fileUrl + '\');" style="color:#2874A6; text-decoration:underline; font-weight:500;">' + fileTitle + '</a></td>';
                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:80px;">' + fileSize + ' KB</td>';
                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:140px;">' + regDttm + '</td>';
                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
                    row += "<a href='javascript:void(0);' onclick=\"deleteAsqFile('" + data[i].filePath + "','" + asqSeq + "');\" title='삭제' style='color:black;'>";
                    row += "<i class='fa-solid fa-trash' style='font-size: 1.1em;'></i>";
                    row += '</a></td>';
                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
                    if (fileUrl !== '#') {
                        row += "<a href='javascript:void(0);' onclick=\"fn_fileDown('" + fileUrl + "');\" title='다운로드' style='color:#28a745;'>";
                        row += "<img src='/images/winct/filedown.svg' alt='다운로드' style='width:16px; height:16px; vertical-align:middle;'>";
                        row += '</a>';
                    }
                    row += '</td>';
                    row += '</tr>';
                    tbody.innerHTML += row;
                }
                $("#asq-file-table").show();
            } else {
                tbody.innerHTML = "<tr><td colspan='5' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>";
                $("#asq-file-table").show();
            }
        }
    });
}

function deleteAsqFile(filePath, asqSeq) {
    Swal.fire({
        title: '삭제여부',
        text: '파일을 삭제하시겠습니까?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: '예',
        cancelButtonText: '아니오',
        customClass: { popup: 'small-swal' }
    }).then((result) => {
        if (result.isConfirmed) {
            var savedTitle = $("#qstnTitle").val();
            var savedConts = $("#qstnConts").val();
            var savedAnsr  = $("#ansrConts").val();
            var savedAnsrHtml = $("#ansrContsView").html();
            var savedWan   = $("#ansrWan").val();

            $.ajax({
                url: '/sftp/deleteFile.do',
                type: 'POST',
                data: {
                    hospCd: getCookie("hospid") || '',
                    filePath: filePath,
                    fileSeq: asqSeq,
                    fileGb: '4',
                    updUser: getCookie("userid") || '',
                    updIp: ''
                },
                success: function(res) {
                    console.log('파일 삭제 성공:', res);
                    $("#qstnTitle").val(savedTitle);
                    $("#qstnConts").val(savedConts);
                    $("#ansrConts").val(savedAnsr);
                    $("#ansrContsView").html(savedAnsrHtml);
                    $("#ansrWan").val(savedWan);
                    showAsqFileList(asqSeq);
                    Swal.fire({
                        title: '삭제완료',
                        text: '파일이 삭제되었습니다.',
                        icon: 'success',
                        confirmButtonText: '확인',
                        customClass: { popup: 'small-swal' }
                    });
                },
                error: function(xhr) {
                    Swal.fire({
                        title: '삭제실패',
                        text: '파일 삭제에 실패하였습니다.',
                        icon: 'error',
                        confirmButtonText: '확인',
                        customClass: { popup: 'small-swal' }
                    });
                }
            });
        } else if (result.isDismissed) {
            Swal.fire({
                title: '취소',
                text: '삭제가 취소되었습니다.',
                icon: 'info',
                confirmButtonText: '확인',
                customClass: { popup: 'small-swal' }
            });
        }
    });
}

function asqFileClear() {
    asqSelectedFiles = new DataTransfer();
    var fileInput = document.getElementById('asq-file-input');
    if (fileInput) fileInput.value = '';
    document.getElementById('asq-file-list-new').innerHTML = '';
    document.getElementById('asq-file-tbody').innerHTML = '';
    $("#asq-file-table").hide();
}

// 답변자 첨부파일 조회 (FILE_GB='5')
function showAnsrFileList(asqSeq) {
    if (!asqSeq) { $("#ansr-file-area").hide(); return; }

    $.ajax({
        url: '/mangr/fileCdList.do',
        type: 'POST',
        data: { fileSeq: asqSeq, fileGb: '5' },
        dataType: 'json',
        success: function(data) {
            var tbody = document.getElementById('ansr-file-tbody');
            tbody.innerHTML = '';
            if (data && data.length > 0) {
                for (var i = 0; i < data.length; i++) {
                    var subCodeNm = data[i].subCodeNm || '문서';
                    var fileTitle = data[i].fileTitle || '제목 없음';
                    var fileSize  = data[i].fileSize  || '';
                    var regDttm   = data[i].regDttm   || '';
                    var fileUrl   = '#';
                    if (data[i].filePath && data[i].fileTitle) {
                        fileUrl = '/sftp/download.do?filePath=' + encodeURIComponent(data[i].filePath);
                    }
                    var row = '<tr style="border-bottom: 1px solid #eee;">';
                    row += '<td style="padding:6px 8px; text-align:left;"><a href="javascript:void(0);" onclick="fn_fileDown(\'' + fileUrl + '\');" style="color:#2874A6; text-decoration:underline; font-weight:500;">' + fileTitle + '</a></td>';
                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:80px;">' + fileSize + ' KB</td>';
                    row += '<td style="text-align:center; padding:6px 8px; color:#555; white-space:nowrap; width:140px;">' + regDttm + '</td>';
                    row += '<td style="text-align:center; vertical-align:middle; padding:6px 4px; width:30px;">';
                    if (fileUrl !== '#') {
                        row += "<a href='javascript:void(0);' onclick=\"fn_fileDown('" + fileUrl + "');\" title='다운로드' style='color:#28a745;'>";
                        row += "<img src='/images/winct/filedown.svg' alt='다운로드' style='width:16px; height:16px; vertical-align:middle;'>";
                        row += '</a>';
                    }
                    row += '</td>';
                    row += '</tr>';
                    tbody.innerHTML += row;
                }
                $("#ansr-file-area").show();
            } else {
                tbody.innerHTML = "<tr><td colspan='4' style='text-align:center; color:#999;'>등록된 파일이 없습니다.</td></tr>";
                $("#ansr-file-area").show();
            }
        }
    });
}

</script>

<!-- ============================================================== -->
<!-- 하단 질문 알림 툴바 (공통) Start -->
<!-- ============================================================== -->
<style>
#todayAsqBar {
    position: fixed;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 36px;
    background: linear-gradient(135deg, #1e3a5f 0%, #2c5282 100%);
    color: #fff;
    display: none;
    align-items: center;
    z-index: 9999;
    box-shadow: 0 -2px 8px rgba(0,0,0,0.15);
    font-size: 13px;
    overflow: hidden;
}
#todayAsqBar .asq-bar-label {
    flex-shrink: 0;
    background: #e67e22;
    color: #fff;
    font-weight: 700;
    padding: 0 14px;
    height: 100%;
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    white-space: nowrap;
}
#todayAsqBar .asq-bar-scroll {
    flex: 1;
    overflow: hidden;
    height: 100%;
    display: flex;
    align-items: center;
}
#todayAsqBar .asq-bar-track {
    display: flex;
    align-items: center;
    white-space: nowrap;
    animation: asqMarquee 40s linear infinite;
    gap: 0;
}
#todayAsqBar .asq-bar-track:hover {
    animation-play-state: paused;
}
#todayAsqBar .asq-bar-spacer {
    display: inline-block;
    flex-shrink: 0;
    width: 100vw;       /* 화면 폭만큼 빈 공간을 두어 메세지가 우측 바깥에서 시작 */
}
#todayAsqBar .asq-bar-msg {
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 0 30px 0 0;
    white-space: nowrap;
}
#todayAsqBar .asq-bar-msg .hosp-name {
    font-weight: 700;
    color: #ffd700;
}
#todayAsqBar .asq-bar-msg .user-name {
    font-weight: 600;
    color: #90cdf4;
}
#todayAsqBar .asq-bar-msg .qstn-title {
    color: #fff;
    font-weight: 600;
}
#todayAsqBar .asq-bar-msg .ansr-badge {
    font-size: 11px;
    font-weight: 700;
    padding: 2px 8px;
    border-radius: 10px;
    background: linear-gradient(135deg, #f6ad55, #ed8936);
    color: #1a202c;
}
#todayAsqBar .asq-bar-msg .visit-badge {
    font-size: 11px;
    font-weight: 700;
    padding: 2px 8px;
    border-radius: 10px;
    background: linear-gradient(135deg, #68d391, #38a169);
    color: #fff;
}
#todayAsqBar .asq-bar-msg .sep {
    color: #4a7ab5;
    margin: 0 8px;
}
#todayAsqBar .asq-bar-toggle {
    flex-shrink: 0;
    background: rgba(255,255,255,0.15);
    border: 1px solid rgba(255,255,255,0.3);
    border-radius: 4px;
    color: #fff;
    font-size: 11px;
    cursor: pointer;
    padding: 3px 10px;
    margin-right: 8px;
    white-space: nowrap;
    transition: background 0.2s;
}
#todayAsqBar .asq-bar-toggle:hover {
    background: rgba(255,255,255,0.25);
}
#todayAsqBar .asq-bar-cnt {
    flex-shrink: 0;
    font-size: 11px;
    color: #a0aec0;
    padding: 0 6px;
    white-space: nowrap;
}
@keyframes asqMarquee {
    /* spacer가 우측 가시영역만큼 차지하므로 0%에서는 메세지가 우측 밖에 위치 → 좌측으로 흘러감 */
    0%   { transform: translateX(0); }
    100% { transform: translateX(-100%); }
}
</style>
<div id="todayAsqBar">
    <div class="asq-bar-label">
        <i class="fas fa-bell"></i> 알림
    </div>
    <div class="asq-bar-scroll">
        <div class="asq-bar-track" id="asqBarTrack"></div>
    </div>
    <div class="asq-bar-cnt" id="asqBarCnt"></div>
    <button class="asq-bar-toggle" id="asqBarToggle" onclick="fn_asqBarToggle()" title="메세지 끄기">
        <i class="fas fa-bell-slash"></i> 끄기
    </button>
</div>
<script type="text/javascript">
// ===== 하단 마퀴 질문 알림 (공통) =====

// 어제 날짜 문자열 생성
function fn_getDateStr(daysAgo) {
    var d = new Date();
    d.setDate(d.getDate() - daysAgo);
    var yyyy = d.getFullYear();
    var mm   = ('0' + (d.getMonth() + 1)).slice(-2);
    var dd   = ('0' + d.getDate()).slice(-2);
    return {
        dash:  yyyy + '-' + mm + '-' + dd,
        slash: yyyy + '/' + mm + '/' + dd,
        plain: yyyy + mm + dd
    };
}

// 페이지 로드시 질문 데이터 조회 (답변대기 + 문의대기 통합)
var _asqData = [];
var _visitData = [];

function fn_loadTodayAsq() {
    // 위너넷/병원 구분 없이 전체 메세지를 받아 프론트에서 마스킹/클릭 제어
    var hospCd = '';

    var done = 0;
    function checkDone() {
        done++;
        if (done >= 2) fn_todayAsqAlert(_asqData, _visitData);
    }

    // 1:1 문의 (답변대기)
    $.ajax({
        type: "POST",
        url: "/mangr/asqCdList.do",
        data: { hospCd: hospCd },
        dataType: "json",
        success: function(response) {
            _asqData = (response && response.data) ? response.data : [];
            checkDone();
        },
        error: function() { checkDone(); }
    });

    // 사이트방문문의 (문의대기)
    $.ajax({
        type: "POST",
        url: "/mangr/visitAsqList.do",
        data: { findData: '' },
        dataType: "json",
        success: function(response) {
            _visitData = (response && response.data) ? response.data : [];
            checkDone();
        },
        error: function() { checkDone(); }
    });
}

// 답변대기 + 문의대기 필터링 → 마퀴 표시
function fn_todayAsqAlert(asqList, visitList) {
    var bar = document.getElementById('todayAsqBar');
    if (!bar) return;

    // 답변대기 필터 (ansrWan != 'Y')
    var asqFiltered = [];
    if (asqList && asqList.length > 0) {
        for (var i = 0; i < asqList.length; i++) {
            var ansrWan = (asqList[i].ansrWan || '').toString().trim();
            if (ansrWan !== 'Y') asqFiltered.push(asqList[i]);
        }
    }

    // 문의대기 필터 (comformYn != 'Y')
    var visitFiltered = [];
    if (visitList && visitList.length > 0) {
        for (var i = 0; i < visitList.length; i++) {
            var comformYn = (visitList[i].comformYn || '').toString().trim();
            if (comformYn !== 'Y') visitFiltered.push(visitList[i]);
        }
    }

    var totalCnt = asqFiltered.length + visitFiltered.length;
    if (totalCnt === 0) {
        bar.style.display = 'none';
        return;
    }

    // 마퀴 메세지 생성
    var msgHtml = '';
    var idx = 0;

    // 위너넷 여부 + 현재 사용자 병원코드 (병원 사용자에서 자기 병원 메세지 구분용)
    var _isWnn = ((getCookie("s_wnn_yn") || '').trim() === 'Y');
    var _curHospCd = String(getCookie("s_hospid") || '').trim();
    // 자기 병원이거나 위너넷이면 풀 노출, 아니면 마스킹
    function _maskHosp(nm, isOwn) { return (_isWnn || isOwn) ? (nm || '') : '**** 병원'; }
    function _maskUser(nm, isOwn) { return (_isWnn || isOwn) ? (nm || '') : '***'; }
    // 클릭은 위너넷에서만 동작 (병원은 자기 병원 메세지여도 클릭 불가)
    var _asqClickAttr   = _isWnn ? 'onclick="fn_goAsqPage();"'      : 'style="cursor:default;"';
    var _visitClickAttr = _isWnn ? 'onclick="fn_goVisitAsqPage();"' : 'style="cursor:default;"';

    // 답변대기 메시지 (클릭 → asqcd.do, 위너넷만)
    for (var j = 0; j < asqFiltered.length; j++) {
        var item = asqFiltered[j];
        var rowHospCd = String(item.hospCd || '').trim();
        var isOwnAsq = (rowHospCd !== '' && _curHospCd !== '' && rowHospCd === _curHospCd);
        msgHtml += '<span class="asq-bar-msg" ' + _asqClickAttr + '>';
        if (idx > 0) msgHtml += '<span class="sep">|</span>';
        msgHtml += '<span class="hosp-name">' + _maskHosp(item.hospNm, isOwnAsq) + '</span> ';
        msgHtml += '<span class="user-name">' + _maskUser(item.userNm, isOwnAsq) + '</span>님 질문등록';
        var title = item.qstnTitle || '';
        if (title && (_isWnn || isOwnAsq)) {
            var shortTitle = title.length > 30 ? title.substring(0, 30) + '...' : title;
            msgHtml += ' - <span class="qstn-title">' + shortTitle + '</span>';
        }
        msgHtml += ' <span class="ansr-badge">응답대기</span>';
        msgHtml += '</span>';
        idx++;
    }

    // 문의대기 메시지 (클릭 → visitAsq.do, 위너넷만)
    // 사이트 방문 문의는 외부 방문자가 입력한 데이터 — 병원 사용자에게는 항상 마스킹
    for (var k = 0; k < visitFiltered.length; k++) {
        var vItem = visitFiltered[k];
        msgHtml += '<span class="asq-bar-msg" ' + _visitClickAttr + '>';
        if (idx > 0) msgHtml += '<span class="sep">|</span>';
        msgHtml += '<span class="hosp-name">' + _maskHosp(vItem.hospNm, false) + '</span> ';
        msgHtml += '<span class="user-name">' + _maskUser(vItem.userNm, false) + '</span>님 상담문의';
        msgHtml += ' <span class="visit-badge">응답대기</span>';
        msgHtml += '</span>';
        idx++;
    }

    // 우측 가시영역 밖에서 등장 → 유일한 메세지만 한 번씩 흘러가고, 모두 지나가면 루프 (중복 없음)
    var trackDiv = document.getElementById('asqBarTrack');
    trackDiv.innerHTML = '<span class="asq-bar-spacer"></span>' + msgHtml;

    // 메세지 수에 따라 애니메이션 속도 조정 (1건당 약 8초)
    // 조금 더 천천히 흐르도록 조정 (최소 30초, 1건당 약 12초)
    var duration = Math.max(30, totalCnt * 12);
    trackDiv.style.animationDuration = duration + 's';

    // 건수 표시
    var cntDiv = document.getElementById('asqBarCnt');
    if (cntDiv) {
        var cntText = '';
        if (asqFiltered.length > 0) cntText += '답변' + asqFiltered.length + '건';
        if (visitFiltered.length > 0) {
            if (cntText) cntText += ' / ';
            cntText += '문의' + visitFiltered.length + '건';
        }
        cntDiv.textContent = cntText;
    }

    bar.style.display = 'flex';

    // 이전에 끄기 상태였으면 복원
    var barOff = (getCookie("s_asq_bar_off") || '').trim();
    if (barOff === 'Y') {
        trackDiv.style.animationPlayState = 'paused';
        var scroll = bar.querySelector('.asq-bar-scroll');
        if (scroll) scroll.style.opacity = '0.3';
        var btn = document.getElementById('asqBarToggle');
        if (btn) btn.innerHTML = '<i class="fas fa-bell"></i> 켜기';
    }
}

// 하단 메시지 클릭 → 답변대기: 관리자 1:1 문의하기 페이지 이동
function fn_goAsqPage() {
    if (location.pathname.indexOf('/mangr/asqcd.do') >= 0) return;
    location.href = '/mangr/asqcd.do';
}

// 하단 메시지 클릭 → 문의대기: 사이트방문문의 페이지 이동
function fn_goVisitAsqPage() {
    if (location.pathname.indexOf('/mangr/visitasq.do') >= 0) return;
    location.href = '/mangr/visitasq.do';
}

function fn_asqBarToggle() {
    var bar = document.getElementById('todayAsqBar');
    var track = document.getElementById('asqBarTrack');
    var btn = document.getElementById('asqBarToggle');
    var scroll = bar ? bar.querySelector('.asq-bar-scroll') : null;

    if (track && track.style.animationPlayState !== 'paused') {
        // 끄기
        track.style.animationPlayState = 'paused';
        if (scroll) scroll.style.opacity = '0.3';
        if (btn) btn.innerHTML = '<i class="fas fa-bell"></i> 켜기';
        setCookie("s_asq_bar_off", "Y", 1);
    } else {
        // 켜기
        if (track) track.style.animationPlayState = 'running';
        if (scroll) scroll.style.opacity = '1';
        if (btn) btn.innerHTML = '<i class="fas fa-bell-slash"></i> 끄기';
        setCookie("s_asq_bar_off", "N", 1);
    }
}

// 로그인 상태이면 위너넷/병원 모두 자동 조회 + 30초 주기 갱신
$(document).ready(function() {
    var hospId = getCookie("s_hospid");
    if (hospId && hospId !== '') {
        fn_loadTodayAsq();
        setInterval(fn_loadTodayAsq, 30000);
    }
});
</script>
<!-- ============================================================== -->
<!-- 하단 질문 알림 툴바 (공통) End -->
<!-- ============================================================== -->

<script>
/* ══ QPS 메뉴 표시 토글 — 키워드 'qps' 타이핑 (2026-08-08) ═══════════════════
     사용자 지시: "적정성평가 말고 별도 QPS 메뉴로, 핫키는 동일하게 저만 보이게".
     ★[2026-08-08 변경] 종전 Ctrl+Alt+Q 는 **다른 프로그램이 먼저 가로채서** 엉뚱하게 동작했다
       (윈도우에서 Ctrl+Alt 조합은 캡처도구·원격툴·메신저 등이 전역 단축키로 자주 점유한다.
        게다가 한글 키보드에서 Ctrl+Alt 는 AltGr 로 해석되기도 한다).
       → **조합키를 아예 쓰지 않는다.** 입력칸 밖에서 `q` `p` `s` 를 이어서 치면 토글된다.
         브라우저·OS 가 가로챌 수 없는 방식이라 어디서든 확실히 먹는다.
     · 안전장치 : 입력칸(input/textarea/select/contenteditable) 안에서는 절대 반응하지 않는다.
                  Ctrl·Alt·Meta 가 눌린 상태도 무시(다른 단축키와 섞이지 않게).
     · 사이드바에 두었으므로 **어느 화면에서든** 먹는다.
     · 저장 = localStorage('qpsDev') — 이 PC 이 브라우저에서만 켜진다(서버·DB 무관, 다른 사람에겐 안 보임).
     · 이중 게이트 : 위너넷(s_wnn_yn='Y') 이 아니면 쳐도 메뉴가 안 나온다.
     · 정식 오픈 시 : 이 스크립트와 li 의 display:none 만 지우면 된다.                        */
(function(){
    // ★[2026-08-08 변경] localStorage → sessionStorage.
    //   localStorage 는 브라우저를 닫아도 남아서 "qps 를 안 쳐도 메뉴가 계속 보였다"(사용자 지적).
    //   sessionStorage 는 그 탭/세션에서만 유효 → 브라우저를 닫으면 자동으로 꺼진다 = "qps 칠 때만 작동".
    //   ↓ 옛 localStorage 잔재 제거(안 지우면 apply 가 계속 켜진 것으로 본다).
    var KEY = 'qpsDev';
    try { localStorage.removeItem(KEY); } catch(e){}
    function flagOn(){ try { return sessionStorage.getItem(KEY) === 'Y'; } catch(e){ return false; } }
    function flagSet(v){ try { sessionStorage.setItem(KEY, v); } catch(e){} }
    var WORD = 'qps', buf = '', bufTimer = null;
    function isWnn(){
        // getCookie 는 top.jsp 정의분. 못 찾으면 직접 읽는다 —
        // 여기서 조용히 false 가 되면 '핫키를 눌러도 아무 일이 없다'가 되어 원인을 못 찾는다.
        try { if (typeof getCookie === 'function') return (getCookie("s_wnn_yn") || '').trim() === 'Y'; } catch(e){}
        try {
            var m = ('; ' + document.cookie).match(/;\s*s_wnn_yn=([^;]*)/);
            return m ? decodeURIComponent(m[1]).trim() === 'Y' : false;
        } catch(e){ return false; }
    }
    // ★게이트 판정을 밖에서도 쓸 수 있게 노출한다(top.jsp 의 QPS 탭 복원 로직이 본다).
    //   안 그러면 '마지막 선택 탭' 복원이 게이트를 무시하고 QPS 메뉴를 다시 펼친다 — 게이트가 새는 길.
    window.qpsMenuOn = function(){ return flagOn() && isWnn(); };
    function apply(){
        var on = (flagOn() && isWnn());
        var li = document.getElementById('menu-qps');
        if (li) li.style.display = on ? '' : 'none';
        // 상단 QPS 탭도 같은 게이트를 쓴다(2026-08-09) — 사이드바만 켜면 탭이 없어 들어갈 길이 없다
        var tab = document.getElementById('top-menu_qps');
        if (tab) tab.style.display = on ? '' : 'none';
    }
    function toggle(){
        if (!isWnn()) return;                           // 위너넷 아니면 아무 일도 없다
        var on = false;
        try {
            on = flagOn();
            flagSet(on ? 'N' : 'Y');
        } catch(e){}
        apply();
        // 안내는 넉넉히 보여준다 — 1.4초는 "떴다 사라졌다"는 지적을 받았다(2026-08-08).
        // 마우스를 올리면 멈추고, 진행바로 남은 시간이 보인다.
        try {
            if (typeof Swal !== 'undefined') {
                Swal.fire({ toast:true, position:'top-end', width:380, timer:4000,
                            timerProgressBar:true, showConfirmButton:false, icon:'info',
                            title:'QPS 메뉴 ' + (on ? '숨김' : '표시'),
                            text: on ? '다시 보려면 qps 를 치세요.' : '상단 [QPS] 탭 · 좌측 [QPS-환자안전]',
                            didOpen: function(el){
                                el.addEventListener('mouseenter', Swal.stopTimer);
                                el.addEventListener('mouseleave', Swal.resumeTimer);
                            } });
            }
        } catch(e){}
    }
        
    function inField(t){
        if (!t) return false;
        var tag = (t.tagName || '').toUpperCase();
        return tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT' || t.isContentEditable === true;
    }
    document.addEventListener('keydown', function(ev){
        if (ev.ctrlKey || ev.altKey || ev.metaKey) { buf = ''; return; }   // 조합키는 남의 단축키
        if (inField(ev.target)) { buf = ''; return; }                      // 입력 중에는 절대 반응 안 함
        // 물리키(code)로 본다 — 한/영 모드가 한글이어도 KeyQ 는 KeyQ 다
        var ch = (ev.code && ev.code.indexOf('Key') === 0) ? ev.code.charAt(3).toLowerCase()
                                                          : (ev.key || '').toLowerCase();
        if (ch.length !== 1 || ch < 'a' || ch > 'z') { buf = ''; return; }
        buf += ch;
        if (WORD.indexOf(buf) !== 0) buf = (ch === WORD.charAt(0)) ? ch : '';   // 어긋나면 처음부터
        if (bufTimer) clearTimeout(bufTimer);
        bufTimer = setTimeout(function(){ buf = ''; }, 1500);                   // 천천히 치면 초기화
        if (buf === WORD) { buf = ''; toggle(); }
    });
    /* 확실한 뒷문 — 키 입력이 어떤 이유로든 안 먹을 때를 위한 URL 스위치.
       예) /main/assessment.do?qpsdev=y  (끄기는 qpsdev=n)
       ★main.jsp 가 주소를 /user/dashboard.do 로 숨기므로 location.search 가 이미 지워졌을 수 있다
         → 원래 경로를 담아 둔 sessionStorage('_realPath') 도 함께 본다. */
    (function(){
        var s = '';
        try { s = (location.search || '') + '|' + (sessionStorage.getItem('_realPath') || ''); } catch(e){}
        var m = s.toLowerCase().match(/qpsdev=([yn])/);
        if (m) flagSet(m[1] === 'y' ? 'Y' : 'N');
    })();

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', apply);
    else apply();
})();
</script>

<%-- ═══ 부서별 점검표 줄을 자료에서 그린다 (2026-08-18) ═══════════════════════
     왜 : 15줄이 손으로 적혀 있어 **서식이 늘고 줄 때마다 사람이 고쳐야** 했다.
          2026-08-15 서식 0종인 감염관리·진료를 손으로 지웠고, 08-18 감염관리에 서식이 생겨
          ***다시 넣어야 하는 상태***가 됐다. 그 손질을 없앤다.

     ★***사이드바는 모든 화면에 뜨는 타일***이다 — 화면마다 조회가 붙으면 안 된다.
       ⇒ ⓐQPS 메뉴 게이트가 켜진 사람만 ⓑ**[부서별 점검표] 를 처음 펼칠 때 한 번**만 부른다.
     ★sessionStorage 에 담아 **다음 화면에서는 곧바로 그린다**(깜빡임 없음). 그 뒤 조용히 다시 받아
       달라졌으면 고쳐 그린다 — 서식을 등록한 직후에도 오래된 줄이 남지 않는다.
     ⚠★***못 받으면 아무것도 하지 않는다*** — JSP 에 적힌 폴백 줄이 그대로 보인다.
       메뉴가 통째로 비면 업무가 멈춘다. 「조회 실패 = 빈 메뉴」로 만들지 말 것.        --%>
<script>
(function(){
  var KEY = 'qpsDeptMenu', done = false;

  function paint(menu){
    var ul = document.getElementById('qps-dept-list');
    if (!ul || !menu || !menu.length) return;              // ★빈 목록이면 폴백을 남긴다
    var h = '';
    for (var i = 0; i < menu.length; i++) {
      var m = menu[i];
      var cd = String(m.cd || '').replace(/[^A-Z0-9_]/g, '');   // 주소에 들어가는 값 — 아는 모양만
      var nm = String(m.nm || cd).replace(/[&<>"]/g, function(c){
        return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'})[c]; });
      if (!cd) continue;
      h += '<li class="nav-item"><a class="nav-item nav-link" href="/main/qpsChk.do?dept=' + cd + '">'
         + nm + '</a></li>';
    }
    if (h) ul.innerHTML = h;
  }

  function load(){
    if (done) return; done = true;
    // ⓐ담아 둔 것이 있으면 먼저 그린다(다음 화면부터는 곧바로 보인다)
    try {
      var c = sessionStorage.getItem(KEY);
      if (c) paint(JSON.parse(c));
    } catch (e) {}
    // ⓑ그러고 나서 조용히 다시 받는다 — ★dataType:'json' 필수
    try {
      $.ajax({ url:'/qps/deptMenu.do', type:'POST', dataType:'json' })
       .done(function(res){
         if (!res || res.result !== 'OK' || !res.menu || !res.menu.length) return;   // 실패 = 폴백 유지
         paint(res.menu);
         try { sessionStorage.setItem(KEY, JSON.stringify(res.menu)); } catch (e) {}
       });
    } catch (e) {}
  }

  function bind(){
    var a = document.querySelector('a[data-target="#qps-g-dept"]');
    if (a) a.addEventListener('click', function(){ if (!window.qpsMenuOn || window.qpsMenuOn()) load(); });
    // 이미 펼쳐진 채로 들어온 경우(탭 복원)에도 한 번 받는다
    var box = document.getElementById('qps-g-dept');
    if (box && box.className.indexOf('show') >= 0 && (!window.qpsMenuOn || window.qpsMenuOn())) load();
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', bind);
  else bind();
})();
</script>


<script>
/* ── 신규병원 게이트 ───────────────────────────────────────────────
   승인은 받았지만 신청서를 아직 제출하지 않은 병원은 메뉴를 잠근다.
   대시보드 진입만 막으면 주소를 직접 쳐서 다른 화면에 들어갈 수 있다.

   ★판정에 실패하면 아무것도 하지 않는다(fail-open) — 조회 하나 때문에
     기존 병원의 메뉴가 사라지는 일이 있어서는 안 된다. */
(function(){
  function lock(){
    var box = document.getElementById('sbAllMenu');
    if (!box) return;

    box.querySelectorAll('a').forEach(function(a){
      var href = a.getAttribute('href') || '';
      if (href.indexOf('/join/joinDocs.do') >= 0) return;   // 제출 화면만 열어둔다
      a.style.opacity = '.45';
      a.style.pointerEvents = 'none';
      a.setAttribute('title', '동의서를 제출하셔야 이용하실 수 있습니다.');
    });

    var msg = document.createElement('li');
    msg.style.cssText = 'padding:10px 14px; margin:6px 10px; border-radius:6px;'
                      + 'background:#fff8e8; border:1px solid #f0d9a8; color:#8a6420;'
                      + 'font-size:12px; line-height:1.6; list-style:none;';
    msg.innerHTML = '동의서를 제출하셔야<br>프로그램을 이용하실 수 있습니다.'
                  + '<div style="margin-top:6px;"><a href="/join/joinDocs.do"'
                  + ' style="color:#1f5a4b; font-weight:700;">동의서 제출하러 가기 →</a></div>';
    box.insertBefore(msg, box.firstChild);
  }

  function chk(){
    if (!window.jQuery) return;
    jQuery.ajax({
      type:'post', url:'/join/joinGate.do', dataType:'json',
      success:function(d){ if (d && d.gate === 'Y') lock(); },
      error:function(){}          /* 실패하면 잠그지 않는다 */
    });
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', chk);
  else chk();
})();
</script>
<!-- ============================================================== -->
<!-- sidebar end -->
<!-- ============================================================== -->
        
        
        
