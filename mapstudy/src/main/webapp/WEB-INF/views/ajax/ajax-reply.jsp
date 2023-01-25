<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>   

<div class="replyContentBox">
	<c:forEach var="r" items="${rList}">
	<div class="replyInfo">
		<div>${r.mnick}</div>
		<div class="replyDate">${r.rdate}</div>
		<c:if test="${r.mid==userId}">
		<div class="replyFuncBox">
		<div class="rfuncBtn" onclick="rfuncBtnClicked(this)"></div>
		<ul class="replyFunc viewOff">
			<li class="replyFuncLi replyFuncLi1" onclick="updateR()" data-rnum="${r.rnum}">수정하기</li>
			<li class="replyFuncLi replyFuncLi2" onclick="deleteR()" data-rnum="${r.rnum}">삭제하기</li>
		</ul>
		</div>
		</c:if>
	</div>
	<div class="replyContent">${r.rcontent}</div>
	</c:forEach>
</div>

