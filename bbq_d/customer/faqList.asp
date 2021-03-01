<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="고객센터, BBQ치킨">
<meta name="Description" content="고객센터 메인">
<title>고객센터 | BBQ치킨</title>
<script>
jQuery(document).ready(function(e) {
	
	$(window).on('scroll',function(e){
		if ($(window).scrollTop() > 0) {
			$(".wrapper").addClass("scrolled");
		} else {
			$(".wrapper").removeClass("scrolled");
		}
	});
	
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
<%
	pageSize = GetReqNum("pageSize", 30)
	gotoPage = GetReqNum("gotoPage",1)
%>
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
				<li>고객센터</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">고객센터</h1>
			<div class="tab-wrap tab-type3 leng2">
				<ul class="tab">
					<li class="on"><a href="./faqList.asp"><span>자주 묻는질문</span></a></li>
					<li><a href="./inquiryWrite.asp"><span>고객의 소리</span></a></li>
				</ul>
			</div>

			<div class="icon-top">
				<div class="img"><img src="/images/customer/ico_big_qa.gif" alt=""></div>
				<h3>고객님께서 자주 문의하시거나 궁금해하는 질문들을 모아서 정리하였습니다.</h3>
				<p>
					찾으시는 내용이 없거나 궁금한 사항이 있으면 고객의 소리에 의견을 남겨주세요. 고객님의 새로운 행복을 위해서 언제나 최선을 다하는 BBQ가 되겠습니다.
				</p>
			</div>


			<form class="form_selType mar-t30">
				<div class="inner">
					<select class="hide" name="" id="">
						<option value="">전체브랜드 보기</option>
						<option value="">비비큐치킨</option>
						<option value="">비비큐몰</option>
						<option value="">행복한집밥</option>
						<option value="">닭익는마을</option>
						<option value="">참숯바베큐</option>
						<option value="">우쿠야</option>
						<option value="">올떡</option>
						<option value="">소신275°C</option>
						<option value="">와타미</option>
					</select>
				</div>
			</form>
<%
	Set vCmd = Server.CreateObject("ADODB.Command")
	With vCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_board_select"

		.Parameters.Append .CreateParameter("@gubun", adVarChar, adParamInput, 10, "LIST")
		.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 2, "01")
		.Parameters.Append .CreateParameter("@bbs_code", adVarChar, adParamInput, 5, "A04")
		.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , pageSize)
		.Parameters.Append .CreateParameter("@page", adInteger, adParamInput, , gotoPage)
		.Parameters.Append .CreateParameter("@TotalCount", adInteger, adParamOutput)

		Set vRs = .Execute

		TotalCount = .Parameters("@TotalCount").Value
	End With
	Set vCmd = Nothing

	If Not (vRs.BOF Or vRs.EOF) Then
%>
			<!-- FAQ -->
			<section class="section section_faq type2 line">
<%
		Do Until vRs.EOF
%>
				<div class="box">
					<a href="#this" class="question">
						<span class="ico-branch red">비비큐 치킨</span>
						<p><%=vRs("title")%></p>
					</a>
					<div class="answer">
						<p>
						<%=vRs("contents")%>
						</p>
					</div>
				</div>
<%
			vRs.MoveNext
		Loop
	End If
%>
			</section>
<%
	Set vRs = Nothing
%>
			<!-- //FAQ -->

			<section class="section section-botContact mar-t70">
				<div class="div-table">
					<div class="tr">
						<div class="td cs">
							<dl>
								<dt>고객센터</dt>
								<dd>080-3436-0507</dd>
							</dl>
							<p>토요일,공휴일은 휴무 / 운영시간 10:00~18:00</p>
						</div>
						<div class="td inq">
							<dl>
								<dt>창업문의</dt>
								<dd>080-383-9000</dd>
							</dl>
							<p>연중무휴 상담가능 / 운영시간 06:00~24:00</p>
						</div>
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
