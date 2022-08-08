<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="브랜드스토리, BBQ치킨">
<meta name="Description" content="브랜드스토리 메인">
<title>브랜드스토리 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
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
				<li>bbq home</li>
				<li>브랜드</li>
				<li>사회공헌활동</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content content-wide">
			<div class="inner">
				<h1 class="ta-l">사회공헌활동</h1>
				<div class="tab-wrap tab-type3 leng2">
					<ul class="tab">
						<li><a href="./csr.asp"><span>사회공헌활동 게시판</span></a></li>
						<li class="on"><a href="./bbcar.asp"><span>찾아가는 치킨릴레이 사연 신청 게시판</span></a></li>
					</ul>
				</div>
			</div>

			<section class="section section_bbqStroy">
				<div class="bbqStroy_happy">
					<div class="inner">
						<h3>비비카 사연 신청 게시판</h3>
						<div><img src="/images/brand/bbqstory_happy.jpg" alt=""></div>
				
						<div class="bbqStroy_qua">
							<dl>
								<dt>꿈과 희망 그리고 사랑을 가득담은 비비카 사연 신청 게시판입니다.</dt>
								<dd class="mar-t40">
		전세계 인구를 잘먹고 잘살게하는 목표를 가진 비비큐가 여러분을 찾아갑니다. <br/>
		세상에서 가장 맛있는 치킨 비비큐를 쉽게 접할 수 없는 지역 혹은 도움의 손길이 필요한 단체 등 <br/>
		필요한 곳에 비비큐가 직접 찾아가도록 하겠습니다. <br/>
		광고성 글은 관리자가 임의로 삭제처리가 가능함을 안내드립니다. <br/>
		정확한 정보 확인을 위해 고객님의 정보를 정확히 적어주시기 바랍니다. <br/>
		고객님의 정보가 부정확할 경우, 신청이 무효처리 될 수 있음을 양해부탁드립니다.<br/>
		<br/>
		정확한 정보 확인을 위해 사연 신청자의 개인정보가 수집되고 관리됨을 안내드립니다.<br/>
		수집된 정보는 매월 자동 삭제됩니다.<br/>
		비비카 사연 신청 기간은 매월 1일 부터 21일 총 3주간 신청을 받습니다. <br/>
		1주간 사연 심사 기간을 거쳐 매월 말일에 선정된 고객님께 연락을 드릴 예정이며, <br/>
		방문 일정 및 필요 수량 협의 후 방문 예정입니다.  
								</dd>
							</dl>
						</div>
					</div>
				</div>
			
				<div class="btn-wrap tap inner mar-t60 tr">
					<div class="td">
							<div class="btn btn-lg btn-red-main" onclick="location.href ='./bbcarWrite.asp'"><span>사연 신청하기</span></div>

							<div class="btn btn-lg btn-grayLine-main" onclick="location.href ='/mypage/bbcarList.asp?gotoPage=1'"><span>내가 쓴 글 확인하기</span></div>

					</div>
				</div>
			</section>
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
