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
<!--#include file="./inc/function.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr"/>
<link href="./css/style.css" type="text/css" rel="stylesheet" media="all" />
<title>*** �ſ�ī�� ���� ��û***</title>
</head>
<body>
<%
    gubun = GetReqStr("gubun","")
    domain = GetReqStr("domain","")
	param_str = ""

    If gubun = "Order" Then
        order_idx = GetReqNum("order_idx", "")
        order_num = GetReqStr("order_num","")
        pay_method = GetReqStr("pay_method","")

        Response.Cookies("GUBUN") = gubun
        response.Cookies("ORDER_IDX") = order_idx

		param_str = "?GUBUN="& gubun &"&ORDER_IDX="& order_idx &"&branch_id="& branch_id

        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_for_pay"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

            Set pRs = .Execute
        End With
        Set pCmd = Nothing
        ItemName = "BBQ Chicken"

        If Not (pRs.BOF Or pRs.EOF) Then
            USER_ID = pRs("member_idno")
            SUBCPID = pRs("danal_h_scpid")
            AMOUNT = pRs("order_amt")+pRs("delivery_fee")-pRs("discount_amt")
        Else
            USER_ID = ""
            SUBCPID = ""
            AMOUNT = ""
        End If

		' ����/�갣 =========================================================================================
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_detail_select_1138"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

            Set pRs = .Execute
        End With
        Set pCmd = Nothing

        If Not (pRs.BOF Or pRs.EOF) Then
            AMOUNT = AMOUNT + (pRs("menu_price")*pRs("menu_qty"))
        End If
		' =============================================================================DNCryptoCOM============

    ElseIf gubun = "Charge" Then
        ItemName = "BBQCard Charge"
        SUBCPID = ""

        cardSeq = GetReqStr("card_seq","")

        Response.Cookies("GUBUN") = gubun
        Response.Cookies("CARD_SEQ") = cardSeq

		param_str = "?GUBUN="& gubun &"&CARD_SEQ="& cardSeq &"&branch_id="& branch_id

        order_num = "P"&RIGHT("0000000" & cardSeq, 7)
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_payco_card_select_one"

            .Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , cardSeq)

            Set pRs = .Execute
        End With
        Set pCmd = Nothing

        If Not(pRs.BOF Or pRs.EOF) Then
            USER_ID = pRs("member_idno")
            AMOUNT = pRs("charge_amount")
        Else
            USER_ID = ""
            AMOUNT = ""
        End If
    ElseIf gubun = "Gift" Then
        ItemName = "BBQCard Gift"

        cardSeq = GetReqStr("card_seq","")

        Response.Cookies("GUBUN") = gubun
        Response.Cookies("CARD_SEQ") = cardSeq

		param_str = "?GUBUN="& gubun &"&CARD_SEQ="& cardSeq &"&branch_id="& branch_id

        order_num = "P"&RIGHT("0000000" & cardSeq, 7)
        Set pCmd = Server.CreateObject("ADODB.Command")
        With pCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_payco_card_select_one"

            .Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , cardSeq)

            Set pRs = .Execute
        End With
        Set pCmd = Nothing

        If Not(pRs.BOF Or pRs.EOF) Then
            USER_ID = pRs("member_idno")
            AMOUNT = pRs("charge_amount")
        Else
            USER_ID = ""
            AMOUNT = ""
        End If
    End If
    
    userAgent = ""
    Select Case domain
        Case "pc": userAgent = "WP" 
        Case "mobile": userAgent = "WM"
    End Select


	Dim REQ_DATA, RES_DATA				' ���� ����
    
	'*[ �ʼ� ������ ]**************************************
	Set REQ_DATA	= CreateObject("Scripting.Dictionary")

    '******************************************************
	'*  RETURNURL 	: CPCGI�������� Full URL�� �־��ּ���
	'*  CANCELURL 	: BackURL�������� Full URL�� �־��ּ���
	'******************************************************/
    RETURNURL = GetCurrentHost& "/pay/danal_card/CPCGI.asp"& param_str
    CANCELURL = GetCurrentHost& "/pay/danal_card/Cancel.asp"

    '**************************************************
    '* SubCP ����
	'**************************************************/
    REQ_DATA.Add "SUBCPID", SUBCPID

    '**************************************************
	'* ���� ����
	'**************************************************/
    REQ_DATA.Add "AMOUNT", AMOUNT
    REQ_DATA.Add "CURRENCY", "410"
    REQ_DATA.Add "ITEMNAME", ItemName
    REQ_DATA.Add "USERAGENT", userAgent
    REQ_DATA.Add "ORDERID", order_num
    REQ_DATA.Add "OFFERPERIOD", ""

    '**************************************************
	'* �� ����
	'**************************************************/
    REQ_DATA.Add "USERNAME", USER_ID '// ������ �̸�
    REQ_DATA.Add "USERID", USER_ID '// ����� ID
    REQ_DATA.Add "USEREMAIL", "" '// �Һ��� email����ó

    '**************************************************
	'* URL ����
	'**************************************************/
    REQ_DATA.Add "CANCELURL", CANCELURL
    REQ_DATA.Add "RETURNURL", RETURNURL

    '**************************************************
	'* �⺻ ����
	'**************************************************/
    REQ_DATA.Add "TXTYPE", "AUTH"
    REQ_DATA.Add "SERVICETYPE", "DANALCARD"
    REQ_DATA.Add "ISNOTI", "N"
    REQ_DATA.Add "BYPASSVALUE", "this=is;a=test;bypass=value" '// BILL���� �Ǵ� Noti���� �������� ��. '&'�� ����� ��� ���� �߸��ԵǹǷ� ����.

' ISDEBUG = TRUE
    if ISDEBUG Then
        FOR EACH key IN REQ_DATA
            Response.Write(key & " / " & REQ_DATA.Item(key) & "<br>" & chr(13) & chr(10))
        NEXT
    end if


	Set RES_DATA = CallCredit(REQ_DATA, false)
	
	IF RES_DATA.Item("RETURNCODE") = "0000" Then
%>
<form name="form" ACTION="<%=RES_DATA.Item("STARTURL")%>" METHOD="POST" >
    <input TYPE="HIDDEN" NAME="STARTPARAMS"  	VALUE="<%=RES_DATA.Item("STARTPARAMS")%>">
    <input TYPE="HIDDEN" NAME="CIURL"   VALUE="<%=GetCurrentHost%>/images/common/logo_header_bbq.png">
    <input TYPE="HIDDEN" NAME="COLOR"   VALUE="#FFFFFF">
</form>
<script>
    document.form.submit();
</script>
<%
	Else
		RETURNCODE	= RES_DATA.Item("RETURNCODE")
		RETURNMSG		= RES_DATA.Item("RETURNMSG")
		CANCELURL		= REQ_DATA.Item("CANCELURL")
%>
		<!--#include file="Error.asp"-->
<%
	End if
Dim giftcard_serial : giftcard_serial = Request("giftcard_serial")
Dim brand_code : brand_code = Request("brand_code")
Dim httpRequest

If giftcard_serial <> "" Then
' db ���ó�� (dbo.bt_giftcard)
    Sql = "UPDATE bt_giftcard SET used_date = SYSDATETIME(), order_num = '"& order_num &"' WHERE giftcard_number = '"& giftcard_serial &"'"
    dbconn.Execute(Sql)
' ��ǰ�� ��ȸ
    Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
    httpRequest.Open "GET", "http://api.bbq.co.kr/GiftCard_2.svc/GetGiftCard/"& giftcard_serial, False
    httpRequest.SetRequestHeader "AUTH_KEY", "BF84B3C90590"
    httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    httpRequest.Send
'��ǰ�� ��ȸ
'��ȸ ��ǰ�� text -> json
    Set oJSON = New aspJSON
    postResponse = "{""list"" : " & httpRequest.responseText & "}"
    oJSON.loadJSON(postResponse)
    Set this = oJSON.data("list")

	'U_CD_BRAND = this.item("U_CD_BRAND") '���귣���ڵ�
    'U_CD_PARTNER = this.item("U_CD_PARTNER") ' �������ڵ�
	'U_CD_BRAND = "01" '���귣���ڵ�
    'U_CD_PARTNER = "1146001" ' �������ڵ�
    U_CD_BRAND = brand_code '���귣���ڵ�
    U_CD_PARTNER = branch_id ' �������ڵ�
    AMT = this.item("AMT") ' �ݾ�
'��ȸ ��ǰ�� text -> json

' ��ǰ�� ���ó�� data set
    data = "{"
    data = data & """U_CD_BRAND"":""" & U_CD_BRAND & ""","
    data = data & """U_CD_PARTNER"":""" & U_CD_PARTNER & ""","
    data = data & """AMT"":""" & AMT & """"
    data = data & "}"
' ��ǰ�� ���ó�� data set
    Set httpRequest = nothing ' �ʱ�ȭ
' ��ǰ�� ���ó��
    Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
    httpRequest.Open "POST", "http://api.bbq.co.kr/GiftCard_2.svc/UseGiftCard/"& giftcard_serial, False
    httpRequest.SetRequestHeader "AUTH_KEY", "BF84B3C90590"
    httpRequest.SetRequestHeader "Content-Type", "application/raw"
    httpRequest.Send data
    Response.Write httpRequest.responseText
    Response.Write data
' ��ǰ�� ���ó��

End If


    ' DB �ݱ�
    DBclose()
%>
</body>
</html>
