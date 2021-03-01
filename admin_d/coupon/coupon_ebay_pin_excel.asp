<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	strCPNIDS	= InjRequest("strCPNIDS")
	If FncIsBlank(strCPNIDS) Then
		Call subGoToMsg("잘못된 접근방식입니다","close")
	End If 

	SqlWhere = " WHERE T1.CPNID IN ('"& Replace(strCPNIDS, "|","','") &"') "

	Sql = "	SELECT "
	Sql = Sql & "	T1.ROW_NO, T1.CPNID, T1.CPNNAME, T1.PINID, T1.PIN, T1.CPNTYPE, T1.USESDATE, T1.USEEDATE, DBO.FN_COUPON_STATUS(T1.PIN) AS STATUS, T1.PUBDATE AS REGDATE, "
	Sql = Sql & "	T1.USEDATE, T1.OWNERID, "	' -- ISNULL(T4.NAME, '&nbsp;') AS dbo.ecl_decrypt(USERNAME), T4.HP1 as dbo.ecl_decrypt(HP1), T4.HP2 as dbo.ecl_decrypt(HP2), T4.HP3 as dbo.ecl_decrypt(HP3),
	Sql = Sql & "	T1.BRANCH_ID, T2.BRANCH_NAME "
	Sql = Sql & " FROM ( "
	Sql = Sql & "	SELECT "
	Sql = Sql & "		RANK() OVER(ORDER BY ISNULL(T1.USEDATE,'2060-12-31'), CASE WHEN T1.STATUS = 8 THEN 999 ELSE T1.STATUS END, PINID) ROW_NO, "
	Sql = Sql & "		T1.CPNID, T2.CPNNAME, T1.PINID, T1.PIN, T1.CPNTYPE, T1.USESDATE, T1.USEEDATE, T1.STATUS, T1.PUBDATE, T1.USEDATE, T1.OWNERID, T1.U_CD_PARTNER AS BRANCH_ID "
	Sql = Sql & "	FROM "& BBQHOME_DB &".DBO.T_CPN_MST T1 WITH (NOLOCK) INNER JOIN "& BBQHOME_DB &".DBO.T_CPN T2 WITH (NOLOCK) ON T2.CPNID = T1.CPNID "
	Sql = Sql & SqlWhere
	Sql = Sql & ") T1 "
	Sql = Sql & " LEFT JOIN BT_BRANCH T2 WITH (NOLOCK) ON T2.BRAND_CODE ='01' AND T2.BRANCH_ID = T1.BRANCH_ID "
'	Sql = Sql & " LEFT JOIN BT_MEMBER T4 WITH (NOLOCK) ON T4.MEMBER_ID = T1.OWNERID "
	Sql = Sql & " ORDER BY ROW_NO "

	Set Rlist = conn.Execute(Sql)
	If Rlist.eof Then
		Call subGoToMsg("내역이 없습니다","close")
	End If 
	
	Response.Buffer = True
	Response.ContentType = "application/vnd.ms-excel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-Disposition","attachment;filename="&server.urlencode("쿠폰리스트")&"_"&replace(date(),"-","")&".xls"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<!-- 리스트 테이블 시작 -->
<table width="100%" border="1" cellpadding="0" cellspacing="0">
	<tr>
	  <td class="tableTDs">순번</td>
	  <td class="tableTDs">쿠폰코드</td>
	  <td class="tableTD">쿠폰명</td>
	  <td class="tableTD">핀번호</td>
	  <td class="tableTD">사용여부</td>
	  <td class="tableTD">사용일시</td>
	  <td class="tableTD">회원 ID</td>
	  <td class="tableTD">매장코드</td>
	  <td class="tableTDe">매장</td>
	</tr>
<%
	intIdx = 1
	Do While not Rlist.EOF
%>
	<tr>
		<td align="center"><%=intIdx%></td>
		<td align="center"><%=Rlist("CPNID")%></td>
		<td align="center"><%=Rlist("CPNNAME")%></td>
		<td align="center" style="mso-number-format:\@"><%=Rlist("PIN")%></td>
		<td align="center"><%If Rlist("STATUS") = 1 Then%>미사용<%ElseIf Rlist("STATUS") = 7 Then%>기한만료<%ElseIf Rlist("STATUS") = 8 Then%>사용불가<%ElseIf Rlist("STATUS") = 9 Then %>정상사용<%End If%></td>
		<td align="center"><%=Rlist("USEDATE")%></td>
        <td align="center" style='mso-number-format:"\@";'><%=objRs.fields("OWNERID")%></td>
        <td align="center" style='mso-number-format:"\@";'><%=objRs.fields("BRANCH_ID")%></td>
		<td align="center"><%=Rlist("BRANCH_NAME")%></td>
	</tr>
<%
		intIdx = intIdx + 1
		Rlist.MoveNext
	Loop
%>
</table>
</body>
</html>