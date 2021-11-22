<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="마이페이지, BBQ치킨">
<meta name="Description" content="마이페이지">
<title>마이페이지 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});
});
</script>
</head>
<%
	brand_code = "01"
%>
<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li>bbq home</li>
				<li>마이페이지</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1>마이페이지</h1>
			<!-- Membership -->
			<section class="section section_membership">
				<!-- My Info -->
				<!--#include virtual="/includes/mypage.inc.asp"-->
				<!--// My Info -->
				<!-- My Menu -->
				<!--#include virtual="/includes/mypagemenu.inc.asp"-->
				<!--// My Menu -->
			</section>
			<!--// Membership -->
		
			<!-- 주문내역 -->
			<section class="section">
				<div class="section-header">
					<h3>주문내역</h3>
					<a href="./orderList.asp" class="btn_more btn btn-sm btn-grayLine">더보기</a>
				</div>
				<div class="section-body">
<%
	totalCount = 0
	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_order_list_member"

		.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput,,3)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

		Set aRs = .Execute

		totalCount = .Parameters("@totalCount").Value
	End With
	Set aCmd = Nothing
%>					
					<table border="1" cellspacing="0" class="tbl-order">
						<caption>장바구니</caption>
						<colgroup>
							<col style="width:170px;">
							<col style="width:90px;">
							<col>
							<col style="width:140px;">
							<col style="width:140px;">
							<col style="width:140px;">
							<col style="width:140px;">
						</colgroup>
						<thead>
							<tr>
								<th>주문일/주문번호</th>
								<th colspan="2">상품정보</th>
								<th>결제금액</th>
								<th>배달정보</th>
								<th>주문매장</th>
								<th>주문상태</th>
							</tr>
						</thead>
						<tbody>
<%

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst

		Do Until aRs.EOF
%>
							<tr>
								<td>
									<%=aRs("order_date")%><br/>
									<p class="orderNum"><%=aRs("order_num")%></p>
									<a href="/mypage/orderView.asp?oidx=<%=aRs("order_idx")%>" class="btn btn-sm btn-grayLine">주문상세보기</a>
								</td>
								<td class="img">
									<a href="/mypage/orderView.asp?oidx=<%=aRs("order_idx")%>">
										<%If aRs("thumb_file_path") = "" Then%>
										<img src="http://placehold.it/80x80">
										<%Else%>
										<img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")%><%=aRs("thumb_file_name")%>" width="80px" height="80px">
										<%End If%>
									</a>
								</td>
								<td class="info ta-l">
									<p class="icon">
										<span class="ico-branch red"><%=aRs("brand_name")%></span>
									</p>
									<p class="menuName"><%=aRs("menu_name")%><%If aRs("menu_count") > 1 Then%><span>외 <%=aRs("menu_count")-1%>개</span><%End If%></p>
								</td>
								<td><%=FormatNumber(aRs("order_amt"),0)%>원</td>
								<td><%=aRs("order_type_name")%></td>
								<td><%=aRs("branch_name")%><br/><%=aRs("branch_tel")%></td>
							<%If aRs("order_step") = "" Then %>
								<td></td>
							<%ElseIf aRs("order_step") = "05" Then %>
								<td><%=aRs("order_status_name")%></td>
							<%ElseIf aRs("order_step") = "01" Or aRs("order_step") = "02" Then %>
								<td class="delivery_step<%=aRs("order_step")%>"></td>
							<%Else%>
								<%If aRs("order_type") = "D" Then%>
									<td class="delivery_step<%=aRs("order_step")%>"></td>
								<%ElseIf aRs("order_type") = "P" Then%>
									<td class="takeOut_step<%=aRs("order_step")%>"></td>
								<%End If%>
							<%End If%>
							</tr>
<%
			aRs.MoveNext
		Loop
	Else
%>
							<tr>
								<td colspan="7" class="orderX">주문내역이 없습니다.</td>
							</tr>
<%
	End If
%>
						</tbody>
					</table>

				</div>
			</section>
			<!--// 주문내역 -->
<%
	totalCount = 0
%>		
			<!-- 문의내역 -->
			<section class="section mar-t100">
				<div class="section-header">
					<h3>문의내역</h3>
					<%If totalCount > 0 Then%><a href="./inquiryList.asp" class="btn_more btn btn-sm btn-grayLine">더보기</a><%End If%>
				</div>
				<div class="section-body">
					<table border="1" cellspacing="0" class="tbl-list">
						<caption>상품문의</caption>
						<colgroup>
							<col style="width:106px;">
							<col style="width:auto;">
							<col style="width:180px;">
							<col style="width:150px;">
						</colgroup>
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>작성일</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
<%
	Set cmd = Server.CreateObject("ADODB.Command")
	totalCount = 0

	With cmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_member_q_select"

        .Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "LIST")
        ' .Parameters.Append .CreateParameter("@q_idx", adParamInput, adParamInput, , q_idx)
        .Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, brand_code)
        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo") )
        .Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
        .Parameters.Append .CreateParameter("@curPage", adInteger, adParamInput, , gotopage)
        .Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

        Set rs = .Execute

        totalCount = .Parameters("@totalCount").Value
    End With
    Set cmd = Nothing

    If Not (rs.BOF Or rs.EOF) Then
    	Do Until rs.EOF
%>

							<tr>
								<td><%=rs("RN")%></td>
								<td class="ta-l">
									<span class="ico-branch red mar-r10">비비큐 치킨</span>
									<a href="./inquiryView.asp?qidx=<%=rs("q_idx")%>"><%=rs("title")%></a>
								</td>
								<td><%=FormatDateTime(rs("regdate"),2)%></td>
								<td><span><%=rs("q_status")%></span></td>
							</tr>
<%
			rs.MoveNext
		Loop
	Else
%>
							<tr>
								<td colspan="4" class="noData">문의내역이 없습니다.</td>
							</tr>
<%
	End If
%>	
<!-- 							<tr>
								<td>1</td>
								<td class="ta-l">
									<span class="ico-branch orange mar-r10">올떡</span>
									<a href="./inquiryView.asp">제너시스 BBQ 통합회원 개인정보 처리방침 개정안내</a>
								</td>
								<td>2018-12-20</td>
								<td><span class="red">답변완료</span></td>
							</tr>
							<tr>
								<td>1</td>
								<td class="ta-l">
									<span class="ico-branch yellow mar-r10">비비큐몰</span>
									<a href="./inquiryView.asp">제너시스 BBQ 통합회원 개인정보 처리방침 개정안내</a>
								</td>
								<td>2018-12-20</td>
								<td><span class="red">답변완료</span></td>
							</tr> -->
						</tbody>
					</table>
				</div>
			</section>
			<!--// 문의내역 -->
			
		</article>
		<!--// Content -->	
		
		<!-- QuickMenu -->
		<!--#include virtual="/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
