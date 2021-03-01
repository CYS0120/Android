<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%
	'-----------------------------------------------------------------------------
	' PAYCO 팝업차단 페이지 샘플 ( ASP )
	' payco_popup.asp
	' 2015-04-20	PAYCO기술지원 <dl_payco_ts@nhnent.com>
	'-----------------------------------------------------------------------------

	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
'	Dim xform, receive_str
'	receive_str = "ready_pre.asp is Called - "
'	For Each xform In Request.form
'		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
'	Next
'	Call Write_Log(receive_str)


	'-----------------------------------------------------------------------------
	' 테스트용 고객 주문 번호 생성
	' 테스트 할때 마다 Refresh(F5)를 해서 고객 주문 번호가 바뀌어야 정상적인 테스트를 하실 수 있습니다.
	'-----------------------------------------------------------------------------
	'Dim CustomerOrderNumber
	'CustomerOrderNumber = request("CustomerOrderNumber")

	gubun = GetReqStr("gubun","")
    domain = GetReqStr("domain","")

	order_idx = GetReqNum("order_idx", "")
	order_num = GetReqStr("order_num","")
	pay_method = GetReqStr("pay_method","")
	branch_id = GetReqStr("branch_id","")

	If branch_id = "" Then
%>
<script>
	alert('매장정보가 없습니다.');
    if(window.opener) {
        self.close();
    } else {
        history.back();
    }
</script>
<%
		response.End
	End If

	' 매장정보 조회...
	Set aCmd = Server.CreateObject("ADODB.Command")

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_branch_select"

		.Parameters.Append .CreateParameter("@branch_id", adInteger, adParamInput, , branch_id)

		Set aRs = .Execute
	End With

	Set aCmd = Nothing

	vUseDANAL = "N"
	vUsePAYCO = "N"
	vUsePAYCOIN = "N"

	If Not (aRs.BOF Or aRs.EOF) Then
		vBranchName = aRs("branch_name")
		vBranchTel = aRs("branch_tel")
		vDeliveryFee = aRs("delivery_fee")
		vSubCPID = aRs("DANAL_H_SCPID")
		vUseDANAL = aRs("USE_DANAL")
		vUsePAYCO = aRs("USE_PAYCO")
		vPayco_Seller = aRs("payco_seller")
		vPayco_Cpid = aRs("payco_cpid")
		vPayco_Itemcd = aRs("payco_itemcd")
		vUsePAYCOIN = aRs("USE_PAYCOIN")
		vPaycoin_Cpid = Trim(aRs("paycoin_cpid"))

		vSubCPID = fNullCheck(vSubCPID, "", "")
		vPayco_Cpid = fNullCheck(vPayco_Cpid, "", "")
		vPayco_Itemcd = fNullCheck(vPayco_Itemcd, "", "")
		vUsePAYCOIN = fNullCheck(vUsePAYCOIN, "", "")
		vPaycoin_Cpid = fNullCheck(vPaycoin_Cpid, "", "")

		If vPaycoin_Cpid <> "" Then
		Else 
%>
			<script>
				alert('페이코인 간편결제 가맹점이 아닙니다.');
				if(window.opener) {
					self.close();
				} else {
					history.back();
				}
			</script>
<%
			Set aRs = Nothing
			response.End
		End If
	Else
%>
		<script>
			alert('매장정보가 없습니다.');
			if(window.opener) {
				self.close();
			} else {
				history.back();
			}
		</script>
<%
		Set aRs = Nothing
		response.End
	End If





    AMOUNT = 0
    BRAND_ID = ""
    BRANCH_ID = ""
    DANAL_H_SCPID = ""


        Response.Cookies("GUBUN") = gubun
	    Response.Cookies("ORDER_IDX") = order_idx

		Set pCmd = Server.CreateObject("ADODB.Command")
	    With pCmd
	        .ActiveConnection = dbconn
	        .NamedParameters = True
	        .CommandType = adCmdStoredProc
	        .CommandText = "bp_order_for_pay"

	        .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

	        Set pRs = .Execute
	    End With
	    Set pCmd = Nothing

	    If Not (pRs.BOF Or pRs.EOF) Then
	        USER_ID = pRs("member_idno")
	        ORDER_NUM = pRs("order_num")
	        DANAL_H_SCPID = pRs("danal_h_scpid")
	        AMOUNT = pRs("order_amt")+pRs("delivery_fee")-pRs("discount_amt")
	    Else
	        USER_ID = ""
	        ORDER_NUM = ""
	        DANAL_H_SCPID = ""
	        AMOUNT = ""
	    End If

		' 제주/산간 =========================================================================================
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_select_1138"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

            Set pRs = .Execute
        End With
        Set pCmd = Nothing

        If Not (pRs.BOF Or pRs.EOF) Then
            AMOUNT = AMOUNT + (pRs("menu_price")*pRs("menu_qty"))
        End If
		' =========================================================================================

    userAgent = ""
    Select Case domain
        Case "pc": userAgent = "WEB" 
        Case "mobile": userAgent = "MOBILE"
    End Select


	Response.Cookies("paycoin_gubun") = gubun
	Response.Cookies("paycoin_domain") = domain
	Response.Cookies("paycoin_order_idx") = order_idx
	Response.Cookies("paycoin_order_num") = order_num
	Response.Cookies("paycoin_pay_method") = pay_method
	Response.Cookies("paycoin_branch_id") = branch_id
	Response.Cookies("paycoin_AMOUNT") = AMOUNT
	Response.Cookies("paycoin_USER_ID") = USER_ID
	Response.Cookies("paycoin_vPaycoin_Cpid") = vPaycoin_Cpid
	Response.Cookies("paycoin_userAgent") = userAgent
	Response.Cookies("paycoin_vSubCPID") = vSubCPID

%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=2.0,user-scalable=yes">
<title>페이코인</title>
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script type="text/javascript">

function order()
{
	document.paycoin_form.submit();
}

</script>
</head>
<body onLoad="order()">
	<form method="post" name="paycoin_form" action="/pay/paycoin/Ready.aspx">
		<input type="hidden" name="gubun" value="<%=gubun%>" />
		<input type="hidden" name="domain" value="<%=domain%>" />
		<input type="hidden" name="order_idx" value="<%=order_idx%>" />
		<input type="hidden" name="order_num" value="<%=order_num%>" />
		<input type="hidden" name="pay_method" value="<%=pay_method%>" />
		<input type="hidden" name="branch_id" value="<%=branch_id%>" />

		<input type="hidden" name="orderid" value="<%=order_num%>" />
		<input type="hidden" name="amount" value="<%=AMOUNT%>" />
		<input type="hidden" name="product" value="BBQ Chicken" />
		<input type="hidden" name="user_id" value="<%=USER_ID%>" />
		<input type="hidden" name="cp_id" value="<%=vPaycoin_Cpid%>" />
		<input type="hidden" name="agent_type" value="<%=userAgent%>" />
		<input type="hidden" name="sub_cp_id" value="<%=vSubCPID%>" />
	</form>
</body>
</html>