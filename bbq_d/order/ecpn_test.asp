<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<%
	Response.Cookies("GUBUN") = ""
	Response.Cookies("ORDER_IDX") = ""

	Dim aCmd, aRs

	Dim order_idx : order_idx = Request("order_idx")

	If order_idx = "" Then
%>
	<script type="text/javascript">
		alert("잘못된 접근입니다.");
		location.href = "/";
	</script>
<%
		Response.End
	End If
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_select_one"

		.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,,order_idx)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing
	Dim order_num, order_date, order_amt, discount_amt, pay_amt, delivery_fee, order_type
	Dim branch_id, branch_name, branch_phone, branch_tel, addr_name, zipcode, address_main, address_detail, delivery_message, delivery_mobile
	Dim spent_time
	If Not (aRs.BOF Or aRs.EOF) Then
		order_idx = aRs("order_idx")
		order_num = aRs("order_num")
		order_type = aRs("order_type")
		member_idx = aRs("member_id")
		member_idno = aRs("member_idno")
		member_type = aRs("member_type")
		pay_type = aRs("pay_type")
		order_date = aRs("order_date")
		order_amt = aRs("order_amt")
		delivery_fee = aRs("delivery_fee")
		discount_amt = aRs("discount_amt")
		pay_amt = aRs("pay_amt")
		branch_id = aRs("branch_id")
		branch_name = aRs("branch_name")
		branch_phone = aRs("branch_phone")
		branch_tel = aRs("branch_tel")
		addr_name = aRs("addr_name")
		zipcode = aRs("delivery_zipcode")
		address_main = aRs("delivery_address")
		address_detail = aRs("delivery_address_detail")
		delivery_message = aRs("delivery_message")
		delivery_mobile = aRs("delivery_mobile")
		spent_time = aRs("spent_time")
		order_channel = aRs("order_channel")
		MENU_NAME		= aRs("MENU_NAME")
		If order_channel = "2" Or order_channel = "3"  Then
			order_channel = "WEB"
		Else
			order_channel = "APP"
		End If
	End If
	Set aRs = Nothing

	'E 쿠폰처리 bt_order_detail 에 쿠폰 사용내역이 있다면 결제정보에 추가 함
	Set pinCmd = Server.CreateObject("ADODB.Command")
	with pinCmd
		.ActiveConnection = dbconn
		.CommandText = "bp_order_detail_select_ecoupon"
		.CommandType = adCmdStoredProc

		.Parameters.Append .CreateParameter("@ORDER_IDX", adInteger, adParamInput, , order_idx)
		Set pinRs = .Execute
	End With
	Set pinCmd = Nothing
	If pinRs.Eof And pinRs.Bof Then
	Else
		'E 쿠폰 전송
		If TESTMODE <> "Y" Then 
			KTR_Use_Coupon order_num, dbconn
		End If 
	End If
%>