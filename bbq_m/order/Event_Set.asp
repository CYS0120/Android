<%
	sub Delivery_Event(ByRef dv_fee)

		' 배송비 프로모션 2021-04-10
		'' 20210417 ~ 20210516
		delivery_dc = 2000
		if date() >= "2021-04-17" and date() <= "2021-05-16" and (CheckLogin()) and date() <> "2021-05-06" then
			if dv_fee < delivery_dc then
				dv_fee = 0
			else
				dv_fee = dv_fee - delivery_dc
			end if
		end if

	end sub
%>