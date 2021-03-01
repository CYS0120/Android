<!-- #include virtual="/inc/config.asp" -->
<%
	server.scripttimeout = 10000

    Dim order_id
    order_id = InjRequest("order_id")

    If FncIsBlank(order_id) Then
%>
<script language="javascript">alert("주문번호가 없습니다.");</script>
<%
        Response.end
    End If

    query = "BBQ.DBO.UP_ORDER_RESEND_MESSAGE '" & order_id & "'"
    conn.Execute(query)
%>
<script language="javascript">alert("문자 재발송 하였습니다.");</script>