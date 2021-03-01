<%
	Response.AddHeader "pragma","no-cache"

	Dim btn_error
	
	btn_error = "취 소"
	
	IF AbleBack Then
		btn_error = "인증 재시도"
	End IF
	
	'/*
	' * Get BgColor
	' */
	BgColor = GetBgColor( BgColor )
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="Content-Language" content="ko" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
<link href="./css/style.css" rel="stylesheet" type="text/css" />
</head> 
<body>  

<div class="wrap color<%=BgColor%>"> <!--각COLOR class="color00" ~ class="color10"-->
    <ul class="header">
        <li class="title">휴대폰 본인확인서비스</li>
        <li class="btn_close" style="display:none">close</li>
    </ul>
    <ul class="box_style03">
        <li>에러 내용(<%=RETURNCODE%>)</li>
        <li><%=RETURNMSG%></li>
		<li><br></li>
		<li><p class="customer">상담원 통화가능시간 : <br />
		평일 : 9시 ~ 18시<br />
		<span>토요일, 일요일, 공휴일 휴무</span></p></li>
    </ul>
    <div class="function">
		<div class="table">
            <span class="row">
				<span class="cell">
					<a href="<%=BackURL%>"><button class="color01">취소</button></a>
                </span>
            </span>
        </div>
    </div>
    <p class="customercenter">다날고객센터: 1566-3355</p>
</div>

</body>
</html>
