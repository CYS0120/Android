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

	pageSize = GetReqNum("pageSize", 10)
	gotopage = GetReqNum("gotopage",1)

	rtnUrl = GetReturnUrl
%>

<body>

<div class="wrapper">

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content inbox1000">

			<%
				Set cInfo = CardDetail(cardno)

				restpoint = 0
				If cInfo.mCode = 0 Then
					restpoint = cInfo.mCardDetail.mRestPayPoint
				End If
			%>

			<!-- 사용가능카드 -->
			<section class="section section_cardView">
				<div class="img"><a href="javascript:;"><img src="/images/mypage/@card<%=(Right(cardno,1) Mod 4)+1%>.png" alt=""></a></div>
				<div class="txt"><%=FormatNumber(restpoint,0)%>원</div>
			</section>
			<!-- //사용가능카드 -->

			<section class="section section_cardUse">
				<div class="section-header">
					<h3>이용내역</h3>
				</div>
				<div class="section-body">
					<!-- Order List -->
					<div class="area">
<!-- 
						<div class="box">
							<div class="top">
								<div class="lef"><span class="ico-branch red">비비큐치킨</span></div>
								<div class="rig">-15000원</div>
							</div>
							<h4 class="prod">신대방점 주문사용</h4>
							<div class="date">2018.11.07</div>
						</div>
 -->
						<%
							sDt = DateAdd("m", -1, Date)
							eDt = Date

							sDt = Replace(FormatDateTime(sDt,2),"-","")
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
<!-- 
							<div class="box">
								<div class="top">
									<div class="lef"><span class="ico-branch red">비비큐치킨</span></div>
									<div class="rig">-<%=tradePoint%>원</div>
								</div>
								<h4 class="prod">신대방점 주문사용</h4>
								<div class="date">2018.11.07</div>
							</div>
 -->
							<!--
								<div class="rig">
									<%If serviceTradeNo <> "" Then%>
									<a href="/mypage/orderView.asp?onum=<%=serviceTradeNo%>&rtnUrl=<%=Server.URLEncode(rtnUrl)%>" class="btn btn-sm btn-grayLine2">상세보기</a>
									<%End If%>
								</div>
							-->

						<%
								Next
							End If
						%>

					</div>
					<!--// Order List -->

				</div>

				<div class="btn-wrap one">
					<a href="/mypage/cardList.asp" class="btn btn_middle btn-gray">목록</a>
				</div>
			
			</section>


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
