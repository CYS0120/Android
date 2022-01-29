<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">

<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="주문상세, BBQ치킨">
<meta name="Description" content="주문상세">
<title>주문상세 | BBQ치킨</title>
</head>

<%
	cmobile = GetReqStr("cmobile","")
	order_num = GetReqStr("onum","")
	order_idx = GetReqStr("oidx","")
	rtnUrl = GetReqStr("rtnUrl","")
	curPage = GetReqNum("gotoPage",1)

	If order_idx = "" Then
%>

<script type="text/javascript">
	alert("잘못된 접근입니다.");
	history.back();
</script>

<%
		Response.End
	End If
	If CheckLogin() Then
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_select_one_member"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
			.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_num)
			.Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))

			Set aRs = .Execute
		End With
		Set aCmd = Nothing
	Else
		If FncIsBlank(Session("ORDER_NOMEMBERHP")) Then 
%>

<script type="text/javascript">
	alert("잘못된 접근입니다.");
	history.back();
</script>

<%
			Response.End
		End If 
		Set aCmd = Server.CreateObject("ADODB.Command")
		With aCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_select_one_nomember"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
			.Parameters.Append .CreateParameter("@order_num", adVarChar, adParamInput, 50, order_num)
			.Parameters.Append .CreateParameter("@nomember_hp", adVarChar, adParamInput, 20, Session("ORDER_NOMEMBERHP"))

			Set aRs = .Execute
		End With
		Set aCmd = Nothing
	End If 

	If Not (aRs.BOF Or aRs.EOF) Then
		order_idx = aRs("order_idx")
		branch_id = aRs("branch_id")
		vOrderNum = aRs("order_num")
		vOrderDate = aRs("order_date")
		vBrandCode = aRs("brand_code")
		vBrandName = aRs("brand_name")
		vOrderType = aRs("order_type")
		vOrderTypeName = aRs("order_type_name")
		vPayType = aRs("pay_type")
		vPayTypeName = aRs("pay_type_name")
		vOrderStatus = aRs("order_status")
		vOrderStatusName = aRs("order_status_name")
		vOrderAmt = aRs("order_amt")
		vDeliveryFee = aRs("delivery_fee")
		vDiscountAmt = aRs("discount_amt")
		vPayAmt = aRs("pay_amt")
		vDeliveryMessage = aRs("delivery_message")
		addr_idx = aRs("addr_idx")

		vBranchName = aRs("branch_name")
		vBranchTel = aRs("branch_tel")

		vAddressName = aRs("addr_name")

		vDelivery_time = aRs("DELIVERYTIME")

		vMobile = aRs("delivery_mobile")
		vZipCode = aRs("delivery_zipcode")
		vAddress = aRs("delivery_address")&" "&aRs("delivery_address_detail")
		delivery_time = aRs("delivery_time")

		vOrderStatus_chk = ""
		if vOrderStatusName <> "취소요청" and vOrderStatusName <> "취소완료" then 
			if vOrderStatus = "P" then 
'				vOrderStatus_chk = "Y" 
				vOrderStatus_chk = "" ' 페이코 에러로 고객취소 로직 막음.
			end if 
		end if 
	Else
%>

<script type="text/javascript">
	alert("주문내역이 없습니다.");
	history.back();
</script>

<%
		Response.End
	End If

	If vOrderType = "D" Then
		order_type_title = "배달정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
	ElseIf vOrderType = "P" Then
		order_type_title = "포장정보"
		order_type_name = "포장매장"
		address_title = "포장매장 주소"
	ElseIf vOrderType = "R" Then
		order_type_title = "예약정보"
		order_type_name = "배달매장"
		address_title = "배달주소"
	End If

	Select Case vPayType
		Case "Card":
		pay_type_title = "온라인결제"
		pay_type_name = "신용카드"
		Case "Phone":
		pay_type_title = "온라인결제"
		pay_type_name = "휴대전화 결제"
		Case "Point":
		pay_type_title = "온라인결제"
		pay_type_name = "포인트"
		Case "Later":
		pay_type_title = "현장결제"
		pay_type_name = "신용카드"
		Case "Cash":
		pay_type_title = "현장결제"
		pay_type_name = "현금"
		Case "Payco":
		pay_type_title = "페이코"
		pay_type_name = "간편결제"
		Case "Paycoin":
		pay_type_title = "페이코인"
		pay_type_name = "간편결제"
		Case "OFF":
		pay_type_title = "현장결제"
		pay_type_name = "현장결제"
	End Select
%>

<%
	PageTitle = "최근 주문"
%>

<body>

<div class="wrapper">
	<!--#include virtual="/includes/header.asp"-->


	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content inbox1000" >

			<!--#include virtual="/mypage/orderView_content.asp"-->
				
				<div class="reorder_view_btn">
					<a href="javascript: void(0)" onclick="result_order('<%=order_idx%>')" class="btn btn-gray btn_middle"><img src="/images/common/btn_cart.png"> 담기</a>
					<a href="javascript: void(0)" onclick="reOrder('<%=order_idx%>', '<%=vOrderType%>')" class="btn btn-red btn_middle">재주문</a>
					<%
						If rtnUrl <> "" Then
					%>
						<a href="<%=rtnUrl%>" class="btn-gray btn_middle" <% if vOrderStatus_chk <> "Y" then ' 고객주문접수 %> style="width:100%;" <% end if %>>목록</a>
					<%
						Else
							If CheckLogin() Then
					%>
						<a href="/mypage/orderList.asp?gotopage=<%=gotopage%>" class="btn-gray btn_middle" <% if vOrderStatus_chk <> "Y" then ' 고객주문접수 %> style="width:100%;" <% end if %>>목록</a>
					<%
							Else
					%>
						<a href="/mypage/orderListNonMem.asp?gotopage=<%=gotopage%>" class="btn-gray btn_middle" <% if vOrderStatus_chk <> "Y" then ' 고객주문접수 %> style="width:100%;" <% end if %>>목록</a>
					<%
							End If
						End if
					%>

					<% if vOrderStatus_chk = "Y" then ' 고객주문접수 %>
						<a href="javascript: void(0)" onclick="CheckInput()" class="btn-red btn_middle">결제 취소</a>
						<!-- <a href="javascript: void(0)" onclick="location.href='/order/orderCancel.asp'" class="btn-red btn_middle">결제 취소</a> -->
					<% end if %>
				</div>

				<div class="order_CompleteTxt2">
					<p>
						문의는 콜센터<strong>(1588-9282)</strong>로 연락 바랍니다.
					</p>
				</div>


			</div>

		</article>
		<!--// Content -->


		<script type="text/javascript">
			var checkClick = 0;

			function CheckInput()
			{
				if ( checkClick == 1 ) {
					alert('등록중입니다. 잠시 기다려 주시기 바랍니다.');
					return;
				}

				if (confirm("정말로 취소하시겠습니까?.\n취소된 주문건은 복구가 불가능합니다"))
				{
					checkClick = 1;

					$.ajax({
						async: false,
						type: "POST",
						url: "orderView_cancel.asp",
						data: $("#inputfrm").serialize(),
						dataType : "text",
						success: function(data) {
							if (data.split("^")[0] == "Y") {
								location.href = "/order/orderCancel.asp?oidx=<%=order_idx%>";
//								alert("결제 취소 되었습니다");
//								document.location.reload();
							}else{
								checkClick = 0;
								showAlertMsg({msg:data.split("^")[1]});
							}
						},
						error: function(data, status, err) {
							checkClick = 0;
							showAlertMsg({msg:err + ' 서버와의 통신이 실패했습니다.'});
						}
					});
				}
			}
		</script>

		<form id="inputfrm" name="inputfrm">
			<input type="hidden" name="orderid" value="<%=vOrderNum%>">
			<input type="hidden" name="cms_type" value="USER"><% ' 별 의미없는듯? %>
			<input type="hidden" name="proc" value="C">
		</form>

		<input type="hidden" name="ol_order_idx_<%=order_idx%>" id="ol_order_idx_<%=order_idx%>" value="<%=order_idx%>">
		<input type="hidden" name="ol_addr_idx_<%=order_idx%>" id="ol_addr_idx_<%=order_idx%>" value="<%=addr_idx%>">
		<input type="hidden" name="ol_branch_id_<%=order_idx%>" id="ol_branch_id_<%=order_idx%>" value="<%=branch_id%>">


		<article class="content">
			<form id="cart_form" name="cart_form" method="post" action="payment.asp" >
				<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
				<input type="hidden" name="branch_id" id="branch_id" value="<%=branch_id%>">
				<input type="hidden" name="branch_data" id="branch_data" value='<%=branch_data%>'>
				<input type="hidden" name="addr_idx" id="addr_idx" value="<%=addr_idx%>">
				<input type="hidden" name="cart_value">
				<input type="hidden" name="addr_data" id="addr_data" value='<%=addr_data%>'>
				<input type="hidden" name="spent_time" id="spent_time">
			</form>

			<form id="form_addr" name="form_addr" method="post" onsubmit="return false;" >
				<input type="hidden" name="addr_idx">
				<input type="hidden" name="mode" value="">
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

				<input type="hidden" name="addr_name">
				<input type="hidden" name="mobile1">
				<input type="hidden" name="mobile2">
				<input type="hidden" name="mobile3">
				<input type="hidden" name="zip_code">
				<input type="hidden" name="address_main">
				<input type="hidden" name="address_detail">
			</form>

			<script type="text/javascript">
				var SERVER_IMGPATH_str = "<%=SERVER_IMGPATH%>";
			</script>


	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
