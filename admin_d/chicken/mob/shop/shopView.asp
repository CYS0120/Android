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

			<!-- 매장 상세 -->
			<div class="shop_view">
				<div class="img"><img src="/images/shop/test_shopdetail.jpg" alt="" class="w-100p"></div>
				<div class="area">
					<div class="icon">
						<span class="ico_shop">프리미엄 Cafe</span>
					</div>
					<div class="title">
						<p class="subject">가산디지털단지점 (올리브카페)</p>
						<p class="sum">02-404-8480</p>
						<a href="tel:123-1234-1234" class="tel">전화하기</a>
					</div>
					<div class="info">
						<dl>
							<dt>주소</dt>
							<dd>서울 송파구 문정동 150-25호 1층</dd>
						</dl>
						<dl>
							<dt>좌석수</dt>
							<dd>50</dd>
						</dl>
						<dl>
							<dt>영업시간</dt>
							<dd>09시00분 ~ 12시00분</dd>
						</dl>
						<dl>
							<dt>제공서비스</dt>
							<dd>
								<ul>
									<li><em><img src="/images/shop/ico_parking.png" alt=""></em> <span>주차</span></li>
									<li><em><img src="/images/shop/ico_wifi.png" alt=""></em> <span>와이파이</span></li>
									<li><em><img src="/images/shop/ico_people.png" alt=""></em> <span>단체</span></li>
								</ul>
							</dd>
						</dl>
					</div>

				</div>
				<div class="loc">
				
				</div>
				<div id="map"></div>
			</div>
			<!-- //매장 상세 -->

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

<script>
function initMap() {
	var myLatLng = {lat: 37.491872, lng: 127.115922};
	var map = new google.maps.Map(document.getElementById('map'), {
		center: myLatLng,
		zoom: 15,
		gestureHandling: 'greedy'
	});

	var image = '/images/shop/ico_marker_bbq.png';
	var marker = new google.maps.Marker({
		map: map,
		position: myLatLng,
		icon: image
	});
}
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCWwU0wiIB6Pppk4z_WLaV61-0DIAq40E4&callback=initMap" async defer></script>
</body>
</html>
