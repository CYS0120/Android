<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>
</head>
<%
	cardno = GetReqStr("cardno","")

	If cardno = "" Then
%>
	<script type="text/javascript">
		showAlertMsg({msg:"잘못된 카드정보입니다.", ok: function(){
			history.back();
		}});
	</script>
<%
		Response.End
	End If


	pageSize = GetReqNum("pageSize",10)
	gotopage = GetReqNum("gotopage", 1)

	rtnUrl = GetReturnUrl
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
<%
	Set cInfo = CardDetail(cardno)

	restPoint = 0
	If cInfo.mCode = 0 Then
		restPoint = cInfo.mCardDetail.mRestPayPoint
	End If
%>		
			<!-- card List -->
			<section class="section section_inquiry">
				<div class="section-header">
					<h3>카드</h3>
				</div>
				<div class="section-body">
					<div class="card-view">
						<div class="box">
							<div class="img"><a href="javacsript:;"><img src="/images/mypage/@card<%=(Right(cardno,1) Mod 4)+1%>.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><span class="fs16">잔액 :</span> <strong><%=FormatNumber(restPoint,0)%></strong>원</p>
							</div>
						</div>
						<div class="right">
							<table border="1" cellspacing="0" class="tbl-list">
								<caption>카드 내역</caption>
								<colgroup>
									<col style="width:120px;">
									<col style="width:auto;">
									<col style="width:120px;">
									<col style="width:150px;">
								</colgroup>
								<thead>
									<tr>
										<th>날짜</th>
										<th>내역</th>
										<th>금액</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
<%
	sDt = DateAdd("m",-1, Date)
	eDt = Date

	sDt = Replace(FormatDateTime(sDt,2),"-","")
	' sDt = DatePart("yyyy",sDt)&Right("00"&DatePart("m",sDt),2)&Right("00"&DatePart("d",sDt),2)
	eDt = Replace(FormatDateTime(eDt,2),"-","")

	Set tList = PointGetTradeList(sDt, eDt, "PAY", cardno, pageSize, gotopage)

	If tList.mCode = 0 Then
		For i = 0 To UBound(tList.mTradeList)
			tradeDate = Mid(tList.mTradeList(i).mTradeDate,1,4)&"."&Mid(tList.mTradeList(i).mTradeDate,5,2)&"."&Mid(tList.mTradeList(i).mTradeDate,7,2)
			tradePoint = tList.mTradeList(i).mTradePoint
			Select Case Replace(tList.mTradeList(i).mPointTradeTypeName," ","")
				Case "충전": tradePoint = FormatNumber(tradePoint,0)
				Case "충전취소": tradePoint = FormatNumber(0-tradePoint,0)
				Case "충전사용": tradePoint = FormatNumber(0-tradePoint,0)
			End Select
			serviceTradeNo = ""
			If tList.mTradeList(i).mServiceTradeNo <> "" And Replace(tList.mTradeList(i).mPointTradeTypeName," ","") ="충전사용" Then
				serviceTradeNo = tList.mTradeList(i).mServiceTradeNo
			End If
%>
									<tr>
										<td><%=tradeDate%></td>
										<td class="ta-l">
											<p>
												<span class="ico-branch red mar-r10">비비큐 치킨</span>
											</p>
											<p class="fs20 mar-t5 black"><%=tList.mTradeList(i).mPointTradeTypeName%></p>
										</td>
										<td><span class="black"><%=tradePoint%>원</span></td>
										<td>
											<%If serviceTradeNo <> "" Then%>
											<a href="/mypage/orderView.asp?onum=<%=serviceTradeNo%>&rtnUrl=<%=Server.URLEncode(rtnUrl)%>" class="btn btn-sm btn-grayLine">주문상세보기</a>
											<%End If%>
										</td>
									</tr>
<%
		Next
	End If
%>
<!-- 									<tr>
										<td>2018.12.12</td>
										<td class="ta-l">
											<p>
												<span class="ico-branch red mar-r10">비비큐 치킨</span>
											</p>
											<p class="fs20 mar-t5 black">가산디지털단지점 주문사용</p>
										</td>
										<td><span class="black">-43,000원</span></td>
										<td><a href="#" class="btn btn-sm btn-grayLine">주문상세보기</a></td>
									</tr>
									<tr>
										<td>2018.12.12</td>
										<td class="ta-l">
											<p>
												<span class="ico-branch red mar-r10">비비큐 치킨</span>
											</p>
											<p class="fs20 mar-t5 black">가산디지털단지점 주문사용</p>
										</td>
										<td><span class="black">-43,000원</span></td>
										<td><a href="#" class="btn btn-sm btn-grayLine">주문상세보기</a></td>
									</tr>
									<tr>
										<td>2018.12.12</td>
										<td class="ta-l">
											<p>
												<span class="ico-branch red mar-r10">비비큐 치킨</span>
											</p>
											<p class="fs20 mar-t5 black">가산디지털단지점 주문사용</p>
										</td>
										<td><span class="black">-43,000원</span></td>
										<td><a href="#" class="btn btn-sm btn-grayLine">주문상세보기</a></td>
									</tr>
									<tr>
										<td>2018.12.12</td>
										<td class="ta-l">
											<p><img src="/images/mypage/ico_heart.png" alt=""></p>
											<p class="fs20 mar-t5 black">카드구매 - <span class="fs16">어디서나 쉽게 사용해보세요</span></p>
										</td>
										<td><span class="black">-43,000원</span></td>
										<td><a href="#" class="btn btn-sm btn-grayLine">주문상세보기</a></td>
									</tr> -->
								</tbody>
							</table>

						</div>
					</div>

					<div class="btn-wrap two-up inner mar-t60">
						<a href="/mypage/cardList.asp" class="btn btn-lg btn-black"><span>목록</span></a>
					</div>

				</div>
			</section>
			<!--// card List -->
			
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
