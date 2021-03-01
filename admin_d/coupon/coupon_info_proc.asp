<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	PROCESS_PAGE = "Y"
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	CPNID	= InjRequest("CPNID")
	CPNNAME	= InjRequest("CPNNAME")
	CPNTYPE	= InjRequest("CPNTYPE")
	DISCOUNT	= InjRequest("DISCOUNT")
	EXPDATE	= InjRequest("EXPDATE")
	STATUS	= InjRequest("STATUS")
	If FncIsBlank(CPNNAME) Or FncIsBlank(CPNTYPE) Or FncIsBlank(DISCOUNT) Or FncIsBlank(EXPDATE) Or FncIsBlank(STATUS) Then 
		Response.Write "E^정보를 모두 입력해 주세요"
		Response.End
	End If 

	MENUID = 0
	OPTIONID = 0
	USESDATE = ""
	USEEDATE = ""
	TOTCNT = 0
	If FncIsBlank(CPNID) Then
		Sql = "	INSERT INTO "& BBQHOME_DB &".DBO.T_CPN(CPNNAME, CPNTYPE, MENUID, OPTIONID, DISCOUNT, EXPDATE, USESDATE, USEEDATE, STATUS, REGDATE, USECNT, TOTCNT) " & _
			 "	VALUES('"& CPNNAME &"','"& CPNTYPE &"','"& MENUID &"','"& OPTIONID &"','"& DISCOUNT &"','"& EXPDATE &"','"& USESDATE &"','"& USEEDATE &"','"& STATUS &"',GETDATE(), 0, '"& TOTCNT &"')"
		conn.Execute(Sql)
	Else 
		Sql = "	UPDATE "& BBQHOME_DB &".DBO.T_CPN SET CPNNAME = '"& CPNNAME &"',CPNTYPE = '"& CPNTYPE &"',MENUID = '"& MENUID &"',OPTIONID = '"& OPTIONID &"',DISCOUNT = '"& DISCOUNT &"',EXPDATE = '"& EXPDATE &"',USESDATE = '"& USESDATE &"',USEEDATE = '"& USEEDATE &"',STATUS = '"& STATUS &"'WHERE CPNID = '"& CPNID &"'"
		conn.Execute(Sql)
	End If 
	Response.Write "Y^적용 되었습니다"
	Response.End
%>
