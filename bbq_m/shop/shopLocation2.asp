<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>

<body>
<div class="wrapper">
<%
	PageTitle = "매장 찾기"
	Dim dir_yn : dir_yn = Request("dir_yn")
	Dim search_text : search_text = Request("search_text")
%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content content-shopList">

			<!--#include virtual="/includes/step.asp"-->

			<script>
				var map;
				var markers = [];
				var image = [];

				var MARKER_WIDTH = 33, // 기본, 클릭 마커의 너비
					MARKER_HEIGHT = 36, // 기본, 클릭 마커의 높이
					OFFSET_X = 12, // 기본, 클릭 마커의 기준 X좌표
					OFFSET_Y = MARKER_HEIGHT, // 기본, 클릭 마커의 기준 Y좌표
					OVER_MARKER_WIDTH = 40, // 오버 마커의 너비
					OVER_MARKER_HEIGHT = 42, // 오버 마커의 높이
					OVER_OFFSET_X = 13, // 오버 마커의 기준 X좌표
					OVER_OFFSET_Y = OVER_MARKER_HEIGHT, // 오버 마커의 기준 Y좌표
					SPRITE_MARKER_URL = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markers_sprites2.png', // 스프라이트 마커 이미지 URL
					SPRITE_WIDTH = 126, // 스프라이트 이미지 너비
					SPRITE_HEIGHT = 146, // 스프라이트 이미지 높이
					SPRITE_GAP = 10; // 스프라이트 이미지에서 마커간 간격

				var markerSize = new kakao.maps.Size(MARKER_WIDTH, MARKER_HEIGHT), // 기본, 클릭 마커의 크기
					markerOffset = new kakao.maps.Point(OFFSET_X, OFFSET_Y), // 기본, 클릭 마커의 기준좌표
					overMarkerSize = new kakao.maps.Size(OVER_MARKER_WIDTH, OVER_MARKER_HEIGHT), // 오버 마커의 크기
					overMarkerOffset = new kakao.maps.Point(OVER_OFFSET_X, OVER_OFFSET_Y), // 오버 마커의 기준 좌표
					spriteImageSize = new kakao.maps.Size(SPRITE_WIDTH, SPRITE_HEIGHT); // 스프라이트 이미지의 크기
				
				var positions = [];
				var selectedMarker = null; // 클릭한 마커를 담을 변수
/* 2021-03-14
function clearMarkers() {
  setMapOnAll(null);
}
function setMapOnAll(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}*/
				function textSearch() {
					var pos = {
						  lat: $('#lat').val(),
						  lng: $('#lng').val()
						};
						//$('.find_shopRoll').slick("unslick");
						$("#search_text").blur();
					setMarkers(map, pos);
				}

				function setMarkers(map, pos) {
					console.log("@@@")
					console.log(map)
					console.log(pos)
					console.log("@@@")
					var slideHtml1 = "";
					var slideHtml2 = "";
					var slideHtml3 = "";
					var slideHtml4 = "";
					var imgSrc = "";
					var dong = "";
					var slideLocation = "";
					var center = "";
					var br_ids = "";
					var mapCustomOverlay = new kakao.maps.CustomOverlay({});
					
					positions = [];
					mapCustomOverlay.setMap(null);

					/* 2021-03-14
					image = {
					  url: '/images/shop/ico_marker.png',
					  size: new google.maps.Size(40, 45),
					  scaledSize: new google.maps.Size(40, 45)
					};
					*/

					$.ajax({
						url:'/api/ajax/shopListAllJs.asp',
						type:'POST',
						data:{"lat":pos.lat, "lng":pos.lng, "search_text":$('#search_text').val()},
						success:function(json) {
							// console.log(json);
							// console.log(json.length);

							// 2021-03-04 주석
							//clearMarkers() //기존마커삭제

							for(var i=0; i<json.length; i++) {
								
								positions.push(new kakao.maps.LatLng(json[i].wgs84_y, json[i].wgs84_x))  // 마커의 위치
									
							/* 2021-03-14 주석
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
										fontSize : '25px',
										color: '#fff',
										fontFamily : 'Roboto-Medium'
									},

								});
								
								markers.push(marker);
								var br_id = json[i].branch_id;
								//alert(json[i].branch_id)
								marker.addListener('click', function() {
									// lpOpen2(".lp-popShop");
									viewBranch(this.no);
									
									map.panTo(this.position);

									// clearMarkers(map, (this.no + 1));
								});

								if(i == 0){
								var center = new google.maps.LatLng(json[i].wgs84_y,json[i].wgs84_x);
								map.panTo(center);
								var br_ids = json[i].branch_id;
								}

								imgSrc = "/images/shop/ico_marker_bbq.png";
							*/
								
								if(i == 0){
									//center = new google.maps.LatLng(json[i].wgs84_y,json[i].wgs84_x);
									center = new kakao.maps.LatLng(json[i].wgs84_y,json[i].wgs84_x);									
									br_ids = json[i].branch_id;
								}

								// slideHtml1 += "<li id=\""+json[i].branch_id+"\" class=\"swiper-slide\"><a href=\"/shop/shopView.asp?branch_id="+json[i].branch_id+"\"><span>"+json[i].branch_name+"</span></a></li>\n";
								// slideHtml1 = '';

								slideHtml1 +=			"<div class=\"box swiviewbox swiview"+(i)+"\" id=\""+json[i].branch_id+"\" style=\"display:none\">";
								slideHtml1 +=				"<dl class=\"in-sec\">";
								slideHtml1 +=					"<dt  style='height:15px'><a href=\"./shopView.asp?branch_id="+json[i].branch_id+"\">"+Number(i+1)+". "+json[i].branch_name+"";
//								if (json[i].yogiyo_yn == "Y")
//									slideHtml1 += "<p><span><img src='/images/shop/yogiyo_icon.png' class='yogiyo'></span>" ;
								if (json[i].membership_yn_code == "50")
									slideHtml1 += "<span class='floatR'><img src='/images/shop/mem_icon2.png' class='memicon'></span>" ;
								slideHtml1 +=					"</a></dt>" ;
								slideHtml1 +=					"<dd>";
								slideHtml1 +=						"<p class=\"wrap\">";
								slideHtml1 +=							"<span class=\"img\"><img src=\"http://placehold.it/130x130?text="+Number(i+1)+"\" alt=\"\"/></span>";
								slideHtml1 +=							"<span class=\"info\">";
								slideHtml1 +=								"<strong>"+json[i].branch_address+"</strong>";
								slideHtml1 +=								"<strong>"+json[i].branch_tel+"</strong>";
								slideHtml1 +=							"</span>";
								slideHtml1 +=						"</p>";
								slideHtml1 +=					"</dd>";
								slideHtml1 +=				"</dl>";
								slideHtml1 +=				"<div class=\"btn_wrap\">";
								<% if dir_yn <> "Y" then %>
								slideHtml1 +=						"<strong onclick=\"telStore('"+ json[i].branch_tel +"')\" class='btn-order2'>전화</strong><strong onclick=\"selectStore('"+ json[i].branch_id +"')\" class='btn-order2'>포장주문</strong>";
								<% end if %>
								slideHtml1 +=						"<input type='hidden' id='br_"+ json[i].branch_id +"' value='"+ JSON.stringify(json[i]) +"'>";
								//slideHtml1 +=						"<a href=\"tel:"+json[i].branch_tel+"\"> </a>";
								slideHtml1 +=				"</div>";
								slideHtml1 +=			"</div>";
								// $('#shopArea1').append(slideHtml1);

							}
							// if(slideHtml1 == "") slideHtml1 = "<li class=\"swiper-slide\"><span>해당 매장이 없습니다.</span></a></li>";
							$('#shopArea1').html(slideHtml1);
							// $('#shop_cnt').html(i);
							
							$("#"+br_ids).show();	
							
							//매장 하단 스와이프
							// $('.find_shopRoll').slick("unslick");
							//$('.find_shopRoll').slick({
							//	centerMode: true,
							//	centerPadding: '30px',
							//	slidesToShow: 1,
							//	arrows: false,
							//	draggable : false
							//});

							var mapContainer = document.getElementById('map'), // 지도를 표시할 div
								mapOption = { 
									center: center, // 지도의 중심좌표
									level: 5 // 지도의 확대 레벨
								};

							var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

							// 지도 위에 마커를 표시합니다
							for (var i = 0; i < positions.length; i++) {
								var gapX = (MARKER_WIDTH + SPRITE_GAP), // 스프라이트 이미지에서 마커로 사용할 이미지 X좌표 간격 값
									originY = (MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 기본, 클릭 마커로 사용할 Y좌표 값
									overOriginY = (OVER_MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 오버 마커로 사용할 Y좌표 값
									normalOrigin = new kakao.maps.Point(0, originY), // 스프라이트 이미지에서 기본 마커로 사용할 영역의 좌상단 좌표
									clickOrigin = new kakao.maps.Point(gapX, originY), // 스프라이트 이미지에서 마우스오버 마커로 사용할 영역의 좌상단 좌표
									overOrigin = new kakao.maps.Point(gapX * 2, overOriginY); // 스프라이트 이미지에서 클릭 마커로 사용할 영역의 좌상단 좌표
								
								// 커스텀 오버레이를 생성합니다
								mapCustomOverlay = new kakao.maps.CustomOverlay({
									map: map,
									position: positions[i],
									content: "<div><span class='count' id='cart_item_count' style='position:absolute; border-radius:100%; background:#f20000; line-height:22px; color:#fff; font-family:\"Roboto-Bold\"; text-align:center; width:22px; height:22px; font-size:12px;'>"+(i+1)+"</span></div>",
									xAnchor: 0.5, // 커스텀 오버레이의 x축 위치입니다. 1에 가까울수록 왼쪽에 위치합니다. 기본값은 0.5 입니다
									yAnchor: 1.1 // 커스텀 오버레이의 y축 위치입니다. 1에 가까울수록 위쪽에 위치합니다. 기본값은 0.5 입니다
								});

								// 커스텀 오버레이를 지도에 표시합니다
								mapCustomOverlay.setMap(map);								

								// 마커를 생성하고 지도위에 표시합니다
								//addMarker(positions[i], normalOrigin, overOrigin, clickOrigin, map);
							}


						},
						error:function(xhr){

							alert(xhr)
						}
					});
				}

				// 마커를 생성하고 지도 위에 표시하고, 마커에 mouseover, mouseout, click 이벤트를 등록하는 함수입니다
				function addMarker(position, normalOrigin, overOrigin, clickOrigin, map) {

					// 기본 마커이미지, 오버 마커이미지, 클릭 마커이미지를 생성합니다
					var normalImage = createMarkerImage(markerSize, markerOffset, normalOrigin),
						overImage = createMarkerImage(overMarkerSize, overMarkerOffset, overOrigin),
						clickImage = createMarkerImage(markerSize, markerOffset, clickOrigin);
					
					// 마커를 생성하고 이미지는 기본 마커 이미지를 사용합니다
					var marker = new kakao.maps.Marker({
						map: map,
						position: position,
						image: normalImage
					});

					// 마커 객체에 마커아이디와 마커의 기본 이미지를 추가합니다
					marker.normalImage = normalImage;

					// 마커에 mouseover 이벤트를 등록합니다
					kakao.maps.event.addListener(marker, 'mouseover', function() {

						// 클릭된 마커가 없고, mouseover된 마커가 클릭된 마커가 아니면
						// 마커의 이미지를 오버 이미지로 변경합니다
						if (!selectedMarker || selectedMarker !== marker) {
							marker.setImage(overImage);
						}
					});

					// 마커에 mouseout 이벤트를 등록합니다
					kakao.maps.event.addListener(marker, 'mouseout', function() {

						// 클릭된 마커가 없고, mouseout된 마커가 클릭된 마커가 아니면
						// 마커의 이미지를 기본 이미지로 변경합니다
						if (!selectedMarker || selectedMarker !== marker) {
							marker.setImage(normalImage);
						}
					});

					// 마커에 click 이벤트를 등록합니다
					kakao.maps.event.addListener(marker, 'click', function() {

						// 클릭된 마커가 없고, click 마커가 클릭된 마커가 아니면
						// 마커의 이미지를 클릭 이미지로 변경합니다
						if (!selectedMarker || selectedMarker !== marker) {

							// 클릭된 마커 객체가 null이 아니면
							// 클릭된 마커의 이미지를 기본 이미지로 변경하고
							!!selectedMarker && selectedMarker.setImage(selectedMarker.normalImage);

							// 현재 클릭된 마커의 이미지는 클릭 이미지로 변경합니다
							marker.setImage(clickImage);
						}

						// 클릭된 마커를 현재 클릭된 마커 객체로 설정합니다
						selectedMarker = marker;
					});
				}

				// MakrerImage 객체를 생성하여 반환하는 함수입니다
				function createMarkerImage(markerSize, offset, spriteOrigin) {
					var markerImage = new kakao.maps.MarkerImage(
						SPRITE_MARKER_URL, // 스프라이트 마커 이미지 URL
						markerSize, // 마커의 크기
						{
							offset: offset, // 마커 이미지에서의 기준 좌표
							spriteOrigin: spriteOrigin, // 스트라이프 이미지 중 사용할 영역의 좌상단 좌표
							spriteSize: spriteImageSize // 스프라이트 이미지의 크기
						}
					);
					
					return markerImage;
				}

				function telStore(tel) {
					location.href="tel://" + tel;
				}

				function selectStore(br_id) {

					// 다른 매장 선택시 장바구니 상품 제거.
					change_store_cart(br_id);

					$.ajax({
						method: "post",
						url: "/api/ajax/ajax_getStoreOnline.asp",
						data: {"branch_id": br_id},
						dataType: "json",
						success: function(res) {
							if(res.result == "0000") {
								$.ajax({
									method: "post",
									url: "/api/ajax/ajax_eventshop_check.asp",
									data: {"MENUIDX":$("#CART_IN_PRODIDX").val(),"BRANCH_ID":br_id},
									dataType: "json",
									success: function(data) {
										if(data.result == "9999") {
											showAlertMsg({msg:data.message});
										}else{
											var br_data = $("#br_"+br_id).attr("value");
											var branch_data = JSON.parse(br_data);

//											$("#branch_id").val(br_id);
//											$("#branch_data").val(br_data);

											sessionStorage.setItem("ss_branch_id", br_id);
											sessionStorage.setItem("ss_branch_data", br_data);

											sessionStorage.setItem("ss_order_type", "P");
											sessionStorage.setItem("ss_addr_idx", "");
											sessionStorage.setItem("ss_addr_data", "");

											//$("#spent_time").val($(".pickup-wrap2 input[name=after]:checked").val());

											// lpClose('.lp_shopSearch');
			//								setSelectedStore();
			//								document.cart_form.submit();
											if (getAllCartMenuCount() > 0) {
												location.href="/order/cart.asp";
											} else {
												location.href="/menu/menuList.asp";
											}
										}
									},
									error: function(xhr) {
										showAlertMsg({msg:"시스템 에러가 발생했습니다."});
									}
								});

							} else {
								sessionStorage.setItem("ss_branch_id", br_id);
								sessionStorage.setItem("ss_branch_data", br_data);
								sessionStorage.setItem("ss_order_type", "P");

								sessionStorage.removeItem("ss_addr_idx");
								sessionStorage.removeItem("ss_addr_data");

								showAlertMsg({msg:res.message+"  메뉴리스트로 이동합니다", ok: function(){
									location.href='/menu/menuList.asp';
								}});
							}
						},
						error: function(xhr) {
							showAlertMsg({msg:"포장 매장을 다시 선택해주세요."});
						}
					});
				}

				function viewBranch(branch_no) {
					$(".swiviewbox").hide();
					$(".swiview"+branch_no).show();
					//$('.find_shopRoll').slick('slickGoTo', branch_no);
				}

				function initMap() {

					var uluru = {};
					
					// Try HTML5 geolocation.
					/* 2021-03-13
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
						uluru = pos;
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
					}*/
					
					if (navigator.geolocation) {
						navigator.geolocation.getCurrentPosition(function(position) {
							uluru = {
								lat: position.coords.latitude,
								lng: position.coords.longitude
							};

							//setMarkers(map, pos);
							$('#lat').val(uluru.lat);
							$('#lng').val(uluru.lng);
							// loadTabList(pos);
							console.log(uluru.lat + "__" + uluru.lng)
							var container = document.getElementById('map');
							var options = {
								center: new kakao.maps.LatLng(uluru.lat, uluru.lng),
								level: 5
							};

							var map = new kakao.maps.Map(container, options);

					  	});

					} else {
						// Browser doesn't support Geolocation
						uluru = {lat: 37.5364270, lng: 127.1458950};

						//setMarkers(map, pos);
						$('#lat').val(uluru.lat);
						$('#lng').val(uluru.lng);
						// loadTabList(pos);
						//console.log(uluru.lat + "__" + uluru.lng)
						var container = document.getElementById('map');
						var options = {
							center: new kakao.maps.LatLng(uluru.lat, uluru.lng),
							level: 5
						};

						var map = new kakao.maps.Map(container, options);						
					}



				}

				$(function(){
					$("#search_text").keypress(function(e) {
						if(e.keyCode == 13) {
							e.preventDefault();
							textSearch();
						}
					});

					// 맵 숨김.
					//$('#map').hide(0)
				});
			</script>

			<!--
			<div class="page_title">
				<img src="/images/common/icon_map.png">
				<span>매장찾기</span>
			</div>
			-->

			<!-- 상단 검색 -->
			<div class="search_shop search-box inbox1000">
				<div class="clearfix">
					<span><img src="/images/common/icon_map.png" width="80%" height="80%"></span>
					<form class="form">
						<input type="hidden" name="lat" id="lat" value="">
						<input type="hidden" name="lng" id="lng" value="">
						<input type="hidden" name="dir_yn" id="dir_yn" value="<%=dir_yn%>">
						<input type="text" name="search_text" id="search_text" placeholder="어느 지역의 매장을 찾으세요?" value="<%=search_text%>">
						<button type="button" class="btn-sch" onclick="textSearch();"><img src="/images/order/btn_search.png" alt="검색"></button>
					</form>
				</div>
				<div class="searchDivBox">
					<!-- <p class="txt" style="width:82%">예) 서초동, 공장아파트, GS타워</p> -->
					<!--
					<p style="width:100%;text-align:center;padding-top:10px">
						<a href="/shop/shopLocation.asp?order_type=<%=request("order_type")%>&dir_yn=<%=request("dir_yn")%>">
						<span class="search_location"><img src="/images/order/icon_location.png"><span>위치 기반 매장 검색</span></span>
						</a>
					</p>
					-->
					<div class="searchWrap">
						<div class="searchDivImgWrap" onclick='location.href="/shop/shopLocation2.asp?order_type=<%=request("order_type")%>&dir_yn=<%=request("dir_yn")%>"'>
							<span class="searchImgSpan">
								<img src="/images/order/icon_location.png">
							</span>
							<span class="searchTextSpan">현위치 매장 검색</span>
						</div>
					</div>
				</div>
			</div>
			<!-- //상단 검색 -->

			<!-- 지도 출력 -->
			<div id="map" style="height:700px"></div>
			<!-- //지도 출력 -->

			<!-- 매장 롤링 -->
			<div class="find_shopRoll" id="shopArea1">

			</div>
			<!-- //매장 롤링 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

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

		initMap();
	</script>
	<!--<script src="https://maps.googleapis.com/maps/api/js?key=<%=GOOGLE_MAP_API_KEY%>&callback=initMap" async defer></script>-->

	<!-- Footer  -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


