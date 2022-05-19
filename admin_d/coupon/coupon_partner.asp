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
        <div class="content">
            <div class="section section_couponlist">
				<form id="searchfrm" name="searchfrm" method="get">
				<div class="section_couponlist_sel">
					<table>
						<tbody>
							<tr>
								<th>
									<ul>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_pin.asp'">멤버십 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_prm.asp'">프로모션 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_money.asp'">금액권</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_ebay_pin.asp'">이베이 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_partner.asp'" checked>거래처 쿠폰</label></li>
										<li><label><input type="radio" name="boardlist" onClick="document.location.href='coupon_search.asp'">쿠폰조회</label></li>
									</ul>
								</th>
							</tr>
						</tbody>
					</table>
				</div>
				</form>
<%
	's_Common_CouponList_3
	num_per_page	= LNUM	'페이지당 보여질 갯수
	page_per_block	= 10	'이동블럭

	page = InjRequest("page")
	If page = "" Then page = 1

	Admin_RID = ""	'어떤값인지??

	Sql = "SELECT COUNT(*) CNT FROM "& BBQHOME_DB &".DBO.T_CPN T1 WITH(NOLOCK) INNER JOIN "& BBQHOME_DB &".DBO.T_CPN_PARTNER T2 WITH(NOLOCK) ON T2.CD_PARTNER = T1.CD_PARTNER AND T2.ADM_ID = '"& Admin_RID &"' WHERE T1.CPNTYPE = 'PR' "
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
							<tr>
                                <th>NO</th>
                                <th>쿠폰ID</th>
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

		Sql = "	SELECT T1.ROW_NUM, T1.CPNID,	" & _
			"		CASE WHEN T1.STATUS = 1 AND CONVERT(VARCHAR(10), GETDATE(), 121) BETWEEN ISNULL(T2.USESDATE, '1900-01-01') AND ISNULL(T2.USEEDATE, '1900-01-01')	" & _
			"			THEN '<span style=''color:green''>[진행] </span>' 	" & _
			"			ELSE '<span style=''color:red''>[종료] </span>'	" & _
			"		END + T1.CPNNAME	" & _
			"		AS CPNNAME,	" & _
			"		T1.CPNTYPE, T1.MENUID, T1.OPTIONID,	" & _
			"		T2.USESDATE, T2.USEEDATE, T2.REGDATE,	" & _
			"		DBO.FN_MENU_INFO(T1.MENUID, T1.OPTIONID) AS MENUNAME,	" & _
			"		T2.USED_CNT, T2.TOT_CNT	" & _
			"	FROM (	" & _
			"		SELECT	" & _
			"			RANK() OVER (ORDER BY T1.REGDATE DESC) ROW_NUM,	" & _
			"			T1.CPNID,	" & _
			"			T1.CPNNAME,	" & _
			"			T1.CPNTYPE, T1.MENUID, T1.OPTIONID,	" & _
			"			T1.STATUS	" & _
			"		FROM "& BBQHOME_DB &".DBO.T_CPN T1 WITH(NOLOCK)	" & _
			"		INNER JOIN "& BBQHOME_DB &".DBO.T_CPN_PARTNER T2 WITH(NOLOCK)	" & _
			"			ON T2.CD_PARTNER = T1.CD_PARTNER AND T2.ADM_ID = '"& Admin_RID &"'	" & _
			"		WHERE T1.CPNTYPE = 'PR'		" & _
			"	) T1	" & _
			"	LEFT JOIN (	" & _
			"		SELECT	" & _
			"			CPNID,	" & _
			"			MIN(PUBDATE) AS REGDATE,	" & _
			"			MIN(USESDATE) AS USESDATE,	" & _
			"			MAX(USEEDATE) AS USEEDATE,	" & _
			"			SUM(CASE WHEN STATUS = 9 THEN 1 ELSE 0 END) AS USED_CNT,	" & _
			"			COUNT(*) AS TOT_CNT	" & _
			"		FROM "& BBQHOME_DB &".DBO.T_CPN_MST WITH(NOLOCK)	" & _
			"		WHERE CPNID IN (SELECT T1.CPNID 	" & _
			"			FROM "& BBQHOME_DB &".DBO.T_CPN T1 WITH(NOLOCK)	" & _
			"			INNER JOIN "& BBQHOME_DB &".DBO.T_CPN_PARTNER T2 WITH(NOLOCK)	" & _
			"				ON T2.CD_PARTNER = T1.CD_PARTNER AND T2.ADM_ID = '"& Admin_RID &"'	" & _
			"			WHERE T1.CPNTYPE = 'PR'	" & _
			"		) AND STATUS IN (1, 9)	" & _
			"		GROUP BY CPNID	" & _
			"	) T2	" & _
			"	ON T2.CPNID = T1.CPNID	" & _
			"	WHERE T1.ROW_NUM BETWEEN "& STARTNUM &" AND "& ENDNUM &"	" & _
			"	ORDER BY T1.ROW_NUM Asc	"
		Set Rlist = conn.Execute(Sql)
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
				USED_CNT	= Rlist("USED_CNT")
				TOT_CNT	= Rlist("TOT_CNT")
%>
							<tr>
								<td><span><%=num%></span></td>
								<td><span><%=CPNID%></span></td>
								<td><span><a href="coupon_partner_pin.asp?cpnid=<%=CPNID%>"><%=CPNNAME%></a></span></td>
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
					</div>
				</div>
			</div>
		</div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>