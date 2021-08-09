<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")
	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
		Response.Write "{""result"":""0000"",""message"":""OK""}"
		Response.End 
	End If

	MENUIDX		= GetReqStr("MENUIDX","")
	BRANCH_ID	= GetReqStr("BRANCH_ID","")

	If MENUIDX = "" Or BRANCH_ID = "" Then 
		Response.Write "{""result"":""0000"",""message"":""OK""}"
		Response.End 
	End If 

	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "UP_BT_EVENT"

		.Parameters.Append .CreateParameter("@BRAND_CD", adVarChar, adParamInput, 4, "01")
		.Parameters.Append .CreateParameter("@MENU_IDXS", adVarChar, adParamInput, 2000, MENUIDX)
		.Parameters.Append .CreateParameter("@BRANCH_ID", adVarChar, adParamInput, 10, BRANCH_ID)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing


	If Not (aRs.BOF Or aRs.EOF) Then
		Response.Write "{""result"":""9999"",""message"":"""&aRs("EVENT_MSG")&"""}"
		Response.End
	End If 

	Response.Write "{""result"":""0000"",""message"":""OK""}"
	Response.End 
%>