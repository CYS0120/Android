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
								<li><label><input type="radio" name="curpage" onClick="document.location.href='store.asp?CD=<%=CD%>'">매장관리</label></li>
								<li><label><input type="radio" name="curpage" checked onClick="document.location.href='address.asp?CD=<%=CD%>'">주소관리</label></li>
							</ul>
						</th>
					</tr>
<%	END IF %>
					<tr>
						<th>
							<div class="board_select">
								<div class="board_search">
									<select name="SM" id="SM">
										<option value="BN"<% If SM = "BN" Then %> selected<% End If %>>법정동</option> 
										<option value="ON"<% If SM = "ON" Then %> selected<% End If %>>만료여부</option>
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


	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

    SDATE = Replace(SDATE,"-","")
    EDATE = Replace(EDATE,"-","")

	SqlFrom = "	FROM BT_ADDRESS_DONG WITH(NOLOCK) "

	SqlWhere = " WHERE 1=1 "

	If Not FncIsBlank(SW) Then 
		If SM = "BN" Then SqlWhere = SqlWhere & " AND B_CODE LIKE '%"& SW &"%' "
		If SM = "ON" Then SqlWhere = SqlWhere & " AND EXPIRE_YN LIKE '%"& SW &"%' "
	End If
	
	SqlOrder	= "ORDER BY H_CODE, B_CODE "

	Sql = "Select COUNT(b_code) CNT " & SqlFrom & SqlWhere
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
							<input type="button" value="엑셀 업로드" class="btn_white125" style="margin-left:10px;">
						</div>
					</div>
					<div class="list_content">
						<table>
								<tr>
									<th>NO</th>
									<th>시도명</th>
									<th>시군구명</th>
									<th>행정동코드</th>
									<th>읍면동명(행정동명)</th>
									<th>법정동코드</th>
									<th>동리명(법정동코드)</th>
									<th>생성일자</th>
									<th>말소일자</th>
									<th>말소여부</th>
									<th>관리</th>
								</tr>
<%
	BARND_NAME = FncBrandName(CD)

	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" * " & vbCrLf
    	Sql = Sql & " , CASE WHEN ISNULL(EXPIRE_YN, 'N') = 'N' THEN '<div style=''color:green''>N</div>' ELSE '<span style=''color:red;font-weight:bold;''>Y</div>' END AS EXPIRE_YN " & vbCrLf
		Sql = Sql & SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & " And B_CODE Not In " & vbCrLf
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " B_CODE "& SqlFrom & SqlWhere & vbCrLf
		Sql = Sql & SqlOrder & ")" & vbCrLf
		Sql = Sql & SqlOrder
		'response.write Sql & "<BR>"
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first

			Do While Not Rlist.Eof
				SIDO_NAME	= Rlist("SIDO_NAME")
				SIGUNGU_NAME		= Rlist("SIGUNGU_NAME")
				H_CODE		= Rlist("H_CODE")
				H_NAME		= Rlist("H_NAME")
				B_CODE		= Rlist("B_CODE")
				B_NAME		= Rlist("B_NAME")
				CREATE_DATE	= Rlist("CREATE_DATE")
				EXPIRE_DATE = Rlist("EXPIRE_DATE")
				EXPIRE_YN	= Rlist("EXPIRE_YN")
%>
								<tr>
									<td><%=num%></td>
									<td><%=SIDO_NAME%></td>
									<td><%=SIGUNGU_NAME%></td>
									<td><%=H_CODE%></td>
									<td><%=H_NAME%></td>
									<td><%=B_CODE%></td>
									<td><%=B_NAME%></td>
									<td><%=CREATE_DATE%></td>
									<td><%=EXPIRE_DATE%></td>
									<td><%=EXPIRE_YN%></td>
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