<%
sql = "EXEC bp_daum_map"
set rs = dbconn.execute(sql)

' Const DAUM_MAP_API_KEY = CStr(rs("API_KEY"))
' response.write DAUM_MAP_API_KEY
' response.end
%>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=<%=rs("API_KEY")%>&libraries=services,clusterer"></script>

<%
rs.close
set rs = nothing
%>