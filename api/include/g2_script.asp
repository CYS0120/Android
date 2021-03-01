<script type="text/javascript">
	var g2_bbq_a_url = "<%=g2_bbq_a_url%>";
	var g2_bbq_d_url = "<%=g2_bbq_d_url%>";
	var g2_bbq_m_url = "<%=g2_bbq_m_url%>";

	var g2_bbq_img_url = "<%=SERVER_IMGPATH%>";

	<% If Request.ServerVariables("HTTPS") = "on" then %>
		var juso_api_url = 'https://www.juso.go.kr/addrlink/addrLinkApiJsonp.do';
		var juso_api_xy_url = 'https://www.juso.go.kr/addrlink/addrCoordApiJsonp.do';
	<% else %>
		var juso_api_url = 'http://www.juso.go.kr/addrlink/addrLinkApiJsonp.do';
		var juso_api_xy_url = 'http://www.juso.go.kr/addrlink/addrCoordApiJsonp.do';
	<% End If %>
</script>