<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	CTP		= InjRequest("CTP")
	USE		= InjRequest("USE")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10

	DetailN = "CTP="& CTP & "&USE="& USE
	Detail = "&LNUM="& LNUM & "&"& DetailN
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function Coupon_pop(CPNID){
	$.ajax({
		async: true,
		type: "POST",
		url: "coupon_info_div.asp",
		data: {"CPNID":CPNID},
		cache: false,
		dataType: "html",
		success: function (data) {
			if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
			}else{
				$("#coupon_info_div").html(data);
				wrapWindowByMask();
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
var checkClick = 0;
function CheckInput(){
	if ( checkClick == 1 ) {
		alert('등록중입니다. 잠시 기다려 주시기 바랍니다.');
		return;
	}
	var f = document.coupon_info;
	if(f.CPNNAME.value.length < 1){alert("쿠폰명을 입력해 주세요");f.CPNNAME.focus();return;}
	if(f.DISCOUNT.value.length < 1){alert("할인금액을 입력해 주세요");f.DISCOUNT.focus();return;}
	if(f.EXPDATE.value.length < 1){alert("유효기간을 입력해 주세요");f.EXPDATE.focus();return;}
	checkClick = 1;
	$.ajax({
		async: false,
		type: "POST",
		url: "coupon_info_proc.asp",
		data: $("#coupon_info").serialize(),
		dataType : "text",
		success: function(data) {
			if (data.split("^")[0] == "Y") {
				document.location.reload();
			}else{
				alert(data.split("^")[1]);
				checkClick = 0;
			}
		},
		error: function(data, status, err) {
			checkClick = 0;
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>쿠폰관리</p> > <p>E-쿠폰관리</p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
        <!--popup-->
        <div class="mask"></div>
        <div class="window">
            
            <div class="sitemap_wrap">
                <!--content-->
                <div class="manager_popup_area" style="height:290px;">
					<form name="coupon_info" id="coupon_info" method="post">
					<div id="coupon_info_div">

					</div>
                    </form>
                </div>
                <!--//content-->
            </div>
        </div>
        <!--//popup-->

        <div class="content">
            <div class="section section_couponlist">
				<form id="searchfrm" name="searchfrm" method="get">
				<input type="hidden" name="LNUM" value="<%=LNUM%>">
				<div class="section_couponlist_sel">
					<table>
						<tbody>
							<tr>
								<th>
									<ul>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_pin.asp'" checked>멤버십 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_prm.asp'">프로모션 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_ebay_pin.asp'">이베이 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_partner.asp'">거래처 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_search.asp'">쿠폰조회</label></li>
									</ul>
								</th>
							</tr>
							<tr>
								<th>
									<ul>
										<li><input type="radio" name="boardlist2" onClick="document.location.href='coupon_pin.asp'"><label>사용현황</label></li>
										<li><input type="radio" name="boardlist2" onClick="document.location.href='coupon.asp'" checked><label>발급관리</label></li>
										<div class="couponlist_search">
											<div>
												<span>종류:</span>
												<select name="CTP" id="CTP" onChange="document.location.href='?CTP='+this.value+'&USE=<%=USE%>&LNUM=<%=LNUM%>'">
													<option value=""<%If CTP="" Then%> selected<%End If%>>전체</option>
													<option value="M"<%If CTP="M" Then%> selected<%End If%>>회원가입</option>
													<option value="D"<%If CTP="D" Then%> selected<%End If%>>기념일</option>
												</select>
											</div>
											<div>
												<span>사용여부:</span>
												<select name="USE" id="USE" onChange="document.location.href='?CTP=<%=CTP%>&USE='+this.value+'&LNUM=<%=LNUM%>'">
													<option value=""<%If USE="" Then%> selected<%End If%>>전체</option>
													<option value="Y"<%If USE="Y" Then%> selected<%End If%>>정상사용</option>
													<option value="N"<%If USE="N" Then%> selected<%End If%>>미사용</option>
												</select>
											</div>
										</div>
									</ul>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
				</form>
<%
	's_Common_CouponList
	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	SqlFrom = "	FROM "& BBQHOME_DB &".DBO.T_CPN CPN WITH(NOLOCK) "
	SqlWhere = " WHERE CPN.CPNTYPE IN ('MEM','ANI') "

	If Not FncIsBlank(CTP) Then	
		If CTP = "M" Then 
			SqlWhere = SqlWhere & " AND CPN.CPNTYPE='MEM' "
		Else
			SqlWhere = SqlWhere & " AND CPN.CPNTYPE='ANI' "
		End If 
	End If 	

	If Not FncIsBlank(USE) Then	
		If USE = "Y" Then 
			SqlWhere = SqlWhere & " AND CPN.STATUS='1' "
		Else
			SqlWhere = SqlWhere & " AND CPN.STATUS='9' "
		End If
	End If 	

	SqlOrder	= "ORDER BY CPN.CPNID DESC"

	Sql = "Select COUNT(CPN.CPNID) CNT " & SqlFrom & SqlWhere
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
							<span>Total:<p> <%=total_num%>건</p></span>
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
						<table style="width:100%;">
							<colgroup>
								<col width="4%">
								<col width="8%">
								<col width="28%">
								<col width="15%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
								<col width="10%">
							</colgroup>
							
							<tr>
								<th>NO</th>
								<th>구분</th>
								<th>쿠폰명</th>
								<th>할인금액</th>
								<th>유효기간</th>
								<th>등록일</th>
								<th>사용여부</th>
								<th>관리</th>
							</tr>
<%
	If total_num > 0 Then 
		Sql = "SELECT Top "&num_per_page&" CPN.* " & SqlFrom & SqlWhere
		Sql = Sql & " And CPN.CPNID Not In "
		Sql = Sql & "(SELECT TOP " & ((page - 1) * num_per_page) & " CPN.CPNID "& SqlFrom & SqlWhere
		Sql = Sql & SqlOrder & ")"
		Sql = Sql & SqlOrder
		Set Rlist = conn.Execute(Sql)
		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				CPNID	= Rlist("CPNID")
				CPNTYPE	= Rlist("CPNTYPE")
				CPNNAME	= Rlist("CPNNAME")
				DISCOUNT	= Rlist("DISCOUNT")
				EXPDATE	= Rlist("EXPDATE")
				REGDATE	= Left(Rlist("REGDATE"),10)
				STATUS	= Rlist("STATUS")

				IF CPNTYPE="MEM" THEN
					CPNTYPE_TXT="회원가입"
				ELSE
					CPNTYPE_TXT="기념일"
				END If

				IF STATUS="1" THEN
					STATUS_TXT="정상사용"
				ELSE
					STATUS_TXT="사용안함"
				END If
%>
							<tr>
								<td><span><%=num%></span></td>
								<td><span><%=CPNTYPE_TXT%></span></td>
								<td><span><a href="coupon_pin.asp?cpnid=<%=CPNID%>"><%=CPNNAME%></a></span></td>
								<td><span><%=DISCOUNT%> 원</span></td>
								<td><span><%=EXPDATE%> 일</span></td>
								<td><span><%=REGDATE%></span></td>
								<td><span><%=STATUS_TXT%></span></td>
								<td><button type="button" onClick="Coupon_pop('<%=CPNID%>')" class="btn_red">수정</button></td>
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
						<div style="display:inline-block;float:right;">
							<button type="button" onClick="Coupon_pop('')" class="btn_red125">등록</button>
						</div>
					</div>
				</div>
			</div>
		</div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>