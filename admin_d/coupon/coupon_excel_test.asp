<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "SUPER"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	SW		= InjRequest("SW")
	Detail = "&SW="& SW
%>
<%
	CPNID	= InjRequest("c_id")

	If FncIsBlank(CPNID) Then
		Call subGoToMsg("잘못된 접근 방식입니다","back")
	End If


	'SqlFrom = "	From BBQ_HOME_OLD.DBO."&SM_Table&" WITH(NOLOCK) LEFT JOIN BBQ_HOME_OLD.DBO."&SM_Table2&" WITH(NOLOCK) ON MST.CPNID = CPN.CPNID "
	If Request.ServerVariables("HTTP_HOST") = "all.fuzewire.com:8080" Then
		SqlFrom = "	From BBQ_HOME_OLD.DBO.T_CPN_MST MST  WITH(NOLOCK) INNER JOIN BBQ_HOME_OLD.DBO.T_CPN CPN WITH(NOLOCK) ON MST.CPNID = CPN.CPNID "
	Else
		SqlFrom = "	From BBQ_HOME.DBO.T_CPN_MST MST  WITH(NOLOCK) INNER JOIN BBQ_HOME.DBO.T_CPN CPN WITH(NOLOCK) ON MST.CPNID = CPN.CPNID "
	End If


	SqlWhere = " WHERE MST.CPNID = "&CPNID
	
	SqlOrder	= "ORDER BY MST.USEDATE DESC "

	'Response.Buffer = True
	'Response.Expires = 0
	'Response.CacheControl = "public"
	'Response.ContentType = "application/vnd.ms-excel; charset=utf-8"
	'Response.AddHeader "Content-Disposition", "attachment;filename=""coupon_"& CPNID & "_" & replace(date(),"-","") &".xls"""   
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<style>
.numtext { mso-number-format:'\@' }
</style>
<table border="1">
						<tr>
							<th>번호</th>
							<th>핀 ID</th>
							<th>핀번호</th>
							<th>쿠폰 ID</th>
							<th>쿠폰종류</th>
							<th>소유자 / 사용자</th>
							<th>메뉴 ID</th>
							<th>옵션 ID</th>
							<!--<th>DISCOUNT</th>-->
							<th>발행일시</th>
							<th>시작일자</th>
							<th>종료일자</th>
							<th>상태 (미사용,사용,폐기)</th>
							<th>사용일시</th>
							<th>연락처</th>
							<th>쿠폰금액</th>
							<th>사용브랜드코드</th>
							<th>사용매장코드</th>
							<th>사용매장명</th>
						</tr>
<%
	'BARND_NAME = FncBrandName(CD)
	num = 1
	'If total_num > 0 Then 
		Sql = "SELECT  MST.*, CPN.CPNNAME, (select branch_name from bt_branch where branch_id = MST.U_CD_PARTNER) as branch_name " & SqlFrom & SqlWhere & vbCrLf
		'Sql = Sql & " And MST.PINID Not In "
		'Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " MST.PINID "& SqlFrom & SqlWhere & vbCrLf
		'Sql = Sql & SqlOrder & ")" & vbCrLf
		Sql = Sql & SqlOrder
		'Response.write Sql
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			'num	= total_num - first

			Do While Not Rlist.Eof
				PINID			= Rlist("PINID")
				CPNNAME				= Rlist("CPNNAME")
				PIN				= Rlist("PIN")
				CPNID		= Rlist("CPNID")
				CPNTYPE	= Rlist("CPNTYPE")
				OWNERID	= Rlist("OWNERID")
				MENUID		= Rlist("MENUID")
				OPTIONID		= Rlist("OPTIONID")
				'DISCOUNT		= Rlist("MST.DISCOUNT")
				PUBDATE		= Rlist("PUBDATE")
				USESDATE		= Rlist("USESDATE")
				USEEDATE		= Rlist("USEEDATE")
				STATUS		= Rlist("STATUS")
				USEDATE		= Rlist("USEDATE")
				TELNO		= Rlist("TELNO")
				CPN_PRICE		= Rlist("CPN_PRICE")
				U_CD_BRAND		= Rlist("U_CD_BRAND")
				U_CD_PARTNER		= Rlist("U_CD_PARTNER")
				branch_name		= Rlist("branch_name")

				IF STATUS="1" THEN
					STATUS_TXT="사용안함"
				ELSEIF STATUS = "8" THEN
					STATUS_TXT="폐기"
				ELSE
					STATUS_TXT="정상사용"
				END If

%>
						<tr>
							<td class="numtext"><%=num%></td>
							<td class="numtext"><%=PINID%></td>
							<td class="numtext"><%=PIN%></td>
							<td class="numtext"><%=CPNID%></td>
							<td class="numtext"><%=CPNTYPE%></td>
							<td class="numtext"><%=OWNERID%></td>
							<td class="numtext"><%=MENUID%></td>
							<td class="numtext"><%=OPTIONID%></td>
							<!--<td></td>-->
							<td class="numtext"><%=PUBDATE%></td>
							<td class="numtext"><%=USESDATE%></td>
							<td class="numtext"><%=USEEDATE%></td>
							<td class="numtext"><%=STATUS_TXT%></td>
							<td class="numtext"><%=USEDATE%></td>
							<td class="numtext"><%=TELNO%></td>
							<td class="numtext"><%=CPN_PRICE%></td>
							<td class="numtext"><%=U_CD_BRAND%></td>
							<td class="numtext"><%=U_CD_PARTNER%></td>
							<td class="numtext"><%=branch_name%></td>
						</tr>
<%
				num = num + 1
				Rlist.MoveNext
			Loop
		End If
		Rlist.Close
		Set Rlist = Nothing 
	'End If 
%>
</table>