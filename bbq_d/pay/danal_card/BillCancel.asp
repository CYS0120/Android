<%
	Response.AddHeader "pragma","no-cache"
%>
<!--#include file="./inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link href="../css/style.css" type="text/css" rel="stylesheet" media="all" />
<title>*** 신용카드 결제 취소 ***</title>
</head>
<body>
<%
	Dim REQ_DATA, RES_DATA							' 변수 선언 

	'*[ 필수 데이터 ]**************************************
	Set REQ_DATA	= CreateObject("Scripting.Dictionary")

    '**************************************************
    '* 결제 정보
    '**************************************************/
    REQ_DATA.Add "TID", ""

    '**************************************************
    '* 기본 정보
    '**************************************************/
    REQ_DATA.Add "CANCELTYPE", "C"
    REQ_DATA.Add "AMOUNT", TEST_AMOUNT

    '**************************************************
    '* 취소 정보
    '**************************************************/
    REQ_DATA.Add "CANCELREQUESTER", "CP_CS_PERSON"
    REQ_DATA.Add "CANCELDESC", "Item not delivered"

    REQ_DATA.Add "CHARSET", CHARSET
    REQ_DATA.Add "TXTYPE", "CANCEL"
    REQ_DATA.Add "SERVICETYPE", "DANALCARD"

	Set RES_DATA = CallCredit(REQ_DATA, false)

    '결과 출력
    Response.Write("== 취소 요청 ==<br>" & chr(13) & chr(10))
    FOR EACH key IN REQ_DATA
        Response.Write(key & " / " & REQ_DATA.Item(key) & "<br>" & chr(13) & chr(10))
    NEXT

    Response.Write("== 취소 응답 ==<br>" & chr(13) & chr(10))
    FOR EACH key IN RES_DATA
        Response.Write(key & " / " & RES_DATA.Item(key) & "<br>" & chr(13) & chr(10))
    NEXT

%>