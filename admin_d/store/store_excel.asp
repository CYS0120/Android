<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "C"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	server.scripttimeout = 10000

	SM		= InjRequest("SM")
	SW		= InjRequest("SW")

	BRAND_CODE	= FncBrandDBCode(CD)
%>
<meta charset="utf-8">
	<table border="1">
							<tr>
								<th>NO</th>
								<th>
									매장코드
								</th>
								<th>
									매장명
								</th>
								<th>
									점주명
								</th>
								<th>
									매장주소
								</th>
								<th>연락처</th>
								<th>
									상태
								</th>
								<th>
									멤버십사용여부
								</th>
								<th>
									좌표여부
								</th>
<%	IF BRAND_CODE = "01" THEN %>
								<th>배달료</th>
								<th>
									요기요여부
								</th>
								<th>
									온라인주문여부
								</th>
								<th>
									다날 여부
								</th>
								<th>
									다날 ID
								</th>
								<th>
									다날 SUB ID
								</th>
								<th>
									페이코인 여부
								</th>
								<th>
									페이코인 ID
								</th>
								<th>
									페이코 여부
								</th>
								<th>
									페이코 ID
								</th>
								<th>
									KB간편결제 여부
								</th>
								<th>
									KB간편결제 ID
								</th>
								<th>
									올리브페이 여부
								</th>
								<th>
									올리브페이 ID
								</th>
<%	END IF %>
							</tr>
<%
	SELCODE_B = ""	'서비스 유형 관리
	SELCODE_E = ""	'멤버십 사용 여부 관리
	Sql = "	Select I.code_kind, code_idx, code_name From bt_code_item I LEFT JOIN bt_code_detail D ON I.item_idx = D.item_idx " & _
		"	Where brand_code = '"& BRAND_CODE &"' And code_gb='S' And code_kind IN ('B','E')  " & _
		"	Order by code_kind, code_ord "
	Set Clist = conn.Execute(Sql)
	If Not Clist.eof Then 
		Do While Not Clist.Eof
			code_kind = Clist("code_kind")
			code_idx = Clist("code_idx")
			code_name = Clist("code_name")
			If code_kind = "B" Then SELCODE_B = SELCODE_B & code_idx & "^" & code_name & "|"
			If code_kind = "E" Then SELCODE_E = SELCODE_E & code_idx & "^" & code_name & "|"
			Clist.MoveNext
		Loop 
	End If

	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

    SDATE = Replace(SDATE,"-","")
    EDATE = Replace(EDATE,"-","")

	SqlFrom = "	FROM BT_BRANCH WITH(NOLOCK) "

	SqlWhere = " WHERE BRAND_CODE = '"& BRAND_CODE &"' "
	IF BRAND_CODE = "01" THEN
		SqlWhere = SqlWhere & " AND BRANCH_ID NOT IN ('7200701', '1364201', '7201701', '1324101', '7144701', '7211901', '7217301', '7217401', '7136101', '1321701', '1323601', '1333201')"
	END IF

	If Not FncIsBlank(SW) Then 
		If SM = "BN" Then SqlWhere = SqlWhere & " AND BRANCH_NAME LIKE '%"& SW &"%' "
		If SM = "ON" Then SqlWhere = SqlWhere & " AND BRANCH_OWNER_NAME LIKE '%"& SW &"%' "
	End If
	
	SqlOrder	= "ORDER BY BRANCH_ID "

	Sql = "SELECT * " & SqlFrom & SqlWhere & SqlOrder

	Sql = "SELECT * " & vbCrLf
	Sql = Sql & " , CASE WHEN CASE WHEN LEN(ISNULL(ORDER_YN, 'N')) > 0 THEN ORDER_YN ELSE ISNULL(ORDER_YN, 'N') END = 'Y' THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS ORDER_YN " & vbCrLf
	Sql = Sql & " , CASE WHEN LEN(ISNULL(danal_h_scpid, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS DANAL_YN " & vbCrLf
	Sql = Sql & " , CASE WHEN LEN(ISNULL(paycoin_cpid, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS PAYCOIN_YN " & vbCrLf
	Sql = Sql & " , CASE WHEN LEN(ISNULL(payco_cpid, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS PAYCO_YN " & vbCrLf
	Sql = Sql & " , CASE WHEN LEN(ISNULL(SGPAY_MERCHANT_V2, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS SGPAY_YN " & vbCrLf
	
	'올리브페이 추가 (2022. 8. 16)
	Sql = Sql & " , CASE WHEN LEN(ISNULL(ubpay_cpid, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS UBPAY_YN " & vbCrLf

	Sql = Sql & " , CASE WHEN ISNULL(WGS84_X, 0) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS WGS84 " & vbCrLf
	Sql = Sql & SqlFrom & SqlWhere & SqlOrder

	Set Rlist = conn.Execute(Sql)
	If Not Rlist.Eof Then 
		ArrSELCODE_E = Split(SELCODE_E,"|")
		num = 1
		Do While Not Rlist.Eof
			BRANCH_ID	= Rlist("BRANCH_ID")
			BRANCH_NAME		= Rlist("BRANCH_NAME")
			BRANCH_OWNER_NAME		= Rlist("BRANCH_OWNER_NAME")
			BRANCH_ADDRESS		= Rlist("BRANCH_ADDRESS")
			BRANCH_TEL		= Rlist("BRANCH_TEL")
			iType		= Rlist("BRANCH_TYPE")
			BRANCH_STATUS		= Rlist("BRANCH_STATUS")

			branch_services_code	= Rlist("branch_services_code")
			membership_yn_code	= Rlist("membership_yn_code")
			DELIVERY_FEE	= Rlist("DELIVERY_FEE")
			coupon_yn	= Rlist("coupon_yn")
			yogiyo_yn	= Rlist("yogiyo_yn")
			If BRANCH_STATUS = "10" Then 
				BRANCH_STATUS = "정상"
			Else
				BRANCH_STATUS = "폐점"
			End If 

			ONLINE_YN = Rlist("ORDER_YN")
			DANAL_YN = Rlist("DANAL_YN")
			DANAL_CPID = Rlist("danal_h_cpid")
			DANAL_SCPID = Rlist("danal_h_scpid")
			PAYCOIN_YN = Rlist("PAYCOIN_YN")
			PAYCOIN_ID = Rlist("paycoin_cpid")
			PAYCO_YN = Rlist("PAYCO_YN")
			PAYCO_ID = Rlist("payco_cpid")
			SGPAY_YN = Rlist("SGPAY_YN")
			SGPAY_ID = Rlist("SGPAY_MERCHANT_V2")
			
			'올리브페이 추가 (2022. 8. 16)
			UBPAY_YN = Rlist("UBPAY_YN")
			UBPAY_ID = Rlist("ubpay_cpid")
			WGS84 = Rlist("WGS84")
%>
							<tr>
								<td><%=num%></td>
								<td><%=BRANCH_ID%></td>
								<td><%=BRANCH_NAME%></td>
								<td><%=BRANCH_OWNER_NAME%></td>
								<td><%=BRANCH_ADDRESS%></td>
								<td><%=BRANCH_TEL%></td>
								<td><%=BRANCH_STATUS%></td>
								<td>
<%									For Cnt = 0 To Ubound(ArrSELCODE_E)
									SetCODE = ArrSELCODE_E(Cnt)
									If Not FncIsBlank(SetCODE) Then 
										ArrSetCODE = Split(SetCODE,"^")
										code_idx = ArrSetCODE(0)
										code_name = ArrSetCODE(1)
										If ""&membership_yn_code=""&code_idx Then
											Response.Write code_name
										End If
									End If 
									Next %>
								</td>
								<td><%=WGS84%></td>
<%	IF BRAND_CODE = "01" THEN %>
								<td><%=DELIVERY_FEE%></td>
								<td><%=yogiyo_yn%></td>
								<td><%=ONLINE_YN%></td>
								<td><%=DANAL_YN%></td>
								<td><%=DANAL_CPID%></td>
								<td><%=DANAL_SCPID%></td>
								<td><%=PAYCOIN_YN%></td>
								<td><%=PAYCOIN_ID%></td>
								<td><%=PAYCO_YN%></td>
								<td><%=PAYCO_ID%></td>
								<td><%=SGPAY_YN%></td>
								<td><%=SGPAY_ID%></td>
								<td><%=UBPAY_YN%></td>
								<td><%=UBPAY_ID%></td>
<%	END IF %>
							</tr>
<%
			num = num + 1
			Rlist.MoveNext
		Loop
	End If
	Rlist.Close
	Set Rlist = Nothing 
%>
						</table>
<%
'' 엑셀로 저장
	Dim FileName : FileName = "" & Date() & "_Store_Data"
	Response.ContentType = "application/x-msexcel"
	Response.CacheControl = "public"
	Response.AddHeader "Content-Disposition", "attachment;filename=" & FileName & ".xls"
%>
