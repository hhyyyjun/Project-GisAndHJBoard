<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

<div id="userInfoBox">
	<div class="changeInfo">
		<span onclick="changeNick(this)">닉네임 변경</span>
	</div>
	<div class="changeInfo">
		<span onclick="changePwd(this)">비밀번호 변경</span>
	</div>
</div>
    
<div id="changeNickForm" class="boardContent">
  <div class="mb-3">
    <label for="joinId" class="form-label">아이디</label>
 	<div id="idBox">
  		<input type="text" disabled class="form-control" id="enterId" value="${myInfo.mid}">
    </div>
  	<div id="joinId"></div>
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

<div id="changePwdForm" class="rreplyViewOff">
	 <div class="mb-3">
    <label for="joinPassword" class="form-label">비밀번호</label>
    <input type="text" class="form-control" id="enterPw" required>
    <div id="joinPassword"></div>
  </div>
  <div class="mb-3">
    <label for="joinPassword" class="form-label">비밀번호 확인</label>
    <input type="text" class="form-control" id="checkPw" required>
    <div id="checkPassword"></div>
  </div>
  <div class="mb-3">
    <label for="joinNickname" class="form-label">권한</label>
    <input type="text" disabled class="form-control" value="${myInfo.mrole}">
  </div>
  <button id="changePwd" onclick="updatePwd()" class="btn btn-primary" disabled>비밀번호 변경</button>
</div>