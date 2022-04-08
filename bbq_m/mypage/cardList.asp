<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>카드 | BBQ치킨</title>

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
		});
	}
</script>

</head>

<%
	Set pCardList = CardOwnerList("USE")
%>

<body>

<div class="wrapper">

	<%
		PageTitle = "비비큐 카드"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!-- 사용가능카드 -->
			<section class="section section_cardList">

				<div class="card_head inbox1000">사용 가능한 카드 <strong><%=UBound(pCardList.mCardDetail)+1%></strong>장</div>

				<div class="cardList_wrap inbox1000_2">

					<%
						For i = 0 To UBound(pCardList.mCardDetail)
					%>

					<div class="box">
						<div class="img"><a href="./cardView.asp?cardno=<%=pCardList.mCardDetail(i).mCardNo%>"><img src="/images/mypage/@card<%=(Right(pCardList.mCardDetail(i).mCardNo,1) Mod 4)+1%>.png" alt=""></a></div>
						<div class="money"><%=FormatNumber(pCardList.mCardDetail(i).mRestPayPoint,0)%>원</div>
					</div>

					<%
						Next
					%>

					<div class="blankBox_wrap">
						<div class="blankBox">
							<div class="img" onclick="javascript:lpOpen('.lp_cardadd');"><a href="#popup"><img src="/images/mypage/plus.png" alt="" class="blankBox_img"></a></div>
							<div class="txt">선물받은 카드를 등록하세요.</div>
						</div>
					</div>

				</div>


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


	<!-- Layer Popup : 카드등록 -->
	<div id="LP_cardGift" class="lp-wrapper lp_cardadd">
		<!-- LP Wrap -->
		<div class="lp-wrap inbox1000">
			<div class="lp-con">
				<!-- LP Header -->
				<div class="lp-header">
					<h2>카드 등록</h2>
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<section class="section">
							<form action="">
							<div class="card_giftPop">
								<dl>
									<dt>카드번호</dt>
									<dd>
										<input type="text" id="giftcardno" onlynum placeholder="숫자 16 또는 18자리만 입력" maxlength="18" style="width:100%">
									</dd>
								</dl>
							</div>
							<div class="alert mar-t30">
								<span>※ 카드 등록 후 적립한 포인트가 보이기까지는 최대 5분의 시간지연이 있을 수 있습니다.</span>
								<span>※ 5회이상 잘못 입력하신 경우 24시간 후 재등록 가능합니다.</span>
							</div>
							<div class="btn-wrap one pad-t40">
								<button type="button" class="btn btn_big btn-gray btn_confirm" onclick="regGiftCard();">등록하기</button>
							</div>
							</form>
						</section>
					</div>
					<!--// LP Content -->

				</div>
				<!--// LP Container -->
			</div>

			<button type="button" class="btn btn_lp_close" onclick='lpClose(".btn_lp_close")'>레이어팝업 닫기</button>

		</div>
		<!--// LP Wrap -->
	</div>
	<!--// Layer Popup -->				
</section>
<!-- //카드등록 -->
