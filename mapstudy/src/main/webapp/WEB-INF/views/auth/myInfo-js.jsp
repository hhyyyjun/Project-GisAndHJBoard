<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>

//패스워드가 영문숫자 조합 8자리~12자리
var pw = /^(?=.*[a-zA-Z])(?=.*[0-9]).{8,12}$/;

$(function(){
	$("#enterPw").keyup(passwordstart);
	$("#enterPw").keyup(changePw);
	$("#checkPw").keyup(passwordstartck);
	$("#checkPw").keyup(changePw);
});

//정보 수정
function updateInfo(){
	var nick = $("#enterNick").val();
	var userData = {
			"nick" : nick
	};
	$.ajax({
		url : "/updateM",
		type : "POST",
		data : JSON.stringify(userData),
		contentType : "application/json;charset=UTF-8",
		success : function(data){
			if(data.result == "success"){
				console.log("정보 변경 성공");
				location.reload();
				alert("정보 수정 완료");
			} else{
				console.log("정보 변경 실패")
			}
		},
		error : function(){
			console.log("정보 변경 에러");
		}
	})
}

//비밀번호 수정
function updatePwd(){
	var pwd = $("#enterPw").val();
	var userData = {
			"pw" : pwd
	};
	$.ajax({
		url : "/updateP",
		type : "POST",
		data : JSON.stringify(userData),
		contentType : "application/json;charset=UTF-8",
		success : function(data){
			if(data.result == "success"){
				console.log("비밀번호 변경 성공");
				location.reload();
				alert("비밀번호 수정 완료");
			} else{
				console.log("비밀번호 변경 실패")
			}
		},
		error : function(){
			console.log("비밀번호 변경 에러");
		}
	})
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

//비밀번호 변경 버튼 활성화 비활성화
function changePw(){
	if(
		!(
		pw.test($("#enterPw").val()) &&
		$("#enterPw").val() === $("#checkPw").val()	
		)
	){
		$("#changePwd").attr("disabled", true);
	    $("#changePwd").css({"background-color":"#dee5ec","cursor":"no-drop","color":"#ffffff","border":"none"});
	} else {
		$("#changePwd").attr("disabled", false);
		$("#changePwd").css({"background-color":"#0b5ed7","cursor":"pointer","color":"#fff"});
	}
}

function changeNick(target){
	$("#changeNickForm").css("display","block");
	$("#changePwdForm").css("display","none");
	$(".changeInfo > span").css("color", "black");
	$(target).css("color","red");
}
function changePwd(target){
	$("#changeNickForm").css("display","none");
	$("#changePwdForm").css("display","block");
	$(".changeInfo > span").css("color", "black");
	$(target).css("color","red");
}
</script>

