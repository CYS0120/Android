<!--#include virtual="/api/include/utf8.asp"-->
<%
	search_text = GetReqStr("search_text", "")
%>
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="매장찾기, BBQ치킨">
<meta name="Description" content="매장찾기">
<title>매장찾기 | BBQ치킨</title>
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

	$('.shop_sort .lp-popShop').niceScroll({
		cursorcolor: '#7d5405',
		cursorborder: '0px solid #000',
		scrollspeed: 150,
		background: '#a76e00',
		zindex: 9999
	});

	$(document).on('click', '.tab-type-shop a', function(e) {
		e.preventDefault();
		var i = $(this).index();
		$(this).addClass('on').siblings().removeClass('on');
		$('.shop_sort .area').eq(i).addClass('on').siblings().removeClass('on');
		$('.shop_sort .area').getNiceScroll().resize();
	});

	$('input[type="text"]').keydown(function() {
	    if (event.keyCode === 13) {
	        event.preventDefault();
	        textSearch();
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
	<div class="container store_cont">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li>bbq home</li>
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
				<form name="search_form" id="search_form" class="form">
					<input type="hidden" name="lat" id="lat" value="">
					<input type="hidden" name="lng" id="lng" value="">
					<h3>매장찾기</h3>
					<div class="shop_search">
						<input type="text" name="search_text" id="search_text" value="<%=search_text%>">
						<button type="button" onClick="textSearch()"><img src="/images/shop/btn_shop_search.gif" alt="검색"></button>
					</div>
					<p class="ex">- 서초동, 대치, 판교</p>
				</form>

				<!-- <div id="shop_rTab" class="shop_sort"></div> -->

				<div class="shop_sort">
					<div class="area on" id="shopArea1">

<!-- 						<div class="no_more"> 
							<span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span>
							<p class="txt">해당 검색어가 없습니다.</p>
						</div>
 -->
					</div>
					<div class="area" id="shopArea2">
<!-- 
						<a href="#" class="box" onClick="javascript:lpOpen2('.lp-popShop');">
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</a>
						<a href="#" class="box" onClick="javascript:lpOpen2('.lp-popShop');">
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</a>
						<a href="#" class="box" onClick="javascript:lpOpen2('.lp-popShop');">
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</a>
						<a href="#" class="box" onClick="javascript:lpOpen2('.lp-popShop');">
							<p class="subject">가산디지털단지점 올리브카페)</p>
							<p class="add">서울특별시 금천구 디지털로 210 (가산동)</p>
							<p class="tel">02-851-9282</p>
						</a>
 -->
					</div>
					<div class="area" id="shopArea3">
						<!-- <div class="no_more">
							<span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span>
							<p class="txt">해당 검색어가 없습니다.</p>
						</div> -->
					</div>
					<div class="area" id="shopArea4">
						<!-- <div class="no_more">
							<span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span>
							<p class="txt">해당 검색어가 없습니다.</p>
						</div> -->
					</div>
					
					<div id="LP_popShop" class="lp-popShop lp-wrapper2">
						
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
var map;
var markers = [];
var image = [];

function loadTabList(branch_id, lat, lng) {
	// console.log(branch_id);
	var pos = {lat:lat, lng:lng};
	var map = new google.maps.Map(document.getElementById('map'), {
		zoom: 15,
		center: pos,
		gestureHandling: 'greedy'
		});

	image = {
	  url: '/images/shop/ico_marker.png',
	  size: new google.maps.Size(35, 40),
	  scaledSize: new google.maps.Size(35, 40)
	};
	var marker = new google.maps.Marker({
		position: new google.maps.LatLng(lat,lng),
		map: map,
		draggable: false,
		//animation: google.maps.Animation.DROP,
		icon: image,
		// label: {text: ""+Number(i+1), color: "white"},
	});
	markers.push(marker);
	marker.addListener('click', function() {
		map.panTo(this.position);
		viewBranch(branch_id);
		// clearMarkers(map, (this.no + 1));
	});
	// setMarkers(map, pos);
	if(branch_id) viewBranch(branch_id);
}

function viewBranch(branch_id) {
	$.ajax({
		url:'./shopListTab.asp',
		type:'POST',
		data:{"branch_id":branch_id},
		success:function(data) {
			$("#LP_popShop").html(data);
			lpOpen2('.lp-popShop');
		}
	});
}

function textSearch() {
	var pos = {
		  lat: $('#lat').val(),
		  lng: $('#lng').val()
		};
	setMarkers(map, pos);
	closeDetail();
}

function closeDetail() {
	$(".lp-popShop").fadeOut('fast');
		// 	$(this).closest(".lp-wrapper2").stop().fadeOut('fast');
		// $(".lp_focus").focus();
		// $(".lp_focus").removeClass(".lp_focus");
}

function setMarkers(map, pos) {
	var slideHtml1 = "";
	var slideHtml2 = "";
	var slideHtml3 = "";
	var slideHtml4 = "";
	var imgSrc = "";
	var dong = "";
	var slideLocation = "";

	image = {
	  url: '/images/shop/ico_marker.png',
	  size: new google.maps.Size(35, 40),
	  scaledSize: new google.maps.Size(35, 40)
	};

	image2 = {
	  url: '/shop/ico_marker.png',
	  size: new google.maps.Size(35, 40),
	  scaledSize: new google.maps.Size(35, 40)
	};

	$.ajax({
		url:'./shopListJs.asp',
		type:'POST',
		data:{"lat":pos.lat, "lng":pos.lng, "search_text":$('#search_text').val()},
		success:function(json) {
			// console.log(json);
			// console.log(json.length);
			for(var i=0; i<json.length; i++) {
				var marker = new google.maps.Marker({
					position: new google.maps.LatLng(json[i].wgs84_y,json[i].wgs84_x),
					map: map,
					draggable: false,
					//animation: google.maps.Animation.DROP,
					icon: image,
					no: i,
					branch_id: json[i].branch_id,
					// label: {text: ""+Number(i+1), color: "white"},
				});
				markers.push(marker);
				var br_id = json[i].branch_id;
				marker.addListener('click', function() {
					// lpOpen2(".lp-popShop");
					viewBranch(this.branch_id);
					
					map.panTo(this.position);

					// clearMarkers(map, (this.no + 1));
				});

				imgSrc = "/images/shop/ico_marker.png";
				slideHtml1 += "<a href='#' class='box' onClick='loadTabList("+json[i].branch_id+","+json[i].wgs84_y+","+json[i].wgs84_x+");'>";
				// slideHtml1 += "<p class='subject'>"+Number(i+1)+"."+json[i].branch_name+"</p>";
				slideHtml1 += "<p class='subject'>"+json[i].branch_name;
//				if (json[i].yogiyo_yn == "Y")
//					slideHtml1 += "<img src='/images/shop/yogiyo_icon.png' class='yogiyo'>" ;
				if (json[i].membership_yn_code == "50")
					slideHtml1 += "<img src='/images/shop/mem_icon2.png' class='memicon'>" ;
				slideHtml1 += "</p>" ;
				slideHtml1 += "<p class='add'>"+json[i].branch_address+"</p>";
				slideHtml1 += "<p class='tel'>"+json[i].branch_tel+"</p>";
				slideHtml1 += "</a>";
				//Express
				// if(json[i].branch_type.toUpperCase() == "CAFE" || json[i].branch_type.toUpperCase() == "REGULAR") {
				// 	slideHtml2 += "<a href='#' class='box' onClick='loadTabList("+json[i].branch_id+","+json[i].wgs84_y+","+json[i].wgs84_x+");'>";
				// 	slideHtml2 += "<p class='subject'>"+json[i].branch_name+"</p>";
				// 	slideHtml2 += "<p class='add'>"+json[i].branch_address+"</p>";
				// 	slideHtml2 += "<p class='tel'>"+json[i].branch_tel+"</p>";
				// 	slideHtml2 += "</a>";
				// }
				// //프리미엄
				// if(json[i].branch_type.indexOf("프리미엄") != -1) {
				// 	slideHtml3 += "<a href='#' class='box' onClick='loadTabList("+json[i].branch_id+","+json[i].wgs84_y+","+json[i].wgs84_x+");'>";
				// 	slideHtml3 += "<p class='subject'>"+json[i].branch_name+"</p>";
				// 	slideHtml3 += "<p class='add'>"+json[i].branch_address+"</p>";
				// 	slideHtml3 += "<p class='tel'>"+json[i].branch_tel+"</p>";
				// 	slideHtml3 += "</a>";
				// }
				// //주차장
				// if(json[i].branch_services.charAt(0) == '1') {
				// 	slideHtml4 += "<a href='#' class='box' onClick='loadTabList("+json[i].branch_id+","+json[i].wgs84_y+","+json[i].wgs84_x+");'>";
				// 	slideHtml4 += "<p class='subject'>"+json[i].branch_name+"</p>";
				// 	slideHtml4 += "<p class='add'>"+json[i].branch_address+"</p>";
				// 	slideHtml4 += "<p class='tel'>"+json[i].branch_tel+"</p>";
				// 	slideHtml4 += "</a>";
				// }

			}
			if(slideHtml1 == '') slideHtml1 = '<div class="no_more"><span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span><p class="txt">해당 검색어가 없습니다.</p></div>';
			// if(slideHtml2 == '') slideHtml2 = '<div class="no_more"><span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span><p class="txt">해당 검색어가 없습니다.</p></div>';
			// if(slideHtml3 == '') slideHtml3 = '<div class="no_more"><span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span><p class="txt">해당 검색어가 없습니다.</p></div>';
			// if(slideHtml4 == '') slideHtml4 = '<div class="no_more"><span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span><p class="txt">해당 검색어가 없습니다.</p></div>';
			$('#shopArea1').html(slideHtml1);
			// $('#shopArea1').html(slideHtml1);
			// $('#shopArea2').html(slideHtml2);
			// $('#shopArea3').html(slideHtml3);
			// $('#shopArea4').html(slideHtml4);
		},
		error:function(xhr){}
	});
}


function initMap() {

	var uluru = {lat: 37.491872, lng: 127.115922};


	// Try HTML5 geolocation.
	if (navigator.geolocation) {
	  navigator.geolocation.getCurrentPosition(function(position) {
		var pos = {
		  lat: position.coords.latitude,
		  lng: position.coords.longitude
		};

		map = new google.maps.Map(document.getElementById('map'), {
		zoom: 15,
		center: pos,
		gestureHandling: 'greedy'
		});

		setMarkers(map, pos);
		$('#lat').val(pos.lat);
		$('#lng').val(pos.lng);
		// loadTabList(pos);
		
	  }, function() {
		  	map = new google.maps.Map(document.getElementById('map'), {
			zoom: 15,
			center: uluru,
			gestureHandling: 'greedy'
			});

			setMarkers(map, uluru);
			$('#lat').val(uluru.lat);
			$('#lng').val(uluru.lng);
	  	
	  });
	}
	else {
	  	// Browser doesn't support Geolocation
		map = new google.maps.Map(document.getElementById('map'), {
		zoom: 15,
		center: uluru,
		gestureHandling: 'greedy'
		});

	  	setMarkers(map, uluru);
	  	$('#lat').val(uluru.lat);
		$('#lng').val(uluru.lng);
	  	console.log('default');
	}
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
<script async defer src="https://maps.googleapis.com/maps/api/js?key=<%=GOOGLE_MAP_API_KEY%>&callback=initMap&region=kr"></script>
</body>
</html>
