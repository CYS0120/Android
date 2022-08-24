<!--#include virtual="/api/include/utf8.asp"-->
<% Call DBOpen %>
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="메뉴소개, BBQ치킨">
<meta name="Description" content="메뉴소개">
<title>메뉴소개 | BBQ치킨</title>

<%
	Dim anc : anc = Request("anc")
	if anc = "103" then anc = ""
	'if len(anc) = 0 then anc = ""
	Dim order_type : order_type = GetReqStr("order_type","D")
%>
<script type="text/javascript">
	var cartPage = "";
	function addMenuNGo(data, go) {
        var a = 'Y';

		data += "$$";	//더미 추가
        var item = data.split("$$");
        var key = item[0]+"_"+item[1]+"_"+item[2]+"_"+item[6];

		if (key.substring(key.length, key.length-1) != '_'){
			var key = key + '_';
		}
	
		cart_key = sessionStorage.getItem(key);

		if (typeof(cart_key) != "undefined" && cart_key != "" && cart_key != null) {
			a = 'N';
		} else{
			addCartMenu(data);
		}

        if (a == 'N') {
            // $('#lp_alert .btn-wrap').hide(0);
            $('#lp_alert .btn_lp_close').hide(0);
            // $('#lp_alert .lp-confirm-cont').css('padding','20px 20px 0');
    
            showAlertMsg({msg:"이미 장바구니에 담긴 메뉴입니다. 장바구니로 이동합니다."});
			$('#lp_alert .btn-wrap').on("click",function() {
				location.href = "/order/cart.asp";
			});
        } else{
			if(go) {
				location.href = "/order/cart.asp";
			} else{
				// showAlertMsg({msg:"장바구니에 담았습니다"});
				lpOpen2("#lp_cart");
				// if(window.confirm("선택한 메뉴가 장바구니에 담겼습니다.\n장바구니로 이동하시겠습니까?")) {
				// location.href = "/order/cart.asp";
			}
		}

	}

	var menu_name_arr = new Array();
	var menu_cate_arr = new Array();
	var menu_idx_arr = new Array();
	var save_anc = "";


	function list_search()
	{
		var obj = document.getElementById("list_src");
		var val = obj.value;
		var cnt = 0;
		
		$('.menuBox').hide(0); // 모든 카테고리 close

		for (i=0; i<menu_name_arr.length; i++)
		{
			if (menu_name_arr[i].replace(/ /gi, "").indexOf(val.replace(/ /gi, "")) > -1) {
				$('.menu_list_idx_'+ menu_cate_arr[i] +'_'+ menu_idx_arr[i]).show(0); // 검색된 카테고리 open
				cnt++;
			}
		}

		if (menu_name_arr.length > cnt) { // 검색됨
			str = "";
			str += '<span style="display:block; text-align:center; padding:0px 0 15px 0;">"<strong>'+ cnt +'</strong>건이 검색되었습니다"</span>';
//			str += '<a href="javascript:void(0)" onclick="$(\'#list_src\').val(\'\'); list_search(); $(\'#list_src\').focus();" class="btn  btn-red btn_middle">다시검색</a>';
			str += '<a href="javascript:void(0)" onclick="menu_list_reset(2) " class="btn btn-black btn_middle" >전체보기</a>';

			$('#list_src_result').html(str).show(0);
			$('#re_text').show(0)
		} else { // input 빈값.
			$('#list_src_result').html('').hide(0);
			$('#re_text').hide(0);
			menu_go(save_anc); // 원래 보던 리스트 보여주기
		}
	}

	function menu_go(anc)
	{
		menu_name_arr = [];
		menu_cate_arr = [];
		menu_idx_arr = [];

		$('.menuBox').hide(0);
		if (anc == "") anc = $("button[name=btnMenuCate]:first").data('cateid');
		save_anc = anc; // 선택된 카테고리 저장.

		// 검색관련된것 초기화
		$('#list_src').val('');
		$('#list_src_result').html('').hide(0);
		$('#re_text').hide(0);

		// if (anc == "") {
		// 	// 103은 인기메뉴.
		// 	$('.menuBox').not('.menu_cate_103').not('.menu_cate_58').show(0);
		// } else {
			// $('.menu_cate_'+ anc).show(0);
		// }

		if (anc == "133") {fstv = "<span style='font-size:13px;'>※ 페스티벌 메뉴는 다른 카테고리 메뉴와 함께 구매가 불가능합니다.</span>"} else {fstv = ""};

		$.ajax({
			type: 'POST',
			url: "/menu/menuList_ajax.asp",
			data: {
				cidx : anc,
				order_type : "<%=order_type%>"
			},
			dataType: 'html',
			success: function(data) {
				$("#fstv-menu").html(fstv);				
				$("#menu-list").html(data);

				$("div[name=menu_div]").each(function(){
					menu_idx_arr.push($(this).data("menuidx"));
					menu_name_arr.push($(this).data("menuname"));
					menu_cate_arr.push($(this).data("menucate"));
				});
			}
		});
	}

	function menu_list_reset(gubun)
	{
		$('#list_src').val(''); 
		list_search(); 

		if (gubun == "1") {
			$('#list_src').focus();
		}

		$('#re_text').hide(0)
	}

	function menu_list_cate_control(num)
	{
		$menu_list_cate_obj = $('#menu_list_cate_'+ num);

		if ($menu_list_cate_obj.parent().hasClass("open") === true) {
			$menu_list_cate_obj.parent().removeClass("open").find('.content').slideToggle(200);
		} else {
			$menu_list_cate_obj.parent().addClass("open").find('.content').slideUp(200);
		}
	}
</script>

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "메뉴"
	%>

	<!-- Header -->
		<!--#include virtual="/includes/header.asp"-->
    <!--// Header -->
	
	<!-- Container -->
	<div class="h-container" style="padding-bottom: 80px !important;">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->

		<%
			Dim cate_idx_str ': cate_idx_str = "103" ' 초기설정
			Dim cate_name_str ': cate_name_str = "모든 비비큐치킨" ' 초기설정
			Dim cate_idx_arr
			Dim cate_name_arr
			Dim category_use_yn
			Dim category_idx

			Set aCmd = Server.CreateObject("ADODB.Command")

			With aCmd
				.ActiveConnection = dbconn
				.CommandType = adCmdStoredProc
				.CommandText = "bp_main_category_select"

				Set aRs = .Execute
			End With

			Set aCmd = Nothing

			If Not (aRs.BOF Or aRs.EOF) Then
				aRs.MoveFirst

				Do Until aRs.EOF
					If cate_idx_str <> "" Then split_str = "S||S"

					category_use_yn = aRs("category_use_yn")
					category_idx = aRs("category_idx")

					if category_use_yn = "Y" then
						if order_type = "P" then 
							cate_idx_str = cate_idx_str & split_str & aRs("category_idx")
							cate_name_str = cate_name_str & split_str & aRs("category_name")
						else
							if category_idx <> "115" then
								cate_idx_str = cate_idx_str & split_str & aRs("category_idx")
								cate_name_str = cate_name_str & split_str & aRs("category_name")
							end if 
						end if 
					end if 

					if anc = "133" then
						cate_idx_str = cate_idx_str & split_str & aRs("category_idx")
						cate_name_str = cate_name_str & split_str & aRs("category_name")
					end if
					aRs.MoveNext
				Loop
			End If

			Set aRs = Nothing

			cate_idx_str = cate_idx_str & split_str & "99999" &"S||S"& "58"
			cate_name_str = cate_name_str & split_str & "사이드메뉴" &"S||S"& "음료/주류"

			cate_idx_arr = Split(cate_idx_str, "S||S")
			cate_name_arr = Split(cate_name_str, "S||S")
		%>
			
		<!-- Content -->
		<article class="content">

			<div class="topFixBanner">

				<!-- 상단 메뉴네비 -->
				<script type="text/javascript" src="/common/js/swiper/jquery-1.12.4.min.js"></script>
				<script type="text/javascript" src="/common/js/swiper/jquery-ui.min.js"></script>
				<script type="text/javascript" src="/common/js/swiper/plugins.js"></script>

				 <div class="menu_nav_wrap">
					<nav class="menu_nav2">
						<div class="swiper-wrapper">
						<% if false then '전체메뉴보기 빼기 %>
							<span class="<% if anc = "" then %>				on <% end if %> swiper-slide2"><button type="button" name="btnMenuCate" data-cateid="" onclick="menu_go(''); ">전체</button></span>
						<% end if '전체메뉴보기 빼기 %>

						<% If anc = "133" Then %>
								<span class="on swiper-slide2"><button type="button" name="btnMenuCate" data-cateid="133" onclick="menu_go('133'); ">페스티벌</button></span>
						<% Else %>
							<% For i=0 To UBound(cate_idx_arr) %>
								<span class="<% if anc = cate_idx_arr(i) then %>		on <% end if %> swiper-slide2"><button type="button" name="btnMenuCate" data-cateid="<%=cate_idx_arr(i)%>" onclick="menu_go('<%=cate_idx_arr(i)%>'); "><%=cate_name_arr(i)%></button></span>
							<% Next %>
						<% End If %>
						</div>
					</nav>
				</div>

				<script type="text/javascript">
				//페이지 로드시 실행
				$(document).ready(function() {
					$('body').addClass('bg_wht');
				
					$('.pageName').text("전체메뉴");
					
					//메뉴 상단 네비게이션
					$(window).load(function(){
						setTimeout(function(){ 
							swiper = $('.menu_nav2').swiper({
								slidesPerView: 'auto',
								<% if anc = "" and false then %>			initialSlide: '0', <% end if %>

								<% For i=0 To UBound(cate_idx_arr) %>
									<% if anc = cate_idx_arr(i) then %>		initialSlide: '<%=i%>', <% end if %>
								<% Next %>
								//freeMode:true
							});	
						}, 300);
					});
					//메뉴 카테고리 클릭
					$('.swiper-wrapper span button').click(function(){
						var $this = $(this);
						$('.swiper-wrapper span').removeClass('on');
						$this.parents('span').addClass('on');
					});
					
					$('.btn_favorite').click(function(e){
						e.preventDefault();
						var $this = $(this);
						$this.toggleClass('favorite_add');
					});
					
					var cateid = '9999';
					var cateid2 = '';
					var slide_str = "";
					
				});
				</script>
				<!-- // 상단 메뉴네비 -->


				<div class="h-inbox1000 menu_list_search ">
					<input type="text" name="list_src" id="list_src"  onkeyup="list_search()" placeholder="검색어를 입력해 주십시오">
					<span id="re_text" class="re_text" onclick="menu_list_reset(1)">X</span>
					<span id="list_src_result" class="re_search"><span>
				</div>

			</div>


			<!-- 메뉴 리스트 -->
			<div class="menu_accordion h-inbox1000" >

				<div id="fstv-menu" style="text-align:center;margin-bottom:10px;">
				</div>				
				
				<!-- menu-list -->
				<div class="menu-list" id="menu-list">
				</div>
				<!-- menu-list -->

			</div>
			<!-- //메뉴 리스트 -->


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
    <!--#include virtual="/includes/footer_new.asp"-->
    <!--// Footer -->


<!-- 아코디언 -->

<script>
function menu_list_cate_all_open()
{
	tot_cnt = "<%=m%>";

	for (i=0; i<=tot_cnt; i++)
	{
		$menu_list_cate_obj = $('#menu_list_cate_'+ i);
		$menu_list_cate_obj.parent().removeClass("open").find('.content').slideDown(0);
	}
}



//	$('.menu_accordion .menu_item .heading').click(function() {
//			
//		var a = $(this).closest('.menu_item');
//		var b = $(a).hasClass('open');
//		var c = $(a).closest('.menu_accordion').find('.open');
//			
//		if(b != true) {
//			$(c).find('.content').slideUp(200);
//			$(c).removeClass('open');
//		}
//
//		$(a).toggleClass('open');
//		$(a).find('.content').slideToggle(200);
//
//	});
</script>

<script type="text/javascript">
    function fnMove(seq, num){
        var offset = $("#anc_" + seq).offset();

		if ($('#list_src_result').css('display') == "none") {
			if (!$( '.menu_accordion' ).is( '.menu_accordion_fix')) {
				top_str = 134;
			} else {
				top_str = 124;
			}

//			$menu_list_cate_obj = $('#menu_list_cate_'+ num);
//
//			if ($menu_list_cate_obj.parent().hasClass("open") === true) {
//			} else {
//				top_str = top_str + 50;
//			}
		} else {
			if (!$( '.menu_accordion' ).is( '.menu_accordion_fix_src')) {
				top_str = 234;
			} else {
				top_str = 224;
			}
		}
		console.log(top_str)
        $('html, body').animate({scrollTop : offset.top-top_str}, 300);
    }

	<% if anc <> "" then %>
		$(function(){
//			fnMove(<%=anc%>)
		});
	<% end if %>
</script>

<script type="text/javascript">
//  var _gaq = _gaq || [];
//  _gaq.push(['_setAccount', 'UA-36251023-1']);
//  _gaq.push(['_setDomainName', 'jqueryscript.net']);
//  _gaq.push(['_trackPageview']);
//
//  (function() {
//    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
//    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
//    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
//  })();
</script>
<!-- // 아코디언 -->



<!-- 메뉴검색 -->
<script type="text/javascript">
//	var bannerOffset = $( '.topFixBanner' ).offset();

    $( window ).scroll( function() {  //window에 스크롤링이 발생하면
		var menu_accordion_fix_string = "";

		if ($('#list_src_result').css('display') == "none") {
			$( '.menu_accordion' ).removeClass( 'menu_accordion_fix_src');
			menu_accordion_fix_string = "menu_accordion_fix";
		} else {
			$( '.menu_accordion' ).removeClass( 'menu_accordion_fix');
			menu_accordion_fix_string = "menu_accordion_fix_src";
		}

		if ( $( document ).scrollTop() > 0 ) {   // 위치 및 사이즈를 파악하여 미리 정한 css class를 add 또는 remove 합니다.
			// $( '.topFixBanner' ).addClass( 'topFixBannerFixed');
			// $( '.menu_accordion' ).addClass( menu_accordion_fix_string);
		} else {
			// $( '.topFixBanner' ).removeClass( 'topFixBannerFixed');
			// $( '.menu_accordion' ).removeClass( menu_accordion_fix_string);
		}
	});
	
	$(window).load(function() {
		menu_go("<%=anc%>");
	});

</script>
<!-- // 메뉴검색 -->