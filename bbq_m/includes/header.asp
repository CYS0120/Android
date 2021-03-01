    <!-- Header -->
    <header class="header">

		<% If PageTitle <> ""  Then %>
	        <h2><%=PageTitle%></h2>
		<% Else %>
		    <h1><a href="/">BBQ치킨</a></h1>
		<% End If %>

        <div class="btn-header-bra">
           <button type="button" class="btn btn_header_cart" onClick="javascript:location.href='/order/cart.asp';"><span class="ico-only">장바구니</span><span class="count" id="cart_item_count"></span></button>
        </div>

		<div class="btn-header-nav">
   			<%If GetUrlPath() <> "/main.asp" Then%>
	            <button type="button" onClick="javascript:history.back();" class="btn btn_header_back"><span class="ico-only">이전페이지</span></button>
				<button type="button" onClick="location.href='/main.asp'" class="btn btn_header_home"><span class="ico-only">메인으로</span></button>
			<% else %>
				<!--<button type="button" class="btn btn_header_brand ss_pc_move_N" style="display:none"><span class="ico-only">패밀리브랜드</span></button>-->
			<%End If%>
			<!--<button type="button" class="btn btn_header_menu"><span class="ico-only">메뉴</span></button>-->
        </div>
		

	</header>
    <!--// Header -->


<script type="text/javascript">
    var paycoAuthUrl = "<%=PAYCO_AUTH_URL%>";
</script>
