<!--#include virtual="/api/include/utf8.asp"-->
<%
    idx          = GetReqStr("idx", "0")
	member_hp    = GetReqStr("member_hp", "")
	member_email = GetReqStr("member_email", "")

	org_name = replace(GetReqStr("org_name", ""), "'", "")
	visit_city = GetReqStr("visit_city", "")
	visit_address = replace(GetReqStr("address_main", "") & " " & GetReqStr("address_detail", ""), "'", "")
	visit_ym = GetReqStr("visit_ym", "")
	visit_date = GetReqStr("visit_date", "1900-01-01")
    
    title = replace(GetReqStr("title",""), "'", "")
    body = replace(GetReqStr("body",""), "'", "")
	filename = GetReqStr("filename", "")
	filename2 = GetReqStr("filename2", "")
	filename3 = GetReqStr("filename3", "")
	del_yn = GetReqStr("del_yn", "")

    If Session("userIdNo") = "" Then
        Response.Write "{""result"":1,""message"":""로그인 후 이용가능합니다.""}"
        Response.End
    End If
    if del_yn = "Y" then 
    else 
        If Not isDate(visit_date) Then
            Response.Write "{""result"":1,""message"":""방문희망일이 올바르지 않습니다.""}"
            Response.End
        End If

        If title = "" Or body = "" Then
            Response.Write "{""result"":1,""message"":""잘못된 정보입니다.""}"
            Response.End
        End If
    end if 
    
    q_idx = ""
    msg = ""

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_member_bbcar_modify"

        .Parameters.Append .CreateParameter("@idx", adInteger, adParamInput, , idx)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
        .Parameters.Append .CreateParameter("@member_id",   adVarChar, adParamInput, 50, Session("userId"))
        .Parameters.Append .CreateParameter("@member_name", adVarChar, adParamInput, 50, Session("userName"))
        .Parameters.Append .CreateParameter("@member_hp",   adVarChar, adParamInput, 20, member_hp)
        .Parameters.Append .CreateParameter("@member_email", adVarChar, adParamInput, 100, member_email)
        
        .Parameters.Append .CreateParameter("@org_name", adVarChar, adParamInput, 1000, org_name)
        .Parameters.Append .CreateParameter("@visit_city", adVarChar, adParamInput, 50, visit_city)
        .Parameters.Append .CreateParameter("@visit_address", adVarChar, adParamInput, 1000, visit_address)
        .Parameters.Append .CreateParameter("@visit_ym", adVarChar, adParamInput, 7, visit_ym)
        .Parameters.Append .CreateParameter("@visit_date", adDBTimeStamp, adParamInput, , visit_date)

        .Parameters.Append .CreateParameter("@title", adVarChar, adParamInput, 100, title)
        .Parameters.Append .CreateParameter("@body", adLongVarWChar, adParamInput, 2147483647, body)
        .Parameters.Append .CreateParameter("@filename", adVarChar, adParamInput, 512, filename)
        .Parameters.Append .CreateParameter("@filename2", adVarChar, adParamInput, 512, filename2)
        .Parameters.Append .CreateParameter("@filename3", adVarChar, adParamInput, 512, filename3)
        .Parameters.Append .CreateParameter("@del_yn", adVarChar, adParamInput, 1, del_yn)

        Set rs = .Execute
    End With

    If Not (rs.BOF Or rs.EOF) Then
        q_idx = rs("q_idx")
        msg = rs("msg")
    Else
        Response.Write "{""result"":-1,""message"":""작업 중 오류가 발생했습니다.""}"
    End If
    Set rs = Nothing 
    Set cmd = Nothing

    If q_idx = "" Then
        Response.Write "{""result"":-1,""message"":""" & msg & """}"
    Else
        Response.Write "{""result"":0,""message"":""" & msg & """,""q_idx"":"& q_idx &"}"
    End If
%>