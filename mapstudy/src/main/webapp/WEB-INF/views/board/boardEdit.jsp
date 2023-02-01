<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<div id="categorySelectBox">카테고리 선택
	<select id="cateSelect">
		<c:forEach var="c" items="${cateList}">
			<option value="${c.cname}">${c.cname}</option>
		</c:forEach>
	</select>
</div>
    
<div id="boardWrite" class="mb-3">
	<input id="boardTitle" type="text" class="form-control" value="${editList.btitle}" required>
	<button id="clearBtn" class="btn btn-outline-secondary" onclick="updateB()">수정</button>
</div>
<input id="updateBnum" type="hidden" value="${editList.bnum}" required>

<div id="summernote">${editList.bcontent}</div>