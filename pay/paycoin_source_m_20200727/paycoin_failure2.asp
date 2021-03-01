<%
	returncode = request("returncode")
	returnmsg = request("returnmsg")
%>
<meta charset="utf-8">
<script>
	alert('결제도중 오류가 발생되어 다시 처음부터 시도해 주시면 감사하겠습니다.');

	if(window.opener) {
		try {
			self.close();
		} catch (e) {
			location.href="/";
		}
	} else {
		location.href="/";
	}
</script>