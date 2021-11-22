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
					<li><a href="./eventList.asp"><span>진행중인 이벤트</span></a></li>
					<li><a href="./eventList.asp"><span>지난 이벤트</span></a></li>
					<li class="on"><a href="./noticeList.asp"><span>공지사항</span></a></li>
				</ul>
			</div>

			<!-- 게시판 뷰 -->
			<div class="board-view">
				<div class="top">
					<h3>
						제너시스 BBQ 통합회원 개인정보 처리방침 개정안내 개인정보 처리방침 개정안내 
					</h3>
					<ul class="info">
						<li class="date"><strong>등록일 :</strong> 2018-12-14</li>
						<li class="hit"><strong>조회수 :</strong> 3265</li>
					</ul>
				</div>
				<div class="con">
					제너시스 BBQ 통합회원 개인정보 처리방침 개정안내 내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용 표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시
					제너시스 BBQ 통합회원 개인정보 처리방침 개정안내 내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용 표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시
					제너시스 BBQ 통합회원 개인정보 처리방침 개정안내 내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용 표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시내용표시 내용표시
				</div>
			</div>
			<!-- //게시판 뷰 -->

			<div class="btn-wrap two-up inner mar-t60">
				<a href="#" onclick="javascript:return false;" class="btn btn-lg btn-black"><span>목록</span></a>
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
