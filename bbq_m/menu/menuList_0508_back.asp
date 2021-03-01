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
%>
<script type="text/javascript">
	var cartPage = "";
	function addMenuNGo(data, go) {
		addCartMenu(data);

		if(go) {
			location.href = "/order/cart.asp";
		} else {
			lpOpen("#lp_cart");
			// if(window.confirm("선택한 메뉴가 장바구니에 담겼습니다.\n장바구니로 이동하시겠습니까?")) {
			// 	location.href = "/order/cart.asp";
			// }
		}
	}

	var menu_list_arr = new Array();
	var menu_list_class = new Array();

	function list_search()
	{
		var obj = document.getElementById("list_src");
		var val = obj.value;
		var cnt = 0;

		menu_list_cate_all_open(); // 모든 카테고리 일단 open (이미지 컨트롤때문이라도 일단은 open)

		$('.menu_list_class').hide(0); // 모든 카테고리 close

		for (i=0; i<menu_list_arr.length; i++)
		{
			if (menu_list_arr[i].replace(/ /gi, "").indexOf(val.replace(/ /gi, "")) > -1) {
				$('#list_div_'+ i).show(0);
				$('.menu_list_class_'+ menu_list_class[i]).show(0); // 검색된 카테고리 open
				cnt++;
			} else {
				$('#list_div_'+ i).hide(0);
			}
		}

		if (menu_list_arr.length > cnt) { // 검색됨
			str = "";
			str += '<span style="display:block; text-align:center; padding:0px 0 15px 0;">"'+ cnt +'건이 검색되었습니다"</span>';
//			str += '<a href="javascript:void(0)" onclick="$(\'#list_src\').val(\'\'); list_search(); $(\'#list_src\').focus();" class="btn  btn-red btn_middle">다시검색</a>';
			str += '<a href="javascript:void(0)" onclick="menu_list_reset(2) " class="btn btn-black btn_middle" >전체보기</a>';

			$('#list_src_result').html(str).show(0);
			$('#re_text').show(0)
		} else { // input 빈값.
			$('#list_src_result').html('').hide(0);
			$('#re_text').hide(0)
		}
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


<style type="text/css">
.topFixBanner {position:relative; background:#ffffff; text-align:center; padding:20px 3% 10px 3%; width:100%}
.topFixBanner > div {position:relative;}
.topFixBanner > div > input {width:100%; border:1px solid #bebebe}
.topFixBannerFixed {position:fixed; top:55px; z-index:9999;}
span.re_text {position:absolute; font-size:1em; color:#777; font-weight:bold; right:15px; top:10px; display:none}
#list_src_result {display:none; padding-top:10px; width:100%; }

.menu_accordion_fix {padding-top:60px;}
.menu_accordion_fix_src {padding-top:160px;}
</style>


<div class="wrapper">
	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">
		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!--#include virtual="/includes/step.asp"-->

			<!--#include virtual="/includes/address.asp"-->

			<div class="topFixBanner">
				<div>
					<input type="text" name="list_src" id="list_src"  onkeyup="list_search()" placeholder="검색어를 입력해 주십시오">
					<span id="re_text" class="re_text" onclick="menu_list_reset(1)">X</span>
				</div>
				<span id="list_src_result"><span>
			</div>

			<!-- 메뉴 리스트 -->
			<div class="menu_accordion" >
			<!--<div class="menu_accordion" style="margin-top:60px;">-->
			<!-- <div class="menu_accordion" style="margin-top:170px;"> -->

				<%
					dim m_i : m_i = 0

					category_idx = GetReqStr("cidx",0)
'					request_cidx = GetReqStr("cidx",0)
'
'					if category_idx = 0 then 
'						menu_idx_arr = array("102", "5", "7", "6", "8")
'						menu_str_arr = array("핫황금올리브", "순수하게 후라이드", "다양하게 양념", "섞어먹자 반반", "구워먹는 비비큐")
'					else 
'						menu_idx_arr = array()
'						menu_str_arr = array()
'
'						if category_idx <> "99999" then 
'							menu_idx_arr = array(category_idx)
'							menu_str_arr = array("치킨")
'
'							if category_idx = "102" then menu_str_arr = array("핫황금올리브")
'							if category_idx = "5" then menu_str_arr = array("순수하게 후라이드")
'							if category_idx = "7" then menu_str_arr = array("다양하게 양념")
'							if category_idx = "6" then menu_str_arr = array("섞어먹자 반반")
'							if category_idx = "8" then menu_str_arr = array("구워먹는 비비큐")
'						end if 
'					end if 

					' 103은 인기메뉴의 번호고 그외의 번호는 카테고리 번호.
					menu_idx_arr = array("103", "102", "5", "7", "6", "8", "99999")
					menu_str_arr = array("인기메뉴", "핫황금올리브", "순수하게 후라이드", "다양하게 양념", "섞어먹자 반반", "구워먹는 비비큐", "사이드 메뉴")

					for m=0 to ubound(menu_idx_arr)
				%>
					<%
						category_idx = menu_idx_arr(m)

						anc_display = ""
						if anc <> "" then 
							if category_idx=anc then 
								anc_display = "Y"
							end if 
						else
							if m=0 then 
								anc_display = "Y"
							end if 
						end if 


						' If IsEmpty(category_idx) Or IsNull(category_idx) Or Trim(category_idx) = "" Or Not IsNumeric(category_idx) Then category_idx = 0

						PageTitle = "메뉴목록"

						Dim aCmd, aRs

						Set aCmd = Server.CreateObject("ADODB.Command")
						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_category_select_one"

							.Parameters.Append .CreateParameter("@brand_code", adVarChar, adParamInput, 10, "01")
							.Parameters.Append .CreateParameter("@category_idx", adInteger, adParamInput, , category_idx)

							Set aRs = .Execute
						End With
						Set aCmd = Nothing

						If Not (aRs.BOF Or aRs.EOF) Then
							PageTitle = aRs("category_name")
						End If
						Set aRs = Nothing
					%>

					<!-- 세계 치킨 시리즈-->
					<div id="anc_<%=category_idx%>"></div>
					<div class="menu_item menu_list_class menu_list_class_<%=category_idx%> <% if anc_display <> "Y" then %> open<% end if %>">
						<div class="heading" id="menu_list_cate_<%=m%>" onclick="menu_list_cate_control(<%=m%>); fnMove(<%=category_idx%>, <%=m%>)"><img src="/images/menu/menu_con0<%=m+1%>.png" alt="" class="menu_con" /><%=menu_str_arr(m)%></div>
						<div class="content" <% if anc_display <> "Y" then %>style="display:none"<% end if %>>

							<!-- menu-list -->
							<div class="menu-list">
								<%
									if category_idx = "103" then 

										Set aCmd = Server.CreateObject("ADODB.Command")

										With aCmd
											.ActiveConnection = dbconn
											.NamedParameters = True
											.CommandType = adCmdStoredProc
											.CommandText = "UP_MENU_LIST_GUBUN"

											.Parameters.Append .CreateParameter("@GUBUN", adInteger, adParamInput, , category_idx)

											Set aRs = .Execute
										End With

										Set aCmd = Nothing

									elseif category_idx = "99999" then 

										Set aCmd = Server.CreateObject("ADODB.Command")

										With aCmd
											.ActiveConnection = dbconn
											.NamedParameters = True
											.CommandType = adCmdStoredProc
											.CommandText = "bp_sidemenu_select"

											Set aRs = .Execute
										End With

										Set aCmd = Nothing

									else

										Set aCmd = Server.CreateObject("ADODB.Command")

										With aCmd
											.ActiveConnection = dbconn
											.NamedParameters = True
											.CommandType = adCmdStoredProc
											.CommandText = "bp_category_menu_list"

											.Parameters.Append .CreateParameter("@category_idx", adInteger, adParamInput, , category_idx)

											Set aRs = .Execute
										End With

										Set aCmd = Nothing

									end if 

									If Not (aRs.BOF Or aRs.EOF) Then
										aRs.MoveFirst

										Do Until aRs.EOF
								%>

								<div class="menuBox" id="list_div_<%=m_i%>" onclick="location.href='/menu/menuView.asp?midx=<%=aRs("menu_idx")%>'">
									<ul class="menuWrap">
										<li class="menuImg"><img src="<%=SERVER_IMGPATH%><%=aRs("thumb_file_path")&aRs("thumb_file_name")%>" alt=""></li>
										<li class="menuText">
											<h4><%=aRs("menu_name")%></h4>
											<em class="menu_point"><%=aRs("menu_title")%></em>
											<strong class="menu_pay"><%=FormatNumber(aRs("menu_price"),0)%>원</strong>
										</li>
									</ul>
								</div>

								<script type="text/javascript">
									menu_list_arr[<%=m_i%>] = "<%=aRs("menu_name")%>";
									menu_list_class[<%=m_i%>] = "<%=category_idx%>";
								</script>

								<%
											m_i = m_i + 1
											aRs.MoveNext
										Loop
									End If

									Set aRs = Nothing
								%>

							</div>
							<!-- menu-list -->

						</div>
					</div>
					<!-- // 세계 치킨 시리즈-->
				<%
					next 
				%>

				<div class="menuList_btn">
					<button type="button" class="btn btn_cart" onClick="javascript:location.href='/order/cart.asp';"><span class="ico-only">장바구니</span><span class="count" id="cart_item_count"></span></button>
					<a href="/order/cart.asp" class="btn  btn-red btn_middle">주문하기</a>
				</div>


			</div>
			<!-- //메뉴 리스트 -->


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->


<!-- 아코디언 -->
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script> 

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
			fnMove(<%=anc%>)
		})
	<% end if %>
</script>

<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-36251023-1']);
  _gaq.push(['_setDomainName', 'jqueryscript.net']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

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

		if ( $( document ).scrollTop() > 140 ) {   // 위치 및 사이즈를 파악하여 미리 정한 css class를 add 또는 remove 합니다.
			$( '.topFixBanner' ).addClass( 'topFixBannerFixed');
			$( '.menu_accordion' ).addClass( menu_accordion_fix_string);
		} else {
			$( '.topFixBanner' ).removeClass( 'topFixBannerFixed');
			$( '.menu_accordion' ).removeClass( menu_accordion_fix_string);
		}
	});
</script>
<!-- // 메뉴검색 -->