<!-- #include virtual="/inc/config.asp" -->
<%
	Response.AddHeader "pragma","no-cache"

    Dim userid, order_id, branch_id, sms_msg

	userid		= InjRequest("userid")
	order_id	= InjRequest("order_id")
	branch_id	= InjRequest("branch_id")
    sms_msg		= InjRequest("sms_msg")

'    Response.write "sms_msg : " & sms_msg & "<BR>"

    If Len(sms_msg) = 0 Then sms_msg = ""

    ' 취소 로그 기록
    query = "INSERT INTO BBQ.DBO.T_LOG_POS_CANCEL(ORDER_ID, CUST_ID, BRANCH_ID, SMS_MSG, DTS_REG) VALUES ('"&order_id&"','"&userid&"','"&branch_id&"','"&sms_msg&"',GETDATE());"
    conn.Execute(query)
'    Response.write query & "<BR>"

    host = CANCEL_BBQ_DOMAIN & "/pay/pay_cancel.asp"
    params = "order_id="&order_id&"&sms_msg="&sms_msg

    html_result = URL_Send(host, params)

'    Response.write "result_full : " & html_result & "<BR>"
    arr_result = Split(html_result, "|")

'    For i = 0 To ubound(arr_result, 1)
'        Response.write "result("&i&") : " & arr_result(i) & "<BR>"
'    Next
    

    If Trim(arr_result(0)) = "SUCC" Then
        res_cd = "0000"
        res_msg = ""
    Else
'        Response.write Trim(arr_result(1))
        res_cd = "9999"
        res_msg = arr_result(1)
    End If
    

'	response.write "userid" &userid& "<br>"
'	response.write "order_id" &order_id& "<br>"
'	response.write "branch_id" &branch_id& "<br>"
'	response.write "locationflag" &locationflag& "<br>"
'	response.write "tno" &tno& "<br>"
'	response.write "req_tx" &req_tx& "<br>"
'	response.write "res_cd" &res_cd& "<br>"
'	response.write "res_msg" &res_msg& "<br>"
'	response.end
	response.write "res_cd" &res_cd& "|"&res_msg

conn.Close
Set conn = Nothing 
%>