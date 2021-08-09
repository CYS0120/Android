<!--#include virtual="/api/include/utf8.asp"-->
<%
	If GetReferer = GetCurrentHost Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
		Response.End 
	End If

    addr_idx = GetReqStr("addr_idx","")

    If addr_idx = "" Or Not IsNumeric(addr_idx) Then
        Response.Write "{""result"":1,""message"":""정보가 불확실합니다.""}"
        Response.End
    End If

    If Not CheckLogin() Then
        Response.Write "{""result"":2,""message"":""로그인이 필요합니다.""}"
        Response.End
    End If

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_member_addr_delete"

        .Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50 , Session("userIdNo"))
        .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
        .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

        .Execute

        errCode = .Parameters("@ERRCODE").Value
        errMsg = .Parameters("@ERRMSG").Value
    End With
    Set cmd = Nothing

    If errCode <> 0 Then
        Response.Write "{""result"":0,""message"":""삭제되었습니다.""}"
        Response.End
    Else
        Response.Write "{""result"":3,""message"":""삭제되지 않았습니다.""}"
        Response.End
    End If
%>