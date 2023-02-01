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
	<input id="boardTitle" type="text" class="form-control" placeholder="제목을 입력하세요." required>
	<button id="clearBtn" class="btn btn-outline-secondary" onclick="insertB()">완료</button>
</div>
<input type="hidden" value="${sessionScope.userId}" id="userId" required>

<div id="summernote"></div>
