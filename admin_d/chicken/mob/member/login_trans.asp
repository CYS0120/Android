<%
Dim UserId

UserId = "bbq"

Session("UserId") = UserId

Response.Redirect("/mypage/mypage.asp")
Response.End()
%>