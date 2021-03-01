<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="비비큐카드, BBQ치킨">
<meta name="Description" content="비비큐카드">
<title>비비큐카드 | BBQ치킨</title>
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
				<li><a href="/">bbq home</a></li>
				<li>비비큐카드</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			
			<section class="section">
				<div class="section-header">
					<h3>비비큐카드</h3>
				</div>
				<div class="section-body">
					<div class="card-list">
<%
	For i = 1 To 4
%>
						<div class="box">
							<div class="img"><img src="/images/mypage/@card<%=i%>.png" alt=""><span class="money">￦<em><%=i%>0,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="<%If CheckLogin() Then%>javascript:;<%Else%>javascript:alert('로그인이 필요합니다.');<%End If%>" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div>
<%
	Next
%>
						<!-- <div class="box">
							<div class="img"><img src="/images/mypage/@card1.png" alt=""><span class="money">￦<em>10,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="#" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div>
						<div class="box">
							<div class="img"><img src="/images/mypage/@card2.png" alt=""><span class="money">￦<em>20,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="#" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div>
						<div class="box">
							<div class="img"><img src="/images/mypage/@card3.png" alt=""><span class="money">￦<em>30,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="#" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div>
						<div class="box">
							<div class="img"><img src="/images/mypage/@card4.png" alt=""><span class="money">￦<em>40,000</em></span></div>
							<div class="mar-t20 ta-c">
								<a href="#" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:lpOpen('.lp_cardGiftPop');">선물하기</button>
							</div>
						</div> -->
					</div>
				</div>
			</section>

			
			<!-- Layer Popup : 카드 선물하기 -->
			<div id="lp_cardGiftPop" class="lp-wrapper lp_cardGiftPop">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>카드 선물하기</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">
								<section class="section">
									<form action="" name="gCard" id="gCard" method="post" onsubmit="return false;">
										<input type="hidden" name="receivePhone">
										<input type="hidden" name="pay_data" value="">
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
														<input type="text" class="w-150" name="receiveName">
													</td>
												</tr>
												<tr>
													<th>휴대전화번호</th>
													<td>
														<div class="ui-group-email">
															<span><input type="text" name="mobile1"></span>
															<span class="dash w-20">-</span>
															<span><input type="text" name="mobile2"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text" name="mobile3"></span>
														</div>
													</td>
												</tr>
												<tr>
													<th>선물메세지</th>
													<td>
														<textarea name="receiveMessage" id="" class="w-100p h-150"></textarea>
													</td>
												</tr>
											</tbody>
										</table>

										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="button" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
											<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
										</div>
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
