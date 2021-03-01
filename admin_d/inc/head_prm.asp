<%

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