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
	// inquiryList
	$(document).on('click', '.section_faq .question', function(e) {
		var par = $(this).closest('.box');
		if(par.hasClass('active')){
			par.removeClass('active').find('.answer').stop().slideUp('fast');
		}else{
			par.addClass('active').find('.answer').stop().slideDown('fast');
			par.siblings().removeClass('active').find('.answer').stop().slideUp('fast');
		}
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
					<li><a href="./bbq.asp"><span>비비큐 이야기</span></a></li>
					<li class="on"><a href="./oliveList.asp"><span>올리브 이야기</span></a></li>
					<li><a href="./videoList.asp"><span>영상콘텐츠</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- 이미지 텍스트 -->
			<div class="brand-bg brand_bgOlive1">
				<dl>
					<dt>우리가 모르고있던 올리브유</dt>
					<dd>올리브유 YES or NO</dd>
				</dl>
			</div>
			<!-- //이미지 텍스트 -->

			<!-- FAQ -->
			<section class="section section_faq">
				<div class="box active">
					<a href="#this" class="question">
						<p>올리브유가 일반 식용유보다 좋다?<span class="ico_yes">YES</span></p>
					</a>
					<div class="answer" style="display:block;">
						<p>
							일반 식용유는 제조 과정에서 산화 방지제가 첨가되고, 옥수수나 콩 등의 재료를 고온으로 가열한 뒤 압력을 가해 기름을 짜기 때문에 이 과정에서 항산화 물질인 폴리페놀, 토코페롤, 셀레늄 등의 영양소가 파괴됩니다. 반면 올리브유는 올리브 열매를 압착해서 짜낼 뿐, 생산과정에서 열을 가하거나 정제하지 않기 때문에 영양 파괴가 없어 비만 방지, 항암, 노화방지 등의 효능이 유지됩니다.
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>황금 올리브유'는 소스용으로만 사용 가능하다?<span class="ico_no">No</span></p>
					</a>
					<div class="answer">
						<p>
							엑스트라 버진 올리브유 속에는 올리브 과육이 짙게 섞여 있기 때문에 그대로 떠먹거나 샐러드 소스나 빵을 찍어 먹는 용도로 최상의 맛과 건강을 지닙니다. 올리브유가 튀김유로 적합하지 않다고 하는 것은 열을 가해 일정 온도를 가하게 되면 기름 속의 과육이 먼저 타서 산화되기 때문입니다. 그러나 여과 과정을 통해 올리브유 속의 미세한 과육을 제거하고 순도를 높이면 올리브유는 최상의 맛과 향을 자랑하는 튀김유가 됩니다. 이를 위해 국내 최대 유지업체 롯데삼강과 BBQ 세계식문화과학기술원은 3년여의 연구 개발 끝에 튀김에 적합한 상태인 BBQ황금 올리브유를 탄생시켰습니다. 엑스트라 버진 올리브유를 원료로 하는 BBQ황금 올리브유는 발화점이 높고, 맛과 향은 그대로 유지되는 최상의 튀김유입니다.
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>올리브유로 조리 시 높게 가열하면 영양소가 파괴된다?<span class="ico_no">No</span></p>
					</a>
					<div class="answer">
						<p>
							고온(70℃)에서 파괴되는 영양소는 단백질입니다. 하지만, 올리브유에는 단백질이 거의 들어 있지 않습니다. 또 모든 식품은 가열하면 그 영양 성분이 조금씩 파괴됩니다. 특히 비타민의 경우 파괴가 쉽습니다. 올리브유는 200℃ 이상 되는 온도에서 장시간 가열해야 오일의 영양 성분이 모두 파괴됩니다. 또한, 올리브유의 가장 중요한 특성인 지방산은 튀김 과정 중에는 거의 변화하지 않기 때문에 기타 미량의 물질만 약간 줄어들 뿐입니다
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>'황금 올리브유'로 닭을 튀기면 고소한 맛이 떨어진다?<span class="ico_no">No</span></p>
					</a>
					<div class="answer">
						<p>
							과거 후라이드 치킨의 고소한 맛은 식용유에서 나오는 트랜스지방산의 맛이었습니다. 반면 올리브유를 튀김유로 사용할 경우에는 올리브유가 코팅 막을 형성해 고기의 육즙이 흘러나오지 않도록 하고 원재료의 풍미를 지켜주며, 손으로 만져도 기름이 덜 배어나오는 바삭한 상태가 됩니다. 닭에 스며드는 기름의 양이 적고 고기의 맛이 유지되다 보니 당연히 고소한 맛이 증가되겠지요. 특히 BBQ는 최고의 치킨 맛이 유지될 수 있는 과학적인 조리 매뉴얼에 의거해 조리순서, 후라잉 온도 및 시간을 준수하고, 오일 관리를 실시함으로써 그 고소한 맛을 살려낼 수 있도록 만전을 기하고 있습니다.
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>올리브유에는 음식을 수십 번, 수백 번 튀겨도 된다?<span class="ico_no">No</span></p>
					</a>
					<div class="answer">
						<p>
							올리브유는 220℃의 높은 온도에서 끓기 시작합니다. 따라서 올리브유로 튀김을 하면 맛이 깔끔하고 일곱 번 까지 다시 사용할 수 있습니다. BBQ 치킨은 그 보다 낮은 165℃를 일정하게 유지하며 튀깁니다. 전국 BBQ 매장에서는 30kg의 올리브유로 닭 150마리만 튀기고 난 뒤 올리브유를 전량 새 것으로 교체합니다. 이것은 오랜 실험을 통해 얻은 결과로 위생은 물론 영양 면에서도 전혀 문제가 되지 않습니다.
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>BBQ는 튀김유로 '황금 올리브유'에 일반 식용유를 섞어 쓰기도 한다?<span class="ico_no">No</span></p>
					</a>
					<div class="answer">
						<p>
							비싼 올리브유 대신 일반 식용유를 몰래 섞어 쓰는 것 아닌가 하는 의혹을 제기하는 일부 소비자들이 있습니다. 하지만 BBQ는 철저한 관리 감독 시스템으로 이러한 문제를 사전차단하고 있습니다. BBQ본사는 가맹점의 닭 판매량과 파우더, 올리브유 주문 비율을 컴퓨터 시스템을 통해 리얼타임으로 관리하고, 이 비율이 맞지 않을 경우 감독인을 가맹점에 파견하여 바로 점검에 들어갑니다. 또한 본사의 슈퍼바이저가 매장을 정기 방문하여 수시로 기름 산가를 측정하는 등 엄격한 관리 감독을 실시하고 있습니다.
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>올리브유는 빛에 오래 노출될수록 좋지 않다?<span class="ico_yes">YES</span></p>
					</a>
					<div class="answer">
						<p>
							올리브유는 방부제 등의 화학물질이 전혀 첨가되지 않기 때문에 열과 빛, 공기에 오래 노출되면 좋지 않습니다. 어둡고 서늘한 곳에 보관하는 게 가장 좋으며, 5~25℃ 정도의 상온에서 뚜껑을 닫아 보관하면 1년 정도는 보관할 수 있습니다. 보관은 플라스틱 용기보다 검은 유리병이나 주석병에 담아두는 게 좋습니다. 될 수 있으면 빨리 소비하는 것이 좋습니다.
						</p>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>좋은 올리브유에서는 후추 맛을 느낄 수 있다?<span class="ico_yes">YES</span></p>
					</a>
					<div class="answer">
						<p>
							좋은 올리브유를 고르려면 색보다는 병뚜껑을 열었을 때 약간의 풀 향기와 사과 향기가 나는 게 좋습니다. 일반적으로 녹색이 강할수록 향이 강하고 맛이 좋은 것으로 알려져 있습니다. 보다 정확한 식별을 위해서는 올리브유 한 모금을 입 안에 넣고 공기를 들이마셨다가 내뱉으면, 좋은 올리브유에서는 입천장 뒤쪽에서 후추 맛을 느낄 수 있습니다.
						</p>
					</div>
				</div>
			</section>
			<!-- //FAQ -->

			<!-- 이미지 텍스트 -->
			<div class="brand-bg brand_bgOlive2 mar-t150">
				<dl>
					<dt>Great taste, eat Fresh</dt>
					<dd>엑스트라 버진 올리브유 이야기</dd>
				</dl>
			</div>

			<div class="txt-basic24 inner mar-t40">
				BBQ는 예로부터 신이 내린 최고의 선물이라 찬사를 받아온<br/>
				‘엑스트라 버진 올리브유’만을 고집합니다.<br/>
				세상에서 가장 맛있고 건강한 치킨만을 제공하겠다는 BBQ의 건강한 고집! 
				BBQ는 올리브 오일 중에 최상급인 100% 엑스트라 버진 올리브오일을 
				원료로 사용하는 올리브오일만을 사용합니다.<br/>
				그리고 3년간의 꾸준한 연구결과, BBQ만의 후라잉 오일 황금올리브유를 
				탄생시켜 세상에서 단 하나밖에 없는 건강하고 맛있는 치킨을 대한민국 
				국민치킨으로 제공하고 있습니다. 
			</div>
			<!-- //이미지 텍스트 -->

			<!-- FAQ -->
			<section class="section section_faq">
				<div class="box">
					<a href="#this" class="question">
						<p>젊음과 건강을 유지하게 하는 '올리브유의 비밀' &amp; '올리브유의 효능'</p>
					</a>
					<div class="answer">
						<div class="faqToggle">
								<div class="oliveStory_faq">
									<p>어린이 뇌 발달을 돕는다</p>
										<p>비타민과 필수 미네랄 성분이 태아와 성장기 어린이들의 뼈를 튼튼하게 만들고 뇌 발달에 도움을 준다.</p>
								</div>
								<div class="oliveStory_faq">
									<p>성인병 예방에 도움을 준다</p>
										<p>단순불포화지방산(올레인산)이 들어있어 각종 성인병의 원인이 되는 콜레스테롤 수치를 억제해 동맥경화, 협심증 예방에 도움을 주고, 혈당을 조절하여 당뇨병 예방에 도움을 준다. </p>
								</div>
								<div class="oliveStory_faq">
									<p>노화방지에 도움을 준다</p>
										<p>단순불포화지방산과 항산화 성분인 비타민E, 토코페롤, 스쿠알렌 등을 다량 함유하고 있어 노화예방에 도움을 준다.</p>
								</div>
								<div class="oliveStory_faq">
									<p>간 기능을 돕고 담석 예방에 도움을 준다</p>
										<p>간에서 생성하는 유익한 콜레스테롤(HDL)의 분비를 촉진해 간기능을 돕고 담석이 생기는 것을 막아주며 담석 예방에 도움을 준다. </p>
								</div>
								<div class="oliveStory_faq">
									<p>비만과 변비 완화에 도움을 준다</p>
										<p>비만의 원인이 되는 트랜스 지방이 함유되어 있지 않아 비만 예방 및 다이어트에 효과적이다. 또한 식물성 지방성분이 대장의 배변운동을 촉진시켜 변을 부드럽게 한다. </p>
								</div>
								<div class="oliveStory_faq">
									<p>피부를 맑고 윤기 있게 가꿔준다</p>
										<p>올리브오일에 함유된 비타민E와 프로비타민이 피부 노화를 막고, 노폐물을 배출시켜 건강한 피부를 유지하고 탈모와 임신선 발생 예방에도 도움을 준다.
						또한 살균 정화능력을 갖고 있어 피부 트러블을 진정시키는 작용을 한다. </p>
								</div>
								<div class="oliveStory_faq">
									<p>암 예방에 도움을 준다</p>
										<p>항산화 물질이 풍부한 올리브유는 암을 예방하는데 도움이 된다. 특히 소화기 계통의 암을 예방하는 데 좋다. </p>
								</div>
						</div>

					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>올리브유의 활용 아이디어 맛도 좋고 건강에도 좋은 올리브유! 어떻게 즐길 수 있을까요?</p>
					</a>
					<div class="answer">
						<div class="faqToggle">
							<div class="oliveStory_faq">
									<p>국수를 삶을 때 넣는다</p>
									<p>국수를 삶을 때 냄비에 1~2방울 넣으면 국수 면발이 더 쫀득해져요. 따로 소금을 넣을 필요도 없답니다. </p>
							</div>
							<div class="oliveStory_faq">
									<p>생선을 구울 때 사용한다</p>
									<p>생선을 굽기 전 생선에 올리브유를 바르면 생선의 비린내가 없어져 더욱 담백하고 맛있는 생선을 즐길 수 있답니다. </p>
							</div>
							<div class="oliveStory_faq">
									<p>마요네즈를 만든다</p>
									<p>달갈노른자 6개와 올리브유 3큰술을 섞은 다음 아이보리색을 띠면서 살짝 굳을 때까지 저으면 올리브유 마요네즈 완성! 기호에 맞게 소금과 후춧가루로 간하면 됩니다. 
						성인병 예방에도 좋아요. </p>
							</div>
							<div class="oliveStory_faq">
									<p>빵에 찍어 먹는다</p>
									<p>올리브유가 빵의 풍미를 좋게 합니다. 버터나 잼을 찍어 먹는 것  보다 다이어트 효과도 좋아요. 조금 싱겁다면 소금과 후춧가루를 넣어보세요!</p>
							</div>
							<div class="oliveStory_faq">
									<p>고기를 재운다</p>
									<p>올리브유가 육질을 부드럽게 해줍니다. 버터로 조리할 때 올리브유를 함께 섞어 조리하면 고기가 타는 것을 방지할 수 있답니다. </p>
							</div>
							<div class="oliveStory_faq">
									<p>견과류를 볶는다</p>
									<p>달군 팬에 올리브유를 두르고 호두, 땅콩, 아몬드 등의 견과류를 볶은 뒤 소금을 약간 뿌려 먹으면 고소한 맛을 더욱 살려서 즐길 수 있어요. </p>
							</div>
							<div class="oliveStory_faq">
									<p>가래떡을 굽는다</p>
									<p>가래떡에 올리브유를 바르고 구우면 굳은 가래떡이 부드러워진답니다. 팬에 올리브유를 두른 뒤 구워 먹어도 담백한 맛을 느낄 수 있어요. </p>
							</div>
						</div>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>올리브유를 이용한 피부관리 TIP</p>
					</a>
					<div class="answer">
						<div class="faqToggle">
							<div class="oliveStory_faq">
									<p>클렌징</p>
									<p>모든 피부타입에 잘 맞는 올리브유를 클렌징오일로 사용하면 피부에 자극을 줄이고 깨끗하게 메이크업을 지울 수가 있습니다. </p>
							</div>
							<div class="oliveStory_faq">
									<p>보습</p>
									<p>발꿈치, 팔꿈치, 무릎 등 피부가 많이 건조하고 거칠어졌을 때 소량 발라주면 촉촉하고 매끄러운 피부가 됩니다. </p>
							</div>
							<div class="oliveStory_faq">
									<p>주름개선</p>
									<p>자기 전에 눈가에 올리브유 한두 방울을 떨구어 주면 눈가의 잔주름을 없애는데 도움을 줍니다. </p>
							</div>
							<div class="oliveStory_faq">
									<p>미백</p>
									<p>기초화장품에 올리브유 한 방울씩 섞어 바르면 피부가 투명하고 생기 있어 보입니다.</p>
							</div>
							<div class="oliveStory_faq">
									<p>모발건강</p>
									<p>단순불포화 지방산과 항산화 성분인 비타민E, 토코페롤, 스쿠알렌 등을 많이 함유하고 있어 모발 보호 및 강화에 도움을 줍니다. </p>
							</div>
							<div class="oliveStory_faq">
									<p>다이어트&amp;건강</p>
									<p>간에서 생성하는 유익한 콜레스테롤(HDL)의 분비를 촉진해 간 기능을 돕고 담석이 생기는 것을 막아주며, 골다공증 예방에도 도움을 줍니다. </p>
							</div>                        
						</div>
					</div>
				</div>
				<div class="box">
					<a href="#this" class="question">
						<p>엑스트라 버진 올리브유의 생산과정</p>
					</a>
					<div class="answer">
						<div class="oliveStory_faq2">고급 품종의 올리브의 씨를 제거하고 최첨단 콜드 프레싱 공법으로 압착하여 엑스트라 버진 올리브유를 얻습니다.
							
							<dl class="gray_box">
								<dt>콜드프레싱공법이란?</dt>
								<dd>
									돌로 짓눌러 납작해진 올리브 열매를 거적으로 겹겹이 쌓아서 기름을 얻어내는 방법.<br/>
									올리브유에 가해지는 열이 직접 가열하는 것보다 훨씬 작기 때문에 짜낼 수 있는 기름의 양이 적어도 품질은 훨씬 뛰어나다.
								</dd>
							</dl>
								
							이렇게 만들어진 엑스트라 버진 올리브유는 바다 건너 대한민국 BBQ로 건너옵니다.<br/>
							수입된 엑스트라 버진 올리브유는 전국의 BBQ 매장에 공급됩니다.<br/>
							그리고 고객들은 건강하고 맛있는 BBQ치킨을 즐길 수 있답니다.</div>

					</div>
				</div>
			</section>
			<!-- //FAQ -->


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