<%
	Response.AddHeader "pragma","no-cache"
%>
<!--#include file="../barcode/inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>*** ?? ????? ?? ?? ***</title>
</head>
<body>
<%
	Dim REQ_DATA, RES_DATA							' ?? ?? 

	'*[ ?? ??? ]**************************************
	Set REQ_DATA	= CreateObject("Scripting.Dictionary")
	
    REQ_DATA.Add "CPID", "9010020650" '//CPID
    '**************************************************
    '* ?? ??
    '**************************************************/
    REQ_DATA.Add "AMOUNT", "123" '//????? ???? ??
    REQ_DATA.Add "ITEMNAME", "TESTITEM" '//???
    REQ_DATA.Add "ORDERID", "W20000005457013" '//??? ????

    '/**************************************************
	' * ?? ??
	' * TAXTYPE : ???? ?? (????? ?? ??)
	' *      - D : ?? ??
	' *      - F : ??
	' *      - C : ?? ??
	'**************************************************/
    REQ_DATA.Add "TAXTYPE", "D" '//???? ?? (????? ?? ??)

     '/**************************************************
	 ' * ?? ??
	 ' * CASHRECEIPTTYPE : ????? ?? ??
	 ' *       - 0 : ??(????)
	 ' *       - 1 : ??(????)
	 ' * CASHRECEIPTINFO : ????? ?? ??
	 ' *       - ??(????) : ?????, ????? ????
	 ' *       - ??(????) : ??? ??
	 ' *       # CASHRECEIPTTYPE ??? ?? ?? ??
	 '**************************************************/
    REQ_DATA.Add "CASHRECEIPTUSERNAME", "TEST" '//??? ?
    REQ_DATA.Add "CASHRECEIPTTYPE", "0" '//????? ?? ??
    REQ_DATA.Add "CASHRECEIPTINFO", "01000000000" '//????? ?? ??

    '**************************************************
    '* ?? ??
    '**************************************************/
    REQ_DATA.Add "TXTYPE", "BILL"
    REQ_DATA.Add "SERVICETYPE", "CRS"

	Set RES_DATA = CallCashReceipt(REQ_DATA, false)

    '?? ??
    Response.Write("== ?? ????? ?? ?? ==<br>" & chr(13) & chr(10))
    FOR EACH key IN REQ_DATA
        Response.Write(key & " / " & REQ_DATA.Item(key) & "<br>" & chr(13) & chr(10))
    NEXT

    Response.Write("== ?? ????? ?? ?? ==<br>" & chr(13) & chr(10))
    FOR EACH key IN RES_DATA
        Response.Write(key & " / " & RES_DATA.Item(key) & "<br>" & chr(13) & chr(10))
    NEXT

%>
</body>
</html>