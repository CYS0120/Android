<%
'카드선물유효성체크
Class clsReqCardVerifyGift
	Public mCompanyCode, mBrandCode, mMemberNo, mReceiverName, mReceiverPhoneNo, mPayMethods

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "companyCode") Then
			mCompanyCode = obj.companyCode
		End If
		If JSON.hasKey(obj, "brandCode") Then
			mBrandCode = obj.brandCode
		End If
		If JSON.hasKey(obj, "memberNo") Then
			mMemberNo = obj.memberNo
		End If
		If JSON.hasKey(obj, "receiverName") Then
			mReceiverName = obj.receiverName
		End If
		If JSON.hasKey(obj, "receiverPhoneNo") Then
			mReceiverPhoneNo = obj.receiverPhoneNo
		End If

		'payMethods
		If JSON.hasKey(obj, "payMethods") Then
			ReDim mPayMethods(obj.payMethods.length - 1)
			For i = 0 To obj.payMethods.length - 1
				Dim tmpPayMethods : Set tmpPayMethods = New clsPayMethods
				tmpPayMethods.Init(obj.payMethods.get(i))
				Set mPayMethods(i) = tmpPayMethods
			Next
		End If
	End Function

	Sub Class_Initialize
		mCompanyCode = ""
		mBrandCode = ""
		mMemberNo = ""
		mReceiverName = ""
		mReceiverPhoneNo = ""
		mPayMethods = Array()
	End Sub

	Sub Class_Terminate
	End Sub

	Public Sub addPayMethods(productInfo)
		ReDim Preserve mPayMethods(UBound(mPayMethods) + 1)
		Set mPayMethods(UBound(mPayMethods)) = productInfo
	End Sub

	Function toJson
		Dim i
		Dim result : result = ""

		If mCompanyCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """companyCode"":""" & mCompanyCode & """"
		End If
		If mBrandCode <> "" Then
			If result <> "" Then result = result & ","
			result = result & """brandCode"":""" & mBrandCode & """"
		End If
		If mMemberNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """memberNo"":""" & mMemberNo & """"
		End If
		If mReceiverName <> "" Then
			If result <> "" Then result = result & ","
			result = result & """receiverName"":""" & mReceiverName & """"
		End If
		If mReceiverPhoneNo <> "" Then
			If result <> "" Then result = result & ","
			result = result & """receiverPhoneNo"":""" & mReceiverPhoneNo & """"
		End If

		'payMethods
		If result <> "" Then result = result & ","
			result = result & """payMethods"":["
			For i = 0 To UBound(mPayMethods)
				If i > 0 Then result = result & ","
				result = result & mPayMethods(i).toJson()
			Next
			result = result & "]"

		result = "{" & result & "}"
		toJson = result
	End Function
End Class
%>