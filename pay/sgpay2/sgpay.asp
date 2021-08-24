<!--#include file="sgpay.inc.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%
	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xform, receive_str
	receive_str = "sgpay.asp is Called - "
	For Each xform In Request.form
		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
	Next
	Call Write_Log(receive_str)


	'-----------------------------------------------------------------------------
	' 테스트용 고객 주문 번호 생성
	' 테스트 할때 마다 Refresh(F5)를 해서 고객 주문 번호가 바뀌어야 정상적인 테스트를 하실 수 있습니다.
	'-----------------------------------------------------------------------------
	'Dim CustomerOrderNumber
	'CustomerOrderNumber = request("CustomerOrderNumber")

	gubun = GetReqStr("gubun", "")
	domain = GetReqStr("domain", "")

	order_idx = GetReqNum("order_idx", "")
	order_num = GetReqStr("order_num", "")
	pay_method = GetReqStr("pay_method", "")
	branch_id = GetReqStr("branch_id", "")

	If order_num = "" Then
		Result = jsonOrder.JSONoutput()
		encryptedJson = Com.encrypt(Result, secretkey)

		Response.Redirect sgPayMainUrl & encryptedJson
	Else
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
<title>Sgpay</title>
<script type="text/javascript">
function sendOrderInfo() {
	document.orderForm.submit();
}
</script>
</head>
<body onLoad="sendOrderInfo()">
	<form name="orderForm" method="post" action="/pay/sgpay/sgpay_res.asp">
<%
	For Each xform In Request.Form
		Response.Write "<input type=""hidden"" name=""" & CStr(xform) & """ id=""" & CStr(xform) & """ value='" & request(xform) & "' />" & vbCrlf
	Next
%>
	</form>
</body>
</html>
<%
	End If
%>