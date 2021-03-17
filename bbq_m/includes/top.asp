<%
    Dim PageTitle
SERVER_PORT = Request.ServerVariables("SERVER_PORT")
if G2_SITE_MODE = "production" and SERVER_PORT = "80" then 
	response.Redirect g2_bbq_m_url
	response.end 
end if 
%>
<!--#include virtual="/includes/meta.asp"-->
<title>브랜드 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<!--#include virtual="/api/ta/ta_top.asp"-->

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=DAUM_MAP_API_KEY%>&libraries=services,clusterer"></script>

<script>
	console.log('--- cart ---');
</script>
 
<div id="loding_div" style="width:100%; height:130%; top:-45px; padding-top:300px;; text-align:center; position:absolute; z-index:9999999999; background-color: #000; opacity: 0.5;"><img src="/images/common/ajax_loader.gif"></div>
<script>
	$(document).ready(function () {
		$("#loding_div").fadeOut(500);
	});
</script>

<!-- Layer Popup : 알림창1 -->
<div id="lp_alert" class="lp-wrapper type2" style="display: none;">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont type1">
                <p class="lp-msg">메시지</p>
            </div>
            <div class="btn-wrap">
                <button type="submit" class="btn w-100p btn-red2 btn-pop">확인</button>
            </div>
            <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->


<!-- Layer Popup : 알림창2 -->
<div id="lp_confirm" class="lp-wrapper type2" style="display: none;">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont">
                <p class="lp-msg">메시지</p>
            </div>
            <div class="btn-wrap two-up">
                <button type="submit" class="btn btn-pop btn-gray2" onclick="lpClose2(this);">취소</button>
                <button type="submit" class="btn btn-pop btn-red2">확인</button>
            </div>
            <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->



<!-- Layer Popup : 알림창4 -->
<div id="lp_msg" class="lp-wrapper type2">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont type1">
                <p class="lp-msg">메시지</p>
            </div>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->


<!-- Layer Popup : 알림창4 -->
<div id="lp_cart" class="lp-wrapper type2">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont type3">
                <p class="lp-msg has-ico ico-cart">선택한 메뉴가 장바구니에 담겼습니다.<br /> 장바구니로 이동하시겠습니까?</p>
            </div>
            <div class="btn-wrap two-up">
                <button type="submit" class="btn btn-pop btn-gray2" onclick="lpClose2(this);">취소</button>
                <button type="submit" class="btn btn-pop btn-red2" onclick="location.href='/order/cart.asp';">확인</button>
            </div>
            <button type="button" class="btn btn_lp_close" onclick="lpClose2(this);"><span>레이어팝업 닫기</span></button>
        </div>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->

<%
'임시로 내리기 -> 조성원수석님 요청
CookName	= "lp_member_" & lp_member_idx
'If Request.Cookies(CookName) = "done" Then 
If Request.Cookies(CookName) = "donetemp22" Then
'Else
%>
<!-- Layer Popup : 알림창5 -->
<div id="lp_member" class="lp-wrapper type2">
    <!-- LP Wrap -->
    <div class="lp-wrap">
        <div class="lp-confirm">
            <div class="lp-confirm-cont type2">
                <div class="lp-msg">

                    <!-- 딹 멤버십 안내  -->
                    <section class="section section_ddackMem "><!--mar-t60-->
                        <img src="images/main/ddack_popup01.png" alt="">
                     <!-- <div class="ddack-memWrap mar-b80">
                            <dl>
                                <dt class="red"><img src="/images/mypage/ddack_red.png" alt="딹"> <span>멤버십회원의 혜택?</span></dt>
                                <dd>구매금액의 5% 포인트 적립 / 이벤트 및 쿠폰 등의 다양한<br>
                                    서비스를 제공 받으실 수 있습니다.</dd>
                            </dl>
                        </div>
                        <div class="ddack-memWrap mar-b80">
                            <dl>
                                <dt class="sand"><img src="/images/mypage/ddack_sand.png" alt="딹"> <span>멤버십회원의 혜택?</span></dt>
                                <dd>
                                    <span class="chk-b">CHECK.1 회원가입</span>
                                    <p>BBQ 홈페이지 또는 모바일 앱에서 회원가입을 합니다.</p>
                                    <span class="chk-b mar-t25">CHECK.2 확인해주세요!</span>
                                    <p>포인트적립은 구매시점으로부터 최소72시간 <br>최대 1주일이내 적립됩니다
                                        (영업일기준)</p>
                                </dd>
                            </dl>
                        </div>
                                
                 
                        <div class="ddack-memWrap">
                            <dl>
                                <dt class="gold"><img src="/images/mypage/ddack_gold.png" alt="딹"> <span>포인트 적립 기준은 무엇인가요?</span></dt>
                                <dd><span class="ddack">딹</span>포인트는 BBQ홈페이지, BBQ앱, BBQ가맹점 <br>전화번호로
                                    인입된 주문의 실 결제금액의 5%적립을 <br>원칙으로 합니다.<br>
                                    (단, 주류, 음료, 배달서비스 결제금액은 제외됩니다)<br><br>
                                    <div class="small_txt">회원이BBQ어플리케이션/홈페이지가 아닌 다른 온라인<br>
                                        주문채널(배달의민족, 요기요, 배달통 등)을 통해 주문을<br>
                                        하거나, 현금, 상품권, 신용카드등을 통해 결제를 한 후<br> 하나
                                        이상의 적립카드와 기타의 할인카드 및 쿠폰을<br> 제시하고
                                        이중으로 포인트 누적 또는 할인을 요구 하거나,<br>
                                        할인 및 증정품(판촉물, 제품)제공 행사 참여시 적립을<br>
                                        요구했을 때, 기프티콘(e-coupon)으로 결제했을 때,<br>
                                        가맹점은 이를 거부할 수 있습니다.<br>
                                        이때 회원은 가맹점의 요구에 따라<span class="ddack">딹</span>멤버십포인트,<br>
                                        다른 온라인주문채널, 할인제도, 기프티콘 등 중 하나를<br>
                                        선택하여야 합니다.</div>
                                </dd>
                            </dl>
                            <span class="validity">유효기간은 적립일로부터 12개월입니다.</span>    -->

                            <!--
                    <div class="ddack-box">
                        <dl>
                            <dt class="navy"><span>적립된</span> <img src="/images/mypage/ddack_navy.png" alt="딹"><span>포인트는 어떻게 사용하나요?</span></dt>
                            <dd>회원님의 적립된 <span class="ddack">딹</span>포인트가 100포인트 이상 부터<br>
                            현금처럼 사용이 가능하며 “BBQ홈페이지/<br>어플리케이션” 에서 딹포인트 적립대상 품목을 <br><span class="ddack">딹</span>포인트로
                            구매 가능합니다.<br>
                            단, 휴게소, 지하철 역사, 기타 사업장에입점한 형태의<br> 가맹점과 일부 가맹점에서는 딹포인트 적립 및 사용이<br> 제한 될 수 있습니다.
                            
                            </dd>
                        </dl>
                    </div>

                        </div>-->

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
        
        <button type="button" class="today" onClick="PopupNoDispaly()"><span>하루동안 보지않기</span> <i class="axi axi-close"></i></button>
    </div>
    <!--// LP Wrap -->
</div>
<!--// Layer Popup -->
<%
End If
%>

<script>
    function setCookie(name, value, expiredays){
	var todayDate = new Date();
	todayDate.setDate(todayDate.getDate() + expiredays);

	document.cookie="lp_member_<%=lp_member_idx%>=done; path=/; expires=" + todayDate.toGMTString() + ";"
}
function PopupNoDispaly(){
	setCookie("lp_member_<%=lp_member_idx%>", "done", 1);
	$('#lp_member').hide();
}
</script>