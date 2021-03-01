<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>

<body>
<div class="wrapper">
<%
	PageTitle = "매장찾기"
	Dim dir_yn : dir_yn = Request("dir_yn")
%>

	<!--#include virtual="/includes/header.asp"-->

	<style>
		.container {height:100% !important; padding:0; }
		.content {height:100% !important;}
	</style>

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content">

			<!-- 현 위치 기반 주소 검색 -->
			<div class="location_wrap">
				<div class="location_map">
					<ul class="inbox1000">
						<li><input type="text" name="search_text" id="search_text" placeholder="서울특별시 금천구 디지털로 210" style="max-width:400px; width:100%"></li>
						<li><a href="/shop/shopLocation_ok.asp" class="btn btn_middle btn-red">이 위치로 설정</a></li>
					</ul>
				</div>
			</div>
			<!-- // 현 위치 기반 주소 검색 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->


	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


