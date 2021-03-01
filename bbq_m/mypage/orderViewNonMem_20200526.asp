<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">

<head>
<!--#include virtual="/includes/top.asp"-->
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
		vMobile = aRs("delivery_mobile")
		vZipCode = aRs("delivery_zipcode")
		vAddress = aRs("delivery_address")&" "&aRs("delivery_address_detail")
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
	PageTitle = "주문상세"
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
		<article class="content">

			<ul class="reorder_time">
				<li><span>주문번호</span> <%=vOrderNum%></li>
				<li><span>주문일시</span> <%=vOrderDate%></li>
			</ul>

			<div class="reorder_wrap">

				<ul class="reorder_view_top clearfix">
					<li class="reorder_view_option"><span><%=vBrandName%><%If vOrderType="X" Then%>(off)<%End If%></span></li>
					<li class="reorder_view_con">
						<span class="reorder_view_delivery">
							<%	If vOrderType = "D" Then %>
								<img src="/images/order/icon_delivery.png"> 
							<%	elseIf vOrderType = "P" Then %>
								<img src="/images/mypage/ico_order_pick.png" alt="">
							<%	elseIf vOrderType = "X" Then %>
								<img src="/images/mypage/ico_order_shop.png" alt="">
							<%	End If  %>
							
							<%=vOrderTypeName%>
						</span>
						<span class="reorder_view_cancel"><img src="/images/order/icon_cancel.png"> <%=vOrderStatusName%></span>
					</li>
				</ul>

				<div class="reorder_view_list">

<%

						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select_main"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						If Not (aRs.BOF Or aRs.EOF) Then
							Do Until aRs.EOF
%>
								<ul>
									<li class="reorder_view_img"><img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>" alt="<%=vMenuName%>" ></li>
									<li class="reorder_view_info">
										<ul>
											<li class="reorder_view_title"><%If aRs("coupon_pin") = "GIFTCOUPON" Then%>(증정쿠폰)<%End If%><%=aRs("menu_name")%></li>
											<li class="reorder_view_price"><strong><%=FormatNumber(aRs("menu_price"),0)%></strong>원  <span>/ <%=aRs("menu_qty")%>개</span></li>
										</ul>
									</li>
								</ul>
<%
								aRs.MoveNext
							Loop
						End If

						Set aRs = Nothing
%>

<%
						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select_barcode"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						If Not (aRs.BOF Or aRs.EOF) Then
							isFirst = True
							Do Until aRs.EOF
%>

								<ul>
									<li class="reorder_view_img"><img src="/images/menu/store_menu.jpg" alt="<%=vMenuName%>" onerror="this.src='http://placehold.it/160x138?text=1';" ></li>
									<li class="reorder_view_info">
										<ul>
											<li class="reorder_view_title"><%=aRs("CGOODNM")%></li>
											<li class="reorder_view_price"><strong><%=FormatNumber(aRs("FAMT"),0)%></strong>원  <span>/ <%=aRs("FQTY")%>개</span></li>
										</ul>
									</li>
								</ul>


<%
								aRs.MoveNext
							Loop
						End If

						Set aRs = Nothing
%>

				</div>

				<div  class="reorder_view_pay">
					<ul class="reorder_view_payList">
						<li>총 상품금액 <span><%=FormatNumber(vOrderAmt,0)%><span>원</span></span></li>
						
						<%If vOrderType = "D" Then%>
							<li>배달비 <span><%=FormatNumber(vDeliveryFee,0)%><span>원</span></span></li>
						<%End If%>

						<li>할인금액 <span><%=FormatNumber(vDiscountAmt,0)%><span>원</span></span></li>
					</ul>
					<ul class="reorder_view_payTotal">
						<li>최종 결제금액</li>
						<li><span><%=FormatNumber(vPayAmt,0)%></span>원</li>
					</ul>
				</div>

				<ul class="reorder_view_data">
					<h4><%=order_type_title%></h4>
					<li class="reorder_view_shop">
						<h5><%=order_type_name%></h5>
						<span><%=vBranchName%></span>(<%=vBranchTel%>)
					</li>
					<li class="reorder_view_address">
						<h5><%=address_title%></h5>

						<%If vOrderType = "D" Then%>
							<%=vAddressName%>
							<span class="robotoR"><%=vMobile%></span>
							(<%=vZipCode%>) 
						<%End If%>
						
						<span><%=vAddress%></span>
					</li>
					<li>
						<h5>기타요청사항</h5>
						<span><%=vDeliveryMessage%></span>
					</li>
				</ul>

				<ul class="reorder_view_data">
					<h4>결제정보</h4>
					<li>
						<h5>결제방법</h5>
						<span><%=pay_type_title%> / <%=pay_type_name%></span>
					</li>
					<li>
						<h5>결제금액</h5>
						<span><span class="robotoR"><%=FormatNumber(vPayAmt,0)%></span>원</span>
					</li>
				</ul>

				<%
					If rtnUrl <> "" Then
				%>
						<div class="reorder_view_btn"><a href="<%=rtnUrl%>" class="btn-gray btn_small">목록</a></div>
				<%
					Else
				%>
							<div class="reorder_view_btn"><a href="/mypage/orderListNonMem.asp?gotopage=<%=gotopage%>" class="btn-gray btn_small">목록</a></div>
				<%
					
					End if
				%>

				<!-- <div class="reorder_view_btn"><a href="javascript: void(0)" onclick="reOrder('<%=order_idx%>', '<%=vOrderType%>')" class="btn-red btn_middle">다시 담기</a></div> -->

			</div>

		</article>
		<!--// Content -->

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
