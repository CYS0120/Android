<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="메뉴소개, BBQ치킨">
<meta name="Description" content="메뉴소개">
<title>메뉴소개 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1><a href="#" onclick="javascript:return false;">BBQ치킨</a></h1>
		<div class="btn-header btn-header-nav">
			<button type="button" onClick="javascript:history.back();" class="btn btn_header_back"><span class="ico-only">이전페이지</span></button>
			<button type="button" class="btn btn_header_menu"><span class="ico-only">메뉴</span></button>
		</div>
		<div class="btn-header btn-header-mnu">
			<button type="button" class="btn btn_header_cart"><span class="ico-only">장바구니</span><span class="count">0</span></button>
			<button type="button" class="btn btn_header_brand"><span class="ico-only">패밀리브랜드</span></button>
		</div>
	</header>
	<!--// Header -->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>

		<!-- Content -->
		<article class="content">

			<!-- 메뉴 리스트 -->
			<div class="menu-list">

				<div class="box">
					<h4>황금 올리브 치킨</h4>
					<div class="img">
						<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
						<span class="info">
							<em class="sum">육즙 가득한 BBQ 대표메뉴</em>
							<strong class="pay">19,000원</strong>
						</span>
					</div>
					<ul class="btnWrap">
						<li class="cart"><a href="#" onclick="javascript:return false;" class="btn btn-lg btn-grayLine"><img src="/images/menu/ico_menuCart.png" alt=""> 장바구니</a></li>
						<li class="dir"><a href="#" onclick="javascript:return false;" class="btn btn-lg btn-red"><img src="/images/menu/ico_menuDir.png" alt=""> 바로주문</a></li>
					</ul>
				</div>

				<div class="box">
					<h4>황금 올리브 치킨</h4>
					<div class="img">
						<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
						<span class="info">
							<em class="sum">육즙 가득한 BBQ 대표메뉴</em>
							<strong class="pay">19,000원</strong>
						</span>
					</div>
					<ul class="btnWrap">
						<li class="cart"><a href="#" onclick="javascript:return false;" class="btn btn-lg btn-grayLine"><img src="/images/menu/ico_menuCart.png" alt=""> 장바구니</a></li>
						<li class="dir"><a href="#" onclick="javascript:return false;" class="btn btn-lg btn-red"><img src="/images/menu/ico_menuDir.png" alt=""> 바로주문</a></li>
					</ul>
				</div>

				<div class="box">
					<h4>황금 올리브 치킨</h4>
					<div class="img">
						<a href="./menuView.asp"><img src="/images/menu/@menu.jpg" alt=""></a>
						<span class="info">
							<em class="sum">육즙 가득한 BBQ 대표메뉴</em>
							<strong class="pay">19,000원</strong>
						</span>
					</div>
					<ul class="btnWrap">
						<li class="cart"><a href="#" onclick="javascript:return false;" class="btn btn-lg btn-grayLine"><img src="/images/menu/ico_menuCart.png" alt=""> 장바구니</a></li>
						<li class="dir"><a href="#" onclick="javascript:return false;" class="btn btn-lg btn-red"><img src="/images/menu/ico_menuDir.png" alt=""> 바로주문</a></li>
					</ul>
				</div>

			</div>
			<!-- //메뉴 리스트 -->

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
	</div>
	<!--// Container -->
	<hr>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
