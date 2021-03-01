<!--#include virtual="/api/include/utf8.asp"-->
<!doctype html>
<html lang="ko">

<head>
    <!--#include virtual="/includes/top.asp"-->
    <!--include virtual="/api/include/requireLogin.asp"-->
    <meta name="Keywords" content="고객센터, BBQ치킨">
    <meta name="Description" content="고객센터 메인">
    <title>고객센터 | BBQ치킨</title>
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
                success: function(res) {
                    alert(res.message);
                    if (res.result == 0) {
                        location.href = "/mypage/inquiryList.asp";
                    }
                }
            });
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
                                        <input type="text" name="title" value="" class="w-250 mar-r15">
                                        <button class="btn file_btn h-47" onclick="javascript:lpOpen('.lp_store');">매장찾기</button>
                                    </td>
                                </tr>
                                <tr>
                                    <th>분류</th>
                                    <td>
                                        <select name="q_type" class="w-250">
                                            <option value="가맹문의">가맹문의</option>
                                            <option value="매장문의">매장문의</option>
                                            <option value="메뉴문의">메뉴문의</option>
                                            <option value="불친절매장신고">불친절매장신고</option>
                                            <option value="기타문의">기타문의</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th>작성자</th>
                                    <td>
                                        <input type="text" name="title" value="" class="w-250">
                                    </td>
                                </tr>
                                <tr>
                                    <th>연락처</th>
                                    <td>
                                        <input type="text" name="title" value="" class="w-100p">
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
                                    <td><button class="btn file_btn">첨부파일 등록</button></td>
                                </tr>
                                <tr>
                                    <th>내용</th>
                                    <td>
                                        <textarea name="body" class="w-100p h-200"></textarea>
                                    </td>
                                </tr>
                                <!-- <tr>
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
						</tr> -->
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

        <!-- Footer -->
        <!--#include virtual="/includes/footer.asp"-->
        <!--// Footer -->
    </div>

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
                            <form id="lpstore_form" action="/order/lpstore.asp">
                                <input type="hidden" id="lpstore_data" name="lpstore_data">
                                <div class="area ">
                                    <div class="wrap">
                                        <input class="w-100p" type="text" id="txtPIN" name="txtPIN" placeholder="매장명 입력">
                                        <button type="button" onclick="javascript:lpstore_Check();" class="btn btn-md2 btn-black mar-t20 cen">검색</button>
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
                                                <thead>
                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>
                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>
                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>
                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>
                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>
                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>

                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>
                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>
                                                    <tr>
                                                        <th>매장명</th>
                                                        <td class="ta-l">패밀리타운점</td>
                                                        <th> <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-sm btn-black btn_confirm"><span>확인</span></button></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <!--
								<tr id="selected_branch">
<%
	If branch_data = "" Then
%>									
									<td colspan="5" class="noData">매장명 검색을 통해 매장을 찾아주세요.</td>
<%
	Else
		Set bJson = JSON.Parse(branch_data)
%>
									<td>포장매장</td>
									<td><%=bJson.branch_name%></td>
									<td><%=bJson.branch_tel%></td>
									<td><%=bJson.branch_address%></td>
									<td><button type="button" onclick="selectPickAddress(<%=bJson.branch_id%>);" class="btn btn-sm btn-redLine">선택</button></td>
<%
		Set bJson = Nothing
	End If
%>
								</tr>
-->
                                                </tbody>
                                            </table>
                                            <!--
    
                                    <button type="button" onclick="javascript:lpstore_Order();" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
-->
                                        </div>

                                    </div>
                                </div>
                            </form>
                        </section>

                        <!--// LP Content -->
                    </div>
                    <!--// LP Container -->

                </div>
            </div>
            <!--// LP Wrap -->
        </div>
        <!--// Layer Popup -->
</body>

</html>