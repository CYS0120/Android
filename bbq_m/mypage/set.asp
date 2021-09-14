<!--#include virtual="/api/include/utf8.asp"-->
<%
	access_token = Request.Cookies("access_token")

	If CheckLogin() and access_token <> "" Then
		Set api = New ApiCall

		api.SetMethod = "POST"
		api.RequestContentType = "application/json"
		'api.Authorization = "Bearer " & access_token
		api.SetData = "{""companyCd"":"""& PAYCO_MEMBERSHIP_COMPANYCODE &""",""accessToken"":"""& access_token &"""}"
		api.SetUrl = PAYCO_MEMBERSHIP_URL & "/push/getMemberPushConfig"

		result = api.Run

		Set api = Nothing

		' Response.Write "</br>PUSH 수신 동의 설정 조회 Result > " & result & "<br>"

		' Response.end
		' {"code":0,"message":"SUCCESS"}

		Set oJson = JSON.Parse(result)

		If JSON.hasKey(oJson , "code") Then
			If oJson.code = 0 Then

				loginMessage = oJson.message
				pushReceiveYn = oJson.result.pushReceiveYn '푸시 수신 여부
				adReceiveYn = oJson.result.adReceiveYn '광고 수신 여부
				nightReceiveYn = oJson.result.nightReceiveYn '야간 광고 수신여부

			Else 
				loginMessage = "PUSH 수신 동의 설정 조회 실패"
			End If
		End If

	Else
		loginSuccess = False
		loginMessage = "인증에 실패하였습니다."
		returnUrl = returnUrl & "&error=no_token"

		'response.write "<br/><br/>access_token : " & access_token
%>
<script>
	window.location.href = "/";
</script>
<%
		response.end
	End If
%>

<%
	If oJson.code = 0 Then

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

		If JSON.hasKey(mJ, "data") Then
			If JSON.hasKey(mJ.data, "member") Then
				If JSON.hasKey(mJ.data.member, "cellphoneNumber") Then
					useridno = mJ.data.member.idNo
				ENd If
			End If
		End if

		Set cmd = Server.CreateObject("ADODB.Command")
		if emailAgree then
			emailAgreeYn = "Y"
		else
			emailAgreeYn = "N"
		end if

		if smsAgree then
			smsAgreeYn = "Y"
		else
			smsAgreeYn = "N"
		end if

		sql = ""
		sql = sql & "UPDATE bt_member SET "
		sql = sql & "	push_agree_yn = '" & pushReceiveYn & "', "
		sql = sql & "	email_agree_yn = '" & emailAgreeYn & "', "
		sql = sql & "	sms_agree_yn = '" & smsAgreeYn & "' "
		sql = sql & "WHERE member_idno = '" & useridno & "'"

		cmd.ActiveConnection = dbconn
		cmd.CommandType = adCmdText
		cmd.CommandText = sql

		cmd.Execute
	end if

	If CheckLogin() Then

		Set api = New ApiCall

		api.SetMethod = "POST"
		api.RequestContentType = "application/x-www-form-urlencode"
		api.SetUrl = g2_bbq_m_url & "/pay/sgpay2/ajax_IsRegMember.asp?corpMemberNo=" & Session("userIdNo")

		isSGPay = api.Run

		Set api = Nothing

	Else
		isSGPay = ""
	end if
%>

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

<script type="text/javascript">
	function validWithdraw(){
		if($("#secssionFrm input[name=sSecssionType]:checked").length == 0) {
			showAlertMsg({msg:"탈퇴사유를 선택하세요."});
			return false;
		}
		
		if($("#secssionFrm input[name=sSecssionType]:checked").val() == "기타") {
			if($.trim($("#sSecssionMsg").val()) == "") {
				showAlertMsg({msg:"기타 의견을 입력해주세요."});
				return false;
			}
		}
		// test
		/*
		showConfirmMsg({msg:"탈퇴하시겠습니까?", ok: function(){
			showAlertMsg({msg:"test", ok: function(){
				window.location.href = "/api/logout.asp";
			}});
		}});
		*/
		showConfirmMsg({msg:"탈퇴하시겠습니까?", ok: function(){
			$.ajax({
				method: "post",
				url: "/api/ajax/ajax_withdraw.asp",
				data: $("#secssionFrm").serialize(),
				dataType: "json",
				success: function(res) {
					lpClose(".lp_memSecssion");
					if(res.result == 0) {
						showAlertMsg({msg:res.message, ok: function(){
							window.location.href = "/";
						}});
					} else {
						showAlertMsg({msg:res.message});
					}
				}
			});
		}});
		
	}
	function save_auto_login(obj)
	{
		obj_chk = obj.checked;

		if (obj_chk == true) {
			auto_chk = "Y";
		} else {
			auto_chk = "N";
		}

		$.ajax({
			url: "/api/ajax/ajax_auto_login.asp",
			data: "auto_chk="+ auto_chk,
			method: "post",
		})
		.done(function( row ) {
			console.log(row)
//			alert( "Data Saved: " + msg2 );
		})
	}

	function push_control(num)
	{
		push1_chk = document.getElementById("push1").checked;

		if (push1_chk) {
//			$('.push_sub_dd').slideDown(200);
			$('.push_sub_dd').show(200);
		} else {
//			$('.push_sub_dd').slideUp(200);
			$('.push_sub_dd').hide(200);

			document.getElementById("push2").checked = false;
//			document.getElementById("push3").checked = false;
		}

		push1_chk = document.getElementById("push1").checked;
		push2_chk = document.getElementById("push2").checked;
//		push3_chk = document.getElementById("push3").checked;

		if (push1_chk == true) {
			push1_chk = "Y";
		} else {
			push1_chk = "N";
		}

		if (push2_chk == true) {
			push2_chk = "Y";
		} else {
			push2_chk = "N";
		}

		push3_chk = "N";
//		if (push3_chk == true) {
//			push3_chk = "Y";
//		} else {
//			push3_chk = "N";
//		}

		$.ajax({
			url: "/api/ajax/ajax_setPush.asp",
			data: "pushReceiveYn="+ push1_chk +"&adReceiveYn="+ push2_chk +"&nightReceiveYn="+ push3_chk,
			method: "post",
		})
		.done(function( row ) {
			if (row != "SUCCESS") {
				alert(row);

				if (num == "1") {
					if (document.getElementById("push1").checked) {
						document.getElementById("push1").checked = false;
						$('.push_sub_dd').hide(0);
					} else {
						document.getElementById("push1").checked = true;
						$('.push_sub_dd').show(0);
					}
				} else {
					// 그외에는 한꺼번에 처리
					if (document.getElementById("push"+ num).checked) {
						document.getElementById("push"+ num).checked = false;
					} else {
						document.getElementById("push"+ num).checked = true;
					}
				}

//				showAlertMsg({msg:row})
//				console.log(msg);
			}
		})
	}

	function validInfo() {
		var data = {};

		push4_chk = document.getElementById("push4").checked;
		push5_chk = document.getElementById("push5").checked;

		if (push4_chk == true) {
			push4_chk = "Y";
		} else {
			push4_chk = "";
		}

		if (push5_chk == true) {
			push5_chk = "Y";
		} else {
			push5_chk = "";
		}

		data.agreeE = push4_chk;
		data.agreeM = push5_chk;

		changeUserInfo_g2(data);
	}


	function changeUserInfo_g2(data) {
		$.ajax({
			method: "post",
			url: "/api/changeUserInfo.asp",
			data: data,
			dataType: "json",
			success: function(res) {
//				showAlertMsg({msg:res.message, ok: function(){
//					location.reload(true);
//				}});
			}
		});
	}

</script>

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "설정"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content inbox1000_2">

			<div class="set_wrap">
				<% If CheckLogin() Then %>
					<dl class="set_list">
						<dt>계정설정</dt>
						<dd><%=Session("userId")%> <button type="button" onClick="javascript:location.href='/api/logout.asp';" class="btn_logout">로그아웃</button></dd>
						<dd><a href="/mypage/memEdit.asp">개인정보변경</a></dd>
						<dd>
							자동로그인 상태 유지 	
							<label class="switch">
								<input type="checkbox" <% if Request.Cookies("refresh_token") <> "" then %> checked <% end if %> onclick="save_auto_login(this)">
								<span class="switch_slider round"></span>
							</label>
						</dd>
					</dl>
					<dl class="set_list">
						<dt>마케팅 수신 동의</dt>

						<dd>
							E-mail
							<label class="switch">
								<input type="checkbox" id="push4" onclick="validInfo()" <%If emailAgree Then%> checked <%End If%>>
								<span class="switch_slider round"></span>
							</label>
						</dd>

						<dd>
							SMS
							<label class="switch">
								<input type="checkbox" id="push5" onclick="validInfo()" <%If smsAgree Then%> checked <%End If%>>
								<span class="switch_slider round"></span>
							</label>
						</dd>


						<dd>
							PUSH 수신 설정
							<label class="switch">
								<input type="checkbox" id="push1" onclick="push_control(1)" <% if pushReceiveYn = "Y" then %> checked <% end if %>>
								<span class="switch_slider round"></span>
							</label>
						</dd>

						<dd class="push_sub_dd" <% if pushReceiveYn <> "Y" then %> style="display:none;" <% end if %>>
							광고 수신
							<label class="switch">
								<input type="checkbox" id="push2" onclick="push_control(2)" <% if pushReceiveYn = "Y" then %> checked <% end if %>>
								<span class="switch_slider round"></span>
							</label>
						</dd>
<% if false then %>
						<dd class="push_sub_dd" <% if pushReceiveYn <> "Y" then %> style="display:none;" <% end if %>>
							야간 광고 수신 (21시~익일8시)
							<label class="switch">
								<input type="checkbox" id="push3" onclick="push_control(3)" <% if pushReceiveYn = "Y" then %> checked <% end if %>>
								<span class="switch_slider round"></span>
							</label>
						</dd>
<% end if %>
					</dl>
				<% end if %>
<% if len(isSGPay) > 0 then %>
				<dl class="set_list">
					<dt>비비큐페이</dt>
					<dd><a href="/pay/sgpay2/sgpay_Mypage.asp">페이설정</a></dd>
				</dl>
<% end if %>

				<dl class="set_list">
					<dt>약관</dt>
					<dd><a href="/etc/marketing.asp">마케팅 수신 약관</a></dd>
					<dd><a href="/etc/location.asp">위치기반서비스 약관</a></dd>
					<dd><a href="/etc/privacy.asp">개인정보취급방침</a></dd>
				</dl>

				<% If CheckLogin() Then %>
					<dl class="set_list">
						<dt>회원탈퇴</dt>
						<dd><a href="#" onClick="javascript:lpOpen('.lp_memSecssion');return false;">제너시스BBQ그룹 통합 멤버십 회원 탈퇴</a></dd>
					</dl>
				<% end if %>

			</div>
			
		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->



<!-- 토글스위치 -->
<script>
	var check = $("input[type='checkbox']");
	check.click(function(){
		$("p").toggle();
	});
</script>
<!-- // 토글스위치 -->



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
				<section class="section-memEdit">
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
						<li>탈퇴후 재가입 시 사용하셨던 아이디는 다시 사용하실 수 있습니다.</li>
						<li class="red">재가입은 회원탈퇴 후 30일이 지난 후에만 가능합니다.</li>
					</ul>
				</section>
				<section class="section-reason mar-t30">
					<div class="section-header">
						<h3>탈퇴사유</h3>
					</div>
					<div class="section-body mar-t10">
						<form name="secssionFrm" id="secssionFrm" method="post" onSubmit="javascript:validWithdraw(); return false;">								
						<div class="box-gray">
							<ul class="ui-group-list two-up">
								<li>
									<label class="ui-radio2">
										<input type="radio" name="sSecssionType" id="sSecssionType1" value="배달불만">
										<span></span> 배달불만
									</label>
								</li>
								<li>	
									<label class="ui-radio2">
										<input type="radio" name="sSecssionType" id="sSecssionType2" value="자주 이용하지 않음">
										<span></span> 자주 이용하지 않음
									</label>
								</li>
								<li>	
									<label class="ui-radio2">
										<input type="radio" name="sSecssionType" id="sSecssionType3" value="상품의 다양성/가격불만">
										<span></span> 상품의 다양성/가격불만
									</label>
								</li>
								<li>	
									<label class="ui-radio2">
										<input type="radio" name="sSecssionType" id="sSecssionType4" value="개인정보 유출우려">
										<span></span> 개인정보 유출우려
									</label>
								</li>
								<li>	
									<label class="ui-radio2">
										<input type="radio" name="sSecssionType" id="sSecssionType5" value="질적인 혜택부족">
										<span></span> 질적인 혜택부족
									</label>
								</li>
								<li>	
									<label class="ui-radio2">
										<input type="radio" name="sSecssionType" id="sSecssionType6" value="기타">
										<span></span> 기타
									</label>
								</li>																																								
							</ul>
							<textarea name="sSecssionMsg" id="sSecssionMsg" rows="3" placeholder="기타 의견을 남겨주세요." class="w-100p mar-t10"></textarea>
						</div>
						<div class="btn-wrap two-up inbox1000 mar-t30">
							<button type="submit" class="btn btn_middle btn-gray">확인</button>
							<button type="button" onClick="javascript:lpClose(this);" class="btn btn_middle btn-grayLine">취소</button>
						</div>
						</form>
					</div>
				</section>
			</div>
			<!--// LP Content -->
		</div>
		<!--// LP Container -->
		<button type="button" onClick="javascript:lpClose(this);" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>
	</div>
	<!--// Layer Popup -->
