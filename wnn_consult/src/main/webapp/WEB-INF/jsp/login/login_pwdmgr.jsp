<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>  
<%@ page import = "java.util.*" %>
<!DOCTYPE html>
<html>
 <head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" /> 
<!-- Bootstrap CSS -->

<!-- Customized Bootstrap Stylesheet -->
<link href="/css/winct/bootstrap.css" rel="stylesheet">
<link href="/css/winct/style.css" rel="stylesheet">

<!-- 부트스트랩 js -->
<script src="/bootstrap/js/bootstrap.bundle.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src='/js/jqgrid_common.js'></script> 
<script type="text/javascript" src='/js/jquery/common.js'></script> 
<title>로그인 페이지</title>
<style>
</style>

<script type="text/javaScript"> 

window.onload = function() {
    var userIdInput = document.getElementById("userId");
    // Check if the user_id field has a value
    if (userIdInput.value.trim() !== "") {
     // userIdInput.disabled = true;  // Disable the input field if it has a value
    } else {
      userIdInput.disabled = true;  // Enable the input field if it's empty
    }
    if (window.opener && !window.opener.closed) {
        window.opener = null;  // 부모 페이지 참조 삭제
    }
};
  
function fnsearch(){
	if(!fnRequired('userNm', '사용자성명을 입력하세요 .'))   return;
	if(!fnRequired('email',   '사용자이메일를 입력하세요 .'))   return;
	$("#userId").val("") ;
	$.ajax( {
		type : "post",
		url : CommonUtil.getContextPath() + "/popup/login_usersearch.do",
		data : {user_nm : $("#userNm").val() , email : $("#email").val() },
		dataType : "json",
		success : function(data) {
            if (data.error_code !== "0" || !data.result || data.result.length === 0 ) {
                alert("해당 사용자정보가 존재하지 않습니다!");
                return;
            }
            $("#userId").val(data.result.user_id);
        },
        error: function (xhr, status, error) {
            alert("서버 요청 중 오류가 발생했습니다.");
            console.error("Error: ", status, error);
        }
	}); 
}
//비밀번호 초기화
function fnPwdClear(){ 

    var popupwidth  = 500;
    var popupheight = 300;
    var url = CommonUtil.getContextPath() + "/popup/login_pwdchg.do";
    
    // 모니터 해상도를 기준으로 중앙 위치 계산
    var screenLeft = window.screenLeft !== undefined ? window.screenLeft : screen.left;
    var screenTop = window.screenTop !== undefined ? window.screenTop : screen.top;

    var screenWidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var screenHeight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var LeftPosition = screenLeft + (screenWidth - popupwidth) / 2;
    var TopPosition = screenTop + (screenHeight - popupheight) / 2;

    var oPopup = window.open(url, "비밀번호초기화", "width=" + popupwidth + ",height=" + popupheight + ",top=" + TopPosition + ",left=" + LeftPosition + ",scrollbars=no");
    if (oPopup) {
        oPopup.focus();
    }
}
function closePopup() {
    if (window.opener && !window.opener.closed) {
        window.opener = null;
    }
    window.close();
}
</script>    
</head>
  <body>  
	  <div id="login" class="container" style= "display: flex; align-items: center; justify-content: center; height: 100vh;">    
	    <div class="set-pass-box">
	      <div class="set-pass-wrap">  
	       <form:form commandName="DTO" id="regForm" name="regForm" method="post">
	        <h2>아이디찾기 비밀번호초기화</h2>
	        <div class="pass-box w-100">    
			  <input type="text" name="userNm" class="form-control mt-2" id="userNm"  value="" placeholder="사용자성명"/>
			  <input type="text" name="email"   class="form-control mt-2" id="email"    value="" placeholder="사용자이메일"/>
		      <h12 style="font-size: 12px; color: #555;">아이디를 찾기 위해서 사용자성명 및 이메일을 등록하고 아이디찾기를 실행하세요</h12>
	          <input type="text" class="form-control mt-2" id="userId" name="userId" placeholder="사용자아이디">
	        </div>
			</form:form>
	        <div class="set-btn-box w-100" style="margin-top: 20px; text-align: right;">
	          <button type="button" class="btn btn-outline-dark" onclick="closePopup();">취소</button>
	          <button type="button" class="btn btn-primary" onclick="javascript:fnsearch();">아이디찾기</button>
	          <button type="button" class="btn btn-primary" onclick="javascript:fnPwdClear();">비밀번호초기화</button>
	        </div>
	      </div> 
	    </div>
	 </div> 
  </body>
</html>

