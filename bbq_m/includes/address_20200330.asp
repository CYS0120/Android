<style type="text/css">
	span.order_type {font-size:0.785em; background:#ff0000; color:#fff; border-radius:10px; padding:1px 10px; vertical-align:t; margin:0 10px 0 5px; }
</style>
			<!-- 회원주소 -->
			<div class="member_address">
				<p id="ship_address"></p>
				<p id="branch_name_p"><% if vBranchName <> "" then %>< <%=vBranchName%> ><% end if %></p>
			</div>
			<!-- // 회원주소 -->

			<script type="text/javascript">
				if (sessionStorage.getItem("ss_order_type") == "P") { // 포장주문일땐 사용자 주소가 없음.
					var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
				} else {
					var addr_data = JSON.parse(sessionStorage.getItem("ss_addr_data"));
					var branch_data = JSON.parse(sessionStorage.getItem("ss_branch_data"));
				}

				// 매장선택부터 않했다면 메인으로 ㄱ
				if (branch_data != "" && typeof(branch_data) != "undefined" && branch_data != "" && branch_data != null) {
				} else {
					showAlertMsg({msg:"매장선택이 안되어있습니다. 매장선택부터 해주시기 바랍니다.", ok: function(){
						document.location.href='/order/delivery.asp?order_type=D';
					}});
				}

				if (sessionStorage.getItem("ss_order_type") == "P") { // 포장주문일땐 사용자 주소가 없음.
					$('#ship_address').html('<img src="/images/main/icon_m_out.png" style="display:none; width:25px; height:25px; vertical-align:top;" class="nono"><span class="order_type">포장</span>'+ branch_data.branch_address +'<a href="javascript: goDeliveryTop(\''+ sessionStorage.getItem("ss_order_type") +'\')"><img src="/images/order/icon_refresh.png"></a>');
					$('#branch_name_p').html("< "+ branch_data.branch_name +" >");

				} else {
					$('#ship_address').html('<img src="/images/main/icon_m_order.png" style="display:none; width:25px; height:25px; vertical-align:top;" class="nono"><span class="order_type">배달</span>'+ addr_data.address_main + ' '+ addr_data.address_detail +'<a href="javascript: goDeliveryTop(\''+ sessionStorage.getItem("ss_order_type") +'\')"><img src="/images/order/icon_refresh.png"></a>');
					$('#branch_name_p').html("< "+ branch_data.branch_name +" >");
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
			</script>
