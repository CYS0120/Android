<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.CharSet = "UTF-8"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%
    Dim result
    REFERERURL	= Request.ServerVariables("HTTP_REFERER")
    If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
        Dim vAddrIdx : vAddrIdx = Request("addr_idx")
        Dim vHCode : vHCode = Request("h_code")

        If IsEmpty(vHCode) Or IsNull(vHCode) Or Trim(vHCode) = "" Then vHCode = "" End If

        Dim aCmd
        Dim ErrCode : ErrCode = -1
        Dim ErrMsg : ErrMsg = "저장에 실패했습니다."

        If Session("userIdx") = "" Then 
            result = "{""result"":""1"", ""message"":""계정 정보가 없습니다.""}"
        Else
            Set aCmd = Server.CreateObject("ADODB.Command")

            With aCmd
                .ActiveConnection = dbconn
                .NamedParameters = True
                .CommandType = adCmdStoredProc
                .CommandText = "bp_member_addr_update_hcode"

                .Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , vAddrIdx)
                .Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))
                .Parameters.Append .CreateParameter("@h_code", adVarChar, adParamInput, 20, vHCode)
                .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
                .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

                .Execute

                ErrCode = .Parameters("@ERRCODE").Value
                ErrMsg = .Parameters("@ERRMSG").Value
            End With
            Set aCmd = Nothing

            If ErrCode = 0 Then
                result = "{""result"":""0"", ""message"":""저장 되었습니다.""}"
            Else
                result = "{""result"":""1"", ""message"":""" & ErrMsg & "(" & vAddrIdx & " " & vHCode & ")""}"
            End If
        End If
    Else 
		result = "{""result"":""1"", ""message"":""잘못된 접근방식 입니다.""}"
    End If

    Response.Write result
%>