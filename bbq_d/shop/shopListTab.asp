<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include virtual="/api/include/db_open.asp"-->
<%
    Dim branch_id : branch_id = Request("branch_id")

    Dim cmd, rs

    Set cmd = Server.CreateObject("ADODB.Command")
    With cmd
        .ActiveConnection = dbconn
        .NamedParameters = True
        .CommandType = adCmdStoredProc
        .CommandText = "bp_branch_select"

        .Parameters.Append .CreateParameter("@branch_id", adVarChar, adParamInput, 20, branch_id)

        Set rs = .Execute
    End With
    Set cmd = Nothing

    Dim branch_type, branch_type_arr, cnt, wgs84_x, wgs84_y, branch_weekday_open, branch_weekday_close, branch_services
    branch_type_arr = split(rs("branch_type"),";")
    cnt = UBound(branch_type_arr)
    branch_type = branch_type_arr(cnt)
    branch_type_arr = split(branch_type,":")
    cnt = UBound(branch_type_arr)
    branch_type = branch_type_arr(cnt)
    wgs84_x = rs("wgs84_x")
    wgs84_y = rs("wgs84_y")
    branch_weekday_open = rs("branch_weekday_open")
    branch_weekday_close = rs("branch_weekday_close")
    branch_services = rs("branch_services")
%>
                        <div class="thumbnail">
                            <img src="/images/shop/shop_img.jpg" alt="가게 사진">
                        </div>
						<div class="top">
							<p class="icon"><span class="ico_shop"><%=branch_type%></span></p>
							<p class="subject"><%=rs("branch_name")%></p>
							<p class="add"><%=rs("branch_address")%></p>
							<p class="tel"><%=rs("branch_tel")%></p>
						</div>
						<div class="bot">
							<ul>
								<li class="w-50p">
									<dl>
										<dt>매장유형</dt>
										<dd><%=branch_type%></dd>
									</dl>
								</li>
								<li class="w-50p">
									<dl>
										<dt>좌석 수</dt>
										<dd><%=rs("branch_seats")%></dd>
									</dl>
								</li>
							</ul>
							<ul>
								<li>
									<dl>
										<dt>영업시간</dt>
										<dd><%=branch_weekday_open%> ~ <%=branch_weekday_close%></dd>
									</dl>
								</li>
							</ul>
							<ul>
								<li>
									<dl>
										<dt>설명</dt>
										<dd><%=rs("branch_description")%></dd>
									</dl>
								</li>
							</ul>
							<ul>
								<li>
									<dl>
										<dt>제공서비스</dt>
										<dd>
											<ul class="service">
												<%If Left(branch_services,1) = "1" THEN%>
												<li><em><img src="/images/shop/ico_parking.png" alt=""></em> <span>주차</span></li>
												<%End IF%>
												<%If Mid(branch_services,3,1) = "1" THEN%>
												<li><em><img src="/images/shop/ico_wifi.png" alt=""></em> <span>와이파이</span></li>
												<%End IF%>
												<%If Mid(branch_services,4,1) = "1" THEN%>
												<li><em><img src="/images/shop/ico_people.png" alt=""></em> <span>단체</span></li>
												<%End IF%>
											</ul>
										</dd>
									</dl>
								</li>
							</ul>
						</div>
						<button type="button" class="close btn_lp_close2"><img src="/images/shop/ico_Shopclose.png" alt="닫기버튼"></button>
