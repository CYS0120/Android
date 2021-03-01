<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="비비큐 소식, BBQ치킨">
<meta name="Description" content="비비큐 소식 메인">
<title>비비큐 소식 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});
	
});
</script>
</head>

<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li><a href="/">bbq home</a></li>
				<li><a href="#">브랜드</a></li>
				<li>비비큐 소식</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">비비큐 소식</h1>
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li><a href="./eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li><a href="./eventList.asp"><span>지난 이벤트</span></a></li>
					<li class="on"><a href="./noticeList.asp"><span>공지사항</span></a></li>
				</ul>
			</div>

			<div class="icon-top">
				<div class="img"><img src="/images/brand/ico_big_notice.gif" alt=""></div>
				<h3>BBQ의새롭고 다양한 소식들을 전해드립니다. 꼭 알아두셔야 할 사항이나 유익한 정보도 확인하세요.</h3>
			</div>

			<table border="1" cellspacing="0" class="tbl-list">
				<caption>상품문의</caption>
				<colgroup>
					<col style="width:106px;">
					<col style="width:auto;">
					<col style="width:180px;">
					<col style="width:150px;">
				</colgroup>
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성일</th>
						<th>조회</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>1</td>
						<td class="ta-l">
							<a href="./noticeView.asp">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
						</td>
						<td>2018-12-20</td>
						<td>265</td>
					</tr>
					<tr>
						<td>1</td>
						<td class="ta-l">
							<a href="./noticeView.asp">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
						</td>
						<td>2018-12-20</td>
						<td>265</td>
					</tr>
					<tr>
						<td>1</td>
						<td class="ta-l">
							<a href="./noticeView.asp">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
						</td>
						<td>2018-12-20</td>
						<td>265</td>
					</tr>
					<tr>
						<td>1</td>
						<td class="ta-l">
							<a href="./noticeView.asp">제너시스 BBQ 통합회원 개인정보 취급 방침 개정안내</a>
						</td>
						<td>2018-12-20</td>
						<td>265</td>
					</tr>
				</tbody>
			</table>

			<div class="board-pager-wrap">
				<div class="board-pager">
					<a href="#" class="board-nav btn_first">처음</a>
					<a href="#" class="board-nav btn_prev">이전</a>
					<ul class="board-page">
						<li class="on"><a href="#">1</a></li>
						<li><a href="#">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
						<li><a href="#">5</a></li>
						<li><a href="#">6</a></li>
						<li><a href="#">7</a></li>
						<li><a href="#">8</a></li>
					</ul>
					<a href="#" class="board-nav btn_next">다음</a>
					<a href="#" class="board-nav btn_last">마지막</a>
				</div>
			</div>

			<div class="mar-t30 ta-c search-board">
				<form action="">
					<input type="text" placeholder="글제목">
					<button type="submit" class="btn btn-md3 btn-black">검색</button>
				</form>
			</div>

		</article>
		<!--// Content -->	
		
		<!-- QuickMenu -->
		<!--#include virtual="/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
