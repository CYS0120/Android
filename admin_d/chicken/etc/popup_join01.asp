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
	$(document).ready(function() {
		/*Handler For SelectAll Checkbox*/
		$("#sAllagree").change(function(){
			$('.agree').prop("checked",$(this).prop("checked"));
		});

		/*Handler For rest of the checkbox*/
		$('.agree').change(function(){
			if( $('.agree').length==$('.agree:checked').length)
			{
				$("#sAllagree").prop("checked",true);
			} else{
				$("#sAllagree").prop("checked",false);
			}
		});
	});
</script>
</head>

<body>
	<div class="winpop-wrap winpop-join">
		<div class="winpop-header">
			<div class="logo"><img src="/images/common/logo_header_bbq.png" alt="BBQ"></div>
		</div>
		<div class="winpop-content">
			<div class="step-wrap">
				<ol>
					<li class="current">
						<em>01</em><span>약관동의 및<br>본인인증</span>
					</li>
					<li>
						<em>02</em><span>회원정보 입력</span>
					</li>
					<li>
						<em>03</em><span>가입완료</span>
					</li>
				</ol>
			</div>
			<div class="agree-wrap">
				<label class="ui-checkbox type2 all-chk">
					<input type="checkbox" name="sAllagree" id="sAllagree" value="">
					<span></span>
					아래 내용에 모두 동의합니다.
				</label>
				<div class="agree-box">
					<p>
						<label class="ui-checkbox type2">
							<input type="checkbox" class="agree">
							<span></span> BBQ 이용약관
						</label>
						<a href="#" onclick="javascript:return false;">전문 보기</a>
					</p>
					<p>
						<label class="ui-checkbox type2">
							<input type="checkbox" class="agree">
							<span></span> 개인정보 수집과 이용
						</label>
						<a href="#" onclick="javascript:return false;">전문 보기</a>
					</p>
					<p>
						<label class="ui-checkbox type2">
							<input type="checkbox" class="agree">
							<span></span> 만 14세 이상입니다.
						</label>
					</p>
					<p>
						<label class="ui-checkbox type2">
							<input type="checkbox" class="agree">
							<span></span> 홍보성 정보 수신 동의 (선택)
						</label>
					</p>
				</div>
				<p class="auth-explain">회원가입 및 본인확인을 위한<br>인증절차를 진행해 주세요.</p>
			</div>
		</div>
		<div class="winpop-footer mar-t20">
			<div class="btn-wrap">
				<button type="button" class="btn btn-lg w-100p btn-red"><span>휴대폰 인증</span></button>
			</div>
		</div>
	</div>
</body>
</html>
