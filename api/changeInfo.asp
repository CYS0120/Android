<!--#include virtual="/api/include/utf8.asp"-->
<%
    info = GetReqStr("info", "")

    If info <> "" Then
        If info = "mobile" Then
            Set api = New ApiCall

            api.SetMethod = "POST"
            api.RequestContentType = "application/json"
            api.Authorization = "Bearer " & Session("access_token")
            api.SetData = "{""scope"":""ADMIN""}"
            api.SetUrl = PAYCO_AUTH_URL & "/api/member/me"

            result = api.Run

            ' Response.Write "VVV" & result

            Set uJ = JSON.Parse(result)

            If JSON.hasKey(uJ, "data") Then
                If JSON.hasKey(uJ.data, "member") Then
                    If JSON.hasKey(uJ.data.member, "cellphoneNumber") Then
                        useridno = uJ.data.member.idNo
                        mobile = uJ.data.member.cellphoneNumber
                    ENd If
                End If
            End if

            If mobile <> "" Then
                Set cmd = Server.CreateObject("ADODB.Command")
                sql = "UPDATE bt_member SET member_mobile = '" & mobile & "' WHERE member_idno = '" & useridno & "'"

                cmd.ActiveConnection = dbconn
                cmd.CommandType = adCmdText
                cmd.CommandText = sql

                cmd.Execute
            End If

        End If
    End If

    ' Response.Redirect "/mypage/memEdit.asp"
%>
<script type="text/javascript">
    window.opener.location.reload(true);
    window.close();
</script>