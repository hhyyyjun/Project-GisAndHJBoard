<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here ${sessionScope.userId}</title>
</head>
<body>
<div class="boardContent">
	<div id="boardTop">
		<div>
			<select id="selectType" class="mb-3">
				<option>글</option>
				<option>댓글</option>
			</select>
			<div class="input-group mb-3" id="searchBox">
			  <input type="text" class="form-control" placeholder="검색어를 입력하세요." aria-label="Recipient's username" aria-describedby="basic-addon2">
			  <button class="btn btn-outline-secondary" id="button-addon2">검색</button>
			</div>
		</div>
		<button onclick="boardWrite()" class="btn btn-outline-secondary mb-3">글쓰기</button>
	</div>
	
	<table class="table table-hover">
	 <thead>
	   <tr>
	     <th scope="col">#</th>
	     <th scope="col">제목</th>
	     <th scope="col">내용</th>
	     <th scope="col">작성자</th>
	   </tr>
	 </thead>
	 <tbody>
	   <tr>
	     <th scope="row"><a href=#>d</a></th>
	     <td>Mark</td>
	     <td>Otto</td>
	     <td>@mdo</td>
	   </tr>
	   <tr>
	     <th scope="row">2</th>
	     <td>Jacob</td>
	     <td>Thornton</td>
	     <td>@fat</td>
	   </tr>
	   <tr>
	     <th scope="row">3</th>
	     <td>Larry the Bird</td>
	     <td>Larry the Bird</td>
	     <td>@twitter</td>
	   </tr>
	 </tbody>
</table>


</div>
</body>
</html>