<!--#include virtual="/api/include/utf8.asp"-->
<%
	' 자동로그인 삭제.
	Response.Cookies("access_token") = ""
	Response.Cookies("access_token_secret") = ""
	Response.Cookies("refresh_token") = ""
	Response.Cookies("refresh_token_save") = ""
	Response.Cookies("token_type") = ""
	Response.Cookies("expires_in") = ""
	Response.Cookies("auto_login_yn") = ""
	Response.Cookies("bbq_app_type") = ""

    Session.Abandon()
%>