<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/aspJSON1.18.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->


</head>

<%

	Set pUserInfo = UserGetInfo
	Set pCouponList = CouponGetHoldList("NONE", "N", 100, 1)
	Set pPointBalance = PointGetPointBalance("SAVE", 30)
	Set pCardOwnerList = CardOwnerList("USE")
%>

<body>

<div class="h-wrapper">
<%
	PageTitle = "마이페이지"
%>
	<!-- Header -->
		<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->

	<!-- Container -->
	<div class="h-container" style="padding-bottom: 0px !important;">
        <!-- Aside -->
		<div id="aside_div"></div>
		<!--// Aside -->
		<!-- Content -->
		<article class="h-content">
            <section class="mypage_area h-inbox1000">
            	<ul class="mypage_top">
            		<li>welcome</li>
            		<li><button type="button" onclick="location.href='/mypage/memEdit.asp'" class="btn btn_mypage"><span class="ico-only">MY</span></button></li>
            	</ul>

            	<ul class="mypage_name">
            		<li><span class="name"><%=Session("userName")%></span>님</li>
            		<li>세상에서 가장 건강하고 맛있는  치킨 bbq 입니다.</li>
            	</ul>

            	<div class="mypage_info">
            		<a href="./membership.asp"><span class="ico-only ico-info01" style="color:#fff;"><em class="h-ddack">딹</em>멤버십 안내</span></a>
            	</div>

            	<div class="mypage_box">
            		<ul>
            			<li onclick="location.href='/mypage/mileage.asp'"><div class="ico-point">포인트</div><p><span><%=FormatNumber(pPointBalance.mTotalPoint,0)%></span>P</p></li>
            			<li onclick="location.href='/mypage/couponList.asp?couponList=coupon'"><div class="ico-cupon">쿠폰</div><p><span><%=pCouponList.mTotalCount%></span>개</p></li>
            			<li onclick="location.href='/mypage/couponList.asp?couponList=giftcard'"><div class="icon_gift">상품권</div><p><span class="gc_red">0</span>개</p></li>
            		</ul>
            	</div>
<!--            	스탬프-->
            	<%
            	'유효스탬프 찾기
                nowDate = Replace(Date(),"-","")
                sql = " SELECT date_s as startYmd, date_e as endYmd FROM bt_event_mkt WHERE date_e >= "& nowDate &" AND date_s <= "& nowDate
                Set Stamp = dbconn.Execute(Sql)
                If Not (Stamp.BOF Or Stamp.EOF) Then
                    startYmd = Stamp("startYmd") '스탬프 시작기간
                    endYmd = Stamp("endYmd") '스탬프 종료기간
                End If
                '유효스탬프 찾기 끝
            	'스탬프 조회
                    req_str = "{""companyCode"":""" & PAYCO_MEMBERSHIP_COMPANYCODE &""",""memberNo"":""" & Session("userIdNo") &""",""startYmd"":"&startYmd&",""endYmd"":"&endYmd&",""perPage"":""2"",""page"":""1""}"
                    api_url = "/stamp/getHoldList"
                    result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
                    'Response.Write result
                    Set oJSON = New aspJSON
                    oJSON.loadJSON(result)
                    Set this = oJSON.data("result")
	                TotalStamp = this.item("totalCount") '총 스탬프 갯수
	                TotalStampCount = this.item("totalStampCount") '총 스탬프 응모권 갯수


                    'Response.Write result

                    If TotalStamp > 0 Then
                        For Each row In this.item("holdList")
                        set this1 = this.item("holdList").item(row)
                        'Response.write "<br>[" & row & "]"
                        'Response.write this1.item("stampName") ' 스탬프명
                        'Response.write this1.item("stampCount") ' 스탬프 갯수
                        Next
                    End If
                '스탬프 조회 끝
                '고객 핸드폰번호
                    If CheckLogin() Then
			            If Session("userPhone") <> "" And Len(Session("userPhone")) > 10 Then
				            temp_mobile = right(Replace(Session("userPhone"), "+82", "0"), 10)
				            vMobile = "0"&left(temp_mobile, 2)&"-"&mid(temp_mobile, 3, 4)&"-"&mid(temp_mobile, 7)
			            End If
		            End If
                '고객 핸드폰번호 끝
                If TotalStamp > 0 Then
                '스탬프 비교
		            CountQuery = " SELECT COUNT(*) as cnt FROM BT_EVENT_MKT_COUPON WHERE cust_id = '"& Session("userIdNo") &"' AND USE_YN = 'Y'"
                    Set Stamp_Coupon = dbconn.Execute(CountQuery)
                    Stamp_Coupon.movefirst
		            If this1.item("stampCount") <> Stamp_Coupon("cnt") Then
                        If this1.item("stampCount") > Stamp_Coupon("cnt") Then
                            Mcount = Stamp_Coupon("cnt") - this1.item("stampCount")
                            'Response.Write Replace(Mcount,"-","")
                            sql = " SELECT stampId_payco as stampId  FROM bt_event_mkt WHERE date_e >= "& nowDate &" AND date_s <= "& nowDate
                            Set Stamp = dbconn.Execute(Sql)
                            If Not (Stamp.BOF Or Stamp.EOF) Then
                            req_str = "{""companyCode"":""" & PAYCO_MEMBERSHIP_COMPANYCODE &""",""stampId"":""" & Stamp("stampId") &""",""memberNo"":""" & Session("userIdNo") &""",""tradeType"":""MINUS"",""stampingCount"":"&Replace(Mcount,"-","")&"}"
                            api_url = "/stamp/tradeStamp"
                            result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
                            End If
                        ElseIf this1.item("stampCount") < Stamp_Coupon("cnt") Then
                            Mcount = this1.item("stampCount") - Stamp_Coupon("cnt")
                            'Response.Write Replace(Mcount,"-","")
                            sql = " SELECT stampId_payco as stampId  FROM bt_event_mkt WHERE date_e >= "& nowDate &" AND date_s <= "& nowDate
                            Set Stamp = dbconn.Execute(Sql)
                            If Not (Stamp.BOF Or Stamp.EOF) Then
                                req_str = "{""companyCode"":""" & PAYCO_MEMBERSHIP_COMPANYCODE &""",""stampId"":""" & Stamp("stampId") &""",""memberNo"":""" & Session("userIdNo") &""",""tradeType"":""PLUS"",""stampingCount"":"&Replace(Mcount,"-","")&"}"
                                api_url = "/stamp/tradeStamp"
                                result = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
                            End If
                        End If
		            End If

                '스탬프 비교 끝
                '스탬프 조회
                    req_str = "{""companyCode"":""" & PAYCO_MEMBERSHIP_COMPANYCODE &""",""memberNo"":""" & Session("userIdNo") &""",""startYmd"":"&startYmd&",""endYmd"":"&endYmd&",""perPage"":""2"",""page"":""1""}"
                    api_url = "/stamp/getHoldList"
                    result_stamp = executeApi ("POST", "application/json", req_str, PAYCO_MEMBERSHIP_URL & api_url)
                    'Response.Write result_stamp
                    Set oJSON = New aspJSON
                    oJSON.loadJSON(result_stamp)
                    Set this_stamp = oJSON.data("result")
                    For Each row In this_stamp.item("holdList")
                    Set this_result = this_stamp.item("holdList").item(row)
                    Next
                '스탬프 조회 끝

            	%>
            	<%
                If Stamp_Coupon("cnt") > 0 Then
            	%>
            	<div class="mypage_box" style="margin-top: 10px; padding: 15px 0 15px 30px; height: 100px; line-height: 50px; text-align: left; font-size: 18px;">
            		<p style="font-size: 18px">기간 : <%=MID(startYmd,5,2)%>/<%=RIGHT(startYmd,2)%> ~ <%=MID(endYmd,5,2)%>/<%=RIGHT(endYmd,2)%></p>
            		<p style="font-size: 18px"><%=this1.item("stampName")%>&nbsp; <%=this_result.item("stampCount")%>장</p>
            		<p style="font-size: 18px">치킨왕 누적 응모권 : <%=this_result.item("stampCount")%> 장</p>
            	</div>
            	<%
            	End If
            	                    End If

            	%>
<!--            	스탬프끝-->
                <script type="text/javascript">
					    var page = 1;
					    var order_pageSize = 3;

					    $(function(){
						    getOrderList();
					    });
				    </script>
            </section>
		    <section class="mypage_list_area h-inbox1000 h-section">
        	    <ul class="mypage_list">
        		    <li><a href="/mypage/orderList.asp">주문내역</a></li>
        	    </ul>
                <div class="reorder_wrap">
					<div class="orderList" id="order_list"></div>
				</div>
                <ul class="mypage_list">
        		    <li><a href="/mypage/addManage.asp">배달지</a></li>
        	    </ul>
                <section class="section_recentOrder">
                    <div>

                    	<%
                    		Dim aCmd : Set aCmd = Server.CreateObject("ADODB.Command")
                    		Dim aRs : Set aRs = Server.CreateObject("ADODB.RecordSet")
                    		Dim TotalCount

                    		With aCmd
                    			.ActiveConnection = dbconn
                    			.NamedParameters = True
                    			.CommandType = adCmdStoredProc
                    			.CommandText = "bp_member_addr_select"

                    			.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
                    			.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

                    			Set aRs = .Execute

                    			TotalCount = .Parameters("@totalCount").Value
                    		End With
                    		Set aCmd = Nothing

                    		If Not (aRs.BOF Or aRs.EOF) Then
                    			aRs.MoveFirst
                    			Do Until aRs.EOF
                    	%>

                    				<div class="addManage" id="addr_<%=aRs("addr_idx")%>">
                    					<div class="name">
                    						<%If aRs("is_main") = "Y" Then%>
                    						<span class="red">[기본배달지]</span> <%End If%><%'=aRs("addr_name")%>
                    					</div>
                    					<ul class="info">
                    						<li>(<%=aRs("zip_code")%>) <%=aRs("address_main")&" "&aRs("address_detail")%></li>
                    					</ul>
                    					<ul class="btn-wrap">
                    						<li class="btn-left">
                    							<% If aRs("is_main") <> "Y" Then %>
                    								<button type="button" class="btn btn_small2 btn-brown" onClick="javascript: setMainAddress('<%=aRs("addr_idx")%>');">기본배달지 설정</button>
                    							<% End If %>
                    						</li>
                    					</ul>
                    				</div>
                    	<%
                    				aRs.MoveNext
                    			Loop
                    		End If
                    		Set aRs = Nothing
                    	%>
                    </div>

                </section>
        		    
            </section>
            <section class="mypage_callCenter h-inbox1000">
				<ul>
					<li>
						<dl><dt>고객센터</dt><dd>080-3436-0507</dd></dl>
					</li>
					<li>운영시간 10:00~18:00 (토요일, 공휴일은 휴무)</li>
				</ul>
			</section>
            <section class="footer_btn h-inbox1000">
				<button type="button" onClick="javascript:location.href='/api/logout.asp';" class="btn h-btn_logout">로그아웃</button>
			</section>
			<div class="section-wrap">
				<form id="cart_form" name="cart_form" method="post" action="payment.asp" >
					<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
					<input type="hidden" name="branch_id" id="branch_id" value="<%=branch_id%>">
					<input type="hidden" name="branch_data" id="branch_data" value='<%=branch_data%>'>
					<input type="hidden" name="addr_idx" id="addr_idx" value="<%=addr_idx%>">
					<input type="hidden" name="cart_value">
					<input type="hidden" name="addr_data" id="addr_data" value='<%=addr_data%>'>
					<input type="hidden" name="spent_time" id="spent_time">
				</form>

				<form id="form_addr" name="form_addr" method="post" onsubmit="return false;" >
					<input type="hidden" name="addr_idx">
					<input type="hidden" name="mode" value="">
					<input type="hidden" name="addr_type" value="">
					<input type="hidden" name="address_jibun" value="">
					<input type="hidden" name="address_road" value="">
					<input type="hidden" name="sido" value="">
					<input type="hidden" name="sigungu" value="">
					<input type="hidden" name="sigungu_code" value="">
					<input type="hidden" name="roadname_code" value="">
					<input type="hidden" name="b_name" value="">
					<input type="hidden" name="b_code" value="">
					<input type="hidden" name="mobile" value="">

					<input type="hidden" name="addr_name">
					<input type="hidden" name="mobile1">
					<input type="hidden" name="mobile2">
					<input type="hidden" name="mobile3">
					<input type="hidden" name="zip_code">
					<input type="hidden" name="address_main">
					<input type="hidden" name="address_detail">
				</form>

				<script type="text/javascript">
					var SERVER_IMGPATH_str = "<%=SERVER_IMGPATH%>";
				</script>

				<%
					totalCount = 0
					Set aCmd = Server.CreateObject("ADODB.Command")
					With aCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bp_order_list_member"

						.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
						.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput,,3)
						.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

						Set aRs = .Execute

						totalCount = .Parameters("@totalCount").Value
					End With
					Set aCmd = Nothing
				%>

			</div>
			<br><br>

			<%
				Set cmd = Server.CreateObject("ADODB.Command")
				totalCount = 0

				With cmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_member_q_select"

					.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "LIST")
					' .Parameters.Append .CreateParameter("@q_idx", adParamInput, adParamInput, , q_idx)
					.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, "01")
					.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo") )
					.Parameters.Append .CreateParameter("@pageSize", adInteger, adParamInput, , 3)
					.Parameters.Append .CreateParameter("@curPage", adInteger, adParamInput, , 1)
					.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

					Set rs = .Execute

					totalCount = .Parameters("@totalCount").Value
				End With
				Set cmd = Nothing
			%>

			<!-- 문의내역
			<div class="section-wrap">
				<section class="section_mypageInq">
					<div class="section-header">
						<h3>문의내역</h3>
						<%If totalCount > 0 Then%><div class="rig"><a href="./inquiryList.asp" class="more">더보기</a></div><%End If%>
					</div>
					<div class="inquiryList-wrap">
						<ul class="inquiryList">
							<%
								If Not (rs.BOF Or rs.EOF) Then
									Do Until rs.EOF
							%>
							<li class="item">
								<a href="./inquiryView.asp?qidx=<%=rs("q_idx")%>" class="item-inquiry">
									<p class="mar-b15"><span class="ico-branch red">비비큐치킨</span></p>
									<p class="subject"><%=rs("title")%></p>
									<div class="item-footer">
										<p class="date">작성일 : <span><%=FormatDateTime(rs("regdate"),2)%></span></p>
										<span class="state"><%=rs("q_status")%></span>
									</div>
								</a>
							</li>

							<%
										rs.MoveNext
									Loop
								Else
							%>

							<li class="inquiryX">문의내역이 없습니다.</li>

							<%
								End If
							%>

						</ul>
					</div>
				</section>
			</div>
			// 문의내역 -->

			<!-- Support 
			<div class="section-wrap">
				<section class="section section_support">
					<ul class="support">
						<li><a href="/customer/faqList.asp">자주하는질문</a></li>
						<li><a href="/customer/inquiryList.asp">고객의소리</a></li>
						<li><a href="#">e-쿠폰 등록</a></li>
						<li><a href="./membership.asp">멤버십 안내</a></li>
					</ul>
				</section>
			</div>
			// Support -->

			
		</article>
		<!--// Content -->

	</div>
	<!--// Container -->
	<!-- Footer -->
	<!--#include virtual="/includes/footer_new.asp"-->
	<!--// Footer -->
<script>
$(document).ready(function (){
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
           }
         }
     });
})
  // 상품권 
</script>