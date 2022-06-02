<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<script>
	jQuery(document).ready(function(e) {

		$(window).on('scroll', function(e) {
			if ($(window).scrollTop() > 0) {
				$(".wrapper").addClass("scrolled");
			} else {
				$(".wrapper").removeClass("scrolled");
			}
		});
	});
</script>
<script type="text/javascript">
var ClickCheck = 0;

	function validQ() {
		if (ClickCheck == 1){
			alert("처리중입니다. 잠시만 기다려주세요.");
			return false;
		}

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

        ClickCheck = 1;

        $.ajax({
			method: "post",
			url: "inquiryProc.asp",
			data: $("#mq").serialize(),
			dataType: "json",
			success: function(res) {
				alert(res.message);
				if (res.result == 0) {
					location.href = "/mypage/inquiryList.asp";
				} else {
                    ClickCheck = 0;
                }
			}, error: function(){
                ClickCheck = 0;
            }
		});
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
		$(".lp_focus").focus();
		$(".lp_focus").removeClass(".lp_focus");
		$('html').css('overflow','');
	}
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
                        고객의 소리를 통해 질문하신 내용에 대한 답변은 마이 페이지를 통해 확인하실 수 있습니다. 광고성 글은 관리자가 임의로 삭제처리 합니다. <br />
                        고객의 소리는 더 나은 서비스와 품질개선을 위하여 가맹점과 공유 중에 있습니다. 본문 상에 고객정보 입력은 자제하여 주시기 바랍니다.
                    </p>
                </div>

                <div class="boardList-wrap">
<form id="mq" name="mq" onsubmit="return false;">
<input type="hidden" id="UPFILE_DIR" value="/bbq_d/inquiry">
<input type="hidden" name="branch_id" value="">
                        <table border="1" cellspacing="0" class="tbl-write type2">
                            <caption>기본정보</caption>
                            <colgroup>
                                <col style="width:283px;">
                                <col style="width:auto;">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>브랜드</th>
                                    <td>BBQ치킨<input type="hidden" name="brand_code" value="01"></td>
                                </tr>
                                <tr>
                                    <th>매장명</th>
                                    <td>
                                        <input type="text" id="branch_name" name="branch_name" readonly class="w-250 mar-r15">
                                        <button class="btn file_btn h-47" onclick="javascript:lpOpen('.lp_store');">매장찾기</button>
                                    </td>
                                </tr>
                                <tr>
                                    <th>분류</th>
                                    <td>
                                        <select name="q_type" class="w-250">
                                            <option value="주문 거부">주문 거부</option>
                                            <option value="E쿠폰/상품권 주문 거부">E쿠폰/상품권 주문 거부</option>
                                            <option value="제품 품질 불만">제품 품질 불만</option>
                                            <option value="이물질">이물질</option>
                                            <option value="품목 미제공(치킨무 등)">품목 미제공(치킨무 등)</option>
                                            <option value="자사앱/온라인 주문 불편">자사앱/온라인 주문 불편</option>
                                            <option value="매장/고객센터 응대 불만">매장/고객센터 응대 불만</option>
                                            <option value="현금영수증 미발급">현금영수증 미발급</option>
                                            <option value="기타 불만">기타 불만</option>
                                            <option value="문의사항(메뉴, 매장, 가맹, 기타)">문의사항(메뉴, 매장, 가맹, 기타)</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>작성자</th>
                                    <td>
                                        <input type="text" name="member_name" value="<%=Session("userName")%>" class="w-250" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <th>연락처</th>
                                    <td>
                                        <input type="text" name="member_hp" value="<%=Replace(Session("userPhone"),"+82","0")%>" class="w-250" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <th>작성일</th>
                                    <td>
                                        <%=FormatDateTime(Date,2)%>
                                    </td>
                                </tr>
                                <tr>
                                    <th>글제목</th>
                                    <td>
                                        <input type="text" name="title" value="" class="w-100p">
                                    </td>
                                </tr>
                                <tr>
                                    <th>파일첨부</th>
                                    <td>
										<input type="text" id="FILENAME" name="FILENAME" readonly class="w-250 mar-r15">
										<button type="button" class="btn file_btn" onClick="OpenUploadFILE('FILENAME','UPFILE_DIR')">첨부파일 등록</button>
										<br>
										<input type="text" id="FILENAME2" name="FILENAME2" readonly class="w-250 mar-t15 mar-r15">
										<button type="button" class="btn file_btn mar-t15" onClick="OpenUploadFILE('FILENAME2','UPFILE_DIR')">첨부파일 등록</button>
										<br>
										<input type="text" id="FILENAME3" name="FILENAME3" readonly class="w-250 mar-t15 mar-r15">
										<button type="button" class="btn file_btn mar-t15" onClick="OpenUploadFILE('FILENAME3','UPFILE_DIR')">첨부파일 등록</button>
									</td>
                                </tr>
                                <tr>
                                    <th>내용</th>
                                    <td>
                                        <textarea name="body" class="w-100p h-200"></textarea>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </form>
                </div>

                <div class="btn-wrap two-up inner mar-t60">
                    <button type="button" onclick="javascript:validQ();" class="btn btn-lg btn-red"><span>등록</span></button>
                    <button type="button" onclick="javascript:history.back();" class="btn btn-lg btn-grayLine"><span>취소</span></button>
                </div>

            </article>
            <!--// Content -->

            <!-- QuickMenu -->
            <!--#include virtual="/includes/quickmenu.asp"-->
            <!-- QuickMenu -->

        </div>
        <!--// Container -->
        <hr>
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
									<input class="w-100p" type="text" id="txtBranch" placeholder="매장명 입력">
									<button type="button" onclick="javascript:Store_Search();" class="btn btn-md2 btn-black mar-t20 cen">검색</button>
								</div>
							</div>
							<div class="hidden_wrap">
								<div class="hidden_scroll">
									<div class="btn-wrap pad-t40 bg-white">

										<table border="1" cellspacing="0" class="tbl-list">
											<caption></caption>
											<colgroup>
												<col style="width:120px;">
												<col>
												<col style="width:120px">
											</colgroup>
											<thead id="branch_div">
												<tr>
													<th colspan="3">매장명 검색을 통해 매장을 찾아주세요.</th>
												</tr>
											</thead>
											<!--tbody>
												<tr id="selected_branch">
													<td colspan="5" class="noData">매장명 검색을 통해 매장을 찾아주세요.</td>
												</tr>
											</tbody-->
										</table>
									</div>
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
        <!-- Footer -->
        <!--#include virtual="/includes/footer.asp"-->
        <!--// Footer -->
    </div>


</body>
</html>