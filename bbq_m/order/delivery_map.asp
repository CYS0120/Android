<!--#include virtual="/api/include/utf8.asp"-->

<%
	order_type = GetReqStr("order_type","")
	branch_id = GetReqStr("branch_id","")
	branch_data = GetReqStr("branch_data","")
	addr_idx = GetReqStr("addr_idx","")
	addr_data = GetReqStr("addr_data","")

	cancel_idx = GetReqStr("cancel_idx","")

	If order_type = "D" Then
		If addr_idx <> "" And addr_data <> "" Then
			Set aJson = JSON.Parse(addr_data)

			addr_idx = aJson.addr_idx
			address = aJson.address_main&" "&aJson.address_detail
			Set aJson = Nothing
		Else
			If CheckLogin() Then
				If addr_idx = "" Then addr_idx = 0

				Set aCmd = Server.CreateObject("ADODB.Command")

				With aCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_member_addr_select"

					.Parameters.Append .CreateParameter("@addr_idx", adInteger, adParamInput, , addr_idx)
					.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
					If addr_idx = 0 Then
						.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "MAIN")
					Else
						.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 10, "ONE")
					End If

					Set aRs = .Execute
				End With
				Set aCmd = Nothing

				If Not (aRs.BOF Or aRs.EOF) Then
					addr_idx = aRs("addr_idx")
					address = aRs("address_main")&" "&aRs("address_detail")

					addr_data = AddressToJson(aRs)
				End If

				Set aRs = Nothing

			End If
		End If

		If branch_data <> "" Then
			Set bJson = JSON.Parse(branch_data)
			branch_id = bJson.branch_id
			branch_name = bJson.branch_name
			branch_tel = bJson.branch_tel
			Set bJson = Nothing
		End If
	ElseIf order_type = "P" Then
		If branch_id <> "" And branch_data <> "" Then
			Set bJson = JSON.Parse(branch_data)
			branch_name = bJson.branch_name
			branch_tel = bJson.branch_tel
			address = bJson.branch_address
			Set bJson = Nothing
		End If
	End If

	ShowOrderType = False
	If (order_type = "D" AND addr_data = "") Or (order_type = "P" And branch_data = "") Then
		ShowOrderType = True
	End If
%>

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<% If Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" Then %>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
<% Else %>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js?autoload=false"></script>
<% End If %>
<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>

<script>
    // 우편번호 찾기 찾기 화면을 넣을 element
    var element_wrap = document.getElementById('wrap_daum');

    function foldDaumPostcode() {
        // iframe을 넣은 element를 안보이게 한다.
		$('#viewport').removeAttr('content','minimum-scale=1.0, width=750, maximum-scale=1.0, user-scalable=no');
		$('#viewport').attr('content','width=750, maximum-scale=1.0, user-scalable=no');
        document.getElementById('wrap_daum').style.display = 'none';
    }

    function showPostcode() {
        // 현재 scroll 위치를 저장해놓는다.
        var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
		daum.postcode.load(function(){
			new daum.Postcode({
				oncomplete: function(data) {
					$("#address_main").val(data.userSelectedType == "J"? data.jibunAddress: data.roadAddress);

					$("#form_addr input[name=zip_code]").val(data.zonecode);
					$("#form_addr input[name=addr_type]").val(data.userSelectedType);
					$("#form_addr input[name=address_jibun]").val(data.jibunAddress);
					$("#form_addr input[name=address_road]").val(data.roadAddress);
					$("#form_addr input[name=sido]").val(data.sido);
					$("#form_addr input[name=sigungu]").val(data.sigungu);
					$("#form_addr input[name=sigungu_code]").val(data.sigunguCode);
					$("#form_addr input[name=roadname_code]").val(data.roadnameCode);
					$("#form_addr input[name=b_name]").val(data.bname);
					$("#form_addr input[name=b_code]").val(data.bcode);
					$('#viewport').removeAttr('content','minimum-scale=1.0, width=750, maximum-scale=1.0, user-scalable=no');
					$('#viewport').attr('content','width=750, maximum-scale=1.0, user-scalable=no');
					document.getElementById('wrap_daum').style.display = 'none';
				},
				// 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
				onresize : function(size) {
					document.getElementById('wrap_daum').style.height = size.height+'px';
				},
				width : '100%',
				height : '100%'
			}).embed(document.getElementById('wrap_daum'));
		});

        // iframe을 넣은 element를 보이게 한다.
		document.getElementById('wrap_daum').style.display = 'block';
		$('#layer').css('z-index','999');
		$('#viewport').attr('content','minimum-scale=1.0, width=750, maximum-scale=1.0, user-scalable=no');
    }
</script>

<% Else %>

<script type="text/javascript">

	function showPostcode() {

		daum.postcode.load(function(){
			new daum.Postcode({
				oncomplete: function(data) {
					$("#address_main").val(data.userSelectedType == "J"? data.jibunAddress: data.roadAddress);

					$("#form_addr input[name=zip_code]").val(data.zonecode);
					$("#form_addr input[name=addr_type]").val(data.userSelectedType);
					$("#form_addr input[name=address_jibun]").val(data.jibunAddress);
					$("#form_addr input[name=address_road]").val(data.roadAddress);
					$("#form_addr input[name=sido]").val(data.sido);
					$("#form_addr input[name=sigungu]").val(data.sigungu);
					$("#form_addr input[name=sigungu_code]").val(data.sigunguCode);
					$("#form_addr input[name=roadname_code]").val(data.roadnameCode);
					$("#form_addr input[name=b_name]").val(data.bname);
					$("#form_addr input[name=b_code]").val(data.bcode);
				}
			}).open({'popupName': 'daumpost'});
		});
	}

	function map_addr() {
        $("#address_main").val("");

		$("#form_addr input[name=zip_code]").val(data.zonecode);
		$("#form_addr input[name=addr_type]").val(data.userSelectedType);
		$("#form_addr input[name=address_jibun]").val(data.jibunAddress);
		$("#form_addr input[name=address_road]").val(data.roadAddress);
		$("#form_addr input[name=sido]").val(data.sido);
		$("#form_addr input[name=sigungu]").val(data.sigungu);
		$("#form_addr input[name=sigungu_code]").val(data.sigunguCode);
		$("#form_addr input[name=roadname_code]").val(data.roadnameCode);
		$("#form_addr input[name=b_name]").val(data.bname);
		$("#form_addr input[name=b_code]").val(data.bcode);
		$('#viewport').removeAttr('content','minimum-scale=1.0, width=750, maximum-scale=1.0, user-scalable=no');
		$('#viewport').attr('content','width=750, maximum-scale=1.0, user-scalable=no');
    }

</script>

<% End If %>

<script type="text/javascript">
	var delivery_amt = 0;
	var cartPage = "cart";
	$(function(){
		if($("#addr_data").val() != "" && $("#branch_data").val() == "") {
			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_getShop.asp",
				data:{dta:$("#addr_data").val()},
				dataType: "json",
				success: function(res) {
					if(res.result == "0000") {
						if(res.online_status != "Y") {
							showAlertMsg({msg:"선택하신 지역에 배달 가능한 매장이 일시적으로 영업을 하지 않습니다."});
							$("#branch_id").val("");
							$("#branch_data").val("");

							$("#branch_name").text("-");
							$("#branch_tel").text("");
						} else {
							$("#branch_id").val(res.branch_id);
							$("#branch_data").val(JSON.stringify(res));

							$("#branch_name").text(res.branch_name);
							$("#branch_tel").text("("+res.branch_tel+")");
						}
					} else {
						showAlertMsg({msg:res.message});
						$("#branch_id").val("");
						$("#branch_data").val("");

						$("#branch_name").text("-");
						$("#branch_tel").text("");
					}
				},
				error: function(xhr){
					showAlertMsg({msg:"배달가능한 매장이 없습니다."});
					$("#branch_id").val("");
					$("#branch_data").val("");

					$("#branch_name").text("-");
					$("#branch_tel").text("");
				}
			});
		}
		$("#delivery_fee").text(numberWithCommas(delivery_amt)+"원");
		getView();

		if($("#addr_idx").val() == "" && getTempAddress() != null) {
			setTempAddress();
		}

<%
	If ShowOrderType Then
%>
		lpOpen(".lp_orderShipping");
<%
	End If

	If cancel_idx <> "" And CheckLogin() Then
%>
	$.ajax({
		type: "post",
		url: "/order/order_membership_cancel.asp",
		data: {order_idx: "<%=cancel_idx%>"},
		dataType: "json",
		success: function(res) {
			if(res.result == 0) {
				showAlertMsg({msg:"멤버십사용이 취소되었습니다."});
			} else {
				showAlertMsg({msg:"멤버십사용이 취소되지 않았습니다."});
			}
		},
		error: function(xhr) {
			showAlertMsg({msg:"멤버십 사용이 정상적으로 취소되지 않았습니다."});
		}
	});
<%
	End If
%>

<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Or instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS") > 0 Then %>
		//alert("-앱 주문시스템 긴급점검 안내-\n\n배달주문 고객분은\n모바일 웹을 이용해주세요.\nhttps://m.bbq.co.kr/\n이용에 불편을 드려 죄송합니다.");
		//return;
<% End If %>
	});

	function goOrder() {
		<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAAOS") > 0 Then %>
			alert("앱 주문 결제시스템 점검 중 입니다.\n\n현장결제를 택하시거나,\nm.bbq.co.kr로 주문결제 해주세요.\n\n이용에 불편을 드려 죄송합니다.");
			//return;
		<% End If %>
		switch($("#order_type").val()) {
			case "D":
				if($("#addr_idx").val() == "") {
					showAlertMsg({msg:"배달주소를 선택하세요."});
					return false;
				}

				if($("#branch_id").val() == "") {
					showAlertMsg({msg:"배달가능한 매장이 없습니다."});
					return false;
				}
			break;
			case "P":
				if($("#branch_id").val() == "") {
					showAlertMsg({msg:"포장가능한 매장이 없습니다."});
					return false;
				}
			break;
		}

		var cartV = getAllCartMenu();
		if(cartV.length == 0) {
			showAlertMsg({msg:"장바구니에 상품이 없습니다."});
			return;
		}

		$("#cart_form input[name=cart_value]").val(JSON.stringify(cartV));
		$("#cart_form").submit();
	}
</script>

<script type="text/javascript">
	var order_type_str = "<%=order_type%>";
</script>

<style>
.container {height:100% !important; padding:0; }
.content {height:100% !important;}
</style>

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "배달지 주소"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<%
		If CheckLogin() And vAddrIdx <> "" Then
	%>

	<script type="text/javascript">
		$(function(){
			selectShipAddress(<%=vAddrIdx%>);
		});
	</script>

	<%
		End If
	%>

	<script type="text/javascript">
		function setScreen() {
			switch($("input[type=radio][name=orderType]:checked").val()) {
				case "D":
				$(".delivery-wrap").show();
				$(".pickup-wrap").hide();
				break;
				case "P":
				$(".delivery-wrap").hide();
				$(".pickup-wrap").show();
				break;
			}
		}

		function textSearch() {
			$.ajax({
				type: "post",
				url: "/api/ajax/shopListJs.asp",
				data:{"lat":$("#lat").val(),"lng":$("#lng").val(),"search_text":$.trim($("#search_text").val())},
				success: function(res){
					$("#search_store_list").html("");
					if(res.length > 0) {
					$.each(res, function(k,v){
						var shtml = "";

						shtml += "<div class=\"box\" id=\"br_"+v.branch_id+"\" value='"+JSON.stringify(v)+"'>\n";
						shtml += "\t<div class=\"name\">"+v.branch_name+"</div>\n";
						shtml += "\t<ul class=\"info\">\n";
						shtml += "\t\t<li>"+v.branch_tel+"</li>\n";
						shtml += "\t\t<li>"+v.branch_address+"</li>\n";
						shtml += "\t</ul>\n";
						shtml += "\t<ul class=\"btn-wrap\">\n";
						shtml += "\t\t<li>\n";
						shtml += "\t\t\t<button type=\"button\" onclick=\"selectStore('"+v.branch_id+"');\" class=\"btn btn-md btn-redLine w-100p btn-redChk\">선택</button>\n";
						shtml += "\t\t</li>\n";
						shtml += "\t</ul>\n";
						shtml += "</div>\n";

						$("#search_store_list").append(shtml);
					});
				}
				},
				error: function(xhr) {
					showAlertMsg({msg:xhr});
				}
			});
		}

		function selectStore(br_id) {
			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_getStoreOnline.asp",
				data: {"branch_id": br_id},
				dataType: "json",
				success: function(res) {
					if(res.result == "0000") {
						$.ajax({
							method: "post",
							url: "/api/ajax/ajax_eventshop_check.asp",
							data: {"MENUIDX":$("#CART_IN_PRODIDX").val(),"BRANCH_ID":br_id},
							dataType: "json",
							success: function(data) {
								if(data.result == "9999") {
									showAlertMsg({msg:data.message});
								}else{
									var br_data = $("#br_"+br_id).attr("value");
									var branch_data = JSON.parse(br_data);

									$("#branch_id").val(br_id);
									$("#branch_data").val(br_data);
									$("#spent_time").val($(".pickup-wrap2 input[name=after]:checked").val());

									lpClose('.lp_shopSearch');
									setSelectedStore();
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

		function setSelectedStore() {
			var branch_id = $("#branch_id").val();

			$("#selected_branch").html("<p class=\"explain\">포장 매장 찾기를 통해 포장가능한 매장을<br>선택해 주세요.</p>");

			if(branch_id != "") {
				var bd = JSON.parse($("#branch_data").val());

				$("#selected_branch").html("");

				var bhtml = "";
				bhtml += "<div class=\"box\">\n";
				bhtml += "\t<div class=\"name\">"+bd.branch_name+"</div>\n";
				bhtml += "\t<ul class=\"info\">\n";
				bhtml += "\t\t<li>"+bd.branch_tel+"</li>\n";
				bhtml += "\t\t<li>"+bd.branch_address+"</li>\n";
				bhtml += "\t</ul>\n";
				bhtml += "\t<ul class=\"btn-wrap\">\n";
				bhtml += "\t</ul>\n";
				bhtml += "</div>\n";
			
				$("#selected_branch").html(bhtml);

				lpClose('.lp_orderShipping');
				$("#order_type").val("P");

				$("#btn_order").show();
				setPickupAddress();
			}
		}

		function setPickupAddress() {
			setOrderTypeTitle();

			var bd = JSON.parse($("#branch_data").val());

			$("#branch_name").text(bd.branch_name);
			$("#branch_tel").text("("+bd.branch_tel+")");
			$("#ship_address").text(bd.branch_address);
		}

		function setOrderTypeTitle() {
			$("#btn_order").text("주문하기");
			switch($("#order_type").val()) {
				case "D":
				$("#order_type_title").text("배달매장 :");
				$("#address_title").text("배달주소 :");
				$("#btn_order").text("배달주문하기");
				break;
				case "P":
				$("#order_type_title").text("포장매장 :");
				$("#address_title").text("포장주소 :");
				$("#btn_order").text("포장주문하기");
				break;
			}
			chkOrderInfo();
		}

		function chkOrderInfo() {
			switch($("#order_type").val()) {
				case "D":
				if($("#branch_id").val() != "" && $("#branch_data").val() != "" && $("#addr_id").val() != "" && $("#addr_data").val() != "") {
					$("#btn_order").show();
				} else {
					$("#order_type_title").text("주문방법 및 주소지가 선택되지 않았습니다.");
					$("#branch_name").text("");
					$("#address_title").text("");
					$("#ship_address").text("");
					$("#btn_order").hide();
				}
				break;
				case "P":
				if($("#branch_id").val() != "" && $("#branch_data").val() != "") {
					$("#btn_order").show();
				} else {
					$("#order_type_title").text("주문방법 및 주소지가 선택되지 않았습니다.");
					$("#branch_name").text("");
					$("#address_title").text("");
					$("#ship_address").text("");
					$("#btn_order").hide();
				}
				break;
				default:
				$("#order_type_title").text("주문방법 및 주소지가 선택되지 않았습니다.");
				$("#branch_name").text("");
				$("#address_title").text("");
				$("#ship_address").text("");
				$("#btn_order").text("주문하기");
				$("#btn_order").hide();
				break;
			}
		}

		$(function(){
			$("#search_text").keypress(function(e){
				if(e.keyCode == 13) {
					e.preventDefault();
					textSearch();
				}
			});

			initLoc();

			setScreen();
			setOrderTypeTitle();
			
			var cV = getAllCartMenu();

			if(cV.length == 0) {
				$("#order_type_info").hide();
			}
		});


d_lat = "37.491872";
d_lng = "127.115922";


		function initLoc() {
			var uluru = {lat: d_lat, lng: d_lng};

			// Try HTML5 geolocation.
			if (navigator.geolocation) {
			  navigator.geolocation.getCurrentPosition(function(position) {
				var pos = {
				  lat: position.coords.latitude,
				  lng: position.coords.longitude
				};

				$('#lat').val(pos.lat);
				$('#lng').val(pos.lng);
				// loadTabList(pos);
				textSearch();
			  }, function() {
					$('#lat').val(uluru.lat);
					$('#lng').val(uluru.lng);
					textSearch();
			  });
			} else {
				$('#lat').val(uluru.lat);
				$('#lng').val(uluru.lng);
				textSearch();
			}
		}

		function openOrderType() {
			var order_type = $("#order_type").val();

			if(order_type == "") order_type = "D";
			$(".lp_orderShipping input[name=orderType][value="+order_type+"]").prop("checked", true);
			setScreen();
			lpOpen(".lp_orderShipping");
		}

	// 2019-05-23 이벤트로 인해 생성
	$(function(){
		var len = getAllCartMenuCount();
		var cartprodidx = '';
		if(len == 0) {
		} else {
			for(var i = 0; i < len; i++) {
				var key = sessionStorage.key(i);
				if(key == ta_id) continue;
				var it = JSON.parse(sessionStorage.getItem(key));
				cartprodidx += ','+it.idx;
			}
		}
		$("#CART_IN_PRODIDX").val(cartprodidx);
	});
	// 2019-05-23 이벤트로 인해 생성

	function go_next_page_map(t)
	{

					if($('#branch_id').val() == "") {
						alert("배달가능한 매장이 없습니다.");
						$('#zip_code').val('');
						$('#address_main').val('');
						$('#address_detail').val('');
					} else {

						br_id = $('#branch_id').val();
						br_data = $("#branch_data").val();

						// 다른 매장 선택시 장바구니 상품 제거.
						change_store_cart(br_id);

						$.ajax({
							method: "post",
							url: "/api/ajax/ajax_getStoreOnline.asp",
							data: {"branch_id": br_id},
							dataType: "json",
							success: function(res) {
								if(res.result == "0000") {
									$.ajax({
										method: "post",
										url: "/api/ajax/ajax_eventshop_check.asp",
										data: {"MENUIDX":$("#CART_IN_PRODIDX").val(),"BRANCH_ID":br_id},
										dataType: "json",
										success: function(data) {
											if(data.result == "9999") {
												showAlertMsg({msg:data.message});
											}else{
//												var br_data = $("#br_"+br_id).attr("value");
//												var branch_data = JSON.parse(br_data);
//
//												$("#branch_id").val(br_id);
//												$("#branch_data").val(br_data);

												sessionStorage.setItem("ss_branch_id", br_id);
												sessionStorage.setItem("ss_branch_data", br_data);

												//$("#spent_time").val($(".pickup-wrap2 input[name=after]:checked").val());

												// lpClose('.lp_shopSearch');
												//	setSelectedStore();
												//	document.cart_form.submit();
												if (getAllCartMenuCount() > 0) {
													location.href="/order/cart.asp";
												} else {
													location.href="/menu/menuList.asp";
												}
											}
										},
										error: function(xhr) {
											showAlertMsg({msg:"시스템 에러가 발생했습니다."});
										}
									});

								} else {
									sessionStorage.setItem("ss_branch_id", br_id);
									sessionStorage.setItem("ss_branch_data", br_data);

									showAlertMsg({msg:res.message+"  메뉴리스트로 이동합니다", ok: function(){
										location.href='/menu/menuList.asp';
									}});
								}
							},
							error: function(xhr) {
								showAlertMsg({msg:"포장 매장을 다시 선택해주세요."});
							}
						});

//						location.href='/order/out_search.asp?order_type=' + orderType_arr[i].value +"&branch_id="+ $('#branch_id').val()
					}

	}

	next_page_gubun = "";

	function addr_img_control(addr_idx)
	{
//		$('.addr_img_obj_class').each(function(){
//			$(this).prop('src', "/images/common/ui_radio_out.png");
//		})
//
//		$('#addr_img_obj_'+ addr_idx).prop('src', "/images/common/ui_radio_on.png");

		next_page_gubun = "D";

		selectShipAddress_new(addr_idx);
	}
	</script>
<script language="javascript">
function goAddr()
{
	if (document.juso_form.keyword.value == "") {
		alert("지도선택을 해주시기 바랍니다.");
		return false;
	}
}
function getAddr(){
	// 적용예 (api 호출 전에 검색어 체크) 	
	//alert($("#form_addr input[name=address_road]").val())
	$("#juso_form input[name=keyword]").val($("#form_addr input[name=address_jibun]").val());

	if (!checkSearchedWord(document.juso_form.keyword)) {
		return ;
	}

	$.ajax({
		<%
			If Request.ServerVariables("HTTPS") = "on" then     '//HTTPS 라면 
				response.write " url :'https://www.juso.go.kr/addrlink/addrLinkApiJsonp.do'  //인터넷망 "
			else 
				response.write " url :'http://www.juso.go.kr/addrlink/addrLinkApiJsonp.do'  //인터넷망 "
			End If
		 %>
		,type:"post"
		,data:$("#juso_form").serialize()
		,dataType:"jsonp"
		,crossDomain:true
		,success:function(jsonStr){
			//$("#shopSearch_list").html("");
			var errCode = jsonStr.results.common.errorCode;
			var errDesc = jsonStr.results.common.errorMessage;
			if(errCode != "0"){
				alert(errCode+"="+errDesc);
			}else{
				if(jsonStr != null){
					makeListJson(jsonStr);
				}
			}
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});
}

function makeListJson(jsonStr){
	var htmlStr = "";
	htmlStr += "";
	i = 0;
	$(jsonStr.results.juso).each(function(){

		/*
		htmlStr += "<li onclick=\"jusoCallBack('"+this.roadAddr+"','"+this.roadAddrPart1+"','"+this.addrDetail+"','"+this.roadAddrPart2+"','"+this.engAddr+"','"+this.jibunAddr+"','"+this.zipNo+"','"+this.admCd+"','"+this.rnMgtSn+"','"+this.bdMgtSn+"','"+this.detBdNmList+"','"+this.bdNm+"','"+this.bdKdcd+"','"+this.siNm+"','"+this.sggNm+"','"+this.emdNm+"','"+this.liNm+"','"+this.rn+"','"+this.udrtYn+"','"+this.buldMnnm+"','"+this.buldSlno+"','"+this.mtYn+"','"+this.lnbrMnnm+"','"+this.lnbrSlno+"','"+this.emdNo+"','"+this.entX+"','"+this.entY+"','"+i+"');\">\n";
		htmlStr += "\t<ul class=\"shop_select\">\n";
		htmlStr += "\t\t\t<li><input  type=\"radio\" name=\"jusoradio\" id=\"jusoradio"+i+"\"></li>\n";
		htmlStr += "\t\t\t<li><label for=\"shop1\">"+this.roadAddr+"</label></li>\n";
		htmlStr += "\t</ul>\n";
		htmlStr += "\t<p ><label for=\"shop1\"><span>["+this.zipNo+"]</span>"+this.jibunAddr+"</label></p>\n";
		htmlStr += "</li>";

		*/

        if(i == 0) {
		jusoCallBack(this.roadAddr,this.roadAddrPart1,this.addrDetail,this.roadAddrPart2,this.engAddr,this.jibunAddr,this.zipNo,this.admCd,this.rnMgtSn,this.bdMgtSn,this.detBdNmList,this.bdNm,this.bdKdcd,this.siNm,this.sggNm,this.emdNm,this.liNm,this.rn,this.udrtYn,this.buldMnnm,this.buldSlno,this.mtYn,this.lnbrMnnm,this.lnbrSlno,this.emdNo,this.entX,this.entY,i);
        
		i++;
		}
	});

	//$('#shopSearch_list').css("overflow-y", "scroll");
	//$('#shopSearch_list').css("overflow-x", "test");
	//$("#shopSearch_list").height(300);

	//$("#shopSearch_list").html(htmlStr);
	//$(".detaile_address").show();
}

//특수문자, 특정문자열(sql예약어의 앞뒤공백포함) 제거
function checkSearchedWord(obj){
	if(obj.value.length >0){
		//특수문자 제거
		var expText = /[%=><]/ ;
		if(expText.test(obj.value) == true){
			alert("특수문자를 입력 할수 없습니다.") ;
			obj.value = obj.value.split(expText).join(""); 
			return false;
		}
		
		//특정문자열(sql예약어의 앞뒤공백포함) 제거
		var sqlArray = new Array(
			//sql 예약어
			"OR", "SELECT", "INSERT", "DELETE", "UPDATE", "CREATE", "DROP", "EXEC",
             		 "UNION",  "FETCH", "DECLARE", "TRUNCATE" 
		);
		
		var regex;
		for(var i=0; i<sqlArray.length; i++){
			regex = new RegExp( sqlArray[i] ,"gi") ;
			
			if (regex.test(obj.value) ) {
			    alert("\"" + sqlArray[i]+"\"와(과) 같은 특정문자로 검색할 수 없습니다.");
				obj.value =obj.value.replace(regex, "");
				return false;
			}
		}
	}
	return true ;
}

function enterSearch() {
	var evt_code = (window.netscape) ? ev.which : event.keyCode;
	if (evt_code == 13) {    
		event.keyCode = 0;  
		getAddr(); 
	} 
}

function jusoCallBack(roadAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr,jibunAddr,zipNo,admCd,rnMgtSn,bdMgtSn,detBdNmList,bdNm,bdKdcd,siNm,sggNm,emdNm,liNm,rn,udrtYn,buldMnnm,buldSlno,mtYn,lnbrMnnm,lnbrSlno,emdNo,entX,entY,radiono){

	document.getElementById('zip_code').value = zipNo;
	document.getElementById('address_main').value = roadAddr;
	document.getElementById('search_text2').value = roadAddr;
	//document.getElementById('address_detail').value = zipNo;

	//$('input[name="jusoradio"]')[radiono].checked = true;

	$("#address_main").val(roadAddrPart1);
	$("#address_main2").val(roadAddrPart1);

	sujo = siNm+" "+sggNm + " " + emdNm +" " + lnbrMnnm +"-" + lnbrSlno;
	rnMgtSn1 = rnMgtSn.substr(0,5);
	rnMgtSn2 = rnMgtSn.substr(5,7);

	
	$("#juso_result").html(roadAddrPart1);

	$("#form_addr input[name=zip_code]").val(zipNo);
	$("#form_addr input[name=addr_type]").val("R");
	$("#form_addr input[name=address_jibun]").val(sujo);
	$("#form_addr input[name=address_road]").val(roadAddrPart1);
	$("#form_addr input[name=sido]").val(siNm);
	$("#form_addr input[name=sigungu]").val(sggNm);
	$("#form_addr input[name=sigungu_code]").val(rnMgtSn1);
	$("#form_addr input[name=roadname_code]").val(rnMgtSn2);
	$("#form_addr input[name=b_name]").val(emdNm);
	$("#form_addr input[name=b_code]").val(admCd);


	document.xy_form.admCd.value = admCd;
	document.xy_form.rnMgtSn.value = rnMgtSn;
	document.xy_form.udrtYn.value = udrtYn;
	document.xy_form.buldMnnm.value = buldMnnm;
	document.xy_form.buldSlno.value = buldSlno;

	$.ajax({
		<%
			If Request.ServerVariables("HTTPS") = "on" then     '//HTTPS 라면 
				response.write " url :'https://www.juso.go.kr/addrlink/addrCoordApiJsonp.do'  //인터넷망 "
			else 
				response.write " url :'http://www.juso.go.kr/addrlink/addrCoordApiJsonp.do'  //인터넷망 "
			End If
		 %>
		,type:"post"
		,data:$("#xy_form").serialize()
		,dataType:"jsonp"
		,crossDomain:true
		,success:function(jsonStr){
			
			var errCode = jsonStr.results.common.errorCode;
			var errDesc = jsonStr.results.common.errorMessage;
			if(errCode != "0"){
				alert(errCode+"="+errDesc);
			}else{
				if(jsonStr != null){

					var grs80 = new Proj4js.Proj("EPSG:5179");
					var wgs84 = new Proj4js.Proj("EPSG:4326");

					var lat = jsonStr.results.juso[0].entY;
					var lng = jsonStr.results.juso[0].entX;

					var p = new Proj4js.Point(lng, lat);

					Proj4js.transform(grs80, wgs84, p);

					lat = p.y.toFixed(6) +'0'; // 6자리 까지 하고 7자리 0 처리 (즉 7자리부터는 버림.)
					lng = p.x.toFixed(6) +'0'; // 6자리 까지 하고 7자리 0 처리 (즉 7자리부터는 버림.)

					$("#form_addr input[name=lat]").val(lat);
					$("#form_addr input[name=lng]").val(lng);

				}
			}
		}
	    ,error: function(xhr,status, error){
	    	alert("에러발생");
	    }
	});

}

function link_move() {
	$('html, body').scrollTop( $(document).height() );
}
</script>

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!--#include virtual="/includes/step.asp"-->

			<!--include virtual="/includes/address.asp"-->

			<form id="cart_form" name="cart_form" method="post" action="payment.asp">
				<input type="hidden" name="order_type" id="order_type" value="<%=order_type%>">
				<input type="hidden" name="branch_id" id="branch_id" value="<%=branch_id%>">
				<input type="hidden" name="branch_data" id="branch_data" value='<%=branch_data%>'>
				<input type="hidden" name="addr_idx" id="addr_idx" value="<%=addr_idx%>">
				<input type="hidden" name="cart_value">
				<input type="hidden" name="addr_data" id="addr_data" value='<%=addr_data%>'>
				<input type="hidden" name="spent_time" id="spent_time">
			</form>

			<input type="hidden" id="CART_IN_PRODIDX">

			<form class="form" id="juso_form" name="juso_form"  method="post" onsubmit="return false;">
			<input type="hidden" name="currentPage" value="1"/> <!-- 요청 변수 설정 (현재 페이지. currentPage : n > 0) -->
			<input type="hidden" name="countPerPage" value="100"/><!-- 요청 변수 설정 (페이지당 출력 개수. countPerPage 범위 : 0 < n <= 100) -->
			<input type="hidden" name="resultType" value="json"/> <!-- 요청 변수 설정 (검색결과형식 설정, json) --> 
			<input type="hidden" name="confmKey" value="<%=JUSO_API_KEY%>"/><!-- 요청 변수 설정 (승인키) -->
				<input type="hidden" name="keyword" id="keyword" placeholder="배달지 검색" onkeydown="enterSearch();" value="<%=search_text%>">
			</form>

			<!-- 현 위치 기반 주소 검색 -->
			<div class="location_wrap"><div id="map" style="width:100%;height:100%;"></div>
				<div class="location_map" style="z-index:1">
					<ul class="inbox1000">
						<li><input type="text" name="search_text2" id="search_text2" readonly placeholder="" style="max-width:400px; width:100%"></li>
						<li><a href="javascript:;" onclick="if (goAddr() != false) { getAddr(); link_move(); }" class="btn btn_middle btn-red">이 위치로 설정</a></li>
					</ul>
				</div>
			</div>
			<!-- // 현 위치 기반 주소 검색 -->


			<!-- Layer Popup : 배달지 입력 -->
			<div id="LP_addShipping">
				<form id="form_addr" name="form_addr" method="post" onsubmit="return false;">
				<input type="hidden" name="addr_idx" value="">
				<input type="hidden" name="mode" value="I">
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
				<input type="hidden" name="lat" value="">
				<input type="hidden" name="lng" value="">

				<input type="hidden" name="zip_code" id="zip_code">
				<input type="hidden" name="address_main" id="address_main">
				<input type="hidden" name="address_main2" id="address_main2">

				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">

						<div class="inner">
							<dl class="regForm hide">
								<dt>이름</dt>
								<dd>
									<input type="text" name="addr_name" class="w-100p">
								</dd>
							</dl>
							<dl class="regForm hide">
								<dt>전화번호</dt>
								<dd>
									<span class="ui-group-tel">
										<span><input type="text" name="mobile1" onlynum maxlength="3"></span>
										<span class="dash">-</span>
										<span><input type="text" name="mobile2" onlynum maxlength="4"></span>
										<span class="dash">-</span>
										<span><input type="text" name="mobile3" onlynum maxlength="4"></span>
									</span>
								</dd>
							</dl>
						</div>
						<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
						<div id="wrap_daum"  class="daum_search" style="background:#fff;">
						<img class="search_close" src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" onclick="foldDaumPostcode()" alt="접기 버튼">
						</div>
						<% End If %>
							
						<!-- 상세주소입력 -->
						<dl class="detaile_address inbox1000" >
							<dt>상세주소입력</dt>
							<dd id="juso_result"></dd>
							<dd><input type="text" name="address_detail" id="address_detail" placeholder="상세 주소를 입력하세요" style="width:100%" onkeyup="chkWord_new(this, 60, 'N');"></dd>
						</dl>
						<!-- // 상세주소입력 -->

						<div class="btn_shopSearch inbox1000">

							<a href="/order/delivery.asp?order_type=<%=order_type%>" class="btn btn-redLine btn_big">취소</a> <a href="javascript:;" onclick="javascript:<% If CheckLogin() Then %>validAddress()<% Else %>validAddressNoMember()<% End If %>;" class="btn btn-red btn_big">확인</a>

						</div>

					</div>
					<!--// LP Content -->
				</div>
				<!--// LP Container -->
				</form>
			</div>
			<!--// Layer Popup -->


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=DAUM_MAP_API_KEY%>&libraries=services"></script>
<script>

var mapContainer = document.getElementById('map'), // 지도를 표시할 div 

mapOption = {
	center: new kakao.maps.LatLng(d_lat, d_lng), // 지도의 중심좌표
	level: 1 // 지도의 확대 레벨
};  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
if (navigator.geolocation) {
    
    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
    navigator.geolocation.getCurrentPosition(function(position) {
        
        var lat = position.coords.latitude, // 위도
            lon = position.coords.longitude; // 경도
        
        var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
            message = ''; // 인포윈도우에 표시될 내용입니다
        
        // 마커와 인포윈도우를 표시합니다
        displayMarker(locPosition, message);

		searchDetailAddrFromCoords(locPosition, function(result, status) {
			if (status === kakao.maps.services.Status.OK) {
				var detailAddr = !!result[0].road_address ? result[0].road_address.address_name: result[0].address.address_name;
				
				
				/*
				var content = '<div class="bAddr">' +
								'<span class="title">법정동 주소정보</span>' + 
								detailAddr + 
							'</div>';
							*/

					//$("#address_main").val(result[0].road_address.address_name);

					//sujo = result[0].address.region_1depth_name+" "+result[0].address.region_2depth_name + " " + result[0].address.region_3depth_name +" " + result[0].address.main_address_no +"-" + result[0].address.sub_address_no;
					//rnMgtSn1 = rnMgtSn.substr(0,5);
					//rnMgtSn2 = rnMgtSn.substr(5,7);
					//$("#juso_result").html(result[0].road_address.address_name);
					//$("#form_addr input[name=zip_code]").val(result[0].road_address.zone_no);
					//$("#form_addr input[name=addr_type]").val("R");
					//$("#form_addr input[name=address_jibun]").val(sujo);
					//$("#form_addr input[name=address_road]").val(result[0].road_address.address_name);
					//$("#form_addr input[name=sido]").val(result[0].address.region_1depth_name);
					//$("#form_addr input[name=sigungu]").val(result[0].address.region_2depth_name);
					//$("#form_addr input[name=sigungu_code]").val(result[0].road_address.zone_no);
					//$("#form_addr input[name=roadname_code]").val("");
					//$("#form_addr input[name=b_name]").val(result[0].address.region_3depth_name);
					//$("#form_addr input[name=b_code]").val("");
					$("#form_addr input[name=address_jibun]").val(detailAddr);

					getAddr();

				// 마커를 클릭한 위치에 표시합니다 
				marker.setPosition(latlng);
				marker.setMap(map);

				// 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
				//infowindow.setContent(content);
				//infowindow.open(map, marker);
			}   
		});

//		$( document ).ready(function() {
//			map.setCenter(locPosition);
//		});

    }, function(){

		$( document ).ready(function() {
			var coord = new kakao.maps.LatLng(d_lat, d_lng);

			map.setCenter(coord);
		});

	});
    
} else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
    
    var locPosition = new kakao.maps.LatLng(d_lat, d_lng),
        message = 'geolocation을 사용할수 없어요.'
        
    displayMarker(locPosition, message);
}

// 지도에 마커와 인포윈도우를 표시하는 함수입니다
function displayMarker(locPosition, message) {

    // 마커를 생성합니다
    var marker = new kakao.maps.Marker({  
        map: map, 
        position: locPosition
    }); 
    
    var iwContent = message, // 인포윈도우에 표시할 내용
        iwRemoveable = true;

    // 인포윈도우를 생성합니다
    var infowindow = new kakao.maps.InfoWindow({
        content : iwContent,
        removable : iwRemoveable
    });
    
    // 인포윈도우를 마커위에 표시합니다 
    infowindow.open(map, "");
    
    // 지도 중심좌표를 접속위치로 변경합니다
    map.setCenter(locPosition);      
}    

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

var marker = new kakao.maps.Marker(), // 클릭한 위치를 표시할 마커입니다
    infowindow = new kakao.maps.InfoWindow({zindex:1}); // 클릭한 위치에 대한 주소를 표시할 인포윈도우입니다

// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
searchAddrFromCoords(map.getCenter(), displayCenterInfo);

// 지도를 클릭했을 때 클릭 위치 좌표에 대한 주소정보를 표시하도록 이벤트를 등록합니다
/*
kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
    searchDetailAddrFromCoords(mouseEvent.latLng, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var detailAddr = !!result[0].road_address ? '<div>도로명주소 : ' + result[0].road_address.address_name + '</div>' : '';
            detailAddr += '<div>지번 주소 : ' + result[0].address.address_name + '</div>';
            
            var content = '<div class="bAddr">' +
                            '<span class="title">법정동 주소정보</span>' + 
                            detailAddr + 
                        '</div>';

            // 마커를 클릭한 위치에 표시합니다 
            marker.setPosition(mouseEvent.latLng);
            marker.setMap(map);

            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
            infowindow.setContent(content);
            infowindow.open(map, marker);
        }   
    });
});
*/

// 마우스 드래그로 지도 이동이 완료되었을 때 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
kakao.maps.event.addListener(map, 'dragend', function() {        
    
    // 지도 중심좌표를 얻어옵니다 
    var latlng = map.getCenter(); 
//	console.log(latlng)
    
    var message = '변경된 지도 중심좌표는 ' + latlng.getLat() + ' 이고, ';
    message += '경도는 ' + latlng.getLng() + ' 입니다';
    
    //var resultDiv = document.getElementById('result');  
    //resultDiv.innerHTML = message;
	
	searchDetailAddrFromCoords(latlng, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var detailAddr = !!result[0].road_address ? result[0].road_address.address_name: result[0].address.address_name;
            
            
			/*
            var content = '<div class="bAddr">' +
                            '<span class="title">법정동 주소정보</span>' + 
                            detailAddr + 
                        '</div>';
						*/

				//$("#address_main").val(result[0].road_address.address_name);

				//sujo = result[0].address.region_1depth_name+" "+result[0].address.region_2depth_name + " " + result[0].address.region_3depth_name +" " + result[0].address.main_address_no +"-" + result[0].address.sub_address_no;
				//rnMgtSn1 = rnMgtSn.substr(0,5);
				//rnMgtSn2 = rnMgtSn.substr(5,7);
				//$("#juso_result").html(result[0].road_address.address_name);
				//$("#form_addr input[name=zip_code]").val(result[0].road_address.zone_no);
				//$("#form_addr input[name=addr_type]").val("R");
				//$("#form_addr input[name=address_jibun]").val(sujo);
				//$("#form_addr input[name=address_road]").val(result[0].road_address.address_name);
				//$("#form_addr input[name=sido]").val(result[0].address.region_1depth_name);
				//$("#form_addr input[name=sigungu]").val(result[0].address.region_2depth_name);
				//$("#form_addr input[name=sigungu_code]").val(result[0].road_address.zone_no);
				//$("#form_addr input[name=roadname_code]").val("");
				//$("#form_addr input[name=b_name]").val(result[0].address.region_3depth_name);
				//$("#form_addr input[name=b_code]").val("");
				$("#form_addr input[name=address_jibun]").val(detailAddr);
				
				$("#address_main").val($("#address_main2").val());

				getAddr();

            // 마커를 클릭한 위치에 표시합니다 
            marker.setPosition(latlng);
            marker.setMap(map);

            // 인포윈도우에 클릭한 위치에 대한 법정동 상세 주소정보를 표시합니다
            //infowindow.setContent(content);
            //infowindow.open(map, marker);
        }   
    });
    
});

// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
kakao.maps.event.addListener(map, 'idle', function() {
    searchAddrFromCoords(map.getCenter(), displayCenterInfo);
});

function searchAddrFromCoords(coords, callback) {
    // 좌표로 행정동 주소 정보를 요청합니다
    geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
}

function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}

// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
function displayCenterInfo(result, status) {
    if (status === kakao.maps.services.Status.OK) {
        var infoDiv = document.getElementById('address_main');

        for(var i = 0; i < result.length; i++) {
            // 행정동의 region_type 값은 'H' 이므로
			//console.log('그런 너를 마주칠까 ' + result[0].address.address_name + '을 못가');
            if (result[i].region_type === 'H') {
                infoDiv.value = result[i].address_name;
                break;
            }
        }
    }    
}
</script>
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->