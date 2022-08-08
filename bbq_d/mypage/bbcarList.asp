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
				<li>나의 작성글</li>
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
					<div class="tab-wrap tab-type3 mar-b0 leng2">
						<ul class="tab">
							<li><a href="./inquiryList.asp"><span>고객의 소리</span></a></li>
							<li class="on"><a href="javascript:;"><span>비비카 신청</span></a></li>
						</ul>
					</div>
				</div>
				<div class="section-body">
					<div class="boardList-wrap">

						<table border="1" cellspacing="0" class="tbl-list">
							<caption>비비카 신청 목록</caption>
							<colgroup>
								<col style="width:100px;">
								<col style="width:180px;">
								<col style="width:180px;">
								<col style="width:auto;">
								<col style="width:180px;">
							</colgroup>
							<thead>
								<tr>
									<th>번호</th>
									<th>신청월</th>
									<th>지역</th>
									<th>제목</th>
									<th>작성일</th>
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
								.CommandText = "bp_member_bbcar_select"

								.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "LIST")
								' .Parameters.Append .CreateParameter("@idx", adParamInput, adParamInput, , idx)
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
										<td><%=rs("row_num")%></td>
										<td><%=rs("visit_ym")%></td>
										<td><%=rs("visit_city")%></td>
										<td>
											<a href="/brand/bbcarView.asp?idx=<%=rs("idx")%>"><%=rs("title")%></a>
										</td>
										<td><%=FormatDateTime(rs("regdate"),2)%></td>
									</tr>
<%
									rs.MoveNext
								Loop
							Else
%>
								<tr>
									<td colspan="5" class="noData">등록된 내역이 없습니다.</td>
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
						<div class="btn-area"><a href="/brand/bbcarWrite.asp" class="btn btn-red">비비카 신청하기</a></div>
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
