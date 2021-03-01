<%
	param_tid = Request("tid")
	param_order_num = Request("order_num")
	param_vPaycoin_Cpid = Request("vPaycoin_Cpid")

	If param_tid <> "" Then ' get방식 주문취소일경우 (관리자페이지에서)
		tid = param_tid
		paycoin_order_num = param_order_num
		paycoin_vPaycoin_Cpid = param_vPaycoin_Cpid
	End If 

	Response.Cookies("paycoin_tid") = tid
	Response.Cookies("paycoin_order_num") = paycoin_order_num
	Response.Cookies("paycoin_vPaycoin_Cpid") = paycoin_vPaycoin_Cpid
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
	<form method="post" name="paycoin_form" action="/pay/paycoin/cancel.aspx">
		<input type="hidden" name="tid" value="<%=tid%>" />
		<input type="hidden" name="cp_id" value="<%=paycoin_vPaycoin_Cpid%>" />
		<input type="hidden" name="orderid" value="<%=paycoin_order_num%>" />
	</form>
</body>
</html>