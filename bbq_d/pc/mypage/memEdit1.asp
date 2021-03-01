<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->
<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="회원정보변경, BBQ치킨">
<meta name="Description" content="회원정보변경">
<title>회원정보변경 | BBQ치킨</title>
<%
    Set api = New ApiCall

    api.SetMethod = "POST"
    api.RequestContentType = "application/json"
    api.Authorization = "Bearer " & Session("access_token")
    api.SetData = "{""scope"":""ADMIN""}"
    api.SetUrl = PAYCO_AUTH_URL & "/api/member/me"

    result = api.Run

    Set api = Nothing

    Set mJ = JSON.Parse(result)

    ' useInfo = "{}"


    If JSON.hasKey(mJ, "header") Then
    	If JSON.hasKey(mJ.header, "resultCode") Then
    		If mJ.header.resultCode = 0 Then
    			emailAgree = mJ.data.member.isAllowedEmailPromotion
    			smsAgree = mJ.data.member.isAllowedSmsPromotion
    			email = Split(mJ.data.member.email,"@")

    			If UBound(email) = 1 Then
    				email1 = email(0)
    				email2 = email(1)
    			Else
    				email1 = ""
    				email2 = ""
    			End If
    			' userInfo = JSON.stringify(mJ.data.member)
    		End If
    	End If
    End If
%>
<script>
jQuery(document).ready(function(e) {
	$(document).on('click','.phone-change-on',function(){
		var par = $(this).closest('.phone-change-wrap');
		par.addClass('on');
	});
	$(document).on('click','.phone-change-off',function(){
		var par = $(this).closest('.phone-change-wrap');
		par.removeClass('on');
	});
});

function setPcMainAddress() {
	
	if(!$('input:radio[name=r_idx]').is(':checked')) {
		alert('기본 배달지를 선택해 주세요.');
		return false;
	}
	var st = $("input:radio[name=r_idx]:checked").val();
	
    if(window.confirm("기본 배달지로 설정하시겠습니까?")) {
        $.ajax({
            method: "post",
            url: "/api/ajax/ajax_setMainAddress.asp",
            data: {addr_idx: st},
            success: function(data) {
                var result = JSON.parse(data);

                if(result.result == 0) {
                	location.reload();
                } else {
                    alert(result.message);
                }
            }
        });
    }
}

function checkAgree(obj) {
	switch($(obj).val()) {
		case "A":
		$("#sAgreeE").prop("checked", $("#sAgreeA").is(":checked"));
		$("#sAgreeM").prop("checked", $("#sAgreeA").is(":checked"));
		break;
		case "E":
		case "M":
		$("#sAgreeA").prop("checked", $("#sAgreeE").is(":checked") && $("#sAgreeM").is(":checked"));
		break;
	}
}


	function saveInfo() {
		var data = {};
		data.email = $.trim($("#sEmail1").val())+"@"+$.trim($("#sEmail2").val());
		data.agreeE = $("#sAgreeE").is(":checked")? "Y": "";
		data.agreeM = $("#sAgreeM").is(":checked")? "Y": "";
		$.ajax({
			method: "post",
			url: "/api/changeUserInfo.asp",
			data: data,
			dataType: "json",
			success: function(res) {
				alert(res.message);
			}
		})
	}

	function changeInfo(info) {
		$.ajax({
			method: "post",
			url: "/api/issueTicket.asp",
			data: {info: info},
			dataType: "json",
			success: function(res) {
				if(res.header.resultCode == 0) {
					var url = "";
					switch(info) {
						case "pwd":
						url = "/change-password"
						break;
						case "mobile":
						url = "/change-cellphone-number";
						break;
					}
					location.href = "<%=PAYCO_AUTH_URL%>"+url+"?ticket="+res.data.ticket+"&appYn=N&logoYn=N&titleYn=N";
				}
			}
		});
	}
</script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
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
			}).open();
		});
	}
</script>
</head>

<body>	
<div class="wrapper">
	<!-- Header -->
	<!--#include virtual="/includes/header.asp"-->
	<!--// Header -->
	<hr>
	
	<!-- Container -->
	<div class="container">
		<!-- BreadCrumb -->
		<div class="breadcrumb-wrap">
			<ul class="breadcrumb">
				<li><a href="/">bbq home</a></li>
				<li><a href="#">마이페이지</a></li>
				<li>회원정보 변경</li>
			</ul>
		</div>
		<!--// BreadCrumb -->
		
		<!-- Content -->
		<article class="content">
			<!-- Membership -->
			<section class="section section_membership">
				<!-- My Info -->
				<!--#include virtual="/includes/mypage.inc.asp"-->
				<!--// My Info -->
				<!-- My Menu -->
				<!--#include virtual="/includes/mypagemenu.inc.asp"-->
				<!--// My Menu -->
			</section>
			<!--// Membership -->

			<!-- My Member Modify -->
			<section class="section section_member">
				<div class="section-header">
					<h3>회원정보변경</h3>
				</div>
				<div class="section-body top-line">
					<form name="memForm" id="memForm" method="post" onsubmit="return false;">
						<div class="section-item">
							<h4>기본정보</h4>
							<div class="boardList-wrap">
								<table border="1" cellspacing="0" class="tbl-member">
									<caption>기본정보</caption>
									<colgroup>
										<col style="width:283px;">
										<col style="width:auto;">
									</colgroup>
									<tbody>
										<tr class="bg-gray">
											<th>이름</th>
											<td><%=Session("userName")%></td>
										</tr>
										<tr class="bg-gray">
											<th>생년월일</th>
											<td><%=Session("userBirth")%></td>
										</tr>
										<tr class="bg-gray line">
											<th>아이디</th>
											<td><%=Session("userId")%></td>
										</tr>
										<tr>
											<th><label for="sPwd1">비밀번호</label></th>
											<td><input type="password" name="sPwd1" id="sPwd1" maxlength="20" placeholder="영문, 숫자, 특수문자를 조합하여 10자 이상 가능" class="w-40p"></td>
										</tr>
										<tr>
											<th><label for="sPwd2">비밀번호 확인</label></th>
											<td><input type="password" name="sPwd2" id="sPwd2" maxlength="20" placeholder="비밀번호 재입력" class="w-40p"><!-- <span class="txt-red">비밀번호가 일치하지 않습니다.</span> --></td>
										</tr>
										<tr>
											<th><label for="sPwd1">휴대폰번호</label></th>
											<td>
												<div class="phone-change-wrap">
													<div class="phone-change-top">
														<span class="va-m"><%=Session("userPhone")%></span>
														<button type="button" class="btn btn-sm btn-brownLine mar-l15 phone-change-on"><span>변경</span></button>
													</div>
													
													<ul class="phone-change-bot">
														<li>
															<span class="display-ib w-120">- 새 휴대폰 번호</span>
															<span class="display-ib">
																<div class="ui-group-email w-350">
																	<span><input type="text"></span>
																	<span class="dash w-20">-</span>
																	<span><input type="text"></span>
																	<span class="dash w-20">-</span>
																	<span class="pad-l0"><input type="text"></span>
																</div>
															</span>
															<button type="button" class="btn btn-md3 btn-red">인증번호 전송</button>
														</li>
														<li class="mar-t20">
															<span class="display-ib w-120">- 인증번호 입력</span>
															<span class="display-ib">
																<div class="ui-group-email w-350">
																	<span><input type="text"></span>
																	<span class="dash w-20">-</span>
																	<span><input type="text"></span>
																	<span class="dash w-20">-</span>
																	<span class="pad-l0"><input type="text"></span>
																</div>
															</span>
															<button type="button" class="btn btn-md3 btn-black">확인</button>
															<button type="button" class="btn btn-md3 btn-grayLine  phone-change-off">취소</button>
														</li>
													</ul>
												</div>
											</td>
										</tr>
										<tr>
											<th><label for="sEmail1">이메일 주소</label></th>
											<td>
												<span class="ui-group-email">
													<span><input type="text" name="sEmail1" id="sEmail1" maxlength="20" value="<%=email1%>"></span>
													<span class="dash">@</span>
													<span><input type="text" name="sEmail2" id="sEmail2" maxlength="20" value="<%=email2%>"></span>
													<span>
														<select name="sEmailSel" id="sEmailSel" onchange="javascript:setEmail(this,'#sEmail2');">
															<option value=""<%If email2 = "" Then%> selected<%End If%>>직접입력</option>
															<option value="naver.com"<%If email2 = "naver.com" Then%> selected<%End If%>>네이버</option>
															<option value="daum.net"<%If email2 = "daum.net" Then%> selected<%End If%>>다음</option>
															<option value="nate.com"<%If email2 = "nate.com" Then%> selected<%End If%>>네이트</option>
														</select>
													</span>											
												</span>
											</td>
										</tr>
										<tr class="last">
											<th>정보수신동의</th>
											<td>
												<div class="ui-group-checkbox three-up">
													<label class="ui-checkbox">
														<input type="checkbox" name="sAgreeA" id="sAgreeA" onclick="checkAgree(this);" value="A"<%If emailAgree And smsAgree Then%> checked="checked"<%End If%>>
														<span></span> 전체동의
													</label>
													<label class="ui-checkbox">
														<input type="checkbox" name="sAgreeE" id="sAgreeE" onclick="checkAgree(this);" value="E"<%If emailAgree Then%> checked="checked"<%End If%>>
														<span></span> 이메일 수신동의
													</label>
													<label class="ui-checkbox">
														<input type="checkbox" name="sAgreeM" id="sAgreeM" onclick="checkAgree(this);" value="M"<%If smsAgree Then%> checked="checked"<%End If%>>
														<span></span> SMS 수신동의
													</label>									
												</div>
												<ul class="ul-guide mar-t20">
													<li>수신동의를 하시면 상품정보, 할인혜택, 이벤트 등 다양한 혜택 및 소식 안내를 받을 수 있습니다.</li>
													<li>회원가입, 주문배달 관련 등의 정보는 수신동의 여부와 상관없이 자동으로 발송됩니다.</li>
												</ul>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<div class="section-item">
							<h4 class="mar-t60">주소지 관리</h4>
							<div class="boardList-wrap">
								<table border="1" cellspacing="0" class="tbl-list" id="address_list">
									<caption>상품문의</caption>
									<colgroup>
										<col style="width:120px;">
										<col style="width:120px;">
										<col style="width:180px;">
										<col>
										<col style="width:180px;">
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>수령인</th>
											<th>전화번호</th>
											<th>주소</th>
											<th>관리</th>
										</tr>
									</thead>
									<tbody>
<%
	Dim aCmd : Set aCmd = Server.CreateObject("ADODB.Command")
	Dim aRs : Set aRs = Server.CreateObject("ADODB.RecordSet")
	Dim TotalCount

	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_member_addr_select"

		.Parameters.Append .CreateParameter("@member_idno", adVarChar, adParamInput, 50, Session("userIdNo"))
		.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)

		Set aRs = .Execute

		TotalCount = .Parameters("@totalCount").Value
	End With
	Set aCmd = Nothing
%>
<%
	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst
		Do Until aRs.EOF
%>
										<tr id="addr_<%=aRs("addr_idx")%>">
											<td>
												<%If aRs("is_main") = "Y" Then%>
												<strong class="red">기본주소지</strong>
												<%Else%>
												<label class="ui-radio">
													<input type="radio" name="r_idx" value="<%=aRs("addr_idx")%>">
													<span></span>
												</label>
												<%End If%>
											</td>
											<td><%=aRs("addr_name")%></td>
											<td><%=aRs("mobile")%></td>
											<td class="ta-l">
												(<%=aRs("zip_code")%>) <br /> <%=aRs("address_main")&" "&aRs("address_detail")%>
											</td>
											<td>
												<a href="javascript:;" class="btn btn-sm btn-grayLine" onClick="javascript:lpOpen('.lp_address');setAddress(<%=aRs("addr_idx")%>);">수정</a>
												<%If aRs("is_main") <> "Y" Then%>
												<a href="javascript:delAddress(<%=aRs("addr_idx")%>);" class="btn btn-sm btn-grayLine">삭제</a>
												<%End If%>
											</td>
										</tr>
<%
			aRs.MoveNext
		Loop
	End If
	Set aRs = Nothing
%>
<!-- 
										<tr>
											<td>
												<label class="ui-radio">
													<input type="radio" name="addr_idx" >
													<span></span>
												</label>

											</td>
											<td>박하림</td>
											<td>010-1234-1234</td>
											<td class="ta-l">
												(15230)<br/>
												서울시 마포구 토정로12길 569-1
											</td>
											<td>
												<a href="#" class="btn btn-sm btn-grayLine">수정</a>
												<a href="#" class="btn btn-sm btn-grayLine">삭제</a>
											</td>
										</tr>
 -->										
									</tbody>
								</table>

								<div class="bot-area">
									<div class="left">
										<button class="btn btn-sm btn-grayLine" onClick="setPcMainAddress();">기본주소지 설정</button>
									</div>
									<div class="right">
										<button type="button" class="btn btn-md3 btn-red" onclick="javascript:lpOpen('.lp_address');">주소지 추가</button>
									</div>
								</div>
							</div>
						</div>

						<div class="btn-wrap two-up inner mar-t60 line">
							<button type="button" onclick="javascript:saveInfo();" class="btn btn-lg btn-black"><span>확인</span></button>
							<button type="button" onclick="javascript:location.href='/mypage/mypage.asp';" class="btn btn-lg btn-grayLine"><span>취소</span></button>
						</div>

					</form>

			
					<button type="button" onclick="javascript:lpOpen('.lp_memSecssion');" class="btn btn_lp_open btn_memSecssion mar-t60">
						<span class="ico-arrowRight">제너시스BBQ그룹 통합 멤버십 회원탈퇴
							<small>불편사항이 있으셨나요? 고객센터(080-3436-0507)로 연락주시면 서비스개선을 위해 최선을 다하겠습니다.</small>
						</span>
					</button>
				</div>
			</section>
			<!--// My Member Modify -->
								
			<!-- Layer Popup : 주소지 추가 -->
			<div id="LP_Address" class="lp-wrapper lp_address">
				
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>주소지 입력</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">
								<section class="section">
									<form id="form_addr" name="form_addr" method="post" onsubmit="return validAddress(); return false;">
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

										<table border="1" cellspacing="0" class="tbl-member black-line">
											<caption>추가정보</caption>
											<colgroup>
												<col style="width:170px;">
												<col style="width:auto;">
											</colgroup>
											<tbody>
												<tr>
													<th>이름</th>
													<td>
														<input type="text" name="addr_name" class="w-150">
													</td>
												</tr>
												<tr>
													<th>전화번호</th>
													<td>
														<div class="ui-group-email">
															<span><input type="text" name="mobile1" maxlength="3"></span>
															<span class="dash w-20">-</span>
															<span><input type="text" name="mobile2" maxlength="4"></span>
															<span class="dash w-20">-</span>
															<span><input type="text" name="mobile3" maxlength="4"></span>
														</div>
													</td>
												</tr>
												<tr>
													<th>주소</th>
													<td>
														<div class="ui-input-post">
															<input type="text" name="zip_code" id="zip_code" maxlength="7" readonly>
															<button type="button" class="btn btn-md2 btn-gray btn_post" onClick="javascript:showPostcode();"><span>우편번호 검색</span></button>
														</div>
														<div class="mar-t10">
															<input type="text" name="address_main" id="address_main" maxlength="100" readonly="" class="w-100p">
														</div>
														<div class="mar-t10">
															<input type="text" name="address_detail" maxlength="100" class="w-100p">
														</div>
													</td>
												</tr>
											</tbody>
										</table>

										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="summit" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
											<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
										</div>
									</form>
								</section>
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

			<!-- Layer Popup : Member Secssion -->
			<div id="LP_MemSecssion" class="lp-wrapper lp_memSecssion">
				<!-- LP Wrap -->
				<div class="lp-wrap">
					<div class="lp-con">
						<!-- LP Header -->
						<div class="lp-header">
							<h2>회원탈퇴</h2>
						</div>
						<!--// LP Header -->
						<!-- LP Container -->
						<div class="lp-container">
							<!-- LP Content -->
							<div class="lp-content">
								<section class="section mar-b50 ta-c">
									<div class="headLine">
										<div class="headLine-img">
											<img src="/images/mypage/logo_genesisBBQ.png" alt="Genesis BBQ">
										</div>
										<p class="headLine-txt">
											제네시스BBQ그룹 통합 멤버십을 이용해 주셔서 감사합니다.
										</p>
									</div>
									<div class="ta-c">
										<ul class="ul-guide ul-guide-type2 display-ib ta-l">
											<li>- 웹사이트 약관 동의 및 개인정보 제공, 활용 동의가 철회됩니다.</li>
											<li>- 탈퇴후 재가입 시 사용하셨던 아이디는 다시 사용하실 수 없습니다.</li>
											<li class="red">- 재가입은 회원탈퇴 후 30일이 지난 훙만 가능합니다.</li>
										</ul>
									</div>
								</section>
								<section class="section">
									<div class="section-header bg-gray">
										<h3>탈퇴사유</h3>
									</div>
									<div class="section-body">
										<form name="secssionFrm" id="secssionFrm" method="post" onsubmit="javascript:return false;">
										<div class="box-gray">
											<ul class="ui-group-list three-up">
												<li>
													<label class="ui-radio">
														<input type="radio" name="sSecssionType" id="sSecssionType1" value="1">
														<span></span> 배달불만
													</label>
												</li>
												<li>	
													<label class="ui-radio">
														<input type="radio" name="sSecssionType" id="sSecssionType2" value="2">
														<span></span> 자주 이용하지 않음
													</label>
												</li>
												<li>	
													<label class="ui-radio">
														<input type="radio" name="sSecssionType" id="sSecssionType3" value="3">
														<span></span> 상품의 다양성/가격불만
													</label>
												</li>
												<li>	
													<label class="ui-radio">
														<input type="radio" name="sSecssionType" id="sSecssionType4" value="4">
														<span></span> 개인정보 유출우려
													</label>
												</li>
												<li>	
													<label class="ui-radio">
														<input type="radio" name="sSecssionType" id="sSecssionType5" value="5">
														<span></span> 질적인 혜택부족
													</label>
												</li>
												<li>	
													<label class="ui-radio">
														<input type="radio" name="sSecssionType" id="sSecssionType6" value="6">
														<span></span> 기타
													</label>
												</li>
											</ul>
											<textarea name="sSecssionMsg" id="sSecssionMsg" rows="3" placeholder="기타 의견을 남겨주세요." class="w-100p"></textarea>
										</div>
										<div class="btn-wrap two-up pad-t40 bg-white">
											<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
											<button type="button" onclick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
										</div>
										</form>
									</div>
								</section>
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
			
		</article>
		<!--// Content -->	
		
		<!-- QuickMenu -->
		<!--#include virtual="/includes/quickmenu.asp"-->
		<!-- QuickMenu -->

	</div>
	<!--// Container -->
	<hr>
	
	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
</div>
</body>
</html>
