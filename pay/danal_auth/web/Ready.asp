<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    Response.CharSet = "UTF-8"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include file="inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>다날 본인인증</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<%
	Dim TransR
	'/********************************************************************************
	' *
	' * [ 전문 요청 데이터 ] *********************************************************
	' *
	' ********************************************************************************/

	'/***[ 필수 데이터 ]************************************/
	Set ByPassValue = CreateObject("Scripting.Dictionary")
	Set TransR = CreateObject("Scripting.Dictionary")

	'/******************************************************
	' ** 아래의 데이터는 고정값입니다.( 변경하지 마세요 )
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
	' * CPID 	 : 다날에서 제공해 드린 ID( function 파일 참조 )
	' * CPPWD	 : 다날에서 제공해 드린 PWD( function 파일 참조 )
	' * TARGETURL : 인증 완료 시 이동 할 페이지의 FULL URL
	' * CPTITLE   : 가맹점의 대표 URL 혹은 APP 이름 
	' ******************************************************/
	TransR.Add "CPID", ID
	TransR.Add "CPPWD", PWD
	TransR.Add "TARGETURL", GetCurrentHost& "/pay/danal_auth/Web/CPCGI.asp"
	TransR.Add "CPTITLE", "www.danal.co.kr"


	'/***[ 선택 사항 ]**************************************/
	'/******************************************************
	' * USERID	: 사용자 ID
	' * ORDERID	: CP 주문번호	
	' * AGELIMIT	: 서비스 사용 제한 나이 설정( 가맹점 필요 시 사용 )
	' ******************************************************/
	TransR.Add "USERID", REQUEST("branch_id")
	TransR.Add "ORDERID", "ORDERID"
	' TransR.Add "AGELIMIT", "019"

	
	'/********************************************************************************
	' *
	' * [ CPCGI에 HTTP POST로 전달되는 데이터 ] **************************************
	' *
	' ********************************************************************************/

	'/***[ 필수 데이터 ]************************************/
	Dim ByPassValue

	'/******************************************************
	' * BgColor	: 인증 페이지 Background Color 설정
	' * BackURL	: 에러 발생 및 취소 시 이동 할 페이지의 FULL URL
	' * IsCharSet	: charset 지정( EUC-KR:deault, UTF-8 )
	' ******************************************************/
	ByPassValue.Add "BgColor", "00"
	ByPassValue.Add "BackURL", GetCurrentHost& "/pay/danal_auth/Web/BackURL.asp"
	ByPassValue.Add "IsCharSet", CHARSET
	
	'/***[ 선택 사항 ]**************************************/
	'/******************************************************
	' ** CPCGI에 POST DATA로 전달 됩니다.
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
		' * 인증 실패에 대한 작업
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