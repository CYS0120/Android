<!-- quickMenu -->
<div class="quickMenu">
    <ul class="menuList">
        <li><a href="javascript:;" onClick="go_site('START')"><p><img src="/images/common/ico_quickmenu01.png" alt="" /></p><span>창업정보</span></a></li>
        <li><a href="javascript:;" onClick="go_site('CHICKEN_UNI')"><p><img src="/images/common/ico_quickmenu02.png" alt="" /></p><span>치킨캠프</span></a></li>
        <li>
            <!--a href="/mypage/card.asp"--><a href="/event/eventList.asp"><p><img src="/images/common/ico_quickmenu03.png" alt="" /></p><span>이벤트</span></a></li>
        <li><a href="javascript:void(0);" onclick="javascript: mobile_window_open('ecoupon');"><p><img src="/images/common/ico_quickmenu04.png" alt="" /></p><span>e쿠폰</span></a></li>
    </ul>
</div>
<!--// quickMenu -->

<!-- Back to Top -->
<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
<!--// Back to Top -->


<!-- Layer Popup : e쿠폰 -->
<div id="lp_eCouponPop" class="lp-wrapper lp_eCouponPop">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-con">
            <!-- LP Header -->
          <!--  <div class="lp-header">
                <h2>E-쿠폰 등록</h2>
            </div>-->
            <!--// LP Header -->
            <!-- LP Container -->
            <div class="lp-container">
                <!-- LP Content -->
                <div class="lp-content">
                  <section class="section2">
						<input type="hidden" id="ecoupon_data" name="ecoupon_data">
						<div class="area ">
							<h3>쿠폰인증번호 등록하기</h3>
							<div class="wrap">
								<input type="text" id="txtPIN" name="txtPIN" placeholder="쿠폰 번호 입력">
								<button type="button" onclick="javascript:eCoupon_Check();" class="btn btn-md2 btn-black">쿠폰번호인증</button>
							</div>
							<div class="txt">
								10-35자 일련번호 .  “ - ”  제외, 알파벳 ( I ) => 숫자 ( 1 ), 알파벳 ( O ) => 숫자 ( 0 ) 로<br/>
								정확히 확인 후 입력하시기 바랍니다
							</div>
						</div>

						<div class="btn-wrap two-up pad-t40 bg-white">
							<button type="button" onclick="javascript:eCoupon_Cart();" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
							<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
						</div>
					</section>
					<!--p><img src="/images/common/e-coupon_info_re.png"/></p-->
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

<script type="text/javascript">
    function eCoupon_Check() {
        if ($("#txtPIN").val() == "") {
            alert('E-쿠폰 번호를 입력해주세요.');
            return;
        }
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_getEcoupon.asp",
            data: {
                txtPIN: $("#txtPIN").val()
            },
            dataType: "json",
            success: function(res) {
                showAlertMsg({
                    msg: res.message,
                    ok: function() {
                        if (res.result == 0) {
                            $("#ecoupon_data").val(res.menuItem);
                        }
                    }
                });
            },
            error: function(data, status, err) {
                showAlertMsg({
                    msg: data + ' ' + status + ' ' + err
                });
            }

        });
    }
	function eCoupon_Cart(){
		var menuItem = $("#ecoupon_data").val();
		if ( menuItem == ''){
			alert('쿠폰인증을 먼저 진행해 주세요');
		}else{
			addCartMenu(menuItem);
			location.href = "/order/cart.asp";
		}
	}
</script>