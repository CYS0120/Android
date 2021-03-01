<script>
	// 장바구니에 있는 정보 가져오기
	var len = sessionStorage.length;
	var ta_cart_array = new Array();
	var temp_cart_prod = new Array();

	if(len == 0) {
	} else {
		for(var i = 0; i < len; i++) {
			var key = sessionStorage.key(i);

			if (sessionStorageException(key) == false) continue;

			var it = JSON.parse(sessionStorage.getItem(key));


			temp_cart_prod = {
				"id": it.idx, 
				"price": it.price, 
				"quantity": it.qty 
			};

			ta_cart_array.push(temp_cart_prod);
		}
	}
	// ta_cart_array 의 형식 = [{정보들}, {정보들2}]
</script>


<!-- Criteo 장바구니 태그 -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
<script type="text/javascript">
window.criteo_q = window.criteo_q || [];
var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
window.criteo_q.push(
 { event: "setAccount", account: 17628}, // 이 라인은 업데이트하면 안됩니다
 { event: "setEmail", email: "<%=Session("userId")%>" }, // 빈 문자 일수 있습니다 
 { event: "setSiteType", type: deviceType},
 { event: "viewBasket", item: ta_cart_array}
);

console.log(ta_cart_array);
</script>
<!-- END Criteo 장바구니 태그 -->




<script>
	// 장바구니에 있는 정보 가져오기
	var len = sessionStorage.length;
	var ta_cart_array = new Array();
	var temp_cart_prod = new Array();
	var ta_totalPrice = 0;
	var ta_totalQty = 0;

	var deviceType = /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "M" : "W";
    window.ENP_VAR = { conversion: { product: [] } };

	if(len == 0) {
	} else {
		for(var i = 0; i < len; i++) {
			var key = sessionStorage.key(i);

			if (sessionStorageException(key) == false) continue;

			var it = JSON.parse(sessionStorage.getItem(key));


			temp_cart_prod = {
				'productCode' : it.idx, 
				'productName' : it.nm, 
				'price': it.price, 
				'dcPrice' : it.price, 
				'qty' : it.qty 
			};

			ta_totalPrice += Number(it.price);
			ta_totalQty += Number(it.qty);

			// 주문한 각 제품들을 배열에 저장
			ENP_VAR.conversion.product.push(temp_cart_prod);

			ta_cart_array.push(temp_cart_prod);
		}

		ENP_VAR.conversion.totalPrice = ta_totalPrice;  // 없는 경우 단일 상품의 정보를 이용해 계산
		ENP_VAR.conversion.totalQty = ta_totalQty;  // 없는 경우 단일 상품의 정보를 이용해 계산
	}
	// ta_cart_array 의 형식 = [{정보들}, {정보들2}]
</script>



<!-- Enliple Tracker Start -->
<script type="text/javascript">

    (function(a,g,e,n,t){a.enp=a.enp||function(){(a.enp.q=a.enp.q||[]).push(arguments)};n=g.createElement(e);n.async=!0;n.defer=!0;n.src="https://cdn.megadata.co.kr/dist/prod/enp_tracker_self_hosted.min.js";t=g.getElementsByTagName(e)[0];t.parentNode.insertBefore(n,t)})(window,document,"script");
//    enp('create', 'conversion', 'bbq', { device: deviceType, paySys: 'naverPay' });

	console.log(ENP_VAR)
</script>
<!-- Enliple Tracker End -->
