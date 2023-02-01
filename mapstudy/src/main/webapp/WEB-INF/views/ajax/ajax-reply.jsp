<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>   

<div class="replyContentBox">
	<c:forEach var="r" items="${rList}">
	<div class="replyreply">
		<div class="replyInfo">
			<div>${r.mnick}</div>
			<div class="replyDate">${r.rdate}</div>
			<c:if test="${r.mid==userId && r.rcontent != '삭제된 댓글입니다.' || mrole=='admin'}">
			<div class="replyFuncBox">
			<div class="rfuncBtn" onclick="rfuncBtnClicked(this)"></div>
			<ul class="replyFunc viewOff">
				<li class="replyFuncLi replyFuncLi1" onclick="updateRbtn(this)">수정하기</li>
				<li class="replyFuncLi replyFuncLi2" onclick="deleteRbtn(this)" data-rnum="${r.rnum}">삭제하기</li>
			</ul>
			</div>
			</c:if>
		</div>
		<div class="replyBoxForRereply">
			<c:choose>
				<c:when test="${r.rcontent == '삭제된 댓글입니다.'}">
					<div class="deletedContent">삭제된 댓글입니다.</div>
				</c:when>
				<c:otherwise>
					<div class="replyBox">
						<div class="replyContent">${r.rcontent}</div>
						<div class="rreplyWrite" onclick="rreplyWrite(this)">댓글</div>
					</div>
				</c:otherwise>
			</c:choose>
			<!-- 숨겨져있는 댓글 수정창 -->
			<div class="changeView">
				<textarea class="form-control replyUcontent">${r.rcontent}</textarea>
				<div class="writerInfo">
					<div>${userNick.mnick}</div>
					<div>
						<button class="btn btn-outline-secondary rreplyBRnum" data-rnum="${r.rnum}" onclick="updateR(this)" >수정</button>
						<button class="btn btn-outline-secondary rreplyBRnum" data-rnum="${r.rnum}" onclick="cancelUR(this)" >취소</button>
					</div>
				</div>
			</div>
			<!-- 대댓글 입력박스 -->
			<div class="rreplyInputBox rreplyViewOff">
				<div class="rreplyBox">
					<div class="rreplyImage"></div>
					<textarea class="form-control rreplyContent" placeholder="대댓글 입력"></textarea>
				</div>
				<div class="writerInfo">
					<div class="rreplyWriter">${userNick.mnick}</div>
					<div>
						<span>0/0</span>
						<button class="btn btn-outline-secondary rreplyBRnum" data-bnum="${r.bnum}" data-rnum="${r.rnum}" onclick="rreplyInput(this)">등록</button>
					</div>
				</div>
			</div>
			<div class="rreply"></div>
		</div>
	</div>
	<!-- 대댓글 -->
	<div class="rreplyContentBox">
		<c:forEach var="rr" items="${rrList}">
		<c:if test="${r.rnum == rr.rnum}">
		<div class="rreplyrreply">
			<div class="replyInfo">
				<div class="rreplyImage"></div>
				<div>${rr.mnick}</div>
				<div class="replyDate">${rr.rrdate}</div>
				<c:if test="${rr.mid==userId || mrole=='admin'}">
				<c:if test="${rr.rrcontent != '삭제된 댓글입니다.'}">
					<div class="replyFuncBox">
					<div class="rfuncBtn" onclick="rfuncBtnClicked(this)"></div>
					<ul class="replyFunc viewOff">
						<c:if test="${r.rcontent != '삭제된 댓글입니다.'}">
						<li class="replyFuncLi replyFuncLi1" onclick="updateRRbtn(this)" data-rrnum="${rr.rrnum}">수정하기</li>
						</c:if>
						<li class="replyFuncLi replyFuncLi2" onclick="updateOrDeleteRR(this)" data-rrnum="${rr.rrnum}" value="삭제하기">삭제하기</li>
					</ul>
					</div>
				</c:if>
				</c:if>
			</div>
			<c:choose>
				<c:when test="${rr.rrcontent == '삭제된 댓글입니다.'}">
					<div class="deletedContents">삭제된 댓글입니다.</div>
				</c:when>
				<c:otherwise>
					<div class="rreplyContents">${rr.rrcontent}</div>
				</c:otherwise>
			</c:choose>
			<!-- 숨겨져있는 대댓글 수정창 -->
			<div class="changeView">
				<textarea class="form-control replyUcontent">${rr.rrcontent}</textarea>
				<div class="writerInfo">
					<div>${userNick.mnick}</div>
					<div>
						<button class="btn btn-outline-secondary rreplyBRnum" data-rrnum="${rr.rrnum}" onclick="updateOrDeleteRR(this)" value="수정하기">수정</button>
						<button class="btn btn-outline-secondary rreplyBRnum" data-rrnum="${rr.rrnum}" onclick="cancelURR(this)" >취소</button>
					</div>
				</div>
			</div>
			<!-- 대댓글 입력박스 -->
			<div class="rreplyInputBox rreplyViewOff">
				<div class="rreplyBox">
					<div class="rreplyImage"></div>
					<textarea class="form-control rreplyContent" placeholder="대댓글 입력"></textarea>
				</div>
				<div class="writerInfo">
					<div class="rreplyWriter">${userNick.mnick}</div>
					<div>
						<span>0/0</span>
						<button class="btn btn-outline-secondary rreplyBRnum" data-bnum="${r.bnum}" data-rnum="${r.rnum}" onclick="rreplyInput(this)">등록</button>
					</div>
				</div>
			</div>
		</div>
		</c:if>
		</c:forEach>
	</div>
	</c:forEach>
</div>

