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
				<li>포인트</li>
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
					<h3>포인트</h3>
					
				</div>
				<div class="section-body">

					<!-- 포인트 요약 -->
					<div class="point-sum div-table">
						<div class="tr">
							<div class="td">
								<dl>
									<dt>사용가능 포인트</dt>
									<dd><%=FormatNumber(pPointBalance.mSavePoint,0)%>P</dd>
								</dl>
							</div>
							<div class="td">
								<dl>
									<dt>소멸예정 포인트 <span>(<%=FormatDateTime(DateAdd("d",30,Date),2)%>기준)</span></dt>
									<dd><%=FormatNumber(pPointBalance.mTotalExtinctionExpectedPoint,0)%>P</dd>
								</dl>
							</div>
						</div>
					</div>
					<!-- //포인트 요약 -->

					<div class="section-item mar-t40">
						<h4 class="fs20">포인트 적립내역</h4>
					</div>

					<table border="1" cellspacing="0" class="tbl-list">
						<caption>포인트 적립 리스트</caption>
						<colgroup>
							<col>
							<col style="width:140px;">
							<col style="width:130px;">
							<col style="width:130px;">
							<col style="width:130px;">
							<col style="width:130px;">
						</colgroup>
						<thead>
							<tr>
								<th>적립/사용 내용</th>
								<th>발생일자</th>
								<th>적립 포인트</th>
								<th>사용 포인트</th>
								<th>소멸예정일</th>
								<th>잔여포인트</th>
							</tr>
						</thead>
						<tbody>
<%
	startYmd = Replace(FormatDateTime(DateAdd("m", -1, Date), 2),"-","")
	endYmd = Replace(FormatDateTime(Date, 2),"-","")
	accountTypeCode = "SAVE"
	cardNo = ""

	Set resPointTrad = PointGetTradeList(startYmd, endYmd, accountTypeCode, cardNo, pageSize, curPage)

	If resPointTrad.mMessage = "SUCCESS" Then
		For i = 0 To UBound(resPointTrad.mTradeList)
%>
							<tr>
								<td class="ta-l">
									<span class="ico-branch red mar-r10">비비큐 치킨</span>
									<a href="javascript:;">[
<%
			If resPointTrad.mTradeList(i).mMerchantTypeName = "ONLINE" Then
				Response.Write "온라인"
			ElseIf resPointTrad.mTradeList(i).mMerchantTypeName = "OFFLINE" Then
				Response.Write "오프라인"
			End if
%>
									] <%=resPointTrad.mTradeList(i).mPointTradeTypeName%></a>
								</td>
								<td><%If resPointTrad.mTradeList(i).mTradeDate<>"" Then%><%=Mid(resPointTrad.mTradeList(i).mTradeDate,1,4)%>-<%=Mid(resPointTrad.mTradeList(i).mTradeDate,5,2)%>-<%=Mid(resPointTrad.mTradeList(i).mTradeDate,7,2)%><%End If%></td>
								<td><%If Replace(resPointTrad.mTradeList(i).mPointTradeTypeName," ","")="적립" Or Replace(resPointTrad.mTradeList(i).mPointTradeTypeName," ","")="적립사용취소" Or Replace(resPointTrad.mTradeList(i).mPointTradeTypeName," ","")="충전" Then%><strong class="black"><%=FormatNumber(resPointTrad.mTradeList(i).mTradePoint,0)%></strong><%End If%></td>
								<td><%If Replace(resPointTrad.mTradeList(i).mPointTradeTypeName," ","")="적립사용" Or Replace(resPointTrad.mTradeList(i).mPointTradeTypeName," ","")="적립취소" Or Replace(resPointTrad.mTradeList(i).mPointTradeTypeName," ","")="충전취소" Or Replace(resPointTrad.mTradeList(i).mPointTradeTypeName," ","")="충전사용" Then%><strong class="black"><%=FormatNumber(resPointTrad.mTradeList(i).mTradePoint,0)%></strong><%End If%></td>
								<td><%If resPointTrad.mTradeList(i).mValidEndDate <> "" Then%><%=Mid(resPointTrad.mTradeList(i).mValidEndDate,1,4)%>-<%=Mid(resPointTrad.mTradeList(i).mValidEndDate,5,2)%>-<%=Mid(resPointTrad.mTradeList(i).mValidEndDate,7,2)%><%End If%></td>
								<td><%=FormatNumber(resPointTrad.mTradeList(i).mSnapshotTotalRestPoint,0)%></td>
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
							TotalCount: "<%=resPointTrad.mTotalCount%>",
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
