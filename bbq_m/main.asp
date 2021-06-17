<!--#include virtual="/api/include/utf8.asp"-->
<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqiOS" )> 0 then
  Response.Cookies("bbq_app_type") = "bbqiOS"
  Response.Cookies("bbq_app_type").Expires = DateAdd("yyyy", 1, now())
  elseif instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then
  Response.Cookies("bbq_app_type") = "bbqAOS"
  Response.Cookies("bbq_app_type").Expires = DateAdd("yyyy", 1, now())
  end if

  if trim(Session("userId")) = "" or Request.Cookies("refresh_token") <> "" then
    access_token = Request.Cookies("access_token")
    access_token_secret = Request.Cookies("access_token_secret")
    refresh_token = Request.Cookies("refresh_token")
    token_type = Request.Cookies("token_type")
    expires_in = Request.Cookies("expires_in")
    auto_login_yn = Request.Cookies("auto_login_yn")

    multi_domail_login_url = "/api/loginToken.asp?access_token="& access_token &"&access_token_secret="& access_token_secret &"&refresh_token="& refresh_token &"&token_type="& token_type &"&expires_in="& expires_in &"&auto_login_yn="& auto_login_yn &"&domain="& domain &"&rtnUrl="& rtnUrl
    If Request.Cookies("loginCheck") = "" Then
        Response.Cookies("loginCheck") = "Y"
    Response.Redirect multi_domail_login_url
    End If
  end if
%>

<!doctype html>
<html lang="ko">
<head>

<!--Push Redirect-->
<!--#include virtual="/includes/push_redirect.asp"-->
<!--Push Redirect-->

<!--#include virtual="/includes/top.asp"-->

<meta name="Keywords" content="BBQ치킨">
<meta name="Description" content="BBQ치킨 메인">
<title>BBQ치킨</title>

 </head>

 <body>
	<div class="h-wrapper">
		<!-- Header -->
		<header class="h-header">
			<h1><a href="/">BBQ치킨</a></h1>
			<div class="h-btn-header-nav">
				<a href="#" onclick="javascript:return false;" class="btn_header_menu">메뉴</a>
			</div>
		</header>
		<!--// Header -->

		<!-- Container -->
		<div class="h-container">
			<!-- Aside -->
			<div id="aside_div"></div>
			<!--// Aside -->

			<!-- Content -->
			<article class="h-content">

				<!-- mainVisual -->
                <link href="/common/css/half-slider.css" rel="stylesheet">

                <div class="flexslider">
                	<ul class="slides spot_li">

                	<%
                		Set bCmd = Server.CreateObject("ADODB.Command")
                		With bCmd
                			.ActiveConnection = dbconn
                			.NamedParameters = True
                			.CommandType = adCmdStoredProc
                			.CommandText = "bp_main_banner_select_m"
                			.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
                			.Parameters.Append .CreateParameter("@MODE", adChar, adParamInput, 1, "W")
                			Set bRs = .Execute
                		End With
                		Set bCmd = Nothing
                		If Not (bRs.BOF Or bRs.EOF) Then
                			Do While Not bRs.EOF
                				MAIN_IMG	= bRs("MAIN_IMG")
                				MAIN_TEXT	= bRs("MAIN_TEXT")
								txtFromDate	= Cdate(left(bRs("date_s"),4) & "-" & mid(bRs("date_s"),5,2) & "-" & right(bRs("date_s"),2))
								txtToDate	= Cdate(left(bRs("date_e"),4) & "-" & mid(bRs("date_e"),5,2) & "-" & right(bRs("date_e"),2))
                				If txtFromDate <= date() AND txtToDate >= date() Then
                	%>
									<li><a href="<%=bRs("link_url")%>" style="background:url('<%=SERVER_IMGPATH%>/main/<%=MAIN_IMG%>') no-repeat center top; background-size:cover;"></a></li>
                	<% 
								End If
								bRs.MoveNext
                			Loop
                		End If 
                		bRs.close
                		Set bRs = Nothing
                	%>
<!-- 
                		<%
                			YY = Year(Now)
                			MM = Right("0"& Month(Now), 2)
                			DD = Right("0"& Day(Now), 2)
                			HH = Right("0"& Hour(Now), 2)
                			II = Right("0"& Minute(Now), 2)
                			SS = Right("0"& Second(Now), 2)

                			now_date_time = YY & MM & DD & HH & II& SS
                		%>
                		<li><a href="/menu/menuList.asp?anc=106" style="background:url('/images/main/201008.png') no-repeat center top; background-size:cover"></a></li>
                		<li><a href="/menu/menuList.asp?anc=106" style="background:url('/images/main/mainVisual_20200709.gif') no-repeat center top; background-size:cover">&nbsp;</a></li>
                		<% if now_date_time >= 20201002105000 And now_date_time <= 20201008235959 then %>
                			<li><a href="/event/eventView.asp?eidx=1283&event=OPEN&gotoPage=" style="background:url('/images/main/main_banner_20200929.png') no-repeat center top; background-size:cover"></a></li>
                		<% End If %>

                		<% if now_date_time >= 20200921000000 And now_date_time <= 20200921235959 then %>
                			<li><a href="/brand/eventList.asp" style="background:url('/images/main/main_banner_20200921.jpg') no-repeat center top; background-size:cover"></a></li>
                		<% End If %>
-->

                		<!--<li>
                			<% if Session("userIdNo") <> "" then %><a href="/menu/menuList.asp?anc=103" style="background:url('/images/main/mainVisual_20200709.gif') no-repeat center top; background-size:cover"></a>
                			<% else %><a href="javascript: void(0)" onclick="openJoin('mobile');"  style="background:url('/images/main/mainVisual_20200709.gif') no-repeat center top; background-size:cover">&nbsp;</a><% end if %>
                		</li> -->
                		<!-- 
                		<li>
                			<% if Session("userIdNo") <> "" then %><a href="/brand/eventView.asp?eidx=1169&event=OPEN" style="background:url('/images/main/mainVisual_20200709.gif') no-repeat center top; background-size:cover"></a>
                			<% else %><a href="javascript: void(0)" onclick="openJoin('mobile');"  style="background:url('/images/main/mainVisual_200713_1.jpg') no-repeat center top; background-size:cover">&nbsp;</a><% end if %>
                		</li>
                		<li style="background-image:url('/images/main/bbq_m_main_0507.jpg');"><% if Session("userIdNo") <> "" then %><a href="/menu/menuList.asp?anc=103" target="_self" style="display:block; width:100%; height:100%;">&nbsp;</a><% else %><a href="javascript: void(0)" onclick="openJoin('mobile');" target="_self" style="display:block; width:100%; height:100%;">&nbsp;</a><% end if %></li>
                		<li class="" style="background-image:url('/images/main/bbq_main_2020417_02.jpg');"></li> -->
                	</ul>
                </div>

                <script type="text/javascript" src="/common/js/jquery.flexslider.js"></script>
                <script type="text/javascript" src="/common/js/script.js"></script>
                <script type="text/javascript">
                	$(window).load(function () {
                		$('.flexslider').flexslider({
                		animation: "slide"
                	});
                });
                </script>			
                <!-- // mainVisual-->
				
				<!-- mainContent -->
				<div class="h-main_con">
					<!-- 실시간 인기 -->
					<ul class="h-main_con_popular">
						<li><span>실시간 인기</span></li>
						<li>

						<%
							Set aCmd = Server.CreateObject("ADODB.Command")
							With aCmd
								.ActiveConnection = dbconn
								.NamedParameters = True
								.CommandType = adCmdStoredProc
								.CommandText = "bt_main_hit_m_select"
								.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
								.Parameters.Append .CreateParameter("@top", adVarchar, adParamInput, 10, "10")
								Set bRs = .Execute
							End With
							Set aCmd = Nothing
						%>	

							<div id="h-main_con_popular_roll" class="h-main_con_popular_roll">	

										<%
											i=1
											If Not (bRs.BOF Or bRs.EOF) Then
												Do While Not bRs.eof 
													hit_title	= bRs("hit_title")
													hit_url	= bRs("hit_url")

													if trim(hit_url) <> "" then 
														hit_title = "<p><a href='"& hit_url &"'>"& i &". "& hit_title &"</a></p>"
													end if 
										%>
														<%=hit_title%>
										<%
													i=i+1
													bRs.MoveNext
												Loop
											End If 
											bRs.close
											Set bRs = Nothing
										%>	
							</div>
						</li>
					</ul>
					<!-- // 실시간 인기 -->
					<ul>
						<div class="main_point_set">
							<iframe width="100%" height="186" src="https://www.youtube.com/embed/NW-6kSg_UvM" frameborder="0" allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>
						</div>
					</ul>
					<!-- 메뉴 -->
					<ul class="h-main_order">
						<li><div class="h-main_order01"><a href="/order/delivery.asp?order_type=D">배달주문</a></div></li>
						<li><div class="h-main_order02"><a href="/order/delivery.asp?order_type=P">포장주문</a></div></li>
						<li><div class="h-main_order03"><a href="/coupon_use.asp">모바일 상품권주문</a></div></li>
						<!--<li><div class="h-main_order04"><a href="https://service.smartbag.kr:18060/81000/brand_giftshop/BRA200721108465763" target="_blank">선물하기</a></div></li>-->
						<li><div class="h-main_order04"><a href="https://service.smartbag.kr:18060/81000/brand_giftshop/BRA200721108465763" target="_blank">선물하기</a></div></li>
					</ul>
					<ul class="h-footer_line">
					</ul>
					<!-- // 메뉴 -->

					<!-- // 배너추가 -->
					<!-- <a href="/brand/eventView.asp?eidx=1435&event=OPEN" class="oneBanner"><img src="/images/main_new/tmp2_event.jpg" alt=""/></a> -->
					<!-- 배너추가// -->   

          <% 'If Session("userIdNo") <> "" Then %>
					<!-- 포인트 -->
          <%
            '// 회원정보 
            'If CheckLogin() Then 
                Set pMemberPoint = PointGetPointBalance("SAVE", "0") '// 포인트
                'Set pCouponList = CouponGetHoldList("NONE", "N", 100, 1) '// 쿠폰
            'End If
          %>	  
					<div class="h-main_point_set">
                    <%
                        If CheckLogin() Then
                    %>
						<div class="h-welcome">
                            <span class="h-main_name"><a href="/mypage/mypage.asp"><%=LoginUserName%></span>님 <br> 환영합니닭</a>
                        </div>
                    <%Else%>
                        <div class="h-welcome">
                            <span class="h-main_name"><a href="#" onclick="javascript:openLogin('mobile');return false;">로그인</a></span>이 <br> 필요합니닭
                        </div>
                    <%End If%>
						<div class="h-main_point">
							<dl>
								<dt><a href="/mypage/mileage.asp">포인트</a></dt>
								<dd><span><%=FormatNumber(pMemberPoint.mSavePoint,0)%></span>P&nbsp;&nbsp;</dd>
							</dl>	

							<%
								If CheckLogin() Then

									Dim aCmd, aRs

									Set aCmd = Server.CreateObject("ADODB.Command")

									With aCmd
										.ActiveConnection = dbconn
										.NamedParameters = True
										.CommandType = adCmdStoredProc
										.CommandText = "bt_member_coupon_select"
										.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 100, Session("userIdNo"))
										.Parameters.Append .CreateParameter("@mode", adVarChar, adParamInput, 20, "LIST")
										.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

										Set aRs = .Execute
										EcoupontotalCount = .Parameters("@totalCount").Value
									End With
									Set aCmd = Nothing 
							%>
							<dl>
								<dt><a href="/mypage/couponList.asp?couponList=coupon">모바일 상품권</a></dt>
								<dd><span><%=EcoupontotalCount%></span>개</dd>
							</dl>								
							<%Else%>
							<dl>
								<dt><a href="/mypage/couponList.asp?couponList=coupon">모바일 상품권</a></dt>
								<dd><span>0</span>개</dd>
							</dl>							
							<%
								Set aRs = Nothing
								End If
							%>	
							<dl>
								<dt><a href="/mypage/couponList.asp?couponList=giftcard">상품권</a></dt>
								<dd><span class="gc_red">0</span>개</dd>
							</dl>
						</div>
					</div>
					<div>&nbsp;</div>

					<!--<a href src="https://www.youtube.com/embed/uVN-x_lOvBA" target="_blank"><iframe id="idIframe" width="100%" height="315" src="https://www.youtube.com/embed/uVN-x_lOvBA" frameborder="0" onload="javascript:resetLink()"></iframe></a>
						실시간 이벤트에 참여하기 위해서 유튜브 영상 제목을 클릭하신 후 유튜브 채팅에 참여하세요!!-->					
					<!-- // 포인트 -->
          <%'End if%>

				</div>
				<!-- // mainContent -->
			</article> 
			<!-- // Content -->
		</div>
		<!-- // Container -->


		<%
			Dim bCmd, bPopRs

			Set bCmd = Server.CreateObject("ADODB.Command")
			With bCmd
				.ActiveConnection = dbconn
				.NamedParameters = True
				.CommandType = adCmdStoredProc
				.CommandText = "bp_popup"
				.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
				.Parameters.Append .CreateParameter("@POPUP_KIND", adChar, adParamInput, 1, "L")
				Set bPopRs = .Execute
			End With
			Set bCmd = Nothing			
			If bPopRs.BOF Or bPopRs.EOF Then
			Else
				popup_idx	= bPopRs("popup_idx")
				brand_code	= bPopRs("brand_code")
				popup_width	= bPopRs("popup_width")
				popup_height	= bPopRs("popup_height")
				popup_close	= bPopRs("popup_close")
				popup_title	= bPopRs("popup_title")
				popup_img	= bPopRs("popup_img")

				popup_img = FILE_SERVERURL & "/uploads/popup/" & popup_img

				CookName	= "popup_" & popup_idx
				If Request.Cookies(CookName) = "done" Then 
				Else
		%>

		<!--윈도우 로드시 팝업-->
		<aside class="popup">
			<div class="inner" id="pop1">
				<div class="area" style="width:<%=popup_width%>px;">
					<img src="<%=popup_img%>" alt="POPUP">
				</div>
				<%If popup_close = "1" Then%>
				<button type="button" class="today" onClick="PopupNoDispaly()">하루동안 보지않기 <i class="axi axi-close"></i></button>
				<%End If%>
				<button type="button" class="close _close" onClick="$('.popup').hide();">[닫기]</button>
			</div>
			<div class="popupbg"></div>
		</aside>
		<!--//윈도우 로드시 팝업-->

		<script>
			$(document).ready(function () {
				$('.popup').show();
			});
			function PopupNoDispaly() {
				setCookie("popup_<%=popup_idx%>", "done", 1);
				$('.popup').hide();
			}
		</script>

		<%
			End If 
		End If

		Set bCmd = Server.CreateObject("ADODB.Command")
		With bCmd
			.ActiveConnection = dbconn
			.NamedParameters = True
			.CommandType = adCmdStoredProc
			.CommandText = "bp_popup"
			.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
			.Parameters.Append .CreateParameter("@POPUP_KIND", adChar, adParamInput, 1, "N")
			Set bPopRs = .Execute
		End With
		Set bCmd = Nothing			
		If bPopRs.BOF Or bPopRs.EOF Then
		Else
			Do While Not bPopRs.EOF
				popup_idx	= bPopRs("popup_idx")
				popup_left	= bPopRs("popup_left")
				popup_top	= bPopRs("popup_top")
				popup_width	= bPopRs("popup_width")
				popup_height	= bPopRs("popup_height")

				CookName	= "popup_" & popup_idx
				If Request.Cookies(CookName) = "done" Then 
				Else
		%>

		<script Language="JavaScript">	
			window.open('/api/popup.asp?PIDX=<%=popup_idx%>','popup_<%=popup_idx%>','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,status=no, left=<%=popup_left%>,top=<%=popup_top%>, width=<%=popup_width%>,height=<%=popup_height+25%>');
		</script>

		<%
					End If 
					bPopRs.MoveNext
				Loop 
			End If 
		%>

		<script>
			function setCookie(name, value, expiredays) {
				var todayDate = new Date();
				todayDate.setDate(todayDate.getDate() + expiredays);
				document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
			}
		</script>


        <!--#include virtual="/includes/app_push.asp"-->
	    <!-- Footer -->
        <!--#include virtual="/includes/footer_new.asp"-->
        <!--// Footer -->
	</div>
 </body>
</html>
<!--#include virtual="/api/ta/ta_footer.asp"-->
	<%
		Call DBClose
	%>

<script>
$(document).ready(function (){
   $.ajax({
         method: "post",
         url: "/api/ajax/ajax_getGiftCard.asp",
         data: {
             callMode: "listCount",
         },
         dataType: "json",
         success: function(res) {
           if (res.result == 0) {
             $(".gc_red").html(res.Count);               
           }
         }
     });
})
  // 상품권 
  
  // 실시간 인기 롤링 
  function tick(){
		$('#h-main_con_popular_roll p:first').slideUp( function () { $(this).appendTo($('#h-main_con_popular_roll')).slideDown(); });
	}
	setInterval(function(){ tick () }, 4000);
  // 실시간 인기 롤링 

function resetLink(){
  $('#idIframe').contents().find('a').each(function(){
    var $o = $(this);
    var s = $o.attr('target');
    if(s=='') $o.attr('target','_blank');
  });
}

</script>

