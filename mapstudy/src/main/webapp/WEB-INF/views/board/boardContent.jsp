<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<div id="boardPageBox">
	<div id="boardTitleBox">
		<h1 id="boardTitle">${boardInfo.btitle}</h1>
	</div>
	<div id="boardToolBox">
		<div>${boardInfo.mnick}</div>
		<div>${boardInfo.bdate}</div>
		<c:if test="${boardInfo.mid==userId}">
		<div id="boardFuncBox">
			<div id="funcBtn"></div>
			<ul id="boardFunc" class="viewOff">
				<li onclick="updateBoard(this)" data-bnum="${boardInfo.bnum}">수정하기</li>
				<li onclick="deleteBoard(this)" data-bnum="${boardInfo.bnum}">삭제하기</li>
			</ul>
		</div>
		</c:if>
	</div>
	<div id="boardContentBox">${boardInfo.bcontent}</div>
	<div id="replyInputBox">
		<input id="replyBnum" type="hidden" value="${boardInfo.bnum}">
		<textarea id="replyContent" class="form-control" placeholder="댓글 입력"></textarea>
		<div class="writerInfo">
			<div class="replyWriter">${myInfo.mnick}</div>
			<div>
				<span>0/0</span>
				<button class="btn btn-outline-secondary" onclick="replyInput()">등록</button>
			</div>
		</div>
	</div>
	<div id="reply"></div>
</div>