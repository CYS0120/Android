<style>
	.order_step ul			{position:relative; width:100%; margin:0 auto;background:trensform;}
	.order_step ul:after	{content:''; display:block; clear:both;}
	.order_step ul:before	{content:''; position:absolute; width:80%; height:1px; background:#ccc; top:15px; left:10%; z-index:-1;}
	.order_step ul li		{float:left; width:20%; text-align:center;}
	.order_step ul li p		{width:30px; height:30px; background:#eee; color:#aaa; line-height:30px; border-radius:100%; margin:0 auto; display:block;}
	.order_step ul li span	{display:block; text-align:center; padding:3px; font-size:.785em; color:#aaa;}

	.order_step ul li.step_on p		{font-weight:bold; background:#ff0000; color:#fff;}
	.order_step ul li.step_on span	{font-weight:bold; color:#ff0000;}
</style>

<%
	dim step_div_control : step_div_control = ";display:none;"
	dim step_num_arr(5)
	step_num_arr(1) = ""
	step_num_arr(2) = ""
	step_num_arr(3) = ""
	step_num_arr(4) = ""
	step_num_arr(5) = ""

	dim now_http_url_file : now_http_url_file = request.servervariables("HTTP_url")

	' step 1
	if instr(now_http_url_file, "delivery.asp") <> 0 or instr(now_http_url_file, "out_search.asp") <> 0 or instr(now_http_url_file, "delivery_search.asp") <> 0 then 
		step_div_control = ""
		step_num_arr(1) = " class='step_on' "
	end if 

	' step 1
	if instr(now_http_url_file, "shopList.asp") <> 0 then 
		step_div_control = ""
		step_num_arr(1) = " class='step_on' "
	end if 

	' step 2
	if instr(now_http_url_file, "menuList.asp") <> 0 or instr(now_http_url_file, "menuView.asp") <> 0 then 
		step_div_control = ""
		step_num_arr(2) = " class='step_on' "
	end if 

	' step 3
	if instr(now_http_url_file, "cart.asp") <> 0 then 
		step_div_control = ""
		step_num_arr(3) = " class='step_on' "
	end if 

	' step 4
	if instr(now_http_url_file, "payment.asp") <> 0 then 
		step_div_control = ""
		step_num_arr(4) = " class='step_on' "
	end if 

	' step 5
	if instr(now_http_url_file, "orderComplete.asp") <> 0 then 
		step_div_control = ""
		step_num_arr(5) = " class='step_on' "
	end if 
%>

<div style="padding:15px 0 5px 0; <%=step_div_control%>">

	<div class="order_step">
		<ul>
			<li <%=step_num_arr(1)%>>
				<p>1</p>
				<span>주소선택</span>
				<!-- <span>매장선택</span> -->
			</li>
			<li <%=step_num_arr(2)%>>
				<p>2</p>
				<span>메뉴선택</span>
			</li>
			<li <%=step_num_arr(3)%>>
				<p>3</p>
				<span>주문확인</span>
			</li>
			<li <%=step_num_arr(4)%>>
				<p>4</p>
				<span>결제수단</span>
			</li>
			<li <%=step_num_arr(5)%>>
				<p>5</p>
				<span>결제완료</span>
			</li>
		<ul>
	</div>

</div>