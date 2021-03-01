<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="전체공통 알림창, BBQ치킨">
<meta name="Description" content="전체공통 알림창">
<title>전체공통 알림창 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {});
</script>
</head>

<body>
<div style="margin:50px 0 0 50px;">
	<button type="button" class="btn btn-md btn-grayLine" onclick="lpOpen2('#popup_sample1');">알림창1</button>
	<button type="button" class="btn btn-md btn-grayLine" onclick="lpOpen2('#popup_sample2');">알림창2</button>
	<button type="button" class="btn btn-md btn-grayLine" onclick="lpOpen2('#popup_sample3');">알림창3</button>
	<button type="button" class="btn btn-md btn-grayLine" onclick="lpOpen2('#popup_sample4');">알림창4</button>
</div>

<!-- Layer Popup : 알림창1 -->
<div id="popup_sample1" class="lp-wrapper type2">
	<!-- LP Wrap -->
	<div class="lp-wrap">
		<div class="lp-confirm">
			<div class="lp-confirm-cont type1">
				<p class="lp-msg">20,000원이 충전되었습니다.</p>
			</div>
			<div class="btn-wrap">
				<button type="submit" class="btn w-100p btn-red22 btn-pop" onclick="lpClose2(this);">확인</button>
			</div>
			<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
		</div>
	</div>
	<!--// LP Wrap -->
</div>
<!--// Layer Popup -->

<!-- Layer Popup : 알림창2 -->
<div id="popup_sample2" class="lp-wrapper type2">
	<!-- LP Wrap -->
	<div class="lp-wrap">
		<div class="lp-confirm">
			<div class="lp-confirm-cont">
				<p class="lp-msg">모든 상품을 삭제하시겠습니까?</p>
			</div>
			<div class="btn-wrap two-up">
				<button type="submit" class="btn btn-pop btn-red2" onclick="lpClose2(this);">확인</button>
				<button type="submit" class="btn btn-pop btn-gray2" onclick="lpClose2(this);">취소</button>
			</div>
			<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
		</div>
	</div>
	<!--// LP Wrap -->
</div>
<!--// Layer Popup -->

<!-- Layer Popup : 알림창3 -->
<div id="popup_sample3" class="lp-wrapper type2">
	<!-- LP Wrap -->
	<div class="lp-wrap">
		<div class="lp-confirm">
			<div class="lp-confirm-cont type2">
				<p class="lp-msg">모든 상품을 삭제하시겠습니까?</p>
			</div>
			<div class="lp-alarm">
				<label class="ui-checkbox type2">
					<input type="checkbox" name="sAgree" id="sAgree1" value="">
					<span></span>
					이 페이지에서 추가 메시지를 만들도록 허용하지 않음
				</label>
			</div>
			<div class="btn-wrap two-up">
				<button type="submit" class="btn btn-pop btn-red2" onclick="lpClose2(this);">확인</button>
				<button type="submit" class="btn btn-pop btn-gray2" onclick="lpClose2(this);">취소</button>
			</div>
			<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
		</div>
	</div>
	<!--// LP Wrap -->
</div>
<!--// Layer Popup -->

<!-- Layer Popup : 알림창4 -->
<div id="popup_sample4" class="lp-wrapper type2">
	<!-- LP Wrap -->
	<div class="lp-wrap">
		<div class="lp-confirm">
			<div class="lp-confirm-cont type3">
				<p class="lp-msg has-ico ico-cart">선택한 메뉴가 장바구니에 담겼습니다.<br /> 장바구니로 이동하시겠습니까?</p>
			</div>
			<div class="btn-wrap two-up">
				<button type="submit" class="btn btn-pop btn-red2" onclick="lpClose2(this);">확인</button>
				<button type="submit" class="btn btn-pop btn-gray2" onclick="lpClose2(this);">취소</button>
			</div>
			<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
		</div>
	</div>
	<!--// LP Wrap -->
</div>
<!--// Layer Popup -->
</html>
