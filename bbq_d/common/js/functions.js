var domain = "pc";

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
    showConfirmMsg({msg:"주소지를 삭제하시겠습니까?", ok: function(){
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_delAddress.asp",
            data: {addr_idx: addr_idx},
            dataType: "json",
            success: function(res) {
                if(res.result == 0) {
                    showAlertMsg({msg:res.message, ok: function(){
                        $("#addr_"+addr_idx).remove();
                    }})
                } else {
                    showAlertMsg({msg:res.message});
                }
            }
        });
    }});
}

function setMainAddress(addr_idx) {
    showConfirmMsg({msg:"기본 배달지로 설정하시겠습니까?", ok: function(){
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
    }});
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
            success: function(res) {
                if(res.success) {
                    location.href = returnUrl;
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

        setTempAddress();

        lpClose(".lp_address");
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

    var len = getAllCartMenuCount();
    var menu_amt = 0;
    var side_amt = 0;

    $(".addmenu").html("");

    for(var i = 0; i < len; i++) {
        var key = sessionStorage.key(i);
        if(key == ta_id) continue;
        if(menu_key != "" && key != menu_key) continue;

        var it = JSON.parse(sessionStorage.getItem(key));
        menu_amt += (Number(it.price) * Number(it.qty));

        var ht = "";

        ht += "<dl>\n";
        ht += "\t<dt>"+it.nm+"</dt>\n";
        ht += "\t<dd>\n";
        ht += "\t\t<span class=\"form-pm\">\n";
        ht += "\t\t\t<button type=\"button\" class=\"minus\" onClick=\"javascript:changeMenuQty('"+key+"',-1);\">-</button>";
        ht += "\t\t\t<input type=\"text\" id=\"qty_"+key+"\" value=\""+it.qty+"\" onkeyup=\"onlyNum(this);\" onChange=\"javascript:changeTxtMenuQty('"+key+"',this.value);\" maxlength=\"4\">\n";
        ht += "\t\t\t<button type=\"button\" class=\"plus\" onClick=\"javascript:changeMenuQty('"+key+"', 1);\">+</button>";
        ht += "\t\t</span>";
        ht += "\t\t<div class=\"mon\">"+addCommas(Number(it.price) * Number(it.qty))+"원</div>\n";
        ht += "\t</dd>";
        ht += "</dl>";

        if(it.hasOwnProperty("side")) {
            for(var skey in it.side) {

                $("#"+skey+" :checkbox").prop("checked", true);

                var side = it.side[skey];

                side_amt += (Number(side.price) * Number(side.qty));

                ht += "<dl>\n";
                ht += "\t<dt>"+side.nm+"</dt>\n";
                ht += "\t<dd>\n";
                ht += "\t\t<span class=\"form-pm\">\n";
                ht += "\t\t\t<button type=\"button\" class=\"minus\" onClick=\"javascript:changeSideQty('"+key+"','"+skey+"',-1);\">-</button>";
                ht += "\t\t\t<input type=\"text\" id=\"qty_"+skey+"\" value=\""+side.qty+"\" onkeyup=\"onlyNum(this);\" onChange=\"javascript:changeTxtSideQty('"+key+"','"+skey+"',this.value);\" maxlength=\"4\">\n";
                ht += "\t\t\t<button type=\"button\" class=\"plus\" onClick=\"javascript:changeSideQty('"+key+"','"+skey+"',1);\">+</button>";
                ht += "\t\t</span>";
                ht += "\t\t<div class=\"mon\">"+addCommas(Number(side.price) * Number(side.qty))+"원<button type=\"button\" class=\"delete\" onclick=\"removeCartSideNew('"+key+"','"+skey+"');\">삭제버튼</div></div>\n";
                ht += "\t</dd>";
                ht += "</dl>";

                $("#"+skey+" :checkbox").prop("checked", true);
            }
        }

        $(".addmenu").append(ht);
    }

    $("#item_amount").text(addCommas(menu_amt)+"원");
    $("#side_amount").text(addCommas(side_amt)+"원");
    $("#pay_amount").text(addCommas(menu_amt+side_amt)+"원");
}

function openCart() {
    if($(".cart-fix").hasClass("on")) {
        closeCart();
        lpOpen("#lp_cart");
        // if(window.confirm("선택하신 메뉴를 장바구니에 담았습니다.\n장바구니로 이동하시겠습니까?")) {
        //     location.href = "/order/cart.asp";
        // }
    } else {
        $(".cart-fix").addClass("on");
        $(".menu-cart").fadeIn(500);
        $("html").addClass("fix");
        $(".btn_other_menu").hide();
    }
}

function closeCart() {
    $(".cart-fix").removeClass("on");
    $(".menu-cart").fadeOut(500);
    $("html").removeClass("fix");
    $(".btn_other_menu").show();
}

function drawCartPage(page){
    var len = sessionStorage.length;
    var menu_amt = 0;
    var side_amt = 0;

    $("#order_type_info").show();
    if(page == "C") {
        $("#cart_list").html("");
    } else if(page == "P") {
        $("#payment_list .order_menu").remove();
    }

    if(getAllCartMenuCount() == 0) {
        var ht = "";

        ht += "<tr>\n";
        ht += "\t<td colspan=\"5\" class=\"empty\">장바구니에 담긴 상품이 없습니다.</td>\n";
        ht += "</tr>\n";
                        
        $("#cart_list").html(ht);
        $("#order_type_info").hide();
    } else {
        for(var i = 0; i < len; i++) {
            var key = sessionStorage.key(i);

            if(key == ta_id) continue;

            var it = JSON.parse(sessionStorage.getItem(key));
			if (it.pin != '')
				it.price = 0;

            var it_amt = (Number(it.price) * Number(it.qty)); 
            menu_amt += (Number(it.price) * Number(it.qty));

            var ht = "";

            ht += "<tr>\n";
            ht += "\t<td class=\"chk\"><label class=\"ui-checkbox no-txt\"><input type=\"checkbox\" value=\""+key+"\"><span></span></label></td>\n";
            ht += "\t<td class=\"img\">\n";
            ht += "\t\t<a href=\"javascript:;\"><img src=\""+it.img+"\" width=\"120px\" height=\"120px\" onerror=\"this.src='http://placehold.it/120x120'\"/>\n";
            ht += "\t</td>\n";
            ht += "\t<td class=\"info ta-l\">\n";
            ht += "\t\t<div class=\"pdt-info div-table\">\n";
            ht += "\t\t\t<dl class=\"tr\">\n";
            ht += "\t\t\t\t<dt class=\"td\">"+it.nm+"</dt>\n";
            ht += "\t\t\t\t<dd class=\"td pm\">\n";
			if (it.pin != ''){
				ht += "\t\t\t\t\t\t<font color='red'>[E-쿠폰]</font>\n";
			}else{
	            ht += "\t\t\t\t\t<span class=\"form-pm\">\n";
				ht += "\t\t\t\t\t\t<button type=\"button\" class=\"minus\" onclick=\"javascript:changeMenuQty('"+key+"',-1);\">-</button>\n";
				ht += "\t\t\t\t\t\t<input type=\"text\" value=\""+it.qty+"\" onkeyup=\"onlyNum(this);\" onChange=\"javascript:changeTxtMenuQty('"+key+"',this.value);\" maxlength=\"4\">\n";
				ht += "\t\t\t\t\t\t<button type=\"button\" class=\"plus\" onclick=\"javascript:changeMenuQty('"+key+"',1);\">+</button>\n";
	            ht += "\t\t\t\t\t</span>\n";
			}
            ht += "\t\t\t\t</dd>\n";
            ht += "\t\t\t\t<dd class=\"td sum\">"+addCommas(it_amt)+"원</dd>\n";
            ht += "\t\t\t</dl>\n";
            if(it.hasOwnProperty("side")) {
                for(var skey in it.side) {
                    var side = it.side[skey];

                    var sit_amt = (Number(side.price) * Number(side.qty));
                    it_amt += sit_amt;

                    side_amt += (Number(side.price) * Number(side.qty));

                    ht += "\t\t\t<dl class=\"tr\">\n";
                    ht += "\t\t\t\t<dt class=\"td\">"+side.nm+"</dt>\n";
                    ht += "\t\t\t\t<dd class=\"td pm\">\n";
                    ht += "\t\t\t\t\t<span class=\"form-pm\">\n";
                    ht += "\t\t\t\t\t\t<button type=\"button\" class=\"minus\" onclick=\"javascript:changeSideQty('"+key+"','"+skey+"',-1);\">-</button>\n";
                    ht += "\t\t\t\t\t\t<input type=\"text\" value=\""+side.qty+"\" onkeyup=\"onlyNum(this);\" onChange=\"javascript:changeTxtSideQty('"+key+"','"+skey+"',this.value);\" maxlength=\"4\">\n";
                    ht += "\t\t\t\t\t\t<button type=\"button\" class=\"plus\" onclick=\"javascript:changeSideQty('"+key+"','"+skey+"',1);\">+</button>\n";
                    ht += "\t\t\t\t\t</span>\n";
                    ht += "\t\t\t\t</dd>\n";
                    ht += "\t\t\t\t<dd class=\"td sum\">"+addCommas(sit_amt)+"원</dd>\n";
                    ht += "\t\t\t</dl>\n";
                }
            }
            ht += "\t\t</div>\n";
            ht += "\t</td>\n";
            ht += "\t<td class=\"pay\">"+addCommas(it_amt)+"</td>\n";
            ht += "\t<td><button type=\"button\" class=\"btn btn-sm btn-grayLine\" onclick=\"openSideChange('"+key+"');\">사이드 변경</button></td>\n";
            ht += "</tr>\n";

            if(page == "C") {
                $("#cart_list").append(ht);
                // if($("#cart_list .order_menu").length == 0) {
                //     $("#cart_list").prepend(ht);
                // } else {
                //     $(ht).insertAfter($("#cart_list .order_menu").last());
                // }
            } else if(page == "P") {
                if($("#payment_list .order_menu").length == 0) {
                    $(ht).insertAfter($("#payment_list .order_head"));
                } else {
                    $(ht).insertAfter($("#payment_list .order_menu").last());
                }
            }
        }

    }
    $("#item_amount").text(numberWithCommas(menu_amt+side_amt)+"원");
    $("#total_amount").html(numberWithCommas(menu_amt+side_amt+delivery_amt));
}

function drawCartPageECoupon(data){
    // var len = getAllCartMenuCount();
    var menu_amt = 0;
    var side_amt = 0;

    var item = data.split("$$");

    var key = item[0]+"_"+item[1]+"_"+item[2];

	var jdata = new Object();
    //if(jdata == null) {
        jdata.type = item[0];
        jdata.idx = item[1];
        jdata.opt = item[2];
        jdata.price = 0;//item[3];
        jdata.nm = item[4];
        jdata.qty = 1;
        jdata.img = item[5];
        jdata.side = {};
    //}

    if(jdata.idx == ""){
        alert('코드가 잘못되었습니다.');
    }

    $("#order_type_info").show();
    // if(page == "C") {
        $("#cart_list").html("");
    // } else if(page == "P") {
    //     $("#payment_list .order_menu").remove();
    // }

    // if(len == 0) {
    //     var ht = "";

    //     ht += "<tr>\n";
    //     ht += "\t<td colspan=\"5\" class=\"empty\">장바구니에 담긴 상품이 없습니다.</td>\n";
    //     ht += "</tr>\n";
                        
    //     $("#cart_list").html(ht);
    //     $("#order_type_info").hide();
    // } else {
    //     for(var i = 0; i < len; i++) {
            // var key = sessionStorage.key(i);

            // if(key == ta_id) continue;

            var it = jdata;//JSON.parse(sessionStorage.getItem(key));

            var it_amt = (Number(it.price) * Number(it.qty)); 
            menu_amt += (Number(it.price) * Number(it.qty));

            var ht = "";

            ht += "<tr>\n";
            ht += "\t<td class=\"chk\"><label class=\"ui-checkbox no-txt\"><input type=\"checkbox\" value=\""+key+"\" disabled><span></span></label></td>\n";
            ht += "\t<td class=\"img\">\n";
            ht += "\t\t<a href=\"javascript:;\"><img src=\""+it.img+"\" width=\"120px\" height=\"120px\" onerror=\"this.src='http://placehold.it/120x120'\"/>\n";
            ht += "\t</td>\n";
            ht += "\t<td class=\"info ta-l\">\n";
            ht += "\t\t<div class=\"pdt-info div-table\">\n";
            ht += "\t\t\t<dl class=\"tr\">\n";
            ht += "\t\t\t\t<dt class=\"td\">"+it.nm+"</dt>\n";
            ht += "\t\t\t\t<dd class=\"td pm\">\n";
            ht += "\t\t\t\t\t<span class=\"form-pm\">\n";
            ht += "\t\t\t\t\t\t<button type=\"button\" class=\"minus\">-</button>\n";
            ht += "\t\t\t\t\t\t<input type=\"text\" value=\""+it.qty+"\" readOnly>\n";
            ht += "\t\t\t\t\t\t<button type=\"button\" class=\"plus\">+</button>\n";
            ht += "\t\t\t\t\t</span>\n";
            ht += "\t\t\t\t</dd>\n";
            ht += "\t\t\t\t<dd class=\"td sum\">"+addCommas(it_amt)+"원</dd>\n";
            ht += "\t\t\t</dl>\n";
            // if(it.hasOwnProperty("side")) {
            //     for(var skey in it.side) {
            //         var side = it.side[skey];

            //         var sit_amt = (Number(side.price) * Number(side.qty));
            //         it_amt += sit_amt;

            //         side_amt += (Number(side.price) * Number(side.qty));

            //         ht += "\t\t\t<dl class=\"tr\">\n";
            //         ht += "\t\t\t\t<dt class=\"td\">"+side.nm+"</dt>\n";
            //         ht += "\t\t\t\t<dd class=\"td pm\">\n";
            //         ht += "\t\t\t\t\t<span class=\"form-pm\">\n";
            //         ht += "\t\t\t\t\t\t<button type=\"button\" class=\"minus\" onclick=\"javascript:changeSideQty('"+key+"','"+skey+"',-1);\">-</button>\n";
            //         ht += "\t\t\t\t\t\t<input type=\"text\" value=\""+side.qty+"\" onkeyup=\"onlyNum(this);\" onChange=\"javascript:changeTxtSideQty('"+key+"','"+skey+"',this.value);\" maxlength=\"4\">\n";
            //         ht += "\t\t\t\t\t\t<button type=\"button\" class=\"plus\" onclick=\"javascript:changeSideQty('"+key+"','"+skey+"',1);\">+</button>\n";
            //         ht += "\t\t\t\t\t</span>\n";
            //         ht += "\t\t\t\t</dd>\n";
            //         ht += "\t\t\t\t<dd class=\"td sum\">"+addCommas(sit_amt)+"원</dd>\n";
            //         ht += "\t\t\t</dl>\n";
            //     }
            // }
            ht += "\t\t</div>\n";
            ht += "\t</td>\n";
            ht += "\t<td class=\"pay\">"+addCommas(it_amt)+"</td>\n";
            ht += "\t<td><button type=\"button\" class=\"btn btn-sm btn-grayLine\" onclick=\"javascript:alert('E-쿠폰은 사이드 변경이 불가능합니다.');\">사이드 변경</button></td>\n";
            ht += "</tr>\n";

            // if(page == "C") {
                $("#cart_list").append(ht);
                // if($("#cart_list .order_menu").length == 0) {
                //     $("#cart_list").prepend(ht);
                // } else {
                //     $(ht).insertAfter($("#cart_list .order_menu").last());
                // }
            // } else if(page == "P") {
            //     if($("#payment_list .order_menu").length == 0) {
            //         $(ht).insertAfter($("#payment_list .order_head"));
            //     } else {
            //         $(ht).insertAfter($("#payment_list .order_menu").last());
            //     }
            // }
        // }

    // }
    $("#item_amount").text(numberWithCommas(menu_amt+side_amt)+"원");
    $("#total_amount").html(numberWithCommas(menu_amt+side_amt+delivery_amt));
}


//----------------------------------------------------------------------
//  장바구니 사이드변경 추가
//----------------------------------------------------------------------
var sideChangeView = "";
var sideChangeItem = null;

function openSideChange(key) {
    lpOpen(".lp_sideChange");

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

    lpClose(".lp_sideChange");
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

        var sc_item_amt = 0;
        var sc_side_amt = 0;

        $(".addmenu").html("");

		if (item.pin != '')
			item.price = 0;

        sc_item_amt = Number(item.price) * Number(item.qty);

        var ht = "";

        ht += "<dl>\n";
        ht += "\t<dt>"+item.nm+"</dt>\n";
        ht += "\t<dd>\n";
		if (item.pin != ''){
			ht += "\t\t\<font color='red'>[E-쿠폰]</font>\n";
		}else{
			ht += "\t\t<span class=\"form-pm\">\n";
			ht += "\t\t\t<button type=\"button\" class=\"minus\" onclick=\"javascript:changeMenuQty('"+key+"',-1);\">-</button>\n";
			ht += "\t\t\t<input type=\"text\" value=\""+item.qty+"\">\n";
			ht += "\t\t\t<button type=\"button\" class=\"plus\" onclick=\"javascript:changeMenuQty('"+key+"',1);\">+</button>\n";
			ht += "\t\t</span>\n";
		}
		ht += "\t\t<div class=\"mon\">"+addCommas(sc_item_amt)+"원</div>\n";
        ht += "\t</dd>\n";
        ht += "</dl>\n";
        if(item.hasOwnProperty("side")) {
            for(var skey in item.side) {
                $("#"+skey+" :checkbox").prop("checked", true);
                var side = item.side[skey];

				var ss_amt = Number(side.price) * Number(side.qty);
                sc_side_amt += ss_amt

                ht += "<dl>\n";
                ht += "\t<dt>"+side.nm+"</dt>\n";
                ht += "\t<dd>\n";
                ht += "\t\t<span class=\"form-pm\">\n";
                ht += "\t\t\t<button type=\"button\" class=\"minus\" onclick=\"javascript:changeSideQty('"+key+"','"+skey+"',-1);\">-</button>\n";
                ht += "\t\t\t<input type=\"text\" value=\""+side.qty+"\" onkeyup=\"onlyNum(this);\" onChange=\"javascript:changeTxtSideQty('"+key+"','"+skey+"',this.value);\" maxlength=\"4\">\n";
                ht += "\t\t\t<button type=\"button\" class=\"plus\" onclick=\"javascript:changeSideQty('"+key+"','"+skey+"',1);\">+</button>\n";
                ht += "\t\t</span>\n";
                ht += "\t\t<div class=\"mon\">"+addCommas(ss_amt)+"원<button type=\"button\" class=\"delete\" onclick=\"removeCartSideNew('"+key+"','"+skey+"');\">삭제버튼</button></div>\n";
                ht += "\t</dd>\n";
                ht += "</dl>\n";
            }
        }

        $(".addmenu").html(ht);

        $("#sc_item_amount").text(addCommas(sc_item_amt)+"원");
        $("#sc_side_amount").text(addCommas(sc_side_amt)+"원");
        $("#sc_total_amount").text(addCommas(sc_item_amt+sc_side_amt)+"원");
    }
}


function setTempAddress() {
    var tAddr = getTempAddress();

    if(tAddr != null) {
        $("#address_list tbody #tAddr").remove();

        var ht = "";

        ht += "<tr id=\"tAddr\">\n";
        ht += "\t<td></td>\n";
        ht += "\t<!--td>"+tAddr.addr_name+"</td>\n";
        ht += "\t<td>"+tAddr.mobile+"</td-->\n";
        ht += "\t<td class=\"ta-l\">\n("+tAddr.zip_code+")<br>\n"+tAddr.address_main+" "+tAddr.address_detail+"\n</td>\n";
        ht += "<td>\n<button type=\"button\" onclick=\"selectShipAddress(0);\" class=\"btn btn-sm btn-redLine\">선택</button>\n</td>\n";
        ht += "</tr>\n";

        $("#address_list tbody").append(ht);
    }
}

function drawShipAddress(data) {
    if(data.addr_idx == "") data.addr_idx = 0;

    $("#addr_idx").val(data.addr_idx);
    // $("#ship_address").text(data.address_main+" "+data.address_detail);
    $("#addr_data").val(JSON.stringify(data));

    checkDeliveryShop(data);

    // lpClose(".lp_orderShipping");
}

function setDeliveryShopInfo(data) {
    $("#branch_id").val(data.branch_id);
    $("#branch_data").val(JSON.stringify(data));

    goOrder();
}

// function getDeliveryShopInfo(branch_id) {
//     $.ajax({
//         method: "post",
//         url: "/api/ajax/ajax_getStoreInfo.asp",
//         data: {branch_id: branch_id},
//         success: function(res) {
//             var si = JSON.parse(res);

//             $("#branch_data").val(res);
//             $("#branch_id").val(branch_id);
//             $("#branch_name").text(si.branch_name);
//             $("#branch_tel").text("("+si.branch_tel+")");

//             lpClose(".lp_orderShipping");
//         }
//     });
// }

// function selectShipAddress(addr_idx) {
//     if(addr_idx == 0) {
//         drawShipAddress(getTempAddress());
//     } else {
//         $.ajax({
//             method: "post",
//             url: "/api/ajax/ajax_getAddress.asp",
//             data: {"address_idx": addr_idx},
//             success: function(data) {
//                 drawShipAddress(JSON.parse(data));
//             }
//         });
//     }
// }


/**
 * 페이징
 */
/* Paging */
function setLocation(info) {
    var gotoPage = info.gotoPage;
    var params = info.params;
    location.href = location.pathname+"?gotopage="+gotoPage+"&"+params+"";
}
function makePaging(info) {
    var PageSize = info.PageSize;
    var gotoPage = info.gotoPage;
    var TotalCount = info.TotalCount;
    var params = info.params;
    var html = "";
    var i = 0;

    var StartPage = 0;
    var EndPage = 0;

    if(gotoPage == "0") {
        gotoPage = "1";
    }
    if (typeof PageSize == "undefined") {
        PageSize = "10";
    }
    if (typeof PageCount == "undefined") {
        PageCount = parseInt((TotalCount-1) / PageSize) + 1;
    }

    var splitPageSize = 10;
    StartPage = (parseInt((gotoPage-1) / splitPageSize) * splitPageSize) + 1;
    EndPage = (parseInt((gotoPage-1) / splitPageSize) * splitPageSize) + splitPageSize;

    // 이전 10개
    if(StartPage-splitPageSize >= 1) {
        html += "<a href=\"#\" onclick=\"setLocation({gotoPage:"+(StartPage-splitPageSize)+", params:'"+params+"'}); return false;\" class=\"board-nav btn_first\">이전</a>&nbsp;";
    }
    // 이전 1개
    if(gotoPage - 1 >= 1) {
        html += "<a href=\"#\" onclick=\"setLocation({gotoPage:"+gotoPage+"-1, params: '"+params+"'}); return false;\" class=\"board-nav btn_prev\">이전</a>"
    }
    html += "<ul class=\"board-page\">";
    for( i = StartPage; i <= EndPage && i <= PageCount; i++) {
        if (i==PageCount || parseInt(i%splitPageSize)=="0") {
            if(i== gotoPage) {
                strCls = " class=\"on\"";
            } else {
                strCls = "";
            }
            html += "<li "+strCls+"><a href=\"#\" onclick=\"setLocation({gotoPage:"+i+", params:'"+params+"'}); return false;\">"+i+"</a></li>";
        } else {
            if(i== gotoPage) {
                strCls = " class=\"on\"";
            } else {
                strCls = "";
            }
            html += "<li "+strCls+"><a href=\"#\" onclick=\"setLocation({gotoPage:"+i+", params:'"+params+"'}); return false;\">"+i+"</a></li>";
        }
    }
    html += "</ul>";
    //다음 1개
    if (PageCount > gotoPage) {
        html += "<a href=\"#\" onclick=\"setLocation({gotoPage:"+gotoPage+"+1, params: '"+params+"'}); return false;\" class=\"board-nav btn_next\">다음</a>"
    }
    // 다음 10개
    if (StartPage + splitPageSize <= PageCount) {
        html += "<a href=\"#\" onclick=\"setLocation({gotoPage:"+(StartPage+splitPageSize)+", params: '"+params+"'}); return false;\" class=\"board-nav btn_last\">다음</a>"
    }

    if (TotalCount > 0) {
        return html;
    } else {
        return "";
    }
}

function mobile_window_open(str)
{
	if (str == "D" || str == "P") {
		url = g2_bbq_m_url +"/order/selection.asp?pc_move=Y&order_type="+ str;
	} else if (str == "noMem") { 
		url = g2_bbq_m_url +"/mypage/orderListNonMem.asp?pc_move=Y";
	} else if (str == "ecoupon") { 
		url = g2_bbq_m_url +"/main.asp?pc_move=Y&ecoupon=Y";
	} else {
		url = g2_bbq_m_url +"/main.asp?pc_move=Y";
	}

	$('#mobile_lay_iframe').prop('src', url).css('width','500px');

	var agent = navigator.userAgent.toLowerCase();

	if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) { // ie
		c = (Number($(window).width())-484);
	} else { // 그외
		c = (Number($(window).width())-495);
	}

	$('#mobile_lay').bPopup({
		speed: 700,
		transition: 'slideBack',
		transitionClose: 'slideBack',
		modalClose: false,
		scrollBar:false,
		opacity: 0.6,
		position: [c, -10],
		positionStyle: 'fixed' //'fixed' or 'absolute'
	});

	$(window).resize(function() { 
		$('#mobile_lay_iframe').prop('height', (Number($(window).height()))+'px')
	});

/*
	$('#mobile_lay').bPopup({
		speed: 700,
		transition: 'slideBack',
		transitionClose: 'slideBack',
		modalClose: false,
		scrollBar:false,
		opacity: 0.6,
		position: ['auto', -10],
		positionStyle: 'fixed' //'fixed' or 'absolute'
	});
*/

//	$.blockUI({ message: $('#mobile_lay') });
//	window.open(url, 'window', 'width=450, height=1500, left=0, top=0, menubar=no, toolbar=no, status=no');
//	window.open('https://m.bbq.co.kr', 'window', 'width=450, height=1500, left=0, top=0');
}

function mobile_order_window_open()
{
	mobile_window_open('');
}

function mobile_cart_window_open()
{
	mobile_window_open('');
}

$(function(){
	$('#mobile_lay_iframe').prop('height', (Number($(window).height()))+30+'px');

	$(window).resize(function() {
		if ($('#mobile_lay').css('display') == 'block') {
			c = (Number($(window).width())-500);

			$('#mobile_lay').css('left', c);

			$('#mobile_lay_iframe').prop('height', (Number($(window).height()))+'px');
		}
	});
});

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