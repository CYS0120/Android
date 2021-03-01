<%
    Session.CodePage = 65001
    Response.Charset = "UTF-8"

    Response.AddHeader "pragma","no-cache"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/pay/coupon_cancel.asp"-->
<%

    userid      = Request("userid")
    ORDER_ID    = Request("order_id")
    branch_id   = Request("branch_id")

'    Response.write "order_id : " & ORDER_ID & "<BR>"

    ' 주문정보
    set oRs=server.createobject("adodb.recordset")
    Set oCmd = Server.CreateObject("ADODB.Command")

    with oCmd
        .ActiveConnection = dbconn
        .CommandText = "BBQ_HOME.DBO.UP_ORDER_READ"
        .CommandType = adCmdStoredProc

        .Parameters.Append .CreateParameter("@ORDER_ID",advarchar,adParamInput,50, ORDER_ID)

        oRs.CursorLocation = adUseClient
        oRs.Open oCmd
    End With

    Set oCmd = Nothing

    If Not oRs.EOF Then
        branch_id = oRs("BRANCH_ID")
        AMOUNT = oRs("LAST_PRICE")
    Else
        branch_id = ""
        AMOUNT = 0
    End If

    set oRs=server.createobject("adodb.recordset")
    Set oCmd = Server.CreateObject("ADODB.Command")

    with oCmd
        .ActiveConnection = dbconn
        .CommandText = "BBQ.DBO.UP_ORDER_PAY_CANCEL"
        .CommandType = adCmdStoredProc

        .Parameters.Append .CreateParameter("@ORDR_ID",             advarchar, adParamInput, 40, order_id)
        .Parameters.Append .CreateParameter("@CANCELID",            advarchar, adParamInput, 30, "WEBADMIN")
        .Parameters.Append .CreateParameter("@CANCELNM",            advarchar, adParamInput, 20, "WEBADMIN")
        .Parameters.Append .CreateParameter("@BRANCH_ID",           advarchar, adParamInput, 10, branch_id)

        .Parameters.Append .CreateParameter("@iRETURN",             adinteger, adParamOutput, ,4)

        .Execute , , adExecuteNoRecords

        iReturn = .Parameters("@iRETURN")

    End with

    Dim RESULT, CPN_PARTNER, KTR, KTR_Result
    Dim i, nowDate
    nowDate = now

    Call Coupon_Cancel (ORDER_ID)

    Response.write "SUCC|취소 완료"
%>
