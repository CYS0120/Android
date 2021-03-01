<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="나의 상담내역, BBQ치킨">
<meta name="Description" content="나의 상담내역">
<title>나의 상담내역 | BBQ치킨</title>
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
	gotoPage = GetReqNum("gotopage", 1)
	pageSize = GetReqNum("pageSize", 10)
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
				<li>문의내역</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
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
		
			<!-- My Inquiry List -->
			<section class="section section_inquiry">
				<div class="section-header">
					<h3>문의내역</h3>
					<div class="right">
						<!-- <select name="" id="" class="w-250">
							<option value="">전체브랜드 보기</option>
							<option value="">비비큐치킨</option>
							<option value="">비비큐몰</option>
							<option value="">행복한집밥</option>
							<option value="">닭익는마을</option>
							<option value="">참숯바베큐</option>
							<option value="">우쿠야</option>
							<option value="">올떡</option>
							<option value="">소신</option>
							<option value="">와타미</option>
						</select> -->
					</div>
				</div>
				<div class="section-body">
					<div class="boardList-wrap">

						<table border="1" cellspacing="0" class="tbl-list">
							<caption>문의내역 리스트</caption>
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
									<th>조회</th>
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
										<span class="ico-branch red mar-r10">비비큐치킨</span>
										<a href="./inquiryView.asp?qidx=<%=rs("q_idx")%>"><%=rs("title")%></a>
									</td>
									<td><%=FormatDateTime(rs("regdate"),2)%></td>
									<td><%If rs("q_status") = "답변완료" Then%><span class="red">답변완료</span><%Else%><span>답변전</span><%End If%></td>
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
							</tbody>
						</table>

					</div>
					<div class="board-pager-wrap">
						<div class="board-pager" id="paging_list">
						</div>
						<script type="text/javascript">
							var html = makePaging({
								PageSize: "<%=pageSize%>",
								gotoPage: "<%=gotopage%>",
								TotalCount: "<%=totalCount%>",
								params: ""
							});
						</script>
						<div class="btn-area"><a href="/customer/inquiryWrite.asp" class="btn btn-red">문의하기</a></div>
					</div>
				</div>
			</section>
			<!--// My Inquiry List -->
			
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
