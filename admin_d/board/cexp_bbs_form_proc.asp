<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	REG_IP	= GetIPADDR()

	CD = InjRequest("CD")
	CIDX = InjRequest("CIDX")
	USE_FG = InjRequest("USE_FG")
	EXPDATE = InjRequest("EXPDATE")
	EXPPLACE = InjRequest("EXPPLACE")
	SHH = InjRequest("SHH")
	SMM = InjRequest("SMM")
	ENDDATE = InjRequest("ENDDATE")
	MAXNUM = InjRequest("MAXNUM")
	MANAGER = InjRequest("MANAGER")

	SHM	= SHH & SMM

	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	If FncIsBlank(CD) Or FncIsBlank(MAXNUM) Or FncIsBlank(MANAGER) Then 
		Response.Write "E^잘못된 접근방식입니다." & BIDX
		Response.End
	End If

	If FncIsBlank(CIDX) Then 
		Sql = "	Insert Into bt_board_cexp_main(USE_FG, EXPDATE, EXPPLACE, SHM, ENDDATE, MAXNUM, MANAGER, REG_USER_IDX, REG_DATE, REG_IP) " & _
			"	Values('"& USE_FG &"','"& EXPDATE &"','"& EXPPLACE &"','"& SHM &"','"& ENDDATE &"','"& MAXNUM &"','"& MANAGER &"','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"')	"
		conn.Execute(Sql)
		Response.Write "Y^등록되었습니다."
		Response.End
	Else
		Sql = "Update bt_board_cexp_main Set USE_FG='"& USE_FG &"',EXPDATE='"& EXPDATE &"',EXPPLACE='"& EXPPLACE &"',SHM='"& SHM &"',ENDDATE='"& ENDDATE &"',MAXNUM='"& MAXNUM &"',MANAGER='"& MANAGER &"' Where CIDX=" & CIDX
		conn.Execute(Sql)
		Response.Write "Y^적용되었습니다."
		Response.End
	End If 
%>
