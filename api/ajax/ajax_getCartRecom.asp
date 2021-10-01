<!--#include virtual="/api/include/utf8.asp"-->
<%
	REFERERURL	= Request.ServerVariables("HTTP_REFERER")

	If left(REFERERURL,19) = left(GetCurrentHost,19) Then 
	Else 
'		cart_recom_list = "[]"
'		Response.ContentType = "application/json"
'		Response.Write cart_recom_list
'		Response.End 
	End If

	cart_recom_list = "[]"

    pageSize = Request("pageSize")
    curPage = Request("curPage")
	menu_key = GetReqStr("menu_key","")
	Set menu_key = JSON.Parse(menu_key)


	Set aCmd = Server.CreateObject("ADODB.Command")
	With aCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_cart_recom"

		.Parameters.Append .CreateParameter("@menu_list", adVarChar, adParamInput, 255, menu_key)
		.Parameters.Append .CreateParameter("@top_number", adVarChar, adParamInput, 255, 10)

		Set aRs = .Execute
	End With
	Set aCmd = Nothing

	If Not (aRs.BOF Or aRs.EOF) Then
		aRs.MoveFirst
		cart_recom_list = "["
		Do Until aRs.EOF
			If cart_recom_list <> "[" Then cart_recom_list = cart_recom_list & ","

				Set bCmd = Server.CreateObject("ADODB.Command")
				With bCmd
					.ActiveConnection = dbconn
					.NamedParameters = True
					.CommandType = adCmdStoredProc
					.CommandText = "bp_menu_List"
					.Parameters.Append .CreateParameter("@ListType", adVarChar, adParamInput, 5, "ONE")
					.Parameters.Append .CreateParameter("@menu_idx", adInteger, adParamInput, , aRs("menu_idx_sub"))
					.Parameters.Append .CreateParameter("@totalCount", adInteger, adParamOutput)
					.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 5, "01")
					Set bMenuRs = .Execute
				End With
				Set bCmd = Nothing

				If Not (bMenuRs.BOF Or bMenuRs.EOF) Then
					cart_recom_list = cart_recom_list & "{"
					cart_recom_list = cart_recom_list & """menu_idx"":""" & bMenuRs("menu_idx") & ""","
					cart_recom_list = cart_recom_list & """menu_title"":""" & bMenuRs("menu_title") & ""","
					cart_recom_list = cart_recom_list & """menu_type"":""" & bMenuRs("menu_type") & ""","
					cart_recom_list = cart_recom_list & """menu_name"":""" & bMenuRs("menu_name") & ""","
					cart_recom_list = cart_recom_list & """menu_price"":""" & bMenuRs("menu_price") & ""","
					cart_recom_list = cart_recom_list & """menu_price_format"":""" & FormatNumber(bMenuRs("menu_price"), 0) & ""","
'					cart_recom_list = cart_recom_list & """menu_desc"":""" & bMenuRs("menu_desc") & """," ' 내용이 많음.
					cart_recom_list = cart_recom_list & """kind_sel"":""" & bMenuRs("kind_sel") & ""","
					cart_recom_list = cart_recom_list & """origin"":""" & bMenuRs("origin") & ""","
					cart_recom_list = cart_recom_list & """calorie"":""" & bMenuRs("calorie") & ""","
					cart_recom_list = cart_recom_list & """sugars"":""" & bMenuRs("sugars") & ""","
					cart_recom_list = cart_recom_list & """protein"":""" & bMenuRs("protein") & ""","
					cart_recom_list = cart_recom_list & """saturatedfat"":""" & bMenuRs("saturatedfat") & ""","
					cart_recom_list = cart_recom_list & """natrium"":""" & bMenuRs("natrium") & ""","
					cart_recom_list = cart_recom_list & """allergy"":""" & bMenuRs("allergy") & ""","
					cart_recom_list = cart_recom_list & """exp1_yn"":""" & bMenuRs("exp1_yn") & ""","
					cart_recom_list = cart_recom_list & """exp1_url"":""" & bMenuRs("exp1_url") & ""","
					cart_recom_list = cart_recom_list & """exp2_yn"":""" & bMenuRs("exp2_yn") & ""","
					cart_recom_list = cart_recom_list & """exp2_imgurl"":""" & bMenuRs("exp2_imgurl") & ""","
					cart_recom_list = cart_recom_list & """exp3_yn"":""" & bMenuRs("exp3_yn") & ""","
					cart_recom_list = cart_recom_list & """exp3_imgurl"":""" & bMenuRs("exp3_imgurl") & ""","
					cart_recom_list = cart_recom_list & """exp4_yn"":""" & bMenuRs("exp4_yn") & ""","
					cart_recom_list = cart_recom_list & """exp4_imgurl"":""" & bMenuRs("exp4_imgurl") & ""","
					cart_recom_list = cart_recom_list & """exp5_yn"":""" & bMenuRs("exp5_yn") & ""","
					cart_recom_list = cart_recom_list & """exp5_imgurl"":""" & bMenuRs("exp5_imgurl") & ""","
					cart_recom_list = cart_recom_list & """MAIN_FILEPATH"":""" & bMenuRs("MAIN_FILEPATH") & ""","
					cart_recom_list = cart_recom_list & """MAIN_FILENAME"":""" & bMenuRs("MAIN_FILENAME") & ""","
					cart_recom_list = cart_recom_list & """THUMB_FILEPATH"":""" & bMenuRs("THUMB_FILEPATH") & ""","
					cart_recom_list = cart_recom_list & """THUMB_FILENAME"":""" & bMenuRs("THUMB_FILENAME") & """ "
					cart_recom_list = cart_recom_list & "}"
				end if 

			aRs.MoveNext
		Loop
		cart_recom_list = cart_recom_list & "]"
	End If

	Set aRs = Nothing


    Response.Write cart_recom_list
%>