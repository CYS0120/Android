<%
	Response.AddHeader "pragma","no-cache"
%>
<!--#include file="./inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/style.css" type="text/css" rel="stylesheet" media="all" />
<title>*** �ſ�ī�� ���� ��� ***</title>
</head>
<body>
<%
	Dim REQ_DATA, RES_DATA							' ���� ���� 

	'*[ �ʼ� ������ ]**************************************
	Set REQ_DATA	= CreateObject("Scripting.Dictionary")

    '**************************************************
    '* ���� ����
    '**************************************************/
    REQ_DATA.Add "TID", ""

    '**************************************************
    '* �⺻ ����
    '**************************************************/
    REQ_DATA.Add "CANCELTYPE", "C"
    REQ_DATA.Add "AMOUNT", TEST_AMOUNT

    '**************************************************
    '* ��� ����
    '**************************************************/
    REQ_DATA.Add "CANCELREQUESTER", "CP_CS_PERSON"
    REQ_DATA.Add "CANCELDESC", "Item not delivered"

    REQ_DATA.Add "CHARSET", CHARSET
    REQ_DATA.Add "TXTYPE", "CANCEL"
    REQ_DATA.Add "SERVICETYPE", "DANALCARD"

	Set RES_DATA = CallCredit(REQ_DATA, false)

    '��� ���
    Response.Write("== ��� ��û ==<br>" & chr(13) & chr(10))
    FOR EACH key IN REQ_DATA
        Response.Write(key & " / " & REQ_DATA.Item(key) & "<br>" & chr(13) & chr(10))
    NEXT

    Response.Write("== ��� ���� ==<br>" & chr(13) & chr(10))
    FOR EACH key IN RES_DATA
        Response.Write(key & " / " & RES_DATA.Item(key) & "<br>" & chr(13) & chr(10))
    NEXT

%>