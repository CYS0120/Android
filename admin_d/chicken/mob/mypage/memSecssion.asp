<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="회원정보변경, BBQ치킨">
<meta name="Description" content="회원정보변경">
<title>회원정보변경 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<!-- Layer Popup : Member Secssion -->
<div id="LP_MemSecssion" class="lp-wrapper lp_memSecssion" style="display:block">
	<!-- LP Header -->
	<div class="lp-header">
		<h2>회원탈퇴</h2>
	</div>
	<!--// LP Header -->
	<!-- LP Container -->
	<div class="lp-container">
		<!-- LP Content -->
		<div class="lp-content">
			<section class="section inner mar-b70">
				<div class="headLine">
					<div class="headLine-img">
						<img src="/images/mypage/logo_genesisBBQ.png" alt="Genesis BBQ">
					</div>
					<p class="headLine-txt">
						제네시스BBQ그룹 통합 멤버십을<br>
						이용해 주셔서 감사합니다.
					</p>
				</div>
				<ul class="ul-guide ul-guide-type2">
					<li>웹사이트 약관 동의 및 개인정보 제공, 활용 동의가 철회됩니다.</li>
					<li>탈퇴후 재가입 시 사용하셨던 아이디는 다시 사용하실 수 없습니다.</li>
					<li class="red">재가입은 회원탈퇴 후 30일이 지난 훙만 가능합니다.</li>
				</ul>
			</section>
			<section class="section">
				<div class="section-header">
					<h3>탈퇴사유</h3>
				</div>
				<div class="section-body">
					<form name="secssionFrm" id="secssionFrm" method="post" onSubmit="javascript:return false;">								
					<div class="box-gray">
						<ul class="ui-group-list two-up">
							<li>
								<label class="ui-radio">
									<input type="radio" name="sSecssionType" id="sSecssionType1" value="1">
									<span></span> 배달불만
								</label>
							</li>
							<li>	
								<label class="ui-radio">
									<input type="radio" name="sSecssionType" id="sSecssionType2" value="2">
									<span></span> 자주 이용하지 않음
								</label>
							</li>
							<li>	
								<label class="ui-radio">
									<input type="radio" name="sSecssionType" id="sSecssionType3" value="3">
									<span></span> 상품의 다양성/가격불만
								</label>
							</li>
							<li>	
								<label class="ui-radio">
									<input type="radio" name="sSecssionType" id="sSecssionType4" value="4">
									<span></span> 개인정보 유출우려
								</label>
							</li>
							<li>	
								<label class="ui-radio">
									<input type="radio" name="sSecssionType" id="sSecssionType5" value="5">
									<span></span> 질적인 혜택부족
								</label>
							</li>
							<li>	
								<label class="ui-radio">
									<input type="radio" name="sSecssionType" id="sSecssionType6" value="6">
									<span></span> 기타
								</label>
							</li>
						</ul>
						<textarea name="sSecssionMsg" id="sSecssionMsg" rows="5" placeholder="기타 의견을 남겨주세요." class="w-100p"></textarea>
					</div>
					<div class="btn-wrap two-up inner mar-t70">
						<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
						<button type="button" onClick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
					</div>
					</form>
				</div>
			</section>
		</div>
		<!--// LP Content -->
	</div>
	<!--// LP Container -->
	<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
</div>
<!--// Layer Popup -->
</body>
</html>
