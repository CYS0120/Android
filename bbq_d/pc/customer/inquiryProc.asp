<!--#include virtual="/api/include/utf8.asp"-->
<%
    q_type = GetReqStr("q_type", "")
    title = GetReqStr("title","")
    body = GetReqStr("body","")

    member_idno = Session("userIdNo")

    If q_type= "" Or title = "" Or body = "" Or member_idno = "" Then
        Response.Write "{""result"":1,""message"":""잘못된 정보입니다.""}"
        Response.End
    End If

    q_idx = ""
    msg = ""

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_member_q_insert"

        .Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, "01")
        .Parameters.Append .CreateParameter("@q_type", adVarChar, adParamInput, 20, q_type)
        .Parameters.Append .CreateParameter("@q_status", adVarChar, adParamInput, 20, "답변대기")
        .Parameters.Append .CreateParameter("@title", adVarChar, adParamInput, 100, title)
        .Parameters.Append .CreateParameter("@body", adLongVarWChar, adParamInput, 2147483647, body)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)

        Set rs = .Execute
    End With
    Set cmd = Nothing

    If Not (rs.BOF Or rs.EOF) Then
        q_idx = rs("q_idx")
        msg = rs("msg")
    End If

    If q_idx = "" Then
        Response.Write "{""result"":2,""message"":""등록되지 않았습니다.""}"
    Else
        Response.Write "{""result"":0,""message"":""등록되었습니다."",""q_idx"":"&q_idx&"}"
    End If
%>