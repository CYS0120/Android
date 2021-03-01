<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.CharSet = "UTF-8"
%>
<!--#include virtual="/common/cv.asp"-->
<!--#include virtual="/include/db_open.asp"-->
<!--#include virtual="/include/func.asp"-->
<%
    Dim result
    Dim vAddrIdx : vAddrIdx = Request("addr_idx")

    If IsEmpty(vAddrIdx) Or IsNull(vAddrIdx) Or Trim(vAddrIdx) = "" Then vAddrIdx = 0

    Dim aCmd, pAddrIdx, ErrCode, ErrMsg

    result = "{"
    If vAddrIdx > 0 Then
        Set aCmd = Server.CreateObject("ADODB.Command")

        With aCmd
            .ActiveConnection = dbconn
            .NamedParameters = True
            .CommandType = adCmdStoredProc
            .CommandText = "bp_member_addr_update_main"

            .Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , vAddrIdx)
            .Parameters.Append .CreateParameter("@member_idx", adInteger, adParamInput, , Session("userIdx"))
            .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
            .Parameters.Append .CreateParameter("@paddr_idx", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRCODE", adInteger, adParamOutput)
            .Parameters.Append .CreateParameter("@ERRMSG", adVarChar, adParamOutput, 500)

            .Execute

            pAddrIdx = .Parameters("@paddr_idx").Value
            ErrCode = .Parameters("@ERRCODE").Value
            ErrMsg = .Parameters("@ERRMSG").Value
        End With
        Set aCmd = Nothing

        If ErrCode = 0 Then
            result = result & """result"":0, ""message"":""수정되었습니다."", ""addr_idx"":" & vAddrIdx & ", ""paddr_idx"":" & pAddrIdx
        Else
            result = result & """result"":" & ErrCode & ", ""message"":""" & ErrMsg & """, ""addr_idx"":" & vAddrIdx & ", ""paddr_idx"":" & pAddrIdx
        End If
    Else
        result = result & """result"":-1, ""message"":""정보가 불확실합니다."", ""addr_idx"":" & vAddrIdx & ", ""paddr_idx"":" & pAddrIdx
    End If
    result = result & "}"

    Response.Write result
%>