<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>게시판 웹 사이트</title>
</head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<body>
	<%-- <%
		String userID = null;
		
		if(session.getAttribute("userID") != null) {
			userID = (String)session.getAttribute("userID");
		}
		
		int bbsID = 0;
		if(request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		if(bbsID == 0) {
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('유효하지 않은 글입니다')");
			pw.println("location.href='bbs.jsp'");
			pw.println("</script>");
		}
		BbsVO bbs = new BbsDAO().getBbs(bbsID);
	--%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expaned="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" >게시판 웹 사이트</a>
		</div>
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			
			<c:if test="${userID eq null }">
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="login.jsp">로그인</a></li>
							<li><a href="join.jsp">회원가입</a></li>
						</ul>
					</li>
				</ul>
			</c:if>
			<c:if test="${userID ne null }">
				<ul class="nav navbar-nav navbar-right">
					<li class="dropdown">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">회원관리<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="logoutAction.jsp">로그아웃</a></li>
						</ul>
					</li>
				</ul>
			</c:if>
		</div>
	</nav>

	<div class="container">
		<div class="row">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width: 20%;">글 제목</td>
							<%--<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt").replaceAll("\n", "<br>") %></td> --%>
							<td colspan="2">${board.title }</td>
						</tr>
						<tr>
							<td>작성자</td>
							<td colspan="2">${board.writer}</td>
						</tr>
						<tr>
							<td>작성일</td>
							<td colspan="2">${board.regDate}</td>
						</tr>
						<tr>
							<td>내용</td>
							<td colspan="2" style="min-height: 200px; text-align: left;">${board.content}</td>
						</tr>
					</tbody>
				</table>
				<div class="container">
					<table class="table" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3" style="background-color: #fafafa; text-align:center;">댓글</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="background-color: #fafafa; text-align:center;"><h5>${userID }</h5></td>
							<td><input class="form-control" type="text" id="replyContent" size="30"></td>
							<td><button class="btn btn-primary" onclick="registerFunction();" type="button">등록</button></td>
						</tr>
					</tbody>
					</table>
				</div>
				<a href="getBoardList.do" class="btn btn-primary">목록</a>
				<%-- <%
					if(userID != null && userID.equals(bbs.getUserID())) {
				-->
					<a href="update.jsp?bbsID=<%=bbsID %>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('글을 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%=bbsID %>" class="btn btn-primary">삭제</a>
				<%
					}
				%> --%>
		</div>
	</div>

</body>
</html>