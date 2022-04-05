<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "C"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	BRAND_CODE	= FncBrandDBCode(CD)
	SM		= InjRequest("SM")
	SW		= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10

	DetailN = "CD="& CD & "&SM="& SM & "&SW="& SW
	Detail = "&LNUM="& LNUM & "&"& DetailN
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>매장관리</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
<script type="text/javascript">
function MemberShipChange(BRANCH_ID,VAL){
	$.ajax({
		async: false,
		type: "POST",
		url: "store_proc.asp",
		data: {"CD":"<%=CD%>","CH":"M","BRANCH_ID":BRANCH_ID,"VAL":VAL},
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
			}else{
				alert(data.split("^")[1]);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function ECouponChange(BRANCH_ID,VAL){
	$.ajax({
		async: false,
		type: "POST",
		url: "store_proc.asp",
		data: {"CD":"<%=CD%>","CH":"C","BRANCH_ID":BRANCH_ID,"VAL":VAL},
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
			}else{
				alert(data.split("^")[1]);
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
function ExcelDown(){
	document.location.href="store_excel.asp?GO=EXCEL<%=Detail%>";
}
</script>
        <div class="content">
			<div class="section section_store_list">
				<form id="searchfrm" name="searchfrm" method="get">
				<input type="hidden" name="CD" value="<%=CD%>">
				<input type="hidden" name="LNUM" value="<%=LNUM%>">
				<table>
<%	IF BRAND_CODE = "01" THEN %>
					<tr>
						<th>
							<ul>
								<li><label><input type="radio" name="curpage" checked onClick="document.location.href='store.asp?CD=<%=CD%>'">매장관리</label></li>
								<li><label><input type="radio" name="curpage" onClick="document.location.href='address.asp?CD=<%=CD%>'">주소관리</label></li>
							</ul>
						</th>
					</tr>
<%	END IF %>					<tr>
						<th>
							<div class="board_select">
								<div class="board_search">
									<select name="SM" id="SM">
										<option value="BN"<% If SM = "BN" Then %> selected<% End If %>>매장명</option> 
										<option value="ON"<% If SM = "ON" Then %> selected<% End If %>>점주명</option>
									</select>
									<input type="text" name="SW" value="<%=SW%>">
									<input type="submit" value="검색" class="btn_white">
									<input type="button" value="Excel" class="btn_white" onClick="ExcelDown()">
								</div>
							</div>
						</th>
					</tr>
				</table>
				</form>
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
	SqlWhere = SqlWhere & " AND BRANCH_ID NOT IN ('7200701', '1364201', '7201701', '1324101', '7144701', '7211901', '7217301', '7217401', '7136101', '1321701', '1323601', '1333201')"

	If Not FncIsBlank(SW) Then 
		If SM = "BN" Then SqlWhere = SqlWhere & " AND BRANCH_NAME LIKE '%"& SW &"%' "
		If SM = "ON" Then SqlWhere = SqlWhere & " AND BRANCH_OWNER_NAME LIKE '%"& SW &"%' "
	End If
	
	SqlOrder	= "ORDER BY BRANCH_ID "

	Sql = "Select COUNT(BRANCH_ID) CNT " & SqlFrom & SqlWhere
	Set Trs = conn.Execute(Sql)
	total_num = Trs("CNT")
	Trs.close
	Set Trs = Nothing 

	If total_num = 0 Then
		first  = 1
	Else
		first  = num_per_page*(page-1)
	End If 

	total_page	= ceil(total_num / num_per_page)
	total_block	= ceil(total_page / page_per_block)
	block       = ceil(page / page_per_block)
	first_page  = (block-1) * page_per_block+1
	last_page   = block * page_per_block
%>
				<div class="list">
					<div class="list_top">
						<div class="list_total">
							<span>Total:<p><%=total_num%>건</p></span>
						</div>
						<div class="list_num">
							<select name="LNUM" id="LNUM" onChange="document.location.href='?<%=DetailN%>&LNUM='+this.value">
								<option value="10"<%If LNUM="10" Then%> selected<%End If%>>10</option>
								<option value="20"<%If LNUM="20" Then%> selected<%End If%>>20</option>
								<option value="50"<%If LNUM="50" Then%> selected<%End If%>>50</option>
								<option value="100"<%If LNUM="100" Then%> selected<%End If%>>100</option>
							</select>
						</div>
					</div>
					<div class="list_content">
						<table>
								<tr>
									<th>NO</th>
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
										멤버십
									</th>
									<th>
										좌표
									</th>
<%	IF BRAND_CODE = "01" THEN %>
									<th>배달료</th>
									<th>
										온라인주문
									</th>
									<th>
										다날
									</th>
									<th>
										페이코인
									</th>
									<th>
										페이코
									</th>
									<th>
										KB간편결제
									</th>
<%	END IF %>
									<th>관리</th>
								</tr>
<%
	BARND_NAME = FncBrandName(CD)

	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" * " & vbCrLf
    	Sql = Sql & " , CASE WHEN CASE WHEN LEN(ISNULL(ORDER_YN, 'N')) > 0 THEN ORDER_YN ELSE ISNULL(ORDER_YN, 'N') END = 'Y' THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS ORDER_YN " & vbCrLf
    	Sql = Sql & " , CASE WHEN LEN(ISNULL(danal_h_cpid, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS DANAL_YN " & vbCrLf
    	Sql = Sql & " , CASE WHEN LEN(ISNULL(paycoin_cpid, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS PAYCOIN_YN " & vbCrLf
    	Sql = Sql & " , CASE WHEN LEN(ISNULL(payco_cpid, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS PAYCO_YN " & vbCrLf
    	Sql = Sql & " , CASE WHEN LEN(ISNULL(sgpay_merchant_v2, '')) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS SGPAY_YN " & vbCrLf
    	Sql = Sql & " , CASE WHEN ISNULL(WGS84_X, 0) > 0 THEN '<div style=''color:green''>Y</div>' ELSE '<span style=''color:red;font-weight:bold;''>N</div>' END AS WGS84 " & vbCrLf
		Sql = Sql & SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & " And BRANCH_ID Not In " & vbCrLf
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " BRANCH_ID "& SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & SqlOrder & ")" & vbCrLf
		Sql = Sql & SqlOrder
		'response.write Sql & "<BR>"
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
'			ArrSELCODE_B = Split(SELCODE_B,"|")
			ArrSELCODE_E = Split(SELCODE_E,"|")

			Do While Not Rlist.Eof
				BRANCH_ID	= Rlist("BRANCH_ID")
				BRANCH_NAME		= Rlist("BRANCH_NAME")
				BRANCH_OWNER_NAME		= Rlist("BRANCH_OWNER_NAME")
				BRANCH_ADDRESS		= Rlist("BRANCH_ADDRESS")
				BRANCH_TEL		= Rlist("BRANCH_TEL")
				iType		= Rlist("BRANCH_TYPE")
				BRANCH_STATUS		= Rlist("BRANCH_STATUS")
'Response.End 

				branch_services_code	= Rlist("branch_services_code")
				membership_yn_code	= Rlist("membership_yn_code")
				DELIVERY_FEE	= Rlist("DELIVERY_FEE")
				coupon_yn	= Rlist("coupon_yn")
				If BRANCH_STATUS = "10" Then 
					BRANCH_STATUS = "정상"
				Else
					BRANCH_STATUS = "폐점"
				End If

				ONLINE_YN = Rlist("ORDER_YN")
				DANAL_YN = Rlist("DANAL_YN")
				PAYCOIN_YN = Rlist("PAYCOIN_YN")
				PAYCO_YN = Rlist("PAYCO_YN")
				SGPAY_YN = Rlist("SGPAY_YN")
				WGS84 = Rlist("WGS84")

'				branch_services_name = ""
'				For Cnt = 0 To Ubound(ArrSELCODE_B)
'					SetCODE = ArrSELCODE_B(Cnt)
'					If Not FncIsBlank(SetCODE) Then 
'						ArrSetCODE = Split(SetCODE,"^")
'						code_idx = ArrSetCODE(0)
'						code_name = ArrSetCODE(1)
'						If FncInStr(branch_services_code,code_idx) Then
'							If Not FncIsBlank(branch_services_name) Then branch_services_name = branch_services_name & ", "
'							branch_services_name = branch_services_name & code_name
'						End If
'					End If
'				Next
%>
								<tr>
									<td><%=num%></td>
									<td><%=BRANCH_NAME%></td>
									<td><%=BRANCH_OWNER_NAME%></td>
									<td><%=BRANCH_ADDRESS%></td>
									<td><%=BRANCH_TEL%></td>
									<td><%=BRANCH_STATUS%></td>
									<td>
										<select name="membership" id="membership" onChange="MemberShipChange('<%=BRANCH_ID%>',this.value)">
											<option value="">멤버십선택</option>
<%									For Cnt = 0 To Ubound(ArrSELCODE_E)
										SetCODE = ArrSELCODE_E(Cnt)
										If Not FncIsBlank(SetCODE) Then 
											ArrSetCODE = Split(SetCODE,"^")
											code_idx = ArrSetCODE(0)
											code_name = ArrSetCODE(1)
%>
											<option value="<%=code_idx%>"<%If ""&membership_yn_code=""&code_idx Then%> selected<%End If%>><%=code_name%></option>
<%										End If 
									Next %>
										</select>
									</td>
									<td><%=WGS84%></td>
<%	IF BRAND_CODE = "01" THEN %>
									<td><%=DELIVERY_FEE%></td>
									<td><%=ONLINE_YN%></td>
									<td><%=DANAL_YN%></td>
									<td><%=PAYCOIN_YN%></td>
									<td><%=PAYCO_YN%></td>
									<td><%=SGPAY_YN%></td>
<%	END IF %>
									<td><input type="button" value="수정" class="btn_white" onClick="document.location.href='store_info.asp?CD=<%=CD%>&BRCD=<%=BRANCH_ID%>'"></td>
								</tr>
<%
				num = num - 1
				Rlist.MoveNext
			Loop
		End If
		Rlist.Close
		Set Rlist = Nothing 
	End If 
%>
						</table>
					</div>
					<div class="list_foot">
<!-- #include virtual="/inc/paging.asp" -->
					</div>
				</div>
			</div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>