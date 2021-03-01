<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/api/include/g2.asp"-->
<%
SERVER_PORT = Request.ServerVariables("SERVER_PORT")
if G2_SITE_MODE = "production" and SERVER_PORT = "80" then 
	response.Redirect g2_bbq_m_url
	response.end 
end if 

    Response.Redirect "/main.asp"
%>