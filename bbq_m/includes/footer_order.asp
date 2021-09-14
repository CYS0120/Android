<script>
	function DetailCartDiv() {
		var dd = document.getElementById("detail_cart").style.display;
		// alert(dd);

		if (dd == "block"){
			document.getElementById("detail_cart").style.display = "none";
		}else{
			document.getElementById("detail_cart").style.display = "block";
		}
	}
</script>
<%
	If right(menuKey,1) <> "_" Then
		menuKey = menuKey + "_"
	End If
%>
<!-- Footer -->
		<footer id="h-footer">	
			<button id="footer_more" class="footer_more" onclick="DetailCartDiv()"></button>
			<div id="detail_cart" class="detail_cart_div">
				<div id="detail_cart_inhtml" class="detail_cart_inner_div">

				<!-- 여기는 항목이 계속 추가되거나 삭제 될수 있다-->
					<div class="detail_cart_content" id="detail_cart_inner_main">
						<div class="dMenuText">
							<span><%=vMenuName%></span>
						</div>
						<div class="form-pm">
							<span>
								<button class="minus" onclick="control_submenu_qty('<%=menuKey%>', -1);" type="button">-</button>
								<input id="new_qty_<%=menuKey%>" type="text" value="1" readonly />
								<button class="plus" onclick="control_submenu_qty('<%=menuKey%>', 1);" type="button">+</button>
							</span>
						</div>
						<div class="menuDel main"></div>
					</div>
				<!-- 여기는 항목이 계속 추가되거나 삭제 될수 있다-->

				</div>
			</div>

			<ul class="h-footer_line"></ul>	
			<ul class="h-footer_icon_2">
				<li class="h-footer_bg_cart"><a onclick="goCart()">장바구니 담기</a></li>
				<li class="h-footer_bg_order"><a onclick="goOrder()">주문하기</a></li>
			</ul>
		</footer>
		
<!-- // Footer -->

<!-- Footer -->
<!--#include virtual="/api/ta/ta_footer.asp"-->
<!--// Footer -->