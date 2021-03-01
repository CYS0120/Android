<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	PIN	= InjRequest("COUPONPIN")
	If FncIsBlank(PIN) Then 
		Response.Write "E^핀번호를 입력해 주세요"
		Response.End
	End If 
	search_choice	= InjRequest("search_choice")
	USESDATE	= InjRequest("USESDATE")
	ADD_DATE	= InjRequest("ADD_DATE")
	CD_PARTNER	= InjRequest("CD_PARTNER")
	If FncIsBlank(search_choice) Or (search_choice <> "cDel" And search_choice <> "cInit" And search_choice <> "period") Then 
		Response.Write "E^변경하실 상태를 선택해주세요."
		Response.End
	End If 

	If CD_PARTNER = "20000" Then 
		Response.Write "E^[스마트] 쿠폰은 기간연장, 쿠폰폐기, 쿠폰초기화가 불가합니다."
		Response.End
	End If 

    If search_choice = "cDel" Then      ' 쿠폰 폐기
		Sql = "	UPDATE "& BBQHOME_DB &".DBO.T_CPN_MST SET STATUS = '8' WHERE PIN = '"& PIN &"'"
		conn.Execute(Sql)
	ElseIf search_choice = "period" Then      ' 쿠폰 기간연장		convert(varchar(10), dateadd(day, 3, useedate), 126) 'dateadd(day, 3, useedate)
		If FncIsBlank(ADD_DATE) Then 
			Response.Write "E^연장하실 기간을 선택해주세요."'&ADD_DATE&"aa"
			Response.End
		End If 

		Sql = "	UPDATE "& BBQHOME_DB &".DBO.T_CPN_MST SET USEEDATE = convert(varchar(10), dateadd(day, "&ADD_DATE&", useedate), 126) WHERE PIN = '"& PIN &"'"
		conn.Execute(Sql)
   ELSE                                ' 쿠폰초기화
		Sql = "	UPDATE "& BBQHOME_DB &".DBO.T_CPN_MST SET STATUS = '1', USEDATE = NULL, TELNO = NULL, U_CD_BRAND = NULL, U_CD_PARTNER = NULL WHERE PIN = '"& PIN &"'"
		conn.Execute(Sql)
    End If

	Response.Write "Y^변경되었습니다."
	Response.End
%>