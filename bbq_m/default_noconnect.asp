<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/api/include/g2.asp"-->
<%
SERVER_PORT = Request.ServerVariables("SERVER_PORT")
'if SERVER_PORT = "80" then 
'	response.Redirect "https://m.bbq.co.kr"
'	response.end 
'end if 

    tm_g = DateDiff("n", "2019-10-01 18:06:10", now())
    if tm_g >=0 and tm_g < 1 then
%>
        <iframe width=100% height=100% frameborder=0 framespacing=0 marginheight=0 marginwidth=0 scrolling=no vspace=0 src="/sorry.asp"></iframe>
<%
    else
        Response.Redirect "/main.asp"
    end if
%>