<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "A"
	PROCESS_PAGE = "Y"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%

	total = InjRequest("total")

	for i=1 to total

		hit_idx = InjRequest("hit_idx_"& i)
		brand_code = InjRequest("brand_code_"& i)
		hit_title = InjRequest("hit_title_"& i)
		hit_url = InjRequest("hit_url_"& i)
		hit_sort = InjRequest("hit_sort_"& i)

		Sql = "Update bt_main_hit_m Set hit_title='"& hit_title &"', hit_url='"& hit_url &"', hit_sort='"& hit_sort &"', brand_code='"& brand_code &"' Where hit_idx='"& hit_idx &"'"
		conn.Execute Sql, Uplow
		If Uplow > 0 Then 
		Else 
			Sql = "	Insert Into bt_main_hit_m(hit_title, hit_url, hit_sort)	" & _
				"	values('"& brand_code &"','"& hit_title &"','"& hit_url &"','"& hit_sort &"')"
			conn.Execute(Sql)
		End If

	next 
	Response.Write "Y^저장 되었습니다"
	Response.End
%>
