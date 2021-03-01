<!--#include virtual="/api/include/utf8.asp"-->
<%
    order_num = GetReqStr("order_num","")

    Set oCancel = OrderCancelListForOrder(order_num)

    If oCancel.code = 0 Then
        Response.Write "{""result"":0,""message"":""취소되었습니다.""}"
    Else
        Response.Write "{""result"":1,""message"":""" & oCancel.mMessage & """}"
    End If
%>