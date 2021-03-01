<%
  Response.AddHeader "pragma","no-cache"
	'/********************************************************************************
	' *
	' * 다날 본인인증
	' *
	' * - 인증 완료 페이지
	' *
	' * 시스템 연동에 대한 문의사항이 있으시면 서비스개발팀으로 연락 주십시오.
	' * DANAL Commerce Division Technique supporting Team
	' * EMail : tech@danal.co.kr
	' *
	' ********************************************************************************/

    '/********************************************************************************
	' *
	' * XSS 취약점 방지를 위해 
	' * 모든 페이지에서 파라미터 값에 대해 검증하는 로직을 추가할 것을 권고 드립니다.
	' * XSS 취약점이 존재할 경우 웹페이지를 열람하는 접속자의 권한으로 부적절한 스크립트가 수행될 수 있습니다.
	' * 보안 대책
	' *  - html tag를 허용하지 않아야 합니다.(html 태그 허용시 white list를 선정하여 해당 태그만 허용)
	' *  - <, >, &, " 등의 문자를 replace등의 문자 변환함수를 사용하여 치환해야 합니다.
	' * 
	' ********************************************************************************/
%>
<!--#include file="inc/function.asp"-->
<%
  Dim BgColor

	BgColor = Request.Form("BgColor")

  '/*
  ' * Get BgColor
  ' */
  BgColor = GetBgColor( BgColor )
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<title>다날 본인확인</title>
	<meta http-equiv="Content-Language"	content="ko" />
	<meta http-equiv="Content-Type"	content="text/html;	charset=euc-kr"	/>
	<link href="./css/style.css"	rel="stylesheet" type="text/css" />
	<script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
	<script language="JavaScript" src="./js/Common.js" type="text/javascript"></script>
</head>
<body onload="changeFontSize();">
	<div class="Wrap">
    <!--HEADER START-->
        <div class="header01">
			<ul>
				<li><h1>다날 본인확인 서비스</h1></li>
				<li class="ci_danal">다날로고</li>
			</ul>
        </div>
    <div class="step bg_<%=BgColor%>">
        <ul>
		<li><b>인증 성공</b></li>
        </ul>
    </div>
    <div class="header02">
        <div class="wrap_txtsize">
            <button class="btn_minus" onClick="return false;">-</button>
            <p class="txtsize">글씨크기</p>
            <button class="btn_plus" onClick="return false;">+</button>
        </div>
    </div>
    <!--//HEADER END-->
    <!--CONTENT START-->
    <div class="content">
        <div class="wrap_content"> <!--레이어팝업이 있을 경우 style="display: none;"-->
            <div class="box_style03">
				<p>본인인증이 정상 처리되었습니다.</p>
            </div>
            <ul class="notice">
                <li class="bullet">다날 고객센터 : 1566-3355 (평일 9시 ~ 19시 통화가능 / 토,일,공휴일 휴무)</li>
            </ul>
        </div>
        <div class="btnfucntion">
            <label for="okay" ><input id="okay" class="bg_<%=BgColor%>" type="button" value="확인" /></label>
        </div>
        <ul class="certification">
            <li class="wau">웹접근성 인증마크</li>
        </ul>
    </div>
    <!--//CONTENT END-->
    <!--BOARD START-->
    <div class="board">
	<ul>
		<li class="field">공지사항</li>
		<li class="value">다날 본인인증을 이용해주셔서 감사합니다. (문의 1566-3355)</li>
	</ul>
    </div>
    <!--//BOARD END-->
</div>

</body>
</html>
