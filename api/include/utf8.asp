<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
	'Response.AddHeader "Set-Cookie", "SameSite=None; Secure; path=/; HttpOnly" ' 크롬 80이슈

	'크롬 80이슈 세션유실 방지
    Dim httpCookies, httpCookie, arrCookie, cookie_id, cookie_val
    httpCookies = Split(Request.ServerVariables("HTTP_COOKIE"),";")
    For Each httpCookie In httpCookies
        arrCookie = Split(httpCookie,"=")
        if ubound(arrCookie) > 0 then 'key-value 쌍 이루는 쿠키만 확인
            cookie_id = Trim(arrCookie(0))
            cookie_val = Trim(arrCookie(1))
            If Left(trim(httpCookie),12) = "ASPSESSIONID" Then
                Response.AddHeader "Set-Cookie", "" & cookie_id & "=" & cookie_val & ";SameSite=None; Secure; path=/; HttpOnly" ' 크롬 80이슈
            end if
        end if 
    next 
	
    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"

	session.lcid	= 1042	'날짜형식 한국 형식으로 

    '  // TODO : 디버그를 위해 만들어 놓은 코드
    IS_DEBUG = false
%>
<!--#include virtual="/api/include/g2.asp"-->
<%
'	HTTPHOST = Request.ServerVariables("HTTP_HOST")
'	if G2_SITE_MODE = "production" and HTTPHOST = "bbq.co.kr" then 
'		response.Redirect g2_bbq_d_url
'	end if 
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
<!--#include virtual="/api/include/keep_login.asp"-->

<%
%>