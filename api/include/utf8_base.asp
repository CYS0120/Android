<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
	Response.AddHeader "Set-Cookie", "SameSite=None; Secure; path=/; HttpOnly" ' ũ�� 80�̽�
    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"

	session.lcid	= 1042	'��¥���� �ѱ� �������� 

    ' // TODO : ����׸� ���� ����� ���� �ڵ�
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

<%
%>