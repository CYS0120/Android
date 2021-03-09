<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="비비큐 소식, BBQ치킨">
<meta name="Description" content="비비큐 소식 메인">
<title>비비큐 소식 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
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
				<li><a href="#" onclick="javascript:return false;">bbq home</a></li>
				<li><a href="#" onclick="javascript:return false;">브랜드</a></li>
				<li>비비큐 소식</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">비비큐 소식</h1>
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li class="on"><a href="./eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li><a href="./eventList.asp"><span>지난 이벤트</span></a></li>
					<li><a href="./noticeList.asp"><span>공지사항</span></a></li>
				</ul>
			</div>

			<!-- 이벤트 목록 없을 때-->
			<!-- <div class="event-list">
				<div class="nomore">
					<div class="img"><img src="/images/brand/ico_nomore.png" alt=""></div>
					<div class="txt">현지 진행중인 이벤트가 없습니다.</div>
				</div>
			</div> -->
			<!-- //이벤트 목록 없을 때 -->

			<!-- 이벤트 목록 -->
			<div class="event-list">
				<div class="box">
					<div class="img"><a href="./eventView.asp"><img src="/images/brand/@event.jpg" alt=""></a></div>
					<div class="info">
						<p class="subject"><a href="./eventView.asp">[BBQ] Let's Chicketing!</a></p>
						<p class="date">2018-12-19 ~ 2018-12-25</p>
					</div>
				</div>
				<div class="box">
					<div class="img"><a href="./eventView.asp"><img src="/images/brand/@event.jpg" alt=""></a></div>
					<div class="info">
						<p class="subject"><a href="./eventView.asp">[BBQ] Let's Chicketing!</a></p>
						<p class="date">2018-12-19 ~ 2018-12-25</p>
					</div>
				</div>
				<div class="box">
					<div class="img"><a href="./eventView.asp"><img src="/images/brand/@event.jpg" alt=""></a></div>
					<div class="info">
						<p class="subject"><a href="./eventView.asp">[BBQ] Let's Chicketing!</a></p>
						<p class="date">2018-12-19 ~ 2018-12-25</p>
					</div>
				</div>
			</div>
			<!-- //이벤트 목록 -->


			<div class="board-pager-wrap">
				<div class="board-pager">
					<a href="#" onclick="javascript:return false;" class="board-nav btn_first">처음</a>
					<a href="#" onclick="javascript:return false;" class="board-nav btn_prev">이전</a>
					<ul class="board-page">
						<li class="on"><a href="#" onclick="javascript:return false;">1</a></li>
						<li><a href="#" onclick="javascript:return false;">2</a></li>
						<li><a href="#" onclick="javascript:return false;">3</a></li>
						<li><a href="#" onclick="javascript:return false;">4</a></li>
						<li><a href="#" onclick="javascript:return false;">5</a></li>
						<li><a href="#" onclick="javascript:return false;">6</a></li>
						<li><a href="#" onclick="javascript:return false;">7</a></li>
						<li><a href="#" onclick="javascript:return false;">8</a></li>
					</ul>
					<a href="#" onclick="javascript:return false;" class="board-nav btn_next">다음</a>
					<a href="#" onclick="javascript:return false;" class="board-nav btn_last">마지막</a>
				</div>
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
