<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "쿠폰 등록"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content inbox1000_2">
			
			<div class="tab-type4">
				<ul class="tab">
					<li><a href="/mypage/couponKeep.asp">마이 쿠폰</a></li>
					<li class="on"><a href="/mypage/couponWrite.asp">쿠폰 등록</a></li>
				</ul>
			</div>

			<!-- e쿠폰 등록 -->
			<div id="LP_eCoupon" class="eCoupon_wrap">
				<h3>쿠폰  번호를<br>입력하여 주세요.</h3>
				<form action="">
					<ul>
						<li><input type="text" id="txtPIN_save" name="txtPIN_save" placeholder="쿠폰 번호 입력" class="w-100p" maxlength="12"></li>
						<li class="mar-t15"><button type="button" onclick="javascript:eCoupon_Check();" class="btn btn_middle btn-red">확인</button></li>
					</ul>
				</form>
				<p>
					<strong><span>*</span> 쿠폰 입력이 잘 안될 때 확인 해주세요.</strong>
					알파벳 ( I ) → 숫자 ( 1 ), 알파벳 ( O ) → 숫자 ( 0 ) 로 변경하여 정확히 확인 후 입력해 주세요.
				</p>
			</div>
			<!--// e쿠폰 등록 -->


		<script type="text/javascript">
			function eCoupon_Check() {
				if ($("#txtPIN_save").val() == "") {
					alert('E-쿠폰 번호를 입력해주세요.');
					return;
				}
				$.ajax({
					method: "post",
					url: "/api/ajax/ajax_getEcoupon.asp",
					data: {
						txtPIN: $("#txtPIN_save").val(),
						PIN_save: "Y"
					},
					dataType: "json",
					success: function(res) {
						if (res.result == 0) {
							showConfirmMsg({
								msg:"정상 등록되었습니다.<br><br>e쿠폰을 바로 사용하시겠습니까?", 
								ok: function(){
									var menuItem = res.menuItem;
									addCartMenu(menuItem);
									location.href = "/order/cart.asp";
								},
								cancel:function() {
									location.href = "/mypage/couponKeep.asp";
								}
							});
						} else {
							showAlertMsg({
								msg: res.message
							});
						}
					},
					error: function(data, status, err) {
//							msg: data + ' ' + status + ' ' + err
						showAlertMsg({
							msg: "에러가 발생하였습니다",
							ok: function() {
								location.href = "/";
							}
						});
					}

				});
			}
		</script>
		

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

