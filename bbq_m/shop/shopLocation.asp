<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/kakaomap.asp"-->
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

			<script type="text/javascript">
				var map;
				var markers = [];
				var image = [];
				var mapOption;
				var mapContainer;
				var br_ids = [];
				//var mapCustomOverlay = new kakao.maps.CustomOverlay({});
				var mapCustomOverlay = [];

				$(function(){
					$("#search_text").keypress(function(e){
						if(e.keyCode == 13) {
							e.preventDefault();
							textSearch();
						}
					});

					initLoc();

				});

				function clearMarkers() {
					setMapOnAll(null);
				}
				function setMapOnAll(map) {
					for (var i = 0; i < markers.length; i++) {
						markers[i].setMap(map);
					}
				}

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
					console.log(map)
					console.log(pos)
					var slideHtml = "";
					var imgSrc = "";
					var positions = [];
					br_ids = [];

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

					if (mapCustomOverlay != null){
						var i;
						for (i=0;i<mapCustomOverlay.length;i++){
							mapCustomOverlay[i].setMap(null);
						}
						mapCustomOverlay = [];
					}

					// image = {
					//   url: '/images/shop/ico_marker.png',
					//   size: new google.maps.Size(40, 45),
					//   scaledSize: new google.maps.Size(40, 45)
					// };

					$.ajax({
						url:'/api/ajax/shopListAllJs.asp',
						type:'POST',
						data:{"lat":pos.lat, "lng":pos.lng, "search_text":$('#search_text').val()},
						success:function(json) {
							// console.log(json);
							// console.log(json.length);

							clearMarkers() //기존마커삭제
							
							for(var i=0; i<json.length; i++) {
								// var marker = new google.maps.Marker({
								// 	position: new google.maps.LatLng(json[i].wgs84_y,json[i].wgs84_x),
								// 	map: map,
								// 	draggable: false,
								// 	//animation: google.maps.Animation.DROP,
								// 	icon: image,
								// 	no: i,
								// 	branch_id: json[i].branch_id,
								// 	// label: {text: ""+json[i].branch_name, color: "white"},
								// 	// label: {text: ""+Number(i+1), color: "white"},
								// 	label: {
								// 		text: ""+Number(i+1),
								// 		fontSize : '25px',
								// 		color: '#fff',
								// 		fontFamily : 'Roboto-Medium'
								// 	},

								// });
								
								// pos.push({
								// 	lat: json[i].wgs84_y,
								// 	lng: json[i].wgs84_x
								// });

								// displayMarker(new kakao.maps.LatLng(json[i].wgs84_y,json[i].wgs84_x),"");

								positions.push(new kakao.maps.LatLng(json[i].wgs84_y, json[i].wgs84_x));  // 마커의 위치

								//markers.push(marker);
								//var br_id = json[i].branch_id;
								//alert(json[i].branch_id)
								// marker.addListener('click', function() {
								// 	// lpOpen2(".lp-popShop");
								// 	viewBranch(this.no);
									
								// 	map.panTo(this.position);

								// 	// clearMarkers(map, (this.no + 1));
								// });

								// if(i == 0){
								// var center = new google.maps.LatLng(json[i].wgs84_y,json[i].wgs84_x);
								// map.panTo(center);
								br_ids[i] = json[i].branch_id;
								// }

								
								imgSrc = "/images/shop/ico_marker_bbq.png";

								// slideHtml1 += "<li id=\""+json[i].branch_id+"\" class=\"swiper-slide\"><a href=\"/shop/shopView.asp?branch_id="+json[i].branch_id+"\"><span>"+json[i].branch_name+"</span></a></li>\n";
								// slideHtml1 = '';

								slideHtml +=			"<div class=\"box swiviewbox swiview"+(i)+"\" id=\""+json[i].branch_id+"\" style=\"display:none\">";
								slideHtml +=				"<dl class=\"in-sec\">";
								slideHtml +=					"<dt  style='height:15px'><a href=\"./shopView.asp?branch_id="+json[i].branch_id+"\">"+Number(i+1)+". "+json[i].branch_name+"";
//								if (json[i].yogiyo_yn == "Y")
//									slideHtml1 += "<p><span><img src='/images/shop/yogiyo_icon.png' class='yogiyo'></span>" ;
								if (json[i].membership_yn_code == "50"){
									slideHtml += "<span class='floatR'><img src='/images/shop/mem_icon2.png' class='memicon'></span>" ;
								}
								slideHtml +=					"</a></dt>" ;
								slideHtml +=					"<dd>";
								slideHtml +=						"<p class=\"wrap\">";
								slideHtml +=							"<span class=\"img\"><img src=\"http://placehold.it/130x130?text="+Number(i+1)+"\" alt=\"\"/></span>";
								slideHtml +=							"<span class=\"info\">";
								slideHtml +=								"<strong>"+json[i].branch_address+"</strong>";
								slideHtml +=								"<strong>"+json[i].branch_tel+"</strong>";
								slideHtml +=							"</span>";
								slideHtml +=						"</p>";
								slideHtml +=					"</dd>";
								slideHtml +=				"</dl>";
								slideHtml +=				"<div class=\"btn_wrap\">";
								<% if dir_yn <> "Y" then %>
								slideHtml +=						"<strong onclick=\"telStore('"+ json[i].branch_tel +"')\" class='btn-order2'>전화</strong><strong onclick=\"selectStore('"+ json[i].branch_id +"')\" class='btn-order2'>포장주문</strong>";
								<% end if %>
								slideHtml +=						"<input type='hidden' id='br_"+ json[i].branch_id +"' value='"+ JSON.stringify(json[i]) +"'>";
								//slideHtml1 +=						"<a href=\"tel:"+json[i].branch_tel+"\"> </a>";
								slideHtml +=				"</div>";
								slideHtml +=			"</div>";
								// $('#shopArea1').append(slideHtml1);

							}
							// if(slideHtml1 == "") slideHtml1 = "<li class=\"swiper-slide\"><span>해당 매장이 없습니다.</span></a></li>";
							$('#shopArea1').html(slideHtml);
							// $('#shop_cnt').html(i);					
							
							// 맨 첫번째 매장 정보 Show
							$("#"+br_ids[0]).show();

							// 지도 위에 마커를 표시합니다
							for (var i = 0; i < positions.length; i++) {
								var gapX = (MARKER_WIDTH + SPRITE_GAP), // 스프라이트 이미지에서 마커로 사용할 이미지 X좌표 간격 값
									originY = (MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 기본, 클릭 마커로 사용할 Y좌표 값
									overOriginY = (OVER_MARKER_HEIGHT + SPRITE_GAP) * i, // 스프라이트 이미지에서 오버 마커로 사용할 Y좌표 값
									normalOrigin = new kakao.maps.Point(0, originY), // 스프라이트 이미지에서 기본 마커로 사용할 영역의 좌상단 좌표
									clickOrigin = new kakao.maps.Point(gapX, originY), // 스프라이트 이미지에서 마우스오버 마커로 사용할 영역의 좌상단 좌표
									overOrigin = new kakao.maps.Point(gapX * 2, overOriginY); // 스프라이트 이미지에서 클릭 마커로 사용할 영역의 좌상단 좌표

								// 커스텀 오버레이를 생성합니다
								mapCustomOverlay.push(
									new kakao.maps.CustomOverlay({
										map: map,
										position: positions[i],
										content: "<div onclick=\"overlayClickEvent("+i+");\"><span class='count' id='cart_item_count' style='position:absolute; border-radius:100%; background:#f20000; line-height:22px; color:#fff; font-family:\"Roboto-Bold\"; text-align:center; width:22px; height:22px; font-size:12px;'>"+(i+1)+"</span></div>",
										xAnchor: 0.5, // 커스텀 오버레이의 x축 위치입니다. 1에 가까울수록 왼쪽에 위치합니다. 기본값은 0.5 입니다
										yAnchor: 1.1 // 커스텀 오버레이의 y축 위치입니다. 1에 가까울수록 위쪽에 위치합니다. 기본값은 0.5 입니다
									})
								);

								// 커스텀 오버레이를 지도에 표시합니다
								mapCustomOverlay[i].setMap(map);								

								// 마커를 생성하고 지도위에 표시합니다
								//addMarker(positions[i], normalOrigin, overOrigin, clickOrigin, map);
							}

							// 맨 첫번째 매장위치 Show
							map.setCenter(new kakao.maps.LatLng(positions[0].getLat(), positions[0].getLng()));


							//매장 하단 스와이프
							// $('.find_shopRoll').slick("unslick");
							//$('.find_shopRoll').slick({
							//	centerMode: true,
							//	centerPadding: '30px',
							//	slidesToShow: 1,
							//	arrows: false,
							//	draggable : false
							//});
							
						},
						error:function(xhr){}
					});
				}

				// 지도에서 숫자 클릭했을때..
				function overlayClickEvent(idx){
					var i = 0;
					var cnt = br_ids.length;
					for (i;i<cnt;i++){
						$("#"+br_ids[i]).hide();
					}
					$("#"+br_ids[idx]).show();
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
												location.href="/menu/menuList.asp?order_type=<%=request("order_type")%>";
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
									location.href='/menu/menuList.asp?order_type=<%=request("order_type")%>';
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

				d_lat = "37.491872";
				d_lng = "127.115922";

				function initLoc() {
					var uluru = {lat: d_lat, lng: d_lng};
					var options = {
						enableHighAccuracy: false, //false 덜 정확하지만 빠름
						timeout: 1500,
						maximumAge: 0
					}

					// Try HTML5 geolocation.
					if (navigator.geolocation) {
					navigator.geolocation.watchPosition(function(position) { //getCurrentPosition -> watchPosition
						var pos = {
							lat: position.coords.latitude,
							lng: position.coords.longitude
						};

						$('#lat').val(pos.lat);
						$('#lng').val(pos.lng);
						// loadTabList(pos);
						textSearch();
					}, function() {
							$('#lat').val(uluru.lat);
							$('#lng').val(uluru.lng);
							textSearch();
					}, options);
					} else {
						$('#lat').val(uluru.lat);
						$('#lng').val(uluru.lng);
						textSearch();
					}
				}
				
				//특수문자, 특정문자열(sql예약어의 앞뒤공백포함) 제거
				function checkSearchedWord(obj){
					if(obj.value.length >0){
						//특수문자 제거
						var expText = /[%=><]/ ;
						if(expText.test(obj.value) == true){
							alert("특수문자를 입력 할수 없습니다.") ;
							obj.value = obj.value.split(expText).join(""); 
							return false;
						}
						
						//특정문자열(sql예약어의 앞뒤공백포함) 제거
						var sqlArray = new Array(
							//sql 예약어
							"OR", "SELECT", "INSERT", "DELETE", "UPDATE", "CREATE", "DROP", "EXEC",
									"UNION",  "FETCH", "DECLARE", "TRUNCATE" 
						);
						
						var regex;
						for(var i=0; i<sqlArray.length; i++){
							regex = new RegExp( sqlArray[i] ,"gi") ;
							
							if (regex.test(obj.value) ) {
								alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
								obj.value =obj.value.replace(regex, "");
								return false;
							}
						}
					}
					return true ;
				}

				function link_move() {
					$('html, body').scrollTop( $(document).height() );
				}

			</script>

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
						<div class="searchDivImgWrap" onclick='location.href="/shop/shopLocation.asp?order_type=<%=request("order_type")%>&dir_yn=<%=request("dir_yn")%>"'>
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
		mapContainer = document.getElementById('map'), // 지도를 표시할 div 

		mapOption = {
			center: new kakao.maps.LatLng(d_lat, d_lng), // 지도의 중심좌표
			level: 5 // 지도의 확대 레벨
		};  

		// 지도를 생성합니다    
		map = new kakao.maps.Map(mapContainer, mapOption); 
		
		function fnSearchDetailAddrFromCoords(locPosition){
			searchDetailAddrFromCoords(locPosition, function(result, status) {
				if (status === kakao.maps.services.Status.OK) {
					var detailAddr = !!result[0].road_address ? result[0].road_address.address_name: result[0].address.address_name;

					// 마커를 클릭한 위치에 표시합니다 
					//marker.setPosition(latlng);
					marker.setPosition(locPosition);
					marker.setMap(map);

					// 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
					//infowindow.setContent(content);
					//infowindow.open(map, marker);
				}   
			});			
		}

		// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
		if (navigator.geolocation) {
			
			var options = {
				enableHighAccuracy: false, //false 덜 정확하지만 빠름
				timeout: 1500,
				maximumAge: 0
			}
			// GeoLocation을 이용해서 접속 위치를 얻어옵니다
			navigator.geolocation.watchPosition(function(position) { //getCurrentPosition -> watchPosition
				
				var lat = position.coords.latitude, // 위도
					lon = position.coords.longitude; // 경도
				
				var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
					message = ''; // 인포윈도우에 표시될 내용입니다

				/********** 접속 위치 마커찍고 위치 이동인데.. 일단 주석 Start ****************/
				// 마커와 인포윈도우를 표시합니다
				//displayMarker(locPosition, message);

				//fnSearchDetailAddrFromCoords(locPosition);
				/********** 접속 위치 마커찍고 위치 이동인데.. 일단 주석 End ****************/
			}, function(){

				$( document ).ready(function() {
					var coord = new kakao.maps.LatLng(d_lat, d_lng);

					map.setCenter(coord);
				});

			}, options);
			
		} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
			
			var locPosition = new kakao.maps.LatLng(d_lat, d_lng),
				message = 'geolocation을 사용할수 없어요.'
			
			/********** 접속 위치 마커찍고 위치 이동인데.. 일단 주석 Start ****************/
			//displayMarker(locPosition, message);
			/********** 접속 위치 마커찍고 위치 이동인데.. 일단 주석 End ****************/
		}

		// 지도에 마커와 인포윈도우를 표시하는 함수입니다
		function displayMarker(locPosition, message) {

			// 마커를 생성합니다
			var marker = new kakao.maps.Marker({  
				map: map, 
				position: locPosition
			}); 
			
			var iwContent = message, // 인포윈도우에 표시할 내용
				iwRemoveable = true;

			// 인포윈도우를 생성합니다
			var infowindow = new kakao.maps.InfoWindow({
				content : iwContent,
				removable : iwRemoveable
			});
			
			// 인포윈도우를 마커위에 표시합니다 
			infowindow.open(map, "");
			
			// 지도 중심좌표를 접속위치로 변경합니다
			map.setCenter(locPosition);      
		}    

		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();

		var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
			infowindow = new kakao.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

		// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
		searchAddrFromCoords(map.getCenter(), displayCenterInfo);

		// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
		/*
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
			searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
				if (status === kakao.maps.services.Status.OK) {
					var detailAddr = !!result[0].road_address ? '<div>도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
					detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
					
					var content = '<div class="bAddr">' +
									'<span class="title">법정동 주소정보</span>' + 
									detailAddr + 
								'</div>';

					// 마커를 클릭한 위치에 표시합니다 
					marker.setPosition(mouseEvent.latLng);
					marker.setMap(map);

					// 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
					infowindow.setContent(content);
					infowindow.open(map, marker);
				}   
			});
		});
		*/

		// 마우스 드래그로 지도 이동이 완료되었을 때 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
		// kakao.maps.event.addListener(map, 'dragend', function() {        
			
		// 	// 지도 중심좌표를 얻어옵니다 
		// 	var latlng = map.getCenter(); 
		// //	console.log(latlng)
			
		// 	var message = '변경된 지도 중심좌표는 ' + latlng.getLat() + ' 이고, ';
		// 	message += '경도는 ' + latlng.getLng() + ' 입니다';
			
		// 	//var resultDiv = document.getElementById('result');  
		// 	//resultDiv.innerHTML = message;
			
		// 	fnSearchDetailAddrFromCoords(latlng);
			
		// });

		// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'idle', function() {
			searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		});

		function searchAddrFromCoords(coords, callback) {
			// 좌표로 행정동 주소 정보를 요청합니다
			geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
		}

		function searchDetailAddrFromCoords(coords, callback) {
			// 좌표로 법정동 상세 주소 정보를 요청합니다
			geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}

		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(result, status) {
			if (status === kakao.maps.services.Status.OK) {
				// var infoDiv = document.getElementById('address_main');

				// for(var i = 0; i < result.length; i++) {
				// 	// 행정동의 region_type 값은 'H' 이므로
				// 	//console.log('그런 너를 마주칠까 ' + result[0].address.address_name + '을 못가');
				// 	if (result[i].region_type === 'H') {
				// 		infoDiv.value = result[i].address_name;
				// 		break;
				// 	}
				// }
			}    
		}
	</script>

	<!-- Footer  -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


