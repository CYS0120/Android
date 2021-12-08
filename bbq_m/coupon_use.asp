<!--#include virtual="/api/include/utf8.asp"-->

<!doctype html>
<html lang="ko">
<head>

<!--#include virtual="/includes/top.asp"-->

</head>

<body>

<div class="wrapper">

	<%
		PageTitle = "모바일 상품권 주문"
	%>

	<!--#include virtual="/includes/header.asp"-->

	<!-- Container -->
	<div class="container">

		<!-- Aside -->
		<!--#include virtual="/includes/aside.asp"-->
		<!--// Aside -->
				
		<!-- Content -->
		<article class="content inbox1000_2">
			<!-- 모바일 상품권 등록 -->
			<div id="LP_eCoupon" class="eCoupon_wrap">
			
				<!-- 사용가능 e쿠폰 -->
				<section class="section section_couponUseOk">
					
					<!-- e쿠폰 등록 -->
					<section class="eCoupon_wrap">
						<h3>모바일 상품권  번호를<br>입력하여 주세요.</h3>
							<ul class="area">
								<li>
									<input type="text" id="txtPIN" name="txtPIN" placeholder="모바일 상품권 번호 입력" class="w-70p" autocomplete="off" style="margin-right:2%;" maxlength="12">
									<button type="button" onclick='javascript:eCouponUse("UA");' class="btn-sm btn-black w-15p">추가</button>
								</li>
							</ul>
					</section>
					<!-- //e쿠폰 등록 -->

					<!-- <div class="couponUseOk_wrap"> -->
					<div class="couponUseOk">
					<%
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
						End With
						Set aCmd = Nothing   

						dim idxEcoupon : idxEcoupon = 0 
						If Not (aRs.BOF Or aRs.EOF) Then    
							aRs.MoveFirst  

							Do Until aRs.EOF  
								idxEcoupon = idxEcoupon + 1
						%>
						<div class="divCouponItemM"> 
							<div class="coupon">
								<!--
								<div class="tit div-table">
									<ul class="tr">
										<li class="td device"><span class="ico-branch red">비비큐치킨</span></li>
										<li class="td day"></li>
									</ul>
								</div>
								-->
								<dl class="info">
									<label class='checkbox'>
									<!--<dt onclick='javascript:eCoupon_Check_GoCart("N", "<%=aRs("c_code")%>");'><b><%=aRs("c_title")%></b></dt>-->
									<dt><input type="checkbox" name="chkEcoupon" id="chkEcoupon<%=idxEcoupon%>" value="<%=aRs("c_code")%>" /> <b><%=aRs("c_title")%></b></dt>
									<dd>
										번&nbsp;&nbsp;&nbsp;&nbsp;호 : <%=aRs("c_code")%><br/>
										금&nbsp;&nbsp;&nbsp;&nbsp;액 : <%=FormatNumber(aRs("CPN_PRICE"), 0)%><br/>
										유효기간 : <%=aRs("USESDATE")%> ~ <%=aRs("USEEDATE")%>
									</dd>
									</label>
								</dl>
								<!--<dl class="coupon_list_delete"><a href='javascript:eCoupon_Check_GoCart("N", "<%=aRs("c_code")%>");' class="btn btn-red btn_middle">사용하기</a></dl>
								<dl class="coupon_list_use"><a href='javascript:eCoupon_Check_GoCart("N", "<%=aRs("c_code")%>");' class="btn btn-red btn_middle">사용</a></dl>
								<dl class="coupon_list_delete"><a href="javascript:eCoupon_del_plus('<%=aRs("c_code")%>')"><img src="/images/mypage/ico_delete.png">삭제</a></dl>-->
							</div>
							<div class="txt">
							<br/> 
							</div>
						</div>

					<%
								aRs.MoveNext
							Loop
						End If
						Set aRs = Nothing                
					%>	
						<div id="divCouponUse">
							<button type="button" onclick='javascript:eCouponUse("UU");' class="btn btn_middle btn-red">사용하기</button>				
							<div class="txt">
								- 타 쿠폰과 중복 사용불가
							</div>
						</div>
					</div>
				</section>
				<!-- //사용가능 e쿠폰 -->
				<!--
				<h3>모바일 상품권 번호를<br>입력하여 주세요.</h3>
				<form action="">
					<ul>
						<li><input type="text" id="txtPIN" name="txtPIN" placeholder="모바일 상품권 번호 입력" class="w-100p" maxlength="12"></li>
						<li class="mar-t15"><button type="button" onclick="javascript:eCoupon_Register_GoCart('N');" class="btn btn_middle btn-red">확인</button></li>
					</ul>
				</form>
				-->
			</div>
			<!--// e쿠폰 등록 -->



		</article>
		<!--// Content -->

	</div>
	<!--// Container -->

	<!-- Footer -->
	<!--#include virtual="/includes/footer.asp"-->
	<!--// Footer -->

<script>
    $(document).ready(function() {
        if($('div[class^="divCouponItem"] .coupon').length == 0){
			$("#divCouponUse").hide();
		}

		$('#txtPIN').keydown(function(key){
			if(key.keyCode == 13){
				eCouponUse("UA");
			}
		});
    });
</script>