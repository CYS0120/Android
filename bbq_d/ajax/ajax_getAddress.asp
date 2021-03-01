<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/include/db_open.asp"-->
<%
    Dim result, aCmd, aRs

    Dim addr_idx : addr_idx = Request("address_idx")

    If IsEmpty(addr_idx) Or IsNull(addr_idx) Or Trim(addr_idx) = "" Or Not IsNumeric(addr_idx) Then addr_idx = "" End If

    If addr_idx = "" Then
        result = "[]"
    Else
        Set aCmd = Server.CreateObject("ADODB.Command")

        With aCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_member_addr_select"

            .Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)
            .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, Session("userIdNo"))
            .Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

            Set aRs = .Execute
        End With
        Set aCmd = Nothing

        result = "["

        Dim i : i = 0
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

                result = result & "}"
                aRs.MoveNext
                i = i + 1
            Loop
        End If

        result  = result & "]"
    End If

    Response.Write result
%>