<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<style>
    #wrap { display: flex; align-items: center; justify-content: center; min-height: 100vh; background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%); }
    .login-card { width: 100%; max-width: 440px; }
    .login-card .card { border: none; border-radius: 12px; overflow: hidden; }
    .login-card .card-header { background-color: #2c3e50; color: #fff; text-align: center; font-size: 1.1rem; font-weight: 600; padding: 20px; border: none; }
    .login-card .card-header i { font-size: 2rem; display: block; margin-bottom: 8px; color: #3498db; }
    .login-card .card-header small { display: block; font-size: 0.75rem; color: #95a5a6; margin-top: 5px; font-weight: 400; }
    .btn-login { background-color: #3498db; border-color: #3498db; color: #fff; font-weight: 600; padding: 10px; font-size: 15px; border-radius: 8px; }
    .btn-login:hover { background-color: #2980b9; border-color: #2980b9; color: #fff; }
    .login-error { display: none; margin-top: 10px; }
    .form-control { border-radius: 8px; height: 42px; }
    .form-control:focus { border-color: #3498db; box-shadow: 0 0 0 0.2rem rgba(52,152,219,.25); }
    label { font-size: 13px; font-weight: 600; color: #333; margin-bottom: 4px; }
    label .required { color: #e74c3c; }
    .hosp-check-btn { border-radius: 0 8px 8px 0; }
    .hosp-info { display: none; padding: 8px 12px; background: #eaf6ff; border-radius: 8px; font-size: 13px; color: #2c3e50; margin-top: -5px; margin-bottom: 10px; }
    .hosp-info i { color: #27ae60; margin-right: 5px; }
    .copyright { text-align: center; color: rgba(255,255,255,0.6); font-size: 11px; margin-top: 20px; }
</style>

<div class="login-card">
    <div class="card shadow-lg">
        <div class="card-header">
            <i class="fas fa-hospital-alt"></i>
            요양병원 인증평가 시스템
            <small>Hospital Accreditation Management System</small>
        </div>
        <div class="card-body p-4">
            <form id="loginForm" autocomplete="off">
                <div class="form-group">
                    <label>요양기관기호 <span class="required">*</span></label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="hospCd" name="hospCd" placeholder="요양기관기호 8자리" value="12345678" maxlength="8">
                        <div class="input-group-append">
                            <button type="button" class="btn btn-outline-primary hosp-check-btn" onclick="checkHosp()">
                                <i class="fas fa-search"></i> 확인
                            </button>
                        </div>
                    </div>
                </div>
                <div class="hosp-info" id="hospInfo">
                    <i class="fas fa-check-circle"></i> <span id="hospNmDisplay"></span>
                </div>
                <div class="form-group">
                    <label>아이디 <span class="required">*</span></label>
                    <input type="text" class="form-control" id="userId" name="userId" placeholder="아이디를 입력하세요" value="admin" required>
                </div>
                <div class="form-group">
                    <label>비밀번호 <span class="required">*</span></label>
                    <input type="password" class="form-control" id="userPw" name="userPw" placeholder="비밀번호를 입력하세요" value="admin1234" required>
                </div>
                <div class="alert alert-danger login-error" id="loginError"></div>
                <button type="submit" class="btn btn-login btn-block mt-3">
                    <i class="fas fa-sign-in-alt"></i> 로그인
                </button>
            </form>
        </div>
    </div>
    <div class="copyright">
        &copy; 2026 WinnerNet. All rights reserved.
    </div>
</div>

<script>
$(document).ready(function() {
    // 자동 기관확인
    if ($('#hospCd').val()) {
        checkHosp();
    }

    $('#loginForm').on('submit', function(e) {
        e.preventDefault();
        $('#loginError').hide();

        var hospCd = $('#hospCd').val().trim();
        var userId = $('#userId').val().trim();
        var userPw = $('#userPw').val().trim();

        if (!hospCd) {
            $('#loginError').text('요양기관기호를 입력하세요.').show();
            $('#hospCd').focus();
            return;
        }
        if (!userId || !userPw) {
            $('#loginError').text('아이디와 비밀번호를 입력하세요.').show();
            return;
        }

        $.ajax({
            url: '/login/doLogin.do',
            type: 'POST',
            data: { hospCd: hospCd, userId: userId, userPw: userPw },
            dataType: 'json',
            success: function(res) {
                if (res.result === 'success') {
                    location.href = '/dashboard/dashboardMain.do';
                } else {
                    $('#loginError').text(res.msg || '로그인에 실패하였습니다.').show();
                }
            },
            error: function() {
                $('#loginError').text('서버 오류가 발생하였습니다.').show();
            }
        });
    });
});

function checkHosp() {
    var hospCd = $('#hospCd').val().trim();
    if (!hospCd || hospCd.length < 8) {
        $('#hospInfo').hide();
        return;
    }
    $.ajax({
        url: '/login/checkHosp.do',
        type: 'POST',
        data: { hospCd: hospCd },
        dataType: 'json',
        success: function(res) {
            if (res.result === 'success') {
                $('#hospNmDisplay').text(res.data.HOSP_NM + ' (' + hospCd + ')');
                $('#hospInfo').slideDown(200);
            } else {
                $('#hospNmDisplay').text(res.msg);
                $('#hospInfo').removeClass('hosp-info').addClass('hosp-info-error').slideDown(200);
            }
        },
        error: function() {
            $('#hospInfo').hide();
        }
    });
}
</script>
