<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<link href="/resources/board2/css/board.css" rel="stylesheet">          
<script type="text/javascript" src="/resources/board2/js/boardScript.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="/resources/board2/js/jquery_board.js" 
          type="text/javascript"></script>
</head>
<body>
<form action="writePro.sp" method="post" name="writeForm" enctype="multipart/form-data">
    <input type="text" name="num" value="${bdto.num}">
    <input type="text" name="ref" value="${bdto.ref}">
    <input type="text" name="re_step" value="${bdto.re_step}">
    <input type="text" name="re_level" value="${bdto.re_level}">
    <input type="text" name="currentPage"   
       value='<c:out value="${pdto.currentPage}"/>'/> 
    <input type="text" name="currPageBlock"  
       value='<c:out value="${pdto.currPageBlock}"/>'/>
  <table>
    <thead class="class01 class-center">
      <tr>
         <th colspan=2 > <h3>글쓰기</h3> 
         </th>
       </tr>
    </thead>
    <tbody class="class02 class-left">
        <tr>
            <th>제목: </th>
            <c:if test="${bdto.num==0}">
            <td><input type="text" size="80%" 
               placeholder="제목을 입력하세요. " 
               name="subject" title="제목" class="chk"/></td>
            </c:if>
            <c:if test="${bdto.num!=0}">
            <td><input type="text" size="80%" 
               placeholder="제목을 입력하세요. " 
               name="subject" title="제목" value="[답글]" class="chk"/></td>
            </c:if>
        </tr>
        <tr>
            <th > 내용: </th>
            <td><textarea cols="80" rows="20" 
                  placeholder="내용을 입력하세요. " 
                  name="content" title="내용" class="chk"></textarea></td>
        </tr>
        <tr>
            <th>첨부파일: </th>
            <td class="class-left"><input type="file" 
                  placeholder="파일을 선택하세요. " 
                  name="afile"/></td>
        </tr>
        <tr>
            <th>작성자: </th>
            <td><input type="text" 
                 placeholder="작성자를 입력하세요" 
                 name ="writer" title="작성자" class="chk"/></td>
        </tr>
        <tr>
            <th>이메일: </th>
            <td><input type="text" 
                 placeholder="메일주소를 작성해 주세요" 
                 name ="email"/></td>
        </tr>
        <tr>
            <th>비밀번호: </th>
            <td><input type="password" 
                 placeholder="비밀번호를 입력하세요" 
                 name ="passwd" title="비밀번호" class="chk"/></td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <button type="submit"    id="submit1">등록</button>
                <button type="button"    id="list2">글 목록으로... </button>
            </td>
        </tr>
    </tbody>
  </table>
</form>
</body>
</html>