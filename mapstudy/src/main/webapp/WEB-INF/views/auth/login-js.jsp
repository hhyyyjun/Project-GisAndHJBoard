<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
//회원가입 화면으로 이동
function join() {
	console.log("회원가입 클릭");
	location.href = "/join";
}
$(function(){
	var cookie = document.cookie;
	
	fnInit();
})
function fnInit(){
    var cookieid = getCookie("saveid");
    console.log(cookieid);
    if(cookieid !=""){
        $("input:checkbox[id='idChk']").prop("checked", true);
        $('#loginId').val(cookieid);
    }
}   
function setCookie(name, value, expiredays){ //쿠키 저장함수
	var todayDate = new Date();
	todayDate.setTime(todayDate.getTime() + 0);
	if(todayDate > expiredays){
	    document.cookie = name + "=" + escape(value) + "; path=/; expires=" + expiredays + ";";
	}else if(todayDate < expiredays){
	    todayDate.setDate(todayDate.getDate() + expiredays);
	    document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + ";";
	}
	console.log(document.cookie);
}
function getCookie(Name) { // 쿠키 불러오는 함수
	var search = Name + "=";
	if (document.cookie.length > 0) { //쿠키가 설정되어 있다면
	    offset = document.cookie.indexOf(search);
	    if (offset != -1) { // 쿠키가 존재한다면
	        offset += search.length; // set index of beginning of value
	        end = document.cookie.indexOf(";", offset); // set index of end of cookie value
	        if (end == -1) //쿠키 값의 마지막 위치 인덱스 번호 설정
	            end = document.cookie.length;
// 	        return unescape(document.cookie.substring(offset, end));
	        return decodeURI(document.cookie.substring(offset, end));
	    }
	}
	return "";
}

function saveid() {
    var expdate = new Date();
    if ($("#idChk").is(":checked")){
        expdate.setTime(expdate.getTime() + 1000 * 60 * 60 * 1);
        setCookie("saveid", $("#loginId").val(), expdate);
        }else{
       expdate.setTime(expdate.getTime() - 1000 * 60 * 60 * 1);
        setCookie("saveid", $("#loginId").val(), expdate);
    }
}



function login() {
	console.log("로그인 들어옴");
	
	saveid();
	
	var id = $("#loginId").val();
	var pw = $("#loginpw").val();
	
	if (!id) { //아이디를 입력하지 않은 경우
	    alert("아이디를 입력 해주세요!");
	    $("#loginId").focus();
	    return;
	}
	if (!pw) { //패스워드를 입력하지 않은 경우
	    alert("패스워드를 입력 해주세요!");
	    $("#loginpw").focus();
	    return;
	}
	
	
	var userData = {
		mid : id,
		mpw : pw
	};

	$.ajax({
		url : "/login_proc",
		type : "POST",
		data : userData,
		dataType : "json",
// 		contentType : "application/x-www-form-urlencoded; charset=utf-8",
		success : function(data) {
			console.log(data);
			if (data.result == "success") {
				console.log('로그인 성공');
				location.href="/board";
			} else {
				alert("아이디 혹은 비밀번호가 일치하지 않습니다.");
				console.log('로그인 실패');
			}
		},
		error : function() {
			console.log('error');
		}
	})
};



</script>