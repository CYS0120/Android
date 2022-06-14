<!--#include virtual="/api/include/utf8.asp"-->

<%
	order_type = GetReqStr("order_type","D")
	branch_id = GetReqStr("branch_id","")
	branch_data = GetReqStr("branch_data","")
	addr_idx = GetReqStr("addr_idx","")
	addr_data = GetReqStr("addr_data","")

	cancel_idx = GetReqStr("cancel_idx","")

	If order_type = "D" Or order_type = "R" Then
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
<!--#include virtual="/api/include/kakaomap.asp"-->



</head>

<body>

<div class="wrapper">
	<%
		PageTitle = "주문하기"
	%>
<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
<!--// Header -->

<!-- Container -->
<div class="h-container" style="padding-bottom: 80px !important;">
	<!-- Aside -->
	<!--#include virtual="/includes/aside.asp"-->
	<!--// Aside -->
	<!-- Content -->
	<article class="content inbox1000">
        <div class="topFixBanner">
		<form id="cart_form" name="cart_form" method="post" action="payment.asp">
			<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
			<input type="hidden" name="branch_id" id="branch_id" value="<%=branch_id%>">
			<input type="hidden" name="branch_data" id="branch_data" value='<%=branch_data%>'>
			<input type="hidden" name="addr_idx" id="addr_idx" value="<%=addr_idx%>">
			<input type="hidden" name="cart_value">
			<input type="hidden" name="addr_data" id="addr_data" value='<%=addr_data%>'>
			<input type="hidden" name="spent_time" id="spent_time">
		</form>

		<!-- 검색 -->
		<% if order_type = "D" Or order_type = "R" then %>
			<div class="find_shopSearch h-inbox1000">
				<form class="form" id="deliverysearch_form" name="deliverysearch_form" action="delivery_search.asp">
					<input type="hidden" name="lat" id="lat" value="">
					<input type="hidden" name="lng" id="lng" value="">
					<input type="hidden" name="dir_yn" id="dir_yn" value="<%=dir_yn%>">
					<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
					<input type="text" name="search_text" id="search_text" placeholder="주소 검색하여 배달지 추가">
					<button type="button" class="btn-sch" onclick="getAddr();"><img src="/images/order/btn_search.png" alt="검색"></button>
				</form>
                <form class="form" action="">
                    <a href="delivery_map.asp?order_type=<%=order_type%>">
					<input type="text" name="search_text" id="search_text" readonly placeholder="현 위치 기반 주소 검색">
					<button type="button" class="btn-sch"><img src="/images/common_new/icon_location.png" alt="검색"></button>
				    </a>
                </form>
				<!--//<div><a href="delivery_map.asp?order_type=<%=order_type%>" class="btn btn-gray btn_middle"><img src="/images/order/icon_location.png"> 현 위치 기반 주소 검색</a></div>-->
			</div>
		<% end if %>


		<% if order_type = "P" then %>
			<div class="find_shopSearch h-inbox1000">
				<form class="form" id="deliverysearch_form" name="deliverysearch_form" action="delivery_P_list.asp">
					<input type="hidden" name="lat" id="lat" value="">
					<input type="hidden" name="lng" id="lng" value="">
					<input type="hidden" name="dir_yn" id="dir_yn" value="<%=dir_yn%>">
					<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
					<input type="text" name="search_text" id="search_text" placeholder="주소 검색하여 매장명 검색">
					<button type="button" class="btn-sch" onclick="getAddr()"><img src="/images/order/btn_search.png" alt="검색"></button>
				</form>
                <form class="form" action="">
                    <a href="/shop/shopLocation.asp?order_type=<%=order_type%>">
					<input type="text" name="search_text" id="search_text" readonly placeholder="현 위치 기반 주소 검색">
					<button type="button" class="btn-sch"><img src="/images/common_new/icon_location.png" alt="검색"></button>
				    </a>
                </form>
				<!--//<div><a href="/shop/shopLocation.asp?order_type=<%=order_type%>" class="btn btn-gray btn_middle"><img src="/images/order/icon_location.png"> 현 위치 기반 매장 검색</a></div>-->
			</div>
		<% end if %>
        </div>
		<!-- // 검색 -->

		<input type="hidden" id="CART_IN_PRODIDX">

		<%If CheckLogin() Then%>

			<h3 class="subTitle">
				최근 주문매장
			</h3>

			<div class="find_shop_wrap" id="order_branch_list"></div>

			<div class="reorder_wrap mar-t30">
				<div class="btn-wrap one mar-t20 mar-b30">
					<button type="button" id="btn_more" onclick="javascript: <% if order_type = "D" then %>getOrderOldBranchList();<% end if %><% if order_type = "P" then %>getOrderBranchList();<% end if %>;" class="btn btn-grayLine btn_middle">더보기</button>
				</div>
			</div>
			<!-- // 매장리스트 -->
		<% else %>
			<div class="ta-c">
				<img src="/images/order/character-img.png" width="50%" height="50%">				
			</div>
			<div class="ta-c">
				<span>해당 내역이 없습니다.</span>
			</div>
		<% end if %>


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
			<input type="hidden" name="h_code" value=""> <!-- 행정동 코드 추가 (2022. 3. 22) -->
			<input type="hidden" name="mobile" value="">

			<div class="page_title">
				<img src="/images/order/icon_house.png">
				<span>배달지 찾기</span>
			</div>

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
								<dd>
									<div>
										<input type="text" name="zip_code" id="zip_code" maxlength="7" readonly onfocus="this.blur()" onClick="javascript:showPostcode();" style="width:100px;">
										<button type="button" onClick="javascript:showPostcode();" class="btn btn-sm btn-gray btn_post">우편번호 검색</button>
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
						<div class="btn-wrap two-up mar-t20">

							<button type="button" class="btn btn_middle btn-red" onclick="javascript:<% If CheckLogin() Then %>validAddress()<% Else %>validAddressNoMember()<% End If %>;">확인</button>
							<button type="button" onClick="javascript:lpClose('.lp_addShipping');" class="btn btn_middle btn-gray">취소</button>

						</div>
					</form>
				</div>
				<!--// LP Content -->
			</div>
			<!--// LP Container -->
		</div>
		<!--// Layer Popup -->

	</article>
	<!--// Content -->

</div>
<!--// Container -->








<!-- 
<% If Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" Then %>
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
<% Else %>
	<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js?autoload=false"></script>
<% End If %>
 -->

<script >
	// 20210427 수제맥주 관련 
	$(function(){
		// 배달은 맥주 관련 판매 안함!! 그래서 삭제..
		var len = sessionStorage.length;
		for(var i=0; i < len; i++) {
			var key = sessionStorage.key(i);
			if (sessionStorageException(key) == false) continue;
			// 맥주는 배달만. 가능..
			if (JSON.parse(sessionStorage.getItem(key)).kindSel == "115") {
				sessionStorage.removeItem(key);
			}														
		}
	});
</script>

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
				url: "/api/ajax/ajax_getShopNew.asp",
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
					showAlertMsg({msg:"배달지를 선택하세요."});
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
			case "R":
				if($("#addr_idx").val() == "") {
					showAlertMsg({msg:"배달지를 선택하세요."});
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

<script type="text/javascript">
	var temp_cnt = 0;

	$(function(){
		if (temp_cnt > 0) {
			$('#addr_btn').text('신규 배달지찾기');
			$('#near_store').show(0);
		}

//		after_control_new('<%=order_type%>'); // 시간 

	});

	function go_next_page()
	{
		var orderType_arr = document.getElementsByName("orderType");

		for (i=0; i<orderType_arr.length; i++)
		{
			if (orderType_arr[i].checked)
			{
				location.href='/order/delivery_search.asp?order_type=' + orderType_arr[i].value
			}
		}
	}

	function after_control_new(str)
	{
		if (str == "") {
			str = $("input[type=radio][name=orderType]:checked").val();
		}


		if (str == "P") {
			$('#orderType_img_D').prop('src', '/images/common/ui_radio_out.png');
			$('#orderType_img_P').prop('src', '/images/common/ui_radio_on.png');
			document.getElementById("order_type").value = "P";
			var after_arr = document.getElementsByName("after");

			for (i=0; i<after_arr.length; i++)
			{
				if (after_arr[i].checked)
				{
					document.getElementById("spent_time").value = after_arr[i].value;
				}
			}
		} else {
			$('#orderType_img_D').prop('src', '/images/common/ui_radio_on.png');
			$('#orderType_img_P').prop('src', '/images/common/ui_radio_out.png');
			document.getElementById("orderType_img_D").value = "D";
			document.getElementById("order_type").value = "D";
			document.getElementById("spent_time").value = "";
		}
	}

	function after_control()
	{
		if ($("input[type=radio][name=orderType]:checked").val() == "P") {
			document.getElementById("order_type").value = "P";
			var after_arr = document.getElementsByName("after");

			for (i=0; i<after_arr.length; i++)
			{
				if (after_arr[i].checked)
				{
					document.getElementById("spent_time").value = after_arr[i].value;
				}
			}
		} else {
			document.getElementById("order_type").value = "D";
			document.getElementById("spent_time").value = "";
		}
	}

	next_page_gubun = "";

	function addr_img_control(addr_idx)
	{
		next_page_gubun = "D";

		selectShipAddress_new(addr_idx);
	}
</script>






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
				getAddr();
			}
		});

//		initLoc();

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

			if (sessionStorageException(key) == false) continue;

            var it = JSON.parse(sessionStorage.getItem(key));
            cartprodidx += ','+it.idx;
		}
	}
    $("#CART_IN_PRODIDX").val(cartprodidx);
});
// 2019-05-23 이벤트로 인해 생성

function go_addr()
{
	adress_arr = document.getElementsByName("adress");

	for (i=0; i<adress_arr.length; i++)
	{
		if (adress_arr[i].checked) {
			selectShipAddress(adress_arr[i].value);
			return;
		}
	}

	alert("배달지를 선택하여 주십시오");
}

function getAddr(){
	if (document.deliverysearch_form.search_text.value == "") {
		alert("주소를 입력해주시기 바랍니다.");
		return;
	}

	document.deliverysearch_form.submit()
}
</script>


		<%If CheckLogin() Then%>

			<!-- 매장리스트 -->
			<script language="javascript">
				$(function (){
					$("#btn_map").click(function (){
						$("#mapWrap").toggle();
					});
				});
			</script>
			<!-- // 매장리스트 -->

			<script type="text/javascript">
				var page = 1;
				var order_pageSize = 5;

				$(function(){
					<% if order_type = "D" then %>
						getOrderOldBranchList();
					<% end if %>

					<% if order_type = "P" then %>
						getOrderBranchList();
					<% end if %>
				});


				next_page_gubun = "";

				function addr_img_control(addr_idx, br_id)
				{
					<% if order_type = "D" then %>
						next_page_gubun = "D";

						selectShipAddress_new(addr_idx);
					<% end if %>

					<% if order_type = "P" then %>
						getDeliveryShopInfo(br_id)
					<% end if %>
				}

				function go_next_page_map(t)
				{
					if($('#branch_id').val() == "") {
						alert("배달가능한 매장이 없습니다.");
					} else {

						br_id = $('#branch_id').val();
						br_data = $("#branch_data").val();

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

												sessionStorage.setItem("ss_branch_id", br_id);
												sessionStorage.setItem("ss_branch_data", br_data);

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

									sessionStorage.removeItem("ss_addr_idx");
									sessionStorage.removeItem("ss_addr_data");

									showAlertMsg({msg:res.message, ok: function(){
										//location.href='/menu/menuList.asp?order_type=<%=order_type%>';
									}});
								}
							},
							error: function(xhr) {
								showAlertMsg({msg:"포장 매장을 다시 선택해주세요."});
							}
						});
					}
				}

				 function getDeliveryShopInfo(br_id) {
					 $.ajax({
						 method: "post",
						 url: "/api/ajax/ajax_getStoreInfo_new.asp",
						 data: {branch_id: br_id},
						dataType: "json",
						 success: function(res) {
							if (res.BREAK_TIME != "0") {
								showAlertMsg({msg:"해당 매장이 주문이 밀려 주문이 어렵습니다. 잠시 후 다시 주문하여 주시기 바랍니다."});
							} else {
								$("#branch_data").val(JSON.stringify(res));
								$("#branch_id").val(res.branch_id);
								$("#branch_name").text(res.branch_name);
								
								// 제주도및 도서지역 2020-08-26 추가
								if(res.add_price_yn == "Y"){
									alert("제주도 및 도서지역은 상품에 따라 추가 금액이 발생될 수 있습니다.")
								}

								selectStore(br_id);
							}
						 }
					 });
				 }

				function selectStore(br_id) {
					// 다른 매장 선택시 장바구니 상품 제거.
					change_store_cart(br_id);

					br_id = $('#branch_id').val();
					br_data = $("#branch_data").val();

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
//											var br_data = $("#br_"+br_id).attr("value");
//											var branch_data = JSON.parse(br_data);

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

			</script>

		<% end if %>


<% If Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" Then %>
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
<% Else %>
	<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js?autoload=false"></script>
<% End If %>




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




	<!-- Footer -->
	<!--#include virtual="/includes/footer_new.asp"-->
	<!--// Footer -->
