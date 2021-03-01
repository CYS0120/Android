<!--#include file="payco_config.asp"-->
<!--#include virtual="/api/include/func.asp"-->
<%
	'-----------------------------------------------------------------------------
	' PAYCO 팝업차단 페이지 샘플 ( ASP )
	' payco_popup.asp
	' 2015-04-20	PAYCO기술지원 <dl_payco_ts@nhnent.com>
	'-----------------------------------------------------------------------------

	'-----------------------------------------------------------------------------
	' (로그) 호출 시점과 호출값을 파일에 기록합니다.
	'-----------------------------------------------------------------------------
	Dim xform, receive_str
	receive_str = "payco_popup.asp is Called - "
	For Each xform In Request.form
		receive_str = receive_str +  CStr(xform) + " : " + request(xform) + ", "
	Next
	Call Write_Log(receive_str)


	'-----------------------------------------------------------------------------
	' 테스트용 고객 주문 번호 생성
	' 테스트 할때 마다 Refresh(F5)를 해서 고객 주문 번호가 바뀌어야 정상적인 테스트를 하실 수 있습니다.
	'-----------------------------------------------------------------------------
	'Dim CustomerOrderNumber
	'CustomerOrderNumber = request("CustomerOrderNumber")

	gubun = GetReqStr("gubun","")
    domain = GetReqStr("domain","")

	order_idx = GetReqNum("order_idx", "")
	order_num = GetReqStr("order_num","")
	pay_method = GetReqStr("pay_method","")
	branch_id = GetReqStr("branch_id","")

%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=2.0,user-scalable=yes">
<title>PAYCO_DEMOWEB (ASP - EASYPAY PAY2)</title>
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script type="text/javascript">

function order(){
    
    var Params = "gubun=<%=gubun%>&domain=<%=domain%>&order_idx=<%=order_idx%>&order_num=<%=order_num%>&pay_method=<%=pay_method%>&branch_id=<%=branch_id%>";		//가맹점고객주문번호 입력

    // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류
    $.support.cors = true;

	/* + "&" + $('order_product_delivery_info').serialize() ); */
	$.ajax({
		type: "POST",
		url: "/pay/payco/payco_reserve.asp",
		data: Params,		// JSON 으로 보낼때는 JSON.stringify(customerOrderNumber)
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		dataType:"json",
		success:function(data){
			if(data.code == '0') {
				console.log(data.result.reserveOrderNo);
				document.location.href = data.result.orderSheetUrl;
			} else {
				alert("code:"+data.code+"\n"+"message:"+data.message);
			}
		},
        error: function(request,status,error) {
            //에러코드
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			return false;
        }
	});
}

</script>
</head>
<body onLoad="order()"></body>
</html>