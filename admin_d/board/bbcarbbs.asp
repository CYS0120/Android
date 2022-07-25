<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "E"
	CUR_PAGE_SUBCODE = ""
	CD = InjRequest("CD")
	If Not FncIsBlank(CD) Then CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
	BBSCODE = InjRequest("BBSCODE")

	TDATE = Date
	YDATE = Date - 1

	sYY		= Year(Date)
	sMM		= Right("0"&month(Date),"2")
	TMSDATE = DateSerial(sYY,sMM,1)		'당월 1일
	TMEDATE = Date 
	PMSDATE = DateSerial(sYY,sMM-1,1)		'전월 1일
	PMEDATE = CDate(TMSDATE) - 1			'전월 마지막일

	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")
	YR		= InjRequest("YR")
	MTH		= InjRequest("MTH")
	CTY		= InjRequest("CTY")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(SDATE) Then SDATE = TMSDATE 
	If FncIsBlank(EDATE) Then EDATE = Date
	If FncIsBlank(LNUM) Then LNUM = 10
	DetailN = "&YR="& YR & "&MTH="& MTH & "&CTY="& CTY & "&SDATE="& SDATE & "&EDATE="& EDATE
	Detail = "&CD="& CD & DetailN & "&LNUM="& LNUM 

	'비비카 신청 게시판이 아닌 경우 이동
	If BBSCODE <> "A09" Then 
		Response.redirect "bbcarbbs.asp?CD="& CD &"&BBSCODE="& BBSCODE
	End If

%>
<!-- #include virtual="/inc/admin_check.asp" -->
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script language="JavaScript">
function setDate(SD,ED,BGB){
	$('#BGB').val(BGB);
	$('#SDATE').val(SD);
	$('#EDATE').val(ED);
	$('#searchfrm').submit();
}
function ExcelDown(IS_IMG){
	//if ($('#SDATE').val() == $('#EDATE').val())
	{
		if (IS_IMG == "NO")
		{
			// alert("TEST");
			document.location.href="bbcarbbs_excel.asp?GO=EXCEL&IMG=NO<%=Detail%>";
		}
		else
		{
			document.location.href="bbcarbbs_excel.asp?GO=EXCEL<%=Detail%>";
		}
	}
	//else
	//{
	//	alert("엑셀 다운로드는 하루씩만 가능합니다.");
	//}
}
</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>게시판관리</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <div class="content">
            <div class="section section_board">
				<form id="searchfrm" name="searchfrm" method="get">
				<input type="hidden" name="LNUM" value="<%=LNUM%>">
				<input type="hidden" name="CD" value="<%=CD%>">
				<table>
					<tr>
						<th>
							<div class="list_select">
								<ul>
<%
	Sql = "Select MENU_CODE2, MENU_NAME, BBS From bt_code_menu with(nolock) Where menu_code='E' And menu_depth=2 And menu_code1='"& CD &"' "
	If SITE_ADM_LV <> "S" Then
		Sql = Sql & " And menu_code2 IN ('"& Replace(ADMIN_CHECKMENU2,",","','") &"') "
	End If
	Sql = Sql & " Order by menu_order "
	Set Mlist = conn.Execute(Sql)
	If Not Mlist.eof Then 
		Do While Not Mlist.Eof
			BBSCD = Mlist("MENU_CODE2")
			BBSNM = Mlist("MENU_NAME")
			BBS = Mlist("BBS")
			If FncIsBlank(BBSCODE) Then BBSCODE = BBSCD
%>
									<li><label><input type="radio" name="BBSCODE" value="<%=BBSCD%>"<%If BBSCODE = BBSCD Then%> checked<%End If%> onClick="document.location.href='<%=BBS%>?CD=<%=CD%>&BBSCODE=<%=BBSCD%>'"><span><%=BBSNM%></span></label></li>
<%
			Mlist.MoveNext
		Loop
	End If 
%>
								</ul>
							</div>
						</th>
					</tr>
					<tr>
						<th>
							<ul>
								<li>
									<label>접수일:</label>
									<input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly style="width:100px"> ~
									<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly style="width:100px">
								</li>
								<li>
									<input type="button" value="금일" class="btn_white<%If BGB="T" Then%> on<%End If%>" onClick="setDate('<%=TDATE%>','<%=TDATE%>','T')">
									<input type="button" value="전일" class="btn_white<%If BGB="P" Then%> on<%End If%>" onClick="setDate('<%=YDATE%>','<%=YDATE%>','P')">
									<input type="button" value="전월" class="btn_white<%If BGB="M" Then%> on<%End If%>" onClick="setDate('<%=PMSDATE%>','<%=PMEDATE%>','M')">
									<input type="button" value="당월" class="btn_white<%If BGB="N" Then%> on<%End If%>" onClick="setDate('<%=TMSDATE%>','<%=TMEDATE%>','N')">
								</li>
							</ul>
							<ul>	
								<li>
									<label>신청년도:</label>
									<select name="YR" id="YR">
										<option value=""<%If YR="" Then%> selected<%End If%>>전체</option>
										<option value="2022"<%If YR="2022" Then%> selected<%End If%>>2022</option>
									</select>
								</li>
								<li>
									<label>신청월:</label>
									<select name="MTH" id="MTH">
										<option value=""<%If MTH="" Then%> selected<%End If%>>전체</option>
										<option value="01"<%If MTH="01" Then%> selected<%End If%>>1</option>
										<option value="02"<%If MTH="02" Then%> selected<%End If%>>2</option>
										<option value="03"<%If MTH="03" Then%> selected<%End If%>>3</option>
										<option value="04"<%If MTH="04" Then%> selected<%End If%>>4</option>
										<option value="05"<%If MTH="05" Then%> selected<%End If%>>5</option>
										<option value="06"<%If MTH="06" Then%> selected<%End If%>>6</option>
										<option value="07"<%If MTH="07" Then%> selected<%End If%>>7</option>
										<option value="08"<%If MTH="08" Then%> selected<%End If%>>8</option>
										<option value="09"<%If MTH="09" Then%> selected<%End If%>>9</option>
										<option value="10"<%If MTH="10" Then%> selected<%End If%>>10</option>
										<option value="11"<%If MTH="11" Then%> selected<%End If%>>11</option>
										<option value="12"<%If MTH="12" Then%> selected<%End If%>>12</option>
									</select>
								</li>
								<li>
									<label>신청지역:</label>
									<select name="CTY" id="CTY">
										<option value=""<%If CTY="" Then%> selected<%End If%>>전체</option>
										<option value="서울특별시"<%If CTY="서울특별시" Then%> selected<%End If%>>서울특별시</option>
										<option value="부산광역시"<%If CTY="부산광역시" Then%> selected<%End If%>>부산광역시</option>
										<option value="대구광역시"<%If CTY="대구광역시" Then%> selected<%End If%>>대구광역시</option>
										<option value="인천광역시"<%If CTY="인천광역시" Then%> selected<%End If%>>인천광역시</option>
										<option value="광주광역시"<%If CTY="광주광역시" Then%> selected<%End If%>>광주광역시</option>
										<option value="대전광역시"<%If CTY="대전광역시" Then%> selected<%End If%>>대전광역시</option>
										<option value="울산광역시"<%If CTY="울산광역시" Then%> selected<%End If%>>울산광역시</option>
										<option value="세종특별자치시"<%If CTY="세종특별자치시" Then%> selected<%End If%>>세종특별자치시</option>
										<option value="경기도"<%If CTY="경기도" Then%> selected<%End If%>>경기도</option>
										<option value="강원도"<%If CTY="강원도" Then%> selected<%End If%>>강원도</option>
										<option value="충청북도"<%If CTY="충청북도" Then%> selected<%End If%>>충청북도</option>
										<option value="충청남도"<%If CTY="충청남도" Then%> selected<%End If%>>충청남도</option>
										<option value="전라북도"<%If CTY="전라북도" Then%> selected<%End If%>>전라북도</option>
										<option value="전라남도"<%If CTY="전라남도" Then%> selected<%End If%>>전라남도</option>
										<option value="경상북도"<%If CTY="경상북도" Then%> selected<%End If%>>경상북도</option>
										<option value="경상남도"<%If CTY="경상남도" Then%> selected<%End If%>>경상남도</option>
										<option value="제주특별자치도"<%If CTY="제주특별자치도" Then%> selected<%End If%>>제주특별자치도</option>
									</select>
								</li>
								<li width="100%" style="align:right;">
									<input type="submit" value="검색" class="btn_white">
									<input type="button" value="EXCEL" class="btn_white" onClick="ExcelDown('')">
									<input type="button" value="EXCEL(NOIMG)" class="btn_white" onClick="ExcelDown('NO')">
								</li>
							</ul>
						</th>
					</tr>
				</table>
				</form>
<%
	Detail = Detail &"&BBSCODE="& BBSCODE

	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	Sql = ""
	Sql = Sql & "	UP_LIST_MEMBER_BBCAR "
	Sql = Sql & "	    @TP = 'PAGE' "
	Sql = Sql & "	    , @DATE_S = '" & SDATE & "' "
	Sql = Sql & "	    , @DATE_E = '" & CDate(EDATE)+1 & "' "
	Sql = Sql & "	    , @YR = '" & YR & "' "
	Sql = Sql & "	    , @MTH = '" & MTH & "' "
	Sql = Sql & "	    , @CITY = '" & CTY & "' "
	Sql = Sql & "	    , @PAGE_SIZE = " & num_per_page & " "
	Sql = Sql & "	    , @PAGE = " & page & " "

'response.write Sql
'response.end

	Set Rlist = conn.Execute(Sql)
	if not Rlist.eof Then
		total_num = Rlist("TOT_CNT")
	end if

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
                            <select name="LNUM" id="LNUM" onChange="document.location.href='?CD=<%=CD%>&BBSCODE=<%=BBSCODE%><%=DetailN%>&LNUM='+this.value">
                                <option value="10"<%If LNUM="10" Then%> selected<%End If%>>10</option>
                                <option value="20"<%If LNUM="20" Then%> selected<%End If%>>20</option>
                                <option value="50"<%If LNUM="50" Then%> selected<%End If%>>50</option>
                                <option value="100"<%If LNUM="100" Then%> selected<%End If%>>100</option>
                            </select>
						</div>
					</div>
					<div class="list_content list_thum_img">
						<table style="width:100%;">
							<!--colgroup>
								<col width="3%">
								<col width="5%">
								<col width="20%">
								<col width="44%">
								<col width="11%">
								<col width="8%">
								<col width="9%">
							</colgroup-->
								<tr>
									<th>NO</th>
									<th>신청년월</th>
									<th>신청지역</th>
									<th width="44%">제목</th>
									<th>작성자</th>
									<th>작성일</th>
								</tr>
<%
	ImgSiteUrl = FncGetSiteUrl(CD)

	If total_num > 0 Then 
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				idx	= Rlist("idx")
				visit_ym	= Rlist("visit_ym")
				visit_city	= Rlist("visit_city")
				title	= Rlist("title")
				member_name	= Rlist("member_name")
				regdate = Left(Rlist("regdate"),21)
%>
								<tr class="thum_padding">
									<td><span><%=idx%></span></td>
									<td><span><%=visit_ym%></span></td>
									<td><span><%=visit_city%></span></td>
									<td><span style="cursor: pointer" onClick="document.location.href='bbcarbbs_form.asp?idx=<%=idx%>&CD=<%=CD%>&BBSCODE=<%=BBSCODE%>'"><%=title%></span></td>
									<td><span><%=member_name%></span></td>
									<td><span><%=regdate%></span></td>
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