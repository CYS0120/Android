<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include file="./inc/function.asp"-->
<%
	returncode = request("returncode")
	returnmsg = request("returnmsg")

	paycoin_order_idx = Request.Cookies("paycoin_order_idx")
	dev_msg = "취소"
	Sql = "Insert Into bt_order_g2_log(order_idx, payco_log, coupon_amt, log_point) values('"& paycoin_order_idx &"','"& Replace(returncode,"'","") &"/"& Replace(returnmsg,"'","") &"/"& Replace(dev_msg,"'","") &"','0','paycoin_failure-001')"
	dbconn.Execute(Sql)
%>
<meta charset="utf-8">
<script>
	alert('<%=returnmsg%>');

	if(window.opener) {
		try {
			self.close();
		} catch (e) {
			location.href="/";
		}
	} else {
		location.href="/";
	}
</script>