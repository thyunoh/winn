<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>

<tiles:insertAttribute name="header" />

</head>
<body> 

	<tiles:insertAttribute name="top" />
		
    <tiles:insertAttribute name="content" />
	
<script>


function loadPage(url) {
  
  $.ajax({
    url: url,
    method: "GET",
	data: {
		
    },
    beforeSend: function() {
      $('#contentArea').empty();
    },
    success: function(response) {    
      $('#contentArea').html(response);      
    },
    error: function(xhr, status, error) {
      alert("페이지 로드 실패: " + error);
    }
  });
}

</script>
	
</body>
</html>