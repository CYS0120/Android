<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
		Response.End 
	End If

    qidx = GetReqStr("qidx","")

    If qidx = "" Then
        Response.Write "{""result"":1,""message"":""삭제할 내역이 없습니다.""}"
        Response.End
    End If

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_member_q_delete"

        .Parameters.Append .CreateParameter("@q_idx", adInteger, adParamInput,,qidx)
        .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
        .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)
		.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))

        .Execute

        errCode = .Parameters("@ERRCODE").Value
        errMsg = .Parameters("@ERRMSG").Value
    End With
    Set cmd = Nothing

    Response.Write "{""result"":" & errCode & ",""message"":""" & errMsg & """}"
%>