<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="주문완료, BBQ치킨">
<meta name="Description" content="주문완료 메인">
<title>주문완료 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
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

<body>
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		
		<!-- Content -->
		<article class="content">
	
			<!-- 주문단계 -->
			<section class="section section-orderStep">
				<ul>
					<li class="step1"><span>01 장바구니</span></li>
					<li class="step2"><span>02 주문/결제</span></li>
					<li class="step3 on"><span>03 주문완료</span></li>
				</ul>
			</section>
			<!-- //주문단계 -->

			<h1 class="line">주문완료</h1>

			<!-- 주문완료 텍스트 -->
			<div class="order_CompleteTxt">
				<h3><span class="red">주문이 정상적으로 완료</span>되었습니다.</h3>
				<p>박라라님께서 주문하신 내역입니다.</p>
			</div>
			<!-- //주문완료 텍스트 -->

			<!-- 주문요약정보 -->
			<section class="section section_orderNumDate">
				<dl>
					<dt>주문번호 : </dt>
					<dd>W100000010794231</dd>
				</dl>
				<dl>
					<dt>주문일시 : </dt>
					<dd>2018.12.20 17:25:21</dd>
				</dl>
			</section>
			<!-- //주문요약정보 -->

			<!-- 장바구니 테이블 -->
			<div class="section-item">
				<h4>주문메뉴</h4>
				<table border="1" cellspacing="0" class="tbl-cart">
					<caption>장바구니</caption>
					<colgroup>
						<col style="width:141px;">
						<col>
						<col style="width:150px;">
						<col style="width:150px;">
						<col style="width:150px;">
					</colgroup>
					<thead>
						<tr>
							<th colspan="2">상품정보</th>
							<th>상품금액</th>
							<th>배달정보</th>
							<th>합계</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="img">
								<a href="#"><img src="http://placehold.it/120x120"/></a>
							</td>
							<td class="info ta-l">
								<div class="pdt-info div-table">
									<dl class="tr">
										<dt class="td">황금 올리브 치킨</dt>
										<dd class="td pm">1개</dd>
										<dd class="td sum">18,000원</dd>
									</dl>
									<dl class="tr">
										<dt class="td">황금 올리브 치킨</dt>
										<dd class="td pm">1개</dd>
										<dd class="td sum">1,000원</dd>
									</dl>
								</div>
							</td>
							<td class="pay">25,000원</td>
							<td class="move" rowspan="2">픽업주문</td>
							<td class="pay" rowspan="2">49,000원</td>
						</tr>
						<tr>
							<td class="img">
								<a href="#"><img src="http://placehold.it/120x120"/></a>
							</td>
							<td class="info ta-l">
								<div class="pdt-info div-table">
									<dl class="tr">
										<dt class="td">황금 올리브 치킨</dt>
										<dd class="td pm">1개</dd>
										<dd class="td sum">18,000원</dd>
									</dl>
									<dl class="tr">
										<dt class="td">황금 올리브 치킨</dt>
										<dd class="td pm">1개</dd>
										<dd class="td sum">1,000원</dd>
									</dl>
									<dl class="tr">
										<dt class="td">황금 올리브 치킨</dt>
										<dd class="td pm">1개</dd>
										<dd class="td sum">1,000원</dd>
									</dl>
									<dl class="tr">
										<dt class="td">황금 올리브 치킨</dt>
										<dd class="td pm">1개</dd>
										<dd class="td sum">1,000원</dd>
									</dl>
								</div>
							</td>
							<td class="pay">25,000원</td>
							
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //장바구니 테이블 -->

			<!-- 장바구니 하단 정보 -->
			<div class="cart-botInfo div-table">
				<div class="tr">
					
					<div class="td rig">
						<span>총 상품금액</span>
						<strong>18,000</strong>
						<span>원</span>
						
						<em><img src="/images/mypage/ico_calc_minus.png" alt=""></em>
						<span>할인금액</span>
						<strong>2,000</strong>
						<span>원</span>
						<em><img src="/images/mypage/ico_calc_equal.png" alt=""></em>
						<span>최종 결제금액</span>
						<strong class="red">50,000</strong>
						<span>원</span>
					</div>
				</div>
			</div>
			<!-- //장바구니 하단 정보 -->


			<!-- 픽업정보 -->
			<div class="section-item">
				<h4>픽업정보</h4>
				<table class="tbl-write">
					<caption>픽업정보</caption>
					<tbody>
						<tr>
							<th scope="row">픽업매장</th>
							<td><span class="red">구로점</span>(02-123-4567)</td>
						</tr>
						<tr>
							<th scope="row">픽업매장 주소</th>
							<td>(01234) 서울특별시 관악구 난리로66 무슨빌딩 5층</td>
						</tr>
						<tr>
							<th scope="row">기타요청사항</th>
							<td>홍하리 / 바싹튀겨주세요~</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //배달정보 -->

			<!-- 결제정보 -->
			<div class="section-item">
				<h4>결제정보</h4>
				<table class="tbl-write">
					<caption>결제정보</caption>
					<tbody>
						<tr>
							<th scope="row">결제방법</th>
							<td>
								일반결제 / 신용카드
							</td>
						</tr>
						<tr>
							<th scope="row">결제금액</th>
							<td>
								<strong>50,000</strong>원
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //결제정보 -->


			<div class="btn-wrap two-up inner mar-t60">
				<a href="#" class="btn btn-lg btn-red"><span>주문내역 확인</span></a>
			</div>


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
