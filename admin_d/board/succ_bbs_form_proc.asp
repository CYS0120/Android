<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	PROCESS_PAGE = "Y"

	REG_IP	= GetIPADDR()

	CD = InjRequest("CD")
	BBSCODE = InjRequest("BBSCODE")
	MCD = InjRequest("MCD")

	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	BIDX		= InjRequest("BIDX")
	BRAND_FG	= InjRequest("BRAND_FG")
	SGUBUN		= InjRequest("SGUBUN")
	STORENAME	= InjRequest("STORENAME")
	TITLE		= InjRequest("TITLE")
	' THUMBIMG	= InjRequest("THUMBIMG")
	CONTIMG		= InjRequest("CONTIMG")
	CONT_TYPE	= InjRequest("CONT_TYPE")
	CONTHTML	= Request("CONTHTML")
	CONTTXT		= InjRequest("CONTTXT")

	If FncIsBlank(CD) Then 
		Response.Write "E^잘못된 접근방식입니다"
		Response.End
	End If


	If FncIsBlank(BIDX) Then
		Sql = "	Insert Into bt_board_succ(TOP_FG, BRAND_FG, SGUBUN, STORENAME, TITLE, HIT, CONTIMG, REG_USER_IDX, REG_DATE, REG_IP, CONT_TYPE, CONTHTML, CONTTXT) " & _
			"	Values('N','"& BRAND_FG &"','"& SGUBUN &"','"& STORENAME &"','"& TITLE &"',0,'"& CONTIMG &"','"& SITE_ADM_CD &"',GetDate(),'"& REG_IP &"','"& CONT_TYPE &"','"& CONTHTML &"','"& CONTTXT &"')	"
		conn.Execute(Sql)
		Response.Write "Y^등록 되었습니다"
		Response.End
	Else
		Sql = "	Update bt_board_succ Set BRAND_FG='"& BRAND_FG &"', SGUBUN='"& SGUBUN &"', STORENAME='"& STORENAME &"', TITLE='"& TITLE &"', CONTIMG='"& CONTIMG &"', CONT_TYPE='"& CONT_TYPE &"', CONTHTML='"& CONTHTML &"', CONTTXT='"& CONTTXT &"' Where BIDX = " & BIDX
		conn.Execute(Sql)
		Response.Write "Y^수정 되었습니다"
		Response.End
	End If
%>
