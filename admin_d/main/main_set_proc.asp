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
			If IMGNUM = "W1" Or IMGNUM = "W2" Or IMGNUM = "W3" Or IMGNUM = "W4" Or IMGNUM = "W5" Then
				main_kind	= "W1"
				main_text	= InjRequest("WMAINTEXT1")
				main_img	= InjRequest("WMAINIMG1")
				link_url	= InjRequest("WLINKURL1")
				link_target	= InjRequest("WLINKTARGET1")
				BAN_ORD		= InjRequest("WBAN_ORD1")
				date_s		= replace(InjRequest("txtFromDate_1"), "-", "")
				date_e		= replace(InjRequest("txtToDate_1"), "-", "")
				date_yn		= InjRequest("date_yn_1")
				If FncIsBlank(link_target) Then link_target = "S"
				If Not FncIsBlank(main_img) Then 
					Sql = "Update bt_main_img Set main_img='"& main_img &"', main_text='"& main_text &"', link_url='"& link_url &"', link_target='"& link_target &"', BAN_ORD='"& BAN_ORD &"', date_s='"& date_s &"', date_e='"& date_e &"', date_yn='"& date_yn &"', emp_cd='"&SITE_ADM_ID&"' Where brand_code='"& brand_code &"' And main_kind='"& main_kind &"'"
					conn.Execute Sql, Uplow
					If Uplow > 0 Then 
					Else 
						Sql = "Insert Into bt_main_img(brand_code, main_kind, main_img, main_text, link_url, link_target, date_s, date_e, date_yn, emp_cd) values('"& brand_code &"','"& main_kind &"','"& main_img &"','"& main_text &"','"& link_url &"','"& link_target &"','"& date_s &"','"& date_e &"','"& date_yn &"','"&SITE_ADM_ID&"')"
						conn.Execute(Sql)
					End If
				End If

				If IMGNUM = "W1" Then 
					Sql = "Delete From bt_main_img Where brand_code='"& brand_code &"' And main_kind IN ('W2','W3','W4','W5')"
					conn.Execute Sql
				End If
			End If

			If IMGNUM = "W2" Or IMGNUM = "W3" Or IMGNUM = "W4" Or IMGNUM = "W5" Then
				main_kind	= "W2"
				main_text	= InjRequest("WMAINTEXT2")
				main_img	= InjRequest("WMAINIMG2")
				link_url	= InjRequest("WLINKURL2")
				link_target	= InjRequest("WLINKTARGET2")
				BAN_ORD		= InjRequest("WBAN_ORD2")
				date_s		= replace(InjRequest("txtFromDate_2"), "-", "")
				date_e		= replace(InjRequest("txtToDate_2"), "-", "")
				date_yn		= InjRequest("date_yn_2")
				If FncIsBlank(link_target) Then link_target = "S"
				If Not FncIsBlank(main_img) Then 
					Sql = "Update bt_main_img Set main_img='"& main_img &"', main_text='"& main_text &"', link_url='"& link_url &"', link_target='"& link_target &"', BAN_ORD='"& BAN_ORD &"', date_s='"& date_s &"', date_e='"& date_e &"', date_yn='"& date_yn &"', emp_cd='"&SITE_ADM_ID&"' Where brand_code='"& brand_code &"' And main_kind='"& main_kind &"'"
					conn.Execute Sql, Uplow
					If Uplow > 0 Then 
					Else 
						Sql = "Insert Into bt_main_img(brand_code, main_kind, main_img, main_text, link_url, link_target, date_s, date_e, date_yn, emp_cd) values('"& brand_code &"','"& main_kind &"','"& main_img &"','"& main_text &"','"& link_url &"','"& link_target &"','"& date_s &"','"& date_e &"','"& date_yn &"','"&SITE_ADM_ID&"')"
						conn.Execute(Sql)
					End If
				End If

				If IMGNUM = "W2" Then 
					Sql = "Delete From bt_main_img Where brand_code='"& brand_code &"' And main_kind IN ('W3','W4','W5')"
					conn.Execute Sql
				End If
			End If

			If IMGNUM = "W3" Or IMGNUM = "W4" Or IMGNUM = "W5" Then
				main_kind	= "W3"
				main_text	= InjRequest("WMAINTEXT3")
				main_img	= InjRequest("WMAINIMG3")
				link_url	= InjRequest("WLINKURL3")
				link_target	= InjRequest("WLINKTARGET3")
				BAN_ORD		= InjRequest("WBAN_ORD3")
				date_s		= replace(InjRequest("txtFromDate_3"), "-", "")
				date_e		= replace(InjRequest("txtToDate_3"), "-", "")
				date_yn		= InjRequest("date_yn_3")
				If FncIsBlank(link_target) Then link_target = "S"
				If Not FncIsBlank(main_img) Then 
					Sql = "Update bt_main_img Set main_img='"& main_img &"', main_text='"& main_text &"', link_url='"& link_url &"', link_target='"& link_target &"', BAN_ORD='"& BAN_ORD &"', date_s='"& date_s &"', date_e='"& date_e &"', date_yn='"& date_yn &"', emp_cd='"&SITE_ADM_ID&"' Where brand_code='"& brand_code &"' And main_kind='"& main_kind &"'"
					conn.Execute Sql, Uplow

					If Uplow > 0 Then 
					Else 
						Sql = "Insert Into bt_main_img(brand_code, main_kind, main_img, main_text, link_url, link_target, date_s, date_e, date_yn, emp_cd) values('"& brand_code &"','"& main_kind &"','"& main_img &"','"& main_text &"','"& link_url &"','"& link_target &"','"& date_s &"','"& date_e &"','"& date_yn &"','"&SITE_ADM_ID&"')"
						conn.Execute(Sql)
					End If
				End If

				If IMGNUM = "W3" Then 
					Sql = "Delete From bt_main_img Where brand_code='"& brand_code &"' And main_kind IN ('W4','W5')"
					conn.Execute Sql
				End If
			End If
	
			If IMGNUM = "W4" Or IMGNUM = "W5" Then
				main_kind	= "W4"
				main_text	= InjRequest("WMAINTEXT4")
				main_img	= InjRequest("WMAINIMG4")
				link_url	= InjRequest("WLINKURL4")
				link_target	= InjRequest("WLINKTARGET4")
				BAN_ORD		= InjRequest("WBAN_ORD4")
				date_s		= replace(InjRequest("txtFromDate_4"), "-", "")
				date_e		= replace(InjRequest("txtToDate_4"), "-", "")
				date_yn		= InjRequest("date_yn_4")
				If FncIsBlank(link_target) Then link_target = "S"
				If Not FncIsBlank(main_img) Then 
					Sql = "Update bt_main_img Set main_img='"& main_img &"', main_text='"& main_text &"', link_url='"& link_url &"', link_target='"& link_target &"', BAN_ORD='"& BAN_ORD &"', date_s='"& date_s &"', date_e='"& date_e &"', date_yn='"& date_yn &"', emp_cd='"&SITE_ADM_ID&"' Where brand_code='"& brand_code &"' And main_kind='"& main_kind &"'"
					conn.Execute Sql, Uplow
					If Uplow > 0 Then 
					Else 
						Sql = "Insert Into bt_main_img(brand_code, main_kind, main_img, main_text, link_url, link_target, date_s, date_e, date_yn, emp_cd) values('"& brand_code &"','"& main_kind &"','"& main_img &"','"& main_text &"','"& link_url &"','"& link_target &"','"& date_s &"','"& date_e &"','"& date_yn &"','"&SITE_ADM_ID&"')"
						conn.Execute(Sql)
					End If
				End If

				If IMGNUM = "W4" Then 
					Sql = "Delete From bt_main_img Where brand_code='"& brand_code &"' And main_kind IN ('W5')"
					conn.Execute Sql
				End If
			End If

			If IMGNUM = "W5" Then
				main_kind	= "W5"
				main_text	= InjRequest("WMAINTEXT5")
				main_img	= InjRequest("WMAINIMG5")
				link_url	= InjRequest("WLINKURL5")
				link_target	= InjRequest("WLINKTARGET5")
				BAN_ORD		= InjRequest("WBAN_ORD5")
				date_s		= replace(InjRequest("txtFromDate_5"), "-", "")
				date_e		= replace(InjRequest("txtToDate_5"), "-", "")
				date_yn		= InjRequest("date_yn_5")
				If FncIsBlank(link_target) Then link_target = "S"
				If Not FncIsBlank(main_img) Then 
					Sql = "Update bt_main_img Set main_img='"& main_img &"', main_text='"& main_text &"', link_url='"& link_url &"', link_target='"& link_target &"', BAN_ORD='"& BAN_ORD &"', date_s='"& date_s &"', date_e='"& date_e &"', date_yn='"& date_yn &"', emp_cd='"&SITE_ADM_ID&"' Where brand_code='"& brand_code &"' And main_kind='"& main_kind &"'"
					conn.Execute Sql, Uplow
					If Uplow > 0 Then 
					Else 
						Sql = "Insert Into bt_main_img(brand_code, main_kind, main_img, main_text, link_url, link_target, date_s, date_e, date_yn, emp_cd) values('"& brand_code &"','"& main_kind &"','"& main_img &"','"& main_text &"','"& link_url &"','"& link_target &"','"& date_s &"','"& date_e &"','"& date_yn &"','"&SITE_ADM_ID&"')"
						conn.Execute(Sql)
					End If
				End If
			End If
		End If
	End If
	Response.Write "Y^적용되었습니다."
%>