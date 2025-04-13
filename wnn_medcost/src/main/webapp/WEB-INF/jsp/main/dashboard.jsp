<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" prefix="page" %>
<%@ page import ="java.util.Date" %>
<%
	Date nowTime = new Date();
%>


    <div class="dashboard-wrapper">
        <div class="dashboard-ecommerce">
            <div class="container-fluid dashboard-content ">
                <div class="ecommerce-widget">
                    <div class="row">
                        <div class="col-xl-3 col-lg-3">
                            <div class="card">
                                <div class="card-header bg-info text-center p-1 ">
                                    <h4 class="mb-0 text-white">진료비 1</h4>
                                </div>
                                <div class="card-body text-center">
                                    <h1 class="mb-0">111</h1>
                                    <p>2024년 01월 01일 ~ 2024년 12월 31일</p>
                                </div>
                                <div class="card-body border-top">
                                    <ul class="list-unstyled bullet-check font-14">
                                        <li>진료비 정보 1.</li>
                                    </ul>
                                    <a href="#" class="btn btn-outline-info btn-block btn-sm">진료비 1 자료보기</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-lg-3">
                            <div class="card">
                                <div class="card-header bg-primary text-center p-1">
                                    <h4 class="mb-0 text-white">진료비 2</h4>
                                </div>
                                <div class="card-body text-center">
                                    <h1 class="mb-0">222</h1>
                                    <p>2024년 01월 01일 ~ 2024년 12월 31일</p>
                                </div>
                                <div class="card-body border-top">
                                    <ul class="list-unstyled bullet-check font-14">
                                        <li>진료비 정보 1.</li>
                                    </ul>
                                    <a href="#" class="btn btn-outline-primary btn-block btn-sm">진료비 2 자료보기</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-lg-3">
                            <div class="card">
                                <div class="card-header bg-secondary text-center p-1">
                                    <h4 class="mb-0 text-white">진료비 3</h4>
                                </div>
                                <div class="card-body text-center">
                                    <h1 class="mb-0">333</h1>
                                    <p>2024년 01월 01일 ~ 2024년 12월 31일</p>
                                </div>
                                <div class="card-body border-top">
                                    <ul class="list-unstyled bullet-check font-14">
                                        <li>진료비 정보 1.</li>
                                    </ul>
                                    <a href="#" class="btn btn-outline-secondary btn-block btn-sm">진료비 3 자료보기</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-lg-3">
                            <div class="card">
                                <div class="card-header bg-warning text-center p-1">
                                    <h4 class="mb-0 text-white">진료비 4</h4>
                                </div>
                                <div class="card-body text-center">
                                    <h1 class="mb-1">444</h1>
                                    <p>2024년 01월 01일 ~ 2024년 12월 31일</p>
                                </div>
                                <div class="card-body border-top">
                                    <ul class="list-unstyled bullet-check font-14">
                                        <li>진료비 정보 1.</li>
                                    </ul>
                                    <a href="#" class="btn btn-outline-warning btn-block btn-sm">진료비 4 자료보기</a>
                                </div>
                            </div>
                        </div>
                   </div>
                   <div class="row">    
                        <div class="col-xl-3 col-lg-3">
                            <div class="card">
                                <div class="card-header bg-light text-center p-1">
                                    <h4 class="mb-0 text-black">진료비 5</h4>
                                </div>
                                <div class="card-body text-center">
                                    <h1 class="mb-1">555</h1>
                                    <p>2024년 01월 01일 ~ 2024년 12월 31일</p>
                                </div>
                                <div class="card-body border-top">
                                    <ul class="list-unstyled bullet-check font-14">
                                        <li>진료비 정보 1.</li>
                                    </ul>
                                    <a href="#" class="btn btn-outline-light btn-block btn-sm">진료비 5 자료보기</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-lg-3">
                            <div class="card">
                                <div class="card-header bg-dark text-center p-1">
                                    <h4 class="mb-0 text-white">진료비 6</h4>
                                </div>
                                <div class="card-body text-center">
                                    <h1 class="mb-0">666</h1>
                                    <p>2024년 01월 01일 ~ 2024년 12월 31일</p>
                                </div>
                                <div class="card-body border-top">
                                    <ul class="list-unstyled bullet-check font-14">
                                        <li>진료비 정보 1.</li>
                                    </ul>
                                    <a href="#" class="btn btn-outline-dark btn-block btn-sm">진료비 6 자료보기</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-lg-3">
                            <div class="card">
                                <div class="card-header bg-success text-center p-1">
                                    <h4 class="mb-0 text-white">진료비 7</h4>
                                </div>
                                <div class="card-body text-center">
                                    <h1 class="mb-1">777</h1>
                                    <p>2024년 01월 01일 ~ 2024년 12월 31일</p>
                                </div>
                                <div class="card-body border-top">
                                    <ul class="list-unstyled bullet-check font-14">
                                        <li>진료비 정보 1.</li>
                                    </ul>
                                    <a href="#" class="btn btn-outline-success btn-block btn-sm">진료비 7 자료보기</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-lg-3">
                            <div class="card">
                                <div class="card-header bg-danger text-center p-1">
                                    <h4 class="mb-0 text-white">진료비 8</h4>
                                </div>
                                <div class="card-body text-center">
                                    <h1 class="mb-0">888</h1>
                                    <p>2024년 01월 01일 ~ 2024년 12월 31일</p>
                                </div>
                                <div class="card-body border-top">
                                    <ul class="list-unstyled bullet-check font-14">
                                        <li>진료비 정보 1.</li>
                                    </ul>
                                    <a href="#" class="btn btn-outline-danger btn-block btn-sm">진료비 8 자료보기</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="row">
                     
                     <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
                         <div class="card">
                             <h5 class="card-header">Chart Name</h5>
                             <div class="card-body">
                                 <div id="cchart_category" style="height: 500px;"></div>
                             </div>
                         </div>
                     </div> 
     			</div>        			
	        </div>
		</div>  
	</div>  
<script type="text/javascript">
	

</script>        
