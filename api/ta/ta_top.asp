<!-- Facebook Pixel Code -->
<script>
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window, document,'script','https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '2714406355544757');
fbq('track', 'PageView');
<%=FB_script%>
</script>
<noscript><img height="1" width="1" style="display:none" src="https://www.facebook.com/tr?id=2714406355544757&ev=PageView&noscript=1" /></noscript>
<!-- End Facebook Pixel Code -->

<!--
<script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
<script type="text/javascript">
      kakaoPixel('1188504223027052596').pageView();
	  <%=kakao_script%>
</script>
-->

<%
ga_id = ""
if request.servervariables("HTTP_HOST") = "m.bbq.co.kr" then
	ga_id = "UA-56160528-1"
elseif request.servervariables("HTTP_HOST") = "bbq.co.kr" then
	ga_id = "UA-39768002-1"
elseif request.servervariables("HTTP_HOST") = "www.bbq.co.kr" then
	ga_id = "UA-39768002-1"
end if

if len(ga_id) > 0 then
%>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=<%=ga_id%>"></script>
<script>
	window.dataLayer = window.dataLayer || [];
	function gtag(){dataLayer.push(arguments);}
	gtag('js', new Date());

	gtag('config', '<%=ga_id%>');

	<% if ga_script = "orderComplete" then %>

		gtag('event', 'purchase', {
			"transaction_id": "<%=order_idx%>",
			"affiliation": "bbq",
			"value": <%=pay_amt%>,
			"currency": "KRW",
			"tax": 0,
			"shipping": 0,
			"items": [<%=ga_str%>]
		});

//		ga('require', 'ecommerce', 'ecommerce.js');
//
//		ga('ecommerce:addTransaction', { 
//			'id': '<%=order_idx%>', // 시스템에서 생성된 주문번호. 필수. 
//			'revenue': '<%=pay_amt%>', // 구매총액. 필수. 배송비 및 세금 기타 모든 비용 포함
//			'affiliation': '', // 제휴사이름. 선택사항. 쿠폰이름 같은거 넣어도 된다.
//			'shipping': '<%=delivery_fee%>', // 배송비. 선택사항. 
//			'tax': '' // 세금. 선택사항.
//		});
//
//		ga('ecommerce:addItem', <%=ga_str%>);
//
//		ga('ecommerce:send');
	<% end if %>
</script>
<%
end if
%>