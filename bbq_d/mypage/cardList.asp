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
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});
});
</script>
<script type="text/javascript">
	function regGiftCard() {
		var cno = $.trim($("#giftcardno").val());

		if(cno.length != 16 && cno.length != 18) {
			showAlertMsg({msg:"카드번호는 숫자 16자리 또는 18자리만 입력가능합니다."})
			return false;
		}

		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_regGiftCard.asp",
			data: {cno:cno},
			dataType: "json",
			success: function(res) {
				showAlertMsg({msg:res.message, ok: function(){
					if(res.result == 0) {
						location.reload(true);
					}
				}});
			},
			error: function(res) {
				showAlertMsg({msg:res.message});
			}
		})
	}
</script>
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
						<div class="box">
							<div class="img blankBox" onclick="javascript:lpOpen('.lp_cardadd');"><img src="/images/mypage/plus.png" alt=""></div>
							<div class="info">
								<p class="txt"><strong>선물받은 카드를 등록하세요.</strong></p>
							</div>
						</div>
					</div>
				</div>
			</section>
			<!--// card List -->

			<!-- Layer Popup : 카드 선물하기 -->
			<div id="lp_cardGiftPop" class="lp-wrapper lp_cardadd">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>카드정보</h2>
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
													<th>카드번호</th>
													<td><input type="text" id="giftcardno" onlynum placeholder="숫자 16 또는 18자리만 입력" maxlength="18" class="w-350"></td>
												</tr>
											</tbody>
										</table>
										<div class="alert">
											<span>* 카드 등록 후 적립한 포인트가 보이기까지는 최대 5분의 시간지연이 있을 수 있습니다.</span>
											<span>* 5회이상 잘못 입력하신 경우 24시간 후 재등록 가능합니다.</span>
										</div>
										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="button" class="btn btn-lg btn-black btn_confirm" onclick="regGiftCard();"><span>등록하기</span></button>
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
