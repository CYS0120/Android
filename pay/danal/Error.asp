<%
    Session.CodePage = 65001
    Response.Charset = "euc-kr"

	Response.AddHeader "pragma","no-cache"

	gubun = Request.Cookies("GUBUN")
	If gubun = "Order" Then
		'PAY�� Point�� ���� ��츸 ���ó��'
		order_idx = Request.Cookies("ORDER_IDX")
		pay_idx = ""
		order_num = ""

		Set Cmd = Server.CreateObject("ADODB.Command")
		With Cmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_order_pay_select"

			.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)

			Set rs = .Execute
		End With
		Set Cmd = Nothing

		If Not (rs.BOF Or rs.EOF) Then
			pay_idx = rs("pay_idx")
			order_num = rs("order_num")
		End If
		Set rs = Nothing

		If pay_idx <> "" Then
			paycoDone = False
			Set Cmd = Server.CreateObject("ADODB.Command")
			With Cmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_pay_detail_select_method"

				.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,,pay_idx)
				.Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, "PAYCOPOINT")

				Set rs = .Execute
			End With
			Set Cmd = Nothing

			If Not (rs.BOF Or rs.EOF) Then
				Set resMC = OrderCancelListForOrder(order_idx)

				If resMC.mCode = 0 Then
					paycoDone = True
				End If
			Else
				paycoDone = True
			End If
			Set rs = Nothing

			If paycoDone Then
				Set Cmd = Server.CreateObject("ADODB.Command")
				With Cmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_pay_update_status"

					.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,, pay_idx)
					.Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "Canceled")
					.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput,500)

					.Execute

					errCode = .Parameters("@ERRCODE").Value
					errMsg = .Parameters("@ERRMSG").Value
				End With
				Set Cmd = Nothing
			End If
		End If
	ElseIf gubun = "Charge" Or gubun = "Gift" Then
		seq = Request.Cookies("CARD_SEQ")
		'���´� �������...
		'pay_idx = -1��..?
		paycoDone = True
		'����ʿ� ���ٰ� ����
		'���� �Ŀ� ����/������ ����Ǵϱ�.

		If paycoDone Then
			Set Cmd = Server.CreateObject("ADODB.Command")
			With Cmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_payco_card_update_pay"

				.Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , seq)
				.Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,,-1)
				.Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
				.Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

				.Execute

				errCode = .Parameters("@ERRCODE").Value
				errMsg = .Parameters("@ERRMSG").Value
			End With
			Set Cmd = Nothing
		End If
	End If

'	Dim btn_error, URL
	
	btn_error = "btn_cancel_error.gif"
	IF AbleBack Then
		btn_error = "btn_retry.gif"
	End IF
	
	'/*
	' * Get CIURL
	' */
	URL = GetCIURL( IsUseCI,CIURL )
	
	'/*
	' * Get BgColor
	' */
	BgColor = GetBgColor( BgColor )
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>�ٳ� �޴��� ����</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<link href="./css/style.css" type="text/css" rel="stylesheet"  media="screen" />
<script language="JavaScript" src="./js/Common.js"></script>
<script language="JavaScript">

<!--
var IsUseCI = "<%= IsUseCI %>";
var CIURL = "<%= CIURL %>";
var BgColor = "<%= BgColor %>";
-->

</script>
</head>
<body>
	<!-- popup size 500x680 -->
	<div class="paymentPop cType<%=BgColor%>">
		<p class="tit">
			<img src="./images/img_tit.gif" width="494" height="48" alt="�ٳ��޴�������" />
			<span class="logo"><img src="<%=URL%>" width="119" height="47" alt="" /></span>
		</p>
		<div class="tabArea">
			<ul class="tab">
				<li class="tab01">�������񽺿���</li>
			</ul>
			<p class="btnSet">
				<a href="JavaScript:OpenHelp();"><img src="./images/btn_useInfo.gif" width="55" height="20" alt="�̿�ȳ�" /></a>
				<a href="JavaScript:OpenCallCenter();"><img src="./images/btn_customer.gif" width="55" height="20" alt="������" /></a>
			</p>
		</div>
		<div class="content">
			<div class="alertBox">
				<p class="type01"><strong>���� ����(<%=Result%>)</strong><br/>
<%	If Result = "COUPON" Then %>
				�ֹ����뿡 �̹� ���� ������ �ֽ��ϴ�
<%	Else %>
				<%=ErrMsg%>
<%	End If %>
				</p>
			</div>
			<div class="infoText">
				<p class="t02">�ٳ� ������ : <strong>1566-3355</strong> (��������)</p>
			</div> 
			<div class="grayBox" style="margin-top:11px;">
				<p class="type02">���� ��ȭ���ɽð� : <br/>
				���� : 9�� ~ 18��<br/>
				<strong>�����, �Ͽ���, ������ �޹�</strong></p>
			</div>
			<p class="btnRetry"><a href="<%=BackURL%>"><img src="./images/<%=btn_error%>" width="110" height="32" alt="���� ��õ�" /></a></p>
		</div>
		<div class="footer">
			<dl class="noti">
				<dt>��������</dt>
				<dd>�ٳ� �޴��� ������ �̿����ּż� �����մϴ�.</dd>
			</dl>
		</div>
	</div>
</body>
</html>
