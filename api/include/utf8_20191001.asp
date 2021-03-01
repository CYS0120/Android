<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"

	session.lcid	= 1042	'날짜형식 한국 형식으로 

HTTPHOST = Request.ServerVariables("HTTP_HOST")
if HTTPHOST = "bbq.co.kr" then 
	response.Redirect "http://www.bbq.co.kr"
end if 
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/includes/cv.asp"-->
<!--#include virtual="/api/include/json2.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<!--#include virtual="/api/call_api.asp"-->
<!--#include virtual="/api/include/classes.asp"-->
<!--#include virtual="/api/membership.asp"-->
<!--#include virtual="/api/barcode/barcode.asp"-->