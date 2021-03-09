<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="마이페이지, BBQ치킨">
<meta name="Description" content="마이페이지">
<title>마이페이지 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {
	
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
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li><a href="#" onclick="javascript:return false;">bbq home</a></li>
				<li><a href="#" onclick="javascript:return false;">마이페이지</a></li>
				<li>주문내역</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1>마이페이지</h1>
			<!-- Membership -->
			<section class="section section_membership">
				<!-- My Info -->
				<div class="myInfo-wrap">
					<div class="myInfo-membership">
						<div class="myInfo-memGrade silver">
							<p class="memGrade"><strong>박아람</strong>님 안녕하세요!</p>
							<p class="memTxt">세상에서 가장 건강하고 맛잇는 치킨 bbq 입니다.</p>
							<div class="btn-wrap">
								<button type="button" class="btn btn-sm2 btn-grayLine"><span>개인정보 변경</span></button>
								<button type="button" class="btn btn-sm2 btn-black mar-l10"><span>치킨캠프 신청내역</span></button>
							</div>
						</div>
						<!-- <div class="myInfo-inquiry">
							<dl class="itemInfo">
								<dt>1:1 문의내역</dt>
								<dd><span>1</span>건</dd>
							</dl>
							<dl class="itemInfo">
								<dt>상품문의내역</dt>
								<dd><span>1</span>건</dd>
							</dl>
						</div> -->
					</div>
					<div class="myInfo-shopping">
						<dl class="itemInfo itemInfo-point" onclick="location.href='/mypage/mileage.asp'">
							<dt>포인트</dt>
							<dd>
								<div class="count"><span>17,380</span>P</div>
							</dd>
						</dl>
						<dl class="itemInfo itemInfo-coupon" onclick="location.href='/mypage/couponList.asp'">
							<dt>쿠폰</dt>
							<dd>
								<div class="count"><span>1</span>장</div>
								<!-- <a href="#" class="link-go">쿠폰 등록하기</a> -->
							</dd>
						</dl>
						<dl class="itemInfo itemInfo-card" onclick="location.href='/mypage/cardList.asp'">
							<dt>카드</dt>
							<dd>
								<div class="count"><span>2</span>장</div>
							</dd>
						</dl>
					</div>
				</div>
				<!--// My Info -->
				<!-- My Menu -->
				<div class="myMenu-wrap on">
					<ul class="myMenu">
						<li class="on"><a href="/mypage/orderList.asp">주문내역</a></li>
						<li><a href="/mypage/couponList.asp">쿠폰</a></li>
						<li><a href="/mypage/mileage.asp">포인트</a></li>
						<li><a href="/mypage/cardList2.asp">카드</a></li>
						<li><a href="/mypage/inquiryList.asp">문의내역</a></li>
						<li><a href="/mypage/membership.asp"><span class="ddack">딹</span> 멤버십 안내</a>							
						</li>
					</ul>
				</div>
				<!--// My Menu -->
			</section>
			<!--// Membership -->
		
			<!-- 주문내역 -->
			<section class="section">
				<div class="section-header">
					<h3>주문내역상세</h3>
				</div>
				<div class="section-body">
					
				<!-- 주문요약정보 -->
				<div class="section_orderNumDate">
					<dl>
						<dt>주문번호 : </dt>
						<dd>W100000010794231</dd>
					</dl>
					<dl>
						<dt>주문일시 : </dt>
						<dd>2018.12.20 17:25:21</dd>
					</dl>
				</div>
				<!-- //주문요약정보 -->

			</section>
			<!--// 주문내역 -->


			<!-- 장바구니 테이블 -->
			<section class="section">
				<div class="section-header2">
					<h4>브랜드  : <span class="ico-branch red">비비큐치킨</span></h4>
					<div class="right">
						<ul class="state_sum">
							<li class="red"><img src="/images/mypage/ico_move.gif" alt=""> 배달주문(5)</li>
							<li><img src="/images/mypage/ico_ok.gif" alt=""> 배달완료</li>
						</ul>
					</div>
				</div>
				
				<div class="section-body">
					<table border="1" cellspacing="0" class="tbl-cart">
						<caption>장바구니</caption>
						<colgroup>
							<col style="width:105px;">
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
									<a href="#" onclick="javascript:return false;"><img src="http://placehold.it/85x85"/></a>
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
								<td class="move" rowspan="2">배달비<br/>2,000원</td>
								<td class="pay" rowspan="2">49,000원</td>
							</tr>
							<tr>
								<td class="img">
									<a href="#" onclick="javascript:return false;"><img src="http://placehold.it/85x85"/></a>
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
			</section>
			<!-- //장바구니 테이블 -->

			<!-- 장바구니 하단 정보 -->
			<div class="cart-botInfo div-table">
				<div class="tr">
					
					<div class="td rig">
						<span>총 상품금액</span>
						<strong>18,000</strong>
						<span>원</span>
						<em><img src="/images/mypage/ico_calc_plus.png" alt=""></em>
						<span>배달비</span>
						<strong>2,000</strong>
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


			<!-- 배달정보 -->
			<div class="section-item">
				<h4>배달정보</h4>
				<table class="tbl-write">
					<caption>배달정보</caption>
					<tbody>
						<tr>
							<th scope="row">배달매장</th>
							<td><span class="red">구로점</span>(02-123-4567)</td>
						</tr>
						<tr>
							<th scope="row">배달주소</th>
							<td>홍메리  /  010-1234-5678  /  (01234) 서울특별시 관악구 난리로66 무슨빌딩 5층</td>
						</tr>
						<tr>
							<th scope="row">기타요청사항</th>
							<td>도착해서 전화해주세요</td>
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
								<strong class="fs20">50,000</strong>원
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- //결제정보 -->


			<div class="btn-wrap two-up inner mar-t60">
				<a href="#" onclick="javascript:return false;" class="btn btn-lg btn-black"><span>목록</span></a>
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
