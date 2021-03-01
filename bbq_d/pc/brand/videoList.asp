<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="브랜드스토리, BBQ치킨">
<meta name="Description" content="브랜드스토리 메인">
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
				<li>브랜드스토리</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">브랜드스토리</h1>
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li><a href="./bbq.asp"><span>비비큐 이야기</span></a></li>
					<li><a href="./oliveList.asp"><span>올리브 이야기</span></a></li>
					<li class="on"><a href="./videoList.asp"><span>영상콘텐츠</span></a></li>
				</ul>
			</div>

			<!-- 비디오메인 -->
			<div class="section section_videoMain">
				<div class="video">
					<a href="./videoView.asp"><img src="http://placehold.it/740x416" alt=""/></a>
				</div>
				<div class="info">
					<p class="subject">[BBQ] New 로고송 개웃ㅋㅋㅋ</p>
					<p class="con">
						New 로고송 진짜를 만나고 왔닭 ㅋㅋㅋㅋㅋㅋ<br/>
						얘네 진짜 미친거 같아 ㅋㅋㅋㅋ 미쳐따리 미쵸따<br/>
						#비비송 #BBQ비비큐송 한번 들어봐바!! ㅋㅋㅋㅋㅋ
					</p>
					<p class="link">
						<a href="./videoView.asp" class="btn btn-sm btn-grayLine">영상보기</a>
					</p>
				</div>
			</div>
			<!-- //비디오메인 -->

			<!-- 비디오 리스트 -->
			<div class="section section_videoList line mar-t50">
				<div class="box">
					<div class="img"><a href="./videoView.asp"><img src="http://placehold.it/284x159" alt=""/></a></div>
					<div class="txt"><a href="./videoView.asp">[BBQ] Let's Chicketing!</a></div>
				</div>
				<div class="box">
					<div class="img"><a href="./videoView.asp"><img src="http://placehold.it/284x159" alt=""/></a></div>
					<div class="txt"><a href="./videoView.asp">[BBQ] Let's Chicketing!</a></div>
				</div>
				<div class="box">
					<div class="img"><a href="./videoView.asp"><img src="http://placehold.it/284x159" alt=""/></a></div>
					<div class="txt"><a href="./videoView.asp">[BBQ] Let's Chicketing!</a></div>
				</div>
				<div class="box">
					<div class="img"><a href="./videoView.asp"><img src="http://placehold.it/284x159" alt=""/></a></div>
					<div class="txt"><a href="./videoView.asp">[BBQ] Let's Chicketing!</a></div>
				</div>
				<div class="box">
					<div class="img"><a href="./videoView.asp"><img src="http://placehold.it/284x159" alt=""/></a></div>
					<div class="txt"><a href="./videoView.asp">[BBQ] Let's Chicketing!</a></div>
				</div>
				<div class="box">
					<div class="img"><a href="./videoView.asp"><img src="http://placehold.it/284x159" alt=""/></a></div>
					<div class="txt"><a href="./videoView.asp">[BBQ] Let's Chicketing!</a></div>
				</div>
				<div class="box">
					<div class="img"><a href="./videoView.asp"><img src="http://placehold.it/284x159" alt=""/></a></div>
					<div class="txt"><a href="./videoView.asp">[BBQ] Let's Chicketing!</a></div>
				</div>
			</div>
			<!-- //비디오 리스트 -->



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
