<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "G"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(LNUM) Then LNUM = 10

	Detail = "&LNUM="& LNUM
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script>
function Coupon_pop(cpnid){
	$.ajax({
		async: true,
		type: "POST",
		url: "coupon_prm_info_div.asp",
		data: {cpnid:cpnid},
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
//	if(f.USESDATE.value.length < 1){alert("유효기간을 입력해 주세요");f.USESDATE.focus();return;}
//	if(f.USEEDATE.value.length < 1){alert("유효기간을 입력해 주세요");f.USEEDATE.focus();return;}
	if(f.TOTCNT.value.length < 1){alert("발행건수를 입력해 주세요");f.TOTCNT.focus();return;}
	checkClick = 1;
	$.ajax({
		async: false,
		type: "POST",
		url: "coupon_prm_info_proc.asp",
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
                <div class="manager_popup_area" style="height:400px;">
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
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_pin.asp'">멤버십 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_prm.asp'" checked>프로모션 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_ebay_pin.asp'">이베이 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_partner.asp'">거래처 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_search.asp'">쿠폰조회</label></li>
									</ul>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
				</form>
<%
	's_Common_CouponList_2
	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	Sql = "UP_ADMIN_COUPON_PRM " & page & " , " & LNUM
	' Sql = "SELECT COUNT(*) CNT FROM (	SELECT T1.CPNID, T1.CD_PARTNER FROM "& BBQHOME_DB &".DBO.T_CPN T1 WITH(NOLOCK) WHERE T1.CPNTYPE = 'PR' ) T1 INNER JOIN "& BBQHOME_DB &".DBO.T_CPN_PARTNER T3 WITH(NOLOCK) ON T3.CD_PARTNER = T1.CD_PARTNER "
	Set Rlist = conn.Execute(Sql)
	if not Rlist.EOF then
		total_num = Rlist("TOT_ROW")
	else
		total_num = 0
	end if
	' Trs.close
	' Set Trs = Nothing 

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
							<select name="LNUM" id="LNUM" onChange="document.location.href='?LNUM='+this.value">
								<option value="10"<%If LNUM="10" Then%> selected<%End If%>>10</option>
								<option value="20"<%If LNUM="20" Then%> selected<%End If%>>20</option>
								<option value="50"<%If LNUM="50" Then%> selected<%End If%>>50</option>
								<option value="100"<%If LNUM="100" Then%> selected<%End If%>>100</option>
							</select>
						</div>
					</div>
					<div class="list_content">
						<table style="width:100%;">
							<tr>
                                <th>NO</th>
                                <th>쿠폰ID</th>
                                <th>발행업체</th>
                                <th>쿠폰명</th>
                                <th>사용기간</th>
                                <th>발행일</th>
                                <th>상품</th>
                                <th>사용건수</th>
							</tr>
<%
	If total_num > 0 Then
		STARTNUM = ( (page-1) * num_per_page) + 1
		ENDNUM = ( page * num_per_page)

		' Sql = "	SELECT T1.ROW_NUM, T1.CPNID,	" & _
		' 	"		CASE WHEN T1.STATUS = 1 AND CONVERT(VARCHAR(10), GETDATE(), 121) BETWEEN ISNULL(T2.USESDATE, '1900-01-01') AND ISNULL(T2.USEEDATE, '1900-01-01')	" & _
		' 	"			THEN '<span style=''color:green''>[진행] </span>' 	" & _
		' 	"			ELSE '<span style=''color:red''>[종료] </span>'	" & _
		' 	"		END + T1.CPNNAME	" & _
		' 	"		AS CPNNAME,	" & _
		' 	"		T1.CPNTYPE, T1.MENUID, T1.OPTIONID,	" & _
		' 	"		T2.USESDATE, T2.USEEDATE, T2.REGDATE,	" & _
		' 	"		DBO.FN_MENU_INFO(T1.MENUID, T1.OPTIONID) AS MENUNAME,	" & _
		' 	"		T1.CD_PARTNER, T3.NM_PARTNER,	" & _
		' 	"		T2.USED_CNT, T2.TOT_CNT	" & _
		' 	"	FROM (	" & _
		' 	"		SELECT	" & _
		' 	"			RANK() OVER (ORDER BY T1.REGDATE DESC) ROW_NUM,	" & _
		' 	"			T1.CPNID, T1.CPNNAME, T1.CPNTYPE, T1.MENUID, T1.OPTIONID, T1.STATUS, T1.CD_PARTNER	" & _
		' 	"		FROM "& BBQHOME_DB &".DBO.T_CPN T1 WITH(NOLOCK)	" & _
		' 	"		WHERE T1.CPNTYPE = 'PR'	" & _
		' 	"	) T1	" & _
		' 	"	INNER JOIN "& BBQHOME_DB &".DBO.T_CPN_PARTNER T3 WITH(NOLOCK) ON T3.CD_PARTNER = T1.CD_PARTNER	" & _
		' 	"	LEFT JOIN (	" & _
		' 	"		SELECT	" & _
		' 	"			CPNID,	" & _
		' 	"			MIN(PUBDATE) AS REGDATE,	" & _
		' 	"			MIN(USESDATE) AS USESDATE,	" & _
		' 	"			MAX(USEEDATE) AS USEEDATE,	" & _
		' 	"			SUM(CASE WHEN STATUS = 9 THEN 1 ELSE 0 END) AS USED_CNT,	" & _
		' 	"			COUNT(*) AS TOT_CNT	" & _
		' 	"		FROM "& BBQHOME_DB &".DBO.T_CPN_MST WITH(NOLOCK)	" & _
		' 	"		WHERE	" & _
		' 	"			CPNID IN (SELECT CPNID FROM "& BBQHOME_DB &".DBO.T_CPN T1 WITH(NOLOCK) WHERE T1.CPNTYPE = 'PR')	" & _
		' 	"			AND STATUS IN (1, 9)	" & _
		' 	"		GROUP BY CPNID	" & _
		' 	"	) T2	" & _
		' 	"	ON T2.CPNID = T1.CPNID	" & _
		' 	"	WHERE T1.ROW_NUM BETWEEN "& STARTNUM &" AND "& ENDNUM &"	" & _
		' 	"	ORDER BY T1.ROW_NUM Asc	"
		' Set Rlist = conn.Execute(Sql)

		If Not Rlist.Eof Then 
			num	= total_num - first
			Do While Not Rlist.Eof
				CPNID	= Rlist("CPNID")
				CPNNAME	= Rlist("CPNNAME")
				CPNTYPE	= Rlist("CPNTYPE")
				MENUID	= Rlist("MENUID")
				OPTIONID	= Rlist("OPTIONID")
				USESDATE	= Rlist("USESDATE")
				USEEDATE	= Rlist("USEEDATE")
				REGDATE	= Rlist("REGDATE")
				MENUNAME	= Rlist("MENUNAME")
				CD_PARTNER	= Rlist("CD_PARTNER")
				NM_PARTNER	= Rlist("NM_PARTNER")
				USED_CNT	= Rlist("USED_CNT")
				TOT_CNT	= Rlist("TOT_CNT")
%>
							<tr>
								<td><span><%=num%></span></td>
								<td><span style="cursor:pointer" onClick="javascript:Coupon_pop('<%=CPNID%>')"><%=CPNID%></span></td>
								<td><span><%=NM_PARTNER%></span></td>
								<td><span><a href="coupon_prm_pin.asp?cpnid=<%=CPNID%>"><%=CPNNAME%></a></span></td>
								<td><span><%=USESDATE%> ~ <%=USEEDATE%></span></td>
								<td><span><%=REGDATE%></span></td>
								<td><span><%=MENUNAME%></span></td>
								<td><span><%=USED_CNT%> / <%=TOT_CNT%></span></td>
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