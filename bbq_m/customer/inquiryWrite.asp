<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">

<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<script type="text/javascript">
	function validQ() {
		if ($.trim($("#mq [name=title]").val()) == "") {
			alert("제목을 입력하세요.");
			$("#mq [name=title]").focus();
			return false;
		}

		if ($.trim($("#mq [name=body]").val()) == "") {
			alert("내용을 입력하세요.");
			$("#mq [name=body]").focus();
			return false;
		}

		$.ajax({
			method: "post",
			url: "inquiryProc.asp",
			data: $("#mq").serialize(),
			dataType: "json",
			success: function (res) {
				alert(res.message);
				if (res.result == 0) {
//					location.href = "/mypage/inquiryList.asp";
					location.href = "./inquiryList.asp";
				}
			}
		})
	}
	function Store_Search(){
		SW = $('#txtBranch').val();
		$.ajax({
			async: true,
			type: "POST",
			url: "inquirybranch.asp",
			data: {"SW":SW},
			cache: false,
			dataType: "html",
			success: function (data) {
				if ( data.replace(/^\s\s*/, '').replace(/\s\s*$/, '').length == 0 ) {
				}else{
					$("#branch_div").html(data);
				}
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
			}
		});
	}
	function SetStore(BID, BNM){
		$('#branch_id').val(BID);
		$('#branch_name').val(BNM);
		$('#lp_store').closest(".lp-wrapper").stop().fadeOut('fast');
    }
    
	function Check_Input(){
		document.inputfrm.submit();
	}

	function fileOpen(el,FIELD) {
		var $el = $(el);
		$('#FILEFIELD').val(FIELD);
		$el.stop().fadeIn('fast');
	}
    function SetFileName(FNAME){
		var FILEFIELD = $('#FILEFIELD').val();
		$('#'+FILEFIELD).val(FNAME);
		lpClose('.lp_file_upload');
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

			<!-- 고객의소리 상단 -->
			<section class="section-Csinfo inbox1000">
				<div class="tit">
					언제나 고객님을 향해 열려 있습니다.<br />
					사소한 질문이라도 정성껏 답변하여 드리겠습니다.
				</div>
				<p class="txt">
					고객님께서 자주 문의하시거나 궁금해하는 질문들을 모아서 정리하였습니다. 찾으시는 내용이 없거나 궁금한 사항이 있으면 고객의 소리에 의견을 남겨주세요. 고객님의 새로운 행복을 위해서 언제나 최선을 다하는 BBQ가 되겠습니다.

				</p>
			</section>
			<!-- //고객의소리 상단 -->

			<!-- 1:1문의 -->
			<section class="section_inq inbox1000">
				<form name="mq" id="mq" method="post" onsubmit="return false;">
				<input type="hidden" id="UPFILE_DIR" value="/bbq_d/inquiry">
				<input type="hidden" name="branch_id" value="">

				<ul class="inq">
					<li><label data-txt="브랜드" class="before-txt"><input type="text" value="BBQ치킨" readonly  class="w-100p"></label></li>
					<li>
						<input type="text" id="branch_name" name="branch_name" readonly class="w-100 mar-r5">
						<button class="btn btn-gray btn_small3" onclick="javascript:lpOpen('.lp_store');">매장찾기</button>
					</li>
					<li>
						<select name="q_type" id="" class="w-100p">
							<option value="가맹문의">가맹문의</option>
							<option value="매장문의">매장문의</option>
							<option value="메뉴문의">메뉴문의</option>
							<option value="불친절매장신고">불친절매장신고</option>
							<option value="쿠폰재발행">쿠폰재발행</option>
							<option value="기타문의">기타문의</option>
						</select>
					</li>
					<li><label data-txt="작성자" class="before-txt"><input type="text" name="member_name" value="<%=Session("userName")%>" readonly class="w-100p"></label></li>
					<li><label data-txt="연락처" class="before-txt"><input type="text" name="member_hp" value="<%=Replace(Session("userPhone"),"+82","0")%>" readonly class="w-100p"></label></li>
					<li><label data-txt="작성일" class="before-txt"><input type="text" value="<%=FormatDateTime(Date,2)%>" readonly class="w-100p"></label></li>
					<li><input type="text" placeholder="글제목" name="title" class="w-100p"></li>
					<li><textarea name="body" id="body" placeholder="내용" style="height:200px;" class="w-100p"></textarea></li>
				</ul>
				<ul class="ui-file">
					<li>
						<label for="">
							<span class="btn btn-file btn-brown" onclick="javascript:fileOpen('.lp_file_upload','FILENAME');">첨부파일 선택</span>
							<input type="text" id="FILENAME" name="FILENAME" readonly placeholder="선택된 파일 없음">
						</label>
					</li>
					<li>
						<label for="">
							<span class="btn btn-file btn-brown" onclick="javascript:fileOpen('.lp_file_upload','FILENAME2');">첨부파일 선택</span>
							<input type="text" id="FILENAME2" name="FILENAME2" readonly placeholder="선택된 파일 없음">
						</label>
					</li>
					<li>
						<label for="">
							<span class="btn btn-file btn-brown" onclick="javascript:fileOpen('.lp_file_upload','FILENAME3');">첨부파일 선택</span>
							<input type="text" id="FILENAME3" name="FILENAME3" readonly placeholder="선택된 파일 없음">
						</label>
					</li>
				</ul>
				<div class="btn-wrap one mar-t20">
					<button type="button" onclick="javascript:validQ();" class="btn btn_middle btn-red">등록</button>
				</div>

				</form>
				<input type="hidden" id="FILEFIELD">
			</section>
			<!-- //1:1문의 -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<iframe name="procframe" src="" width="100%" height="100" style="display:none"> </iframe>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


    <!-- Layer Popup : 매장찾기 -->
    <div id="lp_store" class="lp-wrapper lp_store">
        <!-- LP Wrap -->
        <div class="lp-wrap">
            <div class="lp-con">






                <!-- LP Header -->
                <div class="lp-header">
                    <h2>매장찾기</h2>
                    <button type="button" class="btn btn_lp_close" onclick="lpClose2(this);"><span>레이어팝업 닫기</span></button>
                </div>
				<!--// LP Header -->
				
                <!-- LP Container -->
                <div class="lp-container">

                    <!-- LP Content -->
                    <div class="lp-content">
                        <section class="inbox1000">
							<div class="area ">
								<div class="wrap inquiry_shop">
									<input class="" type="text" id="txtBranch" placeholder="매장명 입력">
									<button type="button" onclick="javascript: Store_Search();" class="btn-sch"><img src="/images/order/btn_search.png" alt="검색"></button>
								</div>
							</div>
							<div class="hidden_wrap">
								<div class="hidden_scroll tbl_shopList">
									<table border="0" cellspacing="0">
										<caption></caption>
										<colgroup>
											<col width="*">
											<col width="70px">
										</colgroup>
										<thead id="branch_div">
											<tr>
												<th colspan="2">매장명 검색을 통해 매장을 찾아주세요.</th>
											</tr>
										</thead>
									</table>
								</div>
							</div>
                        </section>
					</div>
					<!--// LP Content -->	
									
				</div>
				<!--// LP Container -->					
			</div>
		</div>
		<!--// LP Wrap -->
		
	</div>
	<!--// Layer Popup -->

	<iframe name="procframe" src="" width="100%" height="100" style="display:none"> </iframe>


	<!-- Layer Popup : 파일 업로드 -->
	<div id="LP_file_upload" class="lp-wrapper lp_file_upload">

		<!-- LP Wrap -->
		<div class="lp-wrap">
			<div class="lp-con">
				<!-- LP Header -->
				<div class="lp-header">
					<h2>파일 업로드</h2>
					<!--<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>-->
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<section class="section2">
							<form id="inputfrm" name="inputfrm" method="POST" enctype="multipart/form-data" action="<%=FILE_SERVERURL%>/file_save.asp" target="procframe">
								<input type="hidden" name="FILEID" value="FILESEARCH">
								<input type="hidden" name="UPDIR" value="/bbq_d/inquiry">
								<input type="hidden" name="RTURL" value="<%=Request("HTTP_HOST")%>">
								
								<div class="file_wrap">
									<table>
										<colgroup>
											<col width="15%">
											<col width="85%">
										</colgroup>
										<tbody>
											<tr>
												<td>
													<div class="filebox">
														<input id="FILENAME_TXT" class="upload-name" value="파일선택" disabled="disabled">
														<label for="FILESEARCH">찾아보기</label>
														<input type="file" name="FILENAME" id="FILESEARCH" onchange="$('#FILENAME_TXT').val(this.value)" class="upload-hidden">
													</div>
												</td>
											</tr>
											<tr>
												<!-- <td  class="text_left">
													asp, aspx, html, php, jsp, exe, js, vbs, xml 등 서버에 영향을 주는 파일 업로드 금지
												</td> -->
												<td class="text_left">
													첨부파일은 jpg,png,pdf 만 업로드 가능 합니다.<br>모바일 환경에서는 파일첨부에 시간이 걸릴 수 있습니다.
												</td>
											</tr>
										</tbody>
									</table>
									<div class="file_btn">
										<input type="button" class="btn_middle btn-red " onclick="Check_Input()" value="등록">
										<input type="button" class="btn_middle btn-grayLine " value="닫기" onclick="lpClose(this);">
									</div>
								</div>
							</form>
						</section>
						<!--// LP Content -->
					</div>
					<!--// LP Container -->
					</div>
				</div>
			</div>
			<!--// lp-con -->
		</div>
		<!--// LP Wrap -->

	</div>