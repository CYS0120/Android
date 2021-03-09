<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="회원정보변경, BBQ치킨">
<meta name="Description" content="회원정보변경">
<title>회원정보변경 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {
	$(document).on('click','.phone-change-on',function(){
		var par = $(this).closest('.phone-change-wrap');
		par.addClass('on');
	});
	$(document).on('click','.phone-change-off',function(){
		var par = $(this).closest('.phone-change-wrap');
		par.removeClass('on');
	});
});
</script>
</head>

<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li><a href="#" onclick="javascript:return false;">bbq home</a></li>
				<li><a href="#" onclick="javascript:return false;">마이페이지</a></li>
				<li>회원정보 변경</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<!-- Membership -->
			<section class="section section_membership">
				<!-- My Info -->
				<div class="myInfo-wrap">
					<div class="myInfo-membership">
						<div class="myInfo-memGrade silver">
							<p class="memGrade"><strong>박아람</strong>님 안녕하세요!</p>
							<p class="memTxt">세상에서 가장 건강하고 맛잇는 치킨 bbq 입니다.</p>
							<div class="btn-wrap">
								<button type="button" class="btn btn-sm2 btn-grayLine"><span>개인정보 변경</span></button>
								<button type="button" class="btn btn-sm2 btn-black mar-l10"><span>치킨캠프 신청내역</span></button>
							</div>
						</div>
						<!-- <div class="myInfo-inquiry">
							<dl class="itemInfo">
								<dt>1:1 문의내역</dt>
								<dd><span>1</span>건</dd>
							</dl>
							<dl class="itemInfo">
								<dt>상품문의내역</dt>
								<dd><span>1</span>건</dd>
							</dl>
						</div> -->
					</div>
					<div class="myInfo-shopping">
						<dl class="itemInfo itemInfo-point" onclick="location.href='/mypage/mileage.asp'">
							<dt>포인트</dt>
							<dd>
								<div class="count"><span>17,380</span>P</div>
							</dd>
						</dl>
						<dl class="itemInfo itemInfo-coupon" onclick="location.href='/mypage/couponList.asp'">
							<dt>쿠폰</dt>
							<dd>
								<div class="count"><span>1</span>장</div>
								<!-- <a href="#" class="link-go">쿠폰 등록하기</a> -->
							</dd>
						</dl>
						<dl class="itemInfo itemInfo-card" onclick="location.href='/mypage/cardList.asp'">
							<dt>카드</dt>
							<dd>
								<div class="count"><span>2</span>장</div>
							</dd>
						</dl>
					</div>
				</div>
				<!--// My Info -->
				<!-- My Menu -->
				<div class="myMenu-wrap on">
					<ul class="myMenu">
						<li><a href="/mypage/orderList.asp">주문내역</a></li>
						<li><a href="/mypage/couponList.asp">쿠폰</a></li>
						<li><a href="/mypage/mileage.asp">포인트</a></li>
						<li><a href="/mypage/cardList2.asp">카드</a></li>
						<li><a href="/mypage/inquiryList.asp">문의내역</a></li>
						<li><a href="/mypage/membership.asp"><span class="ddack">딹</span> 멤버십 안내</a>							
						</li>
					</ul>
				</div>
				<!--// My Menu -->
			</section>
			<!--// Membership -->

			<!-- My Member Modify -->
			<section class="section section_member">
				<div class="section-header">
					<h3>회원정보변경</h3>
				</div>
				<div class="section-body top-line">
					<form name="memForm" id="memForm" method="post" onsubmit="return false;">
						<div class="section-item">
							<h4>기본정보</h4>
							<div class="boardList-wrap">
								<table border="1" cellspacing="0" class="tbl-member">
									<caption>기본정보</caption>
									<colgroup>
										<col style="width:283px;">
										<col style="width:auto;">
									</colgroup>
									<tbody>
										<tr class="bg-gray">
											<th>이름</th>
											<td>박아람</td>
										</tr>
										<tr class="bg-gray">
											<th>생년월일</th>
											<td>1980.10.10 (양력)</td>
										</tr>
										<tr class="bg-gray line">
											<th>아이디</th>
											<td>hana12345678963</td>
										</tr>
										<tr>
											<th><label for="sPwd1">비밀번호</label></th>
											<td><input type="password" name="sPwd1" id="sPwd1" maxlength="20" placeholder="영문, 숫자, 특수문자를 조합하여 10자 이상 가능" class="w-40p"></td>
										</tr>
										<tr>
											<th><label for="sPwd2">비밀번호 확인</label></th>
											<td><input type="password" name="sPwd2" id="sPwd2" maxlength="20" placeholder="비밀번호 재입력" class="w-40p"><span class="txt-red">비밀번호가 일치하지 않습니다.</span></td>
										</tr>
										<tr>
											<th><label for="sPwd1">휴대폰번호</label></th>
											<td>
												<div class="phone-change-wrap">
													<div class="phone-change-top">
														<span class="va-m">010-8652-5620</span>
														<button type="button" class="btn btn-sm btn-brownLine mar-l15 phone-change-on"><span>변경</span></button>
													</div>
													
													<ul class="phone-change-bot">
														<li>
															<span class="display-ib w-120">- 새 휴대폰 번호</span>
															<span class="display-ib">
																<div class="ui-group-email w-350">
																	<span><input type="text"></span>
																	<span class="dash w-20">-</span>
																	<span><input type="text"></span>
																	<span class="dash w-20">-</span>
																	<span class="pad-l0"><input type="text"></span>
																</div>
															</span>
															<button type="button" class="btn btn-md3 btn-red">인증번호 전송</button>
														</li>
														<li class="mar-t20">
															<span class="display-ib w-120">- 인증번호 입력</span>
															<span class="display-ib">
																<div class="ui-group-email w-350">
																	<span><input type="text"></span>
																	<span class="dash w-20">-</span>
																	<span><input type="text"></span>
																	<span class="dash w-20">-</span>
																	<span class="pad-l0"><input type="text"></span>
																</div>
															</span>
															<button type="button" class="btn btn-md3 btn-black">확인</button>
															<button type="button" class="btn btn-md3 btn-grayLine  phone-change-off">취소</button>
														</li>
													</ul>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="sEmail1">이메일 주소</label></th>
											<td>
												<span class="ui-group-email">
													<span><input type="text" name="sEmail1" id="sEmail1" maxlength="20"></span>
													<span class="dash">@</span>
													<span><input type="text" name="sEmail2" id="sEmail2" maxlength="20"></span>
													<span>
														<select name="sEmailSel" id="sEmailSel" onchange="javascript:setEmail(this,'#sEmail2');">
															<option value="" selected="">직접입력</option>
															<option value="naver.com">네이버</option>
															<option value="daum.net">다음</option>
															<option value="nate.com">네이트</option>
														</select>
													</span>											
												</span>
											</td>
										</tr>
										<tr class="last">
											<th>정보수신동의</th>
											<td>
												<div class="ui-group-checkbox three-up">
													<label class="ui-checkbox">
														<input type="checkbox" name="sAgree" id="sAgree1" value="A">
														<span></span> 전체동의
													</label>
													<label class="ui-checkbox">
														<input type="checkbox" name="sAgree" id="sAgree2" value="E">
														<span></span> 이메일 수신동의
													</label>
													<label class="ui-checkbox">
														<input type="checkbox" name="sAgree" id="sAgree3" value="M">
														<span></span> SMS 수신동의
													</label>									
												</div>
												<ul class="ul-guide mar-t20">
													<li>수신동의를 하시면 상품정보, 할인혜택, 이벤트 등 다양한 혜택 및 소식 안내를 받을 수 있습니다.</li>
													<li>회원가입, 주문배달 관련 등의 정보는 수신동의 여부와 상관없이 자동으로 발송됩니다.</li>
												</ul>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="section-item">
							<h4 class="mar-t60">주소지 관리</h4>
							<div class="boardList-wrap">
								<table border="1" cellspacing="0" class="tbl-list">
									<caption>상품문의</caption>
									<colgroup>
										<col style="width:120px;">
										<col style="width:120px;">
										<col style="width:180px;">
										<col>
										<col style="width:180px;">
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>수령인</th>
											<th>전화번호</th>
											<th>주소</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><strong class="red">기본주소지</strong></td>
											<td>박하림</td>
											<td>010-1234-1234</td>
											<td class="ta-l">
												(15230)<br/>
												서울시 마포구 토정로12길 569-1
											</td>
											<td><a href="#" onclick="javascript:return false;" class="btn btn-sm btn-grayLine">수정</a></td>
										</tr>
										<tr>
											<td>
												<label class="ui-radio">
													<input type="radio">
													<span></span>
												</label>

											</td>
											<td>박하림</td>
											<td>010-1234-1234</td>
											<td class="ta-l">
												(15230)<br/>
												서울시 마포구 토정로12길 569-1
											</td>
											<td>
												<a href="#" onclick="javascript:return false;" class="btn btn-sm btn-grayLine">수정</a>
												<a href="#" onclick="javascript:return false;" class="btn btn-sm btn-grayLine">삭제</a>
											</td>
										</tr>
									</tbody>
								</table>

								<div class="bot-area">
									<div class="left">
										<button class="btn btn-sm btn-grayLine">기본주소지 설정</button>
									</div>
									<div class="right">
										<button type="button" class="btn btn-md3 btn-red" onclick="javascript:lpOpen('.lp_address');">주소지 추가</button>
									</div>
								</div>
							</div>
						</div>

						<div class="btn-wrap two-up inner mar-t60 line">
							<button type="submit" class="btn btn-lg btn-black"><span>확인</span></button>
							<button type="submit" class="btn btn-lg btn-grayLine"><span>취소</span></button>
						</div>

					</form>

			
					<button type="button" onclick="javascript:lpOpen('.lp_memSecssion');" class="btn btn_lp_open btn_memSecssion mar-t60">
						<span class="ico-arrowRight">제너시스BBQ그룹 통합 멤버십 회원탈퇴
							<small>불편사항이 있으셨나요? 고객센터(080-3436-0507)로 연락주시면 서비스개선을 위해 최선을 다하겠습니다.</small>
						</span>
					</button>
				</div>
			</section>
			<!--// My Member Modify -->
								
			<!-- Layer Popup : 주소지 추가 -->
			<div id="LP_Address" class="lp-wrapper lp_address">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>주소지 입력</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">
								<section class="section">
									<form action="">
										<table border="1" cellspacing="0" class="tbl-member black-line">
											<caption>추가정보</caption>
											<colgroup>
												<col style="width:170px;">
												<col style="width:auto;">
											</colgroup>
											<tbody>
												<tr>
													<th>이름</th>
													<td>
														<input type="text" class="w-150">
													</td>
												</tr>
												<tr>
													<th>전화번호</th>
													<td>
														<div class="ui-group-email">
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span><input type="text"></span>
															<span class="dash w-20">-</span>
															<span class="pad-l0"><input type="text"></span>
														</div>
													</td>
												</tr>
												<tr>
													<th>주소</th>
													<td>
														<div class="ui-input-post">
															<input type="text" name="sPost" id="sPost" maxlength="7" readonly="">
															<button type="button" class="btn btn-md2 btn-gray btn_post"><span>우편번호 검색</span></button>
														</div>
														<div class="mar-t10">
															<input type="text" class="w-100p">
														</div>
														<div class="mar-t10">
															<input type="text" class="w-100p">
														</div>
													</td>
												</tr>
											</tbody>
										</table>

										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
											<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
										</div>
									</form>
								</section>
							</div>
							<!--// LP Content -->
						</div>
						<!--// LP Container -->
						<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
					</div>
				</div>
				<!--// LP Wrap -->
			</div>
			<!--// Layer Popup -->

			<!-- Layer Popup : Member Secssion -->
			<div id="LP_MemSecssion" class="lp-wrapper lp_memSecssion">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>회원탈퇴</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">
								<section class="section mar-b50 ta-c">
									<div class="headLine">
										<div class="headLine-img">
											<img src="/images/mypage/logo_genesisBBQ.png" alt="Genesis BBQ">
										</div>
										<p class="headLine-txt">
											제네시스BBQ그룹 통합 멤버십을 이용해 주셔서 감사합니다.
										</p>
									</div>
									<div class="ta-c">
										<ul class="ul-guide ul-guide-type2 display-ib ta-l">
											<li>- 웹사이트 약관 동의 및 개인정보 제공, 활용 동의가 철회됩니다.</li>
											<li>- 탈퇴후 재가입 시 사용하셨던 아이디는 다시 사용하실 수 있습니다.</li>
											<li class="red">- 재가입은 회원탈퇴 후 30일이 지난 후에만 가능합니다.</li>
										</ul>
									</div>
								</section>
								<section class="section">
									<div class="section-header bg-gray">
										<h3>탈퇴사유</h3>
									</div>
									<div class="section-body">
										<form name="secssionFrm" id="secssionFrm" method="post" onsubmit="javascript:return false;">
										<div class="box-gray">
											<ul class="ui-group-list three-up">
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
											<textarea name="sSecssionMsg" id="sSecssionMsg" rows="3" placeholder="기타 의견을 남겨주세요." class="w-100p"></textarea>
										</div>
										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
											<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
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
				</div>
				<!--// LP Wrap -->
			</div>
			<!--// Layer Popup -->
			
		</article>
		<!--// Content -->	
		
		<!-- QuickMenu -->
		<!--#include virtual="/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
