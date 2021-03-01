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

			<!-- 매장검색 -->
			<div class="inbox1000">

				<!-- 검색 -->
				<div class="find_shopSearch search-box">
					<form class="form">
						<input type="hidden" name="lat" id="lat" value="">
						<input type="hidden" name="lng" id="lng" value="">
						<input type="hidden" name="dir_yn" id="dir_yn" value="<%=dir_yn%>">
						<input type="text" name="search_text" id="search_text" placeholder="가산동">
						<!--<button type="button" class="btn-sch" onclick="textSearch();"><img src="/images/order/btn_search.png" alt="검색"></button>-->
					</form>
				</div>
				<!-- // 검색 -->

				<!-- 매장 리스트 -->
				<ul class="shopSearch_list">
					<li>
						<ul class="shop_select">
							<li><input  type="radio" id="shop1"></li>
							<li><label for="shop1">서울 특별시 금천구 디지털로 210(가산동 219-</label></li>
						</ul>
						<p><label for="shop1"><span>[지번]</span> 서울 특별시 금천구 가산동 219-6 에이스 하이엔드</label></p>
					</li>
					<li>
						<ul class="shop_select">
							<li><input  type="radio" id="shop1"></li>
							<li><label for="shop1">서울 특별시 금천구 디지털로 210(가산동 219-</label></li>
						</ul>
						<p><label for="shop1"><span>[지번]</span> 서울 특별시 금천구 가산동 219-6 에이스 하이엔드</label></p>
					</li>
				</ul>
				<!-- // 매장 리스트 -->
					
				<!-- 상세주소입력 -->
				<dl class="detaile_address">
					<dt>상세주소입력</dt>
					<dd>서울 특별시 금천구 디지털로 210(가산동)</dd>
					<dd><input type="text" placeholder="상세 주소를 입력하세요" style="width:100%"></dd>
				</dl>
				<!-- // 상세주소입력 -->
				
				<div class="btn_shopSearch">
					<a href="" class="btn btn-redLine btn_big">취소</a> <a href="" class="btn btn-red btn_big">확인</a>
				</div>

			</div>
			<!-- //매장검색 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->


	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


