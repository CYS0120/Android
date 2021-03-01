<!--#include virtual="/api/include/utf8.asp"-->

<%
	PAGE		= InjRequest("PAGE")
	pageSize	= 2	'목록 갯수
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_Board_GetList"
		.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "LIST")
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@cPage", adInteger, adParamInput, , PAGE)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@Order", adVarChar, adParamInput, 5, "")
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@BBS_CODE", adVarChar, adParamInput, 5, "A01")
		Set vRs = .Execute

		TotalCount = .Parameters("@totalCount").Value
	End With
	Set vCmd = Nothing
	If Not (vRs.BOF Or vRs.EOF) Then
		Do Until vRs.EOF
			TITLE = vRs("TITLE")
			URL_LINK = vRs("URL_LINK")
%>

<div class="box">
	<iframe width="100%" height="420" src="https://www.youtube.com/embed/<%=URL_LINK%>?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1" title="BBQ CF" allowfullscreen=""></iframe>
	<p class="subject"><%=TITLE%></p>
</div>

<%
		vRs.MoveNext
	Loop
Else	%>

<script>
	alert('더이상 존재하지 않습니다');
</script>

<%
	End If
	Set vRs = Nothing
%>