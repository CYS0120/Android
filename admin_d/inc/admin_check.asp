<%
	SITE_AUTH_CHECK = "N"
	PAGE_AUTH_CHECK = "Y"

	If Not FncIsBlank(SITE_ADM_CD) Then
		SITE_AUTH_CHECK = "Y"
	End If

'SITE_ADM_LV = "M"
'SITE_ADM_CD = 2

	'브랜드 코드 변수 생성
	ValBRAND_CODENAME = ""
	SUPER_ADMIN_CHECKMENU = ""	'슈퍼관리자 권한 코드
	Sql = "Select brand_mcode, brand_code, brand_pcode, brand_gcode, brand_name, brand_dir, brand_url From bt_brand Where use_yn='Y' order by brand_order"
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.Eof Then
		Do While Not Mlist.Eof
			MENU_BRANDmcode	= Mlist("brand_mcode")
			MENU_BRANDcode	= Mlist("brand_code")
			MENU_BRANDpcode	= Mlist("brand_pcode")
			MENU_BRANDgcode	= Mlist("brand_gcode")
			MENU_BRANDname	= Mlist("brand_name")
			MENU_BRANDdir	= Mlist("brand_dir")
			MENU_BRANDurl	= Mlist("brand_url")

			ValBRAND_CODENAME = ValBRAND_CODENAME & MENU_BRANDmcode & "^" & MENU_BRANDcode & "^" & MENU_BRANDpcode & "^" & MENU_BRANDgcode & "^" & MENU_BRANDname & "^" & MENU_BRANDdir & "^" & MENU_BRANDurl & "|"
			SUPER_ADMIN_CHECKMENU = SUPER_ADMIN_CHECKMENU & MENU_BRANDmcode & ","
			Mlist.MoveNext
		Loop 
	End If
	If SITE_AUTH_CHECK = "Y" Then
		If Not FncIsBlank(CUR_PAGE_CODE) Then	'페이지 코드가 설정된 경우만 체크
			If SITE_ADM_LV = "S" Then	'슈퍼관리자는 전체권한
				ADMIN_CHECKMENUA = SUPER_ADMIN_CHECKMENU
				ADMIN_CHECKMENUB = SUPER_ADMIN_CHECKMENU
				ADMIN_CHECKMENUC = SUPER_ADMIN_CHECKMENU
				ADMIN_CHECKMENUD = SUPER_ADMIN_CHECKMENU
				ADMIN_CHECKMENUE = SUPER_ADMIN_CHECKMENU
				ADMIN_CHECKMENUG = "G0"
				ADMIN_CHECKMENUF = SUPER_ADMIN_CHECKMENU
				ADMIN_CHECKMENUG = SUPER_ADMIN_CHECKMENU
				ADMIN_CHECKMENUH = SUPER_ADMIN_CHECKMENU
			End If
			If CUR_PAGE_CODE = "SUPER" Then		'슈퍼관리자만 접근 가능한 페이지
				If SITE_ADM_LV <> "S" Then 
					If PROCESS_PAGE = "Y" Then 
						Response.Write "E^권한이 없는 페이지 입니다"
						Response.End
					Else 
						Call subGoToMsg("권한이 없는 페이지 입니다","back")
					End If 
				End If 
			ElseIf SITE_ADM_LV = "S" Then	'슈퍼관리자는 전체권한
			Else	'일반 관리자가 접근 가능한 페이지
				Sql = "Select menu"& CUR_PAGE_CODE &"1 As Menu1, menu"& CUR_PAGE_CODE &"2 As Menu2, menuA1, menuB1, menuC1, menuD1, menuE1, menuF1, menuG1, menuH1 From bt_admin_user Where user_idx=" & SITE_ADM_CD
				Set MenuRs = conn.Execute(Sql)
				If MenuRs.Eof Then 
					Call subGoToMsg("관리자 정보에 이상이 있습니다.다시 로그인 해주세요",SITE_ADM_DIR&"logout.asp")
				Else
					ADMIN_CHECKMENU1 = MenuRs("Menu1")
					ADMIN_CHECKMENU2 = MenuRs("Menu2")
					ADMIN_CHECKMENUA = MenuRs("MenuA1")
					ADMIN_CHECKMENUB = MenuRs("MenuB1")
					ADMIN_CHECKMENUC = MenuRs("MenuC1")
					ADMIN_CHECKMENUD = MenuRs("MenuD1")
					ADMIN_CHECKMENUE = MenuRs("MenuE1")
					ADMIN_CHECKMENUF = MenuRs("MenuF1")
					ADMIN_CHECKMENUG = MenuRs("MenuG1")	'쿠폰쪽만 G2로 
					ADMIN_CHECKMENUH = MenuRs("MenuH1")
					If FncIsBlank(ADMIN_CHECKMENU1) Then 
						PAGE_AUTH_CHECK = "N"
					Else
						If Not FncIsBlank(CUR_PAGE_SUBCODE) Then	'페이지 서브 코드가 설정된 경우만 체크 없는 경우는 초기값이므로 해당 페이지는 무조건 접근 권한이 있음
							If InStr(ADMIN_CHECKMENU1,CUR_PAGE_SUBCODE) > 0 Then 
							Else
								PAGE_AUTH_CHECK = "N"
							End If
						End If
					End If 
				End If

				If PAGE_AUTH_CHECK = "N" Then
					If PROCESS_PAGE = "Y" Then 
						Response.Write "E^권한이 없는 페이지 입니다1"
						Response.End
					Else 
						Call subGoToMsg("권한이 없는 페이지 입니다","back")
					End If 
				End If
			End If
		End If
	Else 
		If PROCESS_PAGE = "Y" Then 
			Response.Write "E^관리자 전용 페이지 입니다"
			Response.End
		Else 
			Call subGoToMsg("관리자 전용 페이지 입니다",SITE_ADM_DIR)
		End If 
	End If
%>
<!-- #include virtual="/inc/functions_code.asp" -->