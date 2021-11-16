<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/coop_exchange_proc.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")

	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다.""}"
		Response.End 
	End If

    Dim PIN
    PIN = GetReqStr("PIN","")
    ' response.write PIN
    ' response.end

    Dim cmd, oRs

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = BBQHOME_DB & ".DBO.UP_COUPON_INFO_DUP"

        .Parameters.Append .CreateParameter("@TP", adVarChar, adParamInput, 5, "SEL")
        .Parameters.Append .CreateParameter("@PIN", adVarChar, adParamInput, 1000, PIN)

        Set oRs = .Execute

    End With
    Set cmd = Nothing

    If NOT oRs.EOF Then
        DUP_YN = oRs("DUP_YN")
        CPNID = oRs("CPNID")
    Else
        DUP_YN = ""
        CPNID = ""
    End If

    ' Response.Write DUP_YN
    Response.Write "{""dupYn"":""" & DUP_YN & """,""cpnId"":""" & CPNID & """}"
    Response.End

%>