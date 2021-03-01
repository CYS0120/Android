<%@ codepage="65001" language="vbscript"%>
<%
Session.CodePage="65001"
Response.CharSet="utf-8"

Response.write request("gubun")
PushServerURL = "https://fcm.googleapis.com/fcm/send"
ApplicationAPIKey = "AAAAKh3Ofco:APA91bErGwlrCTs8hMLxXk6Qu6u4wnKYHfvM0yRos_AdvrKgeT7AMHJoyzD9KEGFilUajD-F-Ii8otOHk8RcPycNLPCYlihOhN2x1ZVMZYZqPrDP25oS5_u9fKPcActJ0iFDyer9JiVn"
arid="dvuo2d7KRfc:APA91bGpCDKmNBT3dYlwq3U5hE7cC2mE-UQP_iNCs85Ky2c9c-2EqT5APFtDy26efUp_ut03UIqYTkmOgqq8COTbqTBSaZI5TIv0kyUwiuyYBL-x-6Bbxyez8Lc70dsa0Dyr0sjXCJzG"
tickertext = "test"
contentTitle = "메세지가 도착하였습니다"
message = "메세지가 도착하였습니다"
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