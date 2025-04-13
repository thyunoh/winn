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
<link href="/css/winct/bootstrap.css" rel="stylesheet">
<link href="/css/winct/style.css" rel="stylesheet">

<!-- 부트스트랩 js -->
<script src="/bootstrap/js/bootstrap.bundle.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript" src='/js/jqgrid_common.js'></script> 
<script type="text/javascript" src='/js/jquery/common.js'></script> 
<title>로그인 페이지</title>
<script type="text/javaScript"> 

window.onload = function() {
    // JSP가 실행될 때 hospUuid 값 가져오기
    var hospUuid = '${sessionScope.s_hosp_uuid}';
    if (hospUuid && hospUuid !== 'null' && hospUuid.trim() !== '') {
        document.getElementById('hospCd').style.display = 'none';
    }	
    
    var userIdInput = document.getElementById("userId");
    // Check if the user_id field has a value
    if (userIdInput.value.trim() !== "") {
     // userIdInput.disabled = true;  // Disable the input field if it has a value
    } else {
      userIdInput.disabled = false;  // Enable the input field if it's empty
    }
  };
  
	function fnSavechg(){
		 
		if( $("#passWd").val() == "") {
			alert("비밀번호를 입력하세요.!");
			$("#passWd").focus();
			return;
		}else if( $("#bfPassWd").val() != $("#afPassWd").val()) {
			alert("변경할 비밀번호를 확인하세요.!");
			$("#bfUserPwd").focus();
			return;
		}

		var formData = $("form[name='regForm']").serialize();
		$.ajax( {
			type : "post",
			url : CommonUtil.getContextPath() + "/base/pwdchgAct.do",
			data : formData,
			dataType : "json",
			success : function(data) {
				if(data.error_code != "0") {
					alert(data.error_msg);
					return;
				}
				alert("비밀번호가 변경되었습니다.");
	            window.close();
			}
		}); 
	}
	function fnSaveReset(){ 
		  
		if( $("#userId").val() == ""){
			alert("사용자 ID를 입력하세요.!");
			$("#userId").focus();
			return;
		}
		if(!confirm("해당사용자의 비밀번호를 초기화 하시겠습니까?")) return;

		$.ajax( {
			type : "post",
			url : CommonUtil.getContextPath() + "/base/pwdresetAct.do",
			data : {user_id : $("#userId").val()},
			dataType : "json",
			success : function(data) {   
				if(data.error_code != "0"){
					if(data.error_code == "20000"){ 
						alert(data.error_msg);
						$("#userId").focus();
					}	
					else{ 
						alert(data.error_msg);
						$("#userId").focus();
					}
				}else{
					alert("비밀번호가 '1234'로 초기화되었습니다.\n비밀번호를 변경 후 로그인 하세요.");
					fnPwdChange();
				}
			},
		    error: function(xhr, status, error) {
		        console.error("Ajax request failed:", status, error);
		        alert("요청 처리 중 오류가 발생했습니다.");
		    }
		}); 
	}
</script>    
</head>
  <body>  
	  <div id="pwresetForm" class="container" style="display: flex; align-items: center; justify-content: center; height: 100vh; ">   
	    <div class="set-pass-box">
	      <div class="set-pass-wrap">  
	       <form:form commandName="DTO" id="regForm" name="regForm" method="post">
	        <h4>비밀번호 변경</h4>
	        <div class="pass-box w-100">                                              
	          <input type="text" name="hospCd" class="form-control mt-2" id="hospCd"  value="" placeholder="요양기관기호"/>
			  <input type="text" name="userId" class="form-control mt-2" id="userId"  value="" placeholder="사용자ID"/>
	          <input type="password" class="form-control mt-2" id="pass_wd" name="passWd" placeholder="현재 비밀번호">
	          <input type="password" class="form-control mt-2" id="bf_pass_wd" name="bfPassWd"  placeholder="변경 비밀번호">
	          <input type="password" class="form-control mt-2" id="af_pass_wd" name="afPassWd"  placeholder="변경 비밀번호 확인">
	        </div>
			</form:form>
	        <div style="margin-top: 10px;" class="set-btn-box w-100">
	          <button type="button" class="btn btn-outline-dark" onclick="window.close();">취소</button>
	          <button type="button" class="btn btn-outline-dark" onclick="fnSaveReset();">초기화</button>
	          <button type="button" class="btn btn-primary" onclick="fnSavechg();">변경</button>
	        </div>
	      </div> 
	    </div>
	 </div> 
  </body>
</html>
