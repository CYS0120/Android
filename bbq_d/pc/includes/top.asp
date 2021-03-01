<%
    Dim PageTitle
%>
<!--#include virtual="/includes/meta.asp"-->
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<!-- Layer Popup : 알림창1 -->
<div id="lp_alert" class="lp-wrapper" style="display: none;">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont type1">
                <p class="lp-msg">메시지</p>
            </div>
            <div class="btn-wrap">
                <button type="submit" class="btn btn-flat btn-red">확인</button>
            </div>
            <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->

<!-- Layer Popup : 알림창2 -->
<div id="lp_confirm" class="lp-wrapper" style="display: none;">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont type2">
                <p class="lp-msg">메시지</p>
            </div>
            <div class="btn-wrap two-up">
                <button type="submit" class="btn btn-flat btn-red">확인</button>
                <button type="submit" class="btn btn-flat btn-gray" onclick="lpClose(this);">취소</button>
            </div>
            <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->

<!-- Layer Popup : 알림창4 -->
<div id="lp_cart" class="lp-wrapper">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont type2">
                <p class="lp-msg has-ico ico-cart">선택한 메뉴가 장바구니에 담겼습니다.<br /> 장바구니로 이동하시겠습니까?</p>
            </div>
            <div class="btn-wrap two-up">
                <button type="submit" class="btn btn-flat btn-red" onclick="location.href='/order/cart.asp';">확인</button>
                <button type="submit" class="btn btn-flat btn-gray" onclick="lpClose(this);">취소</button>
            </div>
            <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->