<%
    Dim PageTitle
SERVER_PORT = Request.ServerVariables("SERVER_PORT")
if G2_SITE_MODE = "production" and SERVER_PORT = "80" then 
	response.Redirect g2_bbq_d_url
	response.end 
end if 
%>
<!--#include virtual="/includes/meta.asp"-->
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<!--#include virtual="/api/ta/ta_top.asp"-->

<!-- Layer Popup : 알림창1 -->
<div id="lp_alert" class="lp-wrapper" style="display: none;z-index:2000">
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
                <button type="submit" class="btn btn-flat btn-red" onclick="location.href='/order/cart.asp';">이동</button>
                <button type="submit" class="btn btn-flat btn-gray" onclick="lpClose(this);">머물기</button>
            </div>
            <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->


<!-- Layer Popup : 알림창5 -->
<div id="lp_member" class="lp-wrapper">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont type2">
                <div class="lp-msg">

                    <!-- 딹 멤버십 안내  -->
                    <section class="section">
                        <div class="section-header">
                            <h3><span class="ddack">딹</span> 멤버십 안내</h3>
                        </div>
                        <div class="section-body">
                            <div class="ddack-memFAQ">
                                <dl class="benefit">
                                    <dt><span class="ddack-mem">딹</span><span class="txt">멤버십회원의 혜택?</span></dt>
                                    <dd>구매금액의 5% 포인트 적립 / 이벤트 및 쿠폰 등의 다양한 서비스를 제공 받으실 수 있습니다.</dd>
                                </dl>
                                <dl class="join">
                                    <dt><span class="ddack-mem">딹</span><span class="txt">멤버십에 가입하려면?</span></dt>
                                    <dd class="check">
                                        <div>
                                            <h4>CHECH.1 회원가입</h4>
                                            <p>BBQ 홈페이지 또는 모바일 앱에서 회원가입을 합니다.</p>
                                        </div>
                                        <div>
                                            <h4>CHECH.2 회원가입</h4>
                                            <p>포인트적립은 구매시점으로부터 최소 72시간 최대 1주일이내 적립됩니다(영업일기준)</p>
                                        </div>
                                    </dd>
                                </dl>
                                <dl class="reserve">
                                    <dt><span class="ddack-mem">딹</span><span class="txt">포인트 적립 기준은 무엇인가요?</span></dt>
                                    <dd>
                                        <p>
                                            <span class="ddack">딹</span>포인트는 BBQ홈페이지, BBQ앱, BBQ가맹점 전화번호로 인입된 주문의 실 결제금액의 5%적립을 원칙으로 합니다.<br>(단, 주류, 음료, 배달서비스 결제금액은 제외됩니다)
                                        </p>
                                        <p>회원이BBQ어플리케이션/홈페이지가 아닌 다른 온라인주문채널(배달의민족, 요기요, 배달통 등)을 통해 주문을 하거나, 현금, 상품권, 신용카드 등을 통해 결제를 한 후 하나 이상의 적립카드와 기타의 할인카드 및 쿠폰을 제시하고 이중으로 포인트 누적 또는 할인을 요구 하거나,
                                            할인 및 증정품(판촉물, 제품)제공 행사 참여시 적립을 요구했을 때, 기프티콘(e-coupon)으로 결제했을 때, 가맹점은 이를 거부할 수 있습니다.
                                            이때 회원은 가맹점의 요구에 따라 <span class="ddack">딹</span> 멤버십포인트, 다른 온라인주문채널, 할인제도, 기프티콘 등 중 하나를 선택하여야 합니다. </p>
                                    </dd>
                                </dl>
                            </div>
                            <div class="ddack-memInfo">
                                <p class="validity">유효기간은 적립일로부터 12개월입니다.</p>
<!--
                                <div class="use-box">
                                    <dl>
                                        <dt><span class="txt">적립된 </span><span class="ddack-mem">딹</span><span class="txt">포인트는 어떻게 사용하나요?</span></dt>
                                        <dd>회원님의 적립된 <span class="ddack">딹</span> 포인트가 100포인트 이상 부터 현금처럼 사용이 가능하며 “BBQ홈페이지/어플리케이션” 에서 <span class="ddack">딹</span>포인트 적립대상 품목을 <span class="ddack">딹</span>포인트로 구매 가능합니다.
                                            <br>단, 휴게소, 지하철 역사, 기타 사업장에 입점한 형태의 가맹점과 일부 가맹점에서는 <span class="ddack">딹</span>포인트 적립 및 사용이 제한 될 수 있습니다.
                                        </dd>
                                    </dl>
                                </div>
-->
                            </div>

                        </div>
                    </section>
                    <!--// 딹 메버십 안내 -->
                </div>
            </div>
            <!--
            <div class="btn-wrap two-up">
                <button type="submit" class="btn btn-flat btn-red" onclick="location.href='/order/cart.asp';">확인</button>
                <button type="submit" class="btn btn-flat btn-gray" onclick="lpClose(this);">취소</button>
            </div>
-->
            <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->