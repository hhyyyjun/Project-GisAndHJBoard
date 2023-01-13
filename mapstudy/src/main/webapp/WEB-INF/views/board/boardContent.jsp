<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="boardPageBox">
	<div id="boardTitleBox">
		<h1 id="boardTitle">${boardInfo.btitle}</h1>
	</div>
	<div id="boardToolBox">
		<div>${boardInfo.mnick}</div>
		<div>${boardInfo.bdate}</div>
		<div id="boardFuncBox">
			<div id="funcBtn"></div>
			<ul id="boardFunc" class="viewOff">
				<li onclick="updateBoard(this)" data-bnum="${boardInfo.bnum}">수정하기</li>
				<li onclick="deleteBoard(this)" data-bnum="${boardInfo.bnum}">삭제하기</li>
			</ul>
		</div>
	</div>
	<div id="boardContentBox">${boardInfo.bcontent}</div>

</div>