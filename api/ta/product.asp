<!-- Criteo 상품 태그 -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
<script type="text/javascript">
window.criteo_q = window.criteo_q || [];
var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
window.criteo_q.push(
 { event: "setAccount", account: 17628}, // 이 라인은 업데이트하면 안됩니다
 { event: "setEmail", email: "<%=Session("userId")%>" }, // 빈 문자 일수 있습니다 
 { event: "setSiteType", type: deviceType},
 { event: "viewItem", item: "<%=menu_idx%>" });
</script>
<!-- END Criteo 상품 태그 -->


<!-- Enliple Tracker Start -->
<script type="text/javascript">
	var deviceType = /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "M" : "W";

    window.ENP_VAR = { 
        collect: {}, 
        conversion: { product: [] }
    };
    ENP_VAR.collect.productCode = '<%=menu_idx%>';
    ENP_VAR.collect.productName = '<%=vMenuName%>';
    ENP_VAR.collect.price = '<%=vMenuPrice%>';
    ENP_VAR.collect.dcPrice = '<%=vMenuPrice%>';
    ENP_VAR.collect.soldOut = 'N';
    ENP_VAR.collect.imageUrl = '<%=ta_img_url%>';
    ENP_VAR.collect.topCategory = '<%=vKind_sel%>';
    ENP_VAR.collect.firstSubCategory = '<%=vKind_sel%>';
    ENP_VAR.collect.secondSubCategory = '<%=vMenu_type%>';
    ENP_VAR.collect.thirdSubCategory = '';

//    /* 간편 결제 시스템을 통한 전환. (이용하지 않는 경우 삭제) */
//    ENP_VAR.conversion.product.push({
//        productCode : '제품 코드',
//        productName : '제품명',
//        price : '제품가격',
//        dcPrice : '제품 할인가격',
//        qty : '제품 수량',
//        soldOut : '품절 여부',
//        imageUrl : '상품 이미지 URL',
//        topCategory : '상품이 속한 카테고리의 최상위 분류',
//        firstSubCategory : '대분류',
//        secondSubCategory : '중분류',
//        thirdSubCategory : '소분류'
//    });

    (function(a,g,e,n,t){a.enp=a.enp||function(){(a.enp.q=a.enp.q||[]).push(arguments)};n=g.createElement(e);n.async=!0;n.defer=!0;n.src="https://cdn.megadata.co.kr/dist/prod/enp_tracker_self_hosted.min.js";t=g.getElementsByTagName(e)[0];t.parentNode.insertBefore(n,t)})(window,document,"script");
    /* 상품수집 */
    enp('create', 'collect', 'bbq', { device: deviceType });
    /* 장바구니 버튼 타겟팅 (이용하지 않는 경우 삭제) */
    enp('create', 'cart', 'bbq', { device: deviceType, btnSelector: 'btn_cart_go' });
//    /* 찜 버튼 타겟팅 (이용하지 않는 경우 삭제) */
//    enp('create', 'wish', 'bbq', { device: deviceType, btnSelector: '찜 버튼의 CSS Selector (document.querySelector 함수에 들어갈 수 있는 값)' });
//    /* 간편 결제 시스템을 통한 전환. (이용하지 않는 경우 삭제) */
//    enp('create', 'conversion', 'bbq', { device: deviceType, paySys: 'naverPay' });
</script>
<!-- Enliple Tracker End -->
