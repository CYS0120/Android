<html lang="ko">
<head>
	<link rel="stylesheet" href="/common/css/menu_base.css?v=" type="text/css">
	<script src="/common/js/libs/jquery-1.12.4.min.js"></script>
	<script src="/common/js/libs/jquery-ui-1.12.1.js"></script>
	<script src="/common/js/libs/jquery.colorbox.js"></script>
	<style>
		.lp_container a.btn_lp_close2 {display: none;}
		body.wh_sub_body {background: none;}
	</style>
</head>

<!--#include virtual="/api/include/db_open.asp"-->
<body class="wh_sub_body">
<script>
var tab_free3_b2_wrap;
	$(function(){
		// 원산지
		if ($(".tab_free3_b2_wrap").length > 0) {
			tab_free3_b2_wrap = $(".tab_free3_b2_wrap > div").bxSlider({
				speed: 1000,
				pause: 5000,
				controls: false,
				pager: true,
				onSliderLoad: function (idx) {
				}
			});
		};
		$(".tab_free_b > li").each(function(index) {
			$(this).click(function (e) {
				e.preventDefault();
				$(".tab_free_b > li").removeClass("active");
				$(this).addClass("active");
				$(".all_tab > div").hide();
				$(".all_tab > div:eq(" + index + ")").show();
				$.colorbox.resize();
			});
		});
		$(".all_tab1 .tab_free3_b > li").each(function(index) {
			$(this).click(function (e) {
				e.preventDefault();
				$(this).parent().find("li").removeClass("active");
				$(this).addClass("active");
				$(this).parent().parent().find(".allergy_pop_wrap div").hide();
				$(this).parent().parent().find(".allergy_pop_wrap div:eq("+index+")").show();
				$.colorbox.resize();
			});
		});
		$(".all_tab2 .tab_free3_b > li").each(function(index) {
			$(this).click(function (e) {
				e.preventDefault();
				$(this).parent().find("li").removeClass("active");
				$(this).addClass("active");
				$(this).parent().parent().find(".allergy_pop_wrap div").hide();
				$(this).parent().parent().find(".allergy_pop_wrap div:eq("+index+")").show();
				$.colorbox.resize();
			});
		});
		$(".all_tab1").on("click", ".tab_free3_b_mob li", function(e) {
			e.preventDefault();
			$(".all_tab1").find(".tab_free3_b li").removeClass("active");
			$(".all_tab1").find(".tab_free3_b2_list div ul li").removeClass("active");
			$(".all_tab1").find(".tab_free3_b"+($(this).data("idx")+1)).addClass("active");
			$(".all_tab1").find(".allergy_pop_wrap div").hide();
			$(".all_tab1").find(".allergy_pop_wrap div:eq("+$(this).data("idx")+")").show();
			$.colorbox.resize();
		});
	});
</script>
<!-- LP_pw -->
<div id="LP_pw" class="lp_wrap lp_pw w big lp_allergy" data-width="900">

	<!-- lp_container -->
	<div class="lp_container">

		<!-- lp_body -->
		<div class="lp_body">

			<!-- lp_pw_wrap -->
			<div class="lp_pw_wrap">
				<h2 class="h2_tit2">BBQ 원산지 표시판</h2>

				<!-- lp_thumb_body -->
				<div class="lp_thumb_body">

					<!-- tab_free_b -->
					<ul class="tab_free_b" id="topTab">
						<li class="active" data-tab="0"><a href="https://m.bbq.co.kr/menu/menu_base.asp#n">원산지 정보</a></li>
						<li><a href="https://m.bbq.co.kr/menu/menu_base.asp#n" data-tab="1">영양성분 정보</a></li>
						<li><a href="https://m.bbq.co.kr/menu/menu_base.asp#n" data-tab="2">알레르기 유발물질</a></li>
					</ul>
					<!-- // tab_free_b -->

					<!-- all_tab -->
					<div class="all_tab" style="margin-top:20px">

						<!-- all_tab1 -->
						<div class="all_tab1">

							<!-- allergy_pop_wrap -->
							<div class="allergy_pop_wrap">
								<div class="allergy_pop">
									<table>
										<colgroup>
											<col width="40%">
											<col width="30%">
											<col width="30%">
										</colgroup>
										<thead>
										<tr>
											<th scope="col">메뉴명</th>
											<th scope="col">원산지</th>
											<th scope="col">표시품목</th>
										</tr>
										</thead>
										<tbody>
										<tr>
											<td class="th_bg">황금올리브치킨™</td>
											<td rowspan=57>국내산</td>
											<td rowspan=57>닭고기</td>
										</tr>
										<tr>
											<td class="th_bg">크런치 버터치킨</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™콤보</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™콤보 핫크리스피</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™콤보 블랙페퍼</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™콤보 레드착착</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™콤보 크런치 버터</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™콤보 양념</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™콤보 반반</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™속안심</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™핫윙</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™순살</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™닭다리</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™반반</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브치킨™레드착착</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브치킨™블랙페퍼</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브치킨™크리스피</td>
										</tr>
										<tr>
											<td class="th_bg">파더's 치킨두마리</td>
										</tr>
										<tr>
											<td class="th_bg">눈맞은닭(윙&봉)</td>
										</tr>
										<tr>
											<td class="th_bg">극한왕갈비치킨</td>
										</tr>
										<tr>
											<td class="th_bg">황올한 깐풍치킨</td>
										</tr>
										<tr>
											<td class="th_bg">황올한 깐풍순살</td>
										</tr>
										<tr>
											<td class="th_bg">오리지날 양념치킨</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™순살양념</td>
										</tr>
										<tr>
											<td class="th_bg">소이갈릭스</td>
										</tr>
										<tr>
											<td class="th_bg">소이갈릭스(윙)</td>
										</tr>
										<tr>
											<td class="th_bg">자메이카 통다리구이</td>
										</tr>
										<tr>
											<td class="th_bg">스모크치킨</td>
										</tr>
										<tr>
											<td class="th_bg">매달구</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™순살반반</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™닭다리반반</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브™반반<br>(레드착착+블랙페퍼)</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브™반반<br>(레드착착+크리스피)</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브™반반<br>(블랙페퍼+크리스피)</td>
										</tr>
										<tr>
											<td class="th_bg">오리지널 반반<br>(황금올리브™+크리스피)</td>
										</tr>
										<tr>
											<td class="th_bg">오리지널 반반<br>(황금올리브™+레드착착)</td>
										</tr>
										<tr>
											<td class="th_bg">오리지널 반반<br>(황금올리브™+블랙페퍼)</td>
										</tr>
										<tr>
											<td class="th_bg">파더's치킨(와사비)</td>
										</tr>
										<tr>
											<td class="th_bg">파더's치킨(로스트 갈릭)</td>
										</tr>
										<tr>
											<td class="th_bg">눈맞은닭(윙&봉) 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™ 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™<br>순살 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™<br>닭다리 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">오리지날 양념치킨 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">황금올리브치킨™<br>순살양념 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브치킨™<br>블랙페퍼 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브치킨™<br>크리스피 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">핫황금올리브치킨™<br>레드착착 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">자메이카 통다리구이 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">스모크치킨 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">황올한 깐풍치킨 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">황올한 깐풍순살 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">크런치 버터치킨 반마리</td>
										</tr>
										<tr>
											<td class="th_bg">핫치킨피자</td>
										</tr>
										<tr>
											<td class="th_bg">BBQ 닭껍데기</td>
										</tr>
										<tr>
											<td class="th_bg">치즐링 칩스</td>
										</tr>
										<tr>
											<td class="th_bg">황올한 닭발튀김</td>
										</tr>
										<tr>
											<td class="th_bg" rowspan=2>로제치킨</td>
											<td>국내산</td>
											<td>닭고기</td>
										</tr>
										<tr>
											<td>외국산</td>
											<td>베이컨슬라이스(돼지고기)</td>
										</tr>
										<tr>
											<td class="th_bg">황올 크런치 너겟(크래커)</td>
											<td>브라질산</td>
											<td>닭고기</td>
										</tr>
										<tr>
											<td class="th_bg">BBQ 치킨버거 마일드</td>
											<td rowspan=2>국내산(닭고기)</td>
											<td rowspan=2>충진식패티(치킨패티)</td>
										</tr>
										<tr>
											<td class="th_bg">BBQ 치킨버거 스파이시</td>
										</tr>
										<tr>
											<td class="th_bg">페퍼로니 시카고피자(라지/레귤러)</td>
											<td>국내산</td>
											<td>페퍼로니(돼지고기)</td>
										</tr>
										<tr>
											<td class="th_bg" rowspan=4>콤비네이션피자</td>
											<td>호주산(쇠고기)</td>
											<td rowspan=2>페퍼로니플러스<br>(쇠고기, 돼지고기)</td>
										</tr>
										<tr>
											<td>국내산(돼지고기)</td>
										</tr>
										<tr>
											<td rowspan=2>외국산과 국내산 섞음</td>
											<td>포크탑핑(돼지고기)</td>
										</tr>
										<tr>
											<td>스모크햄(돼지고기)</td>
										</tr>
										<tr>
											<td class="th_bg" rowspan=3>고구마퐁듀피자</td>
											<td>호주산(쇠고기)</td>
                                            <td rowspan=2>페퍼로니플러스<br>(쇠고기, 돼지고기)</td>
										</tr>
										<tr>
											<td>국내산(돼지고기)</td>
										</tr>
										<tr>
											<td>외국산</td>
											<td>베이컨슬라이스(돼지고기)</td>
										</tr>
										<tr>
											<td class="th_bg">떠먹는 스위트감자</td>
											<td>외국산</td>
											<td>베이컨칩(돼지고기)</td>
										</tr>
										<tr>
											<td class="th_bg">배추김치</td>
											<td>국내산</td>
											<td>배추, 고춧가루</td>
										</tr>
										<tr>
											<td class="th_bg">오다리</td>
											<td>중국산</td>
											<td>오징어</td>
										</tr>
										<tr>
											<td class="th_bg">BBQ 소떡</td>
											<td>국내산</td>
                                            <td>소시지(닭고기, 돼지고기)</td>
										</tr>
										<tr>
											<td class="th_bg">오징어튀김</td>
											<td rowspan=2>외국산</td>
											<td rowspan=2>오징어</td>
										</tr>
										<tr>
											<td class="th_bg">오감볼</td>
										</tr>
										<tr>
											<td class="th_bg">밥(CJ따밥)</td>
											<td>미국산</td>
                                            <td>쌀</td>
										</tr>
										</tbody>
									</table>
								</div>
							</div>
							<!-- // allergy_pop_wrap -->

						</div>
						<!-- // all_tab1 -->

						<!-- all_tab2 -->
						<div class="all_tab2">

							<!-- allergy_pop_wrap -->
							<div class="allergy_pop_wrap">
								<div class="allergy_pop">
									<p>※ 반마리는 한마리 정보와 동일합니다.</p>
									<table>
										<caption>
											영양성분 정보
										</caption>
										<colgroup>
											<col width="100">
											<col width="">
											<col width="80">
											<col width="80">
											<col width="80">
											<col width="80">
											<col width="85">
										</colgroup>
										<thead>
										<tr>
											<th scope="col">카테고리명</th>
											<th scope="col">음식명</th>
											<th scope="col">열량<br><span style="font-size:13px;">(kcal/100g)</span></th>
											<th scope="col">당류<br><span style="font-size:13px;">(g/100g)</span></th>
											<th scope="col">단백질<br><span style="font-size:13px;">(g/100g)</span></th>
											<th scope="col">지방<br><span style="font-size:13px;">(g/100g)</span></th>
											<th scope="col">나트륨<br><span style="font-size:13px;">(mg/100g)</span></th>
										</tr>
										</thead>
										<tbody>
<%	
			Set aCmd = Server.CreateObject("ADODB.Command")

			With aCmd
				.ActiveConnection = dbconn
				.CommandType = adCmdStoredProc
				.CommandText = "bp_menu_base_select"

				Set aRs = .Execute
			End With

			Set aCmd = Nothing

			If Not (aRs.BOF Or aRs.EOF) Then
				aRs.MoveFirst

				Do Until aRs.EOF
					CAT_NAME = aRs("CAT_NAME")
					MENU_NAME = aRs("MENU_NAME")
					CALORIE = aRs("CALORIE")
					SUGARS = aRs("SUGARS")
					PROTEIN = aRs("PROTEIN")
					SATURATEDFAT = aRs("SATURATEDFAT")
					NATRIUM = aRs("NATRIUM")
%>
											<tr>
												<td class="th_bg"><%=CAT_NAME%></td>
												<td><%=replace(replace(MENU_NAME,"소이갈릭스","소이갈릭스(한마리/윙)"),"(라지)","(라지/레귤러)")%></td>
												<td><%=CALORIE%></td>
												<td><%=SUGARS%></td>
												<td><%=PROTEIN%></td>
												<td><%=SATURATEDFAT%></td>
												<td><%=NATRIUM%></td>
											</tr>
<%
					aRs.MoveNext
				Loop
			End If

			Set aRs = Nothing
%>
										</tbody>						
										
									</table>
								</div>
								
							</div>
							<!-- // allergy_pop_wrap -->

						</div>
						<!-- // all_tab2 -->

						<!-- all_tab3 -->
						<div class="all_tab3">

							<!-- allergy_pop_wrap -->
							<div class="allergy_pop_wrap">
								<div class="allergy_pop">
									<p>※ 반마리는 한마리 정보와 동일합니다.</p>
									<table>
										<caption>
											알레르기 유발물질
										</caption>
										<colgroup>
											<col width="100">
											<col width="290">
											<col width="">
										</colgroup>
										<thead>
										<tr>
											<th scope="col">카테고리명</th>
											<th scope="col">음식명</th>
											<th scope="col">알러지 유발물질</th>
										</tr>
										</thead>
										<tbody>
<%
			Set aCmd = Server.CreateObject("ADODB.Command")

			With aCmd
				.ActiveConnection = dbconn
				.CommandType = adCmdStoredProc
				.CommandText = "bp_menu_base_select"

				Set aRs = .Execute
			End With

			Set aCmd = Nothing

			If Not (aRs.BOF Or aRs.EOF) Then
				aRs.MoveFirst

				Do Until aRs.EOF
					CAT_NAME = aRs("CAT_NAME")
					MENU_NAME = aRs("MENU_NAME")
					ALLERGY = aRs("ALLERGY")
%>
											<tr>
												<td class="th_bg"><%=CAT_NAME%></td>
												<td><%=replace(replace(replace(MENU_NAME,"소이갈릭스","소이갈릭스(한마리/윙)"),"(라지)","(라지/레귤러)"),"반반(","반반<br>(")%></td>
												<td><%=ALLERGY%></td>
											</tr>
<%
					aRs.MoveNext
				Loop
			End If

			Set aRs = Nothing
%>
										</tbody>						
										
									</table>
								</div>
								
							</div>
							<!-- // allergy_pop_wrap -->

						</div>
						<!-- // all_tab3 -->

					</div>
					<!-- // all_tab -->

				</div>
				<!-- // lp_thumb_body -->

			</div>
			<!-- // lp_pw_wrap -->

		</div>
		<!-- // lp_body -->

	<!-- // lp_container -->

</div>
<!-- // LP_pw -->
<div id="cboxOverlay" style="display: none;"></div><div id="colorbox" class="" role="dialog" tabindex="-1" style="display: none;"><div id="cboxWrapper"><div><div id="cboxTopLeft" style="float: left;"></div><div id="cboxTopCenter" style="float: left;"></div><div id="cboxTopRight" style="float: left;"></div></div><div style="clear: left;"><div id="cboxMiddleLeft" style="float: left;"></div><div id="cboxContent" style="float: left;"><div id="cboxTitle" style="float: left;"></div><div id="cboxCurrent" style="float: left;"></div><button type="button" id="cboxPrevious"></button><button type="button" id="cboxNext"></button><button id="cboxSlideshow"></button><div id="cboxLoadingOverlay" style="float: left;"></div><div id="cboxLoadingGraphic" style="float: left;"></div></div><div id="cboxMiddleRight" style="float: left;"></div></div><div style="clear: left;"><div id="cboxBottomLeft" style="float: left;"></div><div id="cboxBottomCenter" style="float: left;"></div><div id="cboxBottomRight" style="float: left;"></div></div></div><div style="position: absolute; width: 9999px; visibility: hidden; display: none; max-width: none;"></div></div><div id="cboxOverlay" style="display: none;"></div><div id="colorbox" class="" role="dialog" tabindex="-1" style="display: none;"><div id="cboxWrapper"><div><div id="cboxTopLeft" style="float: left;"></div><div id="cboxTopCenter" style="float: left;"></div><div id="cboxTopRight" style="float: left;"></div></div><div style="clear: left;"><div id="cboxMiddleLeft" style="float: left;"></div><div id="cboxContent" style="float: left;"><div id="cboxTitle" style="float: left;"></div><div id="cboxCurrent" style="float: left;"></div><button type="button" id="cboxPrevious"></button><button type="button" id="cboxNext"></button><button id="cboxSlideshow"></button><div id="cboxLoadingOverlay" style="float: left;"></div><div id="cboxLoadingGraphic" style="float: left;"></div></div><div id="cboxMiddleRight" style="float: left;"></div></div><div style="clear: left;"><div id="cboxBottomLeft" style="float: left;"></div><div id="cboxBottomCenter" style="float: left;"></div><div id="cboxBottomRight" style="float: left;"></div></div></div><div style="position: absolute; width: 9999px; visibility: hidden; display: none; max-width: none;"></div></div></body></html>