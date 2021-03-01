<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
MODE		= InjRequest("MODE")
TOPIDX		= InjRequest("TOPIDX")
IDX			= InjRequest("IDX")
ACCOUNT		= InjRequest("ACCOUNT")

If FncIsBlank(MODE) Then 
	Response.Write "E^잘못된 접근방식입니다."
	Response.End
End If 

If MODE = "IN" Then
	If FncIsBlank(ACCOUNT) Then 
		Response.Write "E^계좌정보를 입력해 주세요"
		Response.End
	End If 

	REG_IP	= GetIPADDR()

	Sql = "	Insert bt_ckuniv_account(ACCOUNT, TOP_FG, REG_USER_IDX, REG_DATE, REG_IP) " & _
		"	Values('"& ACCOUNT &"','N','"& SITE_ADM_CD &"', GetDate(), '"& REG_IP &"')"
	conn.Execute(Sql)
	Response.Write "Y^등록 되었습니다."
ElseIf MODE = "UP" Then
	If FncIsBlank(IDX) Then 
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If
	
	Sql = "	Update bt_ckuniv_account Set ACCOUNT = '"& ACCOUNT &"' Where IDX = " & IDX
	conn.Execute(Sql)
	Response.Write "Y^저장 되었습니다."
ElseIf MODE = "DEL" Then
	If FncIsBlank(IDX) Then 
		Response.Write "E^잘못된 접근방식입니다."
		Response.End
	End If
	
	Sql = "	Delete From bt_ckuniv_account Where IDX = " & IDX
	conn.Execute(Sql)
	Response.Write "Y^삭제 되었습니다."
ElseIf MODE = "TOP" Then
	If FncIsBlank(TOPIDX) Then 
		Response.Write "E^대표 계좌를 선택해 주세요."
		Response.End
	End If

	Sql = "	Update bt_ckuniv_account Set TOP_FG = 'N'"
	conn.Execute(Sql)

	Sql = "	Update bt_ckuniv_account Set TOP_FG = 'Y' Where IDX = " & TOPIDX
	conn.Execute(Sql)

	Response.Write "Y^변경 되었습니다."
Else
	Response.Write "E^잘못된 접근방식 입니다."
End If 

conn.Close
Set conn = Nothing 
%>