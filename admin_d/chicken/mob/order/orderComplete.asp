<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="주문완료, BBQ치킨">
<meta name="Description" content="주문완료">
<title>주문완료 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>주문완료</h1>
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
		<article class="content content-gray">

			<!-- 주문완료 텍스트 -->
			<div class="order_CompleteTxt">
				<h3><span class="red">주문이 정상적으로 완료</span>되었습니다.</h3>
				<p>박라라님께서 주문하신 내역입니다.</p>
			</div>
			<!-- //주문완료 텍스트 -->

			<!-- 주문번호/일시 -->
			<section class="section section_orderNumDate">
				<dl>
					<dt>주문번호</dt>
					<dd>W100000010794231</dd>
				</dl>
				<dl>
					<dt>주문일시</dt>
					<dd>2018.12.20 17:25:21</dd>
				</dl>
			</section>
			<!-- //주문번호/일시 -->

			<!-- 장바구니 리스트 -->
			<div class="section-wrap">
				<section class="section section_orderDetail">
					<div class="section-header order_head mar-b0">
						<h3>주문메뉴</h3>
					</div>
					<div class="order_menu">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="http://placehold.it/160x160?text=1" alt=""></div>
								<div class="td info">
									<div class="sum">
										<dl>
											<dt>황금 올리브 치킨</dt>
											<dd>18,000원 <span>/ 1개</span></dd>
										</dl>
										<dl>
											<dt>- NEW포테이토</dt>
											<dd>10,000원 <span>/ 2개</span></dd>
										</dl>
										<dl>
											<dt>- 무</dt>
											<dd>500원 <span>/ 1개</span></dd>
										</dl>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="order_menu">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="http://placehold.it/160x160?text=1" alt=""></div>
								<div class="td info">
									<div class="sum">
										<dl>
											<dt>자메이카 + 올치팝(컵)</dt>
											<dd>18,000원 <span>/ 1개</span></dd>
										</dl>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="order_calc">
						<div class="top div-table mar-t30">
							<dl class="tr">
								<dt class="td">총 상품금액</dd>
								<dd class="td">18,000원</dd>
							</dl>
							<dl class="tr">
								<dt class="td">배달비</dd>
								<dd class="td">2,000원</dd>
							</dl>
							<dl class="tr">
								<dt class="td">할인금액</dd>
								<dd class="td">-5,000원</dd>
							</dl>
						</div>
						<div class="bot div-table">
							<dl class="tr">
								<dt class="td">최종 결제금액</dd>
								<dd class="td">15,000<span>원</span></dd>
							</dl>
						</div>
					</div>
				</section>
			</div>
			<!-- //장바구니 리스트 -->


			<!-- 배달정보 -->
			<div class="section-wrap section-orderInfo">
				<div class="section-header order_head">
					<h3>배달정보</h3>
				</div>
				<div class="area">
					<dl>
						<dt>배달매장</dt>
						<dd><strong class="red">구로점</strong>(02-123-4567)</dd>
					</dl>
					<dl>
						<dt>배달주소</dt>
						<dd>
							홍메리  /  010-1234-5678<br/>
							(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층
						</dd>
					</dl>
					<dl>
						<dt>기타요청사항</dt>
						<dd>도착해서 전화해주세요</dd>
					</dl>
				</div>
			</div>
			<!-- 배달정보 -->

			<!-- 결제정보 -->
			<div class="section-wrap section-orderInfo bor-none">
				<div class="section-header order_head">
					<h3>결제정보</h3>
				</div>
				<div class="area">
					<dl>
						<dt>일반결제</dt>
						<dd>일반결제 / 신용카드</dd>
					</dl>
					<dl>
						<dt>결제금액</dt>
						<dd class="big"><strong>15,000</strong>원</dd>
					</dl>
				</div>
				<div class="mar-t70">
					<a href="#" class="btn btn-lg btn-red w-100p">주문내역 확인</a>
				</div>
			</div>
			<!-- //결제정보 -->

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