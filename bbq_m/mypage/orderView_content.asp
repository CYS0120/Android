			<!-- 주문번호/일시 -->
			<ul class="reorder_view_top clearfix">
				<li>
					<span class="reorder_view_type">
						<%	If vOrderType = "D" Then %>
							<img src="/images/main/icon_m_order.png"> 
						<%	elseIf vOrderType = "R" or vOrderType = "P" Then %>
							<img src="/images/main/icon_m_out.png" alt="">
						<%	elseIf vOrderType = "X" Then %>
							<img src="/images/mypage/ico_order_shop.png" alt="">
						<%	End If  %>

						<%=vOrderTypeName%>
					</span>
				</li>
				<%
					g2_now_url = request.serverVariables("url")
					 
					g2_now_file = Mid(g2_now_url, InstrRev(g2_now_url,"/")+1)

					if g2_now_file <> "orderCancel.asp" then 
				%>
						<li class="reorder_view_state_wrap">
							<p class="mar-b3 <%=order_status_class(vOrderType, vOrderStatusName)%>"><%=order_status_txt(vOrderType, vOrderStatusName)%></p>
							<% if delivery_time <> "" then %>
								<p class="reorder_view_time"><%=delivery_time%>분 뒤 도착예정</p>
							<% end if %>
						</li>
				<% end if %>

			</ul>
			
			<section class="section section_orderNumDate">
				<dl>
					<dt>주문일시 :</dt>
					<dd><%=vOrderDate%></dd>
				</dl>
				<dl>
					<dt>주문번호 :</dt>
					<dd><%=vOrderNum%></dd>
				</dl>
			</section>
			<!-- //주문번호/일시 -->

			<!-- 예약정보 -->
			<section class="section section_orderNumDate" id="book_area">
				<dl>
					<dt>예약일자 :</dt>
					<dd><%=vDelivery_time%></dd>
				</dl>				
			</section>
			
			<script type="text/javascript" >
				$(document).ready(function() {
					$("#book_area").hide();
					if("<%=vDelivery_time%>" != "") {
						$("#book_area").show();
					}
				});
			</script>
			<!-- 예약정보 -->

			<div>
				<div class="reorder_view_list">
					<h4>주문내역</h4>


					<%
						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput,, order_idx)

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						Dim upper_order_detail_idx : upper_order_detail_idx = -1

						If Not (aRs.BOF Or aRs.EOF) Then
							aRs.MoveFirst

							Do Until aRs.EOF
								If upper_order_detail_idx = -1 Then
					%>

					<div class="order_menu border">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="<%=SERVER_IMGPATH%><%=aRs("main_file_path")&aRs("main_file_name")%>" onerror="this.src='http://placehold.it/160x160?text=1'" alt=""></div>
								<div class="td info">
									<div class="sum">
										<%
											ElseIf upper_order_detail_idx <> 0 And aRs("upper_order_detail_idx") = 0 Then
										%>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="order_menu">
						<div class="box div-table">
							<div class="tr">
								<div class="td img"><img src="<%=SERVER_IMGPATH%><%=aRs("main_file_path")&aRs("main_file_name")%>"  onerror="this.src='http://placehold.it/160x160?text=1';" alt=""></div>
								<div class="td info">
									<div class="sum">

										<%
											End If
											upper_order_detail_idx = aRs("upper_order_detail_idx")
										%>

										<dl>
											<dt><%=aRs("menu_name")%></dt>
											<dd><%=FormatNumber(aRs("menu_price"),0)%>원 <span>/ <%=aRs("menu_qty")%>개</span></dd>
										</dl>

										<%
											If criteo_str <> "" Then ta_gubun = ","
											criteo_str = criteo_str & ta_gubun &" {id: '"& aRs("menu_idx") &"', price: '"& aRs("menu_price") &"', quantity: '"& aRs("menu_qty") &"' }"

											If mobon_str <> "" Then ta_gubun = "," ' chr(34) : "
											mobon_str = mobon_str & ta_gubun &" {productCode: '"& aRs("menu_idx") &"', productName: '"& Replace(Replace(aRs("menu_name"), chr(34), ""), "'", "") &"', price: '"& aRs("menu_price") &"', dcPrice: '"& aRs("menu_price") &"', qty: '"& aRs("menu_qty") &"' }"
											mobon_qty = mobon_qty + CInt(aRs("menu_qty"))
										%>

										<%
												aRs.MoveNext
											Loop
										%>

									</div>
								</div>
							</div>
						</div>
					</div>

					<%
						End If
					%>

<!-- 
					<%
						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select_main"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						If Not (aRs.BOF Or aRs.EOF) Then
							Do Until aRs.EOF
					%>

					<ul>
						<li class="reorder_view_img"><img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>" alt="<%=vMenuName%>" ></li>
						<li class="reorder_view_info">
							<ul>
								<li class="reorder_view_title"><%If aRs("coupon_pin") = "GIFTCOUPON" Then%>(증정쿠폰)<%End If%><%=aRs("menu_name")%></li>
								<li class="reorder_view_price"><strong><%=FormatNumber(aRs("menu_price"),0)%></strong>원  <span>/ <%=aRs("menu_qty")%>개</span></li>
							</ul>
						</li>
					</ul>

					<%
								aRs.MoveNext
							Loop
						End If

						Set aRs = Nothing
					%>

					<%
						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select_barcode"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						If Not (aRs.BOF Or aRs.EOF) Then
							isFirst = True
							Do Until aRs.EOF
					%>

					<ul>
						<li class="reorder_view_img"><img src="/images/menu/store_menu.jpg" alt="<%=vMenuName%>" onerror="this.src='http://placehold.it/160x138?text=1';" ></li>
						<li class="reorder_view_info">
							<ul>
								<li class="reorder_view_title"><%=aRs("CGOODNM")%></li>
								<li class="reorder_view_price"><strong><%=FormatNumber(aRs("FAMT"),0)%></strong>원  <span>/ <%=aRs("FQTY")%>개</span></li>
							</ul>
						</li>
					</ul>

					<%
								aRs.MoveNext
							Loop
						End If

						Set aRs = Nothing

					%>
 -->

					<%
						' 제주/산간 =========================================================================================
						plus_price = 0
						Set pCmd = Server.CreateObject("ADODB.Command")
						With pCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_order_detail_select_1138"

							.Parameters.Append .CreateParameter("@order_idx", adInteger, adParamInput, , order_idx)

							Set pRs = .Execute
						End With
						Set pCmd = Nothing

						If Not (pRs.BOF Or pRs.EOF) Then
							plus_price = (pRs("menu_price")*pRs("menu_qty"))
						End If
						' =========================================================================================

					%>

				</div>

				<div  class="reorder_view_pay">
					<ul class="reorder_view_payList">
						<li>총 상품금액 <span><%=FormatNumber(vOrderAmt,0)%><span>원</span></span></li>
						
						<%If vOrderType = "R" or vOrderType = "D" Then%>
							<li>배달비 <span><%=FormatNumber(vDeliveryFee,0)%><span>원</span></span></li>
						<%End If%>

						<li>할인금액 <span><%=FormatNumber(vDiscountAmt,0)%><span>원</span></span></li>

						<%If plus_price > 0 Then%>
							<li class="red">추가금액 <span class="red"><%=FormatNumber(plus_price,0)%><span class="red">원</span></span></li>
						<% End If %>
					</ul>
					<ul class="reorder_view_payTotal">
						<li>최종 결제금액</li>
						<li><span><%=FormatNumber(vPayAmt,0)%></span>원</li>
					</ul>
				</div>

				<ul class="reorder_view_data">
					<h4><%=order_type_title%></h4>
					<li class="reorder_view_shop">
						<h5><%=order_type_name%></h5>
						<span><%=vBranchName%></span>(<%=vBranchTel%>)
					</li>
					<li class="reorder_view_address">
						<h5><%=address_title%></h5>

						<%If vOrderType = "R" or vOrderType = "D" Then%>
							<%=vAddressName%>
							<span class="robotoR"><%=vMobile%></span>
							(<%=vZipCode%>) 
						<%End If%>
						
						<span><%=vAddress%></span>
					</li>
					<li>
						<h5>기타요청사항</h5>
						<span><%=vDeliveryMessage%></span>
					</li>
				</ul>
				<%
					' 결제수단 가져오기
					Set pCmd = Server.CreateObject("ADODB.Command")
					With pCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bp_web_order_item_pay"

						.Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, vOrderNum)

						Set pRs = .Execute
					End With
					Set pCmd = Nothing

					Dim pay_info_html : pay_info_html = "" 
					if Not (pRs.BOF or pRs.EOF) Then 
						pay_info_html = pay_info_html & "<li><h5>결제방법</h5>"
						Do until pRs.EOF
							order_detail_idx   = pRs("order_idx")
							pay_type_name      = pRs("pay_type_nm")
							payment_amt        = pRs("payment_amt")

							pay_info_html = pay_info_html & "<span>" & pay_type_name & " </span> "
							pay_info_html = pay_info_html & "<span> <span class=""robotoR price"">" & FormatNumber(payment_amt,0) & "</span>원</span><br>"

							pRs.MoveNext
						Loop
						pay_info_html = pay_info_html & "</li>"
					end if 
					set pRs = Nothing
					'// 결제수단 가져오기

					'오류 결제수단 가져오기 
					Set pCmd = Server.CreateObject("ADODB.Command")
					With pCmd
						.ActiveConnection = dbconn
						.NamedParameters = True
						.CommandType = adCmdStoredProc
						.CommandText = "bp_payment_detail_err_select"

						.Parameters.Append .CreateParameter("@order_num", advarchar, adParamInput, 40, vOrderNum)
						.Parameters.Append .CreateParameter("@pay_method", advarchar, adParamInput, 20, "GIFTCARD")

						Set pRs = .Execute
					End With
					Set pCmd = Nothing
					
					dim pay_transaction_id : pay_transaction_id = ""
					if Not (pRs.BOF or pRs.EOF) Then 
						pay_info_html = pay_info_html & "<li><h5>오류 결제수단</h5>"
						Do until pRs.EOF
							pay_transaction_id = pRs("pay_transaction_id")

							if Len(pay_transaction_id) >= 12 then
								pay_info_html = pay_info_html & "<span>" & pay_transaction_id & " </span> "
								pay_info_html = pay_info_html & "<span> <span class=""robotoR price"">" & FormatNumber(pRs("pay_amt"),0) & "</span>원</span><br>"
							end if 
							
							pRs.MoveNext
						Loop
						pay_info_html = pay_info_html & "</li>"
					end if 
					set pRs = Nothing
					'// 오류 결제수단 가져오기 
				%>
				<ul class="reorder_view_data">
					<h4>결제정보</h4>
					<%=pay_info_html%>
					<!--
					<li>
						<h5>결제방법</h5>
						<span><%=pay_type_title%> / <%=pay_type_name%></span>
					</li>
					<li>
						<h5>결제금액</h5>
						<span><span class="robotoR price"><%=FormatNumber(vPayAmt,0)%></span>원</span>
					</li>
					-->
				</ul>