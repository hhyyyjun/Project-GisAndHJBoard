<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div>
	<div>
		<h1>${boardInfo.btitle}</h1>
	</div>
	<div>
		<div>${boardInfo.mnick}</div>
		<div>${boardInfo.bdate}</div>
		<div>
			<ul>
				<li>수정</li>
				<li>삭제</li>
			</ul>
		</div>
	</div>
	<div>${boardInfo.bcontent}</div>

</div>