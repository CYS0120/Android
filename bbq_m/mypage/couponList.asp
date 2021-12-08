<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<meta name="Keywords" content="모바일 상품권, BBQ치킨">
<meta name="Description" content="모바일 상품권">
<title>쿠폰 | BBQ치킨</title>

</head>

<body>

<div class="tab-type4">
	<ul class="tab">
		<li id="tab_coupon" ><a onclick="change_tab('coupon')">할인/증정쿠폰</a></li>
        <li id="tab_Ecoupon" ><a onclick="change_tab('Ecoupon')">모바일상품권</a></li>
		<li id="tab_giftcard" ><a onclick="change_tab('giftcard')">지류상품권</a></li>
	</ul>
</div>

<div class="wrapper" style="display: block">

	<%
		PageTitle = "쿠폰/상품권"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article id="coupon_list" class="content inbox1000" style="display: block">

			<%
				Set couponHoldList = CouponGetHoldList("NONE", "N", 100, 1)
			%>

			<!-- 사용가능쿠폰 -->
			<section class="section section_couponUseOk">
<%
               '페이코 쿠폰 오류 발급으로 인한 코드 (쿠폰번호 - CP00002347, 유효기간- 2021.03.23-2021.04.23) 
                Dim couponTotalCount 
                couponTotalCount = couponHoldList.mTotalCount
				IF couponTotalCount > 0 Then
					For i = 0 To UBound(couponHoldList.mHoldList)
						If couponHoldList.mHoldList(i).mCouponId = "CP00002347" Then
							couponTotalCount = couponTotalCount - 1
						end if 	
					Next
				End If
%>
				<!--<div class="coupon_head">사용 가능한 할인/증정쿠폰 <strong><%=couponTotalCount%></strong>장</div>-->
				<div class="coupon_head" onclick="Regi_PaycoCoupon();">할인/증정쿠폰 등록하기</div>

				<!-- <div class="couponUseOk_wrap"> -->
                <div class="coupon">
 					<%
						IF couponHoldList.mTotalCount > 0 Then
							For i = 0 To UBound(couponHoldList.mHoldList)
					%>
                    <%
                        '페이코 쿠폰 오류 발급으로 인한 코드 (쿠폰번호 - CP00002347, 유효기간- 2021.03.23-2021.04.23) 
                        If couponHoldList.mHoldList(i).mCouponId <> "CP00002347" then
                    %>
					<div class="couponUseOk">
						<div class="coupon">
							<ul class="tit">
								<li class="device"><span class="ico-branch red">비비큐치킨</span></li>
								<li class="day"><span>D - <%=DateDiff("d", Date, left(couponHoldList.mHoldList(i).mValidEndDate,4)&"-"&mid(couponHoldList.mHoldList(i).mValidEndDate,5,2)&"-"&mid(couponHoldList.mHoldList(i).mValidEndDate,7,2))%></span></li>
							</ul>
							<dl class="info">
							<%
								Set couponDetail = CouponGetDetail(couponHoldList.mHoldList(i).mCouponId)
							%>
								<dt><%=couponHoldList.mHoldList(i).mCouponName%></dt>
								<dd>
									유효기간 : <%=left(couponHoldList.mHoldList(i).mValidStartDate,4)&"-"&mid(couponHoldList.mHoldList(i).mValidStartDate,5,2)&"-"&mid(couponHoldList.mHoldList(i).mValidStartDate,7,2)%> ~ <%=left(couponHoldList.mHoldList(i).mValidEndDate,4)&"-"&mid(couponHoldList.mHoldList(i).mValidEndDate,5,2)&"-"&mid(couponHoldList.mHoldList(i).mValidEndDate,7,2)%><br/>
									사용처 : PC · 모바일 · App
								</dd>
							</dl>
							<!-- <ul class="txt">
								<li>모든메뉴 주문시 사용 가능 (단, 주류/음료/배달비 제외)</li>
								<li>타 쿠폰과 중복 사용불가</li>
							</ul> -->
							<div class="txt2">
                                <%=Replace(couponDetail.mCouponInfo, chr(13), "<br>")%>
							</div>
<!-- 
							<ul class="txt">
								<li>황올 포함 18000원 이상 구매 시 7천원 할인 및 치즈볼(랜덤) 2알 증정 이벤트 입니다.</li>
								<li>타 쿠폰과 중복 사용 불가합니다.</li>
								<li>포인트 적립은 불가합니다.</li>
								<li>특화매장 및 일부 매장은 사용이 불가할 수 있습니다.</li>
								<li>배달료 및 포장비등의 추가비용이 발생할 수 있으며, 매장 및 거리에 따라 비용이 상이할 수 있습니다.</li>
							</ul>
 -->
						</div>
					</div>
                    <%
                        End If
                    %>
					<%
							Next
						else %>

					<!-- 등록된 쿠폰 없을때 -->
					<div class="coupon_empty">
						<p>등록된 할인/증정 쿠폰이<br>없습니다.</p>
					</div>
					<!-- // 등록된 쿠폰 없을때 -->
					
					<%
						End If
					%>

                </div>
					
            	

			</section>
			<!-- //사용가능쿠폰 -->
		</article>

		<article id="LP_eCoupon" class="eCoupon_wrap" style="display: block">
			<!-- 사용가능 e쿠폰 -->
			<section class="section section_couponUseOk">
				
                <!-- e쿠폰 등록 -->
                <section class="eCoupon_wrap">
                    <h3>모바일 상품권  번호를<br>입력하여 주세요.</h3>
                    <ul class="area">
                        <li><input type="text" id="txtPIN" name="txtPIN" placeholder="모바일 상품권 번호 입력" class="w-70p" autocomplete="off" style="margin-right:2%;" maxlength="12">
                            <button type="button" onclick='javascript:eCouponUse("LA");/*eCoupon_Check_GoCart_NoPinCode("Y", "./couponList.asp?couponList=Ecoupon")*/' class="btn-sm btn-black w-15p">등록</button>
                        </li>
                    </ul>
                </section>
                <!-- //e쿠폰 등록 -->

				<!-- <div class="couponUseOk_wrap"> -->
                <div class="couponUseOk">
                <%
                    Dim aCmd, aRs

                    Set aCmd = Server.CreateObject("ADODB.Command")

                    With aCmd
                        .ActiveConnection = dbconn
                        .NamedParameters = True
                        .CommandType = adCmdStoredProc
                        .CommandText = "bt_member_coupon_select"
                        .Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 100, Session("userIdNo"))
                        .Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 20, "LIST")
                        .Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

                        Set aRs = .Execute
                    End With
                    Set aCmd = Nothing   

                    dim idxEcoupon : idxEcoupon = 0 
                    If Not (aRs.BOF Or aRs.EOF) Then    
                        aRs.MoveFirst  

                        Do Until aRs.EOF  
                            idxEcoupon = idxEcoupon + 1
                    %>
                    <div class="divCouponItemM"> 
						<div class="coupon">
                            <!--
							<div class="tit div-table">
								<ul class="tr">
									<li class="td device"><span class="ico-branch red">비비큐치킨</span></li>
									<li class="td day"></li>
								</ul>
							</div>
                            -->
							<dl class="info">
                                <label class='checkbox'>
								<!--<dt onclick='javascript:eCoupon_Check_GoCart("N", "<%=aRs("c_code")%>");'><b><%=aRs("c_title")%></b></dt>-->
								<dt><input type="checkbox" name="chkEcoupon" id="chkEcoupon<%=idxEcoupon%>" value="<%=aRs("c_code")%>" /> <b><%=aRs("c_title")%></b></dt>
								<dd>
                                    번&nbsp;&nbsp;&nbsp;&nbsp;호 : <%=aRs("c_code")%><br/>
									금&nbsp;&nbsp;&nbsp;&nbsp;액 : <%=FormatNumber(aRs("CPN_PRICE"), 0)%><br/>
									유효기간 : <%=aRs("USESDATE")%> ~ <%=aRs("USEEDATE")%>
								</dd>
                                </label>
							</dl>
                            <!--<dl class="coupon_list_delete"><a href='javascript:eCoupon_Check_GoCart("N", "<%=aRs("c_code")%>");' class="btn btn-red btn_middle">사용하기</a></dl>
                            <dl class="coupon_list_use"><a href='javascript:eCoupon_Check_GoCart("N", "<%=aRs("c_code")%>");' class="btn btn-red btn_middle">사용</a></dl>
                            <dl class="coupon_list_delete"><a href="javascript:eCoupon_del_plus('<%=aRs("c_code")%>')"><img src="/images/mypage/ico_delete.png">삭제</a></dl>-->
						</div>
                        <div class="txt">
                         <br/> 
						</div>
                    </div>

                <%
                            aRs.MoveNext
						Loop
                %>
						<button type="button" id="btnCouponUse" onclick='javascript:eCouponUse("LU");' class="btn btn_middle btn-red">사용하기</button>
                <%
                    End If
                    Set aRs = Nothing                
                %>						
                        <div class="txt">
							- 타 쿠폰과 중복 사용불가
						</div>

                </div>
			</section>
			<!-- //사용가능 e쿠폰 -->
            
		</article>        

        <article class="content inbox1000" id="giftcard_list" style="display: none">
	        <!-- //사용가능쿠폰 -->
	        <section class="section section_couponUseOk">
                    <article class="content inbox1000">
                    <div class="coupon_head">사용 가능한 지류 상품권 <strong class="gc_red">0</strong>장</div>
				    <div class="coupon_head" onclick="Regi_GiftCard();">지류 상품권 등록하기</div>
                        <!-- 사용가능상품권 -->
                        <section class="section section_couponUseOk">
							<input type="hidden" id="giftcard_value" value="0"><!-- 중복갱신 방지 값 -->
                            <div>
								<!-- 등록된 상품권 목록 -->
								<div id="giftcard_Use_list" class="couponUseOk">
                                
                                </div>
 								<!-- 등록된 상품권 목록 -->
                    	        <!-- 등록된 상품권 없을때 -->
                    	        <div id="giftcard_empty_list" class="coupon_empty" style="display: none">
                    		        <p>등록된 지류 상품권이<br>없습니다.</p>
                    	        </div>
                    	        <!-- // 등록된 상품권 없을때 -->
                            </div>
                        </section>
                        <!-- //사용가능상품권 -->
                    </article>
            </section>
        </article>

		<!--// Content -->
	</div>
	<!--// Container -->





<!-- Layer Popup : 쿠폰등록 -->
	<div id="Lp_RegiPaycoCoupon" class="lp-wrapper lp_RegiPaycoCoupon">
		<!-- LP Wrap -->
		<div class="lp-wrap inbox1000">
			<!-- LP Header -->
			<div class="lp-header">
				<h2>할인/증정쿠폰 등록</h2>
			</div>
			<!--// LP Header -->
			<!-- LP Container -->
			<div class="lp-container">
				<!-- LP Content -->
				<div class="lp-content ">
					<form action="">
						<!-- 모바일 상품권 등록 -->
						 <section class="eCoupon_wrap">
							<h3>할인/증정쿠폰 번호를<br>입력하여 주세요.</h3>
							<form action="" class="form">
								<ul class="area">
									<li><input type="text" id="paycoPIN" name="paycoPIN" placeholder="할인/증정쿠폰 번호 입력" class="w-100p" maxlength="12" value=""></li>
                                    <li class="mar-t15"><button type="button" onclick="paycoCoupon_Check_Json_url();" class="btn btn_middle btn-red">확인</button></li>
                                    <%
                                        ' Set couponIssueByPin = CouponIssueByPinV2("페이코 핀번호  paycoPIN.value")
                                        ' If couponIssueByPin.code = 0 Then
                                        '     alert("");
                                        ' End If
                                    %>
                                </ul>
                            </form>
						</section>
						<!-- 쿠폰 등록 -->
					</form>
				</div>
				<!--// LP Content -->
			</div>
			<!--// LP Container -->
			<button type="button" class="btn btn_lp_close" onclick="javascript:lpClose('.lp_RegiPaycoCoupon');"><span>레이어팝업 닫기</span></button>
		</div>
		<!-- // LP Wrap -->
	</div>
	<!--// Layer Popup -->




<!-- Layer Popup : 상품권 등록 -->
	<div id="Lp_RegiGiftCard" class="lp-wrapper lp_RegiGiftCard">
		<!-- LP Wrap -->
		<div class="lp-wrap inbox1000">
			<!-- LP Header -->
			<div class="lp-header">
				<h2>지류 상품권 등록</h2>
			</div>
			<!--// LP Header -->
			<!-- LP Container -->
			<div class="lp-container">
				<!-- LP Content -->
				<div class="lp-content ">
					<form action="">
						<!-- 상품권인증번호 등록 -->
						 <section class="section section_coupon">
							<h3><br><br>지류 상품권 등록<br><br><br></h3>
							<form action="" class="form">
                            	<ul class="area">
                            		<li><input type="text" autocomplete="off" id="giftPIN" name="giftPIN" placeholder="지류 상품권 번호 입력 ('-' 포함)" class="w-70p" style="margin-right:2%;"><button type="button" onclick="javascript:Giftcard_Check();" class="btn btn-sm btn-black w-15p">등록</button></li>
                            		<li class="mar-t15">
                                        <button type="button" onclick="javascript:Giftcard_scan();" class="btn btn-md btn-black" style="width: 45%; margin-right:4%; padding:0 !important; line-height:25px !important; font-size: 20px !important">
                                            <img src="/images/order/barcode-scan2.png" alt="barcode_scan2" width="50px" height="50px"><br>바코드인증
                                        </button>
                            			<button type="button" onclick="" class="btn btn-md btn-black" style="width: 45%; padding:0 !important; line-height:25px !important; font-size: 20px !important">
                                        <label for="barcode_upload" style="color: #fff; font-size:20px">
                            				<img src="/images/order/barcode-photo.png" alt="barcode-photo" width="50px" height="50px"><br>사진인증
                            			</label>
                            			</button>
                                        <section id="container">
                                              <div class="controls">
                                                  <fieldset class="input-group">
                                                    <input type="file" accept="image/*" id="barcode_upload" style="position: absolute;width: 1px;height: 1px;padding: 0;margin: -1px;overflow: hidden;clip: rect(0, 0, 0, 0);border: 0;"/>
                                                  </fieldset>
                                              </div>
                                        </section>
                                    </li>
                            	</ul>
                            </form>
                            <p class="txt mar-t20">
                            - 알파벳 ( I ) =&gt; 숫자 ( 1 ), 알파벳 ( O ) =&gt; 숫자 ( 0 ) 로 정확히 확인 후 입력하시기 바랍니다.
                            </p>
                        </section>
                        <script src="/barcode/inc/quagga.js"></script>
                        <script src="/barcode/inc/vendor/jquery-1.9.0.min.js"></script>
                        <script src="/barcode/inc/file_input.js" type="text/javascript"></script>
						<!-- 상품권인증번호 등록 -->
					</form>
				</div>
				<!--// LP Content -->
			</div>
			<!--// LP Container -->
			<button type="button" class="btn btn_lp_close" onclick="javascript:lpClose('.lp_RegiGiftCard');"><span>레이어팝업 닫기</span></button>
		</div>
		<!-- // LP Wrap -->
	</div>
	<!--// Layer Popup -->


<!-- Layer Popup : 상품권선물 -->
	<div id="LP_Present" class="lp-wrapper lp_present">
		<!-- LP Wrap -->
		<div class="lp-wrap inbox1000">
			<!-- LP Header -->
			<div class="lp-header">
				<h2>지류 상품권 선물</h2>
			</div>
			<!--// LP Header -->
			<!-- LP Container -->
			<div class="lp-container">
				<!-- LP Content -->
				<div class="lp-content ">
					<form action="">
						<!-- 상품권선물 대상 검색 -->
						 <section class="section section_coupon">
							<div class="section-header coupon_head">
								<h3>지류 상품권 선물대상 검색하기</h3>
							</div>
							<form action="" class="form">
                                <input type="hidden" id="giftcard_idx" value="">
                                <input type="hidden" id="user_id" value="">
                                <input type="hidden" id="user_idno" value="">
								<ul class="area">
									<li><input type="text" autocomplete="off" id="memberId" name="memberId" placeholder="아이디 검색" class="w-100p"></li>
									<li class="mar-t15"><button type="button" onclick="javascript:searchId();" class="btn btn-lg btn-brown w-100p">아이디검색</button></li>
									<li class="mar-t15"><button type="button" onclick="javascript:present_giftcard();" class="btn btn-lg btn-black w-100p">선물하기</button></li>
								</ul>
							</form>
						</section>
						<!-- //지류 상품권선물 대상 검색 -->
					</form>
				</div>
				<!--// LP Content -->
			</div>
			<!--// LP Container -->
			<button type="button" class="btn btn_lp_close" onclick="javascript:lpClose('.lp_present');"><span>레이어팝업 닫기</span></button>
		</div>
		<!-- // LP Wrap -->
	</div>
	<!--// Layer Popup -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
	</div>
<%
    if request("couponList") = "" then 
        couponList = "coupon" '기본 모바일 상품권으로..
    else 
        couponList = request("couponList")
    end if 
%>
<script>
    $(document).ready(function() {
        change_tab("<%=couponList%>");

		$('#txtPIN').keydown(function(key){
			if(key.keyCode == 13){
				eCouponUse("LA");
			}
		});
    });
    
    function change_tab(data){
            if (data == 'giftcard'){
                $.ajax({
                    method: "post",
                    url: "/api/ajax/ajax_getGiftCard.asp",
                    data: {
                        callMode: "listCount",
                    },
                    dataType: "json",
                    success: function(res) {
                        if (res.result == 0) {
                            $(".gc_red").html(res.Count);
                            Giftcard_List();
                        }
                        
                    },
                    error: function(data, status, err) {
                        showAlertMsg({
                            msg: "error"
                        });
                    }
        
                });
                $('#coupon_list').css('display','none');
                $('#LP_eCoupon').css('display','none');
                $('#giftcard_list').css('display','block');
                $('#tab_coupon').removeClass("on");
                $('#tab_Ecoupon').removeClass("on");
                $('#tab_giftcard').addClass("on");
            }else if (data == 'coupon'){
                $('#coupon_list').css('display','block');
                $('#LP_eCoupon').css('display','none');
                $('#giftcard_list').css('display','none');
                $('#tab_coupon').addClass("on");
                $('#tab_Ecoupon').removeClass("on");
                $('#tab_giftcard').removeClass("on");
            }else if (data == 'Ecoupon'){
                $('#LP_eCoupon').css('display','block');
                $('#coupon_list').css('display','none');
                $('#giftcard_list').css('display','none');
                $('#tab_Ecoupon').addClass("on");
                $('#tab_coupon').removeClass("on");
                $('#tab_giftcard').removeClass("on");
            }
        }
        function Giftcard_List() {
            var gf_yn = $('#giftcard_value').val(); // 리스트 중복갱신 방지
            $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: {
                    callMode: "list",
                },
                dataType: "json",
                success: function(res) {
                    if (res.result == 0) {
                        if (0 < res.Count.length){
                            if (gf_yn == 0){
                                for (var i = 0; i < res.Count.length; i++){
                                   rdata = "<div class='coupon' style='margin-bottom: 10px !important;'>";
                                   rdata += "<ul class='tit'>";
                                   rdata += "<li class='device'><span class='ico-branch red'>상품권</span></li>";
                                   rdata += "</ul>";
                                   rdata += "<dl class='info'>";
                                   rdata += "<dt>지류상품권"+ res.Count[i].giftcard_idx +"</dt>";
                                   rdata += "<dd> 유효기간 : "+ res.Count[i].usedate_from +" ~ "+ res.Count[i].usedate_to + "<br/></dd>";
                                   rdata += "</dl>";
                                   // rdata += "<div class='txt2'>";
                                   // rdata += "<a onclick='javascript:Show_searchbox("+res.Count[i].giftcard_idx+");'> 선물하기 </a>";
                                   // rdata += "</div>";
                                   rdata += "</div>";
                                   $('#giftcard_Use_list').append(rdata);
                               }
                               $('#giftcard_value').val('1');
                            }
                        }
                       /*showAlertMsg({
                          msg:"쿠폰리스트 불러오기 성공" + res.Count[0].giftcard_idx
                       });*/
                    }else{
                        $('#giftcard_empty_list').css('display','block');
                    }
                    
                },
                error: function(data, status, err) {
                    console.log("error : " + err);
                    showAlertMsg({
                        msg: "지류 상품권 리스트를 불러오지 못했습니다."
                    });
                }

            });
        }

        function Regi_PaycoCoupon(){
            lpOpen('.lp_RegiPaycoCoupon');
        }

        function Regi_Coupon(){
            lpOpen('.lp_RegiCoupon');
        }
                
        function Regi_GiftCard(){
            lpOpen('.lp_RegiGiftCard');
        }

        function Refresh_Ecoupon(){
            location.href = "./couponList.asp?couponList=Ecoupon"
        }
        
        function Giftcard_Upload(data){
            if(data != ""){
                $("#giftPIN").val(data)
                Giftcard_Check()
            }else{
                showAlertMsg({
                    msg:"지류 상품권을 다시 확인해주세요.",
                });
                return;
            }
        }
        
        function Giftcard_scan(){
        // var link = 'https://1087.g2i.co.kr/barcode/barcode_scan.asp' // DEV
            var link = 'https://m.bbq.co.kr/barcode/barcode_scan.asp' // REAL
            <% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
                if ( window.webkit && window.webkit.messageHandlers ) {
                    window.webkit.messageHandlers.bbqHandler.postMessage('barCodeScan');
                } else {
                    window.SGApp.barCodeScan('');
                }
            <% else %>
                document.location.href=link;
            <% end if %>
        }
        
        function Show_searchbox(Idx){
            lpOpen('.lp_present');
            $('#giftcard_idx').val(Idx);
        }

        function Giftcard_Check() {
            if ($("#giftPIN").val() == "") {
                showAlertMsg({
                    msg:"지류 상품권 번호를 입력해주세요.",
                });
                return;
            }
            $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: {
                    callMode: "insert",
                    giftPIN: $("#giftPIN").val(),
                },
                dataType: "json",
                success: function(res) {
                    if (res.result == 0) {
                        showAlertMsg({
                            msg:"정상 등록되었습니다.",
                            ok: function(){
                                $("#giftPIN").val("");
                                Giftcard_ListCount();
                                Giftcard_Direct_use(res.giftPIN);
                                lpClose(".lp_paymentGiftcard");
                            },
                        });
                    } else if(res.result == 1){
                        showAlertMsg({
                            msg:"이미 등록된 지류 상품권입니다.",
                            ok: function(){
                                $("#giftPIN").val("");
                                lpClose(".lp_paymentGiftcard");
                            },
                        });
                    } else if(res.result == 2){
                         showAlertMsg({
                             msg:"존재하지않는 지류 상품권입니다.",
                             ok: function(){
                                 $("#giftPIN").val("");
                                 lpClose(".lp_paymentGiftcard");
                             },
                         });
                     } else if(res.result == 3){
                       showAlertMsg({
                           msg:"이미 사용한 지류 상품권입니다.",
                           ok: function(){
                               $("#giftPIN").val("");
                               lpClose(".lp_paymentGiftcard");
                           },
                       });
                   } else {
                        showAlertMsg({
                            msg: res.message
                        });
                    }
                },
                error: function(data, status, err) {
                    showAlertMsg({
                                msg: data + ' ' + status + ' ' + err,
                        // msg: "에러가 발생하였습니다",
                        ok: function() {
                            // location.href = "/";
                        }
                    });
                }

            });
        }

        function barCodeData(barcode){
            $("#giftPIN").val(barcode);
             Giftcard_Check()
        }
        
        function searchId() {
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_getGiftCard.asp",
            data: {
                callMode: "search",
                userid: $('#memberId').val(),
            },
            dataType: "json",
            success: function(res) {
                if (res.result == 0) {
                    showAlertMsg({
                        msg:"확인되었습니다.",
                        ok: function(){
                            $('#user_id').val(res.user_id);
                            $('#user_idno').val(res.user_idno);
                        },
                    });
                }else{
                    showAlertMsg({
                        msg:"아이디를 다시 확인해주세요.",
                        ok: function(){
                            $('#user_id').val('');
                            $('#user_idno').val('');
                        },
                    });
                }
                
            },
            error: function(data, status, err) {
                console.log("error : " + err);
                showAlertMsg({
                    msg: err
                });
            }

        });    
        }
        
        function present_giftcard(){
        if($('#user_id').val() == '' || $('#user_idno').val() == ''){
            showAlertMsg({
                msg: "선물 대상이 확인되지 않았습니다."
            });
            return false;
        }
            $.ajax({
                method: "post",
                url: "/api/ajax/ajax_getGiftCard.asp",
                data: {
                    callMode: "present",
                    userid: $('#user_id').val(),
                    useridno: $('#user_idno').val(),
                    idx: $('#giftcard_idx').val(),
                },
                dataType: "json",
                success: function(res) {
                    if (res.result == 0) {
                        showAlertMsg({
                            msg:res.user_id+"님께 상품권을 선물하였습니다.",
                            ok: function(){
                                window.location.reload()
                            },
                        });
                    }else{
                        showAlertMsg({
                            msg:"다시 시도해주세요.",
                            ok: function(){
                            },
                        });
                    }
                    
                },
                error: function(data, status, err) {
                    console.log("error : " + err);
                    showAlertMsg({
                        msg: err
                    });
                }
    
            });  
        }
        
</script>