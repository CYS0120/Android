<%
'점원수동사용
Class clsResCouponRedeem
	Public mCode, mMessage, mClientMessage

	Public Function Init(ByRef obj)
		If JSON.hasKey(obj, "code") Then
			mCode = obj.code
		End If
		If JSON.hasKey(obj, "message") Then
			mMessage = obj.message
		End If
		If JSON.hasKey(obj, "info") Then
			If JSON.hasKey(obj.info, "clientMessage") Then
				mClientMessage = obj.info.clientMessage
			End If
		End If
	End Function

	Private Sub Class_Initialize
		mCode = ""
		mMessage = ""
		mClientMessage = ""
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

		If mClientMessage <> "" Then
			If result <> "" Then result = result & ","
			result = result & """clientMessage"":""" & mClientMessage & """"
		End If

		result = result & "}"

		result = "{" & result & "}"

		toJson = result
	End Function

End Class
%>