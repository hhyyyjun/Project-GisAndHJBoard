<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
//정규표현식
//이메일 @포함 여부 및 대소문자 미구분
var email =
/^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
//패스워드가 영문숫자 조합 8자리~12자리
var pw = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,12}$/;
//닉네임 2~10자리
var nick = /^[가-힣0-9a-zA-Z]{2,10}$/;

$(function(){
	$("#enterId").keyup(emailstart);
	$("#enterId").keyup(joinBtn);
	$("#enterPw").keyup(passwordstart);
	$("#enterPw").keyup(joinBtn);
	$("#checkPw").keyup(passwordstartck);
	$("#checkPw").keyup(joinBtn);
	$("#enterNick").keyup(nicknamestart);
	$("#enterNick").keyup(joinBtn);
	
	var idCheckFlag = false;
});

//이메일 입력 정규표현식 비교
function emailstart() {
    idCheckFlag = false;
	if (!email.test($("#enterId").val())) {
	  console.log("ffffff");
	  $('#joinId').html("<div>이메일 형식이 잘못 되었습니다.</div>");
	  $('#joinId').css({"margin-top":"10px","color":"red","display":"block"});
	  return false;
	} else {
	  console.log("tttttt");
	  $('#joinId').css("display","none");
	  return true;
	}
}
//비밀번호 입력 정규표현식 비교
function passwordstart() {
	if (!pw.test($("#enterPw").val())) {
	  console.log("ffffff");
	  $("#joinPassword").html("<div>영문,숫자 조합 8~12자리</div>");
	  $("#joinPassword").css({"margin-top":"10px","color":"red"});
	  return false;
	} else {
	  console.log("tttttt");
	  $("#joinPassword").html("<div>영문,숫자 조합 8~12자리</div>")
	  $("#joinPassword").css({"margin-top":"10px","color":"blue"});
	  return true;
	}
}
//비밀번호 2번 확인
function passwordstartck() {
	 if ($("#enterPw").val() !== $("#checkPw").val()) {
	   console.log("ffffff");
	   $("#checkPassword").html("<div>비밀번호와 비밀번호 확인이 불일치합니다.</div>");
	   $("#checkPassword").css({"margin-top":"10px","color":"red"});
	   return false;
	 } else {
	   console.log("tttttt");
	   $("#checkPassword").html("<div>비밀번호가 일치합니다.</div>");
	   $("#checkPassword").css({"margin-top":"10px","color":"blue"});
	   return true;
	 }
}
//닉네임 입력 정규표현식 비교
function nicknamestart() {
	 if (!nick.test($("#enterNick").val())) {
	   console.log("ffffff");
	   $("#joinNickname").html("<div>닉네임은 2~10자리까지 생성 가능합니다.</div>");
	   $("#joinNickname").css({"margin-top":"10px","color":"red","display":"block"});
	   return false;
	 } else {
	   console.log("tttttt");
	   $("#joinNickname").css("display","none");
	   return true;
	 }
}
//회원가입 버튼 활성화 비활성화
function joinBtn(){
	if(idCheckFlag == true){
		if(
			!(
			email.test($("#enterId").val()) &&
			pw.test($("#enterPw").val()) &&
			$("#enterPw").val() === $("#checkPw").val() &&	
			nick.test($("#enterNick").val()) &&
			idCheckFlag == true
			)
		){
			$("#joinBtn").attr("disabled", true);
		    $("#joinBtn").css({"background-color":"#dee5ec","cursor":"no-drop","color":"#ffffff","border":"none"});
		} else {
			$("#joinBtn").attr("disabled", false);
			$("#joinBtn").css({"background-color":"#0b5ed7","cursor":"pointer","color":"#fff"});
		}
	} else{
		$("#joinBtn").attr("disabled", true);
	    $("#joinBtn").css({"background-color":"#dee5ec","cursor":"no-drop","color":"#ffffff","border":"none"});
	}
}

//아이디 중복검사
function idCheck(){
	if (email.test($("#enterId").val())){
		var params = {
			id : $("#enterId").val()	
		}
		
		$.ajax({
			url : "/checkId?mid="+$("#enterId").val(),
			type : "POST",
			data : JSON.stringify(params),
			contentType : "application/json;charset=UTF-8",
			success : function(data){
				if(data == 1){
					$("#joinId").html("<div>사용중인 아이디</div>");
					$('#joinId').css({"margin-top":"10px","color":"red","display":"block"});
					idCheckFlag = false;
					joinBtn();
				}else{
					$("#joinId").html("<div>사용가능한 아이디</div>");
					$('#joinId').css({"margin-top":"10px","color":"blue","display":"block"});
					idCheckFlag = true;
					joinBtn();
				}
			},
			error : function(){
				console.log("error");
			}		
		})
	}
}


//회원가입
function joinMember(){
	var id = $("#enterId").val();
	var pw = $("#enterPw").val();
	var nickname = $("#enterNick").val();
	var mrole = $("#mrole").val();
	//form 태그 내 모든 값을 가져옴
	var joinForm = $("#joinForm").serialize();

	console.log(id);
	console.log(pw);
	console.log(nickname);
	console.log(mrole);
	console.log(typeof id);
	console.log(typeof pw);
	console.log(typeof nickname);
	console.log(typeof mrole);
	var userData = {
		"id" : id,
		"pw" : pw,
		"nick" : nickname,
		"role" : mrole
	};
	
	$.ajax({
		url : "/joinMember",
		type : "POST",
		data : JSON.stringify(userData),
		dataType : "json",
		contentType : "application/json;charset=UTF-8",
		success : function(data){
			if(data.result == "success"){
				console.log('회원가입 성공');
				location.href="/login";
			}
			else{
				console.log('회원가입 실패');
			}
		},
		error : function(){
			console.log('error');
		}
	})
}

function goBack(){
	location.href="/login";
// 	history.back();
}
</script>

