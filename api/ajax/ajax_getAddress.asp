<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		result = "[]"
		Response.ContentType = "application/json"
		Response.Write result
		Response.End 
	End If

    addr_idx = GetReqStr("addr_idx","")

    If addr_idx = "" Then
        result = "[]"
    Else
        ' Response.Write addr_idx & "," & Session("userIdNo")
        Set aCmd = Server.CreateObject("ADODB.Command")

        With aCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_member_addr_select"

            .Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)
            .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
            .Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

            Set aRs = .Execute
        End With
        Set aCmd = Nothing

        result = "["

        i = 0
        If Not (aRs.BOF Or aRs.EOF) Then
            aRs.MoveFirst
            Do Until aRs.EOF
                If i > 0 Then result = result & ","
                
                result = result & "{"

                result = result & """addr_idx"":" & aRs("addr_idx")
                result = result & ",""member_idx"":" & aRs("member_idx")
                result = result & ",""member_idno"":""" & aRs("member_idno") & """"
                result = result & ",""member_type"":""" & aRs("member_type") & """"
                result = result & ",""addr_name"":""" & aRs("addr_name") & """"
                result = result & ",""zip_code"":""" & aRs("zip_code") & """"
                result = result & ",""addr_type"":""" & aRs("addr_type") & """"
                result = result & ",""address_jibun"":""" & aRs("address_jibun") & """"
                result = result & ",""address_road"":""" & aRs("address_road") & """"
                result = result & ",""address_main"":""" & aRs("address_main") & """"
                result = result & ",""address_detail"":""" & aRs("address_detail") & """"
                result = result & ",""sido"":""" & aRs("sido") & """"
                result = result & ",""sigungu"":""" & aRs("sigungu") & """"
                result = result & ",""sigungu_code"":""" & aRs("sigungu_code") & """"
                result = result & ",""roadname_code"":""" & aRs("roadname_code") & """"
                result = result & ",""bname"":""" & aRs("bname") & """"
                result = result & ",""b_code"":""" & aRs("b_code") & """"
                result = result & ",""mobile"":""" & aRs("mobile") & """"
                result = result & ",""is_main"":""" & aRs("is_main") & """"
                result = result & ",""lat"":""0"""
                result = result & ",""lng"":""0"""

                result = result & "}"
                aRs.MoveNext
                i = i + 1
            Loop
        End If

        result  = result & "]"
    End If

    Response.Write result
%>