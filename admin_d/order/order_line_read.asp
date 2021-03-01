<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "B"
	CUR_PAGE_SUBCODE = ""
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	OID		= InjRequest("OID")
	If FncIsBlank(OID) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If

	OGB		= InjRequest("OGB")
	SDATE	= InjRequest("SDATE")
	EDATE	= InjRequest("EDATE")
	SM		= InjRequest("SM")
	SW		= InjRequest("SW")
	LNUM	= InjRequest("LNUM")
	If FncIsBlank(OGB) Then OGB = "T"
	If FncIsBlank(SDATE) Then SDATE = Date 
	If FncIsBlank(EDATE) Then EDATE = Date
	If FncIsBlank(LNUM) Then LNUM = 10

	DetailN = "OGB="& OGB & "&SDATE="& SDATE & "&EDATE="& EDATE & "&SM="& SM & "&SW="& SW
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
				<span><p>관리자</p> > <p>주문관리</p> > <p>유선주문취소리스트</p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->
<!-- #include file="order_read.asp" -->

<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>