<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="비비큐카드, BBQ치킨">
<meta name="Description" content="비비큐카드">
<title>비비큐카드 | BBQ치킨</title>
<script type="text/javascript">
	function validGift() {
		if($.trim($("#recv_nm").val()) == "") {
			showAlertMsg({msg:"받으시는 분 이름을 입력해주세요.", ok: function(){
				$("#recv_nm").focus();
			}});
			// alert("받으시는 분 이름을 입력해주세요.");
			return false;
		}
		var mobile = $.trim($("#recv_m1").val())+$.trim($("#recv_m2").val())+$.trim($("#recv_m3").val());

		if(mobile == "" || !(mobile.length == 10 || mobile.length == 11)) {
			showAlertMsg({msg:"전화번호를 확인해주세요.", ok: function(){
				$("#recv_m1").focus();
			}});
			// alert("전화번호를 확인해주세요.");
			// $("#recv_m1").focus();
			return false;
		}

		var chk = true;
		if($.trim($("#gift_msg").val()) == "") {
			showConfirmMsg({msg:"선물메시지없이 보내시겠습니까?", ok: function(){
				chk = false;
			}});
			return false;
			// if(window.confirm("선물메시지없이 보내시겠습니까?")) {
			// 	chk = false;
			// }
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
					lpClose(".lp_cardGiftPop");
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
		lpOpen(".lp_cardGiftPop");
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

	function chargeResultPopup(msg, returnurl) {
		lpOpen("#lp_alert");
		$("#lp_alert .lp-msg").text(msg);
		$("#lp_alert .btn_lp_close").on("click", function(){
			location.href = returnurl;
		});
	}
</script>
</head>

<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	<form name="c_form" id="c_form" method="post">
		<input type="hidden" name="gubun">
		<input type="hidden" name="domain" value="pc">
		<input type="hidden" name="card_seq">
		<input type="hidden" name="amount">
	</form>
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li><a href="#" onclick="javascript:return false;">bbq home</a></li>
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
	For i = 2 To 5
%>
						<div class="box">
							<div class="img"><img src="/images/mypage/@card<%=i-1%>.png" alt=""><span class="money">￦<em><%=i%>0,000</em></span></div>
							<div class="mar-t20 ta-c">
<%
	If CheckLogin() Then
%>
								<a href="javascript:chargeCard(<%=i%>);" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="showGift(<%=i%>);">선물하기</button>
<%
	Else
%>
								<a href="javascript:showAlertMsg({msg:'로그인이 필요합니다.'});" class="btn btn-sm2 btn-black w-120">구매하기</a>
								<button type="button" class="btn btn-sm2 btn-blackLine w-120" onclick="javascript:showAlertMsg({msg:'로그인이 필요합니다.'});">선물하기</button>
<%
	End If
%>
							</div>
						</div>
<%
	Next
%>
<!-- 						<div class="box">
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
									<form name="gc_form" id="gc_form" method="post">
										<input type="hidden" name="mobile" id="mobile">
										<input type="hidden" name="gubun" value="Gift">
										<input type="hidden" name="amount" id="amount">
										<table border="1" cellspacing="0" class="tbl-member black-line">
											<caption>정보입력</caption>
											<colgroup>
												<col style="width:220px;">
												<col style="width:auto;">
											</colgroup>
											<tbody>
												<tr>
													<th>받는사람 이름</th>
													<td>
														<input type="text" id="recv_nm" name="recv_nm" class="w-150">
													</td>
												</tr>
												<tr>
													<th>받는사람 휴대전화번호</th>
													<td>
														<div class="ui-group-email">
															<span><input type="text" id="recv_m1" name="recv_m1" onlyNum maxlength="3"></span>
															<span class="dash w-20">-</span>
															<span><input type="text" id="recv_m2" name="recv_m2" onlyNum maxlength="4"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text" id="recv_m3" name="recv_m3" onlyNum maxlength="4"></span>
														</div>
													</td>
												</tr>
												<tr>
													<th>선물메세지</th>
													<td>
														<textarea name="gift_msg" id="gift_msg" class="w-100p h-150"></textarea>
													</td>
												</tr>
											</tbody>
										</table>

										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="button" onclick="validGift();" class="btn btn-lg btn-black btn_confirm"><span>결제하기</span></button>
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
