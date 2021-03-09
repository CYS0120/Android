<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="주문 방법 선택, BBQ치킨">
<meta name="Description" content="주문 방법 선택 메인">
<title>주문 방법 선택 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<style>
.section-item.item02 {display:none;}
.section-item.item03 {display:none;}
</style>
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

	$(document).on('click', '.orderType-radio .ui-radio:eq(0)', function(e) {
		$(".section-item.item01").show();
		$(".section-item.item02").hide();
		$(".section-item.item03").hide();
	});

	$(document).on('click', '.orderType-radio .ui-radio:eq(1)', function(e) {
		$(".section-item.item01").hide();
		$(".section-item.item02").show();
		$(".section-item.item03").hide();
	});
	$(document).on('click', '.lp_shopList .btn_lp_close', function(e) {
		e.preventDefault();
		$(".section-item.item01").hide();
		$(".section-item.item02").hide();
		$(".section-item.item03").show();
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
		
		<!-- Content -->
		<article class="content">

			<section class="section">
				<div class="section-header">
					<h3>주문 방법 선택 <span class="small">주문방법 선택 후 결제가 가능합니다</span></h3>
				</div>

				<div class="orderType-radio">
					<label class="ui-radio">
						<input type="radio" name="r" id="r1" checked="checked">
						<span></span> 배달주문
					</label>
					<label class="ui-radio">
						<input type="radio" name="r" id="r2">
						<span></span> 픽업주문
					</label>
				</div>

				<div class="section-item item01">
					<h4 class="mar-t60">주소지 관리</h4>
					<div class="boardList-wrap">
						<table border="1" cellspacing="0" class="tbl-list">
							<caption>상품문의</caption>
							<colgroup>
								<col style="width:120px;">
								<col style="width:120px;">
								<col style="width:180px;">
								<col>
								<col style="width:180px;">
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>수령인</th>
									<th>전화번호</th>
									<th>주소</th>
									<th>관리</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><strong class="red">기본주소지</strong></td>
									<td>박하림</td>
									<td>010-1234-1234</td>
									<td class="ta-l">
										(15230)<br>
										서울시 마포구 토정로12길 569-1
									</td>
									<td>
										<button type="button" class="btn btn-sm btn-redLine">선택</button>
									</td>
								</tr>
								<tr>
									<td>
									</td>
									<td>박하림</td>
									<td>010-1234-1234</td>
									<td class="ta-l">
										(15230)<br>
										서울시 마포구 토정로12길 569-1
									</td>
									<td>
										<button type="button" class="btn btn-sm btn-redLine">선택</button>
									</td>
								</tr>
							</tbody>
						</table>

						<div class="bot-area">
							<div class="left txt-basic16">
								- 배달지 관리는 마이페이지 > 회원정보변경에서 확인하실 수 있습니다. 
							</div>
							<div class="right">
								<button type="button" class="btn btn-md3 btn-black" onclick="javascript:lpOpen('.lp_address');">주소지 추가</button>
							</div>
						</div>
					</div>
				</div>
				<div class="section-item item02">
					<div class="boardList-wrap mar-t90">
						<table border="1" cellspacing="0" class="tbl-list">
							<caption>픽업주문</caption>
							<colgroup>
								<col style="width:120px;">
								<col style="width:120px;">
								<col style="width:180px;">
								<col>
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>매장명</th>
									<th>매장 전화번호</th>
									<th>매장주소</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td colspan="4" class="noData">픽업 매장 찾기를 통해 픽업가능한 매장을 선택해 주세요.</td>
								</tr>
							</tbody>
						</table>

						<div class="btn-wrap two-up inner mar-t60">
							<button type="submit" class="btn btn-lg btn-black" onclick="javascript:lpOpen('.lp_shopList');"><span>픽업 매장 찾기</span></button>
						</div>
					</div>
				</div>
				<div class="section-item item03">
					<div class="boardList-wrap mar-t90">
						<table border="1" cellspacing="0" class="tbl-list">
							<caption>픽업주문</caption>
							<colgroup>
								<col style="width:120px;">
								<col style="width:120px;">
								<col style="width:180px;">
								<col>
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>매장명</th>
									<th>매장 전화번호</th>
									<th>매장주소</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><strong class="red">픽업 매장</strong></td>
									<td>구로점</td>
									<td>02-35-5263</td>
									<td class="ta-l">(15230)<br>서울시 마포구 토정로12길 569-1</td>
								</tr>
							</tbody>
						</table>

						<div class="btn-wrap two-up inner mar-t60">
							<button type="submit" class="btn btn-lg btn-black" onclick="javascript:lpOpen('.lp_shopList');"><span>픽업매장 재검색</span></button>
							<button type="button" class="btn btn-lg btn-red"><span>주문서 작성</span></button>
						</div>
					</div>
				</div>
			</section>

			<!-- Layer Popup : 매장찾기 onclick="javascript:lpOpen('.lp_shopList');" -->
			<div id="lp_shopList" class="lp-wrapper lp_shopList">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>매장찾기</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">
								<section class="section2 section-shop">

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

										

										<div class="shop_sort">
											<div class="area ">
												<div class="no_more"> 
													<span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span>
													<p class="txt">해당 검색어가 없습니다.</p>
												</div>
											</div>
											<div class="area on">
												<a href="#" onclick="javascript:return false;" class="box" >
													<p class="subject">가산디지털단지점 올리브카페)</p>
													<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
													<p class="tel">02-851-9282</p>
												</a>
												<a href="#" onclick="javascript:return false;" class="box" >
													<p class="subject">가산디지털단지점 올리브카페)</p>
													<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
													<p class="tel">02-851-9282</p>
												</a>
												<a href="#" onclick="javascript:return false;" class="box" >
													<p class="subject">가산디지털단지점 올리브카페)</p>
													<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
													<p class="tel">02-851-9282</p>
												</a>
												<a href="#" onclick="javascript:return false;" class="box" >
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
											
											
										</div>
									</div>
									<!-- //오른쪽영역 -->

								</section>
							</div>
							<!--// LP Content -->
						</div>
						<!--// LP Container -->
						<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
					</div>
				</div>
				<!--// LP Wrap -->
			</div>
			<!--// Layer Popup -->


			<!-- Layer Popup : 주소지 추가 -->
			<div id="LP_Address" class="lp-wrapper lp_address">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>주소지 입력</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">
								<section class="section">
									<form action="">
										<table border="1" cellspacing="0" class="tbl-member black-line">
											<caption>추가정보</caption>
											<colgroup>
												<col style="width:170px;">
												<col style="width:auto;">
											</colgroup>
											<tbody>
												<tr>
													<th>이름</th>
													<td>
														<input type="text" class="w-150">
													</td>
												</tr>
												<tr>
													<th>전화번호</th>
													<td>
														<div class="ui-group-email">
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text"></span>
														</div>
													</td>
												</tr>
												<tr>
													<th>주소</th>
													<td>
														<div class="ui-input-post">
															<input type="text" name="sPost" id="sPost" maxlength="7" readonly="">
															<button type="button" class="btn btn-md2 btn-gray btn_post"><span>우편번호 검색</span></button>
														</div>
														<div class="mar-t10">
															<input type="text" class="w-100p">
														</div>
														<div class="mar-t10">
															<input type="text" class="w-100p">
														</div>
													</td>
												</tr>
											</tbody>
										</table>

										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
											<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
										</div>
									</form>
								</section>
							</div>
							<!--// LP Content -->
						</div>
						<!--// LP Container -->
						<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
					</div>
				</div>
				<!--// LP Wrap -->
			</div>
			<!--// Layer Popup -->


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
	$('#map').height(winH() - 211);
}
shopHeight();
$OBJ.win.on('load resize',function(){
	shopHeight();
});





</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCWwU0wiIB6Pppk4z_WLaV61-0DIAq40E4&callback=initMap" async defer></script>
</body>
</html>
