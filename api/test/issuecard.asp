<!--#include virtual="/api/include/utf8.asp"-->
<%
    If Session("userIdNo") <> "" Then
        Set resC = CardAutoIssue

        If resC.mCode = 0 Then
            Response.Write "발급된 카드 : " & resC.mCardNo
        Else
            Response.Write "카드발급 실패 : " & resC.mMessage
        End If
    End If
%>