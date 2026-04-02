<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<tiles:insertAttribute name="header" />
<style>
/* === Sidebar Layout === */
body { margin: 0; font-family: 'Malgun Gothic', sans-serif; }
.wrapper { display: flex; min-height: 100vh; }

/* Sidebar */
#sidebar {
    width: 250px; min-width: 250px; background: #2c3e50; color: #ecf0f1;
    transition: all 0.3s; position: fixed; top: 0; left: 0; height: 100vh;
    display: flex; flex-direction: column; z-index: 1000;
}
#sidebar .sidebar-brand { flex-shrink: 0; }
#sidebar .sidebar-menu { flex: 1; overflow-y: auto; overflow-x: hidden; }
#sidebar.collapsed { width: 60px; min-width: 60px; }
#sidebar.collapsed .sidebar-text,
#sidebar.collapsed .sidebar-brand-text,
#sidebar.collapsed .submenu,
#sidebar.collapsed .menu-arrow { display: none; }
#sidebar.collapsed .sidebar-brand { padding: 15px 10px; text-align: center; }
#sidebar.collapsed .nav-link { text-align: center; padding: 12px 5px; }
#sidebar.collapsed .nav-link i { font-size: 18px; margin: 0; }

/* Brand */
.sidebar-brand {
    padding: 18px 20px; font-size: 16px; font-weight: 700;
    border-bottom: 1px solid #34495e; color: #fff; text-decoration: none; display: block;
}
.sidebar-brand:hover { color: #fff; text-decoration: none; }
.sidebar-brand i { color: #3498db; }

/* Nav */
#sidebar .nav-link {
    color: #bdc3c7; padding: 11px 20px; font-size: 14.5px;
    display: flex; align-items: center; transition: all 0.2s; cursor: pointer;
}
#sidebar .nav-link:hover { color: #fff; background: #34495e; }
#sidebar .nav-link.active { color: #fff; background: #3498db; }
#sidebar .nav-link i { width: 22px; margin-right: 10px; text-align: center; font-size: 15px; }
.menu-arrow { margin-left: auto; font-size: 12px; transition: transform 0.2s; }
.menu-arrow.open { transform: rotate(90deg); }

/* Submenu */
.submenu { display: none; background: #243342; }
.submenu.show { display: block; }
.submenu .nav-link { padding-left: 52px; font-size: 13.5px; color: #95a5a6; }
.submenu .nav-link:hover { color: #fff; background: #1a252f; }
.submenu .nav-link.active { color: #fff; background: #2980b9; }

/* Menu divider */
.sidebar-divider { border-top: 1px solid #34495e; margin: 8px 15px; }
.sidebar-section { color: #7f8c8d; font-size: 12px; padding: 10px 20px 5px; text-transform: uppercase; letter-spacing: 1px; font-weight: 600; }

/* Content area */
#content-wrapper {
    margin-left: 250px; width: calc(100% - 250px);
    transition: all 0.3s; display: flex; flex-direction: column; min-height: 100vh;
}
#content-wrapper.expanded { margin-left: 60px; width: calc(100% - 60px); }

/* Top bar */
.topbar {
    background: #fff; border-bottom: 1px solid #dee2e6;
    padding: 8px 20px; display: flex; align-items: center; justify-content: space-between;
    position: sticky; top: 0; z-index: 999;
}
.topbar .toggle-btn { background: none; border: none; font-size: 18px; color: #2c3e50; cursor: pointer; padding: 5px 10px; }
.topbar .user-info { font-size: 13px; color: #555; }
.topbar .user-info a { color: #e74c3c; text-decoration: none; margin-left: 15px; }

/* Main content */
.main-content { flex: 1; padding: 15px 20px; background: #f8f9fa; }

/* Footer */
.main-footer { text-align: center; color: #999; font-size: 11px; padding: 10px; border-top: 1px solid #dee2e6; background: #fff; }

/* Scrollbar */
#sidebar .sidebar-menu::-webkit-scrollbar { width: 6px; }
#sidebar .sidebar-menu::-webkit-scrollbar-track { background: #243342; }
#sidebar .sidebar-menu::-webkit-scrollbar-thumb { background: #4a6a8a; border-radius: 3px; }
#sidebar .sidebar-menu::-webkit-scrollbar-thumb:hover { background: #5a8ab4; }
</style>
</head>
<body>
<div class="wrapper">
    <!-- Sidebar -->
    <tiles:insertAttribute name="top" />

    <!-- Content -->
    <div id="content-wrapper">
        <!-- Top Bar -->
        <div class="topbar">
            <button class="toggle-btn" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
            <div class="user-info">
                <c:if test="${not empty sessionScope.loginUser}">
                    <i class="fas fa-user-circle"></i> <strong>${sessionScope.loginUser.userNm}</strong>님
                    <a href="/login/doLogout.do"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
                </c:if>
            </div>
        </div>
        <!-- Main Content -->
        <div class="main-content">
            <tiles:insertAttribute name="content" />
        </div>
        <!-- Footer -->
        <tiles:insertAttribute name="footer" />
    </div>
</div>

<script>
function toggleSidebar() {
    $('#sidebar').toggleClass('collapsed');
    $('#content-wrapper').toggleClass('expanded');
    localStorage.setItem('sidebarCollapsed', $('#sidebar').hasClass('collapsed'));
}
// Remember sidebar state
$(document).ready(function() {
    if (localStorage.getItem('sidebarCollapsed') === 'true') {
        $('#sidebar').addClass('collapsed');
        $('#content-wrapper').addClass('expanded');
    }
    // Highlight active menu
    var path = location.pathname;
    $('#sidebar .nav-link[href]').each(function() {
        if (path === $(this).attr('href')) {
            $(this).addClass('active');
            $(this).closest('.submenu').addClass('show');
            $(this).closest('.submenu').prev('.nav-link').find('.menu-arrow').addClass('open');
        }
    });
});
</script>
</body>
</html>
