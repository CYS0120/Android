<%
	returncode = request("returncode")
	returnmsg = request("returnmsg")
%>
<meta charset="utf-8">
<script>
	alert('<%=returnmsg%>');

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