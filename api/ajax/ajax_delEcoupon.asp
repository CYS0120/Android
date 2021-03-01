<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
'		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
'		Response.End 
	End If

	txtPIN = GetReqStr("txtPIN","")

    If txtPIN = "" Or Not IsNumeric(txtPIN) Then
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
        .CommandText = "bt_member_coupon_delete"

        .Parameters.Append .CreateParameter("@c_code", adVarChar, adParamInput, 200, txtPIN)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 100 , Session("userIdNo"))
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