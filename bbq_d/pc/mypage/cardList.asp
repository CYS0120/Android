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
	' testArr = Null
	' Response.Write "Ubound for null " & UBound(testArr)

	Set pCardList = CardOwnerList("USE")

	' Response.Write pCardList.toJson()
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
				<li><a href="#" onclick="javascript:return false;">마이페이지</a></li>
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
						<div class="txt-basic16">
							사용 가능한 카드 <span class="orange fs20"><%=UBound(pCardList.mCardDetail)+1%></span>장
						</div>
					</div>
				</div>
				<div class="section-body">
					<div class="card-list">
					<%
					For i = 0 To UBound(pCardList.mCardDetail)
					%>
						<div class="box">
							<div class="img"><a href="./cardView.asp?cardno=<%=pCardList.mCardDetail(i).mCardNo%>"><img src="/images/mypage/@card<%= (Right(pCardList.mCardDetail(i).mCardNo,1) MOD 4)+1%>.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><strong><%=FormatNumber(pCardList.mCardDetail(i).mRestPayPoint,0)%></strong>원</p>
							</div>
						</div>
					<%
					Next
					%>
<!-- 
						<div class="box">
							<div class="img"><a href="./cardView.asp"><img src="/images/mypage/@card2.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><strong>100,000</strong>원</p>
							</div>
						</div>
						<div class="box">
							<div class="img"><a href="./cardView.asp"><img src="/images/mypage/@card2.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><strong>100,000</strong>원</p>
							</div>
						</div>
						<div class="box">
							<div class="img"><a href="./cardView.asp"><img src="/images/mypage/@card3.png" alt=""></a></div>
							<div class="info">
								<p class="txt"><strong>사용완료</strong></p>
							</div>
						</div>
						 -->
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
