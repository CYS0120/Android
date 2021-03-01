<!--#include virtual="/api/include/utf8.asp"-->
<a href="#"onclick="opener.forms.adsf.value='111';windows.close();">닫기</a>
<%
    Dim code, domain, page
    Dim access_token, access_token_secret, refresh_token, token_type, expires_in

	token = request("token")
	deviceId = request("deviceId")

	'd-uZlsIQop4:APA91bEIHbDcUt-LXvJJ8fRzHD72Sf_JmF6T6eD8CV6VT6cvawRUW8T0MbU--bFlwufZPku48zZN-JwxVgWHs08barszB3s_VWEm6xnPH6o0LS89rVToOHWQg2m4mFWOQs5uIGx5ivm_
	token = "d-uZlsIQop4:APA91bEIHbDcUt-LXvJJ8fRzHD72Sf_JmF6T6eD8CV6VT6cvawRUW8T0MbU--bFlwufZPku48zZN-JwxVgWHs08barszB3s_VWEm6xnPH6o0LS89rVToOHWQg2m4mFWOQs5uIGx5ivm_"

'QUFBQXZLRjNETGNzRUloQmszUFB5R2p5Z1Y3aW8xNDUyTEZJZ2ptTmxBcEZld1BXeHdSSHBuTDdVWFNXYTR2MXBhYkVvS2VCRXU4SDRCTFZBcXUvQmFOWENSSlpsOFlrdDNkZkNzOUNPOWZqR3drclJ2WGpGNVhUdzhNMFB3cURwOGdBM1pZVTAvVHkzU2hUbi96ZG1pMVhTVHVxUmJ4dm1TbTdBd0tXbkhoZzJTbkQzL0JuR0tFUkoya1U4V2NaSFUwOGhqM1UrUE9tS2EySFUyZkZURkZidDdIODhvRkFhNTc5Zm9TRmRKOFVzTVJPd0k4OTIxMk95anJ4ZDRpYWdvOWc1UT09

	response.write "토큰"& token & "</br>"
	response.write "디바이스"& deviceId
	'9029ced59d0550d5
	'Response.end

Response.write Session("access_token")

Response.End

    access_token = Request("access_token")
    access_token_secret = Request("access_token_secret")
    refresh_token = Request("refresh_token")
    token_type = Request("token_type")
    expires_in = Request("expires_in")
	PAYCO_AUTH_URL = "https://alpha-api-membership.payco.com"

	Response.write PAYCO_AUTH_URL

	PAYCO_MEMBERSHIP_COMPANYCODE = "C10007"
	PAYCO_MEMBERSHIP_MERCHANTCODE = "M000162"

	Response.write Session("userIdNo")
	

	DBOpen

	access_token = Session("access_token") 

	'If access_token <> "" Then
		Set api = New ApiCall

		api.SetMethod = "POST"
		api.RequestContentType = "application/json"
		'api.Authorization = "Bearer " & access_token
		api.Authorization = "Bearer " & access_token
		api.SetData = "{""companyCd"":""C10007"",""brandCd"":""B00001"",""merchantCd"":""M00001"",""adYn"":""Y"",""title"":""OOOO"",""contents"":""OOOO"",""memberKey"":""10006000823113004"",""pushContentType"":""NORMAL"",""registrant"":""KCP""}"
		api.SetUrl = PAYCO_AUTH_URL & "/server/push/sendPush"

		result = api.Run

		Response.Write "Result > " & result & "<br>"

		
		' {"header":{"resultCode":0,"resultMessage":"SUCCESS","isSuccessful":true},"data":{"member":{"idNo":"10007004142832003","id":"jtest1","type":"INDIVIDUAL","status":"USE","certificationStatus":"CELLPHONE"}}}

		Set oJson = JSON.Parse(result)

		Dim idNo, uid, uname, ubirthday, ugender, uforeigner, uemail, ucellphone, utype, status, certificationStatus
		Dim isSmsAllowed, smsAllowedDt, isEmailAllowed, emailAllowedDt, isPushAllowed, pushAllowedDt
		Dim joinYmdt, joinChannel, joinDetailChannel, joinIp

		If JSON.hasKey(oJson.header, "isSuccessful") And oJson.header.isSuccessful Then
		

		Else
			loginSuccess = False
			loginMessage = "정보를 로드하지 못하였습니다."
			returnUrl = returnUrl & "&error=not_successful"
		End If

	'Else
	'	loginSuccess = False
	'	loginMessage = "인증에 실패하였습니다."
	'	returnUrl = returnUrl & "&error=no_token"
	'End If

    DBClose


Response.End

PushServerURL = "https://fcm.googleapis.com/fcm/send"

ApplicationAPIKey = "AAAAKh3Ofco:APA91bErGwlrCTs8hMLxXk6Qu6u4wnKYHfvM0yRos_AdvrKgeT7AMHJoyzD9KEGFilUajD-F-Ii8otOHk8RcPycNLPCYlihOhN2x1ZVMZYZqPrDP25oS5_u9fKPcActJ0iFDyer9JiVn"

arid="d-uZlsIQop4:APA91bEIHbDcUt-LXvJJ8fRzHD72Sf_JmF6T6eD8CV6VT6cvawRUW8T0MbU--bFlwufZPku48zZN-JwxVgWHs08barszB3s_VWEm6xnPH6o0LS89rVToOHWQg2m4mFWOQs5uIGx5ivm_"

tickertext = "test"

contentTitle = "관리사님께 신규 업무가 도착하였습니다"

message = "관리사님께 신규 업무가 도착하였습니다"

img = "test"

link = "test"

 postJSONData = "" & _
    "{" & _
    "  ""registration_ids"" : [ """ & arid & """ ]" & _
    ", ""notification"": {" & _
    "               , ""title"" : """ & contentTitle & """" & _
    "               , ""message"" : """ & message & """" & _
    "            }" & _
    "}"
Response.write postJSONData
 Set httpObj = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
 httpObj.open "POST" , PushServerURL, False
 httpObj.SetRequestHeader "Content-Type", "application/json"
 httpObj.SetRequestHeader "Authorization", "key=" & ApplicationAPIKey
 httpObj.SetRequestHeader "priority", "high"
 httpObj.SetRequestHeader "content_available", true
 httpObj.Send postJSONData
 httpObj.WaitForResponse
 
 Response.write httpObj.Status

 If httpObj.Status = "200" Then
  response.Write("전송성공 : " & httpObj.ResponseText)
 Else
  response.Write("전송실패 : " & httpObj.ResponseText)
 End If
%>