<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/api/order/class_order_db.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
</head>

<body>
<div class="wrapper">
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
		vMobile = aRs("delivery_mobile")
		vZipCode = aRs("delivery_zipcode")
		vAddress = aRs("delivery_address")&" "&aRs("delivery_address_detail")
		delivery_time = aRs("delivery_time")
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
	PageTitle = "취소 완료"
%>
	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
			
		<!-- Content -->
		<article class="content inbox1000">

			<!-- 주문완료 텍스트 -->
			<div class="order_CompleteTxt">
				<h3>주문이 정상적으로<br>취소 되었습니다.</h3>
				<p><%=GetReqStr(LoginUserName, "고객")%>님께서 취소 하신 주문 내역입니다.</p>
			</div>
			<!-- //주문완료 텍스트 -->

			<!--#include virtual="/mypage/orderView_content.asp"-->


			<!-- 결제정보 -->
			<div class="section-wrap section-orderInfo bor-none">
				<div class="btn-wrap one mar-t30">
					<a href="/" class="btn btn_middle btn-red">확인</a>
				</div>
			</div>
			<!-- //결제정보 -->

			<!--주문완료 문구-->
			<div class="order_CompleteTxt2">
				<p>
					고객님께서 주문 하신 건이 정상적으로 취소 되었습니다. 
<!-- 
					<br>
					주문에 사용된 쿠폰의 경우, ######<br>
					카드결제는 ########<br>
					감사합니다. 
 -->
				</p>
			</div>
			<!--//주문완료 문구-->

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>