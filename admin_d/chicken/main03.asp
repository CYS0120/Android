<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="메인, BBQ치킨">
<meta name="Description" content="메인">
<title>BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<link rel="stylesheet" href="/common/css/main.css">
<link rel="stylesheet" href="/common/css/animate.css">
<link rel="stylesheet" href="/common/css/mscrollbar.css">
<!--#include virtual="/includes/scripts.asp"-->
<script src="/common/js/libs/jquery.bxslider.js"></script>
<script src="/common/js/libs/mscrollbar.js"></script>
<script>
jQuery(document).ready(function(e) {
	
	// scroll header
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});

	// section_visual
	$('.main-bxslider').bxSlider({
		mode: 'horizontal',
		auto:false,
		slideMargin: 0,
		infiniteLoop: true,
		speed: 800,
		controls:false,
	});

	// tab click
	$(".tab-layer li").on('click', function(e){
		tab_sliderWrap();
	});
	tab_sliderWrap();

	// animate
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() >= 388){
			$(".bbq-menu .ico-cap").addClass("swing animated");
			$(".bbq-enjoy .ico-cover").addClass("swing animated");
			$(".bbq-enjoy .list li").addClass("fadeInUp animated");
		};
		if ($(window).scrollTop() >= 4000){
			$(".bestQuality-list li").addClass("fadeInUp animated");
		};
	});

	// num
	$(".num-wrap .minus").on('click', function(e){
		var num = $(this).next().val();
		console.log(num);
		if(num > 1){
			$(this).next().val(num*1-1);
			return false;
		};
	});
	$(".num-wrap .add").on('click', function(e){
		var num = $(this).prev().val();
		console.log(num);
		$(this).prev().val(num*1+1);
		return false;
	});

	// scrollbar
	$(".mCustomScrollbar").mCustomScrollbar({
		horizontalScroll:false,
		theme:"light",
		mouseWheelPixels:300,
		advanced:{
			updateOnContentResize: true
		}
	}); 	
	
});

// tab-slider(bbq menu)
function tab_sliderWrap (){
	var tab_slider = $('.tab-content:visible .tab-slider').bxSlider({
	mode: 'fade', // horizontal, vertical, fade
	auto:false,
	slideMargin: 0,
	infiniteLoop: false,
	speed: 800,
	controls:false,
	touchEnabled:false,
	onSliderLoad: function(currentIndex) {
		$('.tab-content:visible .tab-slider > li').find('.img-wrap img').removeClass('jackInTheBox animated');
		$('.tab-content:visible .tab-slider > li').eq(currentIndex).find('.img-wrap img').addClass('jackInTheBox animated delay-1s');
	},
	onSlideBefore: function ($slideElement, oldIndex, newIndex) {
		console.log(newIndex);
		$('.tab-content:visible .tab-slider > li').find('.img-wrap img').removeClass('jackInTheBox animated');
		$('.tab-content:visible .tab-slider > li').eq(newIndex).find('.img-wrap img').addClass('jackInTheBox animated delay-1s');
	},
	});
};
</script>
</head>

<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container main">
	
		<!-- Content -->
		<article class="content">
			<h1 class="blind">BBQ</h1>

			<!-- Main Visual -->
			<section class="section section_visual" data-688="top:0px;" data-1373="top:-688px;">
				<h2 class="blind">BBQ Visual</h2>
				<div class="section-body">	
					<ul class="main-bxslider">
						<li class="item item01">
							<div class="info-box">
								<p class="tit">추운데
어딜 나가요,
집에서 
비비큐 머거요.</p>
								<!--<ul class="hashTag">
									<li><span>#01</span></li>
									<li><span>#황금올리브오일치킨</span></li>
									<li><span>#자메이카통다리구이</span></li>
									<li><span>#슈퍼콘서트</span></li>
								</ul>-->
							</div>
						</li>
						<li class="item item02">
							<div class="info-box">
								<p class="tit">추운데
어딜 나가요,
집에서 
비비큐 머거요.</p>
								<!--<ul class="hashTag">
									<li><span>#02</span></li>
									<li><span>#황금올리브오일치킨</span></li>
									<li><span>#자메이카통다리구이</span></li>
									<li><span>#슈퍼콘서트</span></li>
								</ul>-->
							</div>
						</li>
						<li class="item item03">
							<div class="info-box">
								<p class="tit">추운데
어딜 나가요,
집에서 
비비큐 머거요.</p>
								<!--<ul class="hashTag">
									<li><span>#03</span></li>
									<li><span>#황금올리브오일치킨</span></li>
									<li><span>#자메이카통다리구이</span></li>
									<li><span>#슈퍼콘서트</span></li>
								</ul>-->
							</div>
						</li>
					</ul>
				</div>
			</section>
			<!--// Main Visual -->

			<!-- Main Info -->
			<section class="section section_info" data-0="top:688px;" data-688="top:0px;" data-1473="top:-785px;">
				<h2 class="blind">BBQ Info</h2>
				<div class="section-body">	
					<div class="inner">
						<div class="bbq-menu">
							<p class="txt01">가장 최근에 주문한 메뉴는</p>
							<p class="tit">자메이카 NEW 포테이토 세트</p>
							<p class="txt02">메뉴입니다.</p>
							<i class="ico ico-cap delay-09s"></i>
							<div class="info-box">
								<img src="/images/main/img_menu03.jpg" alt="자메이카 NEW 포테이토 세트">
								<div class="btn-wrap">
									<button type="button" class="btn btn-md btn-grayLine"><span>자세히보기</span></button>
									<button type="button" class="btn btn-md btn-red btn-line"><span>다시 주문하기</span></button>
								</div>
							</div>
						</div>
						<div class="bbq-enjoy">
							<i class="ico ico-cover delay-12s"></i>
							<p class="tit">BBQ 치킨을<br><strong>더 알차게 즐기는 방법</strong></p>
							<ul class="list">
								<li class="item01">
									<a href="#">
										<p>포인트</p>
										<i class="ico ico-point"></i>
										<span><em>17,380</em>P</span>
									</a>
								</li>
								<li class="item02 delay-03s">
									<a href="#">
										<p>쿠폰</p>
										<i class="ico ico-coupon"></i>
										<span><em>1</em>장</span>
									</a>
								</li>
								<li class="item03 delay-06s">
									<a href="#">
										<p>카드</p>
										<i class="ico ico-card"></i>
									</a>
								</li>
							</ul>
							<div class="btn-wrap">
								<button type="button" class="btn btn-md btn-grayLine w-100p"><span>멤버십 혜택 자세히 보기</span></button>
							</div>
						</div>
					</div>
				</div>
				<div class="ck1"><img src="/images/main/ck1.png" alt="ck1"></div>
				<div class="ck2"><img src="/images/main/ck2.png" alt="ck2"></div>
			</section>
			<!--// Main Info -->

			<!-- Main Menu -->
			<section class="section section_menu" data-0="top:1696px;" data-688="top:785px;" data-1473="top:0px;" data-2384="top:0px;" data-3335="top:-911px;">
				<div class="section-header">
					<h2>BBQ Menu</h2>
				</div>
				<div class="section-body">	
					<div class="tab-wrap tab-layer">
						<ul class="tab">
							<li class="on"><a href="#"><span>올리브 오리지널</span></a></li>
							<li><a href="#"><span>올리브 핫스페셜</span></a></li>
							<li><a href="#"><span>올리브 통살</span></a></li>
							<li><a href="#"><span>올리브 갈릭스</span></a></li>
							<li><a href="#"><span>구이</span></a></li>
							<li><a href="#"><span>세트메뉴</span></a></li>
						</ul>
					</div>
					<div class="tab-container tab-container-layer">
						<!-- tab-content 올리브 오리지널 -->
						<div class="tab-content on">
							<div class="tab-slider-wrap">
								<ul class="tab-slider">
									<li class="item">
										<div class="inner">
											<div class="img-wrap on"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">11 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">12 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
								</ul>
							</div>
						</div>
						<!--// tab-content -->
						<!-- tab-content 올리브 핫스페셜 -->
						<div class="tab-content">
							<div class="tab-slider-wrap">
								<ul class="tab-slider">
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">21 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">22 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
								</ul>
							</div>
						</div>
						<!--// tab-content -->
						<!-- tab-content 올리브 통살 -->
						<div class="tab-content">
							<div class="tab-slider-wrap">
								<ul class="tab-slider">
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">31 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">32 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
								</ul>
							</div>
						</div>
						<!--// tab-content -->
						<!-- tab-content 올리브 갈릭스 -->
						<div class="tab-content">
							<div class="tab-slider-wrap">
								<ul class="tab-slider">
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">41 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">42 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
								</ul>
							</div>
						</div>
						<!--// tab-content -->
						<!-- tab-content 구이 -->
						<div class="tab-content">
							<div class="tab-slider-wrap">
								<ul class="tab-slider">
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">51 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">52 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
								</ul>
							</div>
						</div>
						<!--// tab-content -->
						<!-- tab-content 세트메뉴 -->
						<div class="tab-content">
							<div class="tab-slider-wrap">
								<ul class="tab-slider">
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">61 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
									<li class="item">
										<div class="inner">
											<div class="img-wrap"><img src="/images/main/img_menuList.png" alt="자메이카 통다리 구이"></div>
											<div class="info-wrap">
												<p class="tit">62 자메이카 통다리 구이</p>
												<p class="txt">300년 전통의 오리지널 저크소스를 큼지막하면서도, 쫄깃한 통다리 곳곳에 잘 스며들게 듬~뿍 발라 더욱 깊은 저크 소스의 풍미를 즐길 수 있는 자메이카풍의 별미 요리.</p>
												<p class="origin">원산지닭고기 : 국내산</p>
												<ul class="list">
													<li>
														<p>열량<br><span>(kcal)</span></p>
														<em>201</em>
													</li>
													<li>
														<p>당류<br><span>(g)</span></p>
														<em>0.7</em>
													</li>
													<li>
														<p>단백질<br><span>(g)</span></p>
														<em>21</em>
													</li>
													<li>
														<p>포화지방<br><span>(g)</span></p>
														<em>3</em>
													</li>
													<li>
														<p>나트륨<br><span>(mg)</span></p>
														<em>423</em>
													</li>
												</ul>
												<div class="price-wrap">
													<p class="price"><em>17,500</em> 원</p>
													<div class="num-wrap">
														<button type="button" class="minus"></button>
														<input type="text" value="1" title="수량입력" class="num" readonly="readonly">
														<button type="button" class="add"></button>
													</div>
												</div>
												<div class="btn-wrap">
													<button type="button" class="btn btn-lg btn-gray btn-noLine"><span>상세보기</span></button>
													<button type="button" class="btn btn-lg btn-red btn-noLine"><span>주문하기</span></button>
												</div>
											</div>
										</div>
									</li>
								</ul>
							</div>
						</div>
						<!--// tab-content -->
					</div>
				</div>
			</section>
			<!--// Main Menu -->

			<!-- Main CF -->
			<section class="section section_cf" data-688="top:1862px;" data-1473="top:911px;" data-2384="top:0px;" data-3335="top:-951px;">
				<h2 class="blind">BBQ CF</h2>
				<div class="section-body">	
					<div class="inner">
						<div class="cf_txt">
							<p class="tel"><span>1588-9282</span></p>
							<p class="txt01">세상에서 가장 건강하고 맛있는 치킨이 생각날 땐!</p>
							<p class="txt02">BBQ는 최고의 치킨 맛, 건강에 좋은 치킨을 만들겠다는 일념으로<br>100% 엑스트라 버진 올리브유를 사용하고 있습니다.</p>
						</div>
						<div class="video-wrap">
							<div class="video-box">
								<iframe width="796" height="446" src="https://www.youtube.com/embed/Rav1b8PncxQ?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1"  title="BBQ CF" allowfullscreen></iframe>
							</div>
							<div class="video-info">
								<p class="tit">BBQ CF</p>
								<p class="txt">TV로 방송된 BBQ의 재미있는 CF를 감상해보세요.</p>
							</div>
						</div>
					</div>
				</div>
				<div class="ck3"><img src="/images/main/ck3.png" alt="ck3"></div>
				<div class="ck4"><img src="/images/main/ck4.png" alt="ck4"></div>
			</section>
			<!--// Main CF -->

			<!-- Main Store -->
			<section class="section section_store" data-1473="top:1803px;" data-2384="top:951px;" data-3335="top:0px;" data-4187="top:-852px;">
				<div class="section-header">
					<h2>BBQ STORE</h2>
				</div>
				<div class="section-body">
					<div class="inner">
						<div id="map" class="map-wrap"><img src="/images/main/bg_map.jpg" alt="지도샘플"></div>
						<div class="map-search">
							<div class="search-box">
								<input type="text" title="검색입력창" placeholder="매장명을 입력하세요">
								<button type="submit" class="btn-search"><span></span></button>
								<p class="total-txt">주변 <em class="num">50</em>개의 매장이 있습니다.</p>
							</div>
							<div class="tab-wrap tab-layer">
								<ul class="tab">
									<li class="on"><a href="#"><span>전체</span></a></li>
									<li><a href="#"><span>익스프레스</span></a></li>
									<li><a href="#"><span>프리미엄</span></a></li>
									<li><a href="#"><span>주차장</span></a></li>
								</ul>
							</div>
							<div class="tab-container tab-container-layer mCustomScrollbar">
								<!-- tab-content -->
								<div class="tab-content on">
									<ul class="map-list">
										<li>
											<a href="#">
												<p class="tit">전체 신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li class="on">
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
									</ul>
								</div>
								<!--// tab-content -->
								<!-- tab-content -->
								<div class="tab-content">
									<ul class="map-list">
										<li>
											<a href="#">
												<p class="tit">익스프레스 신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
									</ul>
								</div>
								<!--// tab-content -->
								<!-- tab-content -->
								<div class="tab-content">
									<ul class="map-list">
										<li>
											<a href="#">
												<p class="tit">프리미엄 신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
									</ul>
								</div>
								<!--// tab-content -->
								<!-- tab-content -->
								<div class="tab-content">
									<ul class="map-list">
										<li>
											<a href="#">
												<p class="tit">주차장 신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
										<li>
											<a href="#">
												<p class="tit">신대방1점</p>
												<p class="txt">서울 동작구 신대방동 605-11</p>
												<p class="tel">02-836-8292</p>
											</a>
										</li>
									</ul>
								</div>
								<!--// tab-content -->
							</div>
						</div>
					</div>
				</div>
			</section>
			<!--// Main Store -->

			<!-- Main Best Quality -->
			<section class="section section_bestQuality" data-2384="top:1768px;" data-3335="top:852px;" data-4187="top:0px;" data-4631="top:-440px;">
				<div class="inner">
					<div class="section-header">
						<h2><strong>B</strong>set of the <strong>B</strong>est <strong>Q</strong>uality</h2>
					</div>
					<div class="section-body">	
						<p class="txt">더 풍부한 행복을 만들기 위해 고객의 입맛과 마음을 연구합니다.<br>당신의 행복을 키우는 BBQ</p>
						<ul class="bestQuality-list">
							<li class="item01">
								<a href="#">
									<i class="ico ico-story01"></i>
									<span>BBQ STORY</span>
								</a>
							</li>
							<li class="item02 delay-03s">
								<a href="#">
									<i class="ico ico-story02"></i>
									<span>황금올리브이야기</span>
								</a>
							</li>
							<li class="item03 delay-06s">
								<a href="#">
									<i class="ico ico-story03"></i>
									<span>최고의 맛</span>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</section>
			<!--// Main Best Quality -->
			
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
<script src="/common/js/libs/skrollr.min.js"></script>
<!--[if lt IE 9]>
<script src="/common/js/libs/skrollr.ie.min.js"></script>
<![endif]-->
<script>
var s = skrollr.init({
	edgeStrategy: 'set',
	easing: {
		WTF: Math.random,
		inverted: function(p) {
			return 1-p;
		}
	}
});
</script>
</body>
</html>