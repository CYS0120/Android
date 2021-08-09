<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식입니다.""}"
		Response.End 
	End If

    cardno = GetReqStr("cno","")

    If cardno = "" Then
        Response.Write "{""result"":1,""message"":""카드번호가 잘못되었습니다.""}"
        Response.End
    End If

    Set rC = CardRegRealCard(cardno, "", "")

    If rC.mCode = 0 Then
        Response.Write "{""result"":0,""message"":""등록되었습니다.""}"
    Else
        Response.Write "{""result"":3,""message"":""" & rC.mMessage & """}"
    End If
%>