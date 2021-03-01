<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	MODE	= InjRequest("MODE")
	If FncIsBlank(MODE) Then 
		Response.Write "E^잘못된 접근방식입니다"
		Response.End
	End If 

	If MODE = "INSERT" Then
		code_gb		= InjRequest("code_gb")
		BRAND_CODE	= InjRequest("BRAND_CODE")
		code_gb		= InjRequest("code_gb")
		code_kind	= InjRequest("code_kind")
		code_use	= InjRequest("code_use")
		code_name	= InjRequest("WCODENAME")

		If FncIsBlank(code_name) Then 
			Response.Write "E^항목명을 입력해 주세요"
			Response.End
		End If 

		Sql = "Select item_idx From bt_code_item Where brand_code='"& BRAND_CODE & "' And code_gb='"& code_gb & "' And code_kind='"& code_kind & "'"
		Set RsCheck = conn.Execute(Sql)
		If RsCheck.Eof Then
			Sql = "Select isnull(max(item_idx),0)+1 as item_idx From bt_code_item"
			Set MaxID = conn.Execute(Sql)
			item_idx = MaxID("item_idx")
			
			Sql = "	Insert Into bt_code_item(item_idx, brand_code, code_gb, code_kind, code_use) " & _
				"	Values("& item_idx &",'"& brand_code &"','"& code_gb &"','"& code_kind &"','"& code_use &"')"
			conn.Execute(Sql)
		Else
			item_idx = RsCheck("item_idx")
		End If

'		code_name	= Replace(code_name,"'","''")
		Sql = "	Insert Into bt_code_detail(item_idx, code_name, code_ord) " & _
			"	Values("& item_idx &",'"& code_name &"', (Select isnull(max(code_ord),0)+1 From bt_code_detail Where item_idx="& item_idx &") )"
		conn.Execute(Sql)

		Response.Write "Y^등록 되었습니다"
		Response.End

	ElseIf MODE = "UPNAME" Then
		code_idx	= InjRequest("CheckIdx")
		code_name	= InjRequest("MCODENAME")
		
		If FncIsBlank(code_idx) Then 
			Response.Write "E^변경할 항목을 선택해 주세요"
			Response.End
		End If 
		If FncIsBlank(code_name) Then 
			Response.Write "E^항목명을 입력해 주세요"
			Response.End
		End If 

'		code_name	= Replace(code_name,"'","''")
		Sql = "	Update bt_code_detail Set code_name='"& code_name &"' Where code_idx=" & code_idx
		conn.Execute(Sql)

		Response.Write "Y^변경 되었습니다"
		Response.End

	ElseIf MODE = "DEL" Then
		code_idx	= InjRequest("CheckIdx")
		
		If FncIsBlank(code_idx) Then 
			Response.Write "E^삭제할 항목을 선택해 주세요"
			Response.End
		End If 

		Sql = "	Delete From bt_code_detail Where code_idx=" & code_idx
		conn.Execute(Sql)

		Response.Write "Y^삭제 되었습니다"
		Response.End

	ElseIf MODE = "USE" Then
		item_idx	= InjRequest("item_idx")
		code_use	= InjRequest("code_use")
		
		If FncIsBlank(item_idx) Then 
			Response.Write "E^데이터를 먼저 생성해 주세요"
			Response.End
		End If 

		Sql = "	Update bt_code_item Set code_use='"& code_use &"' Where item_idx=" & item_idx
		conn.Execute(Sql)

		Response.Write "Y^적용 되었습니다"
		Response.End

	ElseIf MODE = "ORDER" Then
		code_idx	= InjRequest("code_idx")
		If FncIsBlank(code_idx) Then 
			Response.Write "E^변경할 항목이 없습니다"
			Response.End
		End If
		arrcode_idx = Split(code_idx,",")
		For Cnt = 0 To Ubound(arrcode_idx)
			code_idx = arrcode_idx(Cnt)
			code_ord = Cnt + 1	

			Sql = "	Update bt_code_detail Set code_ord='"& code_ord &"' Where code_idx=" & code_idx
			conn.Execute(Sql)
		Next 				

		Response.Write "Y^적용 되었습니다"
		Response.End
	Else
		Response.Write "E^잘못된 접근방식입니다"
		Response.End
	End If 
%>
