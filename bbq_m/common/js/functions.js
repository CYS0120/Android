var domain = "mobile";

function getProduct(menu_idx) {
    $.ajax({
        method: "post",
        url: "/api/ajax/ajax_getProduct.asp",
        data: {"menu_idx": menu_idx},
        success: function(data) {

        }
    });
}

// Address 정보 가져오기
function getAddress(addr_idx) {
    $.ajax({
        method: "post",
        url: "/api/ajax/ajax_getAddress.asp",
        data: {"addr_idx": addr_idx},
        success: function(data) {

        }
    });
}
// Address 정보 셋팅
function setAddress(addr_idx) {
    $.ajax({
        method: "post",
        url: "/api/ajax/ajax_getAddress.asp",
        data: {addr_idx: addr_idx},
        dataType: "json",
        success: function(res) {
            if(res.length == 1) {
                $("#form_addr [name=addr_idx]").val(addr_idx);
                $("#form_addr [name=mode]").val("U");
                $("#form_addr [name=addr_type]").val(res[0].addr_type);
                $("#form_addr [name=address_jibun]").val(res[0].address_jibun);
                $("#form_addr [name=address_road]").val(res[0].address_road);
                $("#form_addr [name=sido]").val(res[0].sido);
                $("#form_addr [name=sigungu]").val(res[0].sigungu);
                $("#form_addr [name=sigungu_code]").val(res[0].sigungu_code);
                $("#form_addr [name=roadname_code]").val(res[0].roadname_code);
                $("#form_addr [name=b_name]").val(res[0].bname);
                $("#form_addr [name=b_code]").val(res[0].b_code);
                $("#form_addr [name=mobile]").val(res[0].mobile);
                $("#form_addr [name=lng]").val(res[0].lng);
                $("#form_addr [name=lat]").val(res[0].lat);

                $("#form_addr [name=addr_name]").val(res[0].addr_name);
                if(res[0].mobile != "") {
                    $("#form_addr [name=mobile1]").val(res[0].mobile.split("-")[0]);
                    $("#form_addr [name=mobile2]").val(res[0].mobile.split("-")[1]);
                    $("#form_addr [name=mobile3]").val(res[0].mobile.split("-")[2]);
                }
                $("#form_addr [name=zip_code]").val(res[0].zip_code);
                $("#form_addr [name=address_main]").val(res[0].address_main);
                $("#form_addr [name=address_detail]").val(res[0].address_detail);
				
				if(typeof($("#form_addr [name=h_code]")) != 'undefined'){
					//기존에 등록된 배달지 중 행정동코드(h_code)가 없는 경우 h_code 가져오기
					if(res[0].h_code == ""){
						var query = res[0].address_road;
						
						if(query == "")
							query = res[0].address_jibun;
						
						selectCoordHCode("F", addr_idx, query, $("#form_addr [name=h_code]"));
					}else{
						$("#form_addr [name=h_code]").val(res[0].h_code);
					}
				}
            }
        }
    });
}

function delAddress(addr_idx) {
    if(window.confirm("주소지를 삭제하시겠습니까?")) {
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_delAddress.asp",
            data: {addr_idx: addr_idx},
            dataType: "json",
            success: function(res) {
                if(res.result == 0) {
                    showAlertMsg({msg:res.message, ok: function(){
                        $("#addr_"+addr_idx).remove();
						$("#delivery_addr_"+addr_idx).remove();
                    }});
                } else {
                    showAlertMsg({msg:res.message});
                }
            }
        });
    }
}

function setMainAddress(addr_idx) {
    if(window.confirm("기본 배달지로 설정하시겠습니까?")) {
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_setMainAddress.asp",
            data: {addr_idx: addr_idx},
            success: function(data) {
                var result = JSON.parse(data);

                if(result.result == 0) {
					$('.add_del_span').show(0);

                    if(result.paddr_idx > 0) {
                        $("#addr_"+result.paddr_idx+" .name").html($("#addr_"+result.paddr_idx+" div.name").html().replace("<span class=\"red\">[기본배달지]</span> ",""));
                        $("#addr_"+result.paddr_idx+" .btn-wrap .btn-left").html("<button type=\"button\" class=\"btn btn_small2 btn-brown\" onClick=\"javascript:setMainAddress('"+result.paddr_idx+"');\">기본배달지 설정<button>");

						$('#add_del_'+ addr_idx).hide(0);
                    }

                    $("#addr_"+result.addr_idx+" .name").html("<span class=\"red\">[기본배달지]</span> "+$("#addr_"+result.addr_idx+" div.name").html());
                    $("#addr_"+result.addr_idx+" .btn-wrap .btn-left").html("");
                } else {
                    showAlertMsg({msg:result.message});
                }
            }
        });
    }
}

function validAddress() {
    var addr_name = $.trim($("#form_addr input[name=addr_name]").val());
    var zip_code = $.trim($("#form_addr input[name=zip_code]").val());
    var address_main = $.trim($("#form_addr input[name=address_main]").val());
    var address_detail = $.trim($("#form_addr input[name=address_detail]").val());
    var mobile1 = $.trim($("#form_addr input[name=mobile1]").val());
    var mobile2 = $.trim($("#form_addr input[name=mobile2]").val());
    var mobile3 = $.trim($("#form_addr input[name=mobile3]").val());

    // if (addr_name == "") {
    //     showAlertMsg({msg:"주소명을 입력하세요."});
    //     return false;
    // }
    if (zip_code == "") {
        showAlertMsg({msg:"주소를 선택하세요."});
        return false;
    }
    if(address_main == "") {
        showAlertMsg({msg:"주소를 선택하세요."});
        return false;
    }
    if(address_detail == "") {
        showAlertMsg({msg:"상세주소를 입력하세요."});
        return false;
    }
    // if(mobile1 == "" || mobile2 == "" || mobile3 == "") {
    //     showAlertMsg({msg:"전화번호를 입력하세요."});
    //     return false;
    // }

    // $("#form_addr input[name=mobile]").val(mobile1+"-"+mobile2+"-"+mobile3);

    saveAddress();
}

function validAddressNoMember() {
    var addr_name = $.trim($("#form_addr input[name=addr_name]").val());
    var zip_code = $.trim($("#form_addr input[name=zip_code]").val());
    var address_main = $.trim($("#form_addr input[name=address_main]").val());
    var address_detail = $.trim($("#form_addr input[name=address_detail]").val());
    var mobile1 = $.trim($("#form_addr input[name=mobile1]").val());
    var mobile2 = $.trim($("#form_addr input[name=mobile2]").val());
    var mobile3 = $.trim($("#form_addr input[name=mobile3]").val());

	$("#address_main").val($("#address_main2").val());

	
    // if (addr_name == "") {
    //     showAlertMsg({msg:"주소명을 입력하세요."});
    //     return false;
    // }
    if (zip_code == "") {
        showAlertMsg({msg:"주소를 선택하세요."});
        return false;
    }
    if(address_main == "") {
        showAlertMsg({msg:"주소를 선택하세요."});
        return false;
    }
    if(address_detail == "") {
        showAlertMsg({msg:"상세주소를 입력하세요."});
        return false;
    }
    // if(mobile1 == "" || mobile2 == "" || mobile3 == "") {
    //     showAlertMsg({msg:"전화번호를 입력하세요."});
    //     return false;
    // }

    // $("#form_addr input[name=mobile]").val(mobile1+"-"+mobile2+"-"+mobile3);

    saveAddress();
}

// Address 저장
function saveAddress() {
    if(isLoggedIn) {
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_saveAddress.asp",
            data: $("#form_addr").serialize(),
            dataType: "json",
            success: function(data) {
                //var jsonData = $(data);

				console.log(1);
				console.log(data.success)
                if(data.success) {
					console.log(2);
					addr_img_control(data.addr_idx);
//					location.href="/order/delivery.asp?order_type="+ order_type_str;
//					location.href = returnUrl;
                } else {
                    showAlertMsg({msg:"주소를 저장하지 못했습니다."});
                    return;
                }
            },
            error: function(xhr, status, error) {
                showAlertMsg({msg:error});
            }
        });
    } else {
        var addrdata = dataToJson($("#form_addr"));

        saveTempAddress(addrdata);

        //clearAddressForm();

		console.log(3);
		
		addr_img_control(0);

//        setTempAddress();
//
//		location.href="/order/delivery.asp?order_type="+ order_type_str;
        // lpClose(".lp_addShipping");
    }
}

function clearAddressForm() {
    $("#form_addr").find("input[type=text], input[type=hidden]").val("");
}

//--------------------------------------------------------
// 장바구니....
//--------------------------------------------------------
function drawCart() {
    var menu_key = (current_menu_key === "undefined")? "": current_menu_key;

    var len = sessionStorage.length;
    var menu_amt = 0;
    var side_amt = 0;

    $(".payment > .addmenu").html("");

    for(var i = 0; i < len; i++) {
        var key = sessionStorage.key(i);
        if(key == ta_id) continue;
		if(key.substring(0, 3) == "ss_") continue;

        if(menu_key != "" && key != menu_key) continue;

        var it = JSON.parse(sessionStorage.getItem(key));

        menu_amt += (Number(it.price) * Number(it.qty));

		$('#qty_'+ key).val(it.qty);

        var ht = "";

//        ht += "<dl class=\"chicken\">\n";
//        ht += "\t<dt>"+it.nm+"</dt>\n";
//        ht += "\t<dd>\n";
//        ht += "\t\t<span class=\"form-pm\">\n";
//        ht += "\t\t\t<button type=\"button\" class=\"minus\" onClick=\"javascript:changeMenuQty('"+key+"',-1);\">-</button>";
//        ht += "\t\t\t<input type=\"text\" id=\"qty_"+key+"\" value=\""+it.qty+"\">\n";
//        ht += "\t\t\t<button type=\"button\" class=\"plus\" onClick=\"javascript:changeMenuQty('"+key+"', 1);\">+</button>";
//        ht += "\t\t</span>";
//        ht += "\t\t<div class=\"mon\">"+addCommas(Number(it.price) * Number(it.qty) )+"원</div>\n";
//        ht += "\t</dd>";
//        ht += "</dl>";

        if(it.hasOwnProperty("side")) {
            for(var skey in it.side) {

//                $("#"+skey+" :checkbox").prop("checked", true);

                var side = it.side[skey];

                side_amt += (Number(side.price) * Number(side.qty));

                var side_key = side.type+"_"+side.idx+"_"+side.opt;

				ht += '<input type="hidden" name="hide_side_'+ skey +'" class="hide_side" value="'+ skey +'">';

//                ht += "<dl>\n";
//                ht += "\t<dt>"+side.nm+"</dt>\n";
//                ht += "\t<dd>\n";
//                ht += "\t\t<span class=\"form-pm\">\n";
//                ht += "\t\t\t<button type=\"button\" class=\"minus\" onClick=\"javascript:changeSideQty('"+key+"','"+skey+"',-1);\">-</button>";
//                ht += "\t\t\t<input type=\"text\" id=\"qty_"+skey+"\" value=\""+side.qty+"\">\n";
//                ht += "\t\t\t<button type=\"button\" class=\"plus\" onClick=\"javascript:changeSideQty('"+key+"','"+skey+"',1);\">+</button>";
//                ht += "\t\t</span>";
//                ht += "\t\t<div class=\"mon\">"+addCommas(Number(side.price)*Number(side.qty))+"원<button type=\"button\" class=\"delete\" onclick=\"javascript:removeCartSideNew('"+key+"','"+side_key+"');\">삭제버튼</button></div>\n";
//                ht += "\t</dd>";
//                ht += "</dl>";

//                $("#"+skey+" :checkbox").prop("checked", true);
            }
        }

        $(".payment > .addmenu").append(ht);
    }

//    $("#item_amount").text(numberWithCommas(menu_amt)+"원");
//    $("#side_amount").text(numberWithCommas(side_amt)+"원");
//    $("#pay_amount").text(numberWithCommas(menu_amt+side_amt)+"원");
}

function openCart() {
    if($(".cart-fix").hasClass("on")) {
        closeCart();
        lpOpen2("#lp_cart");
        // if(window.confirm("선택하신 메뉴를 장바구니에 담았습니다.\n장바구니로 이동하시겠습니까?")) {
        //     location.href = "/order/cart.asp";
        // }
    } else {
        $(".cart-fix").addClass("on");
        $(".menu-cart").fadeIn(500);
        $("html").addClass("fix");
    }
}

function closeCart() {
    $(".cart-fix").removeClass("on");
    $(".menu-cart").fadeOut(500);
    $("html").removeClass("fix");
}

function drawCartPage(page){
    var len = sessionStorage.length;
    var goods_len = getAllCartMenuCount()+getCartEcAmtCount(); //getCartEcAmtCount : 금액권 갯수 가져오기
    var menu_amt = 0;
    var side_amt = 0;
	var ec_amt = 0;
	var partyYn = false;
	var partyAndEcYn = false;

    if(page == "C") {
        $("#cart_list .order_menu").remove();
        $("#order_type_info").show();
    } else if(page == "P") {
        $("#payment_list .order_menu").remove();
    }

    if(goods_len == 0) {
        var ht = "";

        ht += "<div class=\"cart_empty\"><p>장바구니에 담긴 상품이<br>없습니다.</p></div>\n";
        ht += "<div class=\"mar-t20\">\n";
        ht += "\t<button type=\"button\" onclick=\"location.href='/menu/menuList.asp';\"  class=\"btn btn_middle btn-redLine\">메뉴 보러가기</button>\n";
        ht += "</div>\n";

        $("#cart_list").html(ht);
        $("#order_type_info").hide();
    } else {
		//홈파티 메뉴 있을 때, 모바일상품권 지우기
		if(getCartPartyCount() != 0){
			partyYn = true;
		
			if(getCartEcAmtCount() != 0){
				partyAndEcYn = true;
			}
		}
		
        for(var i = 0; i < len; i++) {
			var side_amt_new = 0;
            var key = sessionStorage.key(i);

			if (sessionStorageException(key) == false) continue;

            var it = JSON.parse(sessionStorage.getItem(key));
			if (it.pin != ''){
				if(partyYn){
					partyAndEcYn = true;
					continue;
				}
				if (it.nm.indexOf('[에버랜드 프로모션]') != -1) {
					it.price = it.price;
				} else{
					ec_amt = ec_amt + Number(it.price);
					it.price = 0;
				}
			}
            var it_amt = (Number(it.price) * Number(it.qty)); 
            menu_amt += (Number(it.price) * Number(it.qty));

            var ht = "";
			var mkey = it.type +"_"+ it.idx +"_"+ it.opt +"_"+ it.pin

//			console.log(it);

			if (sessionStorage.getItem("ss_order_type") == "D"){
				if (it.kindSel != "115"){
					ht = getCartList(it, mkey, key, it_amt, page, side_amt_new );
				}
			} else {
				ht = getCartList(it, mkey, key, it_amt, page, side_amt_new );
			}

//            ht += "<div class=\"order_menu\">\n";
//            ht += "\t<div class=\"div-table\">\n";
//            ht += "\t\t<div class=\"tr\">\n";
//            ht += "\t\t\t<div class=\"td img\"><img src=\""+it.img+"\" onerror=\"this.src='http://placehold.it/160x160?text=1';\" alt=\"\"></div>";
//            ht += "\t\t\t<div class=\"td info\">";
//            ht += "\t\t\t\t<div class=\"sum\">";
//            ht += "\t\t\t\t\t<dl>\n";
//            ht += "\t\t\t\t\t\t<dt>"+it.nm+"</dt>\n";
//            ht += "\t\t\t\t\t\t<dd>"+numberWithCommas(Number(it.price))+"원 <span>/ "+it.qty+"개</span>";
//			if (it.pin != ''){
//				ht += "<font color='red'>[E-쿠폰]</font>\n";
//			}
//            ht += "</dd>\n";
//			ht += "\t\t\t\t\t</dl>\n";
//
//            if(it.hasOwnProperty("side")) {
//                for(var skey in it.side) {
//
//                    $("#"+skey+" :checkbox").prop("checked", true);
//
//                    var side = it.side[skey];
//
//                    side_amt += (Number(side.price) * Number(side.qty));
//
//                    ht += "\t\t\t\t\t<dl>\n";
//                    ht += "\t\t\t\t\t\t<dt>- "+side.nm+"</dt>\n";
//                    ht += "\t\t\t\t\t\t<dd>"+numberWithCommas(Number(side.price))+"원 <span>/ "+side.qty+"개</span></dd>\n";
//                    ht += "\t\t\t\t\t</dl>\n";
//                }
//            }
//
//            ht += "\t\t\t\t</div>\n";
//            if(page == "C") {
//                ht += "\t\t\t\t<div class=\"mar-t15 ta-r\">\n";
//                ht += "\t\t\t\t\t<button type=\"button\" onclick=\"openSideChange('"+key+"');\" class=\"btn btn-sm btn-brown btn_sideChange\">사이드/수량변경</button>\n";
//                ht += "\t\t\t\t</div>";
//                ht += "\t\t\t\t<button type=\"button\" class=\"btn_del\" onClick=\"javascript:removeCartMenu('"+key+"');\">삭제</button>\n";
//            }
//            ht += "\t\t\t</div>";
//            ht += "\t\t</div>";
//            ht += "\t<div>";
            ht += "</div>";
			
            if(page == "C") {
                if($("#cart_list .order_menu").length == 0) {
                    $("#cart_list").prepend(ht);
                } else {
                    $(ht).insertAfter($("#cart_list .order_menu").last());
                }
            } else if(page == "P") {
                if($("#payment_list .order_menu").length == 0) {
                    $(ht).insertAfter($("#payment_list .order_head"));
                } else {
                    $(ht).insertAfter($("#payment_list .order_menu").last());
                }
            }
        }
		
		
//        $("#item_amount").text(numberWithCommas(menu_amt+side_amt)+"원");
        $("#total_amount").html(numberWithCommas(menu_amt+side_amt+delivery_amt-Number(getCartEcAmt()))+"<span>원</span>");
		$("#total_amount_h").val(menu_amt+side_amt+delivery_amt-Number(getCartEcAmt()));
    }
	
	var ht_ec = "";
	//if (ec_amt > 0 || Number(getCartEcAmt()) > 0
	//	|| (document.getElementById("blnMyECoupon") != null && document.getElementById("blnMyECoupon").value == "Y")) {
		ec_amt = ec_amt + Number(getCartEcAmt());
		console.log("==ec_amt : "+ ec_amt);
		ht_ec += "<div id=\"div_coupon_amt\"><ul class=\"cart_total\">\n";
		ht_ec += "<li>모바일상품권 금액</li>\n";
		ht_ec += "<li id=\"ec_total_amount\">"+numberWithCommas(ec_amt)+"<span>원</span>\n";
		ht_ec += "&nbsp;&nbsp;<button type=\"button\" class=\"btn btn_small4 btn-red\" onclick=\"javascript:if(drawCouponFromCart('C')){lpOpen('.lp_cartCoupon');}\">추가</button></li>\n";
		ht_ec += "</ul><font align='left' color='red'>* 모바일상품권 금액 이상 메뉴 변경 가능</font></div>\n";
		ht_ec += "<input type=\"hidden\" id=\"ec_total_amount_h\" value=\""+ec_amt+"\" />\n";

		if(page == "C") {
			if($("#div_coupon_amt").length > 0) {
				$("#div_coupon_amt").remove();
			}
			$("#divSaveMenu").prepend(ht_ec);
		}
	//}
	if(partyAndEcYn){
		resetCartMenuEcAmt();
		showAlertMsg({msg:"송도맥주축제 메뉴에는 모바일상품권을 사용할 수 없습니다.", ok: function(){			
			if(page == "C") {
				location.href = "/order/cart.asp";
			}
		}});
	}
}

function getCartList(it, mkey, key, it_amt, page, side_amt_new) {
	ht = "<div class=\"order_menu\">\n";
	ht += "<ul id='cart_list_"+ mkey +"' class='cart_list' >";
	ht += "	<li class='cart_img'><img src='"+it.img+"'></li>";
	ht += "	<li class='cart_info'>";
	ht += "		<dl>";
	ht += "			<dt>";
	ht += "			"+it.nm+"";
	if (it.pin != ''){
		ht += " <font color='red'>[모바일 상품권]</font>\n";
	}

	if(page == "C") {
		if (it.pin != '' && it.nm.indexOf('[에버랜드 프로모션]') == -1){
			ht += "<button type=\"button\" class=\"btn-amt\" onClick=\"couponToAmt('"+key+"'); \">메뉴 변경</button>\n";
		}else{
			ht += "<button type=\"button\" class=\"btn-del\" onClick=\"removeCartMenu('"+key+"'); getMenuRecom(); \">삭제</button>\n";
		}
	}
	ht += "			</dt>";
	ht += "			<dd class='cart_choice'>&nbsp;<span>기본 : <span>"+numberWithCommas(Number(it.price))+"</span>원</span></dd>";

	if(it.hasOwnProperty("side")) {
		for(var skey in it.side) {
			if(it.side.hasOwnProperty(skey)) {
				var side = it.side[skey];
				var skey = side.type +"_"+ side.idx +"_"+ side.opt +"_"+ side.pin;

				side_amt_new += (Number(side.price) * Number(side.qty));
				side_amt += (Number(side.price) * Number(side.qty));

				ht += "			<dd class='cart_choice'>";
				ht += "			"+ side.nm +"<span><span>"+numberWithCommas(Number(side.price))+"</span>원</span>";
				ht += "			<input type='hidden' id='S_"+ side.idx +"_hide' name='S_"+ side.idx +"_hide' class='side_hide_class' sidx='"+ side.idx +"' value='"+ skey +"'>";
				ht += "			</dd>";
			}
		}
	}


	ht += "			<dd class='cart_num'>";
	ht += "				<span>"+ numberWithCommas(Number(it_amt + side_amt_new)) +"</span>원";
	ht += "				<span class='form-pm2'>";
	if (it.pin != '') {
		ht += "					<button class='minus' type='button'>-</button>";
		ht += "					<input id='new_qty_"+ mkey +"' type='text' value='"+it.qty+"' readonly />";
		ht += "					<button class='plus' type='button'>-</button>";
	}
	else
	{
		ht += "					<button class='minus' onclick=\"goCartTxt('"+ mkey +"', -1);\" type='button'>-</button>";
		ht += "					<input id='new_qty_"+ mkey +"' type='text' value='"+it.qty+"' readonly />";
		ht += "					<button class='plus' onclick=\"goCartTxt('"+ mkey +"', 1);\" type='button'>-</button>";
		}
	ht += "				</span>";
	ht += "			</dd>";
	ht += "		</dl>";
	ht += "	</li>";
	ht += "</ul>";
	ht += "</div>";
	return ht;
}

// function getMenuRecom()
// {
// 	var key_arr = Array();
// 	var len = sessionStorage.length

// 	for(var i = 0; i < len; i++) {
// 		var key = sessionStorage.key(i);

// 		if (sessionStorageException(key) == false) continue;

// 		key_obj = getCartMenu(key);

// 		key_arr.push(key_obj.idx);
// 	}

// 	if (key_arr.length > 0)
// 	{
// 		menu_key = JSON.stringify(key_arr);

// 		$.ajax({
// 			method: "post",
// 			url: "/api/ajax/ajax_getCartRecom.asp",
// 			traditional : true,
// 			data: {"menu_key" : menu_key},
// 			dataType: "json",
// 			success: function(cart_recom_list) {

// 				var ht = "";
// 				if($(cart_recom_list).length > 0) 
// 				{
// 					ht += "<div class='page_title'>";
// 					ht += "	<p>추천메뉴</p>";
// 					ht += "</div>";
// 					ht += "<div class='menu-list2'>";

// 					$.each(cart_recom_list, function(k, v) 
// 					{
// 						opt_idx = 0;
// 						menuKey = "M_"+ v.menu_idx +"_"+ opt_idx+"_";
// 						menuItem = "M$$"+ v.menu_idx +"$$"+ opt_idx +"$$"+ v.menu_price +"$$"+ v.menu_name +"$$"+ g2_bbq_img_url + v.THUMB_FILEPATH + v.THUMB_FILENAME;

// 						ht += "	<div class='menuBox' id='recom_div_"+ menuKey +"'>";
// 						ht += "		<ul class='menuWrap'>";
// 						//ht += "			<li class='menuWrap_checkbox'>";
// 						//ht += "				<a href=\"javascript: goAddCart_Recom('"+ menuKey +"', '"+ menuItem +"'); \">장바구니</a>";
// 						//ht += "			</li>";
// 						ht += "			<li class='menuImg'  onclick=\"location.href='/menu/menuView.asp?midx="+ v.menu_idx +"'\"><img src='"+ g2_bbq_img_url +""+ v.THUMB_FILEPATH +""+ v.THUMB_FILENAME +"' alt=''></li>";
// 						ht += "			<li class='menuText'>";
// 						ht += "				<h4>"+ v.menu_name +"</h4>";
// 						ht += "				<ul>";
// 						ht += "					<li><span>"+ v.menu_price_format +"</span>원</li>";
// 						ht += "					<li>";
// 						ht += "						<span class='form-pm2'>";
// 						ht += "							<button class='minus' onclick=\"goCartTxt_Recom('"+ menuKey +"', -1);\" type='button'>-</button>";
// 						ht += "							<input id='new_qty_"+ menuKey +"' type='text' readonly='' value='1'>";
// 						ht += "							<button class='plus' onclick=\"goCartTxt_Recom('"+ menuKey +"', 1);\" type='button'>-</button>";
// 						ht += "						</span>";
// 						ht += "					</li>";
// 						ht += "					<li><a href=\"javascript: goAddCart_Recom('"+ menuKey +"', '"+ menuItem +"'); \" class='btn_sidemenu_add mgL5'>추가</a></li>";
// 						ht += "				</ul>";
// 						ht += "			</li>";
						
// 						ht += "		</ul>";


// 						ht += "	</div>";
// 					});

// 					ht += "</div>";

// 					$('#recom_div').html(ht);
// 				}
// 			}
// 		});
// 	}
// }

//여러 e쿠폰 번호 선택 후, 사용하기 
function eCouponUse(page) {
	var saveYN = "";
	var pinObj, saveCartYN, drawCouponYn, goUrl;
	switch(page){
		case 'UA': //coupon_use - 추가 add
			saveYN = 'N'; 
			pinObj = $("input[name=txtPIN]"); 
			saveCartYN = 'N';
			drawCouponYn = 'Y';
			goUrl = '';
			break;
		case 'UU': //coupon_use - 사용하기 use
			saveYN = 'N';
			pinObj = $("input[name=chkEcoupon]"); 
			saveCartYN = 'Y';
			drawCouponYn = 'N';
			goUrl = '/order/cart.asp';
			break;
		case 'LA': //couponList - 추가 add
			saveYN = 'Y'; 
			pinObj = $("input[name=txtPIN]"); 
			saveCartYN = 'N';
			drawCouponYn = 'N';
			goUrl = './couponList.asp?couponList=Ecoupon';
			break;
		case 'LU': //couponList - 사용하기 use
			saveYN = 'N';
			pinObj = $("input[name=chkEcoupon]"); 
			saveCartYN = 'Y';
			drawCouponYn = 'N';
			goUrl = '/order/cart.asp';
			break;
		case 'CA': //cart - 추가 add
			saveYN = 'N';
			pinObj = $("input[name=txtPIN]"); 
			saveCartYN = 'N';
			drawCouponYn = 'Y';
			goUrl = '';
			break;
		case 'CU': //cart - 사용하기 use
			saveYN = 'N';
			pinObj = $("input[name=chkEcoupon]"); 
			saveCartYN = 'Y';
			drawCouponYn = 'N';
			goUrl = '/order/cart.asp';
			break;
	}
	
	if(saveYN == "") return;
	
	var couponList = eCouponObjToString(pinObj);
	if (couponList === undefined || couponList == "") {
		var msgText;
		//if($(pinObj).attr("type") == "checkbox")
		//	msgText = '모바일상품권을 선택하세요.';
		if($(pinObj).attr("type") == "text"){
			msgText = '모바일상품권번호를 입력하세요.';
			
			showAlertMsg({
				msg: msgText
			});
			return;
		}
	}
	if($(pinObj).attr("type") == "text"){
		if(chkCouponDup(couponList)){ //중복
			pinObj.val(couponList);
			showAlertMsg({
				msg: "해당하는 모바일상품권은 이미 등록 되어있습니다."
			});
			return;
		}
	} 
	
	getECouponInfo(saveYN, couponList, saveCartYN, drawCouponYn, goUrl); //e쿠폰 정보 가져오기
}

function eCouponObjToString(pinObj){
	var couponList = "";
	if($(pinObj).attr("type") == "checkbox"){
		$(pinObj).each(function(){
			if (this.checked) {
				var pin = $(this).val();
			
				if (pin != ""){
					if(couponList != "") {
						couponList += "||";
					}
					couponList += pin;
				}
			}
		});
	}else if($(pinObj).attr("type") == "text"){
		var pin = $(pinObj).val();
		
		$(pinObj).val('');
		if (pin != "") {
			couponList = pin;
		}
	}
	return couponList;
}

function chkCouponDup(txtPin){
	//중복 체크 
	var result = false; //중복 아님
	if($("input[name=chkEcoupon]").val() === undefined){
	}else {
		$("input[name=chkEcoupon]").each(function(){
			if( $(this).val() == txtPin){ 
				result = true; //중복
			}
		});
	}
	return result;
}

//e쿠폰 정보 가져와서 상태 검사하고 HTML 만들기 
function getECouponInfo(saveYN, couponList, saveCartYN, drawCouponYn, goUrl){
	if (couponList != "") {
		var jsonData = {
			"txtPIN": couponList,
			"PIN_save": saveYN
		};
		
		var targetUrl = "/api/ajax/ajax_getEcouponAll.asp";
		var cartList = getCouponFromCart();
		var ecAmtPin = "";
		
		$.ajax({
			method: "post",
			url: targetUrl,
			data: jsonData,
			dataType: "json",
			success: function(res) {				
				if (res.result == 0) {
					if(saveCartYN == "Y") {
						ecAmtPin = getCartEcPinList(); 
						console.log("ecAmtPin:" + ecAmtPin);
						resetCartMenuEcAmt(); //e쿠폰+금액권 장바구니 비우기
					}
					var ht = "";
					$.each(res.menuItemList, function(k,v) {
						
						if(saveCartYN == "Y") {
							addCartMenu(v.menuItem);
							console.log('add : '+ v.menuItem)
						}else {	
							if($("input[name=chkEcoupon]").val() != undefined && $("input[name=chkEcoupon]").val() != ""){
								$("input[name=chkEcoupon]").each(function(){
									if(cartList.indexOf($(this).val()) != -1) {
										$(this).prop("checked", true);
									}else {
										$(this).prop("checked", false);
									}
								});
							}
						}
						
						if(drawCouponYn == "Y") {
							var strChecked = "";
							if(cartList != "") {
								if(cartList.indexOf(v.pin) != -1)
									strChecked = "checked";
							}
							ht += '<div class="divCouponItem">';
							ht += '<div class="coupon">';
							ht += '	<dl class="info">';
							ht += '        <label class="checkbox">';
							ht += '		<dt><input type="checkbox" name="chkEcoupon" id="chkEcoupon1'+k+'" value="'+ v.pin +'" ' + strChecked + '/> <b>'+ v.title +'</b></dt>';
							ht += '		<dd>';
							ht += '        번&nbsp;&nbsp;&nbsp;&nbsp;호 : '+ v.pin +'<br/>';
							ht += '		   금&nbsp;&nbsp;&nbsp;&nbsp;액 : '+ addCommas(v.price) +'<br/>';
							ht += '		   유효기간 : '+ v.useSDate +' ~ '+ v.useEDate +'';
							ht += '		</dd>';
							ht += '        </label>';
							ht += '	</dl>';
							ht += '</div><div class="txt"><br/>  </div></div>';
						}
					});
					
					if (ht != "") {
						$("#divCouponUse").prepend(ht);
						$("#divCouponUse").show();
					}
					if (goUrl != ""){
						if(saveCartYN == "Y" && ecAmtPin != "") {
							alert("이전의 e쿠폰 메뉴 변경 내용이 사라집니다. \n메뉴 변경을 원하시면 e쿠폰 우측 상단의 [메뉴 변경]을 클릭해주세요.");
						}
						location.href = goUrl;
						console.log('---- goURL ');
					}
				}else {
					showAlertMsg({
						msg: res.message
					});
				}
			},
			error: function(data, status, err) {
				showAlertMsg({
					msg: data + ' ' + status + ' ' + err
				});
				return false;
			}
		});
	}else {
		//선택한 모바일상품권이 없을 때 e쿠폰 장바구니 비우기
		alert("모바일상품권을 사용하지 않습니다.");
		resetCartMenuEcAmt(); //e쿠폰+금액권 장바구니 비우기
		if (goUrl != ""){
			location.href = goUrl;
		}
	}
}

function drawCouponFromCart(page){
	//마이페이지 등록된 모바일상품권 제외하고 Cart에 있는 coupon list 가져오기
    var len = sessionStorage.length;
    var couponList = "";
    var retrun_val = false;
    if(page == "C") {
        $(".divCouponItem .coupon").remove(); //Cart에서 가져온 item 지우기 
    //} else if(page == "P") {
    //    $("#payment_list .order_menu").remove();
    }
    if(supportStorage()) {
		if(getCartPartyCount()==0){
			for(var i = 0; i < len; i++) {
				var key = sessionStorage.key(i);
				
				if(key == null) continue;
				
				if(key.substring(0, 3) == "ec_" || key.substring(0, 2) == "M_" ) {
					var str = sessionStorage.getItem(key);
					
					if(str === null || str == "" || str === undefined || str == "undefined") continue;
					
					var it = JSON.parse(str);
					if (it.pin != ''){
						if($("input[name=chkEcoupon]").val() === undefined){
							if(couponList != "") couponList +=  "||";
							couponList +=  it.pin;
						}else{
							var blnDisplayYn = false;
							$("input[name=chkEcoupon]").each(function(){
								if( $(this).val() == it.pin) {
									//마이페이지 등록되어 이미 화면에 뿌려진 쿠폰이면 skip 
									blnDisplayYn = true;
									return false; //break loop
								
								}
							});
							if (!blnDisplayYn) {
								if(couponList != "") couponList +=  "||";
								couponList +=  it.pin;
								console.log("key:" + key + ", couponList:" + couponList);
							}
						}
					}
				}
			}
			
			//coupon html 만들기 
			if(couponList != "")
				getECouponInfo('N', couponList, 'N', 'Y', '');
			
			retrun_val = true;
		}else{
			showAlertMsg({msg:"송도맥주축제 메뉴에는 모바일상품권을 사용할 수 없습니다."});
			retrun_val = false;
		}
	}
	return retrun_val;
}


function getCouponFromCart(){
	//마이페이지 등록된 모바일상품권 제외하고 Cart에 있는 coupon list 가져오기
    var len = sessionStorage.length;
    var cartList = "";

    if(supportStorage()) {
		for(var i = 0; i < len; i++) {
			var key = sessionStorage.key(i);
			
			if(key == null) continue;
			if(key.substring(0, 3) == "ec_" || key.substring(0, 2) == "M_" ) {
				var str = sessionStorage.getItem(key);
				
				if(str === null || str == "" || str === undefined || str == "undefined") continue;
				
				var it = JSON.parse(str);
				if (it.pin != ''){
					if(cartList != "") cartList +=  "||";
					cartList +=  it.pin;
				}
			}
		}
		
		return cartList;
	}
}
function getMenuRecom(menu_idx)
{
   if (menu_idx != null && menu_idx.length > 0)
   {
      menu_key = "[" + menu_idx + "]";
// alert(menu_key);
      $.ajax({
         method: "post",
         url: "/api/ajax/ajax_getCartRecom.asp",
         traditional : true,
         data: {"menu_key" : menu_key},
         dataType: "json",
         success: function(cart_recom_list) {

            var ht = "";
            if($(cart_recom_list).length > 0) 
            {
               ht += "<div class='page_title'>";
               ht += "   <p>추천메뉴</p>";
               ht += "</div>";
               ht += "<div class='menu-list2'>";

               $.each(cart_recom_list, function(k, v) 
               {
                  opt_idx = 0;
                  menuKey = "M_"+ v.menu_idx +"_"+ opt_idx+"_";
                  menuItem = "M$$"+ v.menu_idx +"$$"+ opt_idx +"$$"+ v.menu_price +"$$"+ v.menu_name +"$$"+ g2_bbq_img_url + v.THUMB_FILEPATH + v.THUMB_FILENAME;

                  ht += "   <div class='menuBox' id='recom_div_"+ menuKey +"'>";
                  ht += "      <ul class='menuWrap'>";
                  ht += "         <li class='menuImg'>";
				  ht += "			 <img src='"+ g2_bbq_img_url +""+ v.THUMB_FILEPATH +""+ v.THUMB_FILENAME +"' onclick=\"location.href='/menu/menuView.asp?midx="+ v.menu_idx +"'\" alt=''>";
                  ht += "            <h4>"+ v.menu_name +"</h4>";
                  ht += "            <ul>";
                  ht += "               <li style='text-align:center;'><span>"+ v.menu_price_format +"</span>원</li>";
				  ht += "				<label class='ui-checkbox'>"
				  ht += "					<input type='checkbox' id='chkbox_"+ menuKey +"' onclick=\"javascript: goAddCart_Recom('"+ menuKey +"', '"+ menuItem +"'); \">"
				//   ht += "					<input type='checkbox' onclick=\"javascript: AddSubCart('"+ menuKey +"', '"+ menuItem +"'); \">"
				  ht += "					<span style='margin-left:30px; margin-top:5px;'></span>"
				  ht += "				</label>"

                  ht += "            </ul>";
				  ht += "         </li>";
                  
                  ht += "      </ul>";


                  ht += "   </div>";
               });

                  ht += "</div>";

               $('#recom_div').html(ht);
            }
         }
      });
   }
}

function AddSubCart(menuKey, menuItem)
{
    var chk = document.getElementById("chkbox_"+menuKey).checked;

    if (chk == false){
        removeSubCartMenu(menuKey);
		for (let i = 0; i < subCartList.length; i++) {
			if (subCartList[i].key === menuKey) {
				subCartList.splice(i,1);
				i--;
			}
		}
		// console.log(subCartList);
    }else{
		var item = menuItem.split("$$");
		var menuName = item[4];

		var ht = "";
		if (menuKey.length > 0) {

			ht += "<div class='detail_cart_content' id='detail_cart_inner_"+ menuKey +"'>"
			ht += "	<div class='dMenuText'>"
			ht += "		<span>"+ menuName +"</span>"
			ht += "	</div>"
			ht += "	<div class='form-pm'>"
			ht += "		<span>"
			ht += "			<button class='minus' onclick='control_submenu_qty(\""+ menuKey +"\", -1)' type='button'>-</button>"
			ht += "			<input id='new_qty_"+ menuKey +"' type='text' value='1' readonly />"
			ht += "			<button class='plus' onclick='control_submenu_qty(\""+ menuKey +"\", 1)' type='button'>+</button>"
			ht += "		</span>"
			ht += "	</div>"
			ht += "	<div class='menuDel' onclick=removeSubCartMenu('"+ menuKey +"')></div>"
			ht += "</div>"
			
			$('#detail_cart_inhtml').append(ht);

			subCartList.push({key:menuKey, value:menuItem});
			for (let i = 0; i < subCartList.length; i++) {
				var item = subCartList[i];
				subCartDict[item.key] = item
			}
			// console.log(subCartList.length);
			// console.log(subCartList);

			var fd = document.getElementById("detail_cart").style.display;
			if (fd == "block"){
				return false;
			}else{
				document.getElementById("footer_more").click();
			}
		}
	}
	

}

//----------------------------------------------------------------------
//  장바구니 사이드변경 추가
//----------------------------------------------------------------------
var sideChangeView = "";
var sideChangeItem = null;

function openSideChange(key) {
    $(".cart-fix").fadeIn(500);
    $(".menu-cart").fadeIn(500);
    $("html").addClass("fix");

    setSideChange(key);

    sideChangeView = key;
    sideChangeItem = getCartMenu(key);
}

function closeSideChange() {
    if(sideChangeView != "" && sideChangeItem != null) {
        saveCartMenu(sideChangeView, JSON.stringify(sideChangeItem));

        sideChangeView = "";
        sideChangeItem = null;
    }

    $(".cart-fix").fadeOut(500);
    $(".menu-cart").fadeOut(500);
    $("html").removeClass("fix");
}

function sideChangeApply() {
    sideChangeView = "";
    sideChangeItem = null;

    closeSideChange();

    getView();
}

function setSideChange(key) {
    if(supportStorage()) {
        if(key == ta_id) return;

        var item = getCartMenu(key);
		if (item.pin != '')
			item.price = 0;

        var sc_item_amt = 0;
        var sc_side_amt = 0;

        $(".payment > .addmenu").html("");

        sc_item_amt = Number(item.price) * Number(item.qty);

        var ht = "";

        ht += "<dl class=\"chicken\">\n";
        ht += "\t<dt>"+item.nm+"</dt>\n";
        ht += "\t<dd>\n";
		if (item.pin != ''){
			ht += "\t\t<font color='red'>[모바일 상품권]</font>\n";
		}else{

			ht += "\t\t<span class=\"form-pm\">\n";
			ht += "\t\t\t<button type=\"button\" class=\"minus\" onClick=\"javascript:changeMenuQty('"+key+"',-1);\">-</button>\n";
			ht += "\t\t\t<input type=\"text\" value=\""+item.qty+"\" onkeyup=\"onlyNum(this);\" onChange=\"javascript:changeTxtMenuQty('"+key+"',this.value);\" maxlength=\"4\">\n";
			ht += "\t\t\t<button type=\"button\" class=\"plus\" onClick=\"javascript:changeMenuQty('"+key+"',1);\">+</button>\n";
			ht += "\t\t</span>\n";
		}
        ht += "\t\t<div class=\"mon\">"+addCommas(Number(item.price)*Number(item.qty))+"원</div>\n";
        ht += "\t</dd>\n";
        ht += "<dl>\n";

        if(item.hasOwnProperty("side")) {
            for(var skey in item.side) {
 
                $("#"+skey+" :checkbox").prop("checked", true);
               var side = item.side[skey];

                sc_side_amt += Number(side.price) * Number(side.qty);

                ht += "<dl>\n";
                ht += "\t<dt>"+side.nm+"</dt>\n";
                ht += "\t<dd>\n";
                ht += "\t\t<span class=\"form-pm\">\n";
                ht += "\t\t\t<button type=\"button\" class=\"minus\" onClick=\"javascript:changeSideQty('"+key+"','"+skey+"',-1);\">-</button>\n";
                ht += "\t\t\t<input type=\"text\" value=\""+side.qty+"\" onkeyup=\"onlyNum(this);\" onChange=\"javascript:changeTxtSideQty('"+key+"','"+skey+"',this.value);\" maxlength=\"4\">\n";
                ht += "\t\t\t<button type=\"button\" class=\"plus\" onClick=\"javascript:changeSideQty('"+key+"','"+skey+"',1);\">+</button>\n";
                ht += "\t\t</span>\n";
                ht += "\t\t<div class=\"mon\">"+addCommas(Number(side.price)*Number(side.qty))+"원<button type=\"button\" class=\"delete\" onclick=\"removeCartSideNew('"+key+"','"+skey+"');\">삭제버튼</button></div>\n";
                ht += "\t</dd>\n";
                ht += "<dl>\n";
            }
        }

        $(".payment > .addmenu").html(ht);

        $("#sc_item_amount").text(numberWithCommas(sc_item_amt)+"원");
        $("#sc_side_amount").text(numberWithCommas(sc_side_amt)+"원");
        $("#sc_pay_amount").text(numberWithCommas(sc_item_amt+sc_side_amt)+"원");
    }
}


var ta_id = "tempAddress";

function setTempAddress() {
    var tAddr = getTempAddress();

    if(tAddr != null) {
    $(".section_shipList #tAddr").remove();

        var ht = "";


        ht += '<div class="box">';
        ht += '	<div class="name"></div>';
        ht += '	<ul class="info">';
        ht += '		<li>'+tAddr.zip_code+'</li>';
        ht += '		<li>'+tAddr.address_main+' '+tAddr.address_detail+'</li>';
        ht += '	</ul>';
        ht += '	<ul class="btn-wrap">';
        ht += '		<li><button type="button" onclick="addr_img_control(0)" class="btn_middle btn-redLine btn-redChk">선택</button></li>';
        ht += '	</ul>';
        ht += '</div>';


//        ht += "<div class=\"box\" id=\"tAddr\">\n";
////        ht += "\t<div class-\"name\">\n";
////        ht += "\t\t"+tAddr.addr_name+"\n";
////        ht += "\t</div>\n";
//        ht += "\t<ul class=\"info\">\n";
////        ht += "\t\t<li>"+tAddr.mobile+"</li>\n";
//        ht += "\t\t<li><input type='radio' name='adress' value='0' onclick='selectShipAddress_new(0)'></li>\n";
//        ht += "\t\t<li>("+tAddr.zip_code+") "+tAddr.address_main+" "+tAddr.address_detail+"</li>\n";
//        ht += "\t\t<li></li>\n";
//        ht += "\t</ul>\n";
////        ht += "\t<ul class=\"btn-wrap\">\n";
////        ht += "\t\t<li>\n";
////        ht += "\t\t\t<button type=\"button\" class=\"btn btn-md btn-redLine w-100p btn-redChk\" onclick=\"javascript:selectShipAddress_new(0);\">선택</button>\n";
////        ht += "\t\t</li>\n";
////        ht += "\t</ul>\n";
//        ht += "</div>\n";

        $(".section_shipList").append(ht);

		if (typeof(temp_cnt) != "undefined" && temp_cnt != "" && temp_cnt != null) {
		} else {
			temp_cnt = 1;
		}
    }
}

function drawShipAddress_new(data, page_type) {
	if (typeof(data) != "undefined" && data != "" && data != null) {
	} else {
		alert("주소가 잘못 되었습니다");
		return;
	}

    if(data.addr_idx == "") data.addr_idx = 0;

	// 60바이트 체크
	if (chkWord_new_val(data.address_detail, 60, "Y") == false) {
		return;
	}

	if (page_type == "TOP") {
		var_addr_idx = data.addr_idx;
		var_addr_data = JSON.stringify(data);
	} else {
		$("#addr_idx").val(data.addr_idx);
	//    $("#ship_address").text(data.address_main+" "+data.address_detail);
		$("#addr_data").val(JSON.stringify(data));
	}

	sessionStorage.setItem("ss_order_type", "D");
	sessionStorage.setItem("ss_addr_idx", data.addr_idx);
	sessionStorage.setItem("ss_addr_data", JSON.stringify(data));
	sessionStorage.setItem("ss_spent_time", "");

//	alert(sessionStorage.getItem("addr_data"))

	checkDeliveryShop_new(data, page_type);

    // lpClose(".lp_orderShipping");
}

function drawShipAddress(data) {
    if(data.addr_idx == "") data.addr_idx = 0;

    $("#addr_idx").val(data.addr_idx);
//    $("#ship_address").text(data.address_main+" "+data.address_detail);
    $("#addr_data").val(JSON.stringify(data));

    checkDeliveryShop(data);

    // lpClose(".lp_orderShipping");
}

function setDeliveryShopInfo(data) {
    $("#branch_data").val(JSON.stringify(data));
    $("#branch_id").val(data.branch_id);
    $("#branch_name").text(data.branch_name);
    $("#branch_tel").text("("+data.branch_tel+")");

    $("#order_type").val("D");
    setOrderTypeTitle();
    lpClose(".lp_orderShipping");
}


	function reOrder(order_idx, order_type)
	{
		// 배달, 포장인지
		$('#order_type').val(order_type);
		br_id = document.getElementById("ol_branch_id_"+ order_idx).value;

		if (order_type == "P") {
			$('#spent_time').val("30");
			sessionStorage.setItem("ss_spent_time", "30");

			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_getStoreOnline.asp",
				data: {"branch_id": br_id},
				dataType: "json",
				success: function(res) {
					if(res.result == "0000") {
						$.ajax({
							method: "post",
							url: "/api/ajax/ajax_getStoreInfo.asp",
							data: {"BRANCH_ID":br_id},
							dataType: "json",
							success: function(data) {
								if(data.result == "9999") {
									showAlertMsg({msg:data.message});
								}else{
									if (data.BREAK_TIME != "0") {
										showAlertMsg({msg:"해당 매장이 주문이 밀려 주문이 어렵습니다. 잠시 후 다시 주문하여 주시기 바랍니다."});
									} else {
										//도서산간지역 2020-08-26
										getDeliveryShopInfo_hill(br_id);

										change_store_cart(br_id);

										var br_data = JSON.stringify(data);
										var branch_data = JSON.parse(br_data);

										sessionStorage.setItem("ss_branch_id", br_id);
										sessionStorage.setItem("ss_branch_data", br_data);

										sessionStorage.setItem("ss_order_type", "P");
										sessionStorage.setItem("ss_addr_idx", "");
										sessionStorage.setItem("ss_addr_data", "");

										result_order(order_idx);
									}
								}
							},
							error: function(xhr) {
								showAlertMsg({msg:"시스템 에러가 발생했습니다."});
							}
						});

					} else {
						showAlertMsg({msg:res.message});
					}
				},
				error: function(xhr) {
					showAlertMsg({msg:"포장 매장을 다시 선택해주세요."});
				}
			});
		} else {
			addr_idx_str = document.getElementById("ol_addr_idx_"+ order_idx).value;

			if (addr_idx_str > 0) {
			} else {
				alert("저장된 주소가 아닙니다");
				return;
			}

			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_getStoreOnline.asp",
				data: {"branch_id": br_id},
				dataType: "json",
				success: function(res) {
					if(res.result == "0000") {

						$.ajax({
							method: "post",
							url: "/api/ajax/ajax_getStoreInfo.asp",
							data: {"BRANCH_ID":br_id},
							dataType: "json",
							success: function(data) {
								if(data.result == "9999") {
									showAlertMsg({msg:data.message});
								}else{
									if (data.BREAK_TIME != "0") {
										showAlertMsg({msg:"해당 매장이 주문이 밀려 주문이 어렵습니다. 잠시 후 다시 주문하여 주시기 바랍니다."});
									} else {
										//도서산간지역 2020-08-26
										getDeliveryShopInfo_hill(br_id);

										change_store_cart(br_id);

										var br_data = JSON.stringify(data);
										var branch_data = JSON.parse(br_data);

										sessionStorage.setItem("ss_branch_id", br_id);
										sessionStorage.setItem("ss_branch_data", br_data);

										var frm = document.form_addr;

										setAddress(addr_idx_str);

										var addrdata = dataToJson($("#form_addr"));

										saveTempAddress(addrdata);

										selectShipAddress_new(addr_idx_str);

										result_order(order_idx);
									}
								}
							},
							error: function(xhr) {
								showAlertMsg({msg:"시스템 에러가 발생했습니다."});
							}
						});

					} else {
						showAlertMsg({msg:res.message});
					}
				},
				error: function(xhr) {
					showAlertMsg({msg:"포장 매장을 다시 선택해주세요."});
				}
			});
		}
	}

	function result_order(order_idx)
	{
		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getOrderDetailList.asp",
			data: {"order_idx": order_idx},
			dataType: "json",
			success: function(ordList) {
				console.log(ordList)
				if(ordList.result == "0001") {
					showAlertMsg({msg:ordList.message});
				}else{

					if($(ordList).length > 0) {

						$.each(ordList, function(k, v) {

							menuKey = "M_"+ v.menu_idx +"_"+ v.menu_option_idx
							menuItem = "M$$"+ v.menu_idx +"$$"+ v.menu_option_idx +"$$"+ v.menu_price +"$$"+ v.menu_name +"$$"+ SERVER_IMGPATH_str + v.thumb_file_path + v.thumb_file_name + "$$$$" + v.kind_sel

							removeCartMenu(menuKey);
							removeCartSideAll(menuKey);

							addCartMenu(menuItem);
							changeTxtMenuQty(menuKey, v.menu_qty);

							if($(v.side).length > 0) 
							{
								side_list = $(v.side);
								for (i=0; i<side_list.length; i++)
								{
									sideitem = "S$$"+ side_list[i].menu_idx +"$$"+ side_list[i].menu_option_idx +"$$"+ side_list[i].menu_price +"$$"+ side_list[i].menu_name +"$$";
									skey = sideitem[0]+"_"+sideitem[1]+"_"+sideitem[2];

									addCartSide(menuKey, sideitem);
									changeTxtSideQty(menuKey, skey, side_list[i].menu_qty);
								}
							}
							
						});

						location.href="/order/cart.asp"
					}
				}
			}
		});
	}

	var NonMem = "";
	var NonMem_cmobile = "";

	function getOrderList() {
		if (NonMem == "Y") {
			ajax_url = "/api/ajax/ajax_getOrderListNonMem.asp";
		} else { 
			ajax_url = "/api/ajax/ajax_getOrderList_new.asp";
		}

		$.ajax({
			method: "post",
			url: ajax_url,
			data: {pageSize: order_pageSize, curPage: page, cmobile: NonMem_cmobile},
			dataType: "json",
			success: function(ordList) {
				var ht = "";

				if($(ordList).length > 0) {
					page++;

					$.each(ordList, function(k, v) {

//						console.log(k);
//						console.log(v);
//						console.log('---');

						ht += "<div class='reorder_wrap_list'>";
						ht += "	<input type='hidden' id='ol_order_idx_"+ v.order_idx +"' name='ol_order_idx_"+ v.order_idx +"' value='"+ v.order_idx +"'>";
						ht += "	<input type='hidden' id='ol_addr_idx_"+ v.order_idx +"' name='ol_addr_idx_"+ v.order_idx +"' value='"+ v.addr_idx +"'>";
						ht += "	<input type='hidden' id='ol_branch_id_"+ v.order_idx +"' name='ol_branch_id_"+ v.order_idx +"' value='"+ v.branch_id +"'>";


						if (NonMem == "Y") {
							ht += "	<ul onclick='location.href=\"./orderViewNonMem.asp?oidx="+v.order_idx+"\";' style='cursor:pointer'>";
						} else { 
							ht += "	<ul onclick='location.href=\"./orderView.asp?oidx="+v.order_idx+"\";' style='cursor:pointer'>";
						}

						ht += "		<li class='reorder_time'>"+ v.order_date_time +"</li>";

						if (v.order_type == "D") {
							ht += "		<li class='reorder_type'><img src='/images/main/icon_m_order.png'> "+ v.order_type_name +"</li>";
						} else if (v.order_type == "P") {
							ht += "		<li class='reorder_type'><img src='/images/main/icon_m_out.png'> "+ v.order_type_name +"</li>";
						} else if (v.order_type == "R") {
							ht += "		<li class='reorder_type'><img src='/images/main/icon_m_order.png'> "+ v.delivery_time +"</li>";
						} else {
							ht += "		<li class='reorder_type'><img src='/images/main/icon_m_order.png'> "+ v.order_type_name +"</li>";
						}

						ht += "		<li class='reorder_shop'>"+ v.branch_name +"</li>";
						ht += "		<li class='reorder_title'>"+ v.menu_name + (v.menu_count > 1? " <span>외 "+(v.menu_count-1)+"개</span>":"") +"</li>";
						ht += "		<li class='reorder_pay'><span>"+ numberWithCommas(v.order_amt) +"</span>원</li>";
						ht += "		<div class='reorder_view_state_wrap'>";
						ht += "			<p class='"+ v.order_status_class +"'><span>"+ v.order_status_name +"</span></p>";

						if (v.delivery_time) {
							if (v.order_status == "P" || v.order_status == "N" || v.order_status == "M") {
								ht += "			<p class='reorder_view_time'>"+ v.delivery_time +"분 뒤 도착예정</p>";
							}
						} else if (v.DELIVERYTIME) {
							if (v.order_type == "R") {
								ht += "			<p class='reorder_view_time'>"+ v.DELIVERYTIME +" 예약</p>";
							}
						}
						
						ht += "		</div>";
						ht += "	</ul>";
						ht += "	<div class='btn-wrap two-up'>";
						ht += "		<a href='javascript: void(0)' onclick=\"result_order('"+ v.order_idx +"')\" class='btn btn-redLine btn_middle'><img src='/images/common/btn_header_cart.png'> 담기</a> ";
						ht += "		<a href='javascript: void(0)' onclick=\"reOrder('"+ v.order_idx +"', '"+ v.order_type +"')\" class='btn btn-red btn_middle'>재주문</a>";
						ht += "	</div>";
						ht += "</div>";


//						ht += "	<ul>";
//						ht += "		<li>";
//						ht += "			<span class='reorder_option'>비비큐치킨</span>";
//						ht += "			<span class='reorder_shop'>"+v.branch_name+"<span> </span>"+v.order_date.substr(0,10)+"</span>";
//						ht += "		</li>";
//						ht += "		<li class='reorder_title'>"+v.menu_name+(v.menu_count > 1? " <span>외 "+(v.menu_count-1)+"개</span>":"")+"</li>";
//						ht += "		<li class='reorder_pay'><span>"+numberWithCommas(v.order_amt)+"</span>원</li>";
//						ht += "		<li class='reorder_con'>";
//
//						switch(v.order_status){
//						// 	// case ""
//						// 	// 	ht += "\t\t\t<li class=\"btn_2\"><a href=\"javascript:;\"><img src=\"/images/mypage/ico_order_ok.png\" alt=\"\"> <span>배송완료</span></a></li>\n";
//						// 	// 	break;
//						 	default:
//								ht += "			<span class='"+ v.order_status_class +"'> "+v.order_status_name+"</span>";
//						 		break;
//						 }
//						ht += "		</li>";
//						ht += "	</ul>";
//						ht += "	<div class='btn-wrap two-up'><a href=\"./orderView.asp?oidx="+v.order_idx+"\" class='btn btn_middle btn-red'>보기</a> <a href='javascript: void(0)' onclick=\"reOrder('"+ v.order_idx +"', '"+ v.order_type +"')\" class='btn btn_middle btn-redLine'><img src='/images/common/btn_header_cart.png'> 다시담기</a></div>";
//						ht += "</div>";

					});

					$("#order_list").append(ht);
				} else {
					if(page == 1) {
						ht += "<li class='orderX ta-c'>주문내역이 없습니다.</li>";
						ht += "<div class='ta-c'><img src='/images/order/character-img.png' width='50%' height='50%'><div>";

						$("#order_list").html(ht);
					}
					$("#btn_more").hide();
				}
			}
		});
	}


	function getOrderOldBranchList() { //배달 일 때
		ajax_url = "/api/ajax/ajax_getOrderOldList_new.asp";

		// 페이징.
		$.ajax({
			method: "post",
			url: ajax_url,
			data: {pageSize: order_pageSize, curPage: page, cmobile: NonMem_cmobile},
			dataType: "json",
			success: function(ordList) {
				var ht = "";

				if($(ordList).length > 0) {
					page++;

					$.each(ordList, function(k, v) {

//						console.log(k);
//						console.log(v);
//						console.log('---');

						ht += "<ul class='find_shop' id='delivery_addr_"+ v.addr_idx +"'>";
						ht += "	<li class='find_shop_delivery_1'>";

						if (v.is_main == "Y") {
							ht += "	<span class=\"red\">[기본배달지]</span><br> ";
						}

						ht += "		<span>"+ v.address_main +' '+ v.address_detail +"</span> ";
						ht += "	</li>";
						ht += "	<li>";
						ht += " 	<span class='add_del_span' id='add_del_"+ v.addr_idx +"' style='text-decoration:underline; font-size:13px; "
						if (v.is_main == "Y") {
							ht += "display:none;";
						}
						ht += " 	'<button type='button' onClick='javascript:delAddress("+ v.addr_idx +");' class='btn_small2 btn-grayLine btn_lp_open'>삭제</button></span>"
						ht += "	</li>";

						// 행정동코드 없을 때 행정동 코드 가져오는 함수 호출 
						if(v.h_code == ""){
							ht += "	<li><a href=\"javascript: selectCoordHCode('S','"+ v.addr_idx +"','"+ v.address_main +"', '"+ v.branch_id +"'); \" class='btn btn_middle btn-lightGray' style='border-radius: 50px;'>선택</a></li>";
						}else{
							ht += "	<li><a href=\"javascript: addr_img_control('"+ v.addr_idx +"', '"+ v.branch_id +"'); \" class='btn btn_middle btn-lightGray' style='border-radius: 50px;'>선택</a></li>";
						}
                        ht += "</ul>";
					});

					$("#order_branch_list").append(ht);
				} else {
					if(page == 1) {				
						ht += "<li class='orderX ta-c'>주문매장이 없습니다.</li>";
						ht += "<div class='ta-c'><img src='/images/order/character-img.png' width='50%' height='50%'><div>";

						$("#order_branch_list").html(ht);
					}
					$("#btn_more").hide();
				}
			}
		});
	}

	function getOrderBranchList() { //포장일 때 
		ajax_url = "/api/ajax/ajax_getOrderList_new_groupby.asp";

		$.ajax({
			method: "post",
			url: ajax_url,
			data: {pageSize: order_pageSize, curPage: page, cmobile: NonMem_cmobile},
			dataType: "json",
			success: function(ordList) {
				var ht = "";

				if($(ordList).length > 0) {
					z = order_pageSize*page;

					page++;

					$.each(ordList, function(k, v) {

//						console.log(k);
//						console.log(v);
//						console.log('---');

						ht += "<ul class='find_shop'>";
						ht += "	<li></li>";
						ht += "	<li class='find_shop_1'>";
						ht += "		<a href='/shop/shopView.asp?branch_id="+ v.branch_id +"' class='find_shop_name'>"+ v.branch_name +"</a> ";

						if (v.branch_type == "올리브카페")
							ht += "		<a href='javascript: void(0)' class='btn btn-red btn_small4'>올리브카페</a>";

						//포장할인 추가(2022. 6. 7)
						if (v.pickup_discount != ""){
							ht += "		<a href='javascript: viewPickupDiscount("+ v.branch_id +")' class='btn btn-yellow btn_small5'><span id='pd_txt_"+ v.branch_id +"' style='min-width:60px;'>포장할인</span><span id='pd_amt_"+ v.branch_id +"' style='min-width: 60px;display:none'>"+ addCommas(v.pickup_discount) +"</span></a>";
						}

						ht += "	</li>";

						ht += "	<li class='find_shop_2'>";
						ht += "		"+ v.delivery_address +" ";

						if (v.membership_yn_code == "50")
							ht += "		<a href='javascript: void(0)' class='btn btn-red btn_small4'>멤버십</a>";

						ht += "	</li>";
						ht += "	<li class='find_shop_3'>";
						ht += "		"+ v.branch_tel +" ";
						ht += "		<button type='button' id='btn_map' class='' onclick='show_map(\""+ z +"\", \""+ v.wgs84_y +"\", \""+ v.wgs84_x +"\")'><img src='/images/order/icon_map.png' alt='지도보기'></button>";
						ht += "		<div id='mapWrap_"+ z +"' style='display: none;'>";
						ht += "			<div id='map_"+ z +"' style='width:100%;height:350px;'></div>";
						ht += "		</div>";
						ht += "	</li>";
                        ht += "	<li><a href=\"javascript: addr_img_control('"+ v.addr_idx +"', '"+ v.branch_id +"')\" class='btn btn_middle btn-lightGray' style='border-radius: 50px; margin-bottom:10px;'>선택</a></li>";
                        ht += "</ul>";

						z++;
					});

					$("#order_branch_list").append(ht);
				} else {
					if(page == 1) {
						ht += "<li class='orderX ta-c'>주문매장이 없습니다.</li>";
						ht += "<div class='ta-c'><img src='/images/order/character-img.png' width='50%' height='50%'><div>";

						$("#order_branch_list").html(ht);
					}
					$("#btn_more").hide();
				}
			}
		});
	}


function chkWord(obj, maxByte) {
    var strValue = obj.value;
    var strLen = strValue.length;
    var totalByte = 0;
    var len = 0;
    var oneChar = "";
    var str2 = "";

    for(var i=0; i < strLen; i++) {
        oneChar = strValue.charAt(i);
        if (escape(oneChar).length > 4) {
            totalByte += 2;
        } else {
            totalByte++;
        }

        // 잘라내기 위해 저장
        if (totalByte <= maxByte) {
            len = i + 1;
        }
    }

    if (totalByte > maxByte) {
        alert("글자수 " + maxByte + "를 초과 할 수 없습니다.");
        str2 = strValue.substr(0, len);
        obj.value = str2;
        chkWord(obj, maxByte)
    }
}


function chkWord_new(obj, maxByte, returnyn) {
	var memo_pattern = /[^(ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9|a-z|A-Z|\s+|\-|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)|\_|\+|\||\~|\.|\,|\?|\/|\<|\>|\|\u318D\u119E\u11A2\u2022\u2025a\u00B7\uFE55)]/gi
	obj.value = obj.value.replace(memo_pattern,"");

    var strValue = obj.value;
    var strLen = strValue.length;
    var totalByte = 0;
    var len = 0;
    var oneChar = "";
    var str2 = "";

    for(var i=0; i < strLen; i++) {
        oneChar = strValue.charAt(i);
        if (escape(oneChar).length > 4) {
            totalByte += 2;
        } else {
            totalByte++;
        }

        // 잘라내기 위해 저장
        if (totalByte <= maxByte) {
            len = i + 1;
        }
    }

    if (totalByte > maxByte) {
        alert("글자수 " + maxByte + "를 초과 할 수 없습니다.");
        str2 = strValue.substr(0, len);
        obj.value = str2;

		if (returnyn == "Y") {
			return false;
		} else {
			chkWord_new(obj, maxByte, returnyn)
		}
    } else {
		if (returnyn == "Y") {
			return true;
		}
	}
}


function chkWord_new_val(val, maxByte, returnyn) {
	var memo_pattern = /[^(ㄱ-ㅎ|ㅏ-ㅣ|가-힣|0-9|a-z|A-Z|\s+|\-|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)|\_|\+|\||\~|\.|\,|\?|\/|\<|\>|\|\u318D\u119E\u11A2\u2022\u2025a\u00B7\uFE55)]/gi

    var strValue = val.replace(memo_pattern,"");
    var strLen = strValue.length;
    var totalByte = 0;
    var len = 0;
    var oneChar = "";
    var str2 = "";

    for(var i=0; i < strLen; i++) {
        oneChar = strValue.charAt(i);
        if (escape(oneChar).length > 4) {
            totalByte += 2;
        } else {
            totalByte++;
        }

        // 잘라내기 위해 저장
        if (totalByte <= maxByte) {
            len = i + 1;
        }
    }

    if (totalByte > maxByte) {
        alert("상세주소 글자수 " + maxByte + "를 초과 할 수 없습니다.");
        str2 = strValue.substr(0, len);

		if (returnyn == "Y") {
			return false;
		} else {
			chkWord_new(obj, maxByte, returnyn)
		}
    } else {
		if (returnyn == "Y") {
			return true;
		}
	}
}

function eCoupon_Check(saveYN) {
	targetUrl = "/api/ajax/ajax_getEcoupon.asp";
	couponCode = $("#txtPIN_save").val()

	if (couponCode == "") {
		alert('모바일 상품권 번호를 입력해주세요.');
		return;
	}

	if (couponCode.charAt(0) == "6" || couponCode.charAt(0) == "8"){
		targetUrl = "/api/ajax/ajax_getEcouponCoop.asp";
	}

	$.ajax({
		method: "post",
		url: targetUrl,
		data: {
			"txtPIN": couponCode,
			"PIN_save": saveYN
		},
		dataType: "json",
		success: function(res) {
			if (res.result == 0) {
				showConfirmMsg({
					msg:"정상 등록되었습니다.", 
					ok: function(){
					 lpClose('.lp_RegiCoupon');
					 
					},
					cancel:function() {
					 lpClose('.lp_RegiCoupon');
					}
				});
			} else {
				showAlertMsg({
					msg: res.message
				});
			}
		},
		error: function(data, status, err) {
//							msg: data + ' ' + status + ' ' + err
			showAlertMsg({
				msg: "에러가 발생하였습니다",
				ok: function() {
					location.href = "/";
				}
			});
		}

	});
}

function eCoupon_Check_GoCart_NoPinCode(saveYN, url) {		
	var couponCode = $("#txtPIN").val();
	var targetUrl = "/api/ajax/ajax_getEcoupon.asp";
	var jsonData = {
		"txtPIN": couponCode,
		"PIN_save": saveYN
	};

	if (couponCode == "") {
		alert('E-쿠폰 번호를 입력해주세요.');
		return;
	}

	if (couponCode.charAt(0) == "6" || couponCode.charAt(0) == "8"){
		targetUrl = "/api/ajax/ajax_getEcouponCoop.asp";
	}

	eCoupon_Check_Json_url(targetUrl, jsonData, url);
}

function eCoupon_Register_GoCart(saveYN) {		
	var couponCode = $("#txtPIN").val();
	var targetUrl = "/api/ajax/ajax_getEcoupon.asp";
	var jsonData = {
		"txtPIN": couponCode,
		"PIN_save": saveYN
	};

	if (couponCode == "") {
		alert('E-쿠폰 번호를 입력해주세요.');
		return;
	}

	if (couponCode.charAt(0) == "6" || couponCode.charAt(0) == "8"){
		targetUrl = "/api/ajax/ajax_getEcouponCoop.asp";
	}

	eCoupon_Check_Json(targetUrl, jsonData);
}

function eCoupon_Check_GoCart(saveYN, pinCode) {		
	var couponCode = pinCode;
	var targetUrl = "/api/ajax/ajax_getEcoupon.asp";
	var jsonData = {
		"txtPIN": couponCode,
		"PIN_save": saveYN
	};

	if (couponCode == "") {
		alert('E-쿠폰 번호를 입력해주세요.');
		return;
	}

	if (couponCode.charAt(0) == "6" || couponCode.charAt(0) == "8"){
		targetUrl = "/api/ajax/ajax_getEcouponCoop.asp";
	}

	eCoupon_Check_Json(targetUrl, jsonData);
}

function eCoupon_Check_Json(targetUrl, jsonData) {
	$.ajax({
		method: "post",
		url: targetUrl,
		data: jsonData,
		dataType: "json",
		success: function(res) {
			showAlertMsg({
				msg: res.message,
				ok: function() {
					if (res.result == 0) {
						var menuItem = res.menuItem;
						addCartMenu(menuItem);
						location.href = "/order/cart.asp";
					}
				}
			});
		},
		error: function(data, status, err) {
			showAlertMsg({
				msg: data + ' ' + status + ' ' + err
			});
		}

	});						
}

function eCoupon_Check_Json_url(targetUrl, jsonData, url) {
	$.ajax({
		method: "post",
		url: targetUrl,
		data: jsonData,
		dataType: "json",
		success: function(res) {
			showAlertMsg({
				msg: res.message,
				ok: function() {
					if (res.result == 0) {
						var menuItem = res.menuItem;
						//addCartMenu(menuItem);
					}
				}
			});
		},
		error: function(data, status, err) {
			showAlertMsg({
				msg: data + ' ' + status + ' ' + err
			});
		}
	});

	if (url != ""){
		setTimeout(function(){
			location.href = url;
		}, 2000); 	
	}
					
}

function eCoupon_del_plus(txtPIN_str) {
	showConfirmMsg({msg:"쿠폰을 삭제하시겠습니까?", ok: function(){
		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_delEcoupon.asp",
			data: {txtPIN: txtPIN_str},
			dataType: "json",
			success: function(res) {
				if(res.result == 0) {
					showAlertMsg({msg:res.message, ok: function(){
						$('#coupon_list_'+ txtPIN_str).remove();
					}})
				} else {
					showAlertMsg({msg:res.message});
				}
			}
		});
	}});
}

function paycoCoupon_Check_Json_url() {
	var paycoPIN = $("#paycoPIN").val();

	$.ajax({
		method: "post",
		url: "/api/ajax/ajax_getPaycoCoupon.asp",
		data: {"paycoPIN": paycoPIN},
		dataType: "json",
		success: function(res) {
			showAlertMsg({
				msg: res.message,
				ok: function() {
					if (res.result == 0) {
						location.href = "/mypage/couponList.asp";;
					}
				}
			});
		},
		error: function(data, status, err) {
			showAlertMsg({
				msg: data + ' ' + status + ' ' + err
			});
		}
	});
}

function viewPickupDiscount(branch_id){
	if($('#pd_txt_'+branch_id) != undefined){
		if($('#pd_txt_'+branch_id).css("display") == "none"){
			$('#pd_txt_'+branch_id).css("display", "inline-block");
			$('#pd_amt_'+branch_id).css("display", "none");
		}else{
			//포장할인 금액 있으면 금액 노출
			if($('#pd_amt_'+branch_id).html() != ""){
				$('#pd_txt_'+branch_id).css("display", "none");
				$('#pd_amt_'+branch_id).css("display", "inline-block");
			}
		}
	}
}


//--------------------------------------------------------
// 이벤트 참여 회원
//--------------------------------------------------------

function offEventCheck(event_cd, cpnid, cpnno) {
    if(window.confirm("직원확인 처리를 하시겠습니까?\n직원 확인 후에는 쿠폰이 사용처리되어 더 이상 사용하실 수 없습니다.")) {
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_offEventCheck.asp",
            data: {event_cd: event_cd, cpnid: cpnid, cpnno: cpnno},
            dataType: "json",
            success: function(res) {
				showAlertMsg({msg:res.message});
            }
        });
    }
}
