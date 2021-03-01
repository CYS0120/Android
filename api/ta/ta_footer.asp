<% If Request.ServerVariables("PATH_INFO") <> "/menu/menuView.asp" And Request.ServerVariables("PATH_INFO") <> "/order/cart.asp" And Request.ServerVariables("PATH_INFO") <> "/order/orderComplete.asp" Then %>
	<!-- Criteo 홈페이지 태그 -->
	<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
	<script type="text/javascript">
	window.criteo_q = window.criteo_q || [];
	var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
	window.criteo_q.push(
	 { event: "setAccount", account: 17628}, // 이 라인은 업데이트하면 안됩니다
	 { event: "setEmail", email: "<%=Session("userId")%>" }, // 빈 문자 일수 있습니다 
	 { event: "setSiteType", type: deviceType},
	 { event: "viewHome"});
	</script> 
	<!-- END Criteo 홈페이지 태그 -->
<% End If %>


<!-- Enliple Tracker Start -->
<script type="text/javascript">
	var deviceType = /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "M" : "W";

    (function(a,g,e,n,t){a.enp=a.enp||function(){(a.enp.q=a.enp.q||[]).push(arguments)};n=g.createElement(e);n.async=!0;n.defer=!0;n.src="https://cdn.megadata.co.kr/dist/prod/enp_tracker_self_hosted.min.js";t=g.getElementsByTagName(e)[0];t.parentNode.insertBefore(n,t)})(window,document,"script");
    enp('create', 'common', 'bbq', { device: deviceType });    
    enp('send', 'common', 'bbq');
</script>
<!-- Enliple Tracker End -->

