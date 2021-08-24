<%
'	========================================================================================
'	G2 Setting
'	========================================================================================
	Const G2_SITE_MODE = "local" ' {local, test, production}, {87서버일때, bbq서버 test일때,

	dim g2_bbq_a_url, g2_bbq_d_url, g2_bbq_m_url
	dim login_direct_ok : login_direct_ok = "Y" ' Y로 하면 "조성배" 으로 바로 로그인됨 / N으로 하면 입력하는 로직 (production 이 아닐때만.)

	if G2_SITE_MODE = "local" then 
		g2_bbq_a_url = "http://admin.localhost.co.kr"
		g2_bbq_d_url = "http://www.localhost.co.kr"
		g2_bbq_m_url = "http://m.localhost.co.kr"
	elseif G2_SITE_MODE = "test" then 
		g2_bbq_a_url = "http://atest.bbq.co.kr"
		g2_bbq_d_url = "http://htest.bbq.co.kr"
		g2_bbq_m_url = "http://mtest.bbq.co.kr"
	elseif G2_SITE_MODE = "production" then 
		g2_bbq_a_url = "https://webadmin.genesiskorea.co.kr:444"
		g2_bbq_d_url = "https://www.bbq.co.kr"
		g2_bbq_m_url = "https://m.bbq.co.kr"
	end if 

	' 페이코인 50퍼 이벤트 기간
	dim paycoin_start_date, paycoin_end_date
	paycoin_start_date = "2020-12-02"
	paycoin_end_date = "2020-12-02"

'	========================================================================================
	' 메인 2번째줄 상품 노출 번호 (아직 미정)
'	dim g2_bbq_main_goods_d : g2_bbq_main_goods_d = "1059"
'	dim g2_bbq_main_goods_m : g2_bbq_main_goods_m = "1059"
'	========================================================================================
	function g2_domain_filter(ByVal pStr)
		dim g2_bbq_d_url_arr : g2_bbq_d_url_arr = split(replace(replace(replace(pStr, "https://", ""), "http://", ""), "www.", ""), "/") ' 순수 도메인만 추출

		g2_domain_filter = g2_bbq_d_url_arr(0)
	end function 
'	========================================================================================


	function order_status_txt(strType, strText)
		if strText = "주문접수" then 
			order_status_txt = "주문접수"
		elseif strText = "매장전달" then 
			order_status_txt = "주문완료"
		elseif strText = "주문완료" then 
			if strType = "D" then 
				order_status_txt = "배달완료"
			elseif strType = "P" then 
				order_status_txt = "전달완료"
			else 
				order_status_txt = "주문완료"
			end if 

			order_status_txt = "주문완료" ' 강제로 주문완료로 나오게 수정.
		elseif strText = "취소요청" then 
			order_status_txt = "취소요청"
		elseif strText = "취소완료" then 
			order_status_txt = "주문취소"
		else 
			order_status_txt = strText
		end if 
	end function 

	function order_status_class(strType, strText)
		if strText = "주문접수" then 
			order_status_class = "reorder_con_order"
		elseif strText = "매장전달" then 
			order_status_class = "reorder_con_shop"
		elseif strText = "주문완료" then 
			order_status_class = "reorder_con_end"
		elseif strText = "취소요청" then 
			order_status_class = "reorder_con_request"
		elseif strText = "취소완료" then 
			order_status_class = "reorder_con_cancel"
		else 
			order_status_class = "reorder_con_order"
		end if 
	end function 

	':::::::::::::::::::::::::::::: 비비큐페이(Stargate) 관련 설정 / 2020.04.30 / Sewoni31™ ::::::::::::::::::::::::::::::
	' Dim test_accounts
	' test_accounts = "fcku19, yje0709, dkfk1571, pjc0222, lsj92319, whj11111, asaspc, test2020, mtest91, sewoni31, comeover, csungbae79, xrmjjss, santa0220, seunghu, ispace70, childgun, dkfk1571@naver.com, asasoc"

	' Dim arr_test_account
	' arr_test_account = Split(test_accounts, ", ")

	' Dim nArrCnt

	' SGPayOn = true

	' If SGPayOn = True Then
	' 	For nArrCnt=0 To Ubound(arr_test_account)
	' 		SGPayOn = False
	' 		If Trim(arr_test_account(nArrCnt)) = Trim(Session("userId")) Then
	' 			SGPayOn = True
	' 			Exit For
	' 		End If
	' 	Next
	' End If
%>