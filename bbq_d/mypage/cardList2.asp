<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
});
</script>
</head>
<%
	gotopage = GetReqNum("gotopage",1)
	pagesize = GetReqNum("pageSize",10)
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
				<li>카드</li>
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
		
			<!-- card List -->
			<section class="section section_inquiry">
				<div class="section-header">
					<h3>카드</h3>					
					<div class="right">
						
							<!-- <a href="#" class="btn btn-sm2 btn-red w-120">충전하기</a> -->
					</div>
				</div>
				<div class="section-body">
					<div class="card-view">
						
						
							<table border="1" cellspacing="0" class="tbl-list">
								<caption>카드 내역</caption>
								<colgroup>
									<col style="width:5%;">
									<!-- <col style="width:5%;"> -->
									<col style="width:auto;">
									<col style="width:10%;">
									<col style="width:7%;">
									<col style="width:7%;">
									<col style="width:10%;">
									<col style="width:10%;">
									<col style="width:7%;">
									<col style="width:7%;">
									<col style="width:7%;">
									<!-- <col style="width:2%;"> -->
								</colgroup>
								<thead>
									<tr>
										<th>번호</th>
										<!-- <th>구매형태</th> -->
										<th>카드번호</th>
										<th>거래일시</th>
										<th>충전</th>
										<!-- <th>출금</th> -->
										<th>사용주문번호</th>
										<!-- <th>사용가맹점</th> -->
										<th>거래전금액</th>
										<th>거래금액</th>
										<th>거래후금액</th>
										<!-- <th>메세지</th> -->
									</tr>
								</thead>
								<tbody>
<%
	sDt = DateAdd("m",-1,Date)
	eDt = Date

	sDt = DatePart("yyyy", sDt)&Right("00"&DatePart("m",sDt),2)&"01"
	eDt = Replace(FormatDateTime(eDt,2),"-","")

	Set tList = PointGetTradeList(sDt, eDt, "PAY", "", pageSize, gotopage)

	totalCount = 0

	If tList.mCode = 0 Then
		totalCount = tList.mTotalCount

		'Response.Write "totalCount : " & totalCount & ", mlist : " & Ubound(tList.mTradeList) & ", period : " & sDt & " ~ " & eDt

		For i = 0 To UBound(tList.mTradeList)
			idx = totalCount - (pageSize * (gotopage-1) ) - i
			cardNo = tList.mTradeList(i).mCardNo
			tradeDate = Mid(tList.mTradeList(i).mTradeDate,1,4)&"."&Mid(tList.mTradeList(i).mTradeDate,5,2)&"."&Mid(tList.mTradeList(i).mTradeDate,7,2)
			incomeAmt = "-"
			beforeAmt = "-"
			tradeAmt = "-"
			afterAmt = "-"
			serviceTradeNo = "-"

			tradePoint = tList.mTradeList(i).mTradePoint
			snapshotPoint = tList.mTradeList(i).mSnapshotTotalRestPoint
			If tList.mTradeList(i).mServiceTradeNo <> "" Then
				serviceTradeNo = tList.mTradeList(i).mServiceTradeNo
			End If

			Select Case Replace(tList.mTradeList(i).mPointTradeTypeName," ","")
				Case "충전":
				incomeAmt = FormatNumber(tradePoint,0)
				beforeAmt = FormatNumber(snapshotPoint - tradePoint,0)
				afterAmt = FormatNumber(snapshotPoint,0)
				Case "충전취소":
				incomeAmt = "-"&FormatNumber(tradePoint,0)
				beforeAmt = FormatNumber(snapshotPoint - tradePoint,0)
				afterAmt = FormatNumber(snapshotPoint,0)
				Case "충전사용":
				beforeAmt = FormatNumber(tradePoint + snapshotPoint, 0)
				tradeAmt = "-"&FormatNumber(tradePoint, 0)
				afterAmt = FormatNumber(snapshotPoint, 0)
			End Select

%>
									<tr>
										<td><%=idx%></td>
										<!-- <td>선불</td> -->
										<td><%=cardNo%></td>
										<td><%=tradeDate%></td>
										<td><%=incomeAmt%></td>
										<!-- <td>12,000</td> -->
										<td><%=serviceTradeNo%></td>
										<!-- <td>구로점</td> -->
										<td><%=beforeAmt%></td>
										<td><%=tradeAmt%></td>
										<td><%=afterAmt%></td>
										<!-- <td><a href="javascript:void(0);" onclick="javascript:lpOpen('.lp_cardGiftPop2');" class="btn btn-sm btn-grayLine">보기</a></td> -->
									</tr>
<%
		Next
	End If
%>									
<!-- 									<tr>
										<td>222</td>
										<td>선불</td>
										<td>0000-0000-1234-1234</td>
										<td>2018.12.12</td>
										<td>30,000</td>
										<td>12,000</td>
										<td>W10000010797432</td>
										<td>구로점</td>
										<td>43,000</td>
										<td>15,000</td>
										<td>28,000</td>
										<td><a href="javascript:void(0);" onclick="javascript:lpOpen('.lp_cardGiftPop2');" class="btn btn-sm btn-grayLine">보기</a></td>
									</tr>
 -->									
								</tbody>
							</table>

						
					</div>

					<div class="board-pager-wrap">
						<div class="board-pager" id="paging_list">
<!-- 							<a href="#" class="board-nav btn_first">처음</a>
							<a href="#" class="board-nav btn_prev">이전</a>
							<ul class="board-page">
								<li class="on"><a href="#" onclick="javascript:return false;">1</a></li>
								<li><a href="#" onclick="javascript:return false;">2</a></li>
								<li><a href="#" onclick="javascript:return false;">3</a></li>
								<li><a href="#" onclick="javascript:return false;">4</a></li>
								<li><a href="#" onclick="javascript:return false;">5</a></li>
								<li><a href="#" onclick="javascript:return false;">6</a></li>
								<li><a href="#" onclick="javascript:return false;">7</a></li>
								<li><a href="#" onclick="javascript:return false;">8</a></li>
							</ul>
							<a href="#" class="board-nav btn_next">다음</a>
							<a href="#" class="board-nav btn_last">마지막</a> -->
						</div>
					</div>
<script type="text/javascript">
	var html = makePaging({
		PageSize: "<%=pageSize%>",
		gotoPage: "<%=gotopage%>".
		TotalCount: "<%=totalCount%>",
		params: ""
	});

	$("#paging_list").html(html);
</script>
				</div>
			</section>
			<!--// card List -->

			<!-- Layer Popup : 카드 선물메세지 -->
			<div id="lp_cardGiftPop2" class="lp-wrapper lp_cardGiftPop2">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>선물 메세지</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">
								<section class="section">
									<form action="">
										<table border="1" cellspacing="0" class="tbl-member black-line">
											<caption>정보입력</caption>
											<colgroup>
												<col style="width:170px;">
												<col style="width:auto;">
											</colgroup>
											<tbody>
												<tr>
													<th>이름</th>
													<td>
														<input type="text" class="w-150">
													</td>
												</tr>
												<tr>
													<th>휴대전화번호</th>
													<td>
														<div class="ui-group-email">
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text"></span>
														</div>
													</td>
												</tr>
												<tr>
													<th>선물메세지</th>
													<td>
														<textarea name="" id="" class="w-100p h-150"></textarea>
													</td>
												</tr>
											</tbody>
										</table>

										
									</form>
								</section>
							</div>
							<!--// LP Content -->
						</div>
						<!--// LP Container -->
						<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
					</div>
				</div>
				<!--// LP Wrap -->
			</div>
			<!--// Layer Popup -->
			
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
