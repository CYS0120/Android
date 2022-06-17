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
		// ������
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
				<h2 class="h2_tit2">BBQ ������ ǥ����</h2>

				<!-- lp_thumb_body -->
				<div class="lp_thumb_body">

					<!-- tab_free_b -->
					<ul class="tab_free_b" id="topTab">
						<li class="active" data-tab="0"><a href="https://m.bbq.co.kr/menu/menu_base.asp#n">������ ����</a></li>
						<li><a href="https://m.bbq.co.kr/menu/menu_base.asp#n" data-tab="1">���缺�� ����</a></li>
						<li><a href="https://m.bbq.co.kr/menu/menu_base.asp#n" data-tab="2">�˷����� ���߹���</a></li>
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
											<th scope="col">�޴���</th>
											<th scope="col">������</th>
											<th scope="col">ǥ��ǰ��</th>
										</tr>
										</thead>
										<tbody>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ��</td>
											<td rowspan=57>������</td>
											<td rowspan=57>�߰��</td>
										</tr>
										<tr>
											<td class="th_bg">ũ��ġ ����ġŲ</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ���޺�</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ���޺� ��ũ������</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ���޺� ������</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ���޺� ��������</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ���޺� ũ��ġ ����</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ���޺� ���</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ���޺� �ݹ�</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ��ӾȽ�</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ������</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ�����</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ��ߴٸ�</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ��ݹ�</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø���ġŲ�ⷹ������</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø���ġŲ�������</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø���ġŲ��ũ������</td>
										</tr>
										<tr>
											<td class="th_bg">�Ĵ�'s ġŲ�θ���</td>
										</tr>
										<tr>
											<td class="th_bg">��������(��&��)</td>
										</tr>
										<tr>
											<td class="th_bg">���ѿհ���ġŲ</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ���� ��ǳġŲ</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ���� ��ǳ����</td>
										</tr>
										<tr>
											<td class="th_bg">�������� ���ġŲ</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ�������</td>
										</tr>
										<tr>
											<td class="th_bg">���̰�����</td>
										</tr>
										<tr>
											<td class="th_bg">���̰�����(��)</td>
										</tr>
										<tr>
											<td class="th_bg">�ڸ���ī ��ٸ�����</td>
										</tr>
										<tr>
											<td class="th_bg">����ũġŲ</td>
										</tr>
										<tr>
											<td class="th_bg">�Ŵޱ�</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ�����ݹ�</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ��ߴٸ��ݹ�</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø����ݹ�<br>(��������+������)</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø����ݹ�<br>(��������+ũ������)</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø����ݹ�<br>(������+ũ������)</td>
										</tr>
										<tr>
											<td class="th_bg">�������� �ݹ�<br>(Ȳ�ݿø����+ũ������)</td>
										</tr>
										<tr>
											<td class="th_bg">�������� �ݹ�<br>(Ȳ�ݿø����+��������)</td>
										</tr>
										<tr>
											<td class="th_bg">�������� �ݹ�<br>(Ȳ�ݿø����+������)</td>
										</tr>
										<tr>
											<td class="th_bg">�Ĵ�'sġŲ(�ͻ��)</td>
										</tr>
										<tr>
											<td class="th_bg">�Ĵ�'sġŲ(�ν�Ʈ ����)</td>
										</tr>
										<tr>
											<td class="th_bg">��������(��&��) �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ�� �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ��<br>���� �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ��<br>�ߴٸ� �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">�������� ���ġŲ �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�ݿø���ġŲ��<br>������ �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø���ġŲ��<br>������ �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø���ġŲ��<br>ũ������ �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">��Ȳ�ݿø���ġŲ��<br>�������� �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">�ڸ���ī ��ٸ����� �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">����ũġŲ �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ���� ��ǳġŲ �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ���� ��ǳ���� �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">ũ��ġ ����ġŲ �ݸ���</td>
										</tr>
										<tr>
											<td class="th_bg">��ġŲ����</td>
										</tr>
										<tr>
											<td class="th_bg">BBQ �߲�����</td>
										</tr>
										<tr>
											<td class="th_bg">ġ�� Ĩ��</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ���� �߹�Ƣ��</td>
										</tr>
										<tr>
											<td class="th_bg" rowspan=2>����ġŲ</td>
											<td>������</td>
											<td>�߰��</td>
										</tr>
										<tr>
											<td>�ܱ���</td>
											<td>�����������̽�(�������)</td>
										</tr>
										<tr>
											<td class="th_bg">Ȳ�� ũ��ġ �ʰ�(ũ��Ŀ)</td>
											<td>�������</td>
											<td>�߰��</td>
										</tr>
										<tr>
											<td class="th_bg">BBQ ġŲ���� ���ϵ�</td>
											<td rowspan=2>������(�߰��)</td>
											<td rowspan=2>��������Ƽ(ġŲ��Ƽ)</td>
										</tr>
										<tr>
											<td class="th_bg">BBQ ġŲ���� �����̽�</td>
										</tr>
										<tr>
											<td class="th_bg">���۷δ� ��ī������(����/���ַ�)</td>
											<td>������</td>
											<td>���۷δ�(�������)</td>
										</tr>
										<tr>
											<td class="th_bg" rowspan=4>�޺���̼�����</td>
											<td>ȣ�ֻ�(����)</td>
											<td rowspan=2>���۷δ��÷���<br>(����, �������)</td>
										</tr>
										<tr>
											<td>������(�������)</td>
										</tr>
										<tr>
											<td rowspan=2>�ܱ���� ������ ����</td>
											<td>��ũž��(�������)</td>
										</tr>
										<tr>
											<td>����ũ��(�������)</td>
										</tr>
										<tr>
											<td class="th_bg" rowspan=3>������������</td>
											<td>ȣ�ֻ�(����)</td>
                                            <td rowspan=2>���۷δ��÷���<br>(����, �������)</td>
										</tr>
										<tr>
											<td>������(�������)</td>
										</tr>
										<tr>
											<td>�ܱ���</td>
											<td>�����������̽�(�������)</td>
										</tr>
										<tr>
											<td class="th_bg">���Դ� ����Ʈ����</td>
											<td>�ܱ���</td>
											<td>������Ĩ(�������)</td>
										</tr>
										<tr>
											<td class="th_bg">���߱�ġ</td>
											<td>������</td>
											<td>����, ���尡��</td>
										</tr>
										<tr>
											<td class="th_bg">���ٸ�</td>
											<td>�߱���</td>
											<td>��¡��</td>
										</tr>
										<tr>
											<td class="th_bg">BBQ �Ҷ�</td>
											<td>������</td>
                                            <td>�ҽ���(�߰��, �������)</td>
										</tr>
										<tr>
											<td class="th_bg">��¡��Ƣ��</td>
											<td rowspan=2>�ܱ���</td>
											<td rowspan=2>��¡��</td>
										</tr>
										<tr>
											<td class="th_bg">������</td>
										</tr>
										<tr>
											<td class="th_bg">��(CJ����)</td>
											<td>�̱���</td>
                                            <td>��</td>
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
									<p>�� �ݸ����� �Ѹ��� ������ �����մϴ�.</p>
									<table>
										<caption>
											���缺�� ����
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
											<th scope="col">ī�װ���</th>
											<th scope="col">���ĸ�</th>
											<th scope="col">����<br><span style="font-size:13px;">(kcal/100g)</span></th>
											<th scope="col">���<br><span style="font-size:13px;">(g/100g)</span></th>
											<th scope="col">�ܹ���<br><span style="font-size:13px;">(g/100g)</span></th>
											<th scope="col">����<br><span style="font-size:13px;">(g/100g)</span></th>
											<th scope="col">��Ʈ��<br><span style="font-size:13px;">(mg/100g)</span></th>
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
												<td><%=replace(replace(MENU_NAME,"���̰�����","���̰�����(�Ѹ���/��)"),"(����)","(����/���ַ�)")%></td>
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
									<p>�� �ݸ����� �Ѹ��� ������ �����մϴ�.</p>
									<table>
										<caption>
											�˷����� ���߹���
										</caption>
										<colgroup>
											<col width="100">
											<col width="290">
											<col width="">
										</colgroup>
										<thead>
										<tr>
											<th scope="col">ī�װ���</th>
											<th scope="col">���ĸ�</th>
											<th scope="col">�˷��� ���߹���</th>
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
												<td><%=replace(replace(replace(MENU_NAME,"���̰�����","���̰�����(�Ѹ���/��)"),"(����)","(����/���ַ�)"),"�ݹ�(","�ݹ�<br>(")%></td>
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