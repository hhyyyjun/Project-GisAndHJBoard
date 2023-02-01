<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="boardContent">
  <div class="mb-3">
    <label for="loginId" class="form-label">아이디 입력</label>
    <input type="text" class="form-control" id="loginId" aria-describedby="emailHelp">
    <div id="emailHelp" class="form-text">아이디 입력</div>
  </div>
  <div class="mb-3">
    <label for="loginpw" class="form-label">패스워드 입력</label>
    <input type="password" class="form-control" id="loginpw">
  </div>
  <button id="loginBtn" onclick="login()" class="btn btn-primary">로그인하기</button>
  <button onclick="join()" class="btn btn-primary">회원가입</button>
</div>
