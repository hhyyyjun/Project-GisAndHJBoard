<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form>
  <div class="mb-3">
    <label for="joinId" class="form-label">아이디 입력</label>
    <input type="text" class="form-control" id="joinId" aria-describedby="emailHelp">
  </div>
  <div class="mb-3">
    <label for="joinPassword" class="form-label">패스워드 입력</label>
    <input type="password" class="form-control" id="joinPassword">
  </div>
  <div class="mb-3">
    <label for="joinNickname" class="form-label">닉네임</label>
    <input type="text" class="form-control" id="joinNickname">
  </div>
  <!--<div class="mb-3 form-check">
    <!--<input type="checkbox" class="form-check-input" id="exampleCheck1">
     <label class="form-check-label" for="exampleCheck1">Check me out</label>
  </div>-->
  <button onclick="joinMember()" class="btn btn-primary">회원가입</button>
</form>

</body>
</html>