<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/pay/coupon_use.asp"-->
<!--#include file="./inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>�ٳ� ��������</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
</head>
<%
	session.CodePage = 949
    Response.CharSet = "EUC-KR"

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
	' * 	1 : CPID �� ORDERID üũ 
	' * - IDENOPTION
	' * 0 : �������(6�ڸ�) �� ���� IDEN �ʵ�� Return (ex : 1401011)
	' * 1 : �������(8�ڸ�) �� ���� ���� �ʵ�� Return (���� �Ŵ��� ����. ex : DOB=20140101&SEX=1)
	' */
	nConfirmOption = "0"
	nIdenOption = "0"
	TransR.Add "TXTYPE", "CONFIRM"
	TransR.Add "TID", TID
	TransR.Add "CONFIRMOPTION", nConfirmOption
	TransR.Add "IDENOPTION", nIdenOption
	
	'/*
	' * CONFIRMOPTION�� 1�̸� CPID, ORDERID �ʼ� ����
	' */
	IF nConfirmOption = "1" Then
		TransR.Add "CPID", ID
		TransR.Add "ORDERID", ORDERID
	End IF
	
	Set Res = CallTrans(TransR,false)

	' �α����� ��Ű�� ������ �־ ����.
	If Session("userIdx") <> "" Then 

	Else
		Session("userIdx") = Request.Cookies("userIdx")
		Session("userId") = Request.Cookies("userId")
		Session("userIdNo") = Request.Cookies("userIdNo")
		Session("userName") = Request.Cookies("userName")
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
		' * ���� ������ ���� �۾�
		' *
		' **************************************************************************/

		Sql = "Insert Into bt_danal_auth_log(order_num, tid, ci , di, user_nm, branch_id, iden, dob, sex, result, result_msg, regdate) values('"& ORDER_NUM &"','"& Res.Item("TID") &"','"& Res.Item("CI") &"','"& Res.Item("DI") &"','"& Res.Item("NAME") &"','"& Res.Item("USERID") &"','"& Res.Item("IDEN") &"','"& Res.Item("DOB") &"','"& Res.Item("SEX") &"','"& Res.Item("RETURNCODE") &"','"& Res.Item("RETURNMSG") &"',GETDATE())"
		dbconn.Execute(Sql)

		Response.Cookies("danal_auth_tid") = Res.Item("TID")
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

		Response.Cookies("danal_auth_tid") = ""
		Session("danal_auth_tid") = ""

 		'/**************************************************************************
		' *
		' * ���� ���п� ���� �۾�
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
