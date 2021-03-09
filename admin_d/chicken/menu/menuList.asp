<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="전체메뉴, BBQ치킨">
<meta name="Description" content="전체메뉴">
<title>전체메뉴 | BBQ치킨</title>
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
		<div class="breadcrumb-wrap type2">
			<ul class="breadcrumb">
				<li><a href="#" onclick="javascript:return false;">bbq home</a></li>
				<li><a href="#" onclick="javascript:return false;">메뉴</a></li>
				<li><a href="#" onclick="javascript:return false;">치킨</a></li>
				<li class="menu">
					<a href="#" onclick="javascript:return false;">모든 비비큐치킨</a>
					<a href="#" onclick="javascript:return false;">순수하게 후라이드</a>
					<a href="#" onclick="javascript:return false;">다양하게 양념</a>
					<a href="#" onclick="javascript:return false;">섞어먹자 반반</a>
					<a href="#" onclick="javascript:return false;">구워먹는 비비큐</a>
					<a href="#" onclick="javascript:return false;">구이</a>
					<a href="#" onclick="javascript:return false;">야식</a>
				</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<section class="section">

				<div class="section-header">
					<h3>전체메뉴</h3>
				</div>

				<div class="section-body">
					<!-- 메뉴 탭 -->
					<ul class="menu-tab">
						<li class="on"><a href="#" onclick="javascript:return false;">모든 비비큐치킨</a></li>
						<li><a href="#" onclick="javascript:return false;">순수하게 후라이드</a></li>
						<li><a href="#" onclick="javascript:return false;">다양하게 양념</a></li>
						<li><a href="#" onclick="javascript:return false;">섞어먹자 반반</a></li>
						<li><a href="#" onclick="javascript:return false;">구워먹는 비비큐</a></li>
						<li><a href="#" onclick="javascript:return false;">구이</a></li>
						<li><a href="#" onclick="javascript:return false;">야식</a></li>
					</ul>
					<!-- //메뉴 탭 -->

					<div class="menu-list">
					
						<div class="box">
							<div class="img">
								<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
								<ul class="over">
									<li class="cart"><a href="#" onclick="javascript:return false;">장바구니</a></li>
									<li class="dir"><a href="#" onclick="javascript:return false;">바로주문</a></li>
								</ul>
							</div>
							<div class="info">
								<p class="name">황금올리브치킨</p>
								<p class="sum">BBQ만의 황금빛 파우더가 선사하는 잊을 수 없는 바삭바삭함과육즙의 향연</p>
								<p class="pay">19,000원</p>
							</div>
						</div>
					
						<div class="box">
							<div class="img">
								<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
								<ul class="over">
									<li class="cart"><a href="#" onclick="javascript:return false;">장바구니</a></li>
									<li class="dir"><a href="#" onclick="javascript:return false;">바로주문</a></li>
								</ul>
							</div>
							<div class="info">
								<p class="name">황금올리브치킨</p>
								<p class="sum">BBQ만의 황금빛 파우더가 선사하는 잊을 수 없는 바삭바삭함과육즙의 향연</p>
								<p class="pay">19,000원</p>
							</div>
						</div>
					
						<div class="box">
							<div class="img">
								<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
								<ul class="over">
									<li class="cart"><a href="#" onclick="javascript:return false;">장바구니</a></li>
									<li class="dir"><a href="#" onclick="javascript:return false;">바로주문</a></li>
								</ul>
							</div>
							<div class="info">
								<p class="name">황금올리브치킨</p>
								<p class="sum">BBQ만의 황금빛 파우더가 선사하는 잊을 수 없는 바삭바삭함과육즙의 향연</p>
								<p class="pay">19,000원</p>
							</div>
						</div>
					
						<div class="box">
							<div class="img">
								<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
								<ul class="over">
									<li class="cart"><a href="#" onclick="javascript:return false;">장바구니</a></li>
									<li class="dir"><a href="#" onclick="javascript:return false;">바로주문</a></li>
								</ul>
							</div>
							<div class="info">
								<p class="name">황금올리브치킨</p>
								<p class="sum">BBQ만의 황금빛 파우더가 선사하는 잊을 수 없는 바삭바삭함과육즙의 향연</p>
								<p class="pay">19,000원</p>
							</div>
						</div>
					
						<div class="box">
							<div class="img">
								<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
								<ul class="over">
									<li class="cart"><a href="#" onclick="javascript:return false;">장바구니</a></li>
									<li class="dir"><a href="#" onclick="javascript:return false;">바로주문</a></li>
								</ul>
							</div>
							<div class="info">
								<p class="name">황금올리브치킨</p>
								<p class="sum">BBQ만의 황금빛 파우더가 선사하는 잊을 수 없는 바삭바삭함과육즙의 향연</p>
								<p class="pay">19,000원</p>
							</div>
						</div>
					
						<div class="box">
							<div class="img">
								<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
								<ul class="over">
									<li class="cart"><a href="#" onclick="javascript:return false;">장바구니</a></li>
									<li class="dir"><a href="#" onclick="javascript:return false;">바로주문</a></li>
								</ul>
							</div>
							<div class="info">
								<p class="name">황금올리브치킨</p>
								<p class="sum">BBQ만의 황금빛 파우더가 선사하는 잊을 수 없는 바삭바삭함과육즙의 향연</p>
								<p class="pay">19,000원</p>
							</div>
						</div>

					</div>
				</div>

			</section>

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
