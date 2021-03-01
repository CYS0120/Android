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
					location.href = "/mypage/inquiryList.asp";
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
                        <li class="on"><a href="/customer/inquiryWrite.asp"><span>고객의소리</span></a></li>
                    </ul>
                </div>
                <!--// Tab -->

                <!-- 고객센터 상단 -->
                <section class="section section-Csinfo">
                    <div class="inner">
                        <p class="img ico-hear"><span class="ico-only">Q&amp;A</span></p>
                        <div class="tit">
                            언제나 고객님을 향해 열려 있습니다.<br />
                            사소한 질문이라도 정성껏 답변하여 드리겠습니다.
                        </div>
                        <p class="txt">
                            고객님께서 자주 문의하시거나 궁금해하는 질문들을 모아서 정리하였습니다. 찾으시는 내용이 없거나 궁금한 사항이 있으면 고객의 소리에 의견을 남겨주세요. 고객님의 새로운
                            행복을 위해서 언제나 최선을 다하는 BBQ가 되겠습니다.
                        </p>
                    </div>
                </section>
                <!-- //고객센터 상단 -->

                <!-- 1:1문의 -->
                <section class="section section_inq mar-t60">
                    <div class="inner">
				
						<form name="mq" id="mq" method="post" onsubmit="return false;">
						<input type="hidden" id="UPFILE_DIR" value="/bbq_d/inquiry">
						<input type="hidden" name="branch_id" value="">

						<ul class="inq">
							<li><label data-txt="브랜드" class="before-txt"><input type="text" value="BBQ치킨" readonly class="w-100p"></label>
							</li>
							<li>
								<input type="text" id="branch_name" name="branch_name" readonly class="w-250 mar-r15">
								<button class="btn file_btn h-47 store_search" onclick="javascript:lpOpen('.lp_store');">매장찾기</button>
							</li>
							<li>
								<select name="q_type" id="" class="w-100p">
									<option value="가맹문의">가맹문의</option>
									<option value="매장문의">매장문의</option>
									<option value="메뉴문의">메뉴문의</option>
									<option value="불친절매장신고">불친절매장신고</option>
									<option value="기타문의">기타문의</option>
								</select>
							</li>
							<li><label data-txt="작성자" class="before-txt"><input type="text" name="member_name" value="<%=Session("userName")%>" readonly class="w-100p"></label>
							</li>
							<li><label data-txt="연락처" class="before-txt"><input type="text" name="member_hp" value="<%=Replace(Session("userPhone"),"+82","0")%>" readonly class="w-100p"></label>
							</li>
							<li><label data-txt="작성일" class="before-txt"><input type="text" value="<%=FormatDateTime(Date,2)%>" readonly class="w-100p"></label></li>
							<li><input type="text" placeholder="글제목" name="title" class="w-100p"></li>
							<li><textarea name="body" id="body" placeholder="내용" style="height:230px;" class="w-100p"></textarea></li>
						</ul>
						<ul class="ui-file mar-t30">
						<li>
							<label for="">
								<span class="btn btn-sm btn-brown" onClick="OpenUploadFILE('FILENAME','UPFILE_DIR')">첨부파일 선택</span>
								<input type="text" id="FILENAME" name="FILENAME" readonly placeholder="선택된 파일 없음">
							</label>
						</li>
						</ul>
						<div class="mar-t70">
							<button type="button" onclick="javascript:validQ();"
								class="btn btn-lg btn-red w-100p"><span>등록</span></button>
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


	
	<!-- Layer Popup : 매장찾기 -->
    <div id="lp_store" class="lp-wrapper lp_store">
        <!-- LP Wrap -->
        <div class="lp-wrap">
            <div class="lp-con">
                <!-- LP Header -->
                <div class="lp-header">
                    <h2>BBQ 매장찾기</h2>
                    <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
                </div>
                <!--// LP Header -->
                <!-- LP Container -->
                <div class="lp-container">
                    <!-- LP Content -->
                    <div class="lp-content mar-t20">
                        <section class="section2">
							<div class="area ">
								<div class="wrap">
									<input class="w-100p store_input" type="text" id="txtBranch" placeholder="매장명 입력">
									<button type="button" onclick="javascript:Store_Search();" class="btn btn-md2 btn-black mar-t20 cen">검색</button>
								</div>
							</div>
							<div class="hidden_wrap">
								<div class="hidden_scroll">
									<div class="btn-wrap pad-t40 bg-white">

										<table border="1" cellspacing="0" class="tbl-list">
											<caption></caption>
											<colgroup>
												<col style="width:20%;">
												<col>
												<col style="width:20%">
											</colgroup>
											<thead id="branch_div">
												<tr>
													<th colspan="3">매장명 검색을 통해 매장을 찾아주세요.</th>
												</tr>
											</thead>
										</table>
									</div>
								</div>
							</div>
                        </section>
                        <!--// LP Content -->
                    </div>
                    <!--// LP Container -->

                </div>
            </div>
            <!--// LP Wrap -->
        </div>
        <!--// Layer Popup -->
