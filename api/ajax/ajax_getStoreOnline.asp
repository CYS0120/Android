<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":""0001"",""message"":""검색된 매장이 없습니다.""}"
		Response.End 
	End If

    Dim branch_id : branch_id = Request("branch_id")

    Dim cmd, rs

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_branch_select"

        .Parameters.Append .CreateParameter("@branch_id", adVarChar, adParamInput, 20, branch_id)

        Set rs = .Execute
    End With
    Set cmd = Nothing
    If Not (rs.BOF or rs.EOF) then
        rs.MoveFirst
		If rs("online_status") = "Y" Then 
			result = "{""result"":""0000"",""message"":""포장주문이 가능합니다.""}"
		Else
			result = "{""result"":""0001"",""message"":""해당 매장은 영업시간이 아닙니다.<br>잠시 후 다시 시도해주세요""}"
		End If 
	Else
		result = "{""result"":""0001"",""message"":""검색된 매장이 없습니다.""}"
    End If

    Response.Write result
%>