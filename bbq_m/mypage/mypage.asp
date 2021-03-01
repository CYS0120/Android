<!--#include virtual="/api/include/utf8.asp"-->

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

<div class="wrapper">

	<%
		PageTitle = "마이페이지"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content inbox1000">
		
			<div class="section-wrap">

				<!-- Membership Info -->
				<section class="section section_membership">
					<h3 class="blind">나의 쇼핑정보</h3>
					<div class="memGrade gold"><!-- silver, bronze -->
						<p><strong><%=Session("userName")%></strong> 고객님</p>
						<p class="txt">세상에서 가장 건강하고 맛있는 치킨 bbq 입니다.</p>
						<p class="btn_memGrade"><a href="/mypage/memEdit.asp" class="btn btn_small2 btn-grayLine">회원정보 변경</a></p>
					</div>

					<!-- 치킨캠프
					<div class="ckcamp">
						<a href="javascript:alert('준비중입니다.');"><span>치킨캠프 신청내역 확인하기</span></a>
					</div>
					 //치킨캠프 -->

					<div class="myInfo-wrap">
						<ul class="myInfo">
							<li class="item_cupon" onclick="location.href='./couponList.asp'">
								<div class="count"><span><%=pCouponList.mTotalCount%></span> 장 <img src="/images/mypage/icon_pluse.png"></div>
							</li>
							<li class="item_point" onclick="location.href='./mileage.asp'">
								<div class="count"><span><%=FormatNumber(pPointBalance.mTotalPoint,0)%></span> P <img src="/images/mypage/icon_pluse.png"></div>
							</li>
							<li class="item_card" onclick="location.href='./cardList.asp'">
								<div class="count"><span><%=UBound(pCardOwnerList.mCardDetail)+1%></span> 장 <img src="/images/mypage/icon_pluse.png"></div>
							</li>
						</ul>
					</div>

					<div class="btn-myinfo">
						<a href="./membership.asp" class="btn btn_middle"><em class="ddack">딹</em>멤버십 안내</a>
					</div>
				</section>
				<!--// Membership Info -->

				<script type="text/javascript">
					var page = 1;
					var order_pageSize = 3;

					$(function(){
						getOrderList();
					});
				</script>


				<!-- 최근 주문 -->
				<section class="section_recentOrder">
					<div class="section-header">
						<h3>최근 주문 </h3>
						<div class="rig"><a href="/mypage/orderList.asp" class="more">더보기</a></div>
					</div>

					<div class="reorder_wrap">
						<div class="orderList" id="order_list"></div>
					</div>
				</section>
				<!-- // 최근 주문 -->


				<!-- 등록된 주소 -->
				<section class="section_recentOrder">
					<div class="section-header">
						<h3>등록된 주소</h3>
						<div class="rig"><a href="/mypage/addManage.asp" class="more">관리</a></div>
					</div>
					<div class="addManage_wrap">

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
				<!-- // 등록된 주소 -->


				<!-- 고객센터 -->
				<section class="section_mypage_callCenter">
					<dl class="callCenter">
						<dt>고객센터</dt>
						<dd>
							<strong>080-3436-0507</strong>
							<p>운영시간 10:00~18:00 (토요일, 공휴일은 휴무)</p>
						</dd>
					</dl>
				</section>
				<!-- // 고객센터 -->


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
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
