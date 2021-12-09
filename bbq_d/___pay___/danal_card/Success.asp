<%
	Response.AddHeader "pragma","no-cache"       
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link href="./css/style.css" type="text/css" rel="stylesheet"  media="all" />
<title>*** �ſ�ī�� ���� ***</title>
</head>
<body>
<form name="form" >
	<!-- popSize 530x430  -->
	<div class="popWrap">
		<h1 class="logo"><img src="./img/logo.gif" alt="Danal �ſ�ī��" /></h1>
		<div class="tit_area">
			<p class="tit"><img src="./img/tit05.gif" alt="�����Ϸ� Complete" /></p>
		</div>
			<div class="box">
				<div class="boxTop">
					<div class="boxBtm" style="height:136px;">
						<p class="txt_info">������ ������ �Ϸ�Ǿ����ϴ�.</p>
					</div>
				</div>
			</div>
		<p class="btn">
			<a href="#" onclick="javascript:return false;"><img src="./img/btn_confirm.gif" width="91" height="28" alt="Ȯ��" /></a>
		</p>
		<div class="popFoot">
			<div class="foot_top">
				<div class="foot_btm">
					<div class="noti_area">
						 �ٳ� �ſ�ī������� �̿����ּż� �����մϴ�. [Tel] 1566-3355
					</div>
				</div>
			</div>			
		</div>
	</div>
    <input TYPE="HIDDEN" NAME="TID"  	VALUE="<%= Request.Form("TID")  %>">
</form>
</body>
</html>