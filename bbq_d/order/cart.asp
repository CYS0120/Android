<!--#include virtual="/api/include/utf8.asp"-->
<%
	order_type = GetReqStr("order_type", "")
	branch_id = GetReqStr("branch_id", "")
	branch_data = GetReqStr("branch_data", "")
	addr_idx = GetReqNum("addr_idx", "")
	addr_data = GetReqStr("addr_data", "")
	spent_time = GetReqStr("spent_time","")

	If order_type = "D" Then
		store_type_name = "배달매장"
		address_type_name = "배달주소"
	ElseIf order_type = "P" Then
		store_type_name = "포장매장"
		address_type_name = "매장주소"
	End If

	If order_type = "D" Then
		If addr_idx <> "" And addr_data <> "" Then
			Set aJson = JSON.Parse(addr_data)

			addr_idx = aJson.addr_idx
			address = aJson.address_main & " " & aJson.address_detail
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
					address = aRs("address_main") & " " & aRs("address_detail")
					
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
	'배달매장 있는지 확인'
		If branch_id <> "" And branch_data <> "" Then
			Set bJson = JSON.parse(branch_data)
				branch_name = bJson.branch_name
				branch_tel = bJson.branch_tel
				address = bJson.branch_address
			Set bJson = Nothing
		End If
	ENd If

%>
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="장바구니, BBQ치킨">
<meta name="Description" content="장바구니 메인">
<title>장바구니 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});
});
</script>
<script type="text/javascript">
	var delivery_amt = 0;
	var cartPage = "cart";
	$(function(){
		if($("#addr_data").val() != "" && $("#branch_data").val() == "") {
			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_getShop.asp",
				data: {data: $("#addr_data").val()},
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
				error: function(xhr) {
					showAlertMsg({msg:"배달가능한 매장이 없습니다."});
					$("#branch_id").val("");
					$("#branch_data").val("");

					$("#branch_name").text("-");
					$("#branch_tel").text("");
				}
			});
		}
//		$("#delivery_fee").text(numberWithCommas(delivery_amt)+"원");
		getView();
	});

	function goOrder() {
		switch($("#order_type").val()) {
			case "D":
			if($("#addr_idx").val() == "" || $("#addr_data").val() == "") {
				showAlertMsg({msg:"배송지를 선택하셔야 합니다."});
				return false;
			}
			if($("#branch_id").val() == "" || $("#branch_data").val() == "") {
				showAlertMsg({msg:"배달 가능한 매장이 선택되지 않았습니다."});
				return false;
			}
			break;
			case "P":
			if($("#branch_id").val() == "" || $("#branch_data").val() == "") {
				showAlertMsg({msg:"포장 가능한 매장이 선택되지 않았습니다."});
			}
			break;
		}
		var cartV = getAllCartMenu();
		if(cartV.length == 0) {
			showAlertMsg({msg:"장바구니에 상품이 없습니다."});
			return;
		}

		$("#cart_form input[name=cart_value]").val(JSON.stringify(cartV));
		// location.href = "orderType.asp";
		$("#cart_form").attr("action", "order.asp");
		$("#cart_form").submit();
	}

	function checkAll(obj) {
		$("#cart_list :checkbox").prop("checked", $(obj).is(":checked"));
	}

	function deleteAll() {
		if(supportStorage()) {
			if($("#cart_list :checkbox").length == 0) {
				showAlertMsg({msg:"삭제할 상품이 없습니다."});
				return;
			}
			showConfirmMsg({msg:"모든 상품을 삭제하시겠습니까?", ok: function(){
				sessionStorage.clear();
				getView();
				lpClose("#lp_confirm");
				$("#btn_order").parent().hide();
			}});
		}
	}

	function deleteChecked() {
		if(supportStorage()) {
			if($("#cart_list :checkbox:checked").length == 0) {
				showAlertMsg({msg:"삭제할 상품이 없습니다."});
				return;
			}
			showConfirmMsg({msg:"선택된 상품을 삭제하시겠습니까?", ok: function(){
				$.each($("#cart_list :checkbox:checked"), function(k,v) {
					sessionStorage.removeItem($(v).val());
					getView();
				});
				if(getAllCartMenuCount() == 0) {
					$("#btn_order").parent().hide();
				}
				lpClose("#lp_confirm");
			}});
		}
	}

	function changeOrderType() {
		$("#cart_form").attr("action", "orderType.asp");
		$("#cart_form").submit();
	}
</script>

</head>
<%
	Dim aCmd, aRs
%>
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
				<input type="hidden" name="spent_time" value="<%=spent_time%>">
			</form>
			<!-- 주문단계 -->
			<section class="section section-orderStep">
				<ul>
					<li class="step1 on"><span>01 장바구니</span></li>
					<li class="step2"><span>02 주문/결제</span></li>
					<li class="step3"><span>03 주문완료</span></li>
				</ul>
			</section>
			<!-- //주문단계 -->

			<h1>장바구니</h1>
			<!-- 상단 배달정보 -->
			<section class="section section_cartSum" id="order_type_info">
				<ul>
<%
	If order_type <> "" Then
%>
					<li>
						<strong><%=store_type_name%> :</strong>
						<span class="red" id="branch_name"><%=branch_name%></span>
						<span id="branch_tel">(<%=branch_tel%>)</span>
					</li>
					<!-- <li>
						<strong>배달비 :</strong>
						<span id="delivery_free">0원</span>
					</li> -->
					<li>
						<strong><%=address_type_name%> :</strong>
						<span><%=address%></span>
					</li>
				</ul>
				<a href="javascript:changeOrderType();" class="btn btn-sm btn-red">주문방법변경</a>
<%
	Else
%>
					<li>주문방법 및 주소지가 선택되지 않았습니다.</li>
				</ul>
				<a href="javascript:changeOrderType();" class="btn btn-sm btn-red">주문방법선택</a>
<%
	End If
%>
			</section>
			<!-- //상단 배달정보 -->

			<!-- 장바구니 테이블 -->
			<table border="1" cellspacing="0" class="tbl-cart">
				<caption>장바구니</caption>
				<colgroup>
					<col style="width:50px;">
					<col style="width:141px;">
					<col>
					<col style="width:200px;">
					<col style="width:180px;">
				</colgroup>
				<thead>
					<tr>
						<th><label class="ui-checkbox no-txt"><input type="checkbox" onclick="javascript:checkAll(this);"><span></span></label></th>
						<th colspan="2">상품정보</th>
						<th>상품금액</th>
						<th>변경</th>
					</tr>
				</thead>
				<tbody id="cart_list">
				</tbody>
			</table>
			<!-- //장바구니 테이블 -->

			<!-- 장바구니 하단 정보 -->
			<div class="cart-botInfo div-table">
				<div class="tr">
					<div class="td lef">
						<button type="button" onclick="javascript:deleteChecked();" class="btn btn-sm btn-grayLine">선택삭제</button>
						<button type="button" onclick="javascript:deleteAll();" class="btn btn-sm btn-grayLine">전체삭제</button>
					</div>
					<div class="td rig">
						<!-- <span>총 상품금액</span>
						<strong id="item_amount">0</strong>
						<span>원</span>
						<em><img src="/images/mypage/ico_calc_plus.png" alt=""></em>
						<span>배달비</span>
						<strong id="delivery_fee">0</strong>
						<span>원</span>
						<em><img src="/images/mypage/ico_calc_equal.png" alt=""></em> -->
						<span>합계</span>
						<strong class="red" id="total_amount">0</strong>
						<span>원</span>
					</div>
				</div>
			</div>
			<!-- //장바구니 하단 정보 -->

			<div class="btn-wrap two-up inner mar-t60">
				<a href="/menu/menuList.asp" class="btn btn-lg btn-redLine"><span>메뉴 추가하기</span></a>
				<button type="button"<%If order_type = "" Then%> style="display:none;"<%End If%> class="btn btn-lg btn-red" onclick="javascript:goOrder();"><span id="btn_order"><%If order_type = "D" Then%>배달<%ElseIf order_type = "P" Then%>포장<%End If%>주문하기</span></button>
				
				<%If CheckLogin() Then%> 
				<%	Else %>
					<a href="javascript:openLogin();" class="btn btn-lg btn-redLine"><span> 메뉴 주문하기 </span></a>
				<%End If%>
			</div>

			<!-- Layer Popup : Member Secssion -->
			<div id="lp_sideChange" class="lp-wrapper lp_sideChange">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>사이드 변경</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">

								<div class="menu-cart">
									<div class="inner">
										<div class="left mCustomScrollbar">

											<div class="in-sec">
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
														<div class="box">
															<div class="img">
																<label class="ui-checkbox" id="S_<%=aRs("menu_idx")%>_0" onclick="javascript:toggleCartSide('', 'S$$<%=aRs("menu_idx")%>$$0$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$');">
																	<input type="checkbox">
																	<span></span>
																</label>
																<img src="<%=SERVER_IMGPATH%><%=thumb_file_path%><%=thumb_file_name%>"/>
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
										</div>
										<div class="right">
											<div class="addmenu mCustomScrollbar">
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
														<dd id="sc_total_amount">0원</dd>
													</dl>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="btn-wrap two-up mar-t30">
									<button type="button" class="btn btn-lg btn-red" onclick="javascript:sideChangeApply();"><span>변경</span></button>
									<button type="button" class="btn btn-lg btn-grayLine" onclick="javascript:closeSideChange();"><span>취소</span></button>
								</div>

							</div>
							<!--// LP Content -->
						</div>
						<!--// LP Container -->
						<button type="button" class="btn btn_lp_close" onclick="javascript:closeSideChange();"><span>레이어팝업 닫기</span></button>
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
</body>
</html>
