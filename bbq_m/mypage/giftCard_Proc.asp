<!--#include virtual="/api/include/utf8.asp"-->
<%
    recv_nm = GetReqStr("recv_nm","")
    mobile = GetReqStr("mobile","")
    amount = GetReqStr("amount","")
    gift_msg = GetReqStr("gift_msg","")
    gubun = GetReqStr("gubun","")

    If gubun = "" Or recv_nm = "" Or mobile = "" Or amount = "" Then
        Response.Write "{""result"":1,""message"":""정보가 불확실합니다.""}"
        Response.End
    End If

    ' If CheckLogin() Then
    member_idx = Session("userIdx")
    member_idno = Session("userIdNo")
    member_type = "Member"
    ' Else
    '     Randomize Timer

    '     member_idx = 0
    '     member_idno = Round(Rnd * 10000000,0)
    '     member_type = "NonMember"
    ' End If

    seq = 0
    Set Cmd = Server.CreateObject("ADODB.Command")
    With Cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_payco_card_insert"

        .Parameters.Append .CreateParameter("@seq", adInteger, adParamOutput)
        .Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, gubun)
        .Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , member_idx)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)
        .Parameters.Append .CreateParameter("@member_type", adVarChar, adParamInput, 10, member_type)
        .Parameters.Append .CreateParameter("@target_name", adVarChar, adParamInput, 50, recv_nm)
        .Parameters.Append .CreateParameter("@target_mobile", adVarChar, adParamInput, 20, mobile)
        .Parameters.Append .CreateParameter("@gift_message", adVarChar, adParamInput, 1000, gift_msg)
        .Parameters.Append .CreateParameter("@charge_amount", adCurrency, adParamInput,,amount)
        .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
        .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

        .Execute

        seq = .Parameters("@seq").Value
        errCode = .Parameters("@ERRCODE").Value
        errMsg = .Parameters("@ERRMSG").Value
    End With
    Set Cmd = Nothing

    If seq > 0 Then
        Response.Write "{""result"":0, ""message"":""저장되었습니다."",""seq"":"& seq &"}"
    Else
        Response.Write "{""result"":2, ""message"":""처리되지 않았습니다.""}"
    End If

%>