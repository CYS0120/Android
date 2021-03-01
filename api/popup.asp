<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Session.CodePage = "65001"
    Response.CharSet = "UTF-8"
    Response.AddHeader "Pragma", "no-cache"
    Response.CacheControl = "no-cache"
    ' Response.CharSet = "euc-kr"
%>
<!--#include virtual="/api/include/cv.asp"-->
<!--#include virtual="/includes/cv.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%
	PIDX	= InjRequest("PIDX")
	If PIDX = "" Then
		Response.Write "<script>alert('팝업이 존재하지 않습니다');self.close();</script>"
		Response.End 
	Else 
		Sql = "Select * From BT_POPUP Where popup_idx = " & PIDX
		Set Pinfo = dbconn.Execute(Sql)
		If Pinfo.Eof Then
			Response.Write "<script>alert('팝업이 존재하지 않습니다');self.close();</script>"
			Response.End 
		Else
			popup_title	= Pinfo("popup_title")
			popup_width	= Pinfo("popup_width")
			popup_img	= Pinfo("popup_img")
			popup_close	= Pinfo("popup_close")
			popup_img = FILE_SERVERURL & "/uploads/popup/" & popup_img
		End If
	End If
%>
<html>
<head>
<title><%=popup_title%></title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<Script Language="JavaScript">
	function setCookie(name, value, expiredays)
	{
		var todayDate = new Date();
		todayDate.setDate(todayDate.getDate() + expiredays);
	
	    document.cookie="popup_<%=PIDX%>=done; path=/; expires=" + todayDate.toGMTString() + ";"
	}
	function closeWin()
	{
		if(document.form1.chk_close.checked) 
		{
			setCookie("popup_<%=PIDX%>", "done", 1);
		}
		self.close();
	}
</Script>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="area" style="width:<%=popup_width%>px;">
	<img src="<%=popup_img%>" alt="POPUP">
</div>
<table width="<%=popup_width%>" border="0" cellpadding="0" cellspacing="0">
	<form name="form1" method="post" action="">
	<tr>
		<td colspan="3" height="20">
			<p align="right">
			<input type=CHECKBOX name=chk_close>
			<span style="font-size:9pt"><font face="돋움" color="#505050">하루동안 열지 않음</font><font face="돋움" color="black"></font></span>
			<a href="javascript:window.closeWin()" style="font-family:돋움; font-size:9pt;">[닫기]</a>
		</td>
	</tr>
	</form>
</table>
</body>
</html>