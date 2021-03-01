<!-- #include virtual="/inc/config.asp" -->
<%
	'첨부파일 리턴
	FILENM	= InjRequest("FILENM")
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script>
	parent.SetFileName('<%=FILENM%>')
</script>
</head>
<body>
</body>
</html>