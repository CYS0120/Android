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
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>회원정보변경</h1>
		<div class="btn-header btn-header-nav">
			<button type="button" onClick="javascript:history.back();" class="btn btn_header_back"><span class="ico-only">이전페이지</span></button>
			<button type="button" class="btn btn_header_menu"><span class="ico-only">메뉴</span></button>
		</div>
		<div class="btn-header btn-header-mnu">
			<button type="button" class="btn btn_header_cart"><span class="ico-only">장바구니</span></button>
			<button type="button" class="btn btn_header_brand"><span class="ico-only">패밀리브랜드</span></button>
		</div>
	</header>
	<!--// Header -->
	<hr>

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
		<hr>
			
		<!-- Content -->
		<article class="content">

			<!-- Tab -->
			<div class="tab-wrap tab-type1">
				<ul class="tab two-up">
					<li><a href="/mypage/memEdit.asp"><span class="ico-memEdit">개인정보변경</span></a></li>
					<li class="on"><a href="/mypage/shipping.asp"><span class="ico-shipping">배송지관리</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- 배달지추가 -->
			<section class="section section_shippingAdd">
				<button type="button" onClick="javascript:lpOpen('.lp_addShipping');"  class="btn btn-lg btn-black w-100p btn_lp_open">배달지 추가</button>
				<div class="txt">- 자주 사용하는 배송지를 등록 및 관리하실 수 있습니다.</div>
			</section>
			<!-- //배달지추가 -->

			<section class="section section_shipList">
				<div class="box">
					<div class="name">
						<span class="red">[기본배달지]</span> 박하나
					</div>
					<ul class="info">
						<li>010-1111-1111</li>
						<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
					</ul>
					<ul class="btn-wrap">
						<li class="btn-left">
						</li>
						<li class="btn-right">
							<button type="button" onClick="javascript:lpOpen('.lp_addShipping');" class="btn btn-sm btn-grayLine btn_lp_open">수정</button>
						</li>
					</ul>
				</div>
				<div class="box">
					<div class="name">
						<span class="red">[기본배달지]</span> 박하나
					</div>
					<ul class="info">
						<li>010-1111-1111</li>
						<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
					</ul>
					<ul class="btn-wrap">
						<li class="btn-left">
							<button type="button" class="btn btn-sm btn-brown">기본배달지 설정</button>
						</li>
						<li class="btn-right">
							<button type="button" onClick="javascript:lpOpen('.lp_addShipping');" class="btn btn-sm btn-grayLine btn_lp_open">수정</button>
							<button type="button" class="btn btn-sm btn-grayLine">삭제</button>
						</li>
					</ul>
				</div>
				<div class="box">
					<div class="name">
						<span class="red">[기본배달지]</span> 박하나
					</div>
					<ul class="info">
						<li>010-1111-1111</li>
						<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
					</ul>
					<ul class="btn-wrap">
						<li class="btn-left">
							<button type="button" class="btn btn-sm btn-brown">기본배달지 설정</button>
						</li>
						<li class="btn-right">
							<button type="button" onClick="javascript:lpOpen('.lp_addShipping');" class="btn btn-sm btn-grayLine btn_lp_open">수정</button>
							<button type="button" class="btn btn-sm btn-grayLine">삭제</button>
						</li>
					</ul>
				</div>
			</section>

			


			<!-- Layer Popup : 배달지 입력 -->
			<div id="LP_addShipping" class="lp-wrapper lp_addShipping">
				<!-- LP Header -->
				<div class="lp-header">
					<h2>배달지 입력</h2>
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<form action="">
							<div class="inner">
								<dl class="regForm">
									<dt>이름</dt>
									<dd>
										<input type="text" class="w-100p">
									</dd>
								</dl>
								<dl class="regForm">
									<dt>전화번호</dt>
									<dd>
										<span class="ui-group-tel">
											<span><input type="text"maxlength="20"></span>
											<span class="dash">-</span>
											<span><input type="text" maxlength="20"></span>
											<span class="dash">-</span>
											<span><input type="text" maxlength="20"></span>
										</span>
									</dd>
								</dl>
								<dl class="regForm">
									<dt><label for="sPost">주소</label></dt>
									<dd>
										<div class="ui-input-post">
											<input type="text" name="sPost" id="sPost" maxlength="7" readonly>
											<button type="button" class="btn btn-md btn-gray btn_post"><span>우편번호 검색</span></button>
										</div>
										<div class="mar-t10"><input type="text" name="sAddr1" id="sAddr1" maxlength="100" class="w-100p"></div>
										<div class="mar-t10"><input type="text" name="sAddr2" id="sAddr2" maxlength="100" class="w-100p"></div>
									</dd>
								</dl>
							</div>
							<div class="btn-wrap two-up inner mar-t80">
								<button type="submit" class="btn btn-lg btn-black"><span>확인</span></button>
								<button type="submit" class="btn btn-lg btn-grayLine"><span>취소</span></button>
							</div>
						</form>
					</div>
					<!--// LP Content -->
				</div>
				<!--// LP Container -->
				<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
			</div>
			<!--// Layer Popup -->


		</article>
		<!--// Content -->

		<!-- Back to Top -->
		<a href="#Top" class="btn btn_scrollTop">페이지 상단으로 이동</a>
		<!--// Back to Top -->
	</div>
	<!--// Container -->
	<hr>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>