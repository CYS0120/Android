<%
  Response.AddHeader "pragma","no-cache"
  
	'/******************************************************************************** 
	' *
	' * �ٳ� ��������
	' *
	' * - ���� Ȯ�� ������
	' *	���� Ȯ�� �� ��Ÿ ���� ����
	' *
	' * �ý��� ������ ���� ���ǻ����� �����ø� ���񽺰��������� ���� �ֽʽÿ�.
	' * DANAL Commerce Division Technique supporting Team 
	' * EMail : tech@danal.co.kr 
	' *
	' ********************************************************************************/

    '/********************************************************************************
	' *
	' * XSS ����� ������ ���� 
	' * ��� ���������� �Ķ���� ���� ���� �����ϴ� ������ �߰��� ���� �ǰ� �帳�ϴ�.
	' * XSS ������� ������ ��� ���������� �����ϴ� �������� �������� �������� ��ũ��Ʈ�� ����� �� �ֽ��ϴ�.
	' * ���� ��å
	' *  - html tag�� ������� �ʾƾ� �մϴ�.(html �±� ���� white list�� �����Ͽ� �ش� �±׸� ���)
	' *  - <, >, &, " ���� ���ڸ� replace���� ���� ��ȯ�Լ��� ����Ͽ� ġȯ�ؾ� �մϴ�.
	' * 
	' ********************************************************************************/
%>
<!--#include file="./inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>�ٳ� ��������</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
</head>
<%
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
	
	IF Res.Item("RETURNCODE") = "0000" Then

		'/**************************************************************************
		' *
		' * ���� ������ ���� �۾�
		' *
		' **************************************************************************/
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
		' * ���� ���п� ���� �۾�
		' *
		' **************************************************************************/		
		RETURNCODE 	= Res.Item("RETURNCODE")
		RETURNMSG 	= Res.Item("RETURNMSG")
		AbleBack 	= false
		BackURL 	= Request.Form("BackURL")
		BgColor 	= Request.Form("BgColor")
%>
<!--#include file="Error.asp"-->
<%
	End IF
%>
