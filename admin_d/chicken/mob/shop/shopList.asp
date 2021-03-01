<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="매장찾기, BBQ치킨">
<meta name="Description" content="매장찾기">
<title>마이페이지 | 매장찾기</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>매장찾기</h1>
		<div class="btn-header btn-header-nav">
			<button type="button" class="btn btn_header_back"><span class="ico-only">이전페이지</span></button>
			<button type="button" class="btn btn_header_menu"><span class="ico-only">메뉴</span></button>
		</div>
		<div class="btn-header btn-header-mnu">
			<button type="button" class="btn btn_header_cart"><span class="ico-only">장바구니</span></button>
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
		<article class="content content-shopList">

			<!-- 상단 검색 -->
			<div class="find_shopSearch">
				<form class="form">
					<input type="text" placeholder="어느 지역의 매장을 찾으세요?">
				</form>
				<p class="txt">예) 서초동, 공장아파트, GS타워</p>
			</div>
			<!-- //상단 검색 -->

			<!-- 지도 출력 -->
			<div id="map"></div>
			<!-- //지도 출력 -->

			<!-- 매장 롤링 -->
			<div class="find_shopRoll">

				<div class="box">
					<dl class="in-sec">
						<dt><a href="./shopView.asp">1. 가산디지털 단지점 (올리브카페)</a></dt>
						<dd>
							<p class="wrap">
								<span class="img"><img src="http://placehold.it/160x160?text=1" alt=""/></span>
								<span class="info">
									<strong>송파동, 1279m 서울 송파구 송파동 100-1 1층</strong>
									<a href="tel:123-1234-1234">전화하기</a>
								</span>
							</p>
						</dd>
					</dl>
				</div>

				<div class="box">
					<dl class="in-sec">
						<dt><a href="./shopView.asp">1. 가산디지털 단지점 (올리브카페)</a></dt>
						<dd>
							<p class="wrap">
								<span class="img"><img src="http://placehold.it/160x160?text=2" alt=""/></span>
								<span class="info">
									<strong>송파동, 1279m 서울 송파구 송파동 100-1 1층</strong>
									<a href="tel:123-1234-1234">전화하기</a>
								</span>
							</p>
						</dd>
					</dl>
				</div>

				<div class="box">
					<dl class="in-sec">
						<dt><a href="./shopView.asp">1. 가산디지털 단지점 (올리브카페)</a></dt>
						<dd>
							<p class="wrap">
								<span class="img"><img src="http://placehold.it/160x160?text=3" alt=""/></span>
								<span class="info">
									<strong>송파동, 1279m 서울 송파구 송파동 100-1 1층</strong>
									<a href="tel:123-1234-1234">전화하기</a>
								</span>
							</p>
						</dd>
					</dl>
				</div>

				<div class="box">
					<dl class="in-sec">
						<dt><a href="./shopView.asp">1. 가산디지털 단지점 (올리브카페)</a></dt>
						<dd>
							<p class="wrap">
								<span class="img"><img src="http://placehold.it/160x160?text=4" alt=""/></span>
								<span class="info">
									<strong>송파동, 1279m 서울 송파구 송파동 100-1 1층</strong>
									<a href="tel:123-1234-1234">전화하기</a>
								</span>
							</p>
						</dd>
					</dl>
				</div>

			</div>
			<!-- //매장 롤링 -->

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
	</div>
	<!--// Container -->
	<hr>

	<!-- Footer -->
	<!'--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>

<script>
function initMap() {
	var myLatLng = {lat: 37.491872, lng: 127.115922};
	var map = new google.maps.Map(document.getElementById('map'), {
		center: myLatLng,
		zoom: 15,
		gestureHandling: 'greedy'
	});

	var image = '/images/shop/ico_marker.png';
	var marker = new google.maps.Marker({
		map: map,
		position: myLatLng,
		label: {
			text: '27',
			fontSize : '40px',
			color: '#fff',
			fontFamily : 'Roboto-Medium'
		},
		icon: image
	});
}

//매장 하단 스와이프
$('.find_shopRoll').slick({
	centerMode: true,
	centerPadding: '60px',
	slidesToShow: 1,
	arrows: false
});

//지도 높이 값 꽉 차게
function shopHeight(){
	$('#map').height(winH() - 286);
}
shopHeight();
$OBJ.win.on('load resize',function(){
	shopHeight();
});
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCWwU0wiIB6Pppk4z_WLaV61-0DIAq40E4&callback=initMap" async defer></script>
</body>
</html>
