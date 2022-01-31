<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<link href="/resources/board2/css/board.css" rel="stylesheet">
<script type="text/javascript" src="/resources/board2/js/boardScript.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="/resources/board2/js/jquery_board.js" type="text/javascript"></script>
</head>
<body>

 <form action="updatePro.sp" method="post" name="updateForm" enctype="multipart/form-data">
  <table border =1>
    <thead>
      <tr>
         <th colspan=2> <h3>글수정</h3> 
         </th>
       </tr>
    </thead>
    <tbody>
        <tr>
            <th>제목: </th>
            <td><input type="text" size="95%" 
               placeholder="제목을 입력하세요. " 
               name="subject" value='<c:out value="${bdto.subject}"/>'/></td>
        </tr>
        <tr>
            <th>내용: </th>
            <td><textarea cols="80" rows="20" placeholder="내용을 입력하세요. "  name="content"><c:out value="${bdto.content}"/></textarea></td>
        </tr>
        <tr>
            <th>첨부파일: </th>
            <td><input type="file" 
                  placeholder="파일을 선택하세요. " 
                  name="afile" value='<c:out value="${bdto.attachNm}"/>'/><c:out value="${bdto.attachNm}"/></td>
        </tr>
        <tr>
            <th>작성자: </th>
            <td><c:out value="${bdto.writer}"/></td>
        </tr>
        <tr>
            <th>이메일: </th>
            <td><input type="text" 
                 placeholder="메일주소를 작성해 주세요" 
                 name ="email" value='<c:out value="${bdto.email}"/>'/></td>
        </tr>
        <tr>
            <th>비밀번호: </th>
            <td><input type="password" 
                 placeholder="비밀번호를 입력하세요" 
                 name ="passwd" value='<c:out value="${bdto.passwd}"/>'/>
                 <input type="hidden" 
                 name ="num" value='<c:out value="${bdto.num}"/>'/>
                 <input type="text" name="currentPage"   
			       value='<c:out value="${pdto.currentPage}"/>'/> 
			      <input type="text" name="currPageBlock"  
			       value='<c:out value="${pdto.currPageBlock}"/>'/>
                 </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <button type="submit"    id="submit1">글수정</button>
                <button type="button"    id="list3">글 목록으로... </button>
            </td>
        </tr>
    </tbody>
  </table>
</form>
</body>
</html>