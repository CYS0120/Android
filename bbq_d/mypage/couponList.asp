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
				<li>bbq home</li>
				<li>마이페이지</li>
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
				<div class="section-body section_couponList">

					<table border="1" cellspacing="0" class="tbl-list">
						<caption>쿠폰리스트</caption>
						<colgroup>
							<col>
							<col style="width:180px;">
							<col style="width:250px;">
							<col style="width:130px;">
							<col style="width:120px;">
						</colgroup>
						<thead>
							<tr>
								<th>쿠폰명</th>
								<th>유효기간</th>
								<th>할인타입</th>
								<th>사용유무</th>
							</tr>
						</thead>
						<tbody>
<%
	Set cList = CouponGetHoldList("NONE", "N", pageSize, curPage)

	If cList.mMessage = "SUCCESS" Then
		For i = 0 To UBound(cList.mHoldList)
%>
							<tr>
								<td class="ta-l">
									<span class="ico-branch red mar-r10">비비큐 치킨</span>
									<a href="javascript:;"><%=cList.mHoldList(i).mCouponName%></a>
								</td>
								<!--td><%=cList.mHoldList(i).mValidStartDate%> ~ <%=cList.mHoldList(i).mValidEndDate%></td-->
								<td><%=left(cList.mHoldList(i).mValidStartDate,4)&"-"&mid(cList.mHoldList(i).mValidStartDate,5,2)&"-"&mid(cList.mHoldList(i).mValidStartDate,7,2) &" ~<br> " & left(cList.mHoldList(i).mValidEndDate,4)&"-"&mid(cList.mHoldList(i).mValidEndDate,5,2)&"-"&mid(cList.mHoldList(i).mValidEndDate,7,2)%></td>
								<td>
<%
			Select Case cList.mHoldList(i).mBenefitTypeCode
				Case "DISCOUNT": Response.Write "할인"
				Case "PRODUCT": Response.Write "증정"
				Case "ACCUMULATION": Response.Write "적립"
			End Select

			' If cList.mHoldList.get(i).mConditionProductYn = "Y" Then
			' 	Response.Write cList.mHoldList.get(i).mConditionProductCode
			' ElseIf cList.mHoldList.get(i).mConditionAmountYn = "Y" Then
			' 	Response.Write cList.mHoldList.get(i).mConditionAmount
			' End If
%>
								</td>
								<td><%If cList.mHoldList(i).mStatusCode = "USED" Then%>사용<%Else%>미사용<%End If%></td>
							</tr>
<%
		Next
	else %>
							
								<td colspan="4">
									<div class="event-list">
										<div class="nomore">
											<div class="img"><img src="/images/mypage/ico_nocoupon.png" alt=""></div>
											<div class="txt">쿠폰이 없습니다.</div>
										</div>
									</div>
								</td>
							

<%	
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

						$("#paging_list").html(html);
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
