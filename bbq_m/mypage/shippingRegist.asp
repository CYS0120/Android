<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">

<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="회원정보변경, BBQ치킨">
<meta name="Description" content="회원정보변경">
<title>회원정보변경 | BBQ치킨</title>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>

<script type="text/javascript">
	function showPostcode() {
		daum.postcode.load(function(){
			new daum.Postcode({
				oncomplete: function(data) {
					$("#sPost").val(data.zonecode);
					$("#sAddr1").val(data.roadAddress);
				}
			}).open();
		});
	}
</script>

</head>

<body>

<!-- Layer Popup : 배달지 입력 -->
<div id="LP_addShipping" class="lp-wrapper lp_addShipping" style="display:block;">

	<!-- LP Header -->
	<div class="lp-header">
		<h2>배달지 입력</h2>
	</div>
	<!--// LP Header -->

	<!-- LP Container -->
	<div class="lp-container">

		<!-- LP Content -->
		<div class="lp-content">
			<form action="">
				<div class="inner">
					<dl class="regForm">
						<dt>이름</dt>
						<dd>
							<input type="text" class="w-100p">
						</dd>
					</dl>
					<dl class="regForm">
						<dt>전화번호</dt>
						<dd>
							<span class="ui-group-tel">
								<span><input type="text"maxlength="20"></span>
								<span class="dash">-</span>
								<span><input type="text" maxlength="20"></span>
								<span class="dash">-</span>
								<span><input type="text" maxlength="20"></span>
							</span>
						</dd>
					</dl>
					<dl class="regForm">
						<dt><label for="sPost">주소</label></dt>
						<dd>
							<div class="ui-input-post">
								<input type="text" name="sPost" id="sPost" maxlength="7" readonly>
								<button type="button" class="btn btn-md btn-gray btn_post" onClick="javascript:showPostcode();"><span>우편번호 검색</span></button>
							</div>
							<div class="mar-t10"><input type="text" name="sAddr1" id="sAddr1" maxlength="100" class="w-100p"></div>
							<div class="mar-t10"><input type="text" name="sAddr2" id="sAddr2" maxlength="100" class="w-100p"></div>
						</dd>
					</dl>
				</div>
				<div class="btn-wrap two-up inner mar-t80">
					<button type="submit" class="btn btn-lg btn-black"><span>확인</span></button>
					<button type="submit" class="btn btn-lg btn-grayLine"><span>취소</span></button>
				</div>
			</form>
		</div>
		<!--// LP Content -->
	</div>
	<!--// LP Container -->
	<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
</div>
<!--// Layer Popup -->
</body>
</html>
