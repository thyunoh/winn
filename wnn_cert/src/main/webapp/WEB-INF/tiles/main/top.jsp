<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav id="sidebar">
    <a class="sidebar-brand" href="/dashboard/dashboardMain.do">
        <i class="fas fa-hospital-alt"></i> <span class="sidebar-brand-text">요양병원 인증평가</span>
    </a>

    <div class="sidebar-menu">
    <!-- 대시보드 -->
    <a class="nav-link" href="/dashboard/dashboardMain.do">
        <i class="fas fa-tachometer-alt"></i> <span class="sidebar-text">대시보드</span>
    </a>

    <!-- ====== 인증관리 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">인증관리</span></div>

    <a class="nav-link" href="/cert/certMain.do">
        <i class="fas fa-sitemap"></i> <span class="sidebar-text">인증기준 관리</span>
    </a>
    <a class="nav-link" href="/eval/evalMain.do">
        <i class="fas fa-clipboard-check"></i> <span class="sidebar-text">자체평가</span>
    </a>
    <a class="nav-link" href="/improve/improveMain.do">
        <i class="fas fa-tasks"></i> <span class="sidebar-text">개선활동</span>
    </a>
    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-calendar-check"></i> <span class="sidebar-text">인증준비</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/certScheduleMain.do"><span class="sidebar-text">인증일정 관리</span></a>
        <a class="nav-link" href="/manage/guidebookMain.do"><span class="sidebar-text">규정/지침 관리</span></a>
        <a class="nav-link" href="/manage/formCompleteMain.do"><span class="sidebar-text">완결도 점검</span></a>
        <a class="nav-link" href="/manage/certDocStatusMain.do"><span class="sidebar-text">인증자료 현황</span></a>
        <a class="nav-link" href="/manage/selfCheckMain.do"><span class="sidebar-text">부서별 자체점검</span></a>
        <a class="nav-link" href="/manage/mockSurveyMain.do"><span class="sidebar-text">모의조사</span></a>
        <a class="nav-link" href="/manage/workPlanMain.do"><span class="sidebar-text">업무계획</span></a>
    </div>


    <!-- ====== QPS/성과관리 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">QPS/성과관리</span></div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-chart-line"></i> <span class="sidebar-text">QPS 지표</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/qpsMain.do"><span class="sidebar-text">QPS 분류관리</span></a>
        <a class="nav-link" href="/manage/patientCntMain.do"><span class="sidebar-text">재원환자 통계</span></a>
        <a class="nav-link" href="/manage/returnHomeMain.do"><span class="sidebar-text">재택복귀율</span></a>
        <a class="nav-link" href="/manage/tatMain.do"><span class="sidebar-text">영상 TAT</span></a>
        <a class="nav-link" href="/manage/pathologyTatMain.do"><span class="sidebar-text">검체 TAT</span></a>
    </div>

    <!-- ====== 환자안전 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">환자안전</span></div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-exclamation-triangle"></i> <span class="sidebar-text">사고보고/관리</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/rptMain.do"><span class="sidebar-text">환자안전 사고보고</span></a>
        <a class="nav-link" href="/manage/fallMain.do"><span class="sidebar-text">낙상 관리</span></a>
        <a class="nav-link" href="/manage/pressureUlcerMain.do"><span class="sidebar-text">욕창 관리</span></a>
        <a class="nav-link" href="/manage/painAssessMain.do"><span class="sidebar-text">통증 평가</span></a>
    </div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-lock"></i> <span class="sidebar-text">격리/강박</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/restraintMain.do"><span class="sidebar-text">격리/강박 기록</span></a>
        <a class="nav-link" href="/manage/restraintRecordMain.do"><span class="sidebar-text">격리/강박 상세</span></a>
        <a class="nav-link" href="/manage/restraintLogMain.do"><span class="sidebar-text">시행일지</span></a>
    </div>

    <a class="nav-link" href="/manage/consentMain.do">
        <i class="fas fa-file-signature"></i> <span class="sidebar-text">동의서 관리</span>
    </a>
    

    <!-- ====== 감염관리 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">감염관리</span></div>

    <a class="nav-link" href="/manage/infectionMain.do">
        <i class="fas fa-virus"></i> <span class="sidebar-text">감염감시</span>
    </a>
    <a class="nav-link" href="/manage/handHygieneMain.do">
        <i class="fas fa-hands-wash"></i> <span class="sidebar-text">손위생 모니터링</span>
    </a>
    <a class="nav-link" href="/manage/vaccinMain.do">
        <i class="fas fa-syringe"></i> <span class="sidebar-text">예방접종</span>
    </a>
    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-spray-can"></i> <span class="sidebar-text">소독/환경</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/sterilizeMain.do"><span class="sidebar-text">소독/멸균 관리</span></a>
        <a class="nav-link" href="/manage/infInspectMain.do"><span class="sidebar-text">감염 점검</span></a>
        <a class="nav-link" href="/manage/laundryMain.do"><span class="sidebar-text">세탁물 관리</span></a>
        <a class="nav-link" href="/manage/wasteMain.do"><span class="sidebar-text">폐기물 관리</span></a>
    </div>

    <!-- ====== 환자진료 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">환자진료</span></div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-stethoscope"></i> <span class="sidebar-text">진료관리</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/patientChartMain.do"><span class="sidebar-text">환자차트</span></a>
        <a class="nav-link" href="/manage/pharmPatientMain.do"><span class="sidebar-text">투약관리</span></a>
        <a class="nav-link" href="/manage/nutritionMain.do"><span class="sidebar-text">영양관리</span></a>
        <a class="nav-link" href="/manage/rehabMain.do"><span class="sidebar-text">재활치료</span></a>
        <a class="nav-link" href="/manage/dischargeMain.do"><span class="sidebar-text">퇴원관리</span></a>
    </div>

    <a class="nav-link" href="/manage/mealRoundMain.do">
        <i class="fas fa-utensils"></i> <span class="sidebar-text">배식라운딩</span>
    </a>

    <!-- ====== 인력/교육 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">인력/교육</span></div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-user-md"></i> <span class="sidebar-text">직원관리</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/staffMain.do"><span class="sidebar-text">직원 마스터</span></a>
        <a class="nav-link" href="/manage/staffDutyMain.do"><span class="sidebar-text">당직/인력현황</span></a>
        <a class="nav-link" href="/manage/dutyScheduleMain.do"><span class="sidebar-text">근무표</span></a>
        <a class="nav-link" href="/manage/vacationMain.do"><span class="sidebar-text">휴가관리</span></a>
    </div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-graduation-cap"></i> <span class="sidebar-text">교육/훈련</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/staffEduMain.do"><span class="sidebar-text">직원교육</span></a>
        <a class="nav-link" href="/manage/healthChkMain.do"><span class="sidebar-text">건강검진</span></a>
        <a class="nav-link" href="/manage/cprDrillMain.do"><span class="sidebar-text">CPR/응급훈련</span></a>
    </div>

    <a class="nav-link" href="/manage/staffReportMain.do">
        <i class="fas fa-file-alt"></i> <span class="sidebar-text">일일보고</span>
    </a>

    <!-- ====== 시설/장비 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">시설/장비</span></div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-building"></i> <span class="sidebar-text">시설관리</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/fireEquipMain.do"><span class="sidebar-text">소방설비 점검</span></a>
        <a class="nav-link" href="/manage/safetyRoundMain.do"><span class="sidebar-text">안전 라운딩</span></a>
        <a class="nav-link" href="/manage/waterQualityMain.do"><span class="sidebar-text">수질검사</span></a>
    </div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-laptop-medical"></i> <span class="sidebar-text">장비관리</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/medDeviceMain.do"><span class="sidebar-text">의료기기 관리</span></a>
        <a class="nav-link" href="/manage/wardDeviceMain.do"><span class="sidebar-text">병동장비 관리</span></a>
        <a class="nav-link" href="/manage/drugManageMain.do"><span class="sidebar-text">약품관리</span></a>
    </div>

    <!-- ====== 조직관리 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">조직관리</span></div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-sitemap"></i> <span class="sidebar-text">조직구조</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/companyMain.do"><span class="sidebar-text">병원정보</span></a>
        <a class="nav-link" href="/manage/deptMain.do"><span class="sidebar-text">부서관리</span></a>
        <a class="nav-link" href="/manage/wardMain.do"><span class="sidebar-text">병동관리</span></a>
        <a class="nav-link" href="/manage/positionMain.do"><span class="sidebar-text">직위/직급</span></a>
    </div>

    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-users-cog"></i> <span class="sidebar-text">위원회</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/teamMain.do"><span class="sidebar-text">팀/위원회</span></a>
        <a class="nav-link" href="/manage/committeeMain.do"><span class="sidebar-text">위원회 활동</span></a>
    </div>

    <a class="nav-link" href="/manage/complaintMain.do">
        <i class="fas fa-comment-dots"></i> <span class="sidebar-text">민원/고충</span>
    </a>
    <a class="nav-link" href="/manage/satisfactionMain.do">
        <i class="fas fa-smile"></i> <span class="sidebar-text">만족도 조사</span>
    </a>
    <a class="nav-link" href="/manage/emergencyMain.do">
        <i class="fas fa-ambulance"></i> <span class="sidebar-text">응급상황 기록</span>
    </a>
    <a class="nav-link" href="/manage/tempLogMain.do">
        <i class="fas fa-thermometer-half"></i> <span class="sidebar-text">온도 기록</span>
    </a>

    <!-- ====== 문서관리 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">문서관리</span></div>

    <a class="nav-link" href="/manage/templateMain.do">
        <i class="fas fa-file-word"></i> <span class="sidebar-text">문서 템플릿</span>
    </a>
    <a class="nav-link" href="/manage/fileMain.do">
        <i class="fas fa-folder-open"></i> <span class="sidebar-text">파일관리</span>
    </a>
    <a class="nav-link" href="/manage/boardMain.do">
        <i class="fas fa-clipboard-list"></i> <span class="sidebar-text">게시판</span>
    </a>
    <a class="nav-link" href="/manage/noticeMain.do">
        <i class="fas fa-bullhorn"></i> <span class="sidebar-text">공지사항</span>
    </a>

    <!-- ====== 시스템 ====== -->
    <div class="sidebar-divider"></div>
    <div class="sidebar-section"><span class="sidebar-text">시스템관리</span></div>

    <a class="nav-link" href="/cert/refMain.do">
        <i class="fas fa-database"></i> <span class="sidebar-text">공통코드관리</span>
    </a>
    <a class="nav-link" onclick="toggleSubmenu(this)">
        <i class="fas fa-cogs"></i> <span class="sidebar-text">시스템설정</span>
        <span class="menu-arrow"><i class="fas fa-chevron-right"></i></span>
    </a>
    <div class="submenu">
        <a class="nav-link" href="/manage/userMain.do"><span class="sidebar-text">사용자관리</span></a>
        <a class="nav-link" href="/manage/menuAuthMain.do"><span class="sidebar-text">메뉴권한</span></a>
        <a class="nav-link" href="/manage/signLineMain.do"><span class="sidebar-text">결재선관리</span></a>
        <a class="nav-link" href="/manage/loginHistMain.do"><span class="sidebar-text">로그인이력</span></a>
        <a class="nav-link" href="/manage/smsMain.do"><span class="sidebar-text">SMS관리</span></a>
    </div>

    <div style="height:50px;"></div>
    </div><!-- /sidebar-menu -->
</nav>

<script>
function toggleSubmenu(el) {
    var submenu = $(el).next('.submenu');
    var arrow = $(el).find('.menu-arrow');
    submenu.slideToggle(200);
    arrow.toggleClass('open');
}
</script>
