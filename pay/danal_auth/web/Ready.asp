<%@LANGUAGE="VBSCRIPT" CODEPAGE="949"%>
<%
    Session.CodePage = "949"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    Response.CharSet = "EUC-KR"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>�ٳ� ��������</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
</head>
<%
	Dim TransR
	'/********************************************************************************
	' *
	' * [ ���� ��û ������ ] *********************************************************
	' *
	' ********************************************************************************/

	'/***[ �ʼ� ������ ]************************************/
	Set ByPassValue = CreateObject("Scripting.Dictionary")
	Set TransR = CreateObject("Scripting.Dictionary")

	'/******************************************************
	' ** �Ʒ��� �����ʹ� �������Դϴ�.( �������� ������ )
	' * TXTYPE	: ITEMSEND
	' * SERVICE	: UAS
	' * AUTHTYPE	: 36
	' ******************************************************/
	TransR.Add "TXTYPE", "ITEMSEND"
	TransR.Add "SERVICE", "UAS"
	TransR.Add "AUTHTYPE", "36"

	ID = "B010047230"
	PWD = "p2cGNNViYm"

	'/******************************************************
	' * CPID 	 : �ٳ����� ������ �帰 ID( function ���� ���� )
	' * CPPWD	 : �ٳ����� ������ �帰 PWD( function ���� ���� )
	' * TARGETURL : ���� �Ϸ� �� �̵� �� �������� FULL URL
	' * CPTITLE   : �������� ��ǥ URL Ȥ�� APP �̸� 
	' ******************************************************/
	TransR.Add "CPID", ID
	TransR.Add "CPPWD", PWD
	TransR.Add "TARGETURL", GetCurrentHost& "/pay/danal_auth/Web/CPCGI.asp"
	TransR.Add "CPTITLE", "www.danal.co.kr"


	'/***[ ���� ���� ]**************************************/
	'/******************************************************
	' * USERID	: ����� ID
	' * ORDERID	: CP �ֹ���ȣ	
	' * AGELIMIT	: ���� ��� ���� ���� ����( ������ �ʿ� �� ��� )
	' ******************************************************/
	TransR.Add "USERID", REQUEST("branch_id")
	TransR.Add "ORDERID", "ORDERID"
	' TransR.Add "AGELIMIT", "019"

	
	'/********************************************************************************
	' *
	' * [ CPCGI�� HTTP POST�� ���޵Ǵ� ������ ] **************************************
	' *
	' ********************************************************************************/

	'/***[ �ʼ� ������ ]************************************/
	Dim ByPassValue

	'/******************************************************
	' * BgColor	: ���� ������ Background Color ����
	' * BackURL	: ���� �߻� �� ��� �� �̵� �� �������� FULL URL
	' * IsCharSet	: charset ����( EUC-KR:deault, UTF-8 )
	' ******************************************************/
	ByPassValue.Add "BgColor", "00"
	ByPassValue.Add "BackURL", GetCurrentHost& "/pay/danal_auth/Web/BackURL.asp"
	ByPassValue.Add "IsCharSet", CHARSET
	
	'/***[ ���� ���� ]**************************************/
	'/******************************************************
	' ** CPCGI�� POST DATA�� ���� �˴ϴ�.
	' **
	' ******************************************************/  
	ByPassValue.Add "ByBuffer", "This value bypass to CPCGI Page"
	ByPassValue.Add "ByAnyName", "AnyValue"
	

	Response.Cookies("userIdx") = Session("userIdx")
	Response.Cookies("userId") = Session("userId")
	Response.Cookies("userIdNo") = Session("userIdNo")
	Response.Cookies("userName") = Session("userName")
	Response.Cookies("userBirth") = Session("userBirth")
	Response.Cookies("userGender") = Session("userGender")
	Response.Cookies("userEmail") = Session("userEmail")
	Response.Cookies("userPhone") = Session("userPhone")
	Response.Cookies("userType") = Session("userType")
	Response.Cookies("userStatus") = Session("userStatus")


	Set Res = CallTrans( TransR,false )
	
	IF Res.Item("RETURNCODE") = "0000" Then
%>
<body>
<form name="Ready" action="https://wauth.teledit.com/Danal/WebAuth/Web/Start.php" method="post">
<%
MakeFormInput Res , Array("RETURNCODE","RETURNMSG")
MakeFormInput ByPassValue , null
%>
</form>
<script Language="JavaScript">
	document.Ready.submit();
</script>
</body>
</html>
<%
	Else
		'/**************************************************************************
		' *
		' * ���� ���п� ���� �۾�
		' *
		' **************************************************************************/  
		RETURNCODE 	= Res.Item("RETURNCODE")
		RETURNMSG 	= Res.Item("RETURNMSG")
		AbleBack 	= false
		BackURL 	= ByPassValue.Item("BackURL")
		BgColor 	= ByPassValue.Item("BgColor")
%>
		<!--#include file = "Error.asp"-->
<%
	End IF
%>