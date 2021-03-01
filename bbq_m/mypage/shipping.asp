<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>
<!--#include virtual="/includes/top.asp"-->
<meta name="Keywords" content="회원정보변경, BBQ치킨">
<meta name="Description" content="회원정보변경">
<title>회원정보변경 | BBQ치킨</title>

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

			<!-- Tab -->
			<div class="tab-wrap tab-type1">
				<ul class="tab two-up">
					<li><a href="/mypage/memEdit.asp"><span class="ico-memEdit">개인정보변경</span></a></li>
					<li class="on"><a href="/mypage/shipping.asp"><span class="ico-shipping">배송지관리</span></a></li>
				</ul>
			</div>
			<!--// Tab -->

			<!-- 배달지추가 -->
			<section class="section section_shippingAdd">
				<button type="button" onClick="javascript:lpOpen('.lp_addShipping');"  class="btn btn-lg btn-black w-100p btn_lp_open">배달지 추가</button>
				<div class="txt">- 자주 사용하는 배송지를 등록 및 관리하실 수 있습니다.</div>
			</section>
			<!-- //배달지추가 -->

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
						</li>
					</ul>
				</div>

				<%
							aRs.MoveNext
						Loop
					End If
					Set aRs = Nothing
				%>

				<!-- 				
				<div class="box">
					<div class="name">
						<span class="red">[기본배달지]</span> 박하나
					</div>
					<ul class="info">
						<li>010-1111-1111</li>
						<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
					</ul>
					<ul class="btn-wrap">
						<li class="btn-left">
						</li>
						<li class="btn-right">
							<button type="button" onClick="javascript:lpOpen('.lp_addShipping');" class="btn btn-sm btn-grayLine btn_lp_open">수정</button>
						</li>
					</ul>
				</div>
				<div class="box">
					<div class="name">
						<span class="red">[기본배달지]</span> 박하나
					</div>
					<ul class="info">
						<li>010-1111-1111</li>
						<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
					</ul>
					<ul class="btn-wrap">
						<li class="btn-left">
							<button type="button" class="btn btn-sm btn-brown">기본배달지 설정</button>
						</li>
						<li class="btn-right">
							<button type="button" onClick="javascript:lpOpen('.lp_addShipping');" class="btn btn-sm btn-grayLine btn_lp_open">수정</button>
							<button type="button" class="btn btn-sm btn-grayLine">삭제</button>
						</li>
					</ul>
				</div>
				<div class="box">
					<div class="name">
						<span class="red">[기본배달지]</span> 박하나
					</div>
					<ul class="info">
						<li>010-1111-1111</li>
						<li>(01234) 서울특별시 관악구 난리로 66 무슨빌딩 1층</li>
					</ul>
					<ul class="btn-wrap">
						<li class="btn-left">
							<button type="button" class="btn btn-sm btn-brown">기본배달지 설정</button>
						</li>
						<li class="btn-right">
							<button type="button" onClick="javascript:lpOpen('.lp_addShipping');" class="btn btn-sm btn-grayLine btn_lp_open">수정</button>
							<button type="button" class="btn btn-sm btn-grayLine">삭제</button>
						</li>
					</ul>
				</div> 
				-->
			</section>

			


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
				</form>
			</div>
			<!--// Layer Popup -->


		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->
