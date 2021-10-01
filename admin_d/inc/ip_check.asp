<%
CHECK_IP = GetIPADDR()
ALLOW_IP = 0

Sql = "EXEC BBQ.DBO.UP_ADMIN_ALLOW_IP 'S', '"&CHECK_IP&"', '', '', '', '' "
Set Rlist = conn.Execute(Sql)
If NOT Rlist.eof Then 
	ALLOW_IP = Rlist("INCLUDE_IP")
END IF

If ALLOW_IP = 0 Then 
	Response.Redirect "https://www.bbq.co.kr"
End If
%>