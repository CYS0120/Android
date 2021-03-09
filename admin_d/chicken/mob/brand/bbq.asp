<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="브랜드, BBQ치킨">
<meta name="Description" content="브랜드">
<title>브랜드 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
<script>
jQuery(document).ready(function(e) {
	$('.bbqStroy_time .tab a').on('click',function(){
		$(this).addClass('active').siblings().removeClass('active');
		$('.bbqStroy_time .area').eq($(this).index()).addClass('active').siblings().removeClass('active');
		return false;
	});
});
</script>
</head>

<body>
<div class="wrapper">
	<!-- Header -->
	<header class="header">
		<h1>브랜드</h1>
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
					<li class="on"><a href="./bbq.asp"><span>브랜드스토리</span></a></li>
					<li><a href="./eventList.asp"><span>비비큐 소식</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- Tab -->
			<div class="tab-wrap tab-type3">
				<ul class="tab">
					<li class="on"><a href="./bbq.asp"><span>비비큐 이야기</span></a></li>
					<li><a href="./oliveList.asp"><span>올리브 이야기</span></a></li>
					<li><a href="./videoList.asp"><span>영상콘텐츠</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- 비비큐 이야기 -->
			<section class="section section_bbqStroy">
				<div class="inner">

					<div class="bbqStroy_happy">
						<h3>당신의 행복을 키우는 BBQ</h3>
						<div><img src="/images/brand/bbqstory_happy.jpg" alt="" class="w-100p"></div>
						<div class="txt-basic ta-c mar-t50">
							BBQ는 더 풍부한 행복을 만들기 위해<br/>
							고객의 입맛과 마음을 연구합니다.<br/>
							BBQ가 있는 곳 어디서나 행복한 만남이 이루어집니다.<br/>
							사회 윤리적 기업으로 책임과 역할을 다하여<br/>
							모두가 행복해지는 세상을 만들어가겠습니다. 
						</div>
					</div>

					<div class="bbqStroy_qua mar-t70">
						<dl>
							<dt>Best of the Best Quality</dt>
							<dd>
								BBQ는 그 이름처럼<br/>
								최고의 원재료만을 사용하여 맛은 물론 <br/>
								고객의 건강까지 생각합니다.
							</dd>
						</dl>
						<div class="img"><img src="/images/brand/bbqstory_qua.jpg" alt=""></div>
						<dl>
							<dt>세상에서 가장 맛있는 치킨</dt>
							<dd>
								BBQ는 최고의 치킨 맛,<br/>
								건강에 좋은 치킨을 만들겠다는 일념으로<br/>
								올리브유 중에서도 최고급유이자<br/>
								‘신이 내린 선물’이라 불리는<br/>
								100%엑스트라 버진 올리브유를<br/>
								후라잉오일의 원료로 사용하고 있으며<br/>
								국민건강 증진에 기여하고자 합니다.
							</dd>
						</dl>
					</div>

					<div class="bbqStroy_gray">
						<div class="use">
							<h3>BBQ 사용규정</h3>
							<div><img src="/images/brand/bbqstory_logo.jpg" alt="" class="w-100p"></div>
							<dl>
								<dt>마스터 로고_Master Logo</dt>
								<dd>
									BBQ의 Logotype은 대내외 Communication에 있어서 이미지를 
									대표하는 BI(Brand Identity)의 핵심요소이다.<br/>
									따라서 Logo의 형태나 비례는 어떠한 경우에도 정확하게 표현되어야 
									하며 규정된 형태와 비례, 색상은 임의로 변경 될 수 없다. <br/>
									BBQ의 시각적 이미지를 전달하는 중요한 수단이므로 제시된 가이드
									라인을 준수하여 BBQ의 브랜드 이미지에 손상이 발생하지 않도록 
									주의하여 사용하도록 한다.
								</dd>
							</dl>
						</div>
						<div class="color mar-t70">
							<h3>Color System_전용색상 체계</h3>
							<div class="area">
								<div class="box box1">
									<h4>BBQ Prussian Blue</h4>
									<dl>
										<dt>PANTONE</dt>
										<dd>PANTONE 2765C </dd>
									</dl>
									<dl>
										<dt>CMYK</dt>
										<dd>C 100 &nbsp; M 97 &nbsp; Y 0  K 45</dd>
									</dl>
									<dl>
										<dt>RGB</dt>
										<dd>R 22 &nbsp; G 20 &nbsp; B 95</dd>
									</dl>
									<dl>
										<dt>HEX Code</dt>
										<dd>#16145f</dd>
									</dl>
								</div>
								<div class="box box2">
									<h4>BBQ Gold</h4>
									<dl>
										<dt>PANTONE</dt>
										<dd>PANTONE 871C</dd>
									</dl>
									<dl>
										<dt>CMYK</dt>
										<dd>C 20 &nbsp; M 25 &nbsp; Y 60  K 25</dd>
									</dl>
									<dl>
										<dt>RGB</dt>
										<dd>R 163 &nbsp; G 45 &nbsp; B 97</dd>
									</dl>
									<dl>
										<dt>HEX Code</dt>
										<dd>#a39161</dd>
									</dl>
								</div>
								<div class="box box3">
									<h4>BBQ Red</h4>
									<dl>
										<dt>PANTONE</dt>
										<dd>PANTONE 186C </dd>
									</dl>
									<dl>
										<dt>CMYK</dt>
										<dd>C 0 &nbsp; M 00 &nbsp; Y 81  K 4</dd>
									</dl>
									<dl>
										<dt>RGB</dt>
										<dd>R 227 &nbsp; G 25 &nbsp; B 55</dd>
									</dl>
									<dl>
										<dt>HEX Code</dt>
										<dd>#E31937</dd>
									</dl>
								</div>
								<div class="box box4">
									<h4>BBQ Gray</h4>
									<dl>
										<dt>PANTONE</dt>
										<dd>PANTONE Warm Gray 8C</dd>
									</dl>
									<dl>
										<dt>CMYK</dt>
										<dd>C 0 &nbsp; M 9 &nbsp; Y 16 &nbsp; K 43</dd>
									</dl>
									<dl>
										<dt>RGB</dt>
										<dd>R 162 &nbsp; G 149 &nbsp; B 138</dd>
									</dl>
									<dl>
										<dt>HEX Code</dt>
										<dd>#a2958a</dd>
									</dl>
								</div>
								<div class="box box5">
									<h4>BBQ Custom Gradient Color</h4>
								</div>
							</div>
						</div>
					</div>

					<div class="bbqStroy_history">
						<h3>BBQ 로고 History</h3>
						<div class="area div-table">
							<div class="tr">
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo1.jpg" alt=""></dt>
										<dd>1995 ~ 1996</dd>
									</dl>
								</div>
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo2.jpg" alt=""></dt>
										<dd>1997 ~ 1998</dd>
									</dl>
								</div>
							</div>
							<div class="tr">
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo3.jpg" alt=""></dt>
										<dd>1999 ~ 2001</dd>
									</dl>
								</div>
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo4.jpg" alt=""></dt>
										<dd>2001 ~ 2002</dd>
									</dl>
								</div>
							</div>
							<div class="tr">
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo5.jpg" alt=""></dt>
										<dd>2002 ~ 2005</dd>
									</dl>
								</div>
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo6.jpg" alt=""></dt>
										<dd>2006 ~ 2007</dd>
									</dl>
								</div>
							</div>
							<div class="tr">
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo7.jpg" alt=""></dt>
										<dd>2008 ~ </dd>
									</dl>
								</div>
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo8.jpg" alt=""></dt>
										<dd>2011. 서울대 해동관점</dd>
									</dl>
								</div>
							</div>
							<div class="tr">
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo9.jpg" alt=""></dt>
										<dd>2011 ~ 2013</dd>
									</dl>
								</div>
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo11.jpg" alt=""></dt>
										<dd>글로벌 2016</dd>
									</dl>
								</div>
							</div>
						</div>
						
						<div class="area div-table" style="margin-top:-1px;">
							<div class="tr">
								<div class="td">
									<dl>
										<dt><img src="/images/brand/bbqstory_logo10.jpg" alt=""></dt>
										<dd>2014 ~ 현재</dd>
									</dl>
								</div>
							</div>
						</div>
						
						<div class="area2 mar-t30">
							<img src="/images/brand/bbqstory_otherLogo.jpg" alt="">
						</div>
					</div>

					<div class="bbqStroy_time mar-t70">
						<h3>BBQ 연혁 및 수상내역</h3>
						<div class="tab mar-t20 div-table">
							<div class="tr">
								<a href="#" onclick="javascript:return false;" class="active">2010's</a>
								<a href="#" onclick="javascript:return false;">2000's</a>
								<a href="#" onclick="javascript:return false;">1990's</a>
							</div>
						</div>
						<div class="wrap">

							<div class="area active">

								<div class="box">
									<h4>2018 ~</h4>
									<ul>
										<li>포항지진 피해복구 유공 '행정안전부 장관상' 수상</li>
										<li>매경 '글로벌리더 25인 선정'</li>
										<li>WFP(유엔세계식량계획 기구) 협약</li>
									</ul>
								</div>

								<div class="box">
									<h4>2017</h4>
									<ul>
										<li>BBQ 올리버스 공식 후원</li>
										<li>뉴욕 맨하튼 32번가 그랜드 오픈</li>
										<li><strong>대한민국 100대 CEO 11회 연속 수상</strong></li>
										<li>글로벌 57개국 국가 500개 매장 운영</li>
										<li><strong>한국소비자대상 '최고브랜드상' 수상</strong></li>
										<li><strong>브랜드스탁 100대 브랜드 선정 '33위'</strong> </li>
										<li><strong>한국브랜드경영협회의 '2017년 올해의 신성장기업 경영인상' 수상</strong></li>
									</ul>
								</div>

								<div class="box">
									<h4>2016</h4>
									<ul>
										<li>대한민국 브랜드 스타 외식프랜차이즈부문 '1위'</li>
										<li>대한민국 100대 브랜드 '34위' 기록</li>
									</ul>
								</div>

								<div class="box">
									<h4>2015</h4>
									<ul>
										<li>BBQ-ECO EV 실증사업 3자간 MOU 체결(BBQ, 르노삼성, 서울시)</li>
										<li>2015 요우커 만족도 치킨부문 '1위'</li>
										<li><strong>금탑산업훈장 수훈</strong></li>
									</ul>
									<div class="img"><img src="/images/brand/history2015.jpg" alt=""></div>
								</div>

								<div class="box">
									<h4>2014</h4>
									<ul>
										<li>GBFF(제너시스비비큐 패밀리 패스티벌) 개최 5,000명 제주 1박2일 초청</li>
										<li>한국 100대 CEO선정(8회 연속)</li>
										<li>지속가능 경영대상 '환경부장관상' 수상</li>
										<li>기업혁신대상 '산업통상부 장관상' 수상</li>
									</ul>
								</div>

								<div class="box">
									<h4>2013</h4>
									<ul>
										<li>BBQ 교육과정 22,000명 수료 </li>
										<li>5.16 민족상 수상</li>
										<li>코리아 CEO Summit '창조브랜드대상' 수상</li>
									</ul>
								</div>

								<div class="box">
									<h4>2012</h4>
									<ul>
										<li>'글로벌 경영위원회 최고경영자 및 마케팅 대상' 수상</li>
										<li>'한국 최고의 일하기 좋은 기업 대상' 수상</li>
										<li>포브스 '브랜드 경영부문 대상' 수상</li>
										<li><strong>한국유통대상 '대통령상' 수상</strong></li>
									</ul>
									<div class="img"><img src="/images/brand/history2012.jpg" alt=""></div>
								</div>

								<div class="box">
									<h4>2011</h4>
									<ul>
										<li>BBQ 프리미엄 카페 런칭 </li>
										<li>'소비자 품질만족 대상' 수상</li>
										<li>'고용창출 선도 대상' 수상</li>
									</ul>
								</div>

							</div>

							<div class="area">

								<div class="box">
									<h4>2009</h4>
									<ul>
										<li>BBQ 터키 진출</li>
										<li>'한국의 경영자상' 수상</li>
										<li>'한국재계를 이끄는 CEO 대상' 수상</li>
										<li>'CEO 창조경영인상' 수상</li>
										<li><strong>은탑산업훈장 수훈</strong></li>
									</ul>
									<div class="img"><img src="/images/brand/history2009.jpg" alt=""></div>
								</div>

								<div class="box">
									<h4>2008</h4>
									<ul>
										<li>전세계 3,750개점 운영 </li>
										<li>BBQ 인도 진출 </li>
										<li>국내 브랜드가치 '45위' </li>
									</ul>
								</div>

								<div class="box">
									<h4>2007</h4>
									<ul>
										<li>사우디, 말레이시아, 싱가폴(10개국) </li>
										<li><strong>스페인 시민십자대훈장 수훈</strong></li>
									</ul>
									<div class="img"><img src="/images/brand/history2007.jpg" alt=""></div>
								</div>

								<div class="box">
									<h4>2006</h4>
									<ul>
										<li>일본, 미국, 베트남, 호주, 몽골 진출</li>
										<li>상공의 날 '산업자원부 장관상' 수상</li>
									</ul>
								</div>

								<div class="box">
									<h4>2005</h4>
									<ul>
										<li>올리브치킨 혁명(올리브오일 개발)</li>
										<li>공정거래의 날 '대통령상' 수상</li>
									</ul>
								</div>

								<div class="box">
									<h4>2004</h4>
									<ul>
										<li>BBQ 스페인 진출 </li>
										<li>경기도 이천 치킨대학 개관</li>
										<li>BBQ 1,800호점 개점</li>
									</ul>
								</div>

								<div class="box">
									<h4>2003</h4>
									<ul>
										<li>BBQ 중국진출(상해 BBQ유한공사 설립)</li>
										<li>한국유통대상 '국무총리상' 수상</li>
										<li><strong>동탑산업훈장 수훈</strong></li>
									</ul>
									<div class="img"><img src="/images/brand/history2003.jpg" alt=""></div>
								</div>

								<div class="box">
									<h4>2002</h4>
									<ul>
										<li>문정동 신사옥 이전 및 제 2창업 선포</li>
										<li>산업자원부 '장관상' 수상</li>
									</ul>
								</div>

								<div class="box">
									<h4>2000</h4>
									<ul>
										<li>BBQ치킨대학 개관 및 물류센터 준공</li>
										<li>농림부 장관 표창</li>
									</ul>
								</div>

							</div>

							<div class="area">

								<div class="box">
									<h4>1999</h4>
									<ul>
										<li>한국유통대상 '국무총리상' 수상</li>
									</ul>
								</div>

								<div class="box">
									<h4>1998</h4>
									<ul>
										<li>BBQ 1,000호점 오픈(세계 최초) </li>
									</ul>
								</div>

								<div class="box">
									<h4>1996</h4>
									<ul>
										<li>BBQ 100호점 오픈</li>
									</ul>
								</div>

								<div class="box">
									<h4>1995</h4>
									<ul>
										<li>제너시스 BBQ 그룹 창업</li>
										<li>BBQ 1호점 오픈</li>
									</ul>
									<div class="img"><img src="/images/brand/history1995.jpg" alt=""></div>
								</div>

							</div>

						</div>
					</div>

				</div>
			</section>
			<!-- //비비큐 이야기 -->



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