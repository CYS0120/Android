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
	
});
</script>
</head>
<%
	curPage = GetReqNum("gotoPage", 1)
	pageSize = 10
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
				<li><a href="/">bbq home</a></li>
				<li><a href="#">마이페이지</a></li>
				<li>쿠폰</li>
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
		
			<!-- 문의내역 -->
			<section class="section">
				<div class="section-header">
					<h3>쿠폰</h3>
					<div class="right">
						<div class="txt-basic16">
							사용 가능한 쿠폰 <span class="orange fs20"><%=pCouponList.mTotalCount%></span>장
						</div>
					</div>
				</div>
				<div class="section-body">

					<table border="1" cellspacing="0" class="tbl-list">
						<caption>쿠폰리스트</caption>
						<colgroup>
							<col>
							<col style="width:180px;">
							<col style="width:130px;">
							<col style="width:250px;">
							<col style="width:120px;">
						</colgroup>
						<thead>
							<tr>
								<th>쿠폰명</th>
								<th>사용조건</th>
								<th>사용처</th>
								<th>유효기간</th>
								<th>남은일자</th>
							</tr>
						</thead>
						<tbody>
<%
	Set cList = CouponGetHoldList("NONE", "Y", pageSize, curPage)

	If cList.mMessage = "SUCCESS" Then
		For i = 0 To UBound(cList.mHoldList)
%>
							<tr>
								<td class="ta-l">
									<span class="ico-branch red mar-r10">비비큐 치킨</span>
									<a href="javascript:;"><%=cList.mHoldList.get(i).mCouponName%></a>
								</td>
								<td>
<%
			If cList.mHoldList.get(i).mConditionProductYn = "Y" Then
				Response.Write cList.mHoldList.get(i).mConditionProductCode
			ElseIf cList.mHoldList.get(i).mConditionAmountYn = "Y" Then
				Response.Write cList.mHoldList.get(i).mConditionAmount
			End If
%>
			</td>
								<td>PC/모바일</td>
								<td><%=cList.mHoldList.get(i).mValidStartDate%> ~ <%=cList.mHoldList.get(i).mValidEndDate%></td>
								<td><strong class="black">D -<%=DateDiff("d", Date(cList.mHoldList.get(i).mValidEndDate), Date)%></strong></td>
							</tr>
<%
		Next
	End If
%>
						</tbody>
					</table>

					<div class="board-pager-wrap">
						<div class="board-pager" id="paging_list">
						</div>
					</div>

					<script type="text/javascript">
						var html = makePaging({
							PageSize: "<%=pageSize%>",
							gotoPage: "<%=curPage%>",
							TotalCount: "<%=cList.mTotalCount%>",
							params: ""
						});
					</script>

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
