var domain = "mobile";

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

                $("#form_addr [name=addr_name]").val(res[0].addr_name);
                if(res[0].mobile != "") {
                    $("#form_addr [name=mobile1]").val(res[0].mobile.split("-")[0]);
                    $("#form_addr [name=mobile2]").val(res[0].mobile.split("-")[1]);
                    $("#form_addr [name=mobile3]").val(res[0].mobile.split("-")[2]);
                }
                $("#form_addr [name=zip_code]").val(res[0].zip_code);
                $("#form_addr [name=address_main]").val(res[0].address_main);
                $("#form_addr [name=address_detail]").val(res[0].address_detail);
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
                    if(result.paddr_idx > 0) {
                        $("#addr_"+result.paddr_idx+" .name").html($("#addr_"+result.paddr_idx+" div.name").html().replace("<span class=\"red\">[기본배달지]</span> ",""));
                        $("#addr_"+result.paddr_idx+" .btn-wrap .btn-left").html("<button type=\"button\" class=\"btn btn-sm btn-brown\" onClick=\"javascript:setMainAddress('"+result.paddr_idx+"');\">기본배달지 설정<button>");
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

                if(data.success) {
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

        clearAddressForm();

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
    var menu_amt = 0;
    var side_amt = 0;

    if(page == "C") {
        $("#cart_list .order_menu").remove();
        $("#order_type_info").show();
    } else if(page == "P") {
        $("#payment_list .order_menu").remove();
    }

    if(len == 0) {
        var ht = "";

        ht += "<div class=\"cart_empty\"><p>장바구니에 담긴 상품이 없습니다.</p></div>\n";
        ht += "<div class=\"mar-t40\">\n";
        ht += "\t<button type=\"button\" onclick=\"location.href='/menu/menuList.asp';\"  class=\"btn btn-md btn-redLine w-100p\">+ 메뉴 보러가기</button>\n";
        ht += "</div>\n";

        $("#cart_list").html(ht);
        $("#order_type_info").hide();
    } else {
        for(var i = 0; i < len; i++) {
			var side_amt_new = 0;
            var key = sessionStorage.key(i);

            if(key == ta_id) continue;
//            if(key != ta_id) continue;
			if(key.substring(0, 3) == "ss_") continue;


            var it = JSON.parse(sessionStorage.getItem(key));
			if (it.pin != '')
				it.price = 0;

            var it_amt = (Number(it.price) * Number(it.qty)); 
            menu_amt += (Number(it.price) * Number(it.qty));

            var ht = "";
			var mkey = it.type +"_"+ it.idx +"_"+ it.opt

//			console.log(it);

            ht += "<div class=\"order_menu\">\n";
            ht += "<ul id='cart_list_"+ mkey +"' class='cart_list' >";
            ht += "	<li class='cart_img'><img src='"+it.img+"'></li>";
            ht += "	<li class='cart_info'>";
            ht += "		<dl>";
            ht += "			<dt>";
            ht += "			"+it.nm+"";
			if (it.pin != ''){
				ht += " <font color='red'>[E-쿠폰]</font>\n";
			}

            if(page == "C") {
                ht += "<button type=\"button\" class=\"btn-del\" onClick=\"removeCartMenu('"+key+"');\">삭제</button>\n";
            }
            ht += "			</dt>";
            ht += "			<dd class='cart_choice'>&nbsp;<span>기본 : <span>"+numberWithCommas(Number(it.price))+"</span>원</span></dd>";

            if(it.hasOwnProperty("side")) {
                for(var skey in it.side) {
					if(it.side.hasOwnProperty(skey)) {
						var side = it.side[skey];
						var skey = side.type +"_"+ side.idx +"_"+ side.opt

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
            ht += "				<span class='form-pm2'>";
            ht += "					<button class='minus' onclick=\"goCartTxt('"+ mkey +"', -1);\" type='button'>-</button>";
            ht += "					<input id='new_qty_"+ mkey +"' type='text' value='"+it.qty+"' readonly />";
            ht += "					<button class='plus' onclick=\"goCartTxt('"+ mkey +"', 1);\" type='button'>-</button>";
            ht += "				</span>";
            ht += "				<span>"+ numberWithCommas(Number(it_amt + side_amt_new)) +"</span>원";
            ht += "			</dd>";
            ht += "		</dl>";
            ht += "	</li>";
            ht += "</ul>";
            ht += "</div>";





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
        $("#total_amount").html(numberWithCommas(menu_amt+side_amt+delivery_amt)+"<span>원</span>");
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
			ht += "\t\t<font color='red'>[E-쿠폰]</font>\n";
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

function drawShipAddress_new(data) {
    if(data.addr_idx == "") data.addr_idx = 0;

    $("#addr_idx").val(data.addr_idx);
//    $("#ship_address").text(data.address_main+" "+data.address_detail);
    $("#addr_data").val(JSON.stringify(data));

	sessionStorage.setItem("ss_order_type", "D");
	sessionStorage.setItem("ss_addr_idx", data.addr_idx);
	sessionStorage.setItem("ss_addr_data", JSON.stringify(data));
	sessionStorage.setItem("ss_spent_time", "");

//	alert(sessionStorage.getItem("addr_data"))

	checkDeliveryShop_new(data);

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
							menuItem = "M$$"+ v.menu_idx +"$$"+ v.menu_option_idx +"$$"+ v.menu_price +"$$"+ v.menu_name +"$$"+ SERVER_IMGPATH_str + v.thumb_file_path + v.thumb_file_name

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

	function getOrderList() {
		$.ajax({
			method: "post",
			url: "/api/ajax/ajax_getOrderList.asp",
			data: {pageSize: order_pageSize, curPage: page},
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
						ht += "	<ul>";
						ht += "		<li>";
						ht += "			<span class='reorder_option'>비비큐치킨</span>";
						ht += "			<span class='reorder_shop'>"+v.branch_name+"<span></span>"+v.order_date.substr(0,10)+"</span>";
						ht += "		</li>";
						ht += "		<li class='reorder_title'>"+v.menu_name+(v.menu_count > 1? " <span>외 "+(v.menu_count-1)+"개</span>":"")+"</li>";
						ht += "		<li class='reorder_pay'><span>"+numberWithCommas(v.order_amt)+"</span>원</li>";
						ht += "		<li class='reorder_con'>";
						switch(v.order_type){
							// case ""
							// 	ht += "\t\t\t<li class=\"btn_1\"><a href=\"javascript:;\"><img src=\"/images/mypage/ico_order_basic.png\" alt=\"\"> <span class=\"red\">일반주문</span></a></li>\n";
							// 	break;
							default:
								ht += "			<span class='reorder_con_delivery'><img src='/images/order/icon_delivery.png'> "+v.order_type_name+"</span>";
								break;
						}
						switch(v.order_status){
						// 	// case ""
						// 	// 	ht += "\t\t\t<li class=\"btn_2\"><a href=\"javascript:;\"><img src=\"/images/mypage/ico_order_ok.png\" alt=\"\"> <span>배송완료</span></a></li>\n";
						// 	// 	break;
						 	default:
								ht += "			<span class='reorder_con_cancel'><img src='/images/order/icon_cancel.png'> "+v.order_status_name+"</span>";
						 		break;
						 }
						ht += "		</li>";
						ht += "	</ul>";
						ht += "	<div class='reorder_btn'><a href=\"./orderView.asp?oidx="+v.order_idx+"\" class='btn-sm btn-gray'>보기</a> <a href='javascript: void(0)' onclick=\"reOrder('"+ v.order_idx +"', '"+ v.order_type +"')\" class='btn-sm btn-red'>다시담기</a></div>";
						ht += "</div>";

					});

					$("#order_list").append(ht);
				} else {
					if(page == 1) {
						$("#order_list").html("<li class=\"orderX\">주문내역이 없습니다.</li>");
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