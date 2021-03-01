<style>
/*section board list,popup*/
.section_board {width:100%;}
.section_board .board_top {width:100%;}
.section_board .list_select {text-align:left;}
.section_board .list_select ul {display:inline-block;margin-left:20px;}
.section_board .list_select ul li {float:left;margin-bottom:0;margin-right:42px;}
.section_board .board_search {text-align: right;height:40px;line-height:40px;padding-right:20px;}
.section_board .top .board_select .board_search input {margin-right:18px;}
.section_board table tr th {height:40px;}
.section_board table tr td {height:34px;}

</style>
<!-- #include virtual="/inc/config.asp" -->
<!DOCTYPE html>
<html lang="ko">

<head>
    <!-- include virtual="/inc/head.asp" -->
    <script>

    </script>
</head>

<body>
    <div class="wrap">
        <!-- include virtual="/inc/header.asp" -->
        <!--NAV-->
        <div class="navwrap">
            <!--GNB-->
            <div class="gnbwrap">

                <!--
		<div class="board_top hide">
			<div class="route"> 
				<span><p>관리자</p> > <p>게시판관리</p> > <p><%'=FncBrandName(CD)%></p></span>
			</div>
		</div>
-->
            </div>
            <!--//GNB-->
        </div>
        <!--//NAV-->
        <div class="content">
            <div class="section section_board">
                <form id="searchfrm" name="searchfrm" method="get" class="hide">
                    <input type="hidden" name="LNUM" value="<%=LNUM%>">
                    <input type="hidden" name="CD" value="<%=CD%>">
                    <table>
                        <tr>
                            <th>
                                <div class="list_select">
                                    <ul>

                                    </ul>
                                </div>
                            </th>
                        </tr>
                        <tr>
                            <th>
                                <div class="board_search">
                                    <select name="SM" id="SM">
                                        <option value="T">제목</option>
                                    </select>
                                    <input type="text" name="SW" value="<%=SW%>">
                                    <input type="submit" value="검색" class="btn_white">
                                </div>
                            </th>
                        </tr>
                    </table>
                </form>

                <div class="list">
                    <div class="list_top">
                        <div class="list_total">
                            <span>Total:<p><%=total_num%>건</p></span>
                        </div>
                        <div class="list_num">
                            <select name="LNUM" id="LNUM" onChange="document.location.href='?CD=<%=CD%>&BBSCODE=<%=BBSCODE%>&SM=<%=SM%>&SW=<%=SW%>&LNUM='+this.value">
                                <option value="10" <%If LNUM="10" Then%> selected<%End If%>>10</option>
                                <option value="20" <%If LNUM="20" Then%> selected<%End If%>>20</option>
                                <option value="50" <%If LNUM="50" Then%> selected<%End If%>>50</option>
                                <option value="100" <%If LNUM="100" Then%> selected<%End If%>>100</option>
                            </select>
                        </div>
                    </div>
                    <div class="list_content list_thum_img">
                        <table style="width:100%;">
                            <!--colgroup>
								<col width="3%">
								<col width="5%">
								<col width="20%">
								<col width="44%">
								<col width="11%">
								<col width="8%">
								<col width="9%">
							</colgroup-->
                            <tr>
                                <th>NO</th>
                                <th width="44%">제목</th>
                                <th>작성자</th>
                                <th>접수일</th>
                                <th>진행상태</th>
                                <th>노출</th>
                                <th>관리</th>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td><button class="btn">수정</button></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </table>

                    </div>
                    <div class="list_foot">
                        <!-- #include virtual="/inc/paging.asp" -->
                    </div>
                </div>
            </div>
        </div>
        <!-- include virtual="/inc/footer.asp" -->
    </div>
</body>

</html>