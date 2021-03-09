<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="매장찾기, BBQ치킨">
<meta name="Description" content="매장찾기">
<title>매장찾기 | BBQ치킨</title>
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

	$('.shop_sort .area').niceScroll({
		cursorcolor: '#7d5405',
		cursorborder: '0px solid #000',
		scrollspeed: 150,
		background: '#a76e00',
		zindex: 999
	});

	$(document).on('click', '.tab-type-shop a', function(e) {
		e.preventDefault();
		var i = $(this).index();
		$(this).addClass('on').siblings().removeClass('on');
		$('.shop_sort .area').eq(i).addClass('on').siblings().removeClass('on');
		$('.shop_sort .area').getNiceScroll().resize();
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
				<li>매장찾기</li>
			</ul>
		</div>
		<!--// BreadCrumb -->

		<!-- 매장찾기 -->
		<section class="section section-shop">

			<!-- 지도 출력 -->
			<div id="map"></div>
			<!-- //지도 출력 -->

			<!-- 오른쪽영역 -->
			<div class="float">
				<form action="" class="form">
					<h3>매장찾기</h3>
					<div class="shop_search">
						<input type="text">
						<button type="submit"><img src="/images/shop/btn_shop_search.gif" alt="검색"></button>
					</div>
					<p class="ex">예)서초동,공장아파트,GS타워</p>
				</form>

				<!-- 탭 -->
				<!--<div class="tab tab-type-shop">
					<div class="in-sec">
						<a href="#" class="on">전체</a>
						<a href="#" onclick="javascript:return false;">익스프레스</a>
						<a href="#" onclick="javascript:return false;">프리미엄</a>
						<a href="#" onclick="javascript:return false;">주차장</a>
					</div>
				</div>-->
				<!-- //탭 -->

				<div class="shop_sort">
					<div class="area ">
						<div class="no_more"> 
							<span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span>
							<p class="txt">해당 검색어가 없습니다.</p>
						</div>
					</div>
					<div class="area on">
						<a href="#" class="box" onClick="javascript:lpOpen2('.lp-popShop');return false;">
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</a>
						<a href="#" class="box" onClick="javascript:lpOpen2('.lp-popShop');return false;">
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</a>
						<a href="#" class="box" onClick="javascript:lpOpen2('.lp-popShop');return false;">
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</a>
						<a href="#" class="box" onClick="javascript:lpOpen2('.lp-popShop');return false;">
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</a>
					</div>
					<div class="area">
						<div class="no_more">
							<span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span>
							<p class="txt">해당 검색어가 없습니다.</p>
						</div>
					</div>
					<div class="area">
						<div class="no_more">
							<span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span>
							<p class="txt">해당 검색어가 없습니다.</p>
						</div>
					</div>
					
					<div id="LP_popShop" class="lp-popShop lp-wrapper2">
						<div class="top">
							<p class="icon"><span class="ico_shop">프리미엄 Cafe</span></p>
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</div>
						<div class="bot">
							<ul>
								<li class="w-50p">
									<dl>
										<dt>매장유형</dt>
										<dd>올리브카페</dd>
									</dl>
								</li>
								<li class="w-50p">
									<dl>
										<dt>좌석 수</dt>
										<dd>50</dd>
									</dl>
								</li>
							</ul>
							<ul>
								<li>
									<dl>
										<dt>영업시간</dt>
										<dd>11:00 ~ 23:50</dd>
									</dl>
								</li>
							</ul>
							<ul>
								<li>
									<dl>
										<dt>영업시간</dt>
										<dd>지하철 7호선 가산디지털단지역 5번출구</dd>
									</dl>
								</li>
							</ul>
							<ul>
								<li>
									<dl>
										<dt>제공서비스</dt>
										<dd>
											<ul class="service">
												<li><em><img src="/images/shop/ico_parking.png" alt=""></em> <span>주차</span></li>
												<li><em><img src="/images/shop/ico_wifi.png" alt=""></em> <span>와이파이</span></li>
												<li><em><img src="/images/shop/ico_people.png" alt=""></em> <span>단체</span></li>
											</ul>
										</dd>
									</dl>
								</li>
							</ul>
						</div>
						<button type="button" class="close btn_lp_close2"><img src="/images/shop/ico_close.gif" alt=""></button>

					</div>
				</div>
			</div>
			<!-- //오른쪽영역 -->

		</section>
		<!-- //매장찾기 -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>


<script>




function initMap() {
	var locations = [
		[37.490872, 127.110922],
		[37.492272, 127.112322],
		[37.494472, 127.114422],
		[37.496572, 127.116522],
		[37.498972, 127.118622]
	];
	var myLatLng = {lat: 37.491872, lng: 127.115922};
	var map = new google.maps.Map(document.getElementById('map'), {
		center: myLatLng,
		zoom: 15,
		gestureHandling: 'greedy'
	});


	var infowindow = new google.maps.InfoWindow();

	var marker;
	for (i = 0; i < locations.length; i++) {
		marker = new google.maps.Marker({
			position: new google.maps.LatLng(locations[i][0], locations[i][1]),
			map: map
		});
	}

	var image = '/images/shop/ico_marker.png';
	var marker = new google.maps.Marker({
		map: map,
		position: myLatLng,
		icon: image
	});
}

//지도 높이 값 꽉 차게
function shopHeight(){
	$('#map').height(winH() - 141);
}
shopHeight();
$OBJ.win.on('load resize',function(){
	shopHeight();
});





</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCWwU0wiIB6Pppk4z_WLaV61-0DIAq40E4&callback=initMap" async defer></script>
</body>
</html>
