<!-- Criteo 세일즈 태그 -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
<script type="text/javascript">
window.criteo_q = window.criteo_q || [];
var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
window.criteo_q.push(
 { event: "setAccount", account: 17628}, // 이 라인은 업데이트하면 안됩니다
 { event: "setEmail", email: "<%=Session("userId")%>" }, // 빈 문자 일수 있습니다 
 { event: "setSiteType", type: deviceType},
 { event: "trackTransaction", id: "<%=order_idx%>", item: [
    <%=criteo_str%>
]}
);
</script>
<!-- END Criteo 세일즈 태그 -->



<!-- Enliple Tracker Start -->
<script type="text/javascript">
	var deviceType = /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "M" : "W";
    window.ENP_VAR = { conversion: { product: [] } };

    // 주문한 각 제품들을 배열에 저장
    ENP_VAR.conversion.product.push(<%=mobon_str%>);

    ENP_VAR.conversion.ordCode= "<%=order_idx%>";
    ENP_VAR.conversion.totalPrice = "<%=pay_amt%>";
    ENP_VAR.conversion.totalQty = '<%=mobon_qty%>';

    (function(a,g,e,n,t){a.enp=a.enp||function(){(a.enp.q=a.enp.q||[]).push(arguments)};n=g.createElement(e);n.async=!0;n.defer=!0;n.src="https://cdn.megadata.co.kr/dist/prod/enp_tracker_self_hosted.min.js";t=g.getElementsByTagName(e)[0];t.parentNode.insertBefore(n,t)})(window,document,"script");
    enp('create', 'conversion', 'bbq', { device: deviceType });
    enp('send', 'conversion', 'bbq');
</script>
<!-- Enliple Tracker End -->
