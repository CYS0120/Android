<!--#include virtual="/api/include/utf8.asp"-->
<%
	Response.AddHeader "pragma","no-cache"

    gubun = GetReqStr("gubun","")
    
    If gubun = "Order" Then
        'PAY�� Point�� ���� ��츸 ���ó��'
        order_idx = GetReqStr("order_idx","")
        pay_idx = ""
        order_num = ""

        Set Cmd = Server.CreateObject("ADODB.Command")
        With Cmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_order_pay_select"

            .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)

            Set rs = .Execute
        End With
        Set Cmd = Nothing

        If Not (rs.BOF Or rs.EOF) Then
            pay_idx = rs("pay_idx")
            order_num = rs("order_num")
        End If
        Set rs = Nothing

        If pay_idx <> "" Then
            paycoDone = False
            Set Cmd = Server.CreateObject("ADODB.Command")
            With Cmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_pay_detail_select_method"

                .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,,pay_idx)
                .Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 20, "PAYCOPOINT")

                Set rs = .Execute
            End With
            Set Cmd = Nothing

            If Not (rs.BOF Or rs.EOF) Then
                Set resMC = OrderCancelListForOrder(order_idx)

                If resMC.mCode = 0 Then
                    paycoDone = True
                End If
            Else
                paycoDone = True
            End If
            Set rs = Nothing

            If paycoDone Then
                Set Cmd = Server.CreateObject("ADODB.Command")
                With Cmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_pay_update_status"

                    .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,, pay_idx)
                    .Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "Canceled")
                    .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                    .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput,500)

                    .Execute

                    errCode = .Parameters("@ERRCODE").Value
                    errMsg = .Parameters("@ERRMSG").Value
                End With
                Set Cmd = Nothing
            End If
        End If
    ElseIf gubun = "Charge" Or gubun = "Gift" Then
        seq = Request.Cookies("CARD_SEQ")
        '���´� �������...
        'pay_idx = -1��..?
        paycoDone = True

        If paycoDone Then
            Set Cmd = Server.CreateObject("ADODB.Command")
            With Cmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_payco_card_update_pay"

                .Parameters.Append .CreateParameter("@seq", adInteger, adParamInput, , seq)
                .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput,,-1)
                .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                .Execute

                errCode = .Parameters("@ERRCODE").Value
                errMsg = .Parameters("@ERRMSG").Value
            End With
            Set Cmd = Nothing
        End If
    End If    
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