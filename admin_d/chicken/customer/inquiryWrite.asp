<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/meta.asp"-->
<meta name="Keywords" content="고객센터, BBQ치킨">
<meta name="Description" content="고객센터 메인">
<title>고객센터 | BBQ치킨</title>
<!--#include virtual="/includes/styles.asp"-->
<!--#include virtual="/includes/scripts.asp"-->
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
				<li><a href="#" onclick="javascript:return false;">bbq home</a></li>
				<li>고객센터</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<h1 class="ta-l">고객센터</h1>
			<div class="tab-wrap tab-type3 leng2">
				<ul class="tab">
					<li><a href="./faqList.asp"><span>자주 묻는질문</span></a></li>
					<li class="on"><a href="./inquiryWrite.asp"><span>고객의 소리</span></a></li>
				</ul>
			</div>

			<div class="icon-top">
				<div class="img"><img src="/images/customer/ico_big_cs.gif" alt=""></div>
				<h3>언제나 고객님을 향해 열려 있습니다. 사소한 질문이라도 정성껏 답변하여 드리겠습니다.</h3>
				<p>
					고객의 소리를 통해 질문하신 내용에 대한 답변은 마이 페이지를 통해 확인하실 수 있습니다. 광고성 글은 관리자가 임의로 삭제처리 합니다. <br/>
					고객의 소리는 더 나은 서비스와 품질개선을 위하여 가맹점과 공유 중에 있습니다. 본문 상에 고객정보 입력은 자제하여 주시기 바랍니다. 
				</p>
			</div>

			<div class="boardList-wrap">
				<table border="1" cellspacing="0" class="tbl-write type2">
					<caption>기본정보</caption>
					<colgroup>
						<col style="width:283px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th>브랜드</th>
							<td>
								<select class="w-250">
									<option value="" selected="">BBQ치킨</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>분류</th>
							<td>
								<select class="w-250">
									<option value="" selected="">칭찬합니다</option>
								</select>
							</td>
						</tr>
						<tr>
							<th>작성일</th>
							<td>
								<input type="text" value="2019-01-05" class="w-250">
							</td>
						</tr>
						<tr>
							<th>글제목</th>
							<td>
								<input type="text" value="" class="w-100p">
							</td>
						</tr>
						<tr>
							<th>내용</th>
							<td>
								<textarea name="" id="" class="w-100p h-200"></textarea>
							</td>
						</tr>
						<tr>
							<th>첨부파일 1</th>
							<td>
								<label class="ui-file">
									<input type="text" readonly>
									<input type="file" onchange="fileDes(this);" id="fileupload">
									<span class="btn btn-md3 btn-brown">첨부파일 선택</span>
								</label>
							</td>
						</tr>
						<tr>
							<th>첨부파일 2</th>
							<td>
								<label class="ui-file">
									<input type="text" readonly>
									<input type="file" onchange="fileDes(this);" id="fileupload">
									<span class="btn btn-md3 btn-brown">첨부파일 선택</span>
								</label>
								<span class="fs14">*첨부 가능한 파일 타입 : jpg,gif,png,bmp</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div class="btn-wrap two-up inner mar-t60">
				<button type="submit" class="btn btn-lg btn-red"><span>등록</span></button>
				<button type="button" class="btn btn-lg btn-grayLine"><span>취소</span></button>
			</div>

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
