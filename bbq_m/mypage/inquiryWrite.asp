<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">

<head>
<!--#include virtual="/includes/top.asp"-->

<script type="text/javascript">
	function validQ() {

		$.ajax({
			method: "post",
			url: "inquiryProc.asp",
			data:$("#mq").serialize(),
			dataType: "json",
			success: function(res) {
				alert(res.message);
				if(res.result == 0) {
					location.href = "/mypage/inquiryList.asp";
				}
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
			<div class="tab-wrap tab-type2">
				<ul class="tab">
					<li><a href="/customer/faqList.asp"><span>자주묻는질문</span></a></li>
					<li class="on"><a href="/customer/inquiryList.asp"><span>고객의소리</span></a></li>
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
					<form name="mq" id="mq" method="post" onsubmit="return false">
						<ul class="inq">
							<li>
								<select name="q_type" class="w-100p">
									<option value="가맹문의">가맹문의</option>
									<option value="매장문의">매장문의</option>
									<option value="메뉴문의">메뉴문의</option>
									<option value="불친절매장신고">불친절매장신고</option>
									<option value="기타문의">기타문의</option>
								</select>
							</li>
							<li><label data-txt="작성일" class="before-txt"><input type="text" value="<%=FormatDateTime(Date,2)%>" readonly class="w-100p"></label></li>
							<li><input type="text" placeholder="글제목" name="title" class="w-100p"></li>
							<li><textarea name="body" id="body" placeholder="내용" style="height:230px;" class="w-100p"></textarea></li>
						</ul>
						<!-- <ul class="ui-file mar-t30">
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
						</ul> -->
						<div class="mar-t70">
							<button type="button" onclick="javascript:validQ();" class="btn btn-lg btn-red w-100p"><span>등록</span></button>
						</div>
					</form>
				</div>
			</section>
			<!-- //1:1문의 -->


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
