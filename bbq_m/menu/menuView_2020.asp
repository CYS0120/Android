<!--#include virtual="/api/include/utf8.asp"-->

<% Call DBOpen %>
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="메뉴소개, BBQ치킨">
<meta name="Description" content="메뉴소개">
<title>메뉴소개 | BBQ치킨</title>

<script>
	var cartPage = "menu";

	$(function(){
		getView();
	});
</script>

</head>

<%
	Dim menu_idx : menu_idx = Request("midx")
	Dim opt_idx : opt_idx = Request("oidx")

	If IsEmpty(menu_idx) Or IsNull(menu_idx) Or Trim(menu_idx) = "" Or Not IsNumeric(menu_idx) Then menu_idx = 0
	If IsEmpty(opt_idx) Or IsNull(opt_idx) Or Trim(opt_idx) = "" Or Not IsNumeric(opt_idx) Then opt_idx = 0

	If menu_idx = 0 Then
%>

<script type="text/javascript">
	alert("메뉴가 없습니다.");
	location.href = "/main.asp";
</script>

<%
		Response.End
	End If

	Dim bCmd, bMenuRs

	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_menu_List"
		.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
		.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , menu_idx)
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, SITE_BRAND_CODE)
		Set bMenuRs = .Execute
	End With
	Set bCmd = Nothing			
	If bMenuRs.BOF Or bMenuRs.EOF Then
%>

<script type="text/javascript">
	showAlertMsg({msg:"존재하지 않는 메뉴입니다.", ok: function(){
		history.back();
	}});
</script>

<%
		Response.End
	End If 

	Dim vMenuIdx, vMenuTitle, vMenuName, vMenuNameE, vMenuPrice, vNutrient, vOrigin
	vMenuIdx	= bMenuRs("menu_idx")
	vMenuTitle	= bMenuRs("menu_title")
	vMenuName	= bMenuRs("menu_name")	'	메뉴명_국문
	vMenuPrice	= bMenuRs("menu_price")
	menu_desc	= bMenuRs("menu_desc")	'	메뉴설명
	kind_sel	= bMenuRs("kind_sel")	'	분류선택
	vOrigin		= bMenuRs("origin")	'	원산지
	vcalorie	= bMenuRs("calorie")	'	열량
	vsugars	= bMenuRs("sugars")	'	당류g
	vprotein	= bMenuRs("protein")	'	단백질
	vsaturatedfat	= bMenuRs("saturatedfat")	'	포화지방
	vnatrium	= bMenuRs("natrium")	'	나트륨
	allergy	= bMenuRs("allergy")	'	알레르기정보
	vexp1_yn	= bMenuRs("exp1_yn")	'	1차설명 사용여부
	vexp1_url	= bMenuRs("exp1_url")	'	YouTube Url
	vexp2_yn	= bMenuRs("exp2_yn")	'	2차설명 사용여부 Y,N
	vexp2_imgurl	= bMenuRs("exp2_imgurl")	'	배경이미지
	vexp3_yn	= bMenuRs("exp3_yn")	'	3차설명 사용여부 Y,N
	vexp3_imgurl	= bMenuRs("exp3_imgurl")	'	배경이미지
	vexp4_yn	= bMenuRs("exp4_yn")	'	4차설명 사용여부 Y,N
	vexp4_imgurl	= bMenuRs("exp4_imgurl")	'	배경이미지
	vexp5_yn	= bMenuRs("exp5_yn")	'	5차설명 사용여부 Y,N
	vexp5_imgurl	= bMenuRs("exp5_imgurl")	'	배경이미지
'	MAIN_FILEPATH	= bMenuRs("MAIN_FILEPATH")	'
'	MAIN_FILENAME	= bMenuRs("MAIN_FILENAME")	'
	vMainFilePath	= bMenuRs("THUMB_FILEPATH")	'
	vMainFileName	= bMenuRs("THUMB_FILENAME")	'
'	vMainFilePath	= bMenuRs("MOBILE_FILEPATH")	'
'	vMainFileName	= bMenuRs("MOBILE_FILENAME")	'

	Dim menuKey : menuKey = "M_"&vMenuIdx&"_"&opt_idx
	Dim menuItem : menuItem = "M$$"&vMenuIdx&"$$"&opt_idx&"$$"&vMenuPrice&"$$"&vMenuName&"$$"&SERVER_IMGPATH&vMainFilePath&vMainFileName
%>

<script type="text/javascript">var current_menu_key = "<%=menuKey%>";</script>

<body>

<div class="wrapper">

<%
	PageTitle = vMenuName
%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container menu_container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">

			<!-- 메뉴 보기 -->
			<div class="menu-viewTop">
				<div >
					<img src="<%=SERVER_IMGPATH%><%=vMainFilePath%><%=vMainFileName%>" alt="<%=vMenuName%>" style="width:62%;margin-bottom:20px;" ><!--background:url(/images/menu/@menuview_bg01.png)center center no-repeat;background-size:cover;-->
				</div>
				<div class="info">
					<h3><%=vMenuName%></h3>
					<dl class="nut">
						<dt>영양정보</dt>
						<dd>
							<ul>
								<li class="circle1">
									<span>
										<strong>열량</strong>
										<em>(kcal)</em>
									</span>
									<p><%=vcalorie%></p>
								</li>
								<li class="circle2">
									<span>
										<strong>당류</strong>
										<em>(g)</em>
									</span>
									<p><%=vsugars%></p>
								</li>
								<li class="circle3">
									<span>
										<strong>단백질</strong>
										<em>(g)</em>
									</span>
									<p><%=vprotein%></p>
								</li>
								<li class="circle4">
									<span>
										<strong>포화지방</strong>
										<em>(g)</em>
									</span>
									<p><%=vsaturatedfat%></p>
								</li>
								<li class="circle5">
									<span>
										<strong>나트륨</strong>
										<em>(mg)</em>
									</span>
									<p><%=vnatrium%></p>
								</li>
							</ul>
						</dd>
					</dl>
					<ul class="alert">
						<li>원산지 <%=vOrigin%></li>
						<li>100g 당 함량 기준으로 표기</li>
					</ul>
					<div class="caution">
						매장별로 가격이 상이 할 수 있습니다.<br/>
						매장방문 식사시 가격이 상이 할 수 있습니다.<br/>
						사진은 실제 상품과 다를 수 있습니다.
					</div>
                    <div class="allergy">
                    <p class="allergy_tit">알레르기 정보</p>
                    <p class="allergy_desc"><%=allergy%></p>
                    </div>	
				</div>
			</div>

<%		If vexp1_yn = "Y" Then %>
			<div class="menu-viewMov hide">
				<iframe src="https://www.youtube.com/embed/<%=vexp1_url%>?rel=0&amp;controls=0&amp;showinfo=0&amp;autoplay=0&amp;volumn=0&amp;mute=1"  title="BBQ CF" allowfullscreen></iframe>
			</div>
<%		End If %>

			<div class="menu-viewBot hide">

				<!--1번 사진 삽입-->
				<%		If vexp2_yn = "Y" Then %>
				<div class="box">
					<!--div class="box_content">
						<h2 class="tit"></h2>
						<p class="sub_tit"></p>
					</div-->
					<div class="cenimg"><img src="<%=SERVER_IMGPATH%>/explan/<%=vexp2_imgurl%>" alt=""></div>
				</div>

				<%		End If %>
				<!--//1번 사진 삽입-->

				<!--2번 사진 삽입-->
				<%		If vexp3_yn = "Y" Then %>
								<div class="box">
									<!--div class="box_content">
										<h2 class="tit"></h2>
										<p class="sub_tit"></p>
									</div-->
									<div class="cenimg"><img src="<%=SERVER_IMGPATH%>/explan/<%=vexp3_imgurl%>" alt=""></div>
								</div>
				<%		End If %>
				<!--//2번 사진 삽입-->

				<!--3번 사진 삽입-->
				<%		If vexp4_yn = "Y" Then %>
				<div class="box">
					<!--div class="box_content">
						<h2 class="tit"></h2>
						<p class="sub_tit"></p>
					</div-->
					<div class="cenimg"><img src="<%=SERVER_IMGPATH%>/explan/<%=vexp4_imgurl%>" alt=""></div>
				</div>	
				<%		End If %>
				<!--//3번 사진 삽입-->

				<!--4번 사진 삽입-->
				<%		If vexp5_yn = "Y" Then %>
				<div class="box">
					<!--div class="box_content">
						<h2 class="tit"></h2>
						<p class="sub_tit"></p>
					</div-->
					<div class="cenimg"><img src="<%=SERVER_IMGPATH%>/explan/<%=vexp5_imgurl%>" alt=""></div>
				</div>
				<%		End If %>
					<!--//4번 사진 삽입-->

			</div>
			<!-- //메뉴 보기 -->

			<!-- 메뉴 담기 -->
			<div class="menu-cart" style="display:bolok; border:solid 1px #ff0000">
				<div class="sideMenu">
					<%
						Set aCmd = Server.CreateObject("ADODB.Command")

						With aCmd
							.ActiveConnection = dbconn
							.NamedParameters = True
							.CommandType = adCmdStoredProc
							.CommandText = "bp_sidemenu_select"

							Set aRs = .Execute
						End With

						Set aCmd = Nothing

						Dim category_name : category_name = ""

						If Not (aRs.BOF Or aRs.EOF) Then
							aRs.MoveFirst
							Do Until aRs.EOF
								thumb_file_path = aRs("thumb_file_path")
								thumb_file_name = aRs("thumb_file_name")
								If aRs("category_name") <> category_name Then
									If category_name <> "" Then
					%>
				</div>
			</div>

			<%
			End If
			%>

			<div class="wrap">
				<h3><%=aRs("category_name")%></h3>
				<div class="area">

					<%
							category_name = aRs("category_name")
						End If
					%>

					<div class="box" id="S_<%=aRs("menu_idx")%>_0" onclick="javascript:toggleCartSide('<%=menuKey%>', 'S$$<%=aRs("menu_idx")%>$$0$$<%=aRs("menu_price")%>$$<%=aRs("menu_name")%>$$');">
						<div class="img">
							<label>
								<input type="checkbox">
								<img src="<%=SERVER_IMGPATH%><%=thumb_file_path%><%=thumb_file_name%>"/>
							</label>
						</div>
						<div class="info">
							<p class="name"><%=aRs("menu_name")%></p>
							<p class="pay"><%=FormatNumber(aRs("menu_price"),0)%>원</p>
						</div>
					</div>

					<%
								aRs.MoveNext
							Loop
					%>

					</div>
				</div>

				<%
					End If

					Set aRs = Nothing
				%>	

			</div>

			<div class="payment">
				<div class="addmenu">
				</div>
				<div class="calc">
					<div class="top">
						<dl>
							<dt>주문금액</dt>
							<dd id="item_amount">0원</dd>
						</dl>
						<dl>
							<dt>추가금액</dt>
							<dd id="side_amount">0원</dd>
						</dl>
					</div>
					<div class="bot">
						<dl>
							<dt>결제금액</dt>
							<dd id="pay_amount">0원</dd>
						</dl>
					</div>
				</div>
			</div>

			<button type="button" class="btn_menu_close" onClick="javascript:closeCart();">닫기</button>

		</div>
		<!-- //메뉴 담기 -->


		<!-- 장바구니 담기 -->
		<div class="cart-fix">
				<!--<button type="button" class="btn btn-md btn_other_menu" onClick="javascript:openCart();addCartMenu('<%=menuItem%>');">다른메뉴보기</button>-->
			<button type="button" class="btn btn-md btn-red btn_menu_cart" onClick="javascript:openCart();addCartMenu('<%=menuItem%>');">장바구니 담기</button>
		</div>
		<!-- //장바구니 담기 -->

	</article>
	<!--// Content -->

</div>
<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

<% Call DBClose %>





            <!-- Layer Popup : Allergy Secssion -->
            <div id="lp_allergy" class="lp-wrapper lp_allergy">
                <!-- LP Wrap -->
                <div class="lp-wrap">
                    <div class="lp-con">
                        <!-- LP Header -->
                        <div class="lp-header">
                            <h2>알레르기 유발재료</h2>
                        </div>
                        <!--// LP Header -->
                        <!-- LP Container -->
                        <div class="lp-container">
                            <!-- LP Content -->
                            <div class="lp-content">

                                <div class="inner">
                                    <div class="tit">
                                        <select name="" id="" class="w-100p">
                                            <option value="">BBQ치킨</option>
                                        </select>
                                    </div>
                                    
                                    <div class="box">
                                        <h3>Olive 오리지널</h3>
                                        <table class="__tbl-list">
                                            <caption>알레르기 유발재료</caption>
                                        <thead>
                                            <tr>
                                                <th scope="col">분류</th>
                                                <th scope="col">메뉴명</th>
                                                <th scope="col">알레르기 유발재료</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">극한왕갈비치킨</td>
                                                <td class="menu_material">대두, 밀, 조개류(굴), 아황산류</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">마라핫치킨(순살)</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">마라핫치킨(윙)</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">마라핫치킨(한마리)</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">구워먹는 비비큐</td>
                                                <td class="menu_name">매달구</td>
                                                <td class="menu_material">우유, 대두, 밀, 닭고기, 토마토, 쇠고기, 돼지고기, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">바삭칸치킨</td>
                                                <td class="menu_material">대두, 밀, 계란, 새우</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">빠리치킨(윙)</td>
                                                <td class="menu_material">우유, 대두, 밀</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">버라이어티한 비비큐</td>
                                                <td class="menu_name">빠리치킨(한마리)</td>
                                                <td class="menu_material">우유, 대두, 밀</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">소이갈릭스</td>
                                                <td class="menu_material">대두, 밀, 쇠고기</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">소이갈릭스(윙)</td>
                                                <td class="menu_material">대두, 밀, 쇠고기</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">순살바삭칸</td>
                                                <td class="menu_material">대두, 밀, 계란, 새우</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">순살치즐링</td>
                                                <td class="menu_material">우유, 대두, 밀, 계란, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">순살크래커</td>
                                                <td class="menu_material">우유, 대두, 밀, 닭고기, 조개류(굴)</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">구워먹는 비비큐</td>
                                                <td class="menu_name">스모크치킨</td>
                                                <td class="menu_material">대두, 밀, 계란, 닭고기</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념 </td>
                                                <td class="menu_name">시크릿양념치킨</td>
                                                <td class="menu_material">대두, 밀, 닭고기, 토마토, 땅콩, 아황산류</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">써프라이드</td>
                                                <td class="menu_material">우유, 대두, 밀, 계랸, 닭고기, 조개류(굴)</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">구워먹는 비비큐</td>
                                                <td class="menu_name">자메이카통다리구이</td>
                                                <td class="menu_material">대두, 밀, 닭고기, 토마토, 쇠고기</td>
                                            </tr>
                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">치즐링</td>
                                                <td class="menu_material">우유, 대두, 밀, 계란, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">치킨강정</td>
                                                <td class="menu_material">대두, 밀, 계란, 닭고기, 토마토, 새우, 땅콩, 아황산류</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">크림치즈볼</td>
                                                <td class="menu_material">밀, 대두, 우유</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">허니갈릭스</td>
                                                <td class="menu_material">대두, 밀, 쇠고기</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">허니갈릭스(윙)</td>
                                                <td class="menu_material">대두, 밀, 쇠고기</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">다양하게 양념</td>
                                                <td class="menu_name">허니버터갈릭치킨</td>
                                                <td class="menu_material">우유, 대두, 밀, 쇠고기</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브닭다리</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브닭다리(양념)</td>
                                                <td class="menu_material">대두, 밀, 닭고기, 토마토, 땅콩, 아황산류</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브속안심</td>
                                                <td class="menu_material">우유, 대두, 밀, 쇠고기, 새우, 땅콩</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브치킨</td>
                                                <td class="menu_material">우유, 대두, 밀, 조개류(굴), 쇠고기, 새우, 땅콩</td>
                                            </tr>
											                                            <tr>
                                                <td class="cate">순수하게 후라이드</td>
                                                <td class="menu_name">황금올리브핫윙</td>
                                                <td class="menu_material">우유, 대두, 밀, 계란, 새우, 땅콩</td>
                                            </tr>
                                        </tbody>
                                        </table>
                                    </div>
                                    
                                    <div class="box">
                                        <h3>Olive 오리지널</h3>
                                        <table class="__tbl-list">
                                            <caption>알레르기 유발재료</caption>
                                            <tbody>
                                                <tr>
                                                    <td class="menu_name">NEW치킨강정</td>
                                                    <td class="menu_material">땅콩, 닭고기, 대두, 밀</td>
                                                </tr>
                                                <tr>
                                                    <td class="menu_name">NEW치킨강정</td>
                                                    <td class="menu_material">땅콩, 닭고기, 대두, 밀</td>
                                                </tr>
                                                <tr>
                                                    <td class="menu_name">NEW치킨강정</td>
                                                    <td class="menu_material">땅콩, 닭고기, 대두, 밀</td>
                                                </tr>
                                                <tr>
                                                    <td class="menu_name">NEW치킨강정</td>
                                                    <td class="menu_material">땅콩, 닭고기, 대두, 밀</td>
                                                </tr>
                                                <tr>
                                                    <td class="menu_name">NEW치킨강정</td>
                                                    <td class="menu_material">땅콩, 닭고기, 대두, 밀</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                </div>
                            </div>
                            <!--// LP Content -->
                        </div>
                        <!--// LP Container -->
                        <button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
                    </div>
                </div>
                <!--// LP Wrap -->
            </div>
            <!--// Layer Popup -->
