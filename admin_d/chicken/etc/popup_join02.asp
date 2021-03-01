<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="회원가입 팝업, BBQ치킨">
<meta name="Description" content="회원가입 팝업">
<title>회원가입 팝업 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {});
</script>
</head>

<body>
	<div class="winpop-wrap winpop-join join-step02">
		<div class="winpop-header">
			<div class="logo"><img src="/images/common/logo_header_bbq.png" alt="BBQ"></div>
		</div>
		<div class="winpop-content">
			<div class="step-wrap">
				<ol>
					<li>
						<em>01</em><span>약관동의 및<br>본인인증</span>
					</li>
					<li class="current">
						<em>02</em><span>회원정보 입력</span>
					</li>
					<li>
						<em>03</em><span>가입완료</span>
					</li>
				</ol>
			</div>
			<div class="info-box mar-t20">
				<dl>
					<dt>이름 및 성별</dt>
					<dd>박아람</dd>
				</dl>
				<dl class="mar-t20">
					<dt>생년월일</dt>
					<dd>1980.10.10(양력)</dd>
				</dl>
			</div>
			<div class="info-input">
				<div class="input-required">
					<input type="text" value="" class="w-100p" placeholder="아이디 (영문, 숫자 조합 6~16자리)">
					<input type="password" value="" class="w-100p" placeholder="비밀번호 (영문,숫자,특수문자 조합 8~20자리)">
					<input type="password" value="" class="w-100p" placeholder="비밀번호 재입력">
					<input type="text" value="010-2265-7070" class="w-100p" readonly="true">
					<input type="text" value="" class="w-100p" placeholder="이메일 주소">
				</div>
				<div class="input-select">
					<h4>선택 입력</h4>
					<input type="text" value="" placeholder="주소찾기 선택" readonly="true">
					<button type="button" class="btn btn-md4 btn-black">주소찾기</button>
				</div>
			</div>
		</div>
		<div class="winpop-footer mar-t20">
			<div class="btn-wrap">
				<button type="button" class="btn btn-lg w-100p btn-red"><span>가입</span></button>
			</div>
		</div>
	</div>
</body>
</html>
