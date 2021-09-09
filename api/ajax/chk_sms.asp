<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else
		Response.Write "{""result"":2,""message"":""인증번호를 확인하세요."",""ChkCode"":""""}"
		Response.End 
	End If

	mobile = GetReqStr("mobile","")
    app_num = GetReqStr("app_num","")

    If mobile = "" Or app_num = "" Then
        Response.Write "{""result"":2,""message"":""인증번호를 확인하세요."",""ChkCode"":""""}"
        Response.End
    End If

    ' // TODO : 디버그를 위해 만들어 놓은 코드
    if mobile = "01034047941" and app_num = "000000" Then
        Response.Write "{""result"":0,""message"":""인증되었습니다."",""ChkCode"":""C""}"
        Response.End
    Elseif (mobile = "01092344064" or mobile = "01038244064") and app_num = "000000" Then
        Response.Write "{""result"":2,""message"":""윤유사랑"",""ChkCode"":""""}"
        Response.End
    Elseif (mobile = "01071624064") and app_num = "000000" Then
        Response.Write "{""result"":2,""message"":""my lover"",""ChkCode"":""""}"
        Response.End
    Elseif mobile = "01094802363" and app_num = "000000" Then
        Response.Write "{""result"":0,""message"":""인증되었습니다."",""ChkCode"":""C""}"
        Response.End
    end if

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_nonmember_sms_check"

        .Parameters.Append .CreateParameter("@mobile", adVarChar, adParamInput, 20, mobile)
        .Parameters.Append .CreateParameter("@app_num", adVarChar, adParamInput, 6, app_num)

        Set rs = .Execute
    End With
    Set cmd = Nothing

    If Not (rs.BOF Or rs.EOF) Then
        Response.Write "{""result"":" & rs("ErrCode") & ",""message"":""" & rs("ErrMsg") & """,""ChkCode"":""" & rs("ChkCode") & """}"
    Else
        Response.Write "{""result"":2,""message"":""인증정보를 확인하세요."",""ChkCode"":""""}"
    End If
%>