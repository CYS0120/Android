<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
	Response.AddHeader "Set-Cookie", "SameSite=None; Secure; path=/; HttpOnly" ' 크롬 80이슈
    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"

	session.lcid	= 1042	'날짜형식 한국 형식으로 

    ' // TODO : 디버그를 위해 만들어 놓은 코드
%>
<!--#include virtual="/api/include/g2.asp"-->
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/includes/cv.asp"-->
<!--#include virtual="/api/include/json2.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/api/call_api.asp"-->
<!--#include virtual="/api/include/classes.asp"-->
<!--#include virtual="/api/membership.asp"-->
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