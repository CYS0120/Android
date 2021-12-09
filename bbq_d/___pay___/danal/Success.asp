<%
	Response.AddHeader "pragma","no-cache"
	'/********************************************************************************
	' *
	' *�ٳ� �޴��� ����
	' *
	' * - ���� �Ϸ� ������
	' *	���� Ȯ��
	' *
	' *  ���� �ý��� ������ ���� ���ǻ����� �����ø� ���񽺰��������� ���� �ֽʽÿ�.
	' * DANAL Commerce Division Technique supporting Team
	' * EMail : tech@danal.co.kr
	' *
	' ********************************************************************************/
	Dim IsUseCI, CIURL, BgColor, URL
	
	IsUseCI = Request.Form("IsUseCI")
	CIURL = Request.Form("CIURL")
	BgColor = Request.Form("BgColor")
	
	'/*
	' * Get CIURL
	' */
	URL = GetCIURL( IsUseCI,CIURL )
	
	'/*
	' * Get BgColor
	' */
	BgColor = GetBgColor( BgColor )
%>
<!--#include file="inc/function.asp"-->
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
				<li class="tab01">���� ����</li>
			</ul>
			<p class="btnSet">
				<a href="JavaScript:OpenHelp();"><img src="./images/btn_useInfo.gif" width="55" height="20" alt="�̿�ȳ�" /></a>
				<a href="JavaScript:OpenCallCenter();"><img src="./images/btn_customer.gif" width="55" height="20" alt="��������" /></a>
			</p>
		</div>
		<div class="content">
			<div class="alertBox">
				<p class="type02"><span>������ ���� ó���Ǿ����ϴ�.</span></p>
			</div>
			<p class="btnSet02"><a href="#" onclick="javascript:return false;"><img src="./images/btn_ok.gif" width="80" height="32" alt="Ȯ��" /></a></p>
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