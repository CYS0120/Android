<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>카드</h1>
		<div class="btn-header btn-header-nav">
			<button type="button" onClick="javascript:history.back();" class="btn btn_header_back"><span class="ico-only">이전페이지</span></button>
			<button type="button" class="btn btn_header_menu"><span class="ico-only">메뉴</span></button>
		</div>
		<div class="btn-header btn-header-mnu">
			<button type="button" class="btn btn_header_cart"><span class="ico-only">장바구니</span></button>
			<button type="button" class="btn btn_header_brand"><span class="ico-only">패밀리브랜드</span></button>
		</div>
	</header>
	<!--// Header -->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
			
		<!-- Content -->
		<article class="content">

			<section class="section section_cardList2 mar-t60">
				<div class="section-header">
					<div class="btn-wrap">
						<button type="button" class="btn btn-md btn-red w-100p"><span>충전하기</span></button>
						<p class="explain"></p>
					</div>
				</div>
				<div class="section-body">
					<!-- Order List -->
					<div class="area">
						<div class="box">
							<h4 class="prod">[선물] 0000-0000-1346-1345</h4>
							<table border="1" cellspacing="0" >
								<caption>카드 내역</caption>
								<colgroup>
									<col style="width:40%;">
									<col style="width:auto;">									
								</colgroup>
								
								<tbody>
									<tr>
										<th>거래일시</th>
										<td>2019-01-29</td>
									</tr>
									<tr>
										<th>사용가맹점</th>
										<td>여섯글자매장점</td>
									</tr>
									<tr>
										<th>거래금액</th>
										<td>50,000</td>
									</tr>
									<tr>
										<th>거래후금액</th>
										<td>30,000</td>
									</tr>									
								</tbody>
							</table>
						</div>
						<div class="box">
							<h4 class="prod">[구매] 0000-0000-1346-1345</h4>
							<table border="1" cellspacing="0" >
								<caption>카드 내역</caption>
								<colgroup>
									<col style="width:40%;">
									<col style="width:auto;">									
								</colgroup>
								
								<tbody>
									<tr>
										<th>거래일시</th>
										<td>2019-01-29</td>
									</tr>
									<tr>
										<th>사용가맹점</th>
										<td>여섯글자매장점</td>
									</tr>
									<tr>
										<th>거래금액</th>
										<td>50,000</td>
									</tr>
									<tr>
										<th>거래후금액</th>
										<td>30,000</td>
									</tr>									
								</tbody>
							</table>
						</div>

						<!-- Button More -->
						<div class="btn-wrap mar-t20">
							<button type="button" class="btn btn-md btn-grayLine w-100p btn_list_more"><span>더보기</span></button>
							<p class="explain">-정상적인 사용 내역은 pc에서 확인해주세요</p>
						</div>
						<!--// Button More -->
						
					</div>
					<!--// Order List -->
					
				</div>
			</section>

		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
	</div>
	<!--// Container -->
	<hr>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>