<%@ codepage="65001" language="VBScript" %>
<%
	Session.CodePage = 65001
	Response.Charset = "utf-8"
%>
<!--#include virtual="/api/include/func.asp"-->
<%
	'첨부파일 리턴
	FILENM	= InjRequest("FILENM")

SERVER_PORT = Request.ServerVariables("SERVER_PORT")
if SERVER_PORT = "80" then 
	response.Redirect "https://www.bbq.co.kr/board/Fileupload_result.asp?FILENM=" & Server.UrlEncode(FILENM)
	response.end 
end if 

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script>
	parent.SetFileName('<%=FILENM%>')
</script>
</head>
<body>
</body>
</html>