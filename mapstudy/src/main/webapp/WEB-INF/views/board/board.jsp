<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 



<div class="boardContent">
	<div id="categoryWrap">
		<div id="categoryTop">
			<div class="category" onclick="boardList()">전체 게시판</div>
			<c:forEach var="c" items="${cateList}">
				<div class="categoryContent">	
					<div class="category" data-cname="${c.cname}" onclick="boardList(this)">${c.cname}</div>
					<c:if test="${mrole =='admin'}">
						<div class="trachIcon" data-cnum="${c.cnum}" onclick="deleteCate(this)"></div>
					</c:if>
				</div>
			</c:forEach>
		</div>
			<!-- Button trigger modal -->
		<button id="insertCateBtn" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal">
		   카테고리 추가&nbsp;<span id="settingIcon"></span>
		</button>
	</div>
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


<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">카테고리 추가</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
        <input max="20" class="modal-body insertCate" type="text" placeholder="추가하실 카테고리명을 입력해주세요." />
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" onclick="insertCate()">추가하기</button>
      </div>
    </div>
  </div>
</div>