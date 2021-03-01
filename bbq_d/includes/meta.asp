<%
	Set bCmd = Server.CreateObject("ADODB.Command")
	With bCmd
		.ActiveConnection = dbconn
		.NamedParameters = True
		.CommandType = adCmdStoredProc
		.CommandText = "bp_meta_seo"
		.Parameters.Append .CreateParameter("@BRAND_CODE", adVarchar, adParamInput, 10, SITE_BRAND_CODE)
		Set bMetaRs = .Execute
	End With
	Set bCmd = Nothing
	If Not (bMetaRs.BOF Or bMetaRs.EOF) Then
		seo_title	= bMetaRs("seo_title")
		seo_desc	= bMetaRs("seo_desc")
		seo_keywords	= bMetaRs("seo_keywords")
		seo_classification	= bMetaRs("seo_classification")
	Else
		seo_title	= "BBQ치킨"
		seo_desc	= "BBQ치킨"
		seo_keywords= "BBQ치킨"
		seo_classification= ""
	End If 
	bMetaRs.close
	Set bMetaRs = Nothing
%>
<meta charset="utf-8">
<meta name="format-detection" content="telephone=no" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="Keywords" content="<%=seo_keywords%>">
<meta name="Description" content="<%=seo_desc%>">
<meta name="Classification" content="<%=seo_classification%>">
<title><%=seo_title%></title>