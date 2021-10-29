<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "C"
	PROCESS_PAGE = "Y"
	
	CD = InjRequest("CD")
	If FncIsBlank(CD) Then 
		Response.Write "E^잘못된 접근방식 입니다"
		Response.End 
	End If

	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	REG_IP	= GetIPADDR()
	branch_id	= InjRequest("branch_id")
	ORG_owner_img	= InjRequest("ORG_owner_img")
	ORG_branch_thumb	= InjRequest("ORG_branch_thumb")
	ORG_branch_img	= InjRequest("ORG_branch_img")
	ORG_newbranch_img	= InjRequest("ORG_newbranch_img")

	branch_type_code	= InjRequest("branch_type_code")
	branch_seats	= InjRequest("branch_seats")
	branch_services_code	= InjRequest("branch_services_code")

	open_hour	= InjRequest("open_hour")
	open_minute	= InjRequest("open_minute")
	close_hour	= InjRequest("close_hour")
	close_minute	= InjRequest("close_minute")
	branch_weekday_open	= open_hour & open_minute
	branch_weekday_close	= close_hour & close_minute

	delivery_code	= InjRequest("delivery_code")
	close_day_code	= InjRequest("close_day_code")
	close_day	= InjRequest("close_day")
	membership_yn_code	= InjRequest("membership_yn_code")
	order_yn	= InjRequest("order_yn")
	coupon_yn	= InjRequest("coupon_yn")
	yogiyo_yn	= InjRequest("yogiyo_yn")
	happy_yn_code	= InjRequest("happy_yn_code")
	danal_h_cpid	= InjRequest("danal_h_cpid")
	danal_h_scpid	= InjRequest("danal_h_scpid")
	payco_seller	= InjRequest("payco_seller")
	payco_cpid	= InjRequest("payco_cpid")
	payco_itemcd	= InjRequest("payco_itemcd")
	paycoin_cpid	= InjRequest("paycoin_cpid")
	sgpay_merchant	= InjRequest("sgpay_merchant")
	newbranch_title	= InjRequest("newbranch_title")
	newbranch_explan	= InjRequest("newbranch_explan")
	img_path	= "/upload_files/store"
	owner_greeting	= InjRequest("owner_greeting")
	delivery_fee	= InjRequest("delivery_fee")
	way_to_go	= InjRequest("way_to_go")

	owner_img	= InjRequest("owner_img")
	branch_thumb	= InjRequest("branch_thumb")
	branch_img	= InjRequest("branch_img")
	newbranch_img	= InjRequest("newbranch_img")

	add_price_yn	= InjRequest("add_price_yn")
	beer_yn	= InjRequest("beer_yn")

	branch_services_code = Replace(branch_services_code," ","")
	
	wgs84_x	= InjRequest("wgs84_x")
	wgs84_y	= InjRequest("wgs84_y")

	Sql = "	Update bt_branch Set "
	Sql = Sql & " branch_type_code='"& branch_type_code &"', branch_seats='"& branch_seats &"', branch_services_code='"& branch_services_code &"', branch_weekday_open='"& branch_weekday_open &"', branch_weekday_close='"& branch_weekday_close &"', delivery_code='"& delivery_code &"', close_day_code='"& close_day_code &"', close_day='"& close_day &"', membership_yn_code='"& membership_yn_code &"', order_yn='"& order_yn &"', coupon_yn='"& coupon_yn &"', yogiyo_yn='"& yogiyo_yn &"', happy_yn_code='"& happy_yn_code &"', danal_h_cpid='"& danal_h_cpid &"', danal_h_scpid='"& danal_h_scpid &"', payco_seller='"& payco_seller &"', payco_cpid='"& payco_cpid &"', payco_itemcd='"& payco_itemcd &"', paycoin_cpid='"& paycoin_cpid &"', sgpay_merchant_v2='"& sgpay_merchant &"', newbranch_title='"& newbranch_title &"', newbranch_explan='"& newbranch_explan &"', img_path='"& img_path &"', owner_img='"& owner_img &"', branch_thumb='"& branch_thumb &"', branch_img='"& branch_img &"', newbranch_img='"& newbranch_img &"', owner_greeting='"& owner_greeting &"', delivery_fee='"& delivery_fee &"', way_to_go='"& way_to_go &"', add_price_yn='"& add_price_yn &"', beer_yn='"& beer_yn &"' "
	if len(trim(wgs84_x)) > 0 and len(trim(wgs84_y)) > 0 then
		Sql = Sql & ", wgs84_x='"& wgs84_x &"', wgs84_y='"& wgs84_y &"' "
	end if
	Sql = Sql & " , mod_user_idx='"& SITE_ADM_CD &"', mod_date=GetDate(), mod_ip='"& REG_IP &"' "
	Sql = Sql & " Where branch_id = '" & branch_id & "'"
	conn.Execute(Sql)

	Response.Write "Y^수정 되었습니다"
	Response.End 
%>
