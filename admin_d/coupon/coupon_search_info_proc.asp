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

	Sql = "			SELECT CPN.CPNNAME, MST.STATUS, MST.MENUID, MENU.MENU_NAME, MST.USESDATE, MST.USEEDATE, CPN.CD_PARTNER, BRANCH.branch_name	"
	Sql = Sql & "	FROM "& BBQHOME_DB &".DBO.T_CPN CPN WITH (NOLOCK)	"
	Sql = Sql & "	INNER JOIN "& BBQHOME_DB &".DBO.T_CPN_MST MST WITH (NOLOCK) ON CPN.CPNID = MST.CPNID  LEFT JOIN BT_BRANCH BRANCH WITH (NOLOCK) ON BRANCH.branch_id = MST.U_CD_PARTNER	"
	Sql = Sql & "	LEFT OUTER JOIN bt_menu MENU WITH (NOLOCK) ON MST.MENUID = MENU.MENUID	"
	Sql = Sql & "	WHERE MST.PIN = '"& PIN &"' "
	Set Uinfo = conn.Execute(Sql)
	If Uinfo.eof Then
		Response.Write "E^정보에 이상이 있습니다"
		Response.End
	End If 

	CPNNAME	= Uinfo("CPNNAME")
	STATUS	= Uinfo("STATUS")
    IF STATUS="1" THEN
        STATUS_TXT="사용안함"
    ELSEIF STATUS = "8" THEN
        STATUS_TXT="폐기"
    ELSE
        STATUS_TXT="정상사용"
    END If

	MENU_NAME	= Uinfo("MENU_NAME")
	USESDATE	= Uinfo("USESDATE")
	USEEDATE	= Uinfo("USEEDATE")

	branch_name	= Uinfo("branch_name")
	CD_PARTNER	= Uinfo("CD_PARTNER")

	Response.Write "Y^"&CPNNAME&"^"&STATUS_TXT&"^"&MENU_NAME&"^"&USESDATE&"^"&USEEDATE&"^"&branch_name&"^"&CD_PARTNER
	Response.End
%>