<%
ABLE_IP = ""
ABLE_IP = ABLE_IP & "|" & "110.45.246.66" ' 본사
ABLE_IP = ABLE_IP & "|" & "14.32.207.253" ' 본사
ABLE_IP = ABLE_IP & "|" & "211.200.4.162" ' CNTT(공릉)
ABLE_IP = ABLE_IP & "|" & "211.219.135.61" ' CNTT
ABLE_IP = ABLE_IP & "|" & "211.219.135.105" ' CNTT(VPN)
ABLE_IP = ABLE_IP & "|" & "106.242.28.227" ' 치킨대학
ABLE_IP = ABLE_IP & "|" & "175.113.229.5" ' 퓨즈와이어
ABLE_IP = ABLE_IP & "|" & "112.161.203.167" ' 퓨즈와이어
ABLE_IP = ABLE_IP & "|" & "211.41.60.27" ' 지투아이넷
ABLE_IP = ABLE_IP & "|" & "202.68.232.81" ' 지투아이넷_개발

IF LEFT(DATE(), 10) < "2020-10-01" THEN 
    ABLE_IP = ABLE_IP & "|" & "211.107.218.132" ' -3팀(대전 충남)
    ABLE_IP = ABLE_IP & "|" & "121.181.199.177" ' -4팀(대구 경북) 
    ABLE_IP = ABLE_IP & "|" & "119.198.104.45"  '  -5팀(부산 경남) 
end if

CHECK_IP = GetIPADDR()
If InStr(ABLE_IP, "|" & CHECK_IP)> 0 Then 
Else
	Response.Redirect "https://www.bbq.co.kr"
End If 

mobrwz = "iPhone|iPod|BalckBerry|Android|Windows CE|LG|MOT|SAMSUNG|SonyEricsson|Mobile|Symbian|Opera Mobi|Opera Mini|IEmobile|Mobile|Igtelecom|PPC"
spmobrwz = Split(mobrwz, "|")
agent = Request.ServerVariables("HTTP_USER_AGENT")

For i = 0 To Ubound(spmobrwz)
	If InStr(agent, spmobrwz(i)) > 0 Then
		Response.Redirect("https://www.bbq.co.kr")
		Exit For
	End If
Next
%>

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<script src="<%=SITE_ADM_DIR%>js/jquery-1.10.2.min.js"></script>
<script src="<%=SITE_ADM_DIR%>js/jquery.flexslider.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="<%=SITE_ADM_DIR%>js/common.js"></script>

<link rel="stylesheet" href="<%=SITE_ADM_DIR%>css/jquery-ui.css">
<link rel="stylesheet" href="<%=SITE_ADM_DIR%>css/reset.css">
<link rel="stylesheet" href="<%=SITE_ADM_DIR%>css/common.css">
<link rel="stylesheet" href="<%=SITE_ADM_DIR%>css/layout.css">
<link rel="stylesheet" href="<%=SITE_ADM_DIR%>css/content.css">

<script>
$(function(){
	var duration = 300;

	var $side = $('.lnb,.s_btn_bg' );
	var $sidebt = $side.find('.s_btn').on('click', function(){
		$side.toggleClass('open');

		if($side.hasClass('open')) {
			$side.stop(true).animate({left:'0px'}, duration);
			$('.s_btn_bg').stop(true).animate({left:'218px'}, duration);
		}else{
			$side.stop(true).animate({left:'-218px'}, duration);
			$('.s_btn_bg').stop(true).animate({left:'0px'}, duration);
		};
	});
});
</script>