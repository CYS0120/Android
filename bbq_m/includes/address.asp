<style type="text/css">
	span.order_type {font-size:0.785em; background:#ff0000; color:#fff; border-radius:10px; padding:1px 10px; vertical-align:t; margin:0 10px 0 5px; }
</style>
			<!-- 회원주소 -->
			<div class="member_address" style="display:none">
				<p id="ship_address"></p>
				<p id="branch_name_p"><% if vBranchName <> "" then %>< <%=vBranchName%> ><% end if %></p>
			</div>
			<!-- // 회원주소 -->

			<script type="text/javascript">
				next_page_gubun = "";

				<% if Session("userIdNo") <> "" then %>
					<%
						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_member_addr_select"

							.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						dim addr_arr()
						dim first_add_yn : first_add_yn = ""

						cnt = 0
						If Not (aRs.BOF Or aRs.EOF) Then
							aRs.MoveFirst
							Do Until aRs.EOF

							overlap_yn = ""
							overlap_data = trim(aRs("address_main")) &" "& trim(aRs("address_detail"))

							if cnt = 0 then 
								redim addr_arr(cnt+1)
								addr_arr(cnt+1) = overlap_data
							else
								For aidx = 0 To UBound(addr_arr)
									if addr_arr(aidx) = overlap_data then 
										overlap_yn = "Y"
									end if 
								Next

								if overlap_yn <> "Y" then 
									redim addr_arr(cnt+1)
									addr_arr(cnt+1) = overlap_data
								end if 
							end if 

							if overlap_yn = "" then 

								If aRs("is_main") = "Y"  and first_add_yn = "" Then 
					%>
									if (sessionStorage.getItem("ss_order_type") == "P") { // 포장주문일땐 사용자 주소가 없음.
										var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
									} else {
										var addr_data = JSON.parse(sessionStorage.getItem("ss_addr_data"));
										var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
									}

									// 매장선택부터 않했다면 메인으로 ㄱ
									if (branch_data != "" && typeof(branch_data) != "undefined" && branch_data != "" && branch_data != null) {
										new_add_chk();
									} else {
										var_addr_idx = "";
										var_addr_data = "";
										var_branch_data = ""
										var_branch_id = ""
										var_branch_name = ""
										var_order_type = ""

										// 기본주소지로 매장 자동선택
										next_page_gubun = "D";
										selectShipAddress_new('<%=aRs("addr_idx")%>', 'TOP');
									}
					<%
									first_add_yn = "Y"
								end if 
							end if 

							cnt = cnt + 1
							aRs.MoveNext
							Loop
						End If
						Set aRs = Nothing
					%>

					<% if first_add_yn = "" Then %>
						new_add_chk(); // 기본주소지가 없을때 실행
					<% end if %>

				<% else %>
					new_add_chk();
				<% end if %>

				function new_add_chk() 
				{
					if (sessionStorage.getItem("ss_order_type") == "P") { // 포장주문일땐 사용자 주소가 없음.
						var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
					} else {
						var addr_data = JSON.parse(sessionStorage.getItem("ss_addr_data"));
						var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
					}

					// 매장선택부터 않했다면 메인으로 ㄱ
					if (branch_data != "" && typeof(branch_data) != "undefined" && branch_data != "" && branch_data != null) {

						$('.member_address').show(0);

						if (sessionStorage.getItem("ss_order_type") == "P") { // 포장주문일땐 사용자 주소가 없음.
							$('#ship_address').html('<img src="/images/main/icon_m_out.png" style="display:none; width:25px; height:25px; vertical-align:top;" class="nono"><span class="order_type">포장</span>'+ branch_data.branch_address +'<a href="javascript: goDeliveryTop(\''+ sessionStorage.getItem("ss_order_type") +'\')"><img src="/images/order/icon_refresh.png"></a>');
						} else {
							$('#ship_address').html('<img src="/images/main/icon_m_order.png" style="display:none; width:25px; height:25px; vertical-align:top;" class="nono"><span class="order_type">배달</span>'+ addr_data.address_main + ' '+ addr_data.address_detail +'<a href="javascript: goDeliveryTop(\''+ sessionStorage.getItem("ss_order_type") +'\')"><img src="/images/order/icon_refresh.png"></a>');
						}

						if (branch_data.branch_name != "" && typeof(branch_data.branch_name) != "undefined" && branch_data.branch_name != "" && branch_data.branch_name != null) {
						} else {
							branch_data.branch_name = "배달불가";
						}

						////홈파티 Test 1248 = 홈파티 트레이 , 치본스테이크가 장바구니에 있으면 매장선택 가능하게끔. 20201204
						if(sessionStorage.getItem("M_1695_0_") || sessionStorage.getItem("M_1696_0_")){
						    $('#branch_name_p').html("<span>🎉 홈파티 사전예약 [배달] 🍗</span>");
							sessionStorage.setItem("ss_branch_id", "7451401");
							var var_branch_data = sessionStorage.getItem("ss_branch_data")
							var jobj = JSON.parse(var_branch_data);
							jobj.branch_id = "7451401";
							jobj.branch_name = "홈파티 사전예약 매장";
							sessionStorage.setItem("ss_branch_data", JSON.stringify(jobj));
						} else if (branch_data.branch_name == "배달불가") {
							$('#branch_name_p').html("<span style='color: #ff0000'>< "+ branch_data.branch_name +" ></span>");
						} else {
							$('#branch_name_p').html("< "+ branch_data.branch_name +" >");
						}

					} else {
//						showAlertMsg({msg:"매장선택이 안되어있습니다. 매장선택부터 해주시기 바랍니다.", ok: function(){
//							document.location.href='/order/delivery.asp?order_type=D';
//						}});
					}

//					$('.member_address').show(0);
//
//					if (sessionStorage.getItem("ss_order_type") == "P") { // 포장주문일땐 사용자 주소가 없음.
//						$('#ship_address').html('<img src="/images/main/icon_m_out.png" style="display:none; width:25px; height:25px; vertical-align:top;" class="nono"><span class="order_type">포장</span>'+ branch_data.branch_address +'<a href="javascript: goDeliveryTop(\''+ sessionStorage.getItem("ss_order_type") +'\')"><img src="/images/order/icon_refresh.png"></a>');
//					} else {
//						$('#ship_address').html('<img src="/images/main/icon_m_order.png" style="display:none; width:25px; height:25px; vertical-align:top;" class="nono"><span class="order_type">배달</span>'+ addr_data.address_main + ' '+ addr_data.address_detail +'<a href="javascript: goDeliveryTop(\''+ sessionStorage.getItem("ss_order_type") +'\')"><img src="/images/order/icon_refresh.png"></a>');
//					}
//
//					if (branch_data.branch_name != "" && typeof(branch_data.branch_name) != "undefined" && branch_data.branch_name != "" && branch_data.branch_name != null) {
//					} else {
//						branch_data.branch_name = "배달불가";
//					}
//
//					if (branch_data.branch_name == "배달불가") {
//						$('#branch_name_p').html("<span style='color: #ff0000'>< "+ branch_data.branch_name +" ></span>");
//					} else {
//						$('#branch_name_p').html("< "+ branch_data.branch_name +" >");
//					}

				}

				function goDeliveryTop(t)
				{
					var cc = getAllCartMenuCount();

					if (cc > 0) {
						if (confirm("주소 변경시 장바구니는 비워집니다\n\n변경 하시겠습니까?")) {
							goDeliveryTopDetail(t)
						}
					} else {
						goDeliveryTopDetail(t)
					}
				}

				function goDeliveryTopDetail(t)
				{
					if(supportStorage()) {
						var len = sessionStorage.length
						var key_arr = new Array();
						var j=0;

						for(var i = 0; i < len; i++) {
							var key = sessionStorage.key(i);

							if (key != "" && typeof(key) != "undefined" && key != "" && key != null) {
								if (sessionStorageException(key) == false) continue;

								key_arr[j] = key;
								j++;
							} else {
							}
						}

						for(var i = 0; i < key_arr.length; i++) {
							if (key_arr[i] != "" && typeof(key_arr[i]) != "undefined" && key_arr[i] != "" && key_arr[i] != null) {
								sessionStorage.removeItem(key_arr[i]);
							}
						}
					}

					location.href = "/order/delivery.asp?order_type="+ t;
				}

				function go_next_page_map(t)
				{
					br_id = var_branch_id;
					br_data = var_branch_data;

					// 다른 매장 선택시 장바구니 상품 제거.
					change_store_cart(br_id);

					sessionStorage.setItem("ss_branch_id", br_id);
					sessionStorage.setItem("ss_branch_data", br_data);

					new_add_chk();
				}
			</script>