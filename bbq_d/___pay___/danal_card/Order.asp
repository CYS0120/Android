<%
	Response.AddHeader "pragma","no-cache"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="./css/style.css" type="text/css" rel="stylesheet"
	media="screen" />
<title>*** �ſ�ī�� ���� ��û ***</title>
<script language="javascript">
    function confirmEvent() {
        document.form.action = "./Ready.asp";
        document.form.method = "POST";
        document.form.submit();
    }

    function init_orderid() {
        var today = new Date();
        var year = today.getFullYear();
        var month = today.getMonth() + 1;
        var date = today.getDate();
        var time = today.getTime();

        if (parseInt(month) < 10) {
            month = "0" + month;
        }

        if (parseInt(date) < 10) {
            date = "0" + date;
        }

        var order_idxx = "Danal_" + year + "" + month + "" + date + "" + time;

        document.form.orderid.value = order_idxx;
    }
</script>
</head>
<body onload="javascript:init_orderid();">
	<form name="form">
		<div class="paymentPop">
			<div class="titArea">
				<a href="#" class="logo"><img src="./img/logo2.gif" width="75"
					height="34" alt="Danal" /></a> <span class="txtArea"><emclass="point">[������û]</em> �� �������� �ſ�ī������� ��û�ϴ� �������Դϴ�.</span>
			</div>
			<div class="contenBox">
				<div class="grayBox">
					<div class="grayBox_top">
						<div class="grayBox_btm">
							�� �������� �ſ�ī������� ��û�ϴ� �������Դϴ�. <br>

						</div>
					</div>
				</div>
				<div class="payInfo">
					<p class="payTitle">�ſ�ī�� �ֹ�����</p>
					<div class="payDev">
						<dl>
							<dt>
* �ֹ���ȣ
							</dt>
							<dd>
								<input type="text" class="it1" value="" name="orderid" />
							</dd>
						</dl>
						<dl>
							<dt>
* ��ǰ��
							<dd>
								<input type="text" class="it1" value="TestItem" name="itemname" />
							</dd>
						</dl>
						<dl>
							<dt>
* �ֹ��ڸ�
							</dt>
							<dd>
								<input type="text" class="it" value="XXX" name="username" />
							</dd>
						</dl>
						<dl>
							<dt>
* E-mail
							</dt>
							<dd>
								<input type="text" class="it3" value="TEST@TEST.COM" name="useremail" />
							</dd>
						</dl>
						<dl>
							<dt>
* �ֹ��� ID
							</dt>
							<dd>
								<input type="text" class="it" value="USERID" name="userid" />
							</dd>
						</dl>
						<dl>
							<dt>
* �����ȯ��
							</dt>
							<dd>
								<input type="text" class="it" value="WP" name="useragent" /> "WP/WM/WA/WI" �� �ϳ�.
							</dd>
						</dl>

					</div>
				</div>
				<div class="btnSet">
					<a href="#" onclick="javascript:return false;"><img src="./img/btn_payment.gif" width="112"
						height="27" alt="������û" onclick="javascript:confirmEvent();" /></a> <a
						href="#"><img src="./img/btn_first.gif" width="112"
						height="27" alt="ó������" /></a>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
