<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<body>
<form>
  <div class="mb-3">
    <label for="exampleInputId" class="form-label">아이디 입력</label>
    <input type="text" class="form-control" id="exampleInputId" aria-describedby="emailHelp">
    <div id="emailHelp" class="form-text">아이디 입력</div>
  </div>
  <div class="mb-3">
    <label for="exampleInputPassword" class="form-label">패스워드 입력</label>
    <input type="password" class="form-control" id="exampleInputPassword">
  </div>
  <!--<div class="mb-3 form-check">
    <!--<input type="checkbox" class="form-check-input" id="exampleCheck1">
     <label class="form-check-label" for="exampleCheck1">Check me out</label>
  </div>-->
  <button id="loginBtn" type="button" class="btn btn-primary">로그인하기</button>
  <button type="button" onclick="join()" class="btn btn-primary">회원가입</button>
</form>

</body>