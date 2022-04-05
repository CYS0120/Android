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
	Dim order_type : order_type = Request("order_type")
%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content inbox1000">

			<!--#include virtual="/includes/step.asp"-->

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

				var page = 1;
				var order_pageSize = 5;
				var g_map = "";
				var g_pos = "";

				function setMarkers(map, pos) {
//					console.log(map)
//					console.log(pos)
					g_map = map;
					g_pos = pos;

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
						url:'/api/ajax/shopListAllJs_page.asp',
						type:'POST',
						data:{"pageSize": order_pageSize, "curPage": page, "lat":pos.lat, "lng":pos.lng, "search_text":$('#search_text').val()},
						success:function(json) {
							 console.log(json);
							// console.log(json.length);

							z = order_pageSize*page;

							page++;

							if (json.length < order_pageSize) {
								$("#btn_more").hide();
							}

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
								
//								imgSrc = "/images/shop/ico_marker_bbq.png";

								// slideHtml1 += "<li id=\""+json[i].branch_id+"\" class=\"swiper-slide\"><a href=\"/shop/shopView.asp?branch_id="+json[i].branch_id+"\"><span>"+json[i].branch_name+"</span></a></li>\n";
								// slideHtml1 = '';

//								slideHtml1 +=			"<div class=\"box\" id=\""+json[i].branch_id+"\">";
//								slideHtml1 +=				"<dl class=\"in-sec\">";
//								slideHtml1 +=					"<dt><a href=\"./shopView.asp?branch_id="+json[i].branch_id+"\">"+Number(i+1)+". "+json[i].branch_name+"</a>";
//								if (json[i].yogiyo_yn == "Y")
//									slideHtml1 += "<p><span><img src='/images/shop/yogiyo_icon.png' class='yogiyo'></span>" ;
//								if (json[i].membership_yn_code == "50")
//									slideHtml1 += "<span><img src='/images/shop/mem_icon2.png' class='memicon'></span></p>" ;
//								slideHtml1 +=					"</dt>" ;
//								slideHtml1 +=					"<dd>";
//								slideHtml1 +=						"<p class=\"wrap\">";
//								slideHtml1 +=							"<span class=\"img\"><img src=\"http://placehold.it/130x130?text="+Number(i+1)+"\" alt=\"\"/></span>";
//								slideHtml1 +=							"<span class=\"info\">";
//								slideHtml1 +=								"<strong>"+json[i].branch_address+"</strong>";
//								slideHtml1 +=								"<strong>"+json[i].branch_tel+"</strong>";
//								slideHtml1 +=							"</span>";
//								slideHtml1 +=						"</p>";
//								slideHtml1 +=					"</dd>";
//								slideHtml1 +=				"</dl>";
//								slideHtml1 +=				"<div class=\"btn_wrap\">";
//								<% if dir_yn <> "Y" then %>
//								slideHtml1 +=						"<strong onclick=\"selectStore('"+ json[i].branch_id +"')\" class='btn-order2'>전화</strong><strong onclick=\"selectStore('"+ json[i].branch_id +"')\" class='btn-order2'>포장주문</strong>";
//								<% end if %>
//								slideHtml1 +=						"<input type='hidden' id='br_"+ json[i].branch_id +"' value='"+ JSON.stringify(json[i]) +"'>";
//								//slideHtml1 +=						"<a href=\"tel:"+json[i].branch_tel+"\"> </a>";
//								slideHtml1 +=				"</div>";
//								slideHtml1 +=			"</div>";
								// $('#shopArea1').append(slideHtml1);


								slideHtml1 += "<ul class='find_shop'>";
								slideHtml1 += "	<li><a href=\"javascript: selectStore('"+ json[i].branch_id +"')\" class='btn btn_middle btn-lightGray'>선택</a></li>";
								slideHtml1 += "	<li class='find_shop_1'>";
								slideHtml1 += "		<a href='/shop/shopView.asp?branch_id="+ json[i].branch_id +"' class='find_shop_name'>"+ json[i].branch_name +"</a> ";

								if (json[i].branch_type == "올리브카페")
									slideHtml1 += "		<a href='javascript: void(0)' class='btn btn-red btn_small4'>올리브카페</a>";

								slideHtml1 += "	</li>";

								slideHtml1 += "	<li class='find_shop_2'>";
								slideHtml1 += "		"+ json[i].branch_address +" ";

								if (json[i].membership_yn_code == "50")
									slideHtml1 += "		<a href='javascript: void(0)' class='btn btn-red btn_small4'>멤버십</a>";

								slideHtml1 += "	</li>";
								slideHtml1 += "	<li class='find_shop_3'>";
								slideHtml1 += "		"+ json[i].branch_tel +" ";
								slideHtml1 += "		<button type='button' id='btn_map' class='' onclick='show_map(\""+ z +"\", \""+ json[i].wgs84_y +"\", \""+ json[i].wgs84_x +"\")'><!-- <img src='/images/order/icon_map.png' alt='지도보기'> --></button>";
								slideHtml1 += "		<div id='mapWrap_"+ z +"' style='display: none;'>";
								slideHtml1 += "			<div id='map_"+ z +"' style='width:100%;height:350px;'></div>";
								slideHtml1 += "		</div>";
								slideHtml1 += "		<input type='hidden' id='br_"+ json[i].branch_id +"' value='"+ JSON.stringify(json[i]) +"'>";
								slideHtml1 += "	</li>";
								slideHtml1 += "</ul>";

								z++;
							}
							// if(slideHtml1 == "") slideHtml1 = "<li class=\"swiper-slide\"><span>해당 매장이 없습니다.</span></a></li>";
							$('#order_branch_list').append(slideHtml1);
							// $('#shop_cnt').html(i);

							//매장 하단 스와이프
							// $('.find_shopRoll').slick("unslick");
							$('.find_shopRoll').slick({
								centerMode: true,
								centerPadding: '30px',
								slidesToShow: 1,
								arrows: false
							});

						},
						error:function(xhr){}
					});
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
							console.log(res);

							//도서산간지역 2020-08-26
							getDeliveryShopInfo_hill(br_id);

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
												location.href="/menu/menuList.asp?order_type=<%=order_type%>";
											}
										}
									},
									error: function(xhr) {
										showAlertMsg({msg:"시스템 에러가 발생했습니다."});
									}
								});

							} else {
								var br_data = $("#br_"+br_id).attr("value");

								// sessionStorage.setItem("ss_branch_id", br_id);
								// sessionStorage.setItem("ss_branch_data", br_data);
								// sessionStorage.setItem("ss_order_type", "P");

								sessionStorage.removeItem("ss_addr_idx");
								sessionStorage.removeItem("ss_addr_data");

								showAlertMsg({msg:res.message, ok: function(){
									// location.href='/menu/menuList.asp?order_type=<%=order_type%>';
								}});
							}
						},
						error: function(xhr) {
							showAlertMsg({msg:"포장 매장을 다시 선택해주세요."});
						}
					});
				}

				function viewBranch(branch_no) {
					$('.find_shopRoll').slick('slickGoTo', branch_no);
				}

				function initMap() {

					var uluru = {lat: 37.491872, lng: 127.115922};

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
					  }, options);
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
							getAddr();
						}
					});
				});

				function getAddr(){
					if (document.deliverysearch_form.search_text.value == "") {
						alert("검색어를 입력해주시기 바랍니다.");
						return;
					}

					document.deliverysearch_form.submit()
				}
			</script>

			<!--
			<div class="page_title">
				<img src="/images/common/icon_map.png">
				<span>매장찾기</span>
			</div>
			-->


			<!-- 상단 검색 -->
			<div class="find_shopSearch search-box">
				<form class="form" id="deliverysearch_form" name="deliverysearch_form" action="delivery_P_list.asp">
					<input type="hidden" name="lat" id="lat" value="">
					<input type="hidden" name="lng" id="lng" value="">
					<input type="hidden" name="dir_yn" id="dir_yn" value="<%=dir_yn%>">
					<input type="text" name="search_text" id="search_text" placeholder="어느 지역의 매장을 찾으세요?" value="<%=search_text%>">
					<button type="button" class="btn-sch" onclick="getAddr()"><img src="/images/order/btn_search.png" alt="검색"></button>
				</form>

				<!-- <div><a href="/shop/shopLocation.asp?order_type=<%=order_type%>" class="btn btn-gray btn_middle"><img src="/images/order/icon_location.png"> 현 위치 기반 매장 검색</a></div> -->
			</div>
			<!-- //상단 검색 -->

			<!-- 지도 출력 -->
			<div id="map" style="display:none"></div>
			<!-- //지도 출력 -->

			<h3 class="subTitle mar-t50">
				최근 주문매장
			</h3>

			<div class="find_shop_wrap" id="order_branch_list"></div>


			<div class="reorder_wrap mar-t30">
				<div class="btn-wrap one mar-t20">
					<button type="button" id="btn_more" onclick="javascript: setMarkers(g_map, g_pos);" class="btn btn-grayLine btn_middle">더보기</button>
				</div>
			</div>


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->


	<!-- Footer  -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


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

<script type="text/javascript">
	function show_map(i, y, x)
	{
		$('#mapWrap_'+ i).toggle(0);

		var mapContainer = document.getElementById('map_'+ i), // 지도를 표시할 div 
		mapOption = { 
			center: new kakao.maps.LatLng(y, x), // 지도의 중심좌표
			level: 3 // 지도의 확대 레벨
		};

		// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
		var map = new kakao.maps.Map(mapContainer, mapOption); 

		// 마커가 표시될 위치입니다 
		var markerPosition  = new kakao.maps.LatLng(y, x); 

		// 마커를 생성합니다
		var marker = new kakao.maps.Marker({
			position: markerPosition
		});

		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);
	}
</script>