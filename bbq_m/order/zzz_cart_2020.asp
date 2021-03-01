<!--#include virtual="/api/include/utf8.asp"-->

<%
	order_type = GetReqStr("order_type","")
	branch_id = GetReqStr("branch_id","")
	branch_data = GetReqStr("branch_data","")
	addr_idx = GetReqStr("addr_idx","")
	addr_data = GetReqStr("addr_data","")

	cancel_idx = GetReqStr("cancel_idx","")

	If order_type = "D" Then
		If addr_idx <> "" And addr_data <> "" Then
			Set aJson = JSON.Parse(addr_data)

			addr_idx = aJson.addr_idx
			address = aJson.address_main&" "&aJson.address_detail
			Set aJson = Nothing
		Else
			If CheckLogin() Then
				If addr_idx = "" Then addr_idx = 0

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

		If branch_data <> "" Then
			Set bJson = JSON.Parse(branch_data)
			branch_id = bJson.branch_id
			branch_name = bJson.branch_name
			branch_tel = bJson.branch_tel
			Set bJson = Nothing
		End If
	ElseIf order_type = "P" Then
		If branch_id <> "" And branch_data <> "" Then
			Set bJson = JSON.Parse(branch_data)
			branch_name = bJson.branch_name
			branch_tel = bJson.branch_tel
			address = bJson.branch_address
			Set bJson = Nothing
		End If
	End If

	ShowOrderType = False
	If (order_type = "D" AND addr_data = "") Or (order_type = "P" And branch_data = "") Then
		ShowOrderType = True
	End If
%>

<!doctype html>
<html lang="ko">

<head>
<!--#include virtual="/includes/top.asp"-->
<% If Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" Then %>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
<% Else %>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js?autoload=false"></script>
<% End If %>
<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
<script>
    // 우편번호 찾기 찾기 화면을 넣을 element
    var element_wrap = document.getElementById('wrap_daum');

    function foldDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
				$('#viewport').removeAttr('content','minimum-scale=1.0, width=750, maximum-scale=1.0, user-scalable=no');
				$('#viewport').attr('content','width=750, maximum-scale=1.0, user-scalable=no');
        document.getElementById('wrap_daum').style.display = 'none';
    }

    function showPostcode() {
        // 현재 scroll 위치를 저장해놓는다.
        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
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
				$('#viewport').removeAttr('content','minimum-scale=1.0, width=750, maximum-scale=1.0, user-scalable=no');
				$('#viewport').attr('content','width=750, maximum-scale=1.0, user-scalable=no');
				document.getElementById('wrap_daum').style.display = 'none';
            },
            // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
            onresize : function(size) {
                document.getElementById('wrap_daum').style.height = size.height+'px';
            },
            width : '100%',
            height : '100%'
        }).embed(document.getElementById('wrap_daum'));

		});
        // iframe을 넣은 element를 보이게 한다.
				document.getElementById('wrap_daum').style.display = 'block';
				$('#layer').css('z-index','999');
				$('#viewport').attr('content','minimum-scale=1.0, width=750, maximum-scale=1.0, user-scalable=no');
    }
</script>

<% Else %>

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
				}
			}).open();
		});
	}

</script>

<% End If %>

<script type="text/javascript">
	var delivery_amt = 0;
	var cartPage = "cart";
	$(function(){
		if($("#addr_data").val() != "" && $("#branch_data").val() == "") {
			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_getShop.asp",
				data:{dta:$("#addr_data").val()},
				dataType: "json",
				success: function(res) {
					if(res.result == "0000") {
						if(res.online_status != "Y") {
							showAlertMsg({msg:"선택하신 지역에 배달 가능한 매장이 일시적으로 영업을 하지 않습니다."});
							$("#branch_id").val("");
							$("#branch_data").val("");

							$("#branch_name").text("-");
							$("#branch_tel").text("");
						} else {
							$("#branch_id").val(res.branch_id);
							$("#branch_data").val(JSON.stringify(res));

							$("#branch_name").text(res.branch_name);
							$("#branch_tel").text("("+res.branch_tel+")");
						}
					} else {
						showAlertMsg({msg:res.message});
						$("#branch_id").val("");
						$("#branch_data").val("");

						$("#branch_name").text("-");
						$("#branch_tel").text("");
					}
				},
				error: function(xhr){
					showAlertMsg({msg:"배달가능한 매장이 없습니다."});
					$("#branch_id").val("");
					$("#branch_data").val("");

					$("#branch_name").text("-");
					$("#branch_tel").text("");
				}
			});
		}
		$("#delivery_fee").text(numberWithCommas(delivery_amt)+"원");
		getView();

		if($("#addr_idx").val() == "" && getTempAddress() != null) {
			setTempAddress();
		}

<%
	If ShowOrderType Then
%>
		lpOpen(".lp_orderShipping");
<%
	End If

	If cancel_idx <> "" And CheckLogin() Then
%>
	$.ajax({
		type: "post",
		url: "/order/order_membership_cancel.asp",
		data: {order_idx: "<%=cancel_idx%>"},
		dataType: "json",
		success: function(res) {
			if(res.result == 0) {
				showAlertMsg({msg:"멤버십사용이 취소되었습니다."});
			} else {
				showAlertMsg({msg:"멤버십사용이 취소되지 않았습니다."});
			}
		},
		error: function(xhr) {
			showAlertMsg({msg:"멤버십 사용이 정상적으로 취소되지 않았습니다."});
		}
	});
<%
	End If
%>

<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then %>
		//alert("-앱 주문시스템 긴급점검 안내-\n\n배달주문 고객분은\n모바일 웹을 이용해주세요.\nhttps://m.bbq.co.kr/\n이용에 불편을 드려 죄송합니다.");
		//return;
<% End If %>
	});

	function goOrder() {
		<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAAOS") > 0 Then %>
			alert("앱 주문 결제시스템 점검 중 입니다.\n\n현장결제를 택하시거나,\nm.bbq.co.kr로 주문결제 해주세요.\n\n이용에 불편을 드려 죄송합니다.");
			//return;
		<% End If %>
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
					showAlertMsg({msg:"포장가능한 매장이 없습니다."});
					return false;
				}
			break;
		}

		var cartV = getAllCartMenu();
		if(cartV.length == 0) {
			showAlertMsg({msg:"장바구니에 상품이 없습니다."});
			return;
		}

		$("#cart_form input[name=cart_value]").val(JSON.stringify(cartV));
		$("#cart_form").submit();
	}
</script>

</head>

<body>

<div class="wrapper">

<%
	PageTitle = "장바구니"
%>

	<!--#include virtual="/includes/header.asp"-->

<%
	If CheckLogin() And vAddrIdx <> "" Then
%>

	<script type="text/javascript">
		$(function(){
			selectShipAddress(<%=vAddrIdx%>);
		});
	</script>

<%
	End If
%>

<script type="text/javascript">
	function setScreen() {
		switch($("input[type=radio][name=orderType]:checked").val()) {
			case "D":
			$(".delivery-wrap").show();
			$(".pickup-wrap").hide();
			break;
			case "P":
			$(".delivery-wrap").hide();
			$(".pickup-wrap").show();
			break;
		}
	}

	function textSearch() {
		$.ajax({
			type: "post",
			url: "/api/ajax/shopListJs.asp",
			data:{"lat":$("#lat").val(),"lng":$("#lng").val(),"search_text":$.trim($("#search_text").val())},
			success: function(res){
				$("#search_store_list").html("");
				if(res.length > 0) {
				$.each(res, function(k,v){
					var shtml = "";

					shtml += "<div class=\"box\" id=\"br_"+v.branch_id+"\" value='"+JSON.stringify(v)+"'>\n";
					shtml += "\t<div class=\"name\">"+v.branch_name+"</div>\n";
					shtml += "\t<ul class=\"info\">\n";
					shtml += "\t\t<li>"+v.branch_tel+"</li>\n";
					shtml += "\t\t<li>"+v.branch_address+"</li>\n";
					shtml += "\t</ul>\n";
					shtml += "\t<ul class=\"btn-wrap\">\n";
					shtml += "\t\t<li>\n";
					shtml += "\t\t\t<button type=\"button\" onclick=\"selectStore('"+v.branch_id+"');\" class=\"btn btn-md btn-redLine w-100p btn-redChk\">선택</button>\n";
					shtml += "\t\t</li>\n";
					shtml += "\t</ul>\n";
					shtml += "</div>\n";

					$("#search_store_list").append(shtml);
				});
			}
			},
			error: function(xhr) {
				showAlertMsg({msg:xhr});
			}
		});
	}

	function selectStore(br_id) {
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

								$("#branch_id").val(br_id);
								$("#branch_data").val(br_data);
								$("#spent_time").val($(".pickup-wrap2 input[name=after]:checked").val());

								lpClose('.lp_shopSearch');
								setSelectedStore();
							}
						},
						error: function(xhr) {
							showAlertMsg({msg:"시스템 에러가 발생했습니다."});
						}
					});

				} else {
					showAlertMsg({msg:res.message});
				}
			},
			error: function(xhr) {
				showAlertMsg({msg:"포장 매장을 다시 선택해주세요."});
			}
		});
	}

	function setSelectedStore() {
		var branch_id = $("#branch_id").val();

		$("#selected_branch").html("<p class=\"explain\">포장 매장 찾기를 통해 포장가능한 매장을<br>선택해 주세요.</p>");

		if(branch_id != "") {
			var bd = JSON.parse($("#branch_data").val());

			$("#selected_branch").html("");

			var bhtml = "";
			bhtml += "<div class=\"box\">\n";
			bhtml += "\t<div class=\"name\">"+bd.branch_name+"</div>\n";
			bhtml += "\t<ul class=\"info\">\n";
			bhtml += "\t\t<li>"+bd.branch_tel+"</li>\n";
			bhtml += "\t\t<li>"+bd.branch_address+"</li>\n";
			bhtml += "\t</ul>\n";
			bhtml += "\t<ul class=\"btn-wrap\">\n";
			bhtml += "\t</ul>\n";
			bhtml += "</div>\n";
		
			$("#selected_branch").html(bhtml);

			lpClose('.lp_orderShipping');
			$("#order_type").val("P");

			$("#btn_order").show();
			setPickupAddress();
		}
	}

	function setPickupAddress() {
		setOrderTypeTitle();

		var bd = JSON.parse($("#branch_data").val());

		$("#branch_name").text(bd.branch_name);
		$("#branch_tel").text("("+bd.branch_tel+")");
		$("#ship_address").text(bd.branch_address);
	}

	function setOrderTypeTitle() {
		$("#btn_order").text("주문하기");
		switch($("#order_type").val()) {
			case "D":
			$("#order_type_title").text("배달매장 :");
			$("#address_title").text("배달주소 :");
			$("#btn_order").text("배달주문하기");
			break;
			case "P":
			$("#order_type_title").text("포장매장 :");
			$("#address_title").text("포장주소 :");
			$("#btn_order").text("포장주문하기");
			break;
		}
		chkOrderInfo();
	}

	function chkOrderInfo() {
		switch($("#order_type").val()) {
			case "D":
			if($("#branch_id").val() != "" && $("#branch_data").val() != "" && $("#addr_id").val() != "" && $("#addr_data").val() != "") {
				$("#btn_order").show();
			} else {
				$("#order_type_title").text("주문방법 및 주소지가 선택되지 않았습니다.");
				$("#branch_name").text("");
				$("#address_title").text("");
				$("#ship_address").text("");
				$("#btn_order").hide();
			}
			break;
			case "P":
			if($("#branch_id").val() != "" && $("#branch_data").val() != "") {
				$("#btn_order").show();
			} else {
				$("#order_type_title").text("주문방법 및 주소지가 선택되지 않았습니다.");
				$("#branch_name").text("");
				$("#address_title").text("");
				$("#ship_address").text("");
				$("#btn_order").hide();
			}
			break;
			default:
			$("#order_type_title").text("주문방법 및 주소지가 선택되지 않았습니다.");
			$("#branch_name").text("");
			$("#address_title").text("");
			$("#ship_address").text("");
			$("#btn_order").text("주문하기");
			$("#btn_order").hide();
			break;
		}
	}

	$(function(){
		$("#search_text").keypress(function(e){
			if(e.keyCode == 13) {
				e.preventDefault();
				textSearch();
			}
		});

		initLoc();

		setScreen();
		setOrderTypeTitle();
		
		var cV = getAllCartMenu();

		if(cV.length == 0) {
			$("#order_type_info").hide();
		}
	});

	function initLoc() {
		var uluru = {lat: 37.491872, lng: 127.115922};

		// Try HTML5 geolocation.
		if (navigator.geolocation) {
		  navigator.geolocation.getCurrentPosition(function(position) {
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
		  });
		} else {
		  	$('#lat').val(uluru.lat);
			$('#lng').val(uluru.lng);
			textSearch();
		}
	}

	function openOrderType() {
		var order_type = $("#order_type").val();

		if(order_type == "") order_type = "D";
		$(".lp_orderShipping input[name=orderType][value="+order_type+"]").prop("checked", true);
		setScreen();
		lpOpen(".lp_orderShipping");
	}

// 2019-05-23 이벤트로 인해 생성
$(function(){
    var len = getAllCartMenuCount();
	var cartprodidx = '';
    if(len == 0) {
    } else {
        for(var i = 0; i < len; i++) {
            var key = sessionStorage.key(i);
            if(key == ta_id) continue;
            var it = JSON.parse(sessionStorage.getItem(key));
            cartprodidx += ','+it.idx;
		}
	}
    $("#CART_IN_PRODIDX").val(cartprodidx);
});
// 2019-05-23 이벤트로 인해 생성
</script>

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">
			<form id="cart_form" name="cart_form" method="post" action="payment.asp">
				<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
				<input type="hidden" name="branch_id" id="branch_id" value="<%=branch_id%>">
				<input type="hidden" name="branch_data" id="branch_data" value='<%=branch_data%>'>
				<input type="hidden" name="addr_idx" id="addr_idx" value="<%=addr_idx%>">
				<input type="hidden" name="cart_value">
				<input type="hidden" name="addr_data" id="addr_data" value='<%=addr_data%>'>
				<input type="hidden" name="spent_time" id="spent_time">
			</form>

			<input type="hidden" id="CART_IN_PRODIDX">

			<!-- 상단 배달정보 -->
			<section class="section section_cartSum" id="order_type_info">
				<dl>
					<dt id="order_type_title">배달매장 :</dt>
					<dd><span class="red" id="branch_name"><%=vBranchName%></span> <em id="branch_tel"><%=vBranchTel%></em></dd>
				</dl>
				<dl class="address">
					<dt id="address_title">배달주소 :</dt>
					<dd><span class="txt_overflow" id="ship_address"><%=vAddress%></span> <button type="button" onclick="openOrderType();" class="btn btn-sm btn-grayLine btn_lp_open">변경</button></dd>
				</dl>
			</section>
			<!-- //상단 배달정보 -->

			<!-- 장바구니 리스트 -->
			<section class="section section_orderDetail pad-t0" id="cart_list">
				<!-- 
				<div class="mar-t40">
					<button type="button" class="btn btn-md btn-redLine w-100p">+ 다른 메뉴 추가하기</button>
				</div> 
				-->

				<div class="order_calc">
					<div class="top div-table mar-t30">
						<dl class="tr">
							<dt class="td">총 상품금액
							</dt><dd class="td" id="item_amount">0원</dd>
						</dl>
						<!-- <dl class="tr">
							<dt class="td">배달비
							</dt><dd class="td" id="delivery_fee">0원</dd>
						</dl> -->
					</div>
					<div class="bot div-table">
						<dl class="tr">
							<dt class="td">합계</dt>
							<dd class="td" id="total_amount">0<span>원</span></dd>
						</dl>
					</div>
				</div>
				
				<div class="mar-t40">
					<button type="button" onclick="location.href='/menu/menuList.asp';" class="btn btn-md btn-redLine w-100p">+ 메뉴 추가하기</button>
				</div>
				
				<%If CheckLogin() Then%> 
				<%	Else %>
				<div class="mar-t40">
					<button type="button"  onclick="openLogin('mobile');"  class="btn btn-lg btn-red w-100p"> 메뉴 주문하기 </button>
				</div>
				<%End If%>
				
				<div class="mar-t40">
					<button type="submit"<%If order_type = "" Then%> style="display: none;"<%End If%> class="btn btn-lg btn-red w-100p" onClick="javascript:goOrder();" id="btn_order"><%If order_type = "D" Then%>배달<%ElseIf order_type = "P" Then%>포장<%End If%>주문하기</button>
				</div>
			</section>
			<!-- //장바구니 리스트 -->


			<!-- Layer Popup : 배달지 입력 -->
			<div id="LP_orderShipping" class="lp-wrapper lp_orderShipping">
				<!-- LP Header -->
				<div class="lp-header">
					<h2>주문 방법 선택</h2>
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<form action="">

							<!-- 주문 타입 선택 -->
							<div class="inner">
								<ul class="order-moveType">
									<li>
										<label class="ui-radio" onclick="setScreen();">
											<input type="radio" name="orderType" value="D"<%If order_type = "D" Then%> checked="checked"<%End If%>>
											<span></span> 배달주문
										</label>
									</li>
									<li>	
										<label class="ui-radio" onclick="setScreen();">
											<input type="radio" name="orderType" value="P"<%If order_type = "P" Then%> checked="checked"<%End If%>>
											<span></span> 포장주문
										</label>
									</li>
								</ul>
							</div>
							<!-- //주문 타입 선택 -->

							<div class="delivery-wrap"<%If order_type = "P" Then%> style="display: none;"<%End If%>>
								<section class="section section_shipList mar-t40">

									<%
										Set aCmd = Server.CreateObject("ADODB.Command")
										With aCmd
											.ActiveConnection = dbconn
											.NamedParameters = True
											.CommandType = adCmdStoredProc
											.CommandText = "bp_member_addr_select"

											.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))

											Set aRs = .Execute
										End With
										Set aCmd = Nothing

										If Not (aRs.BOF Or aRs.EOF) Then
											aRs.MoveFirst
											Do Until aRs.EOF
									%>

									<div class="box">
										<div class="name">
											<%If aRs("is_main") = "Y" Then%><span class="red">[기본배달지]</span><%End If%> <%=aRs("addr_name")%>
										</div>
										<ul class="info">
											<li><%=aRs("mobile")%></li>
											<li>(<%=aRs("zip_code")%>) <%=aRs("address_main")&" "&aRs("address_detail")%></li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" onclick="selectShipAddress(<%=aRs("addr_idx")%>)" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
											</li>
										</ul>
									</div>

									<%
												aRs.MoveNext
											Loop
										End If
										Set aRs = Nothing
									%>

								</section>

								<div class="btn-wrap inner mar-t40">
									<button type="button" class="btn btn-lg btn-black w-100p" onclick="javascript:lpOpen('.lp_addShipping');">배달지 추가</button>
								</div>

								<div class="txt-basic inner mar-t20">
									- 배달지 관리는 마이페이지 &gt; 회원정보변경에서 확인하실 수 있습니다. 
								</div>
							</div>

							<!-- 포장주문 -->
							<div class="pickup-wrap pickup-wrap2 mar-t30 " style="display:none">
								<span class="txt">매장도착예정시간</span>
								<div class="orderType-radio orderType-radio2">
									<label class="ui-radio">
										<input type="radio" name="after" value="30" id="after30" checked="checked">
										<span></span> 30분 후
									</label>
									<label class="ui-radio">
										<input type="radio" name="after" value="45" id="after40">
										<span></span> 45분 후
									</label>
									<label class="ui-radio">
										<input type="radio" name="after" value="60" id="after50">
										<span></span> 60분 후
									</label>
									<label class="ui-radio">
										<input type="radio" name="after" value="90" id="after90">
										<span></span> 90분 후
									</label>
								</div>
								<div class="txt-basic inner mar-t20">
									최소 조리시간은 15분 입니다.
								</div>
							</div>
							<!--// 포장주문 -->

							<!--// 포장 주문 -->
							<div class="pickup-wrap"<%If order_type = "P" Then%> style="display:none"<%End If%>>
								<h4>포장 매장</h4>
								<section class="section section_shipList" id="selected_branch">
									<p class="explain">포장 매장 찾기를 통해 포장가능한 매장을<br>선택해 주세요.</p>
								</section>
								<div class="btn-wrap inner mar-t40">
									<button type="button"  onclick="javascript:lpOpen('.lp_shopSearch');" class="btn btn-lg btn-black w-100p btn_lp_open">포장 매장 찾기</button>
								</div>
							</div>
							<!--// 포장 주문 -->	
							
						</form>
					</div>
					<!--// LP Content -->
				</div>
				<!--// LP Container -->
				<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
			</div>
			<!--// Layer Popup -->

			<!-- Layer Popup : 배달지 입력 - 포장주문(매장찾기) -->
			<div id="LP_orderShipping" class="lp-wrapper lp_shopSearch">
				<!-- LP Header -->
				<div class="lp-header">
					<h2>매장 찾기</h2>
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<form action="">

							<!-- 검색 영역 -->
							<div class="inner">
								<div class="sch-wrap">
									<input type="hidden" id="lat">
									<input type="hidden" id="lng">
									<input type="text" class="sch-word" id="search_text">
									<button type="button" class="btn-sch" onclick="textSearch();"><img src="/images/order/btn_search.png" alt="검색"></button>
								</div>
							</div>
							<!-- //검색 영역 -->

							<!-- 매장 리스트 -->
							<div class="shop-listWrap">
								<section class="section section_shipList mar-t40" id="search_store_list">
									<div class="box">
										<div class="name">신대방 1점</div>
										<ul class="info">
											<li>010-1111-1111</li>
											<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
											</li>
										</ul>
									</div>
									<div class="box">
										<div class="name">가산디지털단지점(올리브카페)</div>
										<ul class="info">
											<li>010-1111-1111</li>
											<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
										</ul>
										<ul class="btn-wrap">
											<li>
												<button type="button" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
											</li>
										</ul>
									</div>
								</section>
							</div>
							<!--// 배달 주문 -->
						</form>
					</div>
					<!--// LP Content -->
				</div>
				<!--// LP Container -->
				<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
			</div>
			<!--// Layer Popup -->

			<!-- 메뉴 담기 -->
			<div class="menu-cart">
				<div class="sideMenu">

					<%
						Set aCmd = Server.CreateObject("ADODB.Command")

						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_sidemenu_select"

							Set aRs = .Execute
						End With

						Set aCmd = Nothing

						Dim category_name : category_name = ""

						If Not (aRs.BOF Or aRs.EOF) Then
							aRs.MoveFirst
							Do Until aRs.EOF
								thumb_file_path = aRs("thumb_file_path")
								thumb_file_name = aRs("thumb_file_name")
								If aRs("category_name") <> category_name Then
									If category_name <> "" Then
					%>
				</div>
			</div>

			<%
							End If
			%>

			<div class="wrap">
				<h3><%=aRs("category_name")%></h3>
				<div class="area">

					<%
							category_name = aRs("category_name")
						End If
					%>

					<div class="box" id="S_<%=aRs("menu_idx")%>_0" onclick="javascript:toggleCartSide('<%=menuKey%>', 'S$$<%=aRs("menu_idx")%>$$0$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$');">
						<div class="img">
							<label>
								<input type="checkbox">
								<img src="<%=SERVER_IMGPATH%><%=thumb_file_path%><%=thumb_file_name%>"/>
							</label>
						</div>
						<div class="info">
							<p class="name"><%=aRs("menu_name")%></p>
							<p class="pay"><%=FormatNumber(aRs("menu_price"),0)%>원</p>
						</div>
					</div>

					<%
								aRs.MoveNext
							Loop
					%>

				</div>
			</div>

			<%
				End If

				Set aRs = Nothing
			%>	
			
		</div>

				<div class="payment">
					<div class="addmenu">
					</div>
					<div class="calc">
						<div class="top">
							<dl>
								<dt>주문금액</dt>
								<dd id="sc_item_amount">0원</dd>
							</dl>
							<dl>
								<dt>추가금액</dt>
								<dd id="sc_side_amount">0원</dd>
							</dl>
						</div>
						<div class="bot">
							<dl>
								<dt>결제금액</dt>
								<dd id="sc_pay_amount">0원</dd>
							</dl>
						</div>
					</div>
				</div>

				<button type="button" class="btn_menu_close" onclick="javascript:closeSideChange();">닫기</button>
			</div>
			<!-- //메뉴 담기 -->

			<!-- 장바구니 담기 -->
			<div class="cart-fix on display-n" style="transition:0s;">
				<button type="button" class="btn btn-md btn-red btn_menu_cart" onclick="javascript:sideChangeApply();">장바구니 담기</button>
			</div>
			<!-- //장바구니 담기 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

</div>
<!-- Layer Popup : 배달지 입력 -->

<div id="LP_addShipping" class="lp-wrapper lp_addShipping" style="display:none;">
	<form id="form_addr" name="form_addr" method="post" onsubmit="return false;">
	<input type="hidden" name="addr_idx" value="">
	<input type="hidden" name="mode" value="I">
	<input type="hidden" name="addr_type" value="">
	<input type="hidden" name="address_jibun" value="">
	<input type="hidden" name="address_road" value="">
	<input type="hidden" name="sido" value="">
	<input type="hidden" name="sigungu" value="">
	<input type="hidden" name="sigungu_code" value="">
	<input type="hidden" name="roadname_code" value="">
	<input type="hidden" name="b_name" value="">
	<input type="hidden" name="b_code" value="">
	<input type="hidden" name="mobile" value="">

	<!-- LP Header -->
	<div class="lp-header">
		<h2>배달지 입력</h2>
	</div>
	<!--// LP Header -->

	<!-- LP Container -->
	<div class="lp-container">

		<!-- LP Content -->
		<div class="lp-content">
			<form action="">
				<div class="inner">
					<dl class="regForm hide">
						<dt>이름</dt>
						<dd>
							<input type="text" name="addr_name" class="w-100p">
						</dd>
					</dl>
					<dl class="regForm hide">
						<dt>전화번호</dt>
						<dd>
							<span class="ui-group-tel">
								<span><input type="text" name="mobile1" onlynum maxlength="3"></span>
								<span class="dash">-</span>
								<span><input type="text" name="mobile2" onlynum maxlength="4"></span>
								<span class="dash">-</span>
								<span><input type="text" name="mobile3" onlynum maxlength="4"></span>
							</span>
						</dd>
					</dl>
					<dl class="regForm">
						<dt><label for="zip_code">주소</label></dt>
						<dd>
							<div class="ui-input-post">
								<input type="text" name="zip_code" id="zip_code" maxlength="7" readonly onfocus="this.blur()" onClick="javascript:showPostcode();">
								<button type="button" onClick="javascript:showPostcode();" class="btn btn-md btn-gray btn_post"><span>우편번호 검색</span></button>
							</div>
							<div class="mar-t10"><input type="text" name="address_main" id="address_main" maxlength="100" readonly="" class="w-100p" onfocus="this.blur()" onClick="javascript:showPostcode();"></div>
							<div class="mar-t10"><input type="text" name="address_detail" maxlength="30" class="w-100p"></div>
						</dd>
					</dl>
				</div>
				<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
				<div id="wrap_daum"  class="daum_search" style="background:#fff;">
				<img class="search_close" src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" onclick="foldDaumPostcode()" alt="접기 버튼">
				</div>
				<% End If %>
				<div class="btn-wrap two-up inner mar-t80">
					<button type="button" class="btn btn-lg btn-black" onclick="javascript:<% If CheckLogin() Then %>validAddress()<% Else %>validAddressNoMember()<% End If %>;"><span>확인</span></button>
					<button type="button" onClick="javascript:lpClose('.lp_addShipping');" class="btn btn-lg btn-grayLine"><span>취소</span></button>
				</div>
			</form>
		</div>
		<!--// LP Content -->
	</div>
	<!--// LP Container -->
	<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
</div>
<!--// Layer Popup -->
