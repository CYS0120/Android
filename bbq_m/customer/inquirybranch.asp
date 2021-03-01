<!--#include virtual="/api/include/utf8.asp"-->

<%
	schVal	= InjRequest("SW")
	If FncIsBlank(schVal) Then 
%>

	<tr>
		<th colspan="2">검색어를 입력해 주세요.</th>
	</tr>

<%
		Response.End 
	End If
	If Len(schVal) < 2 Then 
%>

	<tr>
		<th colspan="2">검색어를 두자 이상 입력해 주세요.</th>
	</tr>

<%
		Response.End 
	End If 
	pageSize	= 1000	'목록 갯수
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_branch_search_mob"
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@Page", adInteger, adParamInput, , 1)
		.Parameters.Append .CreateParameter("@schVal", adVarChar, adParamInput, 100, schVal)
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		Set vRs = .Execute
	End With
	Set vCmd = Nothing
	If Not (vRs.BOF Or vRs.EOF) Then
		Do Until vRs.EOF
			BRANCH_ID	= vRs("BRANCH_ID")
			BRANCH_NAME	= vRs("BRANCH_NAME")
'			BRANCH_TEL	= vRs("BRANCH_TEL")
			BRANCH_ADDRESS		= vRs("BRANCH_ADDRESS")
%>

	<tr>
		<th>
			<ul>
				<li class="tbl_shopList_name"><%=BRANCH_NAME%></li>
				<li class="tbl_shopList_add"><%=BRANCH_ADDRESS%></li>
			</ul>
		</th>
		<th><button type="button" onclick="javascript:SetStore('<%=BRANCH_ID%>','<%=BRANCH_NAME%>');" class="btn btn-sm btn-gray">확인</button></th>
	</tr>

<%
			vRs.MoveNext
		Loop
	Else
%>

	<tr>
		<th colspan="2">검색 결과가 없습니다.</th>
	</tr>

<%
	End If
	Set vRs = Nothing
%>
