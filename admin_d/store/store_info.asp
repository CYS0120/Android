<!-- #include virtual="/inc/config.asp" -->
<%
	CUR_PAGE_CODE = "C"
	BRCD = InjRequest("BRCD")
	CD = InjRequest("CD")
	If FncIsBlank(CD) Or FncIsBlank(BRCD) Then 
		Call subGoToMsg("잘못된 접근방식 입니다","back")
	End If
	CUR_PAGE_SUBCODE = CD	'현재 선택된 서브메뉴에 대한 권한을 체크하기 위해서 설정
%>
<!-- #include virtual="/inc/admin_check.asp" -->
<%
	BRAND_CODE	= FncBrandDBCode(CD)

	Sql = "Select * From bt_branch Where branch_id = " & BRCD & " And BRAND_CODE='"& BRAND_CODE &"' "
	Set Rinfo = conn.Execute(Sql)
	If Rinfo.eof Then 
		Call subGoToMsg("해당 매장 코드가 등록되어있진 않습니다","back")
	End If

	branch_id	= Rinfo("branch_id")
	brand_code	= Rinfo("brand_code")
	branch_name	= Rinfo("branch_name")
	branch_owner_name	= Rinfo("branch_owner_name")
	branch_phone	= Rinfo("branch_phone")
	branch_tel	= Rinfo("branch_tel")
	branch_address	= Rinfo("branch_address")
	branch_location	= Rinfo("branch_location")
	branch_description	= Rinfo("branch_description")
	branch_type_code	= Rinfo("branch_type_code")
	branch_seats	= Rinfo("branch_seats")
	branch_services_code	= Rinfo("branch_services_code")
	branch_weekday_open	= Rinfo("branch_weekday_open")
	branch_weekday_close	= Rinfo("branch_weekday_close")
	branch_weekend_open	= Rinfo("branch_weekend_open")
	branch_weekend_close	= Rinfo("branch_weekend_close")
	delivery_code	= Rinfo("delivery_code")
	delivery_start	= Rinfo("delivery_start")
	delivery_end	= Rinfo("delivery_end")
	close_day_code	= Rinfo("close_day_code")
	close_day	= Rinfo("close_day")
	branch_status	= Rinfo("branch_status")
	brn	= Rinfo("brn")
	wgs84_x	= Rinfo("wgs84_x")
	wgs84_y	= Rinfo("wgs84_y")
	online_status	= Rinfo("online_status")
	online_date	= Rinfo("online_date")
	online_time	= Rinfo("online_time")
	lunch_box_yn	= Rinfo("lunch_box_yn")
	membership_yn_code	= Rinfo("membership_yn_code")
	if membership_yn_code = "" then
		membership_yn_code = "50"
	end if
	order_yn	= Rinfo("order_yn")
	coupon_yn	= Rinfo("coupon_yn")
	yogiyo_yn	= Rinfo("yogiyo_yn")
	happy_yn_code	= Rinfo("happy_yn_code")
	danal_h_cpid	= Rinfo("danal_h_cpid")
	danal_h_scpid	= Rinfo("danal_h_scpid")
	payco_seller	= Rinfo("payco_seller")
	payco_cpid	= Rinfo("payco_cpid")
	payco_itemcd	= Rinfo("payco_itemcd")
	paycoin_cpid	= Rinfo("paycoin_cpid")
	sgpay_merchant	= Rinfo("sgpay_merchant_v2")
	newbranch_title	= Rinfo("newbranch_title")
	newbranch_explan	= Rinfo("newbranch_explan")
	img_path	= Rinfo("img_path")
	owner_img	= Rinfo("owner_img")
	branch_thumb	= Rinfo("branch_thumb")
	branch_img	= Rinfo("branch_img")
	newbranch_img	= Rinfo("newbranch_img")
	owner_greeting	= Rinfo("owner_greeting")
	use_yn	= Rinfo("use_yn")
	del_yn	= Rinfo("del_yn")
	cooking_time	= Rinfo("cooking_time")
	callcenter_message	= Rinfo("callcenter_message")
	delivery_fee	= Rinfo("delivery_fee")
	way_to_go	= Rinfo("way_to_go")
	add_price_yn	= Rinfo("add_price_yn") '제주/도서산간대상여부 2020-08-25 추가
	beer_yn	= Rinfo("beer_yn") '주류

	SELCODE_A = ""	'매장유형관리
	SELCODE_B = ""	'서비스 유형 관리
	SELCODE_C = ""	'휴무일 관리
	SELCODE_D = ""	'배달 가능 여부 관리
	SELCODE_E = ""	'멤버십 사용 여부 관리
	SELCODE_F = ""	'행복한 집밥 배달 가능 여부 관리
	Sql = "	Select I.code_kind, code_idx, code_name From bt_code_item I LEFT JOIN bt_code_detail D ON I.item_idx = D.item_idx " & _
		"	Where brand_code = '"& brand_code &"' And code_gb='S'  " & _
		"	Order by code_kind, code_ord "
	Set Clist = conn.Execute(Sql)
	If Not Clist.eof Then 
		Do While Not Clist.Eof
			code_kind = Clist("code_kind")
			code_idx = Clist("code_idx")
			code_name = Clist("code_name")
			If code_kind = "A" Then SELCODE_A = SELCODE_A & code_idx & "^" & code_name & "|"
			If code_kind = "B" Then SELCODE_B = SELCODE_B & code_idx & "^" & code_name & "|"
			If code_kind = "C" Then SELCODE_C = SELCODE_C & code_idx & "^" & code_name & "|"
			If code_kind = "D" Then SELCODE_D = SELCODE_D & code_idx & "^" & code_name & "|"
			If code_kind = "E" Then SELCODE_E = SELCODE_E & code_idx & "^" & code_name & "|"
			If code_kind = "F" Then SELCODE_F = SELCODE_F & code_idx & "^" & code_name & "|"
			Clist.MoveNext
		Loop 
	End If
	HOME_SITE_URL = FncGetSiteUrl(CD)
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- #include virtual="/inc/head.asp" -->
<script type="text/javascript">
function InputCheck(){
	var f = document.inputfrm;
	$.ajax({
		async: true,
		type: "POST",
		url: "store_info_proc.asp",
		data: $("#inputfrm").serialize(),
		dataType: "text",
		success: function (data) {
			alert(data.split("^")[1]);
			if(data.split("^")[0] == 'Y'){
				document.location.href='store.asp?CD=<%=CD%>';
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}

function calculateStore() {
	var f = document.inputfrm;
	$.ajax({
		async: true,
		type: "POST",
		url: "<%=CANCEL_BBQ_DOMAIN%>/pay/sgpay/sgpay_calculate.asp",
		data: "branch_id=<%=branch_id%>&merchant=<%=sgpay_merchant%>",
		dataType: "text",
		success: function (data) {
			if(data.split("^")[0] == 'Y') {
				alert(data.split("^")[1].replace(/\|/g, "\n"));
			}
		},
		error: function(data, status, err) {
			alert(err + '서버와의 통신이 실패했습니다.');
		}
	});
}
var checkClick = 0;
function CheckInput(tp, num){
	var run = 0;
	if (tp == "update") {
		if ( checkClick == 1 ) {
			alert('등록중입니다. 잠시 기다려 주시기 바랍니다.');
			return;
		}

		// 동, 배달비 미입력 시 알림 → each 사용하기
		$('[id^="delfee_tr_"]').each(function(index) {
			if($('[id^="dong"]:eq('+index+')').val() == "undefined" || $('[id^="dong"]:eq('+index+')').val() == "" || $('[id^="dong"]:eq('+index+')').val() == null){
				run = 0;
				alert("동을 입력해주세요");
				$('[id^="dong"]:eq('+index+')').focus();
				return false;
			}
			if($('[id^="add_delFee"]:eq('+index+')').val() <= 0 || $('[id^="add_delFee"]:eq('+index+')').val() == "" || $('[id^="add_delFee"]:eq('+index+')').val() == null){
				run = 0;
				alert("추가배달료를 입력해주세요");
				$('[id^="add_delFee"]:eq('+index+')').focus();
				return false;
			}
		})

		// 같은 동을 여러 번 세팅하면 알림
		for (var i = 1; i <= cnt; ++i) {
			var dong1 = "#dong" + i;
			for (var j = i+1; j <= cnt; ++j) {
				var dong2 = "#dong" + j;
				alert(dong1 + " && " + dong2);
				alert($(dong1).val() + " && " + $(dong2).val());
				if ($(dong1).val() == $(dong2).val()){run = 0;alert("하나의 동에 추가배달료 한 번만 설정해주세요");$(dong2).focus();return false;}
			}
		}

		run = 1;
	} else if (tp == "delete") {
		// 삭제 행에 내용 없으면 해당 div만 삭제하도록
		var delete_dong = "#dong" + num;
		var delete_tr = "#delfee_tr_" + num;
		if($(delete_dong).val() == "undefined" || $(delete_dong).val() == "" || $(delete_dong).val() == null) {
			$(delete_tr).remove();
			// var cnt = $("#cnt").val();
			// cnt = Number(cnt) - 1;
			// $("#cnt").val(cnt);
			return;
		} else{
			run = 1;
		}
	}

	if (run == 1) {
		checkClick = 1;
		$.ajax({
			async: true,
			type: "POST",
			url: "store_info_delFee_proc.asp",
			data: $("#inputfrm").serialize()+$("#inputfrm2").serialize()+"&tp="+tp+"&num="+num,
			dataType: "text",
			success: function (data) {
				alert(data);
				$('.mask, .window').hide();
				location.reload();
			},
			error: function(data, status, err) {
				alert(err + '서버와의 통신이 실패했습니다.');
				checkClick = 0;
			}
		});
	}
}

function AddDelDiv(){
	var html = "";
	var cnt = $("#cnt").val();
	cnt = Number(cnt) + 1;
	$("#cnt").val(cnt);

	html = html + "";

	html = html + "	<tr id='delfee_tr_" + cnt + "'>"
	html = html + "		<td>" + cnt + "</td>"
	html = html + "		<td>"
	html = html + "			<select id='sido" + cnt + "' name='sido" + cnt + "' onchange=onChange_sigungu('#sido" + cnt + "','#sigungu" + cnt + "')>"
	html = html + "				<option value=''></option>"
<%
			Sql = "select distinct sido_name from bt_address_dong with (nolock) "
			Set Sidolist = conn.Execute(Sql)
			If Not Sidolist.eof Then 
				Do While Not Sidolist.Eof
					sido_select = Sidolist("sido_name")
%>
	html = html + "				<option value='<%=sido_select%>'><%=sido_select%></option>"
<%	
					Sidolist.MoveNext
				Loop 
			End If
%>
	html = html + "			</select>"
	html = html + "		</td>"
	html = html + "		<td>"
	html = html + "			<select id='sigungu" + cnt + "' name='sigungu" + cnt + "' onchange=onChange_dong('#sido" + cnt + "','#sigungu" + cnt + "','#dong" + cnt + "')></select>"
	html = html + "		</td>"
	html = html + "		<td>"
	html = html + "			<select id='dong" + cnt + "' name='dong" + cnt + "'></select>"
	html = html + "		</td>"
	html = html + "		<td><input type='number' step='100' id='add_delFee" + cnt +"' name='add_delFee" + cnt + "' value='' style='width:80px;' onkeyup='onlyNum(this);'>원</td>"
	html = html + "		<td><input type='button' value='삭제' class='btn_white' onClick=CheckInput('delete'," + cnt + ")></td>"
	html = html + "	</tr>"

	$("#AddDel_table").append(html);
}

function AddDelFee(){
	wrapWindowByMask();
}

function onChange_sigungu(sido_id, sigungu_id)
{
	$.post(
		"/store/ajax_sigungu_list.asp"
		, {sido_name: $(sido_id).val()}
		, function(data) {
			$(sigungu_id).html(data);
	});
}

function onChange_dong(sido_id, sigungu_id, dong_id)
{
	$.post(
		"/store/ajax_dong_list.asp"
		, {sido_name: $(sido_id).val(), sigungu_name: $(sigungu_id).val()}
		, function(data) {
			$(dong_id).html(data);
	});
}
</script>
</head>
<body>
    <div class="wrap">
<!-- #include virtual="/inc/header.asp" -->
<!-- #include virtual="/inc/header_nav.asp" -->
		<div class="board_top">
			<div class="route"> 
				<span><p>관리자</p> > <p>매장관리</p> > <p><%=FncBrandName(CD)%></p></span>
			</div>
		</div>
	</div>
	<!--//GNB-->
</div>
<!--//NAV-->


		<!--popup-->
        <div class="mask"></div>
        <div class="window">
            <div class="sitemap_wrap">
                <!--content-->
                <div class="delfee_popup_area">
                    <form id="inputfrm2" name="inputfrm2">
					<div class="popup_title">
						<span>동별 추가 배달료 설정</span>
						<span><input type="button" value="추가" class="btn_white" onClick="AddDelDiv()"></span>
						<a class="close" onClick="location.reload();"><img src="../img/close.png" alt=""></a>
					</div>
					<table id="AddDel_table" name="AddDel_table">
						<tr>
							<th>NO</th>
							<th>시도</th>
							<th>시군구</th>
							<th>행정동(법정동)</th>
							<th>추가배달료</th>
							<th>관리</th>
						</tr>
<%
	Sql = "	select t2.branch_id, t1.sido_name, t1.sigungu_name, t1.h_code, t1.h_name, t1.b_code, t1.b_name, t1.h_name+'('+t1.b_name+')' as dong_name, t2.delivery_fee as add_delFee " & _
		  "	from bt_address_dong t1 with (nolock) " & _
		  "	inner join bt_branch_delivery_fee t2 with (nolock) " & _
		  "	on t1.h_code = t2.h_code and t1.b_code = t2.b_code " & _
		  "		and t2.branch_id = '" & BRCD & "' and t2.use_yn = 'Y' "
	Set DelFeelist = conn.Execute(Sql)
	cnt = 0
	If Not DelFeelist.eof Then 
		Do While Not DelFeelist.Eof
			add_delFee = DelFeelist("add_delFee")
			sido_name = DelFeelist("sido_name")
			sigungu_name = DelFeelist("sigungu_name")
			h_code = DelFeelist("h_code")
			b_code = DelFeelist("b_code")
			dong_code = DelFeelist("h_code") & "|" & DelFeelist("b_code")
			dong_name = DelFeelist("dong_name")
			
			cnt = cnt + 1
%>
						<tr id="delfee_tr_<%=cnt%>">
							<td><%=cnt%></td>
							<td>
								<select id="sido<%=cnt%>" name="sido<%=cnt%>" onchange="onChange_sigungu('#sido<%=cnt%>', '#sigungu<%=cnt%>')">
									<option value="<%=sido_name%>"><%=sido_name%></option>
<%
							Sql = "select distinct sido_name from bt_address_dong with (nolock) where sido_name not in ('" & sido_name & "') "
							Set Sidolist = conn.Execute(Sql)
							If Not Sidolist.eof Then 
								Do While Not Sidolist.Eof
									sido_select = Sidolist("sido_name")
%>
									<option value="<%=sido_select%>"><%=sido_select%></option>
<%	
									Sidolist.MoveNext
								Loop 
							End If
%>
								</select>
							</td>
							<td>
								<select id="sigungu<%=cnt%>" name="sigungu<%=cnt%>" onchange="onChange_dong('#sido<%=cnt%>', '#sigungu<%=cnt%>', '#dong<%=cnt%>')">
									<option value="<%=sigungu_name%>"><%=sigungu_name%></option>
								</select>
							</td>
							<td>
								<select id="dong<%=cnt%>" name="dong<%=cnt%>">
									<option value="<%=dong_code%>"><%=dong_name%></option>
								</select>
							</td>
							<td><input type="number" step="100" id="add_delFee<%=cnt%>" name="add_delFee<%=cnt%>" value="<%=add_delFee%>" style="width:80px;" onkeyup="onlyNum(this);">원</td>
							<td><input type="button" value="삭제" class="btn_white" onClick="CheckInput('delete',<%=cnt%>)"></td>
						</tr>
<%	
			DelFeelist.MoveNext
		Loop
	End If
%>
					</table>
					<div class="popup_btn">
						<input type="button" value="등록" class="btn_red125" onClick="CheckInput('update',0)">
						<input type="button" value="취소" class="btn_white125" onClick="$('.mask, .window').hide();location.reload();">
					</div>
					<input type="hidden" id="cnt" name="cnt" value="<%=cnt%>">
                    </form>
                </div>
                <!--//content-->
            </div>
        </div>
        <!--//popup-->

        <div class="content">
			<div class="section section_store">
				<div class="store_info">
<%
	UploadDir	= FncGetUploadDir(CD)
	UPIMG_DIR	= UploadDir &"/store"
%>
<form id="inputfrm" name="inputfrm" method="post">
<input type="hidden" name="CD" value="<%=CD%>">
<input type="hidden" id="UPIMG_DIR" value="<%=UPIMG_DIR%>">
<input type="hidden" name="branch_id" value="<%=branch_id%>">
<input type="hidden" name="ORG_owner_img" value="<%=owner_img%>">
<input type="hidden" name="ORG_branch_thumb" value="<%=branch_thumb%>">
<input type="hidden" name="ORG_branch_img" value="<%=branch_img%>">
<input type="hidden" name="ORG_newbranch_img" value="<%=newbranch_img%>">
					<table class="store_info_detail">
						<colgroup>
							<col width="15%">
							<col width="85%">
						</colgroup>
							<tr>
								<th>매장코드</th>
								<td><%=branch_id%></td>
							</tr>
							<tr>
								<th>브랜드 명 / 매장명</th>
								<td><%=FncBrandName(CD)%> / <%=branch_name%></td>
							</tr>
							<tr>
								<th>점주 명</th>
								<td><%=branch_owner_name%></td>
							</tr>
							<tr>
								<th>점주 사진</th>
								<td>
									<div class="filebox">
										<input id="owner_img" name="owner_img" class="upload-name" value="<%=owner_img%>" readonly>
										<label for="owner_img" onClick="OpenUploadIMG('owner_img','UPIMG_DIR')">찾아보기</label>
									</div>
									<span>이미지 사이즈(단위:픽셀)-가로 1920px, 세로600px, 확장자 jpg</span>
								</td>
							</tr>
							<tr>
								<th>점주님 인사말</th>
								<td>
									<input type="text" name="owner_greeting" value="<%=owner_greeting%>" style="width:95%">
								</td>
							</tr>
							<tr>
								<th>매장 상태</th>
								<td><%If branch_status="10" Then%>영업<%else%>폐점<%End If%></td>
							</tr>
							<tr>
								<th>매장 유형</th>
								<td>
<%									ArrSELCODE_A = Split(SELCODE_A,"|")
									For Cnt = 0 To Ubound(ArrSELCODE_A)
										SetCODE = ArrSELCODE_A(Cnt)
										If Not FncIsBlank(SetCODE) Then 
											ArrSetCODE = Split(SetCODE,"^")
											code_idx = ArrSetCODE(0)
											code_name = ArrSetCODE(1)
%>
										<label><input type="radio" name="branch_type_code" value="<%=code_idx%>"<%If ""&branch_type_code=""&code_idx Then%> checked<%End If%>><%=code_name%></label>
<%										End If 
									Next %>
								</td>
							</tr>
							<tr>
								<th>서비스 적용</th>
								<td>
									<label><input type="radio" name="use_yn" value="Y"<%If use_yn="Y" Then%> checked<%End If%>>YES</label>
									<label><input type="radio" name="use_yn" value="N"<%If use_yn="N" Then%> checked<%End If%>>NO</label>
								</td>
							</tr>
							<tr>
								<th>서비스 유형</th>
								<td>
<%
									ArrSELCODE_B = Split(SELCODE_B,"|")
									For Cnt = 0 To Ubound(ArrSELCODE_B)
										SetCODE = ArrSELCODE_B(Cnt)
										If Not FncIsBlank(SetCODE) Then 
											ArrSetCODE = Split(SetCODE,"^")
											code_idx = ArrSetCODE(0)
											code_name = ArrSetCODE(1)
%>
										<label><input type="checkbox" name="branch_services_code" value="<%=code_idx%>"<%If FncInStr(branch_services_code,code_idx) Then%> checked<%End If%>><%=code_name%></label>
<%										End If 
									Next %>
								</td>
							</tr>
							<tr>
								<th>영업시간</th>
								<td>
									<span><select name="open_hour" id="open_hour">
										<option value="00" <% If Left(branch_weekday_open,2) = "00" Then %>selected<% End If %>>00시</option>
										<option value="01" <% If Left(branch_weekday_open,2) = "01" Then %>selected<% End If %>>01시</option>
										<option value="02" <% If Left(branch_weekday_open,2) = "02" Then %>selected<% End If %>>02시</option>
										<option value="03" <% If Left(branch_weekday_open,2) = "03" Then %>selected<% End If %>>03시</option>
										<option value="04" <% If Left(branch_weekday_open,2) = "04" Then %>selected<% End If %>>04시</option>
										<option value="05" <% If Left(branch_weekday_open,2) = "05" Then %>selected<% End If %>>05시</option>
										<option value="06" <% If Left(branch_weekday_open,2) = "06" Then %>selected<% End If %>>06시</option>
										<option value="07" <% If Left(branch_weekday_open,2) = "07" Then %>selected<% End If %>>07시</option>
										<option value="08" <% If Left(branch_weekday_open,2) = "08" Then %>selected<% End If %>>08시</option>
										<option value="09" <% If Left(branch_weekday_open,2) = "09" Then %>selected<% End If %>>09시</option>
										<option value="10" <% If Left(branch_weekday_open,2) = "10" Then %>selected<% End If %>>10시</option>
										<option value="11" <% If Left(branch_weekday_open,2) = "11" Then %>selected<% End If %>>11시</option>
										<option value="12" <% If Left(branch_weekday_open,2) = "12" Then %>selected<% End If %>>12시</option>
										<option value="13" <% If Left(branch_weekday_open,2) = "13" Then %>selected<% End If %>>13시</option>
										<option value="14" <% If Left(branch_weekday_open,2) = "14" Then %>selected<% End If %>>14시</option>
										<option value="15" <% If Left(branch_weekday_open,2) = "15" Then %>selected<% End If %>>15시</option>
										<option value="16" <% If Left(branch_weekday_open,2) = "16" Then %>selected<% End If %>>16시</option>
										<option value="17" <% If Left(branch_weekday_open,2) = "17" Then %>selected<% End If %>>17시</option>
										<option value="18" <% If Left(branch_weekday_open,2) = "18" Then %>selected<% End If %>>18시</option>
										<option value="19" <% If Left(branch_weekday_open,2) = "19" Then %>selected<% End If %>>19시</option>
										<option value="20" <% If Left(branch_weekday_open,2) = "20" Then %>selected<% End If %>>20시</option>
										<option value="21" <% If Left(branch_weekday_open,2) = "21" Then %>selected<% End If %>>21시</option>
										<option value="22" <% If Left(branch_weekday_open,2) = "22" Then %>selected<% End If %>>22시</option>
										<option value="23" <% If Left(branch_weekday_open,2) = "23" Then %>selected<% End If %>>23시</option>
										<option value="24" <% If Left(branch_weekday_open,2) = "24" Then %>selected<% End If %>>24시</option>
									</select>시</span>
									<span><select name="open_minute" id="open_minute">
										<option value="00" <% If Right(branch_weekday_open,2) = "00" Then %>selected<% End If %>>00분</option>
										<option value="10" <% If Right(branch_weekday_open,2) = "10" Then %>selected<% End If %>>10분</option>
										<option value="20" <% If Right(branch_weekday_open,2) = "20" Then %>selected<% End If %>>20분</option>
										<option value="30" <% If Right(branch_weekday_open,2) = "30" Then %>selected<% End If %>>30분</option>
										<option value="40" <% If Right(branch_weekday_open,2) = "40" Then %>selected<% End If %>>40분</option>
										<option value="50" <% If Right(branch_weekday_open,2) = "50" Then %>selected<% End If %>>50분</option>
									</select>분</span>
									<span></span>
									<span><select name="close_hour" id="close_hour">
										<option value="00" <% If Left(branch_weekday_close,2) = "00" Then %>selected<% End If %>>00시</option>
										<option value="01" <% If Left(branch_weekday_close,2) = "01" Then %>selected<% End If %>>01시</option>
										<option value="02" <% If Left(branch_weekday_close,2) = "02" Then %>selected<% End If %>>02시</option>
										<option value="03" <% If Left(branch_weekday_close,2) = "03" Then %>selected<% End If %>>03시</option>
										<option value="04" <% If Left(branch_weekday_close,2) = "04" Then %>selected<% End If %>>04시</option>
										<option value="05" <% If Left(branch_weekday_close,2) = "05" Then %>selected<% End If %>>05시</option>
										<option value="06" <% If Left(branch_weekday_close,2) = "06" Then %>selected<% End If %>>06시</option>
										<option value="07" <% If Left(branch_weekday_close,2) = "07" Then %>selected<% End If %>>07시</option>
										<option value="08" <% If Left(branch_weekday_close,2) = "08" Then %>selected<% End If %>>08시</option>
										<option value="09" <% If Left(branch_weekday_close,2) = "09" Then %>selected<% End If %>>09시</option>
										<option value="10" <% If Left(branch_weekday_close,2) = "10" Then %>selected<% End If %>>10시</option>
										<option value="11" <% If Left(branch_weekday_close,2) = "11" Then %>selected<% End If %>>11시</option>
										<option value="12" <% If Left(branch_weekday_close,2) = "12" Then %>selected<% End If %>>12시</option>
										<option value="13" <% If Left(branch_weekday_close,2) = "13" Then %>selected<% End If %>>13시</option>
										<option value="14" <% If Left(branch_weekday_close,2) = "14" Then %>selected<% End If %>>14시</option>
										<option value="15" <% If Left(branch_weekday_close,2) = "15" Then %>selected<% End If %>>15시</option>
										<option value="16" <% If Left(branch_weekday_close,2) = "16" Then %>selected<% End If %>>16시</option>
										<option value="17" <% If Left(branch_weekday_close,2) = "17" Then %>selected<% End If %>>17시</option>
										<option value="18" <% If Left(branch_weekday_close,2) = "18" Then %>selected<% End If %>>18시</option>
										<option value="19" <% If Left(branch_weekday_close,2) = "19" Then %>selected<% End If %>>19시</option>
										<option value="20" <% If Left(branch_weekday_close,2) = "20" Then %>selected<% End If %>>20시</option>
										<option value="21" <% If Left(branch_weekday_close,2) = "21" Then %>selected<% End If %>>21시</option>
										<option value="22" <% If Left(branch_weekday_close,2) = "22" Then %>selected<% End If %>>22시</option>
										<option value="23" <% If Left(branch_weekday_close,2) = "23" Then %>selected<% End If %>>23시</option>
										<option value="24" <% If Left(branch_weekday_close,2) = "24" Then %>selected<% End If %>>24시</option>
									</select>시</span>
									<span><select name="close_minute" id="close_minute">
										<option value="00" <% If Right(branch_weekday_close,2) = "00" Then %>selected<% End If %>>00분</option>
										<option value="10" <% If Right(branch_weekday_close,2) = "10" Then %>selected<% End If %>>10분</option>
										<option value="20" <% If Right(branch_weekday_close,2) = "20" Then %>selected<% End If %>>20분</option>
										<option value="30" <% If Right(branch_weekday_close,2) = "30" Then %>selected<% End If %>>30분</option>
										<option value="40" <% If Right(branch_weekday_close,2) = "40" Then %>selected<% End If %>>40분</option>
										<option value="50" <% If Right(branch_weekday_close,2) = "50" Then %>selected<% End If %>>50분</option>
									</select>분</span>
								</td>
							</tr>
							<tr>
								<th>좌석수</th>
								<td>
									<input type="number" name="branch_seats" value="<%=branch_seats%>" onkeyup="onlyNum(this);">
									<span>(숫자만 입력)</span>
								</td>
							</tr>
							<tr>
								<th>휴무일</th>
								<td>
<%										ArrSELCODE_C = Split(SELCODE_C,"|")
										For Cnt = 0 To Ubound(ArrSELCODE_C)
											SetCODE = ArrSELCODE_C(Cnt)
											If Not FncIsBlank(SetCODE) Then 
												ArrSetCODE = Split(SetCODE,"^")
												code_idx = ArrSetCODE(0)
												code_name = ArrSetCODE(1)
%>
											<label><input type="radio" name="close_day_code" value="<%=code_idx%>"<%If ""&close_day_code=""&code_idx Then%> checked<%End If%> onClick="$('#close_day').val('<%=code_name%>')"><%=code_name%></label>
<%											End If 
										Next %>
									<label><input type="radio" name="close_day_code" value="0"<%If close_day_code = "0" Then%> checked<%End If%>>직접입력</label>
									<span><input type="text" id="close_day" name="close_day" value="<%=close_day%>"></span>
								</td>
							</tr>
							<tr>
								<th>찾아오시는길</th>
								<td>
									<label><input type="radio" name="way_to_go_sel" onClick="$('#way_to_go').val('<%=branch_address%>')">매장주소와동일</label>
									<label><input type="radio" name="way_to_go_sel" onClick="$('#way_to_go').val('')" checked>새로입력</label>
									<span><input type="text" id="way_to_go" name="way_to_go" value="<%=way_to_go%>" style="width:400px;"></span>
								</td>
							</tr>
							<tr>
								<th>매장 썸네일 이미지</th>
								<td>
									<div class="filebox">
										<input id="branch_thumb" name="branch_thumb" class="upload-name" value="<%=branch_thumb%>" readonly>
										<label for="branch_thumb" onClick="OpenUploadIMG('branch_thumb','UPIMG_DIR')">찾아보기</label>
									</div>
									<span>이미지 사이즈(단위:픽셀)-가로 1920px, 세로600px, 확장자 jpg</span>
								</td>
							</tr>
							<tr>
								<th>매장 대표 이미지</th>
								<td>
									<div class="filebox">
										<input id="branch_img" name="branch_img" class="upload-name" value="<%=branch_img%>" readonly>
										<label for="branch_img" onClick="OpenUploadIMG('WMAINIMG1','UPIMG_DIR')">찾아보기</label>
									</div>
									<span>이미지 사이즈(단위:픽셀)-가로 1920px, 세로600px, 확장자 jpg</span>
								</td>
							</tr>
							<tr>
								<th>매장주소</th>
								<td><%=branch_address%></td>
							</tr>
							<tr>
								<th>매장 전화번호</th>
								<td><%=branch_tel%></td>
							</tr>
							<tr>
								<th>위치코드</th>
								<td>
									[<span>X = <input type="number" name="wgs84_x" value="<%=wgs84_x%>"></span>,
									<span>Y = <input type="number" name="wgs84_y" value="<%=wgs84_y%>"></span>]
									<span style="padding-left:20px;"><a href="https://www.google.com/maps/place/<%=branch_address%>" target="_googlemap">[구글지도 검색]</a></span>
									<span>갱신을 원할 시 구글지도 검색결과가 1건일 경우 주소창 상단에 @3X.XXXXXX,12X.XXXXXX 의 값을 Y와 X 값으로 넣으시기 바랍니다.</span>
								</td>
							</tr>
							<tr>
								<th>배달가능여부</th>
								<td>
<%									ArrSELCODE_D = Split(SELCODE_D,"|")
									For Cnt = 0 To Ubound(ArrSELCODE_D)
										SetCODE = ArrSELCODE_D(Cnt)
										If Not FncIsBlank(SetCODE) Then 
											ArrSetCODE = Split(SetCODE,"^")
											code_idx = ArrSetCODE(0)
											code_name = ArrSetCODE(1)
											If FncIsBlank(delivery_code) Then delivery_code = code_idx
%>
											<label><input type="radio" name="delivery_code" value="<%=code_idx%>"<%If ""&delivery_code=""&code_idx Then%> checked<%End If%>><%=code_name%></label>
<%										End If 
									Next %>
								</td>
							</tr>
							<tr>
								<th>배달비</th>
								<td>
									<input type="number" step="100" name="delivery_fee" value="<%=delivery_fee%>" onkeyup="onlyNum(this);">원 
									<span>(숫자만 입력)</span>
									<input type="button" value="추가 배달비" class="btn_white125" style="margin-left:10px;" onClick="AddDelFee()"></input>
								</td>
							</tr>
							<tr>
								<th>멤버십 사용여부</th>
								<td>
<%									ArrSELCODE_E = Split(SELCODE_E,"|")
									For Cnt = 0 To Ubound(ArrSELCODE_E)
										SetCODE = ArrSELCODE_E(Cnt)
										If Not FncIsBlank(SetCODE) Then 
											ArrSetCODE = Split(SetCODE,"^")
											code_idx = ArrSetCODE(0)
											code_name = ArrSetCODE(1)
											If FncIsBlank(membership_yn_code) Then membership_yn_code = code_idx
%>
											<label><input type="radio" name="membership_yn_code" value="<%=code_idx%>"<%If ""&membership_yn_code=""&code_idx Then%> checked<%End If%>><%=code_name%></label>
<%										End If 
									Next %>
								</td>
							</tr>
							<tr>
								<th>온라인 주문접수 여부</th>
								<td>
									<label><input type="radio" name="order_yn" value="Y"<%If order_yn="Y" Then%> checked<%End If%>>YES</label>
									<label><input type="radio" name="order_yn" value="N"<%If order_yn="N" Then%> checked<%End If%>>NO</label>
								</td>
							</tr>
							<tr>
								<th>제주/도서산간 대상여부</th>
								<td>
									<label><input type="radio" name="add_price_yn" value="Y"<%If add_price_yn="Y" Then%> checked<%End If%>>YES</label>
									<label><input type="radio" name="add_price_yn" value="N"<%If add_price_yn="N" Then%> checked<%End If%>>NO</label>
								</td>
							</tr>
							<tr>
								<th>주류 판매여부</th>
								<td>
									<label><input type="radio" name="beer_yn" value="Y"<%If beer_yn="Y" Then%> checked<%End If%>>YES</label>
									<label><input type="radio" name="beer_yn" value="N"<%If beer_yn="N" Then%> checked<%End If%>>NO</label>
								</td>
							</tr>
							<tr>
								<th>쿠폰 사용 여부</th>
								<td>
									<label><input type="radio" name="coupon_yn" value="Y"<%If coupon_yn="Y" Then%> checked<%End If%>>YES</label>
									<label><input type="radio" name="coupon_yn" value="N"<%If coupon_yn="N" Then%> checked<%End If%>>NO</label>
								</td>
							</tr>
							<tr>
								<th>요기요 행사매장</th>
								<td>
									<label><input type="radio" name="yogiyo_yn" value="Y"<%If yogiyo_yn="Y" Then%> checked<%End If%>>YES</label>
									<label><input type="radio" name="yogiyo_yn" value="N"<%If yogiyo_yn="N" Then%> checked<%End If%>>NO</label>
								</td>
							</tr>
							<tr>
								<th>매장 포스 상태</th>
								<td>
									접속여부 : <%=online_status%> , 접속일 : <%=online_date%>&nbsp;<%=online_time%>
								</td>
							</tr>
							<!--<tr>
								<th>행복한집밥 배달여부</th>
								<td>
<%									ArrSELCODE_F = Split(SELCODE_F,"|")
									For Cnt = 0 To Ubound(ArrSELCODE_F)
										SetCODE = ArrSELCODE_F(Cnt)
										If Not FncIsBlank(SetCODE) Then 
											ArrSetCODE = Split(SetCODE,"^")
											code_idx = ArrSetCODE(0)
											code_name = ArrSetCODE(1)
											If FncIsBlank(happy_yn_code) Then happy_yn_code = code_idx
%>
											<label><input type="radio" name="happy_yn_code" value="<%=code_idx%>"<%If ""& happy_yn_code = ""&code_idx Then%> checked<%End If%>><%=code_name%></label>
<%										End If 
									Next %>
								</td>
							</tr>-->
						
					</table>

					<div class="new_store">
						<div>
							<span>신규매장소개</span>
						</div>
						<table>
							<colgroup>
								<col width="15%">
								<col width="85%">
							</colgroup>
							
							<tr>
								<th>제목</th>
								<td><input type="text" name="newbranch_title" id="newbranch_title" value="<%=newbranch_title%>"></td>
							</tr>
							<tr>
								<th>내용</th>
								<td><textarea name="newbranch_explan" id="newbranch_explan" style="width:95%;height:50px"><%=newbranch_explan%></textarea></td>
							</tr>
							<tr>
								<th>사진등록</th>
								<td>
									<div class="filebox">
										<input id="newbranch_img" name="newbranch_img" class="upload-name" value="<%=WMAINIMG1%>" readonly>
										<label for="newbranch_img" onClick="OpenUploadIMG('newbranch_img','UPIMG_DIR')">찾아보기</label>
										<span>이미지 사이즈(단위:픽셀)-가로 1920px, 세로600px, 확장자 jpg</span>
									</div>
								</td>
							</tr>
							
						</table>
						<table style="margin-top:40px;">
							<colgroup>
								<col width="15%">
								<col width="85%">
							</colgroup>
							<tr>
								<th>다날ID등록</th>
								<td><input type="text" name="danal_h_cpid" id="danal_h_cpid" value="<%=danal_h_cpid%>" style="width:150px"> <input type="text" name="danal_h_scpid" id="danal_h_scpid" value="<%=danal_h_scpid%>" style="width:150px"></td>
							</tr>
						</table>
					</div>
					<div class="payco_in">
						<div>
							<span>페이코 등록</span>
						</div>
						<table>
							<colgroup>
								<col width="15%">
								<col width="85%">
							</colgroup>
							
							<tr>
								<th>SellerKey</th>
								<td><input type="text" name="payco_seller" id="payco_seller" value="<%=payco_seller%>"></td>
							</tr>
							<tr>
								<th>CPID</th>
								<td><input type="text" name="payco_cpid" id="payco_cpid" value="<%=payco_cpid%>"></td>
							</tr>
							<tr>
								<th>Product ID</th>
								<td>
									<input type="text" name="payco_itemcd" id="payco_itemcd" value="<%=payco_itemcd%>">
								</td>
							</tr>
							
						</table>
					</div>

					<div class="paycoin_in">
						<div>
							<span>페이코인 등록</span>
						</div>
						<table>
							<colgroup>
								<col width="15%">
								<col width="85%">
							</colgroup>

							<tr>
								<th>CPID</th>
								<td><input type="text" name="paycoin_cpid" id="paycoin_cpid" value="<%=paycoin_cpid%>"></td>
							</tr>
							
						</table>
					</div>

					<div class="paycoin_in">
						<div>
							<span>BBQ PAY<% If sgpay_merchant <> "" Then %> <button type="button" class="btn_red" onclick="javascript: calculateStore();"> 정 산 </button><% End If %></span>
						</div>
						<table>
							<colgroup>
								<col width="15%">
								<col width="85%">
							</colgroup>

							<tr>
								<th>Merchant 키 등록</th>
								<td><input type="text" name="sgpay_merchant" id="sgpay_merchant" value="<%=sgpay_merchant%>"></td>
							</tr>
							
						</table>
					</div>

					<div style="margin-top:20px">
						<input type="button" class="btn_red125" onClick="InputCheck()" value="저 장">
					</div>
					</form>
				</div>
			</div>
        </div>
<!-- #include virtual="/inc/footer.asp" -->
    </div>
</body>
</html>