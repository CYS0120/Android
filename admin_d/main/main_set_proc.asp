<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "A"
	PROCESS_PAGE = "Y"
	CUR_PAGE_SUBCODE = ""
	CD			= InjRequest("CD")
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	brand_code	= FncBrandDBCode(CD)
	IMGNUM		= InjRequest("IMGNUM")

	If IMGNUM = "WN" Then	'WEB 삭제 
		Sql = "Delete From bt_main_img Where brand_code='"& brand_code &"' And main_kind like 'W%'"
		conn.Execute Sql
	ElseIf IMGNUM = "MN" Then	'모바일 삭제
		Sql = "Delete From bt_main_img Where brand_code='"& brand_code &"' And main_kind='M1'"
		conn.Execute Sql
	Else
		If IMGNUM = "M1" Then
			main_kind	= "M1"
			main_text	= InjRequest("MMAINTEXT1")
			main_img	= InjRequest("MMAINIMG1")
			link_url	= InjRequest("MLINKURL1")
			link_target	= InjRequest("MLINKTARGET1")
			BAN_ORD		= 1		'InjRequest("MBAN_ORD1")
			If FncIsBlank(link_target) Then link_target = "S"
			If Not FncIsBlank(main_img) Then 
				Sql = "Update bt_main_img Set main_img='"& main_img &"', main_text='"& main_text &"', link_url='"& link_url &"', link_target='"& link_target &"', BAN_ORD='"& BAN_ORD &"' Where brand_code='"& brand_code &"' And main_kind='"& main_kind &"'"
				conn.Execute Sql, Uplow
				If Uplow > 0 Then 
				Else 
					Sql = "Insert Into bt_main_img(brand_code, main_kind, main_img, main_text, link_url, link_target) values('"& brand_code &"','"& main_kind &"','"& main_img &"','"& main_text &"','"& link_url &"','"& link_target &"')"
					conn.Execute(Sql)
				End If
			End If
		Else 

			i = 0
			num = Cint(replace(IMGNUM, "W", ""))
			sql = ""
			Do while i < num
				i = i + 1
				
				main_kind 	= "W"&i
				main_text	= InjRequest("WMAINTEXT"&i)
				main_img	= InjRequest("WMAINIMG"&i)
				link_url	= InjRequest("WLINKURL"&i)
				link_target	= InjRequest("WLINKTARGET"&i)
				BAN_ORD		= InjRequest("WBAN_ORD"&i)
				date_s		= replace(InjRequest("txtFromDate_"&i), "-", "")
				date_e		= replace(InjRequest("txtToDate_"&i), "-", "")
				date_yn		= InjRequest("date_yn_"&i)

				sql = sql & "EXEC UP_BT_MAIN_IMG 'WEB', '"& brand_code &"', '"& main_kind &"', '"& main_text &"', '"& main_img &"', '"& link_url &"', '"& link_target &"', '"& BAN_ORD &"', '"& date_s &"', '"& date_e &"', '"& date_yn &"', '"& SITE_ADM_ID &"'" & vbCrLf
			Loop

			sql = sql & "EXEC UP_BT_MAIN_IMG 'DELETE_W', '', '"& IMGNUM &"', '', '', '', '', '', '', '', '', ''"
			' response.write sql
			conn.Execute sql

		End If
	End If
	Response.Write "Y^적용되었습니다."
%>