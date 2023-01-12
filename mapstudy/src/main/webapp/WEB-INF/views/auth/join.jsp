<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div id="joinForm" class="boardContent">
  <div class="mb-3">
    <label for="joinId" class="form-label">아이디 입력</label>
 	<div id="idBox">
  		<input type="text" class="form-control" id="enterId">
  		<button id="checkId" onclick="idCheck()">중복 검사</button>
    </div>
  	<div id="joinId"></div>
  </div>
  <div class="mb-3">
    <label for="joinPassword" class="form-label">패스워드 입력</label>
    <input type="password" class="form-control" id="enterPw">
    <div id="joinPassword"></div>
  </div>
  <div class="mb-3">
    <label for="chkPassword" class="form-label">패스워드 확인</label>
    <input type="password" class="form-control" id="checkPw">
    <div id="checkPassword"></div>
  </div>
  <div class="mb-3">
    <label for="joinNickname" class="form-label">닉네임</label>
    <input type="text" class="form-control" id="enterNick">
    <div id="joinNickname"></div>
  </div>
  <div class="mb-3">
    <label for="memberRole" class="form-label">권한</label>
    <select id="mrole">
    	<option>일반회원</option>
    	<option>관리자</option>
    </select>
  </div>
  <button style="border:none; cursor:no-drop; background-color:#dee5ec; color:#ffffff;" disabled onclick="joinMember()" id="joinBtn" class="btn">회원가입</button>
  <button onclick="goBack()" class="btn btn-primary">로그인화면으로 돌아가기</button>
</div>