<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>

<body>
<div class="wrapper">
<%
	PageTitle = "매장찾기"
%>
	<!--#include virtual="/includes/header.asp"-->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
				
		<!-- Content -->
		<article class="content content-shopList">
<script>
var map;
var markers = [];
var image = [];


function textSearch() {
	var pos = {
		  lat: $('#lat').val(),
		  lng: $('#lng').val()
		};
		$('.find_shopRoll').slick("unslick");
	setMarkers(map, pos);
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
	  size: new google.maps.Size(60, 65),
	  scaledSize: new google.maps.Size(60, 65)
	};

	$.ajax({
		url:'/api/ajax/shopListAllJs.asp',
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
					// label: {text: ""+json[i].branch_name, color: "white"},
					// label: {text: ""+Number(i+1), color: "white"},
					label: {
						text: ""+Number(i+1),
						fontSize : '40px',
						color: '#fff',
						fontFamily : 'Roboto-Medium'
					},

				});
				markers.push(marker);
				var br_id = json[i].branch_id;
				marker.addListener('click', function() {
					// lpOpen2(".lp-popShop");
					viewBranch(this.no);
					
					map.panTo(this.position);

					// clearMarkers(map, (this.no + 1));
				});
				
				imgSrc = "/images/shop/ico_marker_bbq.png";

				// slideHtml1 += "<li id=\""+json[i].branch_id+"\" class=\"swiper-slide\"><a href=\"/shop/shopView.asp?branch_id="+json[i].branch_id+"\"><span>"+json[i].branch_name+"</span></a></li>\n";
				// slideHtml1 = '';

				slideHtml1 +=			"<div class=\"box\" id=\""+json[i].branch_id+"\">";
				slideHtml1 +=				"<dl class=\"in-sec\">";
				slideHtml1 +=					"<dt><a href=\"./shopView.asp?branch_id="+json[i].branch_id+"\">"+Number(i+1)+". "+json[i].branch_name+"</a>";
				if (json[i].yogiyo_yn == "Y")
					slideHtml1 += "<img src='/images/shop/yogiyo_icon.png' class='yogiyo'>" ;
				if (json[i].membership_yn_code == "50")
					slideHtml1 += "<img src='/images/shop/mem_icon2.png' class='memicon'>" ;
				slideHtml1 += "</dt>" ;
				slideHtml1 +=					"<dd>";
				slideHtml1 +=						"<p class=\"wrap\">";
				slideHtml1 +=							"<span class=\"img\"><img src=\"http://placehold.it/160x160?text="+Number(i+1)+"\" alt=\"\"/></span>";
				slideHtml1 +=							"<span class=\"info\">";
				slideHtml1 +=								"<strong>"+json[i].branch_address+"</strong>";
				slideHtml1 +=								"<a href=\"tel:"+json[i].branch_tel+"\"> </a>";
				slideHtml1 +=							"</span>";
				slideHtml1 +=						"</p>";
				slideHtml1 +=					"</dd>";
				slideHtml1 +=				"</dl>";
				slideHtml1 +=			"</div>";
				// $('#shopArea1').append(slideHtml1);

			}
			// if(slideHtml1 == "") slideHtml1 = "<li class=\"swiper-slide\"><span>해당 매장이 없습니다.</span></a></li>";
			$('#shopArea1').html(slideHtml1);
			// $('#shop_cnt').html(i);
			//매장 하단 스와이프
// $('.find_shopRoll').slick("unslick");
$('.find_shopRoll').slick({
	centerMode: true,
	centerPadding: '60px',
	slidesToShow: 1,
	arrows: false
});

		},
		error:function(xhr){}
	});
}

function viewBranch(branch_no) {
	$('.find_shopRoll').slick('slickGoTo', branch_no);
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
	} else {
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

$(function(){
	$("#search_text").keypress(function(e) {
		if(e.keyCode == 13) {
			e.preventDefault();
			textSearch();
		}
	});
});
</script>
			<!-- 상단 검색 -->
			<div class="find_shopSearch search-box">
				<form class="form">
					<input type="hidden" name="lat" id="lat" value="">
					<input type="hidden" name="lng" id="lng" value="">
					<input type="text" name="search_text" id="search_text" placeholder="어느 지역의 매장을 찾으세요?">
					
				</form>
				<p class="txt">예) 서초동, 공장아파트, GS타워</p>
			</div>
			<!-- //상단 검색 -->

			<!-- 지도 출력 -->
			<div id="map"></div>
			<!-- //지도 출력 -->

			<!-- 매장 롤링 -->
			<div class="find_shopRoll" id="shopArea1">

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

	<!-- Footer  -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>

<script>
	/*
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
*/


</script>
<script src="https://maps.googleapis.com/maps/api/js?key=<%=GOOGLE_MAP_API_KEY%>&callback=initMap" async defer></script>
</body>
</html>