<%
'주문확정 탭
Class clsCouponAcmList
	Public mCouponId, mCouponNo, mCouponAcmPoint

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "couponId") Then
			mCouponId = obj.couponId
		End If
		If JSON.hasKey(obj, "couponNo") Then
			mCouponNo = obj.couponNo
		End If
		If JSON.hasKey(obj, "couponAcmPoint") Then
			mCouponAcmPoint = obj.couponAcmPoint
		End If
	End Function

	Private Sub Class_Initialize
		mCouponId = ""
		mCouponNo = ""
		mCouponAcmPoint = 0
	End Sub

	Private Sub Class_Terminate
	End SUb
End Class
%>