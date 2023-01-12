<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
	<tiles:insertAttribute name="styles"/>
	<tiles:insertAttribute name="scripts"/>
</head>
<body>
	
	<tiles:insertAttribute name="header"/>
	<div class="container-sm">
		<tiles:insertAttribute name="contents"/>
	</div>
	<tiles:insertAttribute name="footer"/>
	<tiles:insertAttribute name="contents-js"/>
</body>
</html>