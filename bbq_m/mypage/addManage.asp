<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->
<!--#include virtual="/api/include/requireLogin.asp"-->

<meta name="Keywords" content="회원정보변경, BBQ치킨">
<meta name="Description" content="회원정보변경">
<title>회원정보변경 | BBQ치킨</title>

<script>
	jQuery(document).ready(function(e) {
		// inquiryList
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
<% If Request.ServerVariables("HTTP_HOST") = "bbq.fuzewire.com:8010" Then %>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js?autoload=false"></script>
<% Else %>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js?autoload=false"></script>
<% End If %>
<script type="text/javascript">
<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
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
		$('#layer').css('z-index','999');
        document.getElementById('wrap_daum').style.display = 'block';
		$('#viewport').attr('content','minimum-scale=1.0, width=750, maximum-scale=1.0, user-scalable=no');
    }
<% Else %>

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

<% End If %>
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

	function validInfo() {
		var data = {};
		data.email = $.trim($("#sEmail1").val())+"@"+$.trim($("#sEmail2").val());
		data.agreeE = $("#sAgreeE").is(":checked")? "Y": "";
		data.agreeM = $("#sAgreeM").is(":checked")? "Y": "";

		changeUserInfo(data);
	}
	// function saveInfo() {
	// 	var data = {};
	// 	data.email = $.trim($("#sEmail1").val())+"@"+$.trim($("#sEmail2").val());
	// 	data.agreeE = $("#sAgreeE").is(":checked")? "Y": "";
	// 	data.agreeM = $("#sAgreeM").is(":checked")? "Y": "";
	// 	$.ajax({
	// 		method: "post",
	// 		url: "/api/changeUserInfo.asp",
	// 		data: data,
	// 		dataType: "json",
	// 		success: function(res) {
	// 			alert(res.message);
	// 		}
	// 	})
	// }

	// function changeInfo(info) {
	// 	$.ajax({
	// 		method: "post",
	// 		url: "/api/issueTicket.asp",
	// 		data: {info: info},
	// 		dataType: "json",
	// 		success: function(res) {
	// 			if(res.header.resultCode == 0) {
	// 				var url = "";
	// 				switch(info) {
	// 					case "pwd":
	// 					url = "/change-password"
	// 					break;
	// 					case "mobile":
	// 					url = "/change-cellphone-number";
	// 					break;
	// 				}
	// 				location.href = "<%=PAYCO_AUTH_URL%>"+url+"?ticket="+res.data.ticket+"&appYn=N&logoYn=N&titleYn=N";
	// 			}
	// 		}
	// 	});
	// }

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
				succes: function(res) {
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
</script>
</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "주소지 관리"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
			
		<!-- Content -->
		<article class="content inbox1000">

			<form name="memForm" id="memForm" method="post" onSubmit="return false;">

				<!-- 주소지 관리 -->
				<section class="section section_memEdit mar-t40">
					<div class="section section_shippingAdd alignC">
						
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
				<section class="section_addManage">

					<div class="btn_wrap"><button type="button" onClick="javascript:lpOpen('.lp_addShipping');"  class="btn btn-red btn_middle">배달지 추가</button></div>

					<div class="section-header">
						<h3>등록된 주소</h3>
					</div>

					<div class="addManage_wrap">
					
						<%
							If Not (aRs.BOF Or aRs.EOF) Then
								aRs.MoveFirst
								Do Until aRs.EOF
						%>

						<div class="addManage" id="addr_<%=aRs("addr_idx")%>">
							<div class="name">
								<%If aRs("is_main") = "Y" Then%>
								<span class="red">[기본배달지]</span> <%End If%><%'=aRs("addr_name")%>
							</div>
							<ul class="info">
								<!--li><%'=aRs("mobile")%></li-->
								<li>(<%=aRs("zip_code")%>) <%=aRs("address_main")&" "&aRs("address_detail")%></li>
							</ul>
							<ul class="btn-wrap">
								<li class="btn-left">
									<% If aRs("is_main") <> "Y" Then %>
										<button type="button" class="btn btn_small2 btn-brown" onClick="javascript:setMainAddress('<%=aRs("addr_idx")%>');">기본배달지 설정</button>
									<% End If %>
								</li>
								<li class="btn-right">
									<span class='add_del_span' id='add_del_<%=aRs("addr_idx")%>' <% If aRs("is_main") = "Y" Then %> style="display:none" <% End If %>><button type="button" onClick="javascript:delAddress(<%=aRs("addr_idx")%>);" class="btn_small2 btn-grayLine btn_lp_open">삭제</button></span>

									<button type="button" onClick="javascript:lpOpen('.lp_addShipping');setAddress(<%=aRs("addr_idx")%>);" class="btn_small2 btn-grayLine btn_lp_open">수정</button>
								</li>
							</ul>
						</div>
						<%
									aRs.MoveNext
								Loop
							End If
							Set aRs = Nothing
						%>
					</div>
				</section>
				<!-- //배달지 리스트 -->

			</form>

		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<iframe id="frm_work" height="0" width="0" style="display: none;"></iframe>

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->





	<!-- Layer Popup : 배달지 입력 -->
	<div id="LP_addShipping" class="lp-wrapper lp_addShipping">

		<!-- LP Wrap -->
		<div class="lp-wrap inbox1000">

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
							<div class="ui-input-post">
								<input type="text" name="zip_code" id="zip_code" maxlength="7" readonly onfocus="this.blur()" onClick="javascript:showPostcode();" style="width:90px;">
								<button type="button" onClick="javascript:showPostcode();" class="btn btn-sm btn-gray">우편번호 검색</button>
							</div>
							<div class="mar-t10"><input type="text" name="address_main" id="address_main" maxlength="100" readonly="" class="w-100p" onfocus="this.blur()" onClick="javascript:showPostcode();"></div>
							<div class="mar-t10"><input type="text" name="address_detail" maxlength="100" class="w-100p" onkeyup="chkWord_new(this, 60, 'N');"></div>
						</div>
						<% If instr(Request.ServerVariables("HTTP_USER_AGENT"), "bbqAOS") > 0 Then %>
						
							<div id="wrap_daum" class="daum_search" style="background:#fff;">
								<img class="search_close" src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" onclick="foldDaumPostcode()" alt="접기 버튼">
							</div>
						
						<% End If %>

						<div class="btn-wrap two-up mar-t20">
							<button type="submit" class="btn btn_big btn-black">확인</button>
							<button type="button" onClick="javascript:lpClose('.lp_addShipping');" class="btn btn_big btn-grayLine">취소</button>
						</div>
					</form>
				</div>
				<!--// LP Content -->
			</div>
			<!--// LP Container -->

			<button type="button" onClick="javascript:lpClose(this);" class="btn btn_lp_close"><span>레이어팝업 닫기</span></button>

		</div>
		<!--// LP Wrap -->
	</div>
	<!--// Layer Popup -->
