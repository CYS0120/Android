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

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content">

			<!-- 현 위치 기반 주소 검색 -->
			<div class="locationOk_wrap">
				<div class="locationOk_map"></div>
				<!-- 상세주소입력 -->
				<dl class="detaile_address inbox1000">
					<dt>상세주소입력</dt>
					<dd>서울 특별시 금천구 디지털로 210(가산동)</dd>
					<dd><input type="text" placeholder="상세 주소를 입력하세요" style="width:100%"></dd>
				</dl>
				<!-- // 상세주소입력 -->

				<div class="btn_shopSearch inbox1000">
					<a href="" class="btn btn-redLine btn_big">취소</a> <a href="" class="btn btn-red btn_big">확인</a>
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


