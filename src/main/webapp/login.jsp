<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title><spring:message code="message.user.header"/></title>
</head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<body>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expaned="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand"><spring:message code="message.user.header"/></a>
		</div>
		
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp"><spring:message code="message.user.header.main"/></a></li>
				<!-- <li><a href="bbs.jsp">게시판</a></li> -->
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><spring:message code="message.user.header.in"/><span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li class="active"><a href="login.jsp"><spring:message code="message.user.login.title"/></a></li>
						<li><a href="join.jsp"><spring:message code="message.user.header.join"/></a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="login.do?lang=ko">
					<h3 style="text-align: center;"><spring:message code="message.user.header.login"/></h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="<spring:message code="message.user.login.id"/>" name="id" maxlength="20" value="${userVO.id}">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="<spring:message code="message.user.login.password"/>"name="password" maxlength="20" value="${userVO.password}">
					</div>
					<input type="submit" class="btn btn-primary form-control" value="<spring:message code="message.user.login.title"/>">
				</form>
			</div>
		</div>
	</div>
</body>
</html>