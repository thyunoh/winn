<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
/* ===== Dashboard Variables & Base ===== */
:root {
    --dash-primary: #2c3e50;
    --dash-info: #3498db;
    --dash-success: #27ae60;
    --dash-warning: #f39c12;
    --dash-danger: #e74c3c;
    --dash-purple: #8e44ad;
    --dash-teal: #1abc9c;
    --dash-dark: #34495e;
    --dash-light-bg: #f8f9fc;
    --dash-border: #e3e6f0;
    --dash-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
}

.dashboard-container {
    background-color: var(--dash-light-bg);
    min-height: 100vh;
}

/* ===== Summary Cards ===== */
.summary-card {
    border: none;
    border-radius: 0.55rem;
    box-shadow: var(--dash-shadow);
    transition: transform 0.15s ease, box-shadow 0.15s ease;
    overflow: hidden;
}
.summary-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 0.5rem 2rem rgba(58, 59, 69, 0.18);
}
.summary-card .card-body {
    padding: 1.25rem 1.5rem;
    position: relative;
}
.summary-card .card-icon {
    position: absolute;
    top: 1rem;
    right: 1.25rem;
    font-size: 2rem;
    opacity: 0.25;
    color: #fff;
}
.summary-card .card-title-text {
    font-size: 0.8rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: rgba(255,255,255,0.85);
    margin-bottom: 0.5rem;
}
.summary-card .card-big-number {
    font-size: 2.2rem;
    font-weight: 800;
    color: #fff;
    line-height: 1.1;
}
.summary-card .card-sub-info {
    font-size: 0.82rem;
    color: rgba(255,255,255,0.8);
    margin-top: 0.5rem;
}

.bg-gradient-primary   { background: linear-gradient(135deg, #2c3e50, #3d5875); }
.bg-gradient-info      { background: linear-gradient(135deg, #3498db, #5dade2); }
.bg-gradient-success   { background: linear-gradient(135deg, #27ae60, #2ecc71); }
.bg-gradient-warning   { background: linear-gradient(135deg, #e67e22, #f39c12); }
.bg-gradient-danger    { background: linear-gradient(135deg, #c0392b, #e74c3c); }
.bg-gradient-purple    { background: linear-gradient(135deg, #8e44ad, #a569bd); }
.bg-gradient-teal      { background: linear-gradient(135deg, #16a085, #1abc9c); }

/* ===== Chart Cards ===== */
.chart-card {
    border: none;
    border-radius: 0.55rem;
    box-shadow: var(--dash-shadow);
    background: #fff;
}
.chart-card .card-header {
    background: #fff;
    border-bottom: 1px solid var(--dash-border);
    font-weight: 700;
    font-size: 0.95rem;
    color: var(--dash-primary);
    padding: 1rem 1.5rem;
    border-radius: 0.55rem 0.55rem 0 0;
}
.chart-card .card-body {
    padding: 1.25rem;
}

/* ===== Table Styling ===== */
.dash-table {
    font-size: 0.85rem;
}
.dash-table thead th {
    background-color: #f8f9fc;
    color: var(--dash-primary);
    font-weight: 700;
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 0.03em;
    border-bottom: 2px solid var(--dash-border);
    padding: 0.7rem 0.75rem;
    white-space: nowrap;
}
.dash-table tbody td {
    padding: 0.65rem 0.75rem;
    vertical-align: middle;
    border-top: 1px solid #f0f0f0;
}
.dash-table tbody tr:hover {
    background-color: #f1f5ff;
}

/* ===== Badge Styles ===== */
.badge-cert      { background-color: var(--dash-success); color: #fff; }
.badge-cond      { background-color: var(--dash-warning); color: #fff; }
.badge-uncert    { background-color: var(--dash-danger); color: #fff; }
.badge-plan      { background-color: var(--dash-info); color: #fff; }
.badge-progress  { background-color: var(--dash-warning); color: #fff; }
.badge-done      { background-color: var(--dash-success); color: #fff; }

.badge-status {
    font-size: 0.78rem;
    padding: 0.35em 0.65em;
    border-radius: 0.35rem;
    font-weight: 600;
}

/* ===== Progress Bars ===== */
.progress-lg {
    height: 1.5rem;
    border-radius: 0.5rem;
    font-size: 0.8rem;
}
.progress-md {
    height: 0.75rem;
    border-radius: 0.4rem;
}

/* ===== Phase Cards ===== */
.phase-card {
    border: 2px solid var(--dash-border);
    border-radius: 0.55rem;
    padding: 1.25rem;
    text-align: center;
    transition: border-color 0.2s ease;
    background: #fff;
}
.phase-card.active {
    border-color: var(--dash-info);
    box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.15);
}
.phase-card .phase-icon {
    font-size: 2rem;
    margin-bottom: 0.5rem;
}
.phase-card .phase-title {
    font-weight: 700;
    font-size: 0.95rem;
    color: var(--dash-primary);
}
.phase-card .phase-pct {
    font-size: 1.5rem;
    font-weight: 800;
    margin: 0.5rem 0;
}
.phase-arrow {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    color: #bdc3c7;
}

/* ===== Quick Links ===== */
.quick-link-btn {
    border: 1px solid var(--dash-border);
    border-radius: 0.55rem;
    padding: 1rem;
    text-align: center;
    background: #fff;
    transition: all 0.15s ease;
    cursor: pointer;
    text-decoration: none;
    display: block;
    box-shadow: var(--dash-shadow);
}
.quick-link-btn:hover {
    border-color: var(--dash-info);
    background: #f0f7ff;
    transform: translateY(-2px);
    text-decoration: none;
}
.quick-link-btn .link-icon {
    font-size: 1.8rem;
    margin-bottom: 0.5rem;
    display: block;
}
.quick-link-btn .link-text {
    font-size: 0.85rem;
    font-weight: 600;
    color: var(--dash-primary);
}

/* ===== Section Headers ===== */
.section-header {
    font-size: 1rem;
    font-weight: 700;
    color: var(--dash-primary);
    margin-bottom: 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 2px solid var(--dash-info);
    display: inline-block;
}

/* ===== QPS Indicator ===== */
.qps-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.4rem 0;
    border-bottom: 1px dashed #eee;
}
.qps-item:last-child { border-bottom: none; }
.qps-label { font-size: 0.82rem; color: #555; }
.qps-value { font-weight: 700; font-size: 0.9rem; }
</style>

<div class="dashboard-container px-3 py-3">

    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h4 class="mb-0 font-weight-bold" style="color: var(--dash-primary);">
                <i class="fas fa-tachometer-alt mr-2"></i>요양병원 인증 대시보드
            </h4>
            <small class="text-muted" id="dashUpdateTime">최종 갱신: -</small>
        </div>
        <button class="btn btn-sm btn-outline-secondary" onclick="loadDashboardData()">
            <i class="fas fa-sync-alt mr-1"></i>새로고침
        </button>
    </div>

    <!-- ===== Row 1: Summary Cards ===== -->
    <div class="row mb-4">
        <!-- Card 1: 인증 현황 -->
        <div class="col-xl-3 col-md-6 mb-3">
            <div class="card summary-card bg-gradient-primary">
                <div class="card-body">
                    <div class="card-icon"><i class="fas fa-certificate"></i></div>
                    <div class="card-title-text">인증 현황</div>
                    <div class="mb-2">
                        <span id="certStatusBadge" class="badge badge-status badge-cert">인증</span>
                    </div>
                    <div class="card-sub-info">
                        <span id="certCycle">인증주기: 4주기</span><br>
                        <span id="certExpiry">만료일: 2027-12-31</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card 2: 자체평가 점수 -->
        <div class="col-xl-3 col-md-6 mb-3">
            <div class="card summary-card bg-gradient-info">
                <div class="card-body">
                    <div class="card-icon"><i class="fas fa-chart-line"></i></div>
                    <div class="card-title-text">자체평가 점수</div>
                    <div class="card-big-number" id="selfEvalScore">80.7</div>
                    <div class="card-sub-info">
                        목표 대비 달성률
                        <div class="progress progress-md mt-1" style="background: rgba(255,255,255,0.25);">
                            <div id="selfEvalProgress" class="progress-bar" role="progressbar"
                                 style="width:89.7%; background-color: rgba(255,255,255,0.9);" aria-valuenow="89.7">
                            </div>
                        </div>
                        <small id="selfEvalTarget">목표: 90점 | 달성률: 89.7%</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card 3: 개선활동 현황 -->
        <div class="col-xl-3 col-md-6 mb-3">
            <div class="card summary-card bg-gradient-success">
                <div class="card-body">
                    <div class="card-icon"><i class="fas fa-tasks"></i></div>
                    <div class="card-title-text">개선활동 현황</div>
                    <div class="d-flex align-items-end mb-1">
                        <span class="card-big-number mr-2" id="improveTotal">12</span>
                        <span style="color: rgba(255,255,255,0.8); font-size:0.85rem;">건</span>
                    </div>
                    <div class="card-sub-info">
                        <span class="mr-2" id="impPlan">계획 <strong>3</strong></span>
                        <span class="mr-2" id="impProg">진행 <strong>5</strong></span>
                        <span class="mr-2" id="impDone">완료 <strong>4</strong></span>
                    </div>
                    <div class="card-sub-info mt-1">
                        <span style="color: #ffe08a;" id="impOverdue"><i class="fas fa-exclamation-triangle mr-1"></i>미완료(기한초과) <strong>2</strong>건</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card 4: QPS 지표 -->
        <div class="col-xl-3 col-md-6 mb-3">
            <div class="card summary-card bg-gradient-warning">
                <div class="card-body">
                    <div class="card-icon"><i class="fas fa-heartbeat"></i></div>
                    <div class="card-title-text">QPS 핵심지표</div>
                    <div class="card-big-number" id="qpsRate">87.5<small style="font-size:0.9rem;">%</small></div>
                    <div class="card-sub-info" id="qpsDetail">
                        <div class="qps-item" style="border-color: rgba(255,255,255,0.2);">
                            <span class="qps-label" style="color:rgba(255,255,255,0.8);">낙상발생률</span>
                            <span class="qps-value" style="color:#fff;">0.8%</span>
                        </div>
                        <div class="qps-item" style="border-color: rgba(255,255,255,0.2);">
                            <span class="qps-label" style="color:rgba(255,255,255,0.8);">손위생수행률</span>
                            <span class="qps-value" style="color:#fff;">94.2%</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== Row 2: Charts ===== -->
    <div class="row mb-4">
        <!-- Bar Chart: 영역별 평가점수 -->
        <div class="col-xl-8 col-lg-7 mb-3">
            <div class="card chart-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-chart-bar mr-2 text-primary"></i>영역별 평가점수</span>
                    <small class="text-muted">100점 만점 기준</small>
                </div>
                <div class="card-body">
                    <div style="position: relative; height: 320px;">
                        <canvas id="domainScoreChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Doughnut Chart: 개선활동 상태 -->
        <div class="col-xl-4 col-lg-5 mb-3">
            <div class="card chart-card h-100">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span><i class="fas fa-chart-pie mr-2 text-primary"></i>개선활동 상태</span>
                </div>
                <div class="card-body d-flex flex-column align-items-center justify-content-center">
                    <div style="position: relative; width: 240px; height: 240px;">
                        <canvas id="improveStatusChart"></canvas>
                    </div>
                    <div class="mt-3 text-center" id="improveChartLegend">
                        <span class="mr-3"><i class="fas fa-circle text-info mr-1"></i>계획</span>
                        <span class="mr-3"><i class="fas fa-circle text-warning mr-1"></i>진행</span>
                        <span><i class="fas fa-circle text-success mr-1"></i>완료</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== Row 3: Tables ===== -->
    <div class="row mb-4">
        <!-- 최근 자체평가 내역 -->
        <div class="col-xl-6 mb-3">
            <div class="card chart-card h-100">
                <div class="card-header">
                    <i class="fas fa-clipboard-list mr-2 text-primary"></i>최근 자체평가 내역
                </div>
                <div class="card-body p-0">
                    <table class="table dash-table mb-0" id="selfEvalTable">
                        <thead>
                            <tr>
                                <th class="text-center" style="width:50px;">No</th>
                                <th class="text-center">평가년도</th>
                                <th class="text-center">주기</th>
                                <th class="text-center">상태</th>
                                <th class="text-center">결과</th>
                                <th class="text-center">점수</th>
                            </tr>
                        </thead>
                        <tbody id="selfEvalBody">
                            <tr><td colspan="6" class="text-center py-4 text-muted">데이터를 불러오는 중...</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 최근 개선활동 -->
        <div class="col-xl-6 mb-3">
            <div class="card chart-card h-100">
                <div class="card-header">
                    <i class="fas fa-tools mr-2 text-primary"></i>최근 개선활동
                </div>
                <div class="card-body p-0">
                    <table class="table dash-table mb-0" id="improveTable">
                        <thead>
                            <tr>
                                <th class="text-center" style="width:50px;">No</th>
                                <th>제목</th>
                                <th class="text-center" style="width:70px;">상태</th>
                                <th class="text-center" style="width:80px;">담당자</th>
                                <th class="text-center" style="width:110px;">목표일</th>
                            </tr>
                        </thead>
                        <tbody id="improveBody">
                            <tr><td colspan="5" class="text-center py-4 text-muted">데이터를 불러오는 중...</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== Row 4: 인증 준비 현황 ===== -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card chart-card">
                <div class="card-header">
                    <i class="fas fa-flag-checkered mr-2 text-primary"></i>인증 준비 현황
                </div>
                <div class="card-body">
                    <!-- 전체 진행률 -->
                    <div class="mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="font-weight-bold" style="color: var(--dash-primary);">전체 진행률</span>
                            <span class="font-weight-bold" style="font-size:1.1rem; color: var(--dash-info);" id="totalProgressPct">68%</span>
                        </div>
                        <div class="progress progress-lg">
                            <div id="totalProgressBar" class="progress-bar bg-info progress-bar-striped progress-bar-animated"
                                 role="progressbar" style="width: 68%;" aria-valuenow="68">
                                68%
                            </div>
                        </div>
                    </div>

                    <!-- 단계별 카드 -->
                    <div class="row align-items-center">
                        <div class="col-lg col-md-4 mb-2">
                            <div class="phase-card active" id="phase1">
                                <div class="phase-icon" style="color: var(--dash-info);"><i class="fas fa-search"></i></div>
                                <div class="phase-title">1단계: 현황파악</div>
                                <div class="phase-pct" style="color: var(--dash-success);" id="phase1Pct">95%</div>
                                <div class="progress progress-md">
                                    <div class="progress-bar bg-success" style="width:95%;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-auto phase-arrow d-none d-lg-flex">
                            <i class="fas fa-chevron-right"></i>
                        </div>
                        <div class="col-lg col-md-4 mb-2">
                            <div class="phase-card active" id="phase2">
                                <div class="phase-icon" style="color: var(--dash-warning);"><i class="fas fa-cogs"></i></div>
                                <div class="phase-title">2단계: 시스템개선</div>
                                <div class="phase-pct" style="color: var(--dash-warning);" id="phase2Pct">62%</div>
                                <div class="progress progress-md">
                                    <div class="progress-bar bg-warning" style="width:62%;"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-auto phase-arrow d-none d-lg-flex">
                            <i class="fas fa-chevron-right"></i>
                        </div>
                        <div class="col-lg col-md-4 mb-2">
                            <div class="phase-card" id="phase3">
                                <div class="phase-icon" style="color: var(--dash-purple);"><i class="fas fa-check-double"></i></div>
                                <div class="phase-title">3단계: 최종점검</div>
                                <div class="phase-pct" style="color: var(--dash-dark);" id="phase3Pct">35%</div>
                                <div class="progress progress-md">
                                    <div class="progress-bar bg-secondary" style="width:35%;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== Row 5: Quick Links ===== -->
    <div class="row mb-4">
        <div class="col-12 mb-2">
            <span class="section-header"><i class="fas fa-link mr-1"></i>바로가기</span>
        </div>
        <div class="col-xl-2 col-lg-4 col-md-4 col-6 mb-3">
            <a href="/cert/certMain.do" class="quick-link-btn">
                <span class="link-icon" style="color: var(--dash-primary);"><i class="fas fa-sitemap"></i></span>
                <span class="link-text">인증기준</span>
            </a>
        </div>
        <div class="col-xl-2 col-lg-4 col-md-4 col-6 mb-3">
            <a href="/eval/evalMain.do" class="quick-link-btn">
                <span class="link-icon" style="color: var(--dash-info);"><i class="fas fa-clipboard-check"></i></span>
                <span class="link-text">자체평가</span>
            </a>
        </div>
        <div class="col-xl-2 col-lg-4 col-md-4 col-6 mb-3">
            <a href="/improve/improveMain.do" class="quick-link-btn">
                <span class="link-icon" style="color: var(--dash-success);"><i class="fas fa-tasks"></i></span>
                <span class="link-text">개선활동</span>
            </a>
        </div>
        <div class="col-xl-2 col-lg-4 col-md-4 col-6 mb-3">
            <a href="/manage/infectionMain.do" class="quick-link-btn">
                <span class="link-icon" style="color: var(--dash-danger);"><i class="fas fa-virus"></i></span>
                <span class="link-text">감염감시</span>
            </a>
        </div>
        <div class="col-xl-2 col-lg-4 col-md-4 col-6 mb-3">
            <a href="/manage/staffEduMain.do" class="quick-link-btn">
                <span class="link-icon" style="color: var(--dash-warning);"><i class="fas fa-graduation-cap"></i></span>
                <span class="link-text">직원교육</span>
            </a>
        </div>
        <div class="col-xl-2 col-lg-4 col-md-4 col-6 mb-3">
            <a href="/cert/refMain.do" class="quick-link-btn">
                <span class="link-icon" style="color: var(--dash-dark);"><i class="fas fa-database"></i></span>
                <span class="link-text">공통코드</span>
            </a>
        </div>
    </div>

</div><!-- /.dashboard-container -->

<script>
$(document).ready(function() {
    loadDashboardData();
});

/* ===== Chart instances (for destroy on reload) ===== */
var domainChart = null;
var improveChart = null;

/* ===== Mock Data ===== */
var mockSummary = [
    {nodeNm: '기본가치체계', domainScore: 85.5},
    {nodeNm: '환자진료체계', domainScore: 78.3},
    {nodeNm: '행정관리체계', domainScore: 82.1},
    {nodeNm: '성과관리체계', domainScore: 76.8}
];

var mockImprove = [
    {title: '낙상예방 규정 개정',       impStatus: '진행', manager: '김간호', dueDt: '2026-04-30'},
    {title: '손위생 교육 강화',         impStatus: '완료', manager: '이감염', dueDt: '2026-03-31'},
    {title: '소방설비 점검표 개선',     impStatus: '계획', manager: '박시설', dueDt: '2026-05-15'},
    {title: '의무기록 완결도 향상',     impStatus: '진행', manager: '최의무', dueDt: '2026-04-20'},
    {title: 'QPS 지표 모니터링 체계',   impStatus: '계획', manager: '정QPS', dueDt: '2026-05-30'}
];

var mockSelfEval = [
    {evalYear: '2026', cycle: '4주기', status: '진행중', result: '-',      score: 80.7},
    {evalYear: '2025', cycle: '4주기', status: '완료',   result: '인증',   score: 83.2},
    {evalYear: '2024', cycle: '3주기', status: '완료',   result: '인증',   score: 79.5},
    {evalYear: '2023', cycle: '3주기', status: '완료',   result: '조건부', score: 72.1},
    {evalYear: '2022', cycle: '3주기', status: '완료',   result: '인증',   score: 81.0}
];

/* ===== Load Dashboard Data ===== */
function loadDashboardData() {
    $.ajax({
        url: '/dashboard/getDashboardData.do',
        type: 'POST',
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success' && res.data) {
                renderDashboard(res.data.summary || mockSummary, res.data.recentImprove || mockImprove);
            } else {
                renderDashboard(mockSummary, mockImprove);
            }
        },
        error: function() {
            /* Use mock data when API is not available */
            renderDashboard(mockSummary, mockImprove);
        }
    });
}

/* ===== Render All Dashboard Components ===== */
function renderDashboard(summaryData, improveData) {
    updateTimestamp();
    renderDomainChart(summaryData);
    renderImproveChart(improveData);
    renderSelfEvalTable(mockSelfEval);
    renderImproveTable(improveData);
    updateSummaryCards(summaryData, improveData);
}

/* ===== Update Timestamp ===== */
function updateTimestamp() {
    var now = new Date();
    var y = now.getFullYear();
    var m = String(now.getMonth() + 1).padStart(2, '0');
    var d = String(now.getDate()).padStart(2, '0');
    var h = String(now.getHours()).padStart(2, '0');
    var mi = String(now.getMinutes()).padStart(2, '0');
    $('#dashUpdateTime').text('최종 갱신: ' + y + '-' + m + '-' + d + ' ' + h + ':' + mi);
}

/* ===== Update Summary Cards from Data ===== */
function updateSummaryCards(summaryData, improveData) {
    /* Compute average score */
    if (summaryData && summaryData.length > 0) {
        var totalScore = 0;
        for (var i = 0; i < summaryData.length; i++) {
            totalScore += (summaryData[i].domainScore || 0);
        }
        var avg = (totalScore / summaryData.length).toFixed(1);
        $('#selfEvalScore').text(avg);

        var target = 90;
        var pct = Math.min((avg / target * 100), 100).toFixed(1);
        $('#selfEvalProgress').css('width', pct + '%');
        $('#selfEvalTarget').text('목표: ' + target + '점 | 달성률: ' + pct + '%');
    }

    /* Compute improve counts */
    if (improveData && improveData.length > 0) {
        var plan = 0, prog = 0, done = 0;
        for (var j = 0; j < improveData.length; j++) {
            var st = improveData[j].impStatus;
            if (st === '계획') plan++;
            else if (st === '진행') prog++;
            else if (st === '완료') done++;
        }
        var total = plan + prog + done;
        $('#improveTotal').text(total);
        $('#impPlan').html('계획 <strong>' + plan + '</strong>');
        $('#impProg').html('진행 <strong>' + prog + '</strong>');
        $('#impDone').html('완료 <strong>' + done + '</strong>');
    }
}

/* ===== Domain Score Bar Chart ===== */
function renderDomainChart(data) {
    if (domainChart) { domainChart.destroy(); }

    var labels = [];
    var scores = [];
    var bgColors = ['#3498db', '#27ae60', '#e67e22', '#8e44ad', '#e74c3c', '#1abc9c'];
    var borderColors = ['#2980b9', '#229954', '#d35400', '#7d3c98', '#c0392b', '#17a589'];

    for (var i = 0; i < data.length; i++) {
        labels.push(data[i].nodeNm);
        scores.push(data[i].domainScore || 0);
    }

    var ctx = document.getElementById('domainScoreChart').getContext('2d');
    domainChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: '평가점수',
                data: scores,
                backgroundColor: bgColors.slice(0, scores.length),
                borderColor: borderColors.slice(0, scores.length),
                borderWidth: 1,
                borderRadius: 6,
                borderSkipped: false,
                barPercentage: 0.55
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#2c3e50',
                    titleFont: { size: 13 },
                    bodyFont: { size: 12 },
                    padding: 10,
                    cornerRadius: 6,
                    callbacks: {
                        label: function(context) {
                            return ' ' + context.parsed.y + '점';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100,
                    ticks: {
                        stepSize: 20,
                        font: { size: 12 },
                        callback: function(value) { return value + '점'; }
                    },
                    grid: { color: '#f0f0f0' }
                },
                x: {
                    ticks: { font: { size: 12, weight: 'bold' } },
                    grid: { display: false }
                }
            },
            animation: {
                duration: 1000,
                easing: 'easeOutQuart'
            }
        },
        plugins: [{
            /* Data labels on bars */
            afterDatasetsDraw: function(chart) {
                var ctx2 = chart.ctx;
                chart.data.datasets.forEach(function(dataset, i) {
                    var meta = chart.getDatasetMeta(i);
                    meta.data.forEach(function(bar, index) {
                        var val = dataset.data[index];
                        ctx2.fillStyle = '#2c3e50';
                        ctx2.font = 'bold 13px sans-serif';
                        ctx2.textAlign = 'center';
                        ctx2.fillText(val + '점', bar.x, bar.y - 8);
                    });
                });
            }
        }]
    });
}

/* ===== Improve Status Doughnut Chart ===== */
function renderImproveChart(data) {
    if (improveChart) { improveChart.destroy(); }

    var plan = 0, prog = 0, done = 0;
    for (var i = 0; i < data.length; i++) {
        var st = data[i].impStatus;
        if (st === '계획') plan++;
        else if (st === '진행') prog++;
        else if (st === '완료') done++;
    }

    var ctx = document.getElementById('improveStatusChart').getContext('2d');
    improveChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['계획', '진행', '완료'],
            datasets: [{
                data: [plan, prog, done],
                backgroundColor: ['#3498db', '#f39c12', '#27ae60'],
                borderColor: '#fff',
                borderWidth: 3,
                hoverOffset: 8
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            cutout: '60%',
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#2c3e50',
                    callbacks: {
                        label: function(context) {
                            var total = context.dataset.data.reduce(function(a, b) { return a + b; }, 0);
                            var pct = total > 0 ? ((context.parsed / total) * 100).toFixed(1) : 0;
                            return ' ' + context.label + ': ' + context.parsed + '건 (' + pct + '%)';
                        }
                    }
                }
            },
            animation: {
                animateRotate: true,
                duration: 1000
            }
        },
        plugins: [{
            /* Center text */
            beforeDraw: function(chart) {
                var width = chart.width;
                var height = chart.height;
                var ctx2 = chart.ctx;
                ctx2.restore();

                var total = chart.data.datasets[0].data.reduce(function(a, b) { return a + b; }, 0);
                ctx2.font = 'bold 24px sans-serif';
                ctx2.fillStyle = '#2c3e50';
                ctx2.textBaseline = 'middle';
                ctx2.textAlign = 'center';
                ctx2.fillText(total + '건', width / 2, height / 2 - 8);

                ctx2.font = '12px sans-serif';
                ctx2.fillStyle = '#7f8c8d';
                ctx2.fillText('전체', width / 2, height / 2 + 14);

                ctx2.save();
            }
        }]
    });
}

/* ===== Self Evaluation Table ===== */
function renderSelfEvalTable(data) {
    var tbody = $('#selfEvalBody');
    tbody.empty();

    if (!data || data.length === 0) {
        tbody.append('<tr><td colspan="6" class="text-center py-4 text-muted">자체평가 내역이 없습니다.</td></tr>');
        return;
    }

    for (var i = 0; i < data.length; i++) {
        var item = data[i];
        var statusBadge = getEvalStatusBadge(item.status);
        var resultBadge = getResultBadge(item.result);
        var scoreColor = (item.score >= 80) ? 'text-success' : ((item.score >= 70) ? 'text-warning' : 'text-danger');

        var tr = '<tr>' +
            '<td class="text-center">' + (i + 1) + '</td>' +
            '<td class="text-center font-weight-bold">' + item.evalYear + '</td>' +
            '<td class="text-center">' + item.cycle + '</td>' +
            '<td class="text-center">' + statusBadge + '</td>' +
            '<td class="text-center">' + resultBadge + '</td>' +
            '<td class="text-center font-weight-bold ' + scoreColor + '">' + item.score + '</td>' +
            '</tr>';
        tbody.append(tr);
    }
}

/* ===== Improve Table ===== */
function renderImproveTable(data) {
    var tbody = $('#improveBody');
    tbody.empty();

    if (!data || data.length === 0) {
        tbody.append('<tr><td colspan="5" class="text-center py-4 text-muted">개선활동 내역이 없습니다.</td></tr>');
        return;
    }

    for (var i = 0; i < data.length; i++) {
        var item = data[i];
        var badge = getImpStatusBadge(item.impStatus);

        /* Check if overdue */
        var dueDtStr = item.dueDt || '';
        var isOverdue = false;
        if (dueDtStr && item.impStatus !== '완료') {
            var dueDate = new Date(dueDtStr.replace(/-/g, '/'));
            if (dueDate < new Date()) {
                isOverdue = true;
            }
        }

        var dueDtDisplay = dueDtStr;
        if (isOverdue) {
            dueDtDisplay = '<span class="text-danger font-weight-bold">' + dueDtStr + ' <i class="fas fa-exclamation-circle"></i></span>';
        }

        var tr = '<tr' + (isOverdue ? ' class="table-danger"' : '') + '>' +
            '<td class="text-center">' + (i + 1) + '</td>' +
            '<td>' + (item.title || '') + '</td>' +
            '<td class="text-center">' + badge + '</td>' +
            '<td class="text-center">' + (item.manager || '') + '</td>' +
            '<td class="text-center">' + dueDtDisplay + '</td>' +
            '</tr>';
        tbody.append(tr);
    }
}

/* ===== Badge Helper Functions ===== */
function getImpStatusBadge(status) {
    var cls = 'badge-secondary';
    if (status === '계획') cls = 'badge-plan';
    else if (status === '진행') cls = 'badge-progress';
    else if (status === '완료') cls = 'badge-done';
    return '<span class="badge badge-status ' + cls + '">' + (status || '-') + '</span>';
}

function getEvalStatusBadge(status) {
    if (status === '완료') return '<span class="badge badge-status badge-done">완료</span>';
    if (status === '진행중') return '<span class="badge badge-status badge-progress">진행중</span>';
    return '<span class="badge badge-status badge-secondary">' + (status || '-') + '</span>';
}

function getResultBadge(result) {
    if (!result || result === '-') return '<span class="text-muted">-</span>';
    if (result === '인증') return '<span class="badge badge-status badge-cert">인증</span>';
    if (result === '조건부') return '<span class="badge badge-status badge-cond">조건부</span>';
    if (result === '미인증') return '<span class="badge badge-status badge-uncert">미인증</span>';
    return '<span class="badge badge-status badge-secondary">' + result + '</span>';
}

/* ===== Page Navigation ===== */
function fnMovePage(url) {
    if (typeof fnMenuClick === 'function') {
        /* If tiles menu framework function exists, use it */
        fnMenuClick(url);
    } else {
        location.href = url;
    }
}
</script>
