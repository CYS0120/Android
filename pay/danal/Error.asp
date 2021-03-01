<%
    Session.CodePage = 65001
    Response.Charset = "euc-kr"

	Response.AddHeader "pragma","no-cache"

	gubun = Request.Cookies("GUBUN")
	If gubun = "Order" Then
		'PAY에 Point가 있을 경우만 취소처리'
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
		'상태는 결제취소...
		'pay_idx = -1로..?
		paycoDone = True
		'멤버십에 해줄거 없음
		'결제 후에 충전/선물이 진행되니까.

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
<title>다날 휴대폰 결제</title>
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
			<img src="./images/img_tit.gif" width="494" height="48" alt="다날휴대폰결제" />
			<span class="logo"><img src="<%=URL%>" width="119" height="47" alt="" /></span>
		</p>
		<div class="tabArea">
			<ul class="tab">
				<li class="tab01">결제서비스에러</li>
			</ul>
			<p class="btnSet">
				<a href="JavaScript:OpenHelp();"><img src="./images/btn_useInfo.gif" width="55" height="20" alt="이용안내" /></a>
				<a href="JavaScript:OpenCallCenter();"><img src="./images/btn_customer.gif" width="55" height="20" alt="고객센터" /></a>
			</p>
		</div>
		<div class="content">
			<div class="alertBox">
				<p class="type01"><strong>에러 내용(<%=Result%>)</strong><br/>
<%	If Result = "COUPON" Then %>
				주문내용에 이미 사용된 쿠폰이 있습니다
<%	Else %>
				<%=ErrMsg%>
<%	End If %>
				</p>
			</div>
			<div class="infoText">
				<p class="t02">다날 고객센터 : <strong>1566-3355</strong> (전국공통)</p>
			</div> 
			<div class="grayBox" style="margin-top:11px;">
				<p class="type02">상담원 통화가능시간 : <br/>
				평일 : 9시 ~ 18시<br/>
				<strong>토요일, 일요일, 공휴일 휴무</strong></p>
			</div>
			<p class="btnRetry"><a href="<%=BackURL%>"><img src="./images/<%=btn_error%>" width="110" height="32" alt="결제 재시도" /></a></p>
		</div>
		<div class="footer">
			<dl class="noti">
				<dt>공지사항</dt>
				<dd>다날 휴대폰 결제를 이용해주셔서 감사합니다.</dd>
			</dl>
		</div>
	</div>
</body>
</html>
