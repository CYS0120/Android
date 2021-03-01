<!--#include virtual="/api/include/utf8.asp"-->
<%
     order_idx = GetReqStr("order_idx","")

    If order_idx = "" Then
        Response.Write "{""result"":2,""message"":""유효한 주문번호가 아닙니다.""}"
        Response.End
    End If

    '주문 기본정보 조회'
    Set pCmd = Server.CreateObject("ADODB.Command")
    With pCmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_order_select_one_membership"

        .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

        Set pRs = .Execute
    End With
    Set pCmd = Nothing

    If Not (pRs.BOF Or pRs.EOF) Then
        ' reqC.mMerchantCode = pRs("branch_id")
        branch_id = pRs("branch_id")
        order_num = pRs("order_num")
    Else
        Response.Write "{""result"":1,""message"":""주문정보가 잘못되었습니다.""}"
        Response.End
    End If
    
	'Response.write order_num
    Set oCancel = OrderCancelListForOrderV2(order_num, branch_id)

'    Set oCancel = OrderCancelListForOrder(order_num)

    If oCancel.mCode = 0 Then
        Response.Write "{""result"":0,""message"":""취소되었습니다.""}"
    Else
        Response.Write "{""result"":1,""message"":""" & oCancel.mMessage & """}"
	End If
%>