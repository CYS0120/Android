<%
   push_type = request("PUSHTYPE") '푸시타입 QueryString(pushtype=push_type) 
    If push_type = "CARD" Then
        Response.redirect "https://m.bbq.co.kr/mypage/cardList.asp" '카드 페이지로 이동
    ElseIf push_type = "POINT" Then
        Response.redirect "https://m.bbq.co.kr/mypage/mileage.asp" '포인트 페이지로 이동
	'ElseIf push_type = "STAMP" Then
    '    Response.redirect "" 
	ElseIf push_type = "COUPON" Then
        Response.redirect "https://m.bbq.co.kr/mypage/couponList.asp?couponList=coupon" '쿠폰 페이지로 이동
	ElseIf push_type = "AMOUNT_CARD" Then
        Response.redirect "https://m.bbq.co.kr/mypage/couponList.asp?couponList=giftcard" '지류상품권 페이지로 이동
	'ElseIf push_type = "GIFTICON" Then
    '    Response.redirect ""
	ElseIf push_type = "EVENT" Then
        Response.redirect "https://m.bbq.co.kr/brand/eventList.asp" '이벤트 페이지로 이동
	'ElseIf push_type = "SMART_ORDER" Then
    '    Response.redirect ""
	'ElseIf push_type = "AUTHENTICATION" Then
    '    Response.redirect ""
	'ElseIf push_type = "RECEIPT" Then
    '    Response.redirect ""
    End If
%>