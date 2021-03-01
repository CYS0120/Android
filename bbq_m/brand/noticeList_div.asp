<!--#include virtual="/api/include/utf8.asp"-->

<%
	PAGE		= InjRequest("PAGE")
	pageSize	= 5	'목록 갯수
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_Board_NoticeList"
		.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "LIST")
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@cPage", adInteger, adParamInput, , Page)
		.Parameters.Append .CreateParameter("@sKey", adVarChar, adParamInput, 20, "TITLE")
		.Parameters.Append .CreateParameter("@sWord", adVarChar, adParamInput, 50, SW)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		.Parameters.Append .CreateParameter("@BBS_CODE", adVarChar, adParamInput, 5, "A03")
		Set vRs = .Execute

		TotalCount = .Parameters("@totalCount").Value
	End With
	Set vCmd = Nothing
	If TotalCount = 0 Then
		first  = 1
	Else
		first  = pageSize * (Page - 1)
	End If 

	If Not (vRs.BOF Or vRs.EOF) Then
		num	= TotalCount - first
		Do Until vRs.EOF
%>

<div class="box">
	<p class="subject"><a href="./noticeView.asp?BIDX=<%=vRs("BIDX")%>"><%=vRs("TITLE")%></a></p>
	<ul class="info">
		<li class="date"><%=FormatDateTime(vRs("REG_DATE"),2)%></li>
	</ul>
</div>

<%
		num = num - 1
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