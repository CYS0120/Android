<%
'주문멤버십사용
Class clsResOrderUseListForOrder
	Public mCode, mMessage, mOrderNo, mOrderDate, mPointUseList, mTotalPoint, mCouponUseList

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "result") Then
			If JSON.hasKey(obj.result, "orderNo") Then
				mOrderNo = obj.result.orderNo
			End If
			If JSON.hasKey(obj.result, "orderDate") Then
				mOrderDate = obj.result.orderDate
			End If

			'couponUseList
			If JSON.hasKey(obj.result, "couponUseList") Then
				ReDim mCouponUseList(obj.result.couponUseList.length-1)
				For i=0 To obj.result.couponUseList.length-1
					Dim tmpCouponUseList : Set tmpCouponUseList = New clsCouponUseList
					tmpCouponUseList.Init(obj.result.couponUseList.get(i))
					Set mCouponUseList(i) = tmpCouponUseList
				Next
			End If

			'pointUseList
			If JSON.hasKey(obj.result, "pointUseList") Then
				ReDim mPointUseList(obj.result.pointUseList.length-1)
				For i=0 To obj.result.pointUseList.length-1
					Dim tmpPointUseList : Set tmpPointUseList = New clsPointUseList
					tmpPointUseList.Init(obj.result.pointUseList.get(i))
					Set mPointUseList(i) = tmpPointUseList
				Next
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = 0
		mMessage = ""
		mOrderNo = ""
		mOrderDate = ""
		mPointUseList = Array()
		mCouponUseList = Array()
		mTotalPoint = 0
	End Sub

	Private Sub Class_Terminate
	End Sub

	Public Function toJson
		result = ""

		If result <> "" Then result = result & ","
		result = result & """code"":" & mCode

		If mMessage <> "" Then
			If result <> "" Then result = result & ","
			result = result & """message"":""" & mMessage & """"
		End If

		If result <> "" Then result = result & ","
		result = result & """result"":{"

		If mOrderNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """orderNo"":""" & mOrderNo & """"
		End If

		If mOrderDate <> "" Then
			If result <> "" Then result = result & ","
			result = result & """orderDate"":""" & mOrderDate & """"
		End If

		If UBound(mCouponUseList) > -1 Then
			If result <> "" Then result = result & ","
			result = result & """couponUseList"":["
			For i = 0 To UBound(mCouponUseList)
				If i > 0 Then result = result & ","
				result = result & mCouponUseList(i).toJson()
			Next
			result = result & "]"
		End If

		If UBound(mPointUseList) > -1 Then
			If result <> "" Then result = result & ","
			result = result & """pointUseList"":["
			For i = 0 To UBound(mPointUseList)
				If i > 0 Then result = result & ","
				result = result & mPointUseList(i).toJson()
			Next
			result = result & "]"
		End If

		result = result & "}"

		result = "{" & result & "}"

		toJson = result
	End Function
End Class
%>