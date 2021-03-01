<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="고객센터, BBQ치킨">
<meta name="Description" content="고객센터">
<title>고객센터 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>고객센터</h1>
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
			<div class="tab-wrap tab-type2">
				<ul class="tab">
					<li><a href="./faqList.asp"><span>자주묻는질문</span></a></li>
					<li class="on"><a href="./inquiryList.asp"><span>고객의소리</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- 고객센터 상단 -->
			<section class="section section-Csinfo">
				<div class="inner">
					<p class="img ico-hear"><span class="ico-only">Q&amp;A</span></p>
					<div class="tit">
						언제나 고객님을 향해 열려 있습니다.<br/>
						사소한 질문이라도 정성껏 답변하여 드리겠습니다. 
					</div>
					<p class="txt">
						고객님께서 자주 문의하시거나 궁금해하는 질문들을 모아서 정리하였습니다. 찾으시는 내용이 없거나 궁금한 사항이 있으면 고객의 소리에 의견을 남겨주세요. 고객님의 새로운 행복을 위해서 언제나 최선을 다하는 BBQ가 되겠습니다.
					</p>
				</div>
			</section>
			<!-- //고객센터 상단 -->

			<!-- 1:1문의 -->
			<section class="section section_inq mar-t60">
				<div class="inner">
					<form action="">
						<ul class="inq">
							<li>
								<select name="" id="" class="w-100p">
									<option value="">BBQ치킨</option>
								</select>
							</li>
							<li>
								<select name="" id="" class="w-100p">
									<option value="">분류선택</option>
								</select>
							</li>
							<li><label data-txt="작성일" class="before-txt"><input type="text" value="2018-12-05" class="w-100p"></label></li>
							<li><input type="text" placeholder="글제목" class="w-100p"></li>
							<li><textarea name="" id="" placeholder="내용" style="height:230px;" class="w-100p"></textarea></li>
						</ul>
						<ul class="ui-file mar-t30">
							<li>
								<label for="">
									<span class="btn btn-sm btn-brown">첨부파일 선택</span>
									<input type="text" readonly placeholder="선택된 파일 없음">
									<input type="file" onchange="fileDes(this);" id="fileupload">
								</label>
							</li>
							<li>
								<label for="">
									<span class="btn btn-sm btn-brown">첨부파일 선택</span>
									<input type="text" readonly placeholder="선택된 파일 없음">
									<input type="file" onchange="fileDes(this);" id="fileupload">
								</label>
							</li>
						</ul>
						<div class="mar-t70">
							<button type="submit" class="btn btn-lg btn-red w-100p"><span>등록</span></button>
						</div>
					</form>
				</div>
			</section>
			<!-- //1:1문의 -->


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