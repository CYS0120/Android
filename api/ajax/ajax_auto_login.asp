<!--#include virtual="/api/include/utf8.asp"-->
<%
'	If GetReferer = GetCurrentHost Then 
'	Else 
'		result = "[]"
'		Response.ContentType = "application/json"
'		Response.Write result
'		Response.End 
'	End If

	auto_chk = request("auto_chk")

	if auto_chk = "Y" then 
		Response.Cookies("refresh_token") = Request.Cookies("refresh_token_save")
		Response.Cookies("refresh_token").Expires = DateAdd("yyyy", 1, now())
	else
		Response.Cookies("refresh_token") = ""
		Response.Cookies("refresh_token").Expires = DateAdd("yyyy", 1, now())
	end if 

	response.write auto_chk
%>