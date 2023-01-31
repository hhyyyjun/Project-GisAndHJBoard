<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 

<div class="boardContent">
	<div id="boardTop">
		<div>
			<select id="selectType" class="mb-3">
				<option value="1">글</option>
				<option value="2">댓글</option>
			</select>
			<div class="input-group mb-3" id="searchBox">
			  <input id="searchContent" type="text" class="form-control" placeholder="검색어를 입력하세요." aria-label="Recipient's username" aria-describedby="basic-addon2">
			  <button class="btn btn-outline-secondary" id="button-addon2" onclick="boardList()">검색</button>
			</div>
		</div>
		<button id="writeBtn" onclick="boardWrite()" class="btn btn-outline-secondary mb-3">글쓰기</button>
	</div>
	<div id="target"></div>
</div>
