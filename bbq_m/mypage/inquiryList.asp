<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<meta name="Keywords" content="나의 상담내역, BBQ치킨">
<meta name="Description" content="나의 상담내역">
<title>나의 상담내역</title>

<script>
	jQuery(document).ready(function(e) {
		// inquiryList
		// $(document).on('click', '.inquiryList .item-inquiry', function(e) {
		// 	var $item = $(this).closest(".item");

		// 	e.preventDefault();
			
		// 	if ($item.hasClass("on")) {
		// 		$item.find(".item-content").stop().slideUp('fast', function(){
		// 			$item.removeClass("on");
		// 		});
		// 	} else {
		// 		$item.addClass("on");
		// 		$item.find(".item-content").stop().slideDown('fast');
		// 	}
		// });
	});
</script>

<script type="text/javascript">
	var page = 1;
	var pagesize = 10;

	$(function(){
		getInquiryList();
	});

	function getInquiryList() {
		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getInquiryList.asp",
			data: {mode: "LIST",brand_code:"01",pageSize:pagesize, curPage: page},
			// dataType: "json",
			success: function(respon) {
				var res = JSON.parse(respon);
				if(res.result == 0) {
					if(res.totalCount == 0) {
						$("#inquiry_list").html("<li class=\"inquiryX\">문의내역이 없습니다.</li>");
						$("#btn_more").hide();
					}

					$.each(res.data, function(k,v) {
						var ht = "";

						ht += "<li class=\"item"+(v.q_status=="답변완료"?" complete":"")+"\">\n";
						ht += "\t<a href=\"./inquiryView.asp?qidx="+v.q_idx+"\" class=\"item-inquiry\">\n";
						ht += "\t\t<p class=\"mar-b10\">\n";
						ht += "\t\t\t<span class=\"ico-branch red\">비비큐치킨</span>\n";
						ht += "\t\t</p>\n";
						ht += "\t\t<p class=\"subject\">"+v.title+"</p>\n";
						ht += "\t\t<div class=\"item-footer\">\n";
						ht += "\t\t\t<p class=\"date\">작성일 : <span>"+v.regdate.substr(0,10)+"</span></p>\n";
						ht += "\t\t\t<span class=\"state\">"+v.q_status+"</span>\n";
						ht += "\t\t</div>\n";
						ht += "\t</a>\n";
						// ht += "\t<div class=\"item-content\">\n";
						// ht += "\t\t<div class=\"question\">\n";
						// ht += "\t\t\t<p>"+v.body+"</p>\n";
						// ht += "\t\t</div>\n";
						// if(v.a_body != "") {
						// 	ht += "\t\t<div class=\"answer\">\n";
						// 	ht += "\t\t\t<p>"+v.a_body+"</p>\n";
						// 	ht += "\t\t</div>\n";
						// }
						// ht += "\t</div>\n";
						ht += "</li>\n";

						$("#inquiry_list").append(ht);
					});

					if(res.totalCount > 0 && res.data.length < pagesize) {
						$("#btn_more").hide();
					} else {
						page++;
					}
				} else {
					alert(res.message);
				}
			},
			error: function(xhr, state, m) {
				alert("error");
			}
		});
	}
</script>


<style>
.container {margin-bottom:-70px;}
@media (max-width:480px){
.container {margin-bottom:-40px;}
}
</style>

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "나의 상담내역"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->

		<!-- Content -->
		<article class="content">

			<div class="page_title">
				<img src="/images/order/icon_orderList.png">
				<span>나의 문의 내역</span>
			</div>

			<!-- Inquiry -->
			<section class="section-wrap section_inquiry">
				<h2 class="blind">상품문의</h2>

				<!-- Inquiry List -->
				<div class="inquiryList-wrap">

					<div class="btn-wrap">
						<button type="button" onclick="location.href='/customer/inquiryWrite.asp';" class="btn btn_middle btn-red">문의하기</button>
						<p class="explain">※ 문의하신 상담글은 수정, 삭제가 불가능합니다.</p>
					</div>

					<!-- 주문 내역 검색 -->
					<form class="form_selType mar-t25">
						<!-- <select name="" id="">
							<option value="">전체브랜드 보기</option>
						</select> -->
					</form>
					<!-- //주문 내역 검색 -->

					<ul class="inquiryList" id="inquiry_list">
					</ul>

					<div class="btn-wrap">
						<button type="button"  id="btn_more"  onclick="javascript:getInquiryList();" class="btn-grayLine btn_middle mar-t20 mar-b20"><span>더보기</span></button>
					</div>

				</div>
				<!--// Inquiry List -->

			</section>
			<!-- Inquiry -->
				
			<!-- Call Center -->
			<section class="section_callCenter ">
				<div class="inner">
					<dl class="callCenter">
						<dt>고객센터</dt>
						<dd>
							<div class="callNumber">080-3436-0507</div>
							<div class="openTime">운영시간 10:00~18:00 (토요일, 공휴일은 휴무)</div>
						</dd>
					</dl>
				</div>
			</section>
			<!--// Call Center -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
