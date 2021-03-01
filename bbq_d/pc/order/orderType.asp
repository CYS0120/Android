<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="주문 방법 선택, BBQ치킨">
<meta name="Description" content="주문 방법 선택 메인">
<title>주문 방법 선택 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});


	// $('.shop_sort .area').niceScroll({
	// 	cursorcolor: '#7d5405',
	// 	cursorborder: '0px solid #000',
	// 	scrollspeed: 150,
	// 	background: '#a76e00',
	// 	zindex: 999
	// });

	$(document).on('click', '.tab-type-shop a', function(e) {
		e.preventDefault();
		var i = $(this).index();
		$(this).addClass('on').siblings().removeClass('on');
		$('.shop_sort .area').eq(i).addClass('on').siblings().removeClass('on');
		$('.shop_sort .area').getNiceScroll().resize();
	});

	// $(document).on('click', '.orderType-radio .ui-radio:eq(0)', function(e) {
	// 	$(".section-item.item01").show();
	// 	$(".section-item.item02").hide();
	// 	$(".section-item.item03").hide();
	// });

	// $(document).on('click', '.orderType-radio .ui-radio:eq(1)', function(e) {
	// 	$(".section-item.item01").hide();
	// 	$(".section-item.item02").show();
	// 	$(".section-item.item03").hide();
	// });
	// $(document).on('click', '.lp_shopList .btn_lp_close', function(e) {
	// 	e.preventDefault();
	// 	$(".section-item.item01").hide();
	// 	$(".section-item.item02").hide();
	// 	$(".section-item.item03").show();
	// });

	// $(document).on("click", ".orderType-radio .ui-radio", function(e){
	// 	console.log($(this).index()+" clicked");
	// 	switch($(this).index()) {
	// 		case 0:
	// 		$(".section-item.item01").show();
	// 		$(".section-item.item02").hide();
	// 		break;
	// 		case 1:
	// 		$(".section-item.item01").hide();
	// 		$(".section-item.item02").show();
	// 		break;
	// 	}
	// });
});


function setScreen() {
	$("#order_type").val($("input[type=radio][name=orderType]:checked").val());
	switch($("#order_type").val()) {
		case "D":
			$(".section-item.item01").show();
			$(".section-item.item02").hide();
		break;
		case "P":
			$(".section-item.item01").hide();
			$(".section-item.item02").show();
		break;
	}
}
</script>
<%
	order_type = GetReqStr("order_type","D")
	branch_id = GetReqStr("branch_id", "")
	branch_data = GetReqStr("branch_data","")
	addr_idx = GetReqStr("addr_idx", "")
	addr_data = GetReqStr("addr_data", "")


	If order_type = "D" Then
		If addr_idx <> "" And addr_data <> "" Then
			Set aJson = JSON.Parse(addr_data)
			addr_idx = aJson.addr_idx
			address = aJson.address_main & " " & aJson.address_detail

			Set aJson = Nothing
		Else
			If addr_idx = "" Then
				If CheckLogin() Then addr_idx = 0
			End If

			If addr_idx <> "" Then
				Set aCmd = Server.CreateObject("ADODB.Command")

				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_member_addr_select"

					.Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)
					.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
					If addr_idx = 0 Then
						.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "MAIN")
					Else
						.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "ONE")
					End If

					Set aRs = .Execute
				End With
				Set aCmd = Nothing

				If Not (aRs.BOF Or aRs.EOF) Then
					addr_idx = aRs("addr_idx")
					address = aRs("address_main")&" "&aRs("address_detail")

					addr_data = AddressToJson(aRs)
				End If

				Set aRs = Nothing
			End If
		End If

		If branch_id <> "" Then
			Set aCmd = Server.CreateObject("ADODB.Command")
			With aCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_branch_select"

				.Parameters.Append .CreateParameter("@branch_id", adVarChar, adParamInput, 20, branch_id)

				Set aRs = .Execute
			End With
			Set aCmd = Nothing

			If Not (aRs.BOF Or aRs.EOF) Then
				vBranchName = aRs("branch_name")
				vBranchTel = aRs("branch_tel")
			End if

			Set aRs = Nothing
		End If
	End If

	If Not CheckLogin() Then
%>
	<script type="text/javascript">
		$(function(){
			setTempAddress();
		});
	</script>
<%
	End If
%>
<script type="text/javascript">
	function goOrder() {
		switch($("#order_type").val()) {
			case "D":
				if($("#addr_idx").val() == "") {
					showAlertMsg({msg:"배달주소를 선택하세요."});
					return false;
				}

				if($("#branch_id").val() == "") {
					showAlertMsg({msg:"배달가능한 매장이 없습니다."});
					return false;
				}
			break;
			case "P":
				if($("#branch_id").val() == "") {
					showAlertMsg({msg:"픽업 매장을 선택하세요."});
					return false;
				}
			break;
		}

		// var cartV = getAllCartMenu();
		// if(cartV.length == 0) {
		// 	showAlertMsg({msg:"장바구니에 상품이 없습니다."});
		// 	return false;
		// }
		// $("#cart_form input[name=cart_value]").val(JSON.stringify(cartV));
		// $("#cart_form").submit();

		$("#cart_form").attr("action", "cart.asp");
		$("#cart_form").submit();
	}
</script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
<script type="text/javascript">
	function showPostcode() {
		daum.postcode.load(function(){
			new daum.Postcode({
				oncomplete: function(data) {
					$("#address_main").val(data.userSelectedType == "J"? data.jibunAddress: data.roadAddress);

					$("#form_addr input[name=zip_code]").val(data.zonecode);
					$("#form_addr input[name=addr_type]").val(data.userSelectedType);
					$("#form_addr input[name=address_jibun]").val(data.jibunAddress);
					$("#form_addr input[name=address_road]").val(data.roadAddress);
					$("#form_addr input[name=sido]").val(data.sido);
					$("#form_addr input[name=sigungu]").val(data.sigungu);
					$("#form_addr input[name=sigungu_code]").val(data.sigunguCode);
					$("#form_addr input[name=roadname_code]").val(data.roadnameCode);
					$("#form_addr input[name=b_name]").val(data.bname);
					$("#form_addr input[name=b_code]").val(data.bcode);

					// findStore();
				}
			}).open();
		});
	}
</script>
<script type="text/javascript">
	var map;
	var markers = [];
	var image = [];

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


function setMarkers(map, pos) {
	var slideHtml = "";
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

	markers = [];
	$.ajax({
		url:'/api/ajax/shopListJs.asp',
		type:'POST',
		data:{"lat":pos.lat, "lng":pos.lng, "search_text":$('#search_text').val()},
		success:function(json) {
			// console.log(json);
			// console.log(json.length);
			// $("#store_count").text(json.length);
			for(var i=0; i<json.length; i++) {
				var marker = new google.maps.Marker({
					position: new google.maps.LatLng(json[i].wgs84_y,json[i].wgs84_x),
					map: map,
					draggable: false,
					//animation: google.maps.Animation.DROP,
					icon: image,
					no: i,
					data: json[i],
					// label: {text: ""+Number(i+1), color: "white"},
				});
				markers.push(marker);
				var br_id = json[i].branch_id;
				marker.addListener('click', function() {
					// lpOpen2(".lp-popShop");
					// viewBranch(br_id);
					branchSel($(this)[0].no, $(this)[0].data.branch_id);
					// map.panTo(this.position);

					// clearMarkers(map, (this.no + 1));
				});

				imgSrc = "/images/shop/ico_marker.png";

				slideHtml += "<a onmouseover=\"moveMap("+json[i].wgs84_y+","+json[i].wgs84_x+");\" href=\"javascript:branchSel("+i+",'"+json[i].branch_id+"');\" class=\"box\">\n";
				slideHtml += "\t<p class=\"subject\">"+json[i].branch_name+"</p>\n";
				slideHtml += "\t<p class=\"add\">"+json[i].branch_address+"</p>\n";
				slideHtml += "\t<p class=\"tel\">"+json[i].branch_tel+"</p>\n";
				slideHtml += "</a>\n";
			}
			if(slideHtml == "") slideHtml = "<li><a href=\"javascript:;\"><p class=\"txt\">해당 매장이 없습니다.</p></a></li>";
			$('#shopArea').html(slideHtml);

			// $('.shop_sort .area').niceScroll({
			// 	cursorcolor: '#7d5405',
			// 	cursorborder: '0px solid #000',
			// 	scrollspeed: 150,
			// 	background: '#a76e00',
			// 	zindex: 999
			// });

		},
		error:function(xhr){}
	});
}

function moveMap(x, y) {
	var pos = new google.maps.LatLng(x, y);
	map.panTo(pos);
}
//지도 높이 값 꽉 차게
function shopHeight(){
	$('#map').height(winH() - 211);
}
shopHeight();
$OBJ.win.on('load resize',function(){
	shopHeight();
});

function textSearch() {
	var pos = {
		lat: $("#lat").val(),
		lng: $("#lng").val()
	};

	setMarkers(map, pos);
}
</script>
<script type="text/javascript">
	function chkBranchSelect() {
		var bhtml = "";
		if($.trim($("#branch_id").val()) != "") {
			var bd = JSON.parse($("#branch_data").val());
			bhtml += "<td><strong class=\"red\">픽업 매장</strong></td>\n";
			bhtml += "<td>"+bd.branch_name+"</td>\n";
			bhtml += "<td>"+bd.branch_tel+"</td>\n";
			bhtml += "<td class=\"ta-l\">"+bd.branch_address+"</td>\n";
			bhtml += "<td><button type=\"button\" onclick=\"selectPickAddress('"+bd.branch_id+"');\" class=\"btn btn-sm btn-redLine\">선택</button></td>"

			$("#btn_store_search").text("픽업매장 재검색");
			$("#btn_pickup_order").show();
		} else {
			bhtml = "<td colspan=\"5\" class=\"noData\">픽업 매장 찾기를 통해 픽업가능한 매장을 선택해 주세요.</td>";

			$("#btn_store_search").text("픽업 매장 찾기");
			$("#btn_pickup_order").hide();
		}
		$("#selected_branch").html(bhtml);
	}

	function branchSel(idx, branch_id) {
		var d = markers[idx].data;

		if(d.branch_id == branch_id) {
			$("#branch_id").val(branch_id);
			$("#branch_data").val(JSON.stringify(d));
		}

		chkBranchSelect();
		lpClose(".lp_shopList");
	}

	$(function(){
		$("#search_text").keypress(function(e){
			if(e.keyCode == 13) {
				e.preventDefault();
				textSearch();
			}
		});
	});

	function selectPickAddress(branch_id) {
		if($("#branch_id").val() == branch_id) {
			$("#cart_form").attr("action", "cart.asp");
			$("#cart_form").submit();
		} else {
			showAlertMsg({msg:"픽업 매장을 다시 선택해주세요."});
		}
	}
	// function backCart() {
	// 	$("#cart_form").attr("action", "cart.asp");
	// 	$("#cart_form").submit();
	// }
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
			<form id="cart_form" name="cart_form" method="post">
				<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
				<input type="hidden" name="branch_id" id="branch_id" value="<%=branch_id%>">
				<input type="hidden" name="branch_data" id="branch_data" value='<%=branch_data%>'>
				<input type="hidden" name="addr_idx" id="addr_idx" value="<%=addr_idx%>">
				<input type="hidden" name="cart_value">
				<input type="hidden" name="addr_data" id="addr_data" value='<%=addr_data%>'>
			</form>
			<section class="section">
				<div class="section-header">
					<h3>주문 방법 선택 <span class="small">주문방법 선택 후 결제가 가능합니다</span></h3>
				</div>

				<div class="orderType-radio">
					<label class="ui-radio" onclick="setScreen();">
						<input type="radio" name="orderType" value="D"<%If order_type = "D" Then%> checked="checked"<%End If%>>
						<span></span> 배달주문
					</label>
					<label class="ui-radio" onclick="setScreen();">
						<input type="radio" name="orderType" value="P"<%If order_type = "P" Then%> checked="checked"<%End If%>>
						<span></span> 픽업주문
					</label>
				</div>

				<div class="section-item item01"<%If order_type = "P" Then%> style="display: none;"<%End If%>>
					<h4 class="mar-t60">주소지 관리</h4>
					<div class="boardList-wrap">
						<table border="1" cellspacing="0" class="tbl-list" id="address_list">
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
<%
	If CheckLogin() Then
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_member_addr_select"

			.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
			.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

			Set aRs = .Execute

			totalCount = .Parameters("@totalCount").Value
		End With
		Set aCmd = Nothing

		If Not (aRs.BOF Or aRs.EOF) Then
			aRs.MoveFirst

			Do Until aRs.EOF
%>
								<tr>
									<td><%If aRs("is_main") = "Y" Then%><strong class="red">기본주소지</strong><%End If%></td>
									<td><%=aRs("addr_name")%></td>
									<td><%=aRs("mobile")%></td>
									<td class="ta-l">
										(<%=aRs("zip_code")%>)<br>
										<%=aRs("address_main")&" "&aRs("address_detail")%>
									</td>
									<td>
										<button type="button" onclick="selectShipAddress(<%=aRs("addr_idx")%>);" class="btn btn-sm btn-redLine">선택</button>
									</td>
								</tr>
<%
				aRs.MoveNext
			Loop
		End If
		Set aRs = Nothing
	End If
%>
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
				<div class="section-item item02"<%If order_type = "D" Then%> style="display: none;"<%End If%>>
					<div class="boardList-wrap mar-t90">
						<table border="1" cellspacing="0" class="tbl-list">
							<caption>픽업주문</caption>
							<colgroup>
								<col style="width:120px;">
								<col style="width:120px;">
								<col style="width:180px;">
								<col>
								<col style="width:180px">
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th>매장명</th>
									<th>매장 전화번호</th>
									<th>매장주소</th>
									<th></th>
								</tr>
							</thead>
							<tbody>
								<tr id="selected_branch">
<%
	If branch_data = "" Then
%>									
									<td colspan="5" class="noData">픽업 매장 찾기를 통해 픽업가능한 매장을 선택해 주세요.</td>
<%
	Else
		Set bJson = JSON.Parse(branch_data)
%>
									<td>픽업매장</td>
									<td><%=bJson.branch_name%></td>
									<td><%=bJson.branch_tel%></td>
									<td><%=bJson.branch_address%></td>
									<td><button type="button" onclick="selectPickAddress(<%=bJson.branch_id%>);" class="btn btn-sm btn-redLine">선택</button></td>
<%
		Set bJson = Nothing
	End If
%>
								</tr>
							</tbody>
						</table>

						<div class="btn-wrap two-up inner mar-t60">
							<button type="button" class="btn btn-lg btn-black" onclick="lpOpen('.lp_shopList');"><span id="btn_store_search">픽업 매장 찾기</span></button>
							<!-- <button type="button" id="btn_pickup_order" style="display: none;" class="btn btn-lg btn-red"><span>주문서 작성</span></button> -->
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
										<form class="form" onsubmit="return false;">
											<h3>매장찾기</h3>
											<div class="shop_search">
												<input type="hidden" id="lat">
												<input type="hidden" id="lng">
												<input type="text" id="search_text">
												<button type="button" onclick="textSearch();"><img src="/images/shop/btn_shop_search.gif" alt="검색"></button>
											</div>
											<p class="ex">예)서초동,공장아파트,GS타워</p>
										</form>

										<div class="shop_sort">
											<div class="area">
												<div class="no_more"> 
													<span class="img"><img src="/images/shop/ico_shop_find.png" alt=""></span>
													<p class="txt">해당 검색어가 없습니다.</p>
												</div>
											</div>
											<div class="area on" id="shopArea"></div>
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
									<form id="form_addr" name="form_addr" method="post" onsubmit="return false;">
										<input type="hidden" name="addr_idx">
										<input type="hidden" name="mode" value="I">
										<input type="hidden" name="addr_type">
										<input type="hidden" name="address_jibun">
										<input type="hidden" name="address_road">
										<input type="hidden" name="sido">
										<input type="hidden" name="sigungu">
										<input type="hidden" name="sigungu_code">
										<input type="hidden" name="roadname_code">
										<input type="hidden" name="b_name">
										<input type="hidden" name="b_code">
										<input type="hidden" name="mobile">
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
														<input type="text" class="w-150" name="addr_name">
													</td>
												</tr>
												<tr>
													<th>전화번호</th>
													<td>
														<div class="ui-group-email">
															<span><input type="text" name="mobile1" maxlength="3"></span>
															<span class="dash w-20">-</span>
															<span><input type="text" name="mobile2" maxlength="4"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text" name="mobile3" maxlength="4"></span>
														</div>
													</td>
												</tr>
												<tr>
													<th>주소</th>
													<td>
														<div class="ui-input-post">
															<input type="text" name="zip_code" id="zip_code" maxlength="7" readonly>
															<button type="button" onclick="javascript:showPostcode();" class="btn btn-md2 btn-gray btn_post"><span>우편번호 검색</span></button>
														</div>
														<div class="mar-t10">
															<input type="text" class="w-100p" name="address_main" id="address_main" maxlength="100" readonly>
														</div>
														<div class="mar-t10">
															<input type="text" class="w-100p" name="address_detail" maxlength="100">
														</div>
													</td>
												</tr>
											</tbody>
										</table>

										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="button" onclick="javascript:validAddress();" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
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
	<script async defer src="https://maps.googleapis.com/maps/api/js?key=<%=GOOGLE_MAP_API_KEY%>&callback=initMap&region=kr"></script>
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
