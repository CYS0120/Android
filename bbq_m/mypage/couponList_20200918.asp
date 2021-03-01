<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<meta name="Keywords" content="쿠폰, BBQ치킨">
<meta name="Description" content="쿠폰">
<title>쿠폰 | BBQ치킨</title>

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "쿠폰"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content inbox1000">

			<%
				Set couponHoldList = CouponGetHoldList("NONE", "N", 100, 1)
			%>

			<!-- 사용가능쿠폰 -->
			<section class="section section_couponUseOk">

				<div class="coupon_head">사용 가능한 쿠폰 <strong><%=couponHoldList.mTotalCount%></strong>장</div>

				<div class="couponUseOk_wrap">
					<%
						IF couponHoldList.mTotalCount > 0 Then
							For i = 0 To UBound(couponHoldList.mHoldList)
					%>
					<div class="couponUseOk">
						<div class="coupon">
							<ul class="tit">
								<li class="device"><span class="ico-branch red">비비큐치킨</span></li>
								<li class="day"><span>D - <%=DateDiff("d", Date, left(couponHoldList.mHoldList(i).mValidEndDate,4)&"-"&mid(couponHoldList.mHoldList(i).mValidEndDate,5,2)&"-"&mid(couponHoldList.mHoldList(i).mValidEndDate,7,2))%></span></li>
							</ul>
							<dl class="info">
								<dt><%=couponHoldList.mHoldList(i).mCouponName%></dt>
								<dd>
									유효기간 : <%=left(couponHoldList.mHoldList(i).mValidStartDate,4)&"-"&mid(couponHoldList.mHoldList(i).mValidStartDate,5,2)&"-"&mid(couponHoldList.mHoldList(i).mValidStartDate,7,2)%> ~ <%=left(couponHoldList.mHoldList(i).mValidEndDate,4)&"-"&mid(couponHoldList.mHoldList(i).mValidEndDate,5,2)&"-"&mid(couponHoldList.mHoldList(i).mValidEndDate,7,2)%><br/>
									<!-- 사용처 : PC · 모바일 · App -->
								</dd>
							</dl>
							<!-- <ul class="txt">
								<li>모든메뉴 주문시 사용 가능 (단, 주류/음료/배달비 제외)</li>
								<li>타 쿠폰과 중복 사용불가</li>
							</ul> -->
							<ul class="txt">
								<li>황올 포함 18000원 이상 구매 시 7천원 할인 및 치즈볼(랜덤) 2알 증정 이벤트 입니다.</li>
								<li>타 쿠폰과 중복 사용 불가합니다.</li>
								<li>포인트 적립은 불가합니다.</li>
								<li>특화매장 및 일부 매장은 사용이 불가할 수 있습니다.</li>
								<li>배달료 및 포장비등의 추가비용이 발생할 수 있으며, 매장 및 거리에 따라 비용이 상이할 수 있습니다.</li>
							</ul>

						</div>
					</div>

					<%
							Next
						else %>

					<!-- 등록된 쿠폰 없을때 -->
					<div class="coupon_empty">
						<p>등록된 e쿠폰이<br>없습니다.</p>
					</div>
					<!-- // 등록된 쿠폰 없을때 -->
					
					<%
						End If
					%>


					<!--
					<div class="box">
						<div class="coupon">
							<div class="tit div-table">
								<ul class="tr">
									<li class="td device"><span class="ico-branch red">비비큐치킨</span></li>
									<li class="td day">D-15</li>
								</ul>
							</div>
							<dl class="info">
								<dt>[스테디셀러] 황금올리브 1+1 쿠폰</dt>
								<dd>
									유효기간 : 2018-12-01 ~ 2018-12-31<br/>
									사용처 : PC · 모바일 · App
								</dd>
							</dl>
						</div>
						<div class="txt">
							- 황금올리브 치킨 주문시 사용 가능<br/>
							- 타 쿠폰과 중복 사용불가
						</div>
					</div>

					<div class="box">
						<div class="coupon">
							<div class="tit div-table">
								<ul class="tr">
									<li class="td device"><span class="ico-branch yellow">비비큐몰</span></li>
									<li class="td day">D-15</li>
								</ul>
							</div>
							<dl class="info">
								<dt>[스테디셀러] 황금올리브 1+1 쿠폰</dt>
								<dd>
									유효기간 : 2018-12-01 ~ 2018-12-31<br/>
									사용처 : PC · 모바일 · App
								</dd>
							</dl>
						</div>
						<div class="txt">
							- 황금올리브 치킨 주문시 사용 가능<br/>
							- 타 쿠폰과 중복 사용불가
						</div>
					</div> 
					-->

				</div>
			</section>
			<!-- //사용가능쿠폰 -->
			
		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
