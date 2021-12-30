<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include virtual="/pay/coupon_use_coop.asp"-->
<!--#include file="./inc/function.asp"-->
<html>
<head>
<title>다날 본인인증</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<%
	Session.CodePage = "65001"
    Response.CharSet = "UTF-8"

	Dim TransR, Addition, Res
	Dim nConfirmOption, TID
	
	Set TransR = CreateObject("Scripting.Dictionary")

	TID = Request.Form("TID")
	
	'/*
	' * initialize
	' */
	Res = null
	
	'/*
	' * CONFIRM
	' * - CONFIRMOPTION 
	' *	0 : NONE( default )
	' * 	1 : CPID 및 ORDERID 체크 
	' * - IDENOPTION
	' * 0 : 생년월일(6자리) 및 성별 IDEN 필드로 Return (ex : 1401011)
	' * 1 : 생년월일(8자리) 및 성별 별개 필드로 Return (연동 매뉴얼 참조. ex : DOB=20140101&SEX=1)
	' */
	nConfirmOption = "0"
	nIdenOption = "0"
	TransR.Add "TXTYPE", "CONFIRM"
	TransR.Add "TID", TID
	TransR.Add "CONFIRMOPTION", nConfirmOption
	TransR.Add "IDENOPTION", nIdenOption
	
	'/*
	' * CONFIRMOPTION이 1이면 CPID, ORDERID 필수 전달
	' */
	IF nConfirmOption = "1" Then
		TransR.Add "CPID", ID
		TransR.Add "ORDERID", ORDERID
	End IF
	
	Set Res = CallTrans(TransR,false)

	' 로그인이 끈키는 현상이 있어서 넣음.
	If Session("userIdx") <> "" Then 

	Else
		Session("userIdx") = Request.Cookies("userIdx")
		Session("userId") = Request.Cookies("userId")
		Session("userIdNo") = Request.Cookies("userIdNo")
		if Session("userName") = "" then Session("userName") = Request.Cookies("userName")
		Session("userBirth") = Request.Cookies("userBirth")
		Session("userGender") = Request.Cookies("userGender")
		Session("userEmail") = Request.Cookies("userEmail")
		Session("userPhone") = Request.Cookies("userPhone")
		Session("userType") = Request.Cookies("userType")
		Session("userStatus") = Request.Cookies("userStatus")

		Response.Cookies("userIdx") = ""
		Response.Cookies("userId") = ""
		Response.Cookies("userIdNo") = ""
		Response.Cookies("userName") = ""
		Response.Cookies("userBirth") = ""
		Response.Cookies("userGender") = ""
		Response.Cookies("userEmail") = ""
		Response.Cookies("userPhone") = ""
		Response.Cookies("userType") = ""
		Response.Cookies("userStatus") = ""

	End If 

	IF Res.Item("RETURNCODE") = "0000" Then

		'/**************************************************************************
		' *
		' * 인증 성공에 대한 작업
		' *
		' **************************************************************************/

		Sql = "Insert Into bt_danal_auth_log(order_num, tid, ci , di, user_nm, branch_id, iden, dob, sex, result, result_msg, regdate) values('"& ORDER_NUM &"','"& Res.Item("TID") &"','"& Res.Item("CI") &"','"& Res.Item("DI") &"','"& Res.Item("NAME") &"','"& Res.Item("USERID") &"','"& Res.Item("IDEN") &"','"& Res.Item("DOB") &"','"& Res.Item("SEX") &"','"& Res.Item("RETURNCODE") &"','"& Res.Item("RETURNMSG") &"',GETDATE())"
		dbconn.Execute(Sql)

		Session("danal_auth_tid") = Res.Item("TID")
%>
<body>
<form name="CPCGI" action="./Success.asp" method="post">
<%
	MakeFormInputHTTP Request.Form , "TID"
	MakeFormInput Res , Array("RETURNCODE","RETURNMSG")
%>
</form>
<script>
	document.CPCGI.submit();
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
		BackURL 	= Request.Form("BackURL")
		BgColor 	= Request.Form("BgColor")

'		Sql = "Insert Into bt_danal_auth_log(order_num, tid, ci , di, user_nm, branch_id, iden, dob, sex, result, result_msg, regdate) values('"& ORDER_NUM &"','','','','"& USER_ID &"','','','','','"& RETURNCODE &"','"& RETURNMSG &"',GETDATE())"
'		dbconn.Execute(Sql)
%>
<!--#include file="Error.asp"-->
<%
	End IF
%>
