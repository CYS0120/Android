<%
'주문취소 탭
Class clsPointAcmCancelList
	Public mProductCd, mPayMethodCode, mCancelAcmDetailNo, mAcmCancelAmount

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "productCd") Then
			mProductCd = obj.productCd
		End If
		If JSON.hasKey(obj, "payMethodCode") Then
			mPayMethodCode = obj.payMethodCode
		End If
		If JSON.hasKey(obj, "cancelAcmDetailNo") Then
			mCancelAcmDetailNo = obj.cancelAcmDetailNo
		End If
		If JSON.hasKey(obj, "acmCancelAmount") Then
			mAcmCancelAmount = obj.acmCancelAmount
		End If
	End Function

	Sub Class_Initialize
		mProductCd = ""
		mPayMethodCode = ""
		mCancelAcmDetailNo = ""
		mAcmCancelAmount = 0
	End Sub

	Sub Class_Terminate
	End Sub

	Function toJson
		cResult = ""

		If mProductCd <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """productCd"":""" & mProductCd & """"
		End If
		If mPayMethodCode <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """payMethodCode"":""" & mPayMethodCode & """"
		End If
		If mCancelAcmDetailNo <> "" Then
			If cResult <> "" Then cResult = cResult & ","
			cResult = cResult & """cancelAcmDetailNo"":""" & mCancelAcmDetailNo & """"
		End If

		If cResult <> "" Then cResult = cResult & ","
		cResult = cResult & """acmCancelAmount"":" & mAcmCancelAmount

		cResult = "{" & cResult & "}"
		toJson = cResult
	End Function
End Class
%>