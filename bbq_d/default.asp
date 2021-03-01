<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/api/include/g2.asp"-->
<%
	' 모바일웹으로 전환
	viewType = request("viewType")
	If Len(viewType) = 0 And Len(request("pc")) > 0 Then viewType = "DESKTOP"

	If Len(viewType) = 0 Then viewType = ""
	If viewType <> "DESKTOP" Then
		mobrwz = "iPhone|iPod|BalckBerry|Android|Windows CE|LG|MOT|SAMSUNG|SonyEricsson|Mobile|Symbian|Opera Mobi|Opera Mini|IEmobile|Mobile|Igtelecom|PPC"
		spmobrwz = Split(mobrwz, "|")
		agent = Request.ServerVariables("HTTP_USER_AGENT")

		For i = 0 To Ubound(spmobrwz)
			If InStr(agent, spmobrwz(i)) > 0 Then
				Response.write "Go Mobile~<BR>"
				Response.Redirect(g2_bbq_m_url)
				Exit For
			End If
		Next
	End If
    Response.Redirect "/main.asp"
%>