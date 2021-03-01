<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "D"
	PROCESS_PAGE = "Y"

	REG_IP	= GetIPADDR()

	CD = InjRequest("CD")
	MIDX = InjRequest("MIDX")
	If FncIsBlank(CD) Then 
		Response.Write "E^잘못된 접근방식 입니다"
		Response.End 
	End If

	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	brand_code	= InjRequest("brand_code")
	menu_type	= InjRequest("menu_type")
	menu_name	= InjRequest("menu_name")
	menu_name_e	= InjRequest("menu_name_e")
	menu_price	= InjRequest("menu_price")
	menu_desc	= InjRequest("menu_desc")
	kind_sel	= InjRequest("kind_sel")
	poscode		= InjRequest("poscode")
	menu_title	= InjRequest("menu_title")
	gubun_sel	= InjRequest("gubun_sel")
	option_yn	= InjRequest("option_yn")
	sale_shop	= InjRequest("sale_shop")
	online_yn	= InjRequest("online_yn")
	smart_age	= InjRequest("smart_age")
	smart_taste	= InjRequest("smart_taste")
	use_yn		= InjRequest("use_yn")
	origin		= InjRequest("origin")
	calorie		= InjRequest("calorie")
	sugars		= InjRequest("sugars")
	protein		= InjRequest("protein")
	saturatedfat	= InjRequest("saturatedfat")
	natrium		= InjRequest("natrium")
	allergy		= InjRequest("allergy")
	exp1_yn		= InjRequest("exp1_yn")
	exp1_url	= InjRequest("exp1_url")
	exp2_yn		= InjRequest("exp2_yn")
	exp2_title	= InjRequest("exp2_title")
	exp2_imgurl	= InjRequest("exp2_imgurl")
	exp3_yn		= InjRequest("exp3_yn")
	exp3_title	= InjRequest("exp3_title")
	exp3_imgurl	= InjRequest("exp3_imgurl")
	exp4_yn		= InjRequest("exp4_yn")
	exp4_title	= InjRequest("exp4_title")
	exp4_imgurl	= InjRequest("exp4_imgurl")
	exp5_yn		= InjRequest("exp5_yn")
	exp5_title	= InjRequest("exp5_title")
	exp5_imgurl	= InjRequest("exp5_imgurl")

	THUMB_IMG	= InjRequest("THUMB_IMG")
	MAIN_IMG	= InjRequest("MAIN_IMG")
	MOBILE_IMG	= InjRequest("MOBILE_IMG")

	menu_idx_sub	= InjRequest("menu_idx_sub")
	menu_title_sub	= InjRequest("menu_title_sub")

	add_price	= InjRequest("add_price")
	adult_yn	= InjRequest("adult_yn")

	If FncIsBlank(menu_name) Or FncIsBlank(menu_price) Then 
		Response.Write "E^기본적인 정보를 입력해 주세요"
		Response.End 
	End If

	gubun_sel	= Replace(gubun_sel," ","")
	sale_shop	= Replace(sale_shop," ","")
	smart_age	= Replace(smart_age," ","")
	smart_taste	= Replace(smart_taste," ","")

	If FncIsBlank(MIDX) Then
		Sql = "	Insert Into bt_menu(brand_code, menu_type, menu_name, menu_name_e, menu_price, menu_desc, kind_sel, poscode, menu_title, " & _
			"		gubun_sel, option_yn, sale_shop, online_yn, smart_age, smart_taste,  " & _
			"		use_yn, del_yn, sort, origin, calorie, sugars, protein, saturatedfat, natrium, allergy,  " & _
			"		exp1_yn, exp1_url, exp2_yn, exp2_title, exp2_imgurl, exp3_yn, exp3_title, exp3_imgurl,  " & _
			"		exp4_yn, exp4_title, exp4_imgurl, exp5_yn, exp5_title, exp5_imgurl, " & _
			"		reg_user_idx, reg_date, reg_ip, add_price, adult_yn	) " & _
			"	Values('"& brand_code &"','"& menu_type &"','"& menu_name &"','"& menu_name_e &"','"& menu_price &"','"& menu_desc &"','"& kind_sel &"','"& poscode &"','"& menu_title &"', " & _
			"		'"& gubun_sel &"','"& option_yn &"','"& sale_shop &"','"& online_yn &"','"& smart_age &"','"& smart_taste &"', " & _
			"		'"& use_yn &"','N',( Select Isnull(Max(sort),0)+1 From bt_menu Where brand_code='"& brand_code &"'),'"& origin &"','"& calorie &"','"& sugars &"','"& protein &"','"& saturatedfat &"','"& natrium &"','"& allergy &"', " & _
			"		'"& exp1_yn &"','"& exp1_url &"','"& exp2_yn &"','"& exp2_title &"','"& exp2_imgurl &"','"& exp3_yn &"','"& exp3_title &"','"& exp3_imgurl &"', " & _
			"		'"& exp4_yn &"','"& exp4_title &"','"& exp4_imgurl &"','"& exp5_yn &"','"& exp5_title &"','"& exp5_imgurl &"', " & _
			"		'"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"','"& add_price &"','"& adult_yn &"')	"
		conn.Execute(Sql)
		Sql = "	Select Max(menu_idx) As menu_idx From bt_menu"
		Set MaxID = conn.Execute(Sql)
		menu_idx = MaxID("menu_idx")

		If Not FncIsBlank(THUMB_IMG) Then
			Sql = "	Insert Into bt_menu_file(menu_idx, file_type, file_name, file_ext, file_path, del_yn, reg_user_idx, reg_date, reg_ip) " & _
				"	Values('"& menu_idx &"','THUMB','"& THUMB_IMG &"','','/thumbnail/','N','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')"
			conn.Execute(Sql)
		End If

		If Not FncIsBlank(MAIN_IMG) Then
			Sql = "	Insert Into bt_menu_file(menu_idx, file_type, file_name, file_ext, file_path, del_yn, reg_user_idx, reg_date, reg_ip) " & _
				"	Values('"& menu_idx &"','MAIN','"& MAIN_IMG &"','','/pc/','N','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')"
			conn.Execute(Sql)
		End If

		If Not FncIsBlank(MOBILE_IMG) Then
			Sql = "	Insert Into bt_menu_file(menu_idx, file_type, file_name, file_ext, file_path, del_yn, reg_user_idx, reg_date, reg_ip) " & _
				"	Values('"& menu_idx &"','MOBILE','"& MOBILE_IMG &"','','/mobile/','N','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')"
			conn.Execute(Sql)
		End If

		if menu_idx_sub <> "" then 
			menu_idx_sub_arr = split(menu_idx_sub, ",")

			for i=0 to ubound(menu_idx_sub_arr)
				if trim(menu_idx_sub_arr(i)) <> "" then 
					Sql = "	Insert Into bt_menu_good(brand_code, menu_idx_parent, menu_idx_sub) " & _
						"	Values('"& brand_code &"', '"& menu_idx &"', '"& trim(menu_idx_sub_arr(i)) &"')"
					conn.Execute(Sql)
				end if 
			next 
		end if 

		Response.Write "Y^등록 되었습니다"
		Response.End
	Else
		Sql = "	Update bt_menu Set brand_code='"& brand_code &"', menu_type='"& menu_type &"', menu_name='"& menu_name &"', menu_name_e='"& menu_name_e &"', menu_price='"& menu_price &"', menu_desc='"& menu_desc &"', kind_sel='"& kind_sel &"', poscode='"& poscode &"', menu_title='"& menu_title &"', gubun_sel='"& gubun_sel &"', option_yn='"& option_yn &"', sale_shop='"& sale_shop &"', online_yn='"& online_yn &"', smart_age='"& smart_age &"', smart_taste='"& smart_taste &"', use_yn='"& use_yn &"', origin='"& origin &"', calorie='"& calorie &"', sugars='"& sugars &"', protein='"& protein &"', saturatedfat='"& saturatedfat &"', natrium='"& natrium &"', allergy='"& allergy &"', exp1_yn='"& exp1_yn &"', exp1_url='"& exp1_url &"', exp2_yn='"& exp2_yn &"', exp2_title='"& exp2_title &"', exp2_imgurl='"& exp2_imgurl &"', exp3_yn='"& exp3_yn &"', exp3_title='"& exp3_title &"', exp3_imgurl='"& exp3_imgurl &"', exp4_yn='"& exp4_yn &"', exp4_title='"& exp4_title &"', exp4_imgurl='"& exp4_imgurl &"', exp5_yn='"& exp5_yn &"', exp5_title='"& exp5_title &"', exp5_imgurl='"& exp5_imgurl &"', mod_user_idx='"& SITE_ADM_CD &"', mod_date=GetDate(), mod_ip='"& REG_IP &"', add_price='"& add_price &"', adult_yn='"& adult_yn &"' Where menu_idx = " & MIDX
		conn.Execute(Sql)

		If Not FncIsBlank(THUMB_IMG) Then
			Sql = "	Update bt_menu_file Set file_path='/thumbnail/', file_name='"& THUMB_IMG &"', file_ext='', mod_user_idx='"& SITE_ADM_CD &"', mod_date=GetDate(), mod_ip='"& REG_IP &"' Where menu_idx = " & MIDX & " And file_type = 'THUMB' "
			conn.Execute Sql, Uplow
			If Uplow > 0 Then 
			Else 
				Sql = "	Insert Into bt_menu_file(menu_idx, file_type, file_name, file_ext, file_path, del_yn, reg_user_idx, reg_date, reg_ip) " & _
					"	Values('"& MIDX &"','THUMB','"& THUMB_IMG &"','','/thumbnail/','N','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')"
				conn.Execute(Sql)
			End If
		End If

		If Not FncIsBlank(MAIN_IMG) Then
			Sql = "	Update bt_menu_file Set file_path='/pc/', file_name='"& MAIN_IMG &"', file_ext='', mod_user_idx='"& SITE_ADM_CD &"', mod_date=GetDate(), mod_ip='"& REG_IP &"' Where menu_idx = " & MIDX & " And file_type = 'MAIN' "
			conn.Execute Sql, Uplow
			If Uplow > 0 Then 
			Else 
				Sql = "	Insert Into bt_menu_file(menu_idx, file_type, file_name, file_ext, file_path, del_yn, reg_user_idx, reg_date, reg_ip) " & _
					"	Values('"& MIDX &"','MAIN','"& MAIN_IMG &"','','/pc/','N','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')"
				conn.Execute(Sql)
			End If
		End If

		If Not FncIsBlank(MOBILE_IMG) Then
			Sql = "	Update bt_menu_file Set file_path='/mobile/', file_name='"& MOBILE_IMG &"', file_ext='', mod_user_idx='"& SITE_ADM_CD &"', mod_date=GetDate(), mod_ip='"& REG_IP &"' Where menu_idx = " & MIDX & " And file_type = 'MOBILE' "
			conn.Execute Sql, Uplow
			If Uplow > 0 Then 
			Else 
				Sql = "	Insert Into bt_menu_file(menu_idx, file_type, file_name, file_ext, file_path, del_yn, reg_user_idx, reg_date, reg_ip) " & _
					"	Values('"& MIDX &"','MOBILE','"& MOBILE_IMG &"','','/mobile/','N','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')"
				conn.Execute(Sql)
			End If 
		End If

		if menu_idx_sub <> "" then 
			Sql = " delete from bt_menu_good where menu_idx_parent='"& MIDX &"'"
			conn.Execute(Sql)

			menu_idx_sub_arr = split(menu_idx_sub, ",")

			for i=0 to ubound(menu_idx_sub_arr)
				if trim(menu_idx_sub_arr(i)) <> "" then 
					Sql = "	Insert Into bt_menu_good(brand_code, menu_idx_parent, menu_idx_sub) " & _
						"	Values('"& brand_code &"', '"& MIDX &"', '"& trim(menu_idx_sub_arr(i)) &"')"
					conn.Execute(Sql)
				end if 
			next 
		end if 

		Response.Write "Y^수정 되었습니다"
		Response.End
	End If
%>
