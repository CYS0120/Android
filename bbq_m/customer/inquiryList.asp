<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<script>
//jQuery(document).ready(function(e) {
//	// inquiryList
//	$(document).on('click', '.inquiryList .item-inquiry', function(e) {
//		var $item = $(this).closest(".item");
//
//		e.preventDefault();
//		
//		if ($item.hasClass("on")) {
//			$item.find(".item-content").stop().slideUp('fast', function(){
//				$item.removeClass("on");
//			});
//		} else {
//			$item.addClass("on");
//			$item.find(".item-content").stop().slideDown('fast');
//		}
//	});
//});
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

						ht += "<li class=\"item"+(v.q_status=="답변완료"?" complete":"")+"\">";
//						ht += "	<a href=\"./inquiryView.asp?qidx="+v.q_idx+"\" class=\"item-inquiry\">";
						ht += "	<a href=\"#this\" class=\"item-inquiry\">";
						ht += "		<p class=\"mar-b10\">";
						ht += "			<span class=\"ico-branch red\">비비큐치킨</span>";
						ht += "		</p>";
						ht += "		<p class=\"subject\">"+v.title+"</p>";
						ht += "		<div class=\"item-footer\">";
						ht += "			<p class=\"date\">작성일 : <span>"+v.regdate.substr(0,10)+"</span></p>";
						ht += "			<span class=\"state\">"+v.q_status+"</span>";
						ht += "		</div>";
						ht += "	</a>";
						ht += "	<div class=\"item-content\">";
						ht += "		<div class=\"question\">";
						ht += "			<p>"+v.body+"</p>";
						ht += "		</div>";
						if(v.a_body != "") {
							ht += "		<div class=\"answer\">";
							ht += "			<p>"+v.a_body+"</p>";
							ht += "		</div>";
						}
						ht += "	</div>";
						ht += "</li>";

						$("#inquiry_list").append(ht);
					});



					// inquiryList
					$(document).on('click', '.inquiryList .item-inquiry', function(e) {
						var $item = $(this).closest(".item");

						e.preventDefault();
						
						if ($item.hasClass("on")) {
							$item.find(".item-content").stop().slideUp('fast', function(){
								$item.removeClass("on");
							});
						} else {
							$item.addClass("on");
							$item.find(".item-content").stop().slideDown('fast');
						}
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

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "고객센터"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->

		<!-- Content -->
		<article class="content">

			<!-- Tab -->
			<div class="tab-type4">
				<ul class="tab">
					<li><a href="/customer/faqList.asp">자주하는 질문</a></li>
					<li class="on"><a href="/customer/inquiryList.asp">고객의소리</a></li>
					<li><a href="/brand/noticeList.asp">공지사항</a></li>
				</ul>
			</div>
			<!--// Tab -->

			<%
				If False Then
			%>
			<%
				Else
			%>

			<!-- Inquiry List -->
			<div class="inquiryList-wrap inbox1000 ">
				<div class="btn-wrap one">
					<a href="/customer/inquiryWrite.asp" class="btn btn_middle btn-red">문의하기</a>
					<p class="explain">※ 문의하신 상담글은 수정, 삭제가 불가능합니다.</p>
				</div>


				<ul class="inquiryList" id="inquiry_list"></ul>

				<%
					End If
				%>

				<!-- Button More -->
				<div class="btn-wrap one">
					<button type="button" id="btn_more"  onclick="javascript:getInquiryList();"  class="btn btn_middle btn-grayLine btn-more">더보기</button>
				</div>
				<!--// Button More -->

			</div>
			<!--// Inquiry List -->


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
