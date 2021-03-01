<!doctype html>
<html lang="ko">
<head>
</head>
<script type="text/javascript">
var cartPage = "";
var defaultPopupOption = "width=460, height=500, toolbar=no, location=no, scrollbars=no, resizable=no, menubar=no";
var pgPopupOption = "width=704, height=504, toolbar=no, location=no, scrollbars=no, resizable=no, menubar=no";
var pgPhonePopupOption = "width=520, height=650, toolbar=no, location=no, scrollbars=no, resizable=no, menubar=no";

function goPay() {
	window.open("","pgp",pgPopupOption);
	o_form.action = "/popup/Ready.asp";
	o_form.target = "pgp";
	o_form.submit();
}
</script>
<body>
<form id="o_form" name="o_form" method="post">
	<input type="hidden" name="gubun" value="Order">
	<input type="hidden" id="paytype" name="pm" value="">
	<input type="hidden" name="order_idx">
	<input type="hidden" name="order_num">
	<input type="hidden" name="pay_method">
	<input type="hidden" name="domain" value="mobile">
	<input type="hidden" name="save_point" id="save_point">
	<input type="hidden" name="coupon_amt" id="payco_coupon">
	<input type="hidden" name="bbq_card" id="bbq_card">
	<input type="hidden" name="use_coupon" id="use_coupon" value="[]">
	<input type="hidden" name="chk_mem" id="chk_mem" value="N">
	<input type="hidden" name="branch_id" value="<%=branch_id%>">
</form>
<input type=button onClick="goPay()" value="test">
</body>
</html>