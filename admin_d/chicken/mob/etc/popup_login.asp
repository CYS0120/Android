<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="로그인, BBQ치킨">
<meta name="Description" content="ㅍ로그인 메인">
<title>로그인 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<div class="winpop-wrap winpop-login">
		<div class="winpop-header">
			<div class="logo"><img src="/images/common/login_logo.png" alt="BBQ"></div>
			<p class="pop-tit">비비큐에 오신 것을 환영합니다.</p>
		</div>
		<div class="winpop-content">
			<div class="login-input">
				<input type="text" value="" placeholder="아이디" class="w-100p">
				<input type="password" value="" placeholder="비밀번호" class="w-100p mar-t15">
			</div>
			<div class="btn-wrap mar-t20">
				<button type="button" class="btn btn-lg w-100p btn-red"><span>LOGIN</span></button>
				<div class="login-save">
					<label class="ui-checkbox">
						<input type="checkbox">
						<span></span> 아이디 저장
					</label>
				</div>
			</div>
		</div>
		<div class="winpop-footer">
			<p class="tit-footer">세상에서 가장 건강하고 맛있는 치킨이 생각날 땐!<br>이제, 온라인으로 주문하세요!</p>
			<div class="login-etc">
				<dl class="find">
					<dt class="bul bul-dot">아이디 또는 비밀번호를<br>잊어버리셨나요?</dt>
					<dd><button type="button" class="btn btn-etc btn-grayLine">아이디/비밀번호 찾기</button></dd>
				</dl>
				<dl class="join">
					<dt class="bul bul-dot">아직 회원이 아니신가요?<em>회원가입을 하시면 더 많은<br>혜택을 받으실 수 있습니다.</em></dt>
					<dd><button type="button" class="btn btn-etc btn-grayLine">회원가입 바로가기</button></dd>
				</dl>
			</div>
		</div>
	</div>
</div>
</body>
</html>
