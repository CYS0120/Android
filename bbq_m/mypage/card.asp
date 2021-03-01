<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="카드, BBQ치킨">
<meta name="Description" content="카드">
<title>비비큐카드 | BBQ치킨</title>

<script type="text/javascript">
	function validGift() {
		if($.trim($("#recv_nm").val()) == "") {
			alert("받으시는 분 이름을 입력해주세요.");
			$("#recv_nm").focus();
			return false;
		}
		var mobile = $.trim($("#recv_m1").val())+$.trim($("#recv_m2").val())+$.trim($("#recv_m3").val());

		if(mobile == "" || !(mobile.length == 10 || mobile.length == 11)) {
			alert("전화번호를 확인해주세요.");
			$("#recv_m1").focus();
			return false;
		}

		var chk = true;
		if($.trim($("#gift_msg").val()) == "") {
			if(window.confirm("선물메시지없이 보내시겠습니까?")) {
				chk = false;
			}
		} else {
			chk = false;
		}

		if(chk) {
			alert("선물메시지를 입력해주세요.");
			$("#gift_msg").focus();
			return false;
		}

		$("#mobile").val(mobile);

		$.ajax({
			method: "post",
			url: "giftCard_Proc.asp",
			data: $("#gc_form").serialize(),
			dataType: "json",
			success: function(res) {
				if(res.result == 0) {
					$("#c_form input[name=card_seq]").val(res.seq);
					$("#c_form input[name=gubun]").val("Gift");
					$("#c_form input[name=amount]").val($("#amount").val());

					window.open("","pgp", pgPopupOption);

					$("#c_form").attr("action","/pay/danal_card/Ready.asp");
					$("#c_form").attr("target", "pgp");
					$("#c_form").submit();
				} else {
					alert(res.message);
				}
			}
		});
	}

		function showGift(amount) {
		lpOpen(".lp_cardGift");
		$("#amount").val(amount * 10000);
	}

	function chargeCard(amount) {
		$.ajax({
			method: "post",
			url: "chargeCard_Proc.asp",
			data:{gubun:"Charge",amount:amount*10000},
			dataType: "json",
			success: function(res) {
				if(res.result == 0) {
					$("#c_form input[name=card_seq]").val(res.seq);
					$("#c_form input[name=gubun]").val("Charge")
					$("#c_form input[name=amount]").val(amount * 10000);

					window.open("","pgp", pgPopupOption);

					$("#c_form").attr("action", "/pay/danal_card/Ready.asp");
					$("#c_form").attr("target", "pgp");
					$("#c_form").submit();
				} else {
					alert(res.message);
				}
			}
		});
	}
</script>

</head>

<%
	PageTitle = "비비큐카드"
%>

<body>
<div class="wrapper">

	<!--#include virtual="/includes/header.asp"-->

	<form name="c_form" id="c_form" method="post">
		<input type="hidden" name="gubun">
		<input type="hidden" name="domain" value="mobile">
		<input type="hidden" name="card_seq">
		<input type="hidden" name="amount">
	</form>

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!-- 사용가능카드 -->
			<section class="section section_cardList mar-t60">
				<div class="area">

					<%
						For i = 2 To 5
					%>

					<div class="box">
						<div class="img"><img src="/images/mypage/@card<%=i-1%>.png" alt=""><span class="money">￦<em><%=i%>0,000</em></span></div>
						<div class="btn-wrap two-up pad-t40 bg-white inner">

							<%
								If CheckLogin() Then
							%>

							<a href="javascript:chargeCard(<%=i%>);" class="btn btn-md btn-black btn_confirm"><span>구매하기</span></a>
							<button type="button" onclick="showGift(<%=i%>);" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button>

							<%
								Else
							%>

							<a href="javascript:alert('로그인이 필요합니다.');" class="btn btn-md btn-black btn_confirm"><span>구매하기</span></a>
							<button type="button" onclick="javascript:alert('로그인이 필요합니다.');" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button>

							<%
								End If
							%>

						</div>
					</div>

					<%
						Next
					%>

					<!-- <div class="box">
						<div class="img"><img src="/images/mypage/@card1.png" alt=""><span class="money">￦<em>10,000</em></span></div>
						<div class="btn-wrap two-up pad-t40 bg-white inner">
							<a href="#" class="btn btn-md btn-black btn_confirm"><span>구매하기</span></a>
							<button type="button" onclick="javascript:lpOpen('.lp_cardGift');" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button>
						</div>
					</div>
					<div class="box">
						<div class="img"><img src="/images/mypage/@card2.png" alt=""><span class="money">￦<em>10,000</em></span></div>
						<div class="btn-wrap two-up pad-t40 bg-white inner">
							<a href="#" class="btn btn-md btn-black btn_confirm"><span>구매하기</span></a>
							<button type="button" onclick="javascript:lpOpen('.lp_cardGift');" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button>
						</div>
					</div>
					<div class="box">
						<div class="img"><img src="/images/mypage/@card3.png" alt=""><span class="money">￦<em>10,000</em></span></div>
						<div class="btn-wrap two-up pad-t40 bg-white inner">
							<a href="#" class="btn btn-md btn-black btn_confirm"><span>구매하기</span></a>
							<button type="button" onclick="javascript:lpOpen('.lp_cardGift');" class="btn btn-md btn-grayLine btn_cancel"><span>선물하기</span></button>
						</div>
					</div> -->
				</div>
			</section>
			<!-- //사용가능카드 -->

			<!-- Layer Popup : 카드선물 -->
			<div id="LP_cardGift" class="lp-wrapper lp_cardGift">
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
									<form name="gc_form" id="gc_form" method="post">
										<input type="hidden" name="mobile" id="mobile">
										<input type="hidden" name="gubun" value="Gift">
										<input type="hidden" name="amount" id="amount">
										<div class="inner">
											<div class="card_giftPop">
												<dl>
													<dt>이름</dt>
													<dd>
														<input type="text" id="recv_nm" name="recv_nm" class="w-100p">
													</dd>
												</dl>
												<dl>
													<dt>전화번호</dt>
													<dd>
														<div class="ui-group-email">
															<span><input type="text" id="recv_m1" name="recv_m1" onlyNum maxlength="3"></span>
															<span class="dash w-20">-</span>
															<span><input type="text" id="recv_m2" name="recv_m2" onlyNum maxlength="4"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text" id="recv_m3" name="recv_m3" onlyNum maxlength="4"></span>
														</div>
													</dd>
												</dl>
												<dl>
													<dt>선물메시지</dt>
													<dd>
														<textarea name="gift_msg" id="gift_msg" class="w-100p h-280"></textarea>
													</dd>
												</dl>
											</div>
											
											<div class="btn-wrap two-up pad-t40 bg-white">
												<button type="button" onclick="validGift();" class="btn btn-lg btn-black btn_confirm"><span>결제하기</span></button>
												<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
											</div>
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

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
