<!-- #include virtual="/inc/config.asp" -->
<%
	'이미지파일 리턴
	IMGNM	= InjRequest("IMGNM")
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script>
	parent.SetImgName('<%=IMGNM%>')
</script>
</head>
<body>
</body>
</html>