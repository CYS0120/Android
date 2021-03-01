<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<title>BBQ치킨</title>
<script type="text/javascript">
    $(function(){
        $("#o_form").submit();
    });
</script>
</head>
<body>

<%
    Dim order_idx : order_idx = Request("order_idx")
    Dim order_num : order_num = Request("order_num")
    Dim pay_method : pay_method = Request("pay_method")

    If IsEmpty(order_idx) Or IsNull(order_idx) Or Trim(order_idx) = "" Or Not IsNumeric(order_idx) Then order_idx = ""
    If IsEmpty(order_num) Or IsNull(order_num) Or Trim(order_num) = "" Then order_num = ""

    If order_idx = "" Or order_num = "" Then
%>
    <script type="text/javascript">
        alert("잘못된 접근입니다.");
        history.back();
    </script>
<%
        Response.End
    End If

    Dim aCmd, aRs

    Set aCmd = Server.CreateObject("ADODB.Command")
    With aCmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_order_select_one"

        .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)
        Set aRs = .Execute
    End With
    Set aCmd = Nothing


    If Not (aRs.BOF Or aRs.EOF) Then
        member_idx = aRs("member_id")
        member_type = aRs("member_type")
        member_idno = aRs("member_idno")
        danal_h_cpid = aRs("danal_h_cpid")
        danal_h_scpid = aRs("danal_h_scpid")
        order_amt = aRs("order_amt")
    End If

    Set aCmd = Server.CreateObject("ADODB.Command")
    With aCmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_pay_insert"

        .Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput,, member_idx)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)
        .Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, member_type)
        .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,,order_amt)
        .Parameters.Append .CreateParameter("@pay_status", adVarChar, adParamInput, 10, "PAY")
        .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamOutput)

        .Execute

        pay_idx = .Parameters("@pay_idx").Value
    End With
    Set aCmd = Nothing

    pay_transaction_id = Round(Rnd() * 10000000,0)
    pay_approve_num = Round(Rnd()*100000, 0)

    Set aCmd = Server.CreateObject("ADODB.Command")
    With aCmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_pay_detail_insert"

        .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput, , pay_idx)
        .Parameters.Append .CreateParameter("@pay_method", adVarChar, adParamInput, 10, pay_method)
        .Parameters.Append .CreateParameter("@pay_transaction_id", adVarChar, adParamInput, 50, pay_transaction_id)
        .Parameters.Append .CreateParameter("@pay_cpid", adVarChar, adParamInput, 50, danal_h_cpid)
        .Parameters.Append .CreateParameter("@pay_subcp", adVarChar, adParamInput, 50, danal_h_scpid)
        .Parameters.Append .CreateParameter("@pay_amt", adCurrency, adParamInput,,order_amt)
        .Parameters.Append .CreateParameter("@pay_approve_num", adVarChar, adParamInput, 50, pay_approve_num)
        .Parameters.Append .CreateParameter("@pay_result_code", adVarChar, adParamInput, 10, "0000")
        .Parameters.Append .CreateParameter("@pay_err_msg", adVarChar, adParamInput, 1000, "결제되었습니다.")
        .Parameters.Append .CreateParameter("@pay_result", adLongVarWChar, adParamInput, 2147483647, "SUCCESS")
        .Parameters.Append .CreateParameter("@pay_detail_idx", adInteger, adParamOutput)

        .Execute

        pay_detail_idx = .Parameters("@pay_detail_idx").Value
    End With
    Set aCmd = Nothing

    Set aCmd = Server.CreateObject("ADODB.Command")
    With aCmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_order_pay_insert"

        .Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)
        .Parameters.Append .CreateParameter("@pay_idx", adInteger, adParamInput, , pay_idx)

        .Execute
    End With
    Set aCmd = Nothing
%>
<form id="o_form" name="o_form" method="post" action="/order/orderComplete.asp">
    <input type="hidden" name="order_idx" value="<%=order_idx%>">
    <input type="hidden" name="order_num" value="<%=order_num%>">
    <input type="hidden" name="pay_method" value="<%=pay_method%>">
</form>
</body>
</html>
