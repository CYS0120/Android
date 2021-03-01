<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "D"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	BCD	= InjRequest("BCD")
	GB = InjRequest("GB")
	If FncIsBlank(BCD) Or FncIsBlank(GB) Then 
		Response.Write "&nbsp;"
		Response.End
	End If

	brand_code = FncBrandDBCode(BCD)
	SELCODE = ""	'구분선택
	Sql = "	Select code_idx, code_name From bt_code_item I LEFT JOIN bt_code_detail D ON I.item_idx = D.item_idx " & _
		"	Where brand_code = '"& brand_code &"' And code_gb='M' And code_kind ='"& GB &"' " & _
		"	Order by code_ord "
	Set Clist = conn.Execute(Sql)
	If Not Clist.eof Then 
		Do While Not Clist.Eof
			code_idx = Clist("code_idx")
			code_name = Clist("code_name")
			SELCODE = SELCODE & code_idx & "^" & code_name & "|"
			Clist.MoveNext
		Loop 
	Else
		Response.Write "&nbsp;"
		Response.End
	End If

	Response.Write "<ul>"
	ArrSELCODE = Split(SELCODE,"|")
	For Cnt = 0 To Ubound(ArrSELCODE)
		SetCODE = ArrSELCODE(Cnt)
		If Not FncIsBlank(SetCODE) Then 
			ArrSetCODE = Split(SetCODE,"^")
			code_idx = ArrSetCODE(0)
			code_name = ArrSetCODE(1)
			If GB = "A" Then %>
				<li><label><input type="checkbox" name="gubun_sel" value="<%=code_idx%>"><%=code_name%></label></li>
<%			ElseIf GB = "B" Or GB = "S" Then %>
				<label><input type="radio" name="kind_sel" value="<%=code_idx%>"><%=code_name%></label>
<%			ElseIf GB = "C" Then %>
				<li><label><input type="checkbox" name="sale_shop" value="<%=code_idx%>"><%=code_name%></label></li>
<%			ElseIf GB = "D" Then %>
				<li><label><input type="checkbox" name="smart_age" value="<%=code_idx%>"><%=code_name%></label></li>
<%			ElseIf GB = "E" Then %>
				<li><label><input type="checkbox" name="smart_taste" value="<%=code_idx%>"><%=code_name%></label></li>
<%			End If 
		End If 
	Next
	Response.Write "</ul>"
%>