<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="boardWrite" class="mb-3">
	<input id="boardTitle" type="text" class="form-control" value="${editList.btitle}" required>
	<button id="clearBtn" class="btn btn-outline-secondary" onclick="updateB()">수정</button>
</div>
<input type="hidden" value="${sessionScope.userNick}" id="userNick" required>

<div id="summernote">${editList.bcontent}</div>