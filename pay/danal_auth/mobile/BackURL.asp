<%
	Response.AddHeader "pragma","no-cache" 
%>
<html>
<head>
<title>�ٳ� ��������</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<%        
	Dim nextURL 
	
	'/*
	' * Ư�� URL ����
	' */
	'nextURL = "http://www.danal.co.kr"
 
	'/*
	' * â �ݱ� Script
	' * - Javascript:self.close(); ���ÿ��� �ٳ� ��������â�� �˾����� ����ֽñ� �ٶ��ϴ�.
	' */
	'nextURL = "Javascript:self.close();";

	'/*
	' * ���� �ݱ� Script
	' * - �׽�Ʈ �� �ҽ� ����
	' */
	nextURL = "Javascript:window.TeleditApp.BestClose();"
%>
<form name="BackURL" action="<%=nextURL%>" method="post">
</form>
<script Language="Javascript">
        document.BackURL.submit();
</script>
</body>
</html>