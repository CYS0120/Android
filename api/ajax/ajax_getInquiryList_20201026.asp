<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":1,""message"":""잘못된 접근방식 입니다."",""totalCount"":0}"
		Response.End 
	End If

    mode = GetReqStr("mode", "LIST")
    brand_code = GetReqStr("brand_code", "")
    q_idx = GetReqStr("q_idx",0)
    pageSize = GetReqNum("pageSize", 10)
    curPage = GetReqNum("curPage", 1)

    result = ""
    totalCount = 0
    member_idno = Session("userIdNo")

    If member_idno = "" Then
        result = "{""result"":1,""message"":""정보가 부족합니다."",""totalCount"":0}"
    Else
        If mode = "ONE" Then
            If q_idx = 0 Then
                result = "{""result"":1,""message"":""정보가 부족합니다."",""totalCount"":0}"
            Else
                Set cmd = Server.CreateObject("ADODB.Command")
                With cmd
                    .ActiveConnection = dbconn
                    .NamedParameters = True
                    .CommandType = adCmdStoredProc
                    .CommandText = "bp_member_q_select"

                    .Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, mode)
                    .Parameters.Append .CreateParameter("@q_idx", adParamInput, adParamInput, , q_idx)
                    .Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, brand_code)
                    .Parameters.Append .CreateParameter("@memeber_idno", adVarChar, adParamInput, 50, member_idno)

                    Set rs = .Execute
                End With
                Set cmd = Nothing

                If Not (rs.BOF Or rs.EOF) Then
                    result = "{"
                    result = result & """q_idx"":" & rs("q_idx")
                    result = result & ",""brand_code"":""" & rs("brand_code") & """"
                    result = result & ",""q_type"":""" & rs("q_type") & """"
                    result = result & ",""q_status"":""" & rs("q_status") & """"
                    result = result & ",""title"":""" & rs("title") & """"
                    result = result & ",""body"":""" & Replace(rs("body"),vbCrLf,"<br>") & """"
                    result = result & ",""regdate"":""" & rs("regdate") & """"
                    result = result & ",""a_date"":""" & rs("a_date") & """"
                    result = result & ",""a_body"":"""& Replace(rs("a_body"),vbCrLf, "<br>") & """"
                    result = result & "}"

                    result = "{""result"":0,""message"":"""",""totalCount"":1,""data"":" & result & "}"
                Else
                    result = "{""result"":0,""message"":""검색된 결과가 없습니다."",""totalCount"":0}"
                End If
                Set rs = Nothing
            End If
        ElseIf mode = "LIST" Then
            Set cmd = Server.CreateObject("ADODB.Command")
            With cmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_member_q_select"

                .Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, mode)
                .Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, brand_code)
                .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, member_idno)
                .Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
                .Parameters.Append .CreateParameter("@curPage", adInteger, adParamInput, , curPage)
                .Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

                Set rs = .Execute

                totalCount = .Parameters("@totalCount").Value
            End With
            Set cmd = Nothing

            If Not (rs.BOF Or rs.EOF) Then
                rs.MoveFirst

                result = ""
                Do Until rs.EOF
                    If result <> "" Then result = result & ","
                    result = result & "{"
                    result = result & """q_idx"":" & rs("q_idx")
                    result = result & ",""brand_code"":""" & rs("brand_code") & """"
                    result = result & ",""q_type"":""" & rs("q_type") & """"
                    result = result & ",""q_status"":""" & rs("q_status") & """"
                    result = result & ",""title"":""" & rs("title") & """"
                    result = result & ",""body"":""" & Replace(rs("body"), vbCrLf, " ") & """"
                    result = result & ",""regdate"":""" & rs("regdate") & """"
                    result = result & ",""a_date"":""" & rs("a_date") & """"
                    If IsNull(rs("a_body")) Then
                        result = result & ",""a_body"":"""& rs("a_body") & """"
                    Else
                        result = result & ",""a_body"":"""& Replace(rs("a_body"), vbCrLf, " ") & """"
                    End If
                    result = result & "}"

                    rs.MoveNext
                Loop
                result = "{""result"":0,""message"":"""",""totalCount"":"&totalCount&",""data"":[" & result & "]" & "}"
            Else
                result = "{""result"":0,""message"":""검색된 결과가 없습니다."",""totalCount"":0}"
            End If
        End If
    End If

    Response.Write result
%>