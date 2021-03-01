<!--#include virtual="/api/include/utf8.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="회원정보변경, BBQ치킨">
<meta name="Description" content="회원정보변경">
<title>회원정보변경 | BBQ치킨</title>

<script>
	jQuery(document).ready(function(e) {
		// inquiryList
		$(document).on('click', '.btn_phoneChange', function(e) {
			if($('.phone-cert').is(':hidden')){
				$('.phone-cert').show();
				$(this).find('span').text('취소');
			}else{
				$('.phone-cert').hide();
				$(this).find('span').text('변경');
			}
		});
	});
</script>

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

	function checkAgree(obj) {
		switch($(obj).val()) {
			case "A":
				$("#sAgreeE").prop("checked", $("#sAgreeA").is(":checked"));
				$("#sAgreeM").prop("checked", $("#sAgreeA").is(":checked"));
				break;
			case "E":
				$("#sAgreeA").prop("checked", $("#sAgreeE").is(":checked")  && $("#sAgreeM").is(":checked"));
			break;
			case "M":
				$("#sAgreeA").prop("checked", $("#sAgreeE").is(":checked")  && $("#sAgreeM").is(":checked"));
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

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "회원정보변경"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content">
			<form name="memForm" id="memForm" method="post" onSubmit="return false;">
				<!-- 기본정보 -->
				<section class="section mar-b50">
					<div class="section-header">						
						<h3>기본정보</h3>
					</div>
					<div class="section-body">
						<div class="box-gray">
							<dl class="regForm">
								<dt>이름</dt>
								<dd><%=Session("userName")%></dd>
							</dl>
							<dl class="regForm">
								<dt>생년월일</dt>
								<dd><%=Session("userBirth")%></dd>
							</dl>
							<dl class="regForm">
								<dt>아이디</dt>
								<dd><%=Session("userId")%></dd>
							</dl>
						</div>
						<div class="inner">
							<dl class="regForm">
								<dt><label for="sPwd1">비밀번호</label></dt>
								<dd>
									<button type="button" onclick="javascript:changeInfo('pwd');" class="btn btn-sm btn-brownLine w-170 btn_phoneChange"><span>비밀번호 변경</span></button>
									<!-- <input type="password" name="sPwd1" id="sPwd1" maxlength="20" placeholder="영문, 숫자, 특수문자를 조합하여 10자 이상" class="w-100p">
									<input type="password" name="sPwd2" id="sPwd2" maxlength="20" placeholder="비밀번호 재입력" class="w-100p bor-tnone"> -->
								</dd>
							</dl>
							<dl class="regForm">
								<dt>휴대폰번호</dt>
								<dd>
									<span class="va-m mar-r20"><%=Session("userPhone")%></span><button type="button" onclick="javascript:changeInfo('mobile');" class="btn btn-sm btn-brownLine w-170 btn_phoneChange"><span>변경</span></button>

									<!-- 									
									<ul class="phone-cert mar-t30">
										<li>
											<span class="ui-group-tel">
												<span>
													<select>
														<option value="" selected>010</option>
													</select>
												</span>
												<span class="dash">-</span>
												<span><input type="text"></span>
												<span class="dash">-</span>
												<span><input type="text"></span>
											</span>
											<a href="#" class="btn btn-md btn-red">인증번호</a>
										</li>
										<li>
											<input type="text" placeholder="인증번호 입력" class="w-100p">
											<button type="button" class="btn btn-md btn-black">확인</button>
										</li>
									</ul>
									 -->	
									 
								</dd>
							</dl>
							<dl class="regForm">
								<dt><label for="sEmail1">이메일 주소</label></dt>
								<dd>
									<span class="ui-group-email">
										<span><input type="text" name="sEmail1" id="sEmail1" maxlength="20" value="<%=email1%>"></span>
										<span class="dash">@</span>
										<span><input type="text" name="sEmail2" id="sEmail2" maxlength="20" value="<%=email2%>"></span>
										<span>
											<select name="sEmailSel" id="sEmailSel" onChange="javascript:setEmail(this,'#sEmail2');">
												<option value=""<%If email2 = "" Then%> selected<%End If%>>직접입력</option>
												<option value="naver.com"<%If email2 ="naver.com" Then%> selected<%End If%>>네이버</option>
												<option value="daum.net"<%If email2 ="daum.net" Then%> selected<%End If%>>다음</option>
												<option value="nate.com"<%If email2 ="nate.com" Then%> selected<%End If%>>네이트</option>
											</select>
										</span>
									</span>
								</dd>
							</dl>
						</div>											
					</div>
				</section>
				<!--// 기본정보 -->
					
				<!-- 정보수신동의 -->
				<section class="section mar-b125">
					<div class="section-header">
						<h3>정보수신동의</h3>
					</div>
					<div class="section-body">
						<div class="box-gray">
							<div class="ui-group-checkbox three-up">
								<label class="ui-checkbox">
									<input type="checkbox" name="sAgreeA" onclick="checkAgree(this);" id="sAgreeA" value="A"<%If emailAgree And smsAgree Then%> checked="checked"<%End If%>>
									<span></span> 전체동의
								</label>
								<label class="ui-checkbox">
									<input type="checkbox" name="sAgreeE" onclick="checkAgree(this);" id="sAgreeE" value="E"<%If emailAgree Then%> checked="checked"<%End If%>>
									<span></span> 이메일 수신동의
								</label>
								<label class="ui-checkbox">
									<input type="checkbox" name="sAgreeM" onclick="checkAgree(this);" id="sAgreeM" value="M"<%If smsAgree Then%> checked="checked"<%End If%>>
									<span></span> SMS 수신동의
								</label>									
							</div>
						</div>
						<div class="inner">
							<ul class="ul-guide mar-t30">
								<li>수신동의를 하시면 상품정보, 할인혜택, 이벤트 등 다양한 혜택 및 소식 안내를 받을 수 있습니다.</li>
								<li>회원가입, 주문배달 관련 등의 정보는 수신동의 여부와 상관없이 자동으로 발송됩니다.</li>
							</ul>
						</div>
					</div>
				</section>
				<!--// 정보수신동의 -->

				<!-- 주소지 관리 -->
				<section class="section">
					<div class="section-header section-header-line">
						<h3>주소지 관리</h3>
					</div>
					<div class="section section_shippingAdd">
						<button type="button" onClick="javascript:lpOpen('.lp_addShipping');"  class="btn btn-lg btn-black w-100p btn_lp_open">배달지 추가</button>
						<div class="txt">- 자주 사용하는 배송지를 등록 및 관리하실 수 있습니다.</div>
					</div>
				</section>
				<!--// 주소지 관리 -->

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

				<!-- 배달지 리스트 -->
				<section class="section section_shipList">
					<%
						If Not (aRs.BOF Or aRs.EOF) Then
							aRs.MoveFirst
							Do Until aRs.EOF
					%>

					<div class="box" id="addr_<%=aRs("addr_idx")%>">
						<div class="name">
							<%If aRs("is_main") = "Y" Then%><span class="red">[기본배달지]</span> <%End If%><%=aRs("addr_name")%>
						</div>
						<ul class="info">
							<li><%=aRs("mobile")%></li>
							<li>(<%=aRs("zip_code")%>) <%=aRs("address_main")&" "&aRs("address_detail")%></li>
						</ul>
						<ul class="btn-wrap">
							<li class="btn-left">

								<%							
									If aRs("is_main") <> "Y" Then
								%>

								<button type="button" class="btn btn-sm btn-brown" onClick="javascript:setMainAddress('<%=aRs("addr_idx")%>');">기본배달지 설정</button>

								<%
									End If
								%>

							</li>
							<li class="btn-right">
								<button type="button" onClick="javascript:lpOpen('.lp_addShipping');setAddress(<%=aRs("addr_idx")%>);" class="btn btn-sm btn-grayLine btn_lp_open">수정</button>

								<%							
									If aRs("is_main") <> "Y" Then
								%>

								<button type="button" onClick="javascript:delAddress(<%=aRs("addr_idx")%>);" class="btn btn-sm btn-grayLine btn_lp_open">삭제</button>

								<%
									End If
								%>

							</li>
						</ul>
					</div>

					<%
								aRs.MoveNext
							Loop
						End If
						Set aRs = Nothing
					%>

				</section>
				<!-- //배달지 리스트 -->

				<div class="mar-t100 inner">
						<button type="button" onClick="javascript:lpOpen('.lp_memSecssion');" class="btn btn_lp_open btn_memSecssion"><span class="ico-arrowRight">회원탈퇴 <small>제너시스BBQ그룹 통합 멤버십 회원탈퇴</small></span></button>
				</div>

				<div class="btn-wrap two-up inner mar-t80">
					<button type="button" onclick="javascript:saveInfo();" class="btn btn-lg btn-black"><span>확인</span></button>
					<button type="button" onclick="javascript:location.href='/mypage/mypage.asp'" class="btn btn-lg btn-grayLine"><span>취소</span></button>
				</div>
			</form>
			
			<!-- Layer Popup : Member Secssion -->
			<div id="LP_MemSecssion" class="lp-wrapper lp_memSecssion">
				<!-- LP Header -->
				<div class="lp-header">
					<h2>회원탈퇴</h2>
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<section class="section inner mar-b70">
							<div class="headLine">
								<div class="headLine-img">
									<img src="/images/mypage/logo_genesisBBQ.png" alt="Genesis BBQ">
								</div>
								<p class="headLine-txt">
									제네시스BBQ그룹 통합 멤버십을<br>
									이용해 주셔서 감사합니다.
								</p>
							</div>
							<ul class="ul-guide ul-guide-type2">
								<li>웹사이트 약관 동의 및 개인정보 제공, 활용 동의가 철회됩니다.</li>
								<li>탈퇴후 재가입 시 사용하셨던 아이디는 다시 사용하실 수 없습니다.</li>
								<li class="red">재가입은 회원탈퇴 후 30일이 지난 훙만 가능합니다.</li>
							</ul>
						</section>
						<section class="section">
							<div class="section-header">
								<h3>탈퇴사유</h3>
							</div>
							<div class="section-body">
								<form name="secssionFrm" id="secssionFrm" method="post" onSubmit="javascript:return false;">								
								<div class="box-gray">
									<ul class="ui-group-list two-up">
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
									<textarea name="sSecssionMsg" id="sSecssionMsg" rows="5" placeholder="기타 의견을 남겨주세요." class="w-100p"></textarea>
								</div>
								<div class="btn-wrap two-up inner mar-t70">
									<button type="submit" class="btn btn-lg btn-black btn_confirm"><span>확인</span></button>
									<button type="button" onClick="javascript:lpClose(this);" class="btn btn-lg btn-grayLine btn_cancel"><span>취소</span></button>
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
			<!--// Layer Popup -->

			<!-- Layer Popup : 배달지 입력 -->
			<div id="LP_addShipping" class="lp-wrapper lp_addShipping">
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
				<!-- LP Header -->
				<div class="lp-header">
					<h2>배달지 입력</h2>
				</div>
				<!--// LP Header -->
				<!-- LP Container -->
				<div class="lp-container">
					<!-- LP Content -->
					<div class="lp-content">
						<form action="">
							<div class="inner">
								<dl class="regForm">
									<dt>이름</dt>
									<dd>
										<input type="text" name="addr_name" class="w-100p">
									</dd>
								</dl>
								<dl class="regForm">
									<dt>전화번호</dt>
									<dd>
										<span class="ui-group-tel">
											<span><input type="text" name="mobile1" maxlength="3"></span>
											<span class="dash">-</span>
											<span><input type="text" name="mobile2" maxlength="4"></span>
											<span class="dash">-</span>
											<span><input type="text" name="mobile3" maxlength="4"></span>
										</span>
									</dd>
								</dl>
								<dl class="regForm">
									<dt><label for="zip_code">주소</label></dt>
									<dd>
										<div class="ui-input-post">
											<input type="text" name="zip_code" id="zip_code" maxlength="7" readonly>
											<button type="button" onClick="javascript:showPostcode();" class="btn btn-md btn-gray btn_post"><span>우편번호 검색</span></button>
										</div>
										<div class="mar-t10"><input type="text" name="address_main" id="address_main" maxlength="100" readonly="" class="w-100p"></div>
										<div class="mar-t10"><input type="text" name="address_detail" maxlength="100" class="w-100p"></div>
									</dd>
								</dl>
							</div>
							<div class="btn-wrap two-up inner mar-t80">
								<button type="submit" class="btn btn-lg btn-black"><span>확인</span></button>
								<button type="button" onClick="javascript:lpClose('.lp_addShipping');" class="btn btn-lg btn-grayLine"><span>취소</span></button>
							</div>
						</form>
					</div>
					<!--// LP Content -->
				</div>
				<!--// LP Container -->
				<button type="button" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
			</div>
			<!--// Layer Popup -->

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<iframe id="frm_work" height="0" width="0" style="display: none;"></iframe>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
