<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/db_open.asp"-->

<%
    Dim aCmd, aRs
%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->

<script type="text/javascript">
    var idx = 0;

    function checkOrder() {
        var clen = localStorage.length;

        if(clen > 0) {
            var od = [];

            for(var i = 0; i < clen; i++) {
                var k = localStorage.key(i);
                var v = JSON.parse(localStorage.getItem(k));

                var t = {};
                t.code = k;
                t.value = v;

                od.push(t);
            }

            $("#item_data").val(JSON.stringify(od));
            $("#order_form").submit();
        } else {
            alert("주문할 메뉴가 없습니다.");
        }
    }

    $(function(){
        drawSM();
    });
    function addMenu() {
        var sm = $("#menu_item").val();

        if(sm != "") {
            var smV = {};
            var smA = sm.split("_");
            var smName = $("#menu_item :selected").text();
            smV.cd = smA[1];
            smV.nm = smName;
            smV.opt = smA[2];
            smV.qty = 1;
            smV.price = smA[3];

            addCartMenu(sm, JSON.stringify(smV));

        }
    }

    function drawSM() {
        var len = localStorage.length;
        var item_amt = 0;

        $("#order_table").html("");

        for(var i = 0; i < len; i++) {
            var k = localStorage.key(i);
            var si = JSON.parse(localStorage.getItem(k));

            item_amt += Number(si.price) * Number(si.qty);
            var html = "";

            html = "<div class=\"tr\" id=\"tr_"+i+"\">\n";
            html += "\t<div class=\"td img\">\n";
            html += "\t\t<img src=\"http://placehold.it/160x160?text=1\" alt>\n";
            html += "\t</div>\n";
            html += "\t<div class=\"td info\">\n";
            html += "\t\t<div class=\"sum\">\n";
            html += "\t\t\t<dl>\n";
            html += "\t\t\t\t<dt>"+si.nm+"</dt>\n";
            html += "\t\t\t\t<dd>"+numberWithCommas(Number(si.price))+"원 <span>/ "+si.qty+"개</span></dd>\n";
            html += "\t\t\t</dl>\n";
            html += "\t\t</div>\n";
            html += "\t\t<div class=\"mar-t15 ta-r\">\n";
            html += "\t\t\t<button type=\"button\" class=\"btn btn-sm btn-brown\">사이드/수량변경<button>\n";
            html += "\t\t</div>\n";
            html += "\t\t<button type=\"button\" class=\"btn_del\" onClick=\"javascript:delCartMenu('"+k+"')\">삭제</button>\n";
            html += "\t</div>\n";
            html += "</div>";

            $("#order_table").append(html);
        }

        $("#item_amount").val(item_amt);
        $("#total_amount").val(item_amt+2000);

        $("#item_amt").text(numberWithCommas(item_amt)+"원");
        $("#total_amt").html(numberWithCommas(item_amt+2000)+"<span>원</span>");
    }

    function supportStorage() {
        return typeof(Storage) !== "undefined";
    }

    function addCartMenu(key, value) {
        if(supportStorage()) {
            if(hasCartMenu(key)) {
                var item = JSON.parse(localStorage.getItem(key));
                var vo = JSON.parse(value);
                item.qty += vo.qty;
                value = JSON.stringify(item);
            }
            localStorage.setItem(key, value);
            drawSM();
        }
    }

    function hasCartMenu(key) {
        if(supportStorage()) {
            var str = localStorage.getItem(key);

            if(str === null || str === undefined || str == "undefined") {
                return false;
            } else {
                return true;
            }
        }
        return true;
    }

    function delCartMenu(key) {
        if(supportStorage()) {
            if(hasCartMenu(key)) {
                localStorage.removeItem(key);
                drawSM();
            }
        }
    }

    function setDeliveryAddress(obj) {

    }
</script>

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "장바구니"
	%>
    <!--#include virtual="/includes/header.asp"-->

	<%

	%>

    <!-- Container -->
    <div class="container">

        <!-- Aside -->
        <!--#include virtual="/includes/aside.asp"-->
        <!--// Aside -->
            
        <!-- Content -->
        <article class="content">

			<%
				Dim addr_idx : addr_idx = Request("addr_idx")

				If IsEmpty(addr_idx) Or IsNull(addr_idx) Or Trim(addr_idx) = "" Or Not IsNumeric(addr_idx) Then addr_idx = ""

				Set aCmd = Server.CreateObject("ADODB.Command")
				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_member_addr_select"

					.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
					If addr_idx = "" Then
						.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 20, "MAIN")
					Else
						.Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)
					End If

					Set aRs = .Execute
				End With
				Set aCmd = Nothing

				If Not (aRs.BOF Or aRs.EOF) Then
					addr_idx = aRs("addr_idx")
					address = aRs("address_main") & " " & aRs("address_detail")
				End If
			%>

            <!-- 상단 배달정보 -->
            <section class="section section_cartSum">
                <dl>
                    <dt>배달매장 :</dt>
                    <dd><span class="red">구로점</span> <em>(02-123-4567)</em></dd>
                </dl>
                <dl class="address">
                    <dt>배달주소 :</dt>
                    <dd><span class="txt_overflow"><%=address%></span> <button type="button" onclick="javascript:lpOpen('.lp_orderShipping');" class="btn btn-sm btn-grayLine btn_lp_open">변경</button></dd>
                </dl>
            </section>
            <!-- //상단 배달정보 -->

            <!-- 장바구니 리스트 -->
            <section class="section section_orderDetail pad-t0">
                <select id="menu_item">
                    <option value="C_1_0_19000">NEW 치킨강정</option>
                    <option value="C_2_0_19000">골뱅이치킨</option>
                    <option value="C_3_0_18000">황금올리브치킨</option>
                    <option value="C_4_0_19500">자메이카 통다리 구이</option>
                    <option value="C_5_0_19000">황금올리브닭다리</option>
                    <option value="C_6_0_20000">황금올리브닭다리(반반)</option>
                    <option value="C_7_0_19900">써프라이드</option>
                    <option value="C_8_0_18000">순살크래커</option>
                    <option value="C_9_0_18000">황금올리브핫윙</option>
                    <option value="C_10_0_19000">황금올리브치킨(반반)</option>
                    <option value="C_11_0_17000">황금올리브속안심</option>
                    <option value="C_12_0_19500">시크릿 양념치킨</option>
                    <option value="C_13_0_19000">치즐링</option>
                    <option value="C_14_0_16000">바삭칸 치킨</option>
                    <option value="C_15_0_17000">바삭칸 치킨(반반)</option>
                    <option value="C_16_0_18900">마라 핫치킨</option>
                    <option value="C_17_0_19000">빠리치킨(윙)</option>
                    <option value="C_18_0_19000">빠리치킨(한마리)</option>
                    <option value="C_19_0_18000">순살바삭칸치킨</option>
                    <option value="C_20_0_17000">스모크 치킨</option>
                    <option value="C_21_0_19500">매달구(윙)</option>
                    <option value="S_22_0_18900">허니갈릭스</option>
                    <option value="S_23_0_18900">소이갈릭스</option>
                    <option value="S_24_0_500">양념소스</option>
                    <option value="S_25_0_500">비비소스</option>
                    <option value="S_26_0_500">스모크 소스</option>
                    <option value="S_27_0_500">순살크래커 소스</option>
                    <option value="S_28_0_500">치킨무</option>
                    <option value="S_29_0_1000">콜라 355ml</option>
                    <option value="S_30_0_1500">콜라 500ml</option>
                    <option value="S_31_0_2000">콜라 1.25L</option>
                    <option value="S_32_0_4000">NEW포테이토</option>
                    <option value="S_33_0_5000">NEW포테이토(딥치즈)</option>
                    <option value="S_34_0_5000">NEW포테이토(스윗허니)</option>
                    <option value="S_35_0_3000">올치팝(컵)</option>
                    <option value="S_36_0_3000">올치팝(콜)</option>
                    <option value="S_37_0_5000">올치팝(맥)</option>
                    <option value="S_38_0_4500">쉐킷쉐킷 치즈맛</option>
                    <option value="S_39_0_4500">쉐킷쉐킷바베큐맛</option>
                    <option value="S_40_0_3000">고구마스틱</option>
                    <option value="S_41_0_4000">오징어스틱</option>
                    <option value="S_42_0_3000">치즈 스틱</option>
                    <option value="S_43_0_1000">콘 샐러드</option>
                    <option value="S_44_0_1000">코울슬로</option>
                    <option value="S_45_0_4000">슈스트링</option>
                </select>
                <input type="button" value="추가" onclick="addMenu();">
                <div class="order_menu">
                    <div class="box div-table" id="order_table">
                        <!-- <div class="tr">
                            <div class="td img"><img src="http://placehold.it/160x160?text=1" alt=""></div>
                            <div class="td info">
                                <div class="sum">
                                    <dl>
                                        <dt>자메이카 + 올치팝(컵)</dt>
                                        <dd>18,000원 <span>/ 1개</span></dd>
                                    </dl>
                                </div>
                                <div class="mar-t15 ta-r">
                                    <button type="button" class="btn btn-sm btn-brown">사이드/수량변경</button>
                                </div>
                                <button type="button" class="btn_del">삭제</button>
                            </div>
                        </div> -->
                    </div>
                </div>

                <div class="mar-t40">
                    <button type="button" class="btn btn-md btn-redLine w-100p">+ 다른 메뉴 추가하기</button>
                </div>

                <div class="order_calc">
                    <div class="top div-table mar-t30">
                        <dl class="tr">
                            <dt class="td">총 상품금액
                            </dt><dd class="td" id="item_amt">0원</dd>
                        </dl>
                        <dl class="tr">
                            <dt class="td">배달비
                            </dt><dd class="td" id="delivery_fee">2,000원</dd>
                        </dl>
                    </div>
                    <div class="bot div-table">
                        <dl class="tr">
                            <dt class="td">합계</dt>
                            <dd class="td" id="total_amt">0<span>원</span></dd>
                        </dl>
                    </div>
                </div>

                <div class="mar-t40">
                    <button type="submit" class="btn btn-lg btn-red w-100p" onClick="javascript:checkOrder();">주문하기</button>
                </div>
            </section>
            <!-- //장바구니 리스트 -->

            <!-- Layer Popup : 배달지 입력 -->
            <div id="LP_orderShipping" class="lp-wrapper lp_orderShipping">
                <!-- LP Header -->
                <div class="lp-header">
                    <h2>주문 방법 선택</h2>
                </div>
                <!--// LP Header -->
                <!-- LP Container -->
                <div class="lp-container">
                    <!-- LP Content -->
                    <div class="lp-content">
                        <form action="">

                            <!-- 주문 타입 선택 -->
                            <div class="inner">
                                <ul class="order-moveType">
                                    <li>
                                        <label class="ui-radio">
                                            <input type="radio" name="moveType" checked>
                                            <span></span> 배달주문
                                        </label>
                                    </li>
                                   <!--  <li>    
                                        <label class="ui-radio">
                                            <input type="radio" name="moveType">
                                            <span></span> 포장주문
                                        </label>
                                    </li> -->
                                </ul>
                            </div>
                            <!-- //주문 타입 선택 -->

                            <section class="section section_shipList mar-t40">

								<%
									Set aCmd = Server.CreateObject("ADODB.Command")

									With aCmd
										.ActiveConnection = dbconn
										.NamedParameters = True
										.CommandType = adCmdStoredProc
										.CommandText = "bp_member_addr_select"

										.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
										' .Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

										Set aRs = .Execute
									End With
									Set aCmd = Nothing

									If Not (aRs.BOF Or aRs.EOF) Then
										aRs.MoveFirst

										Do Until aRs.EOF
								%>

                                <div class="box">
                                    <div class="name">
                                        <%If aRs("is_main")="Y" Then%><span class="red">[기본배달지]</span><%End If%> <%=aRs("addr_name")%>
                                    </div>
                                    <ul class="info">
                                        <li><%=aRs("mobile")%></li>
                                        <li>(<%=aRs("zip_code")%>) <%=aRs("address_main")&" "&aRs("address_detail")%></li>
                                    </ul>
                                    <ul class="btn-wrap">
                                        <li>
                                            <button type="button" class="btn btn-md btn-redLine w-100p btn-redChk">선택</button>
                                        </li>
                                    </ul>
                                </div>

								<%
											aRs.MoveNext
										Loop
									End If
									Set aRs = Nothing
								%>

                            </section>

                            <div class="btn-wrap inner mar-t40">
                                <button type="submit" class="btn btn-lg btn-black w-100p">배달지 추가</button>
                            </div>

                            <div class="txt-basic inner mar-t20">
                                - 배달지 관리는 마이페이지 &gt; 회원정보변경 &gt; 배달지관리에서 확인하실 수 있습니다. 
                            </div>
                        </form>
                    </div>
                    <!--// LP Content -->
                </div>
                <!--// LP Container -->
                <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
            </div>
            <!--// Layer Popup -->

        </article>
        <!--// Content -->

		<form id="order_form" name="order_form" method="post" action="menu_test02.asp">
			<input type="hidden" id="addr_idx" name="addr_idx" value="<%=addr_idx%>">
			<input type="hidden" name="delivery_fee" value="2000">
			<input type="hidden" id="item_data" name="item_data" value="">
			<input type="hidden" id="item_amount" name="item_amount" value="0">
			<input type="hidden" id="total_amount" name="total_amount" value="0">
		</form>

    </div>
    <!--// Container -->

    <!-- Footer -->
    <!--#include virtual="/includes/footer.asp"-->
    <!--// Footer -->
