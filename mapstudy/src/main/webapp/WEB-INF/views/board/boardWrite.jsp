<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<div id="boardWrite" class="mb-3">
	<input id="boardTitle" type="text" class="form-control" placeholder="제목을 입력하세요.">
	<button id="clearBtn" class="btn btn-outline-secondary" onclick="insertB()">완료</button>
</div>
<input type="hidden" value="$(userId)" id="userId">
<!-- <div> -->
<!--       <div id="smarteditor"> -->
<!--         <textarea name="editorTxt" id="editorTxt"  -->
<!--                   rows="20" cols="10"  -->
<!--                   placeholder="내용을 입력해주세요"></textarea> -->
<!--       </div> -->
<!-- </div> -->

<div id="summernote"></div>
</body>
</html>