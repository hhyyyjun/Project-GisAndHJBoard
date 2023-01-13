<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="joinForm" class="boardContent">
  <div class="mb-3">
    <label for="joinId" class="form-label">아이디</label>
 	<div id="idBox">
  		<input type="text" disabled class="form-control" id="enterId" value="${myInfo.mid}">
    </div>
  	<div id="joinId"></div>
  </div>
  <div class="mb-3">
    <label for="joinPassword" class="form-label">비밀번호</label>
    <input type="text" class="form-control" id="enterPw" value="${myInfo.mpw}">
    <div id="joinPassword"></div>
  </div>
  <div class="mb-3">
    <label for="joinNickname" class="form-label">닉네임</label>
    <input type="text" class="form-control" id="enterNick" value="${myInfo.mnick}">
    <div id="joinNickname"></div>
  </div>
  <div class="mb-3">
    <label for="joinNickname" class="form-label">권한</label>
    <input type="text" disabled class="form-control" value="${myInfo.mrole}">
  </div>
  <button onclick="updateInfo()" class="btn btn-primary">정보 변경</button>
</div>