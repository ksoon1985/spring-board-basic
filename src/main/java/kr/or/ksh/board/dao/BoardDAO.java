package kr.or.ksh.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.or.ksh.board.dto.BoardDTO;
import kr.or.ksh.board.web.BoardController;

@Repository("boardDao")
public class BoardDAO {
	private static final Logger logger = LoggerFactory.getLogger(BoardDAO.class);
//database 연결 위해 DI 필요
	@Autowired 
	private SqlSession sqlsession;//connection pool의  컨넥션 정보
	
	String prens= "model2.board.";
	public int getAllcount() {
		return sqlsession.selectOne(prens+"allCnt");
	}
	public List<BoardDTO> getArticles(Map<String, Integer> hmap) {
		return sqlsession.selectList(prens+"getArticles",hmap);
	}
	
	public BoardDTO getArticle(BoardDTO bdto) {
		HashMap<String, Integer> numMap 
		    = new HashMap<String, Integer>();
		numMap.put("num", bdto.getNum());
		sqlsession.update(prens+"updateReadCont", numMap);
		return sqlsession.selectOne(prens+"getArticles", numMap);
	}
	public void boardWrite(BoardDTO bdto) {
	     sqlsession.insert(prens+"boardWrite",bdto);
	}
	
	public void boardUpdate(BoardDTO bdto) {
		 sqlsession.update(prens+"updatePro",bdto);
	}
	public int getNewNum() {
		return sqlsession.selectOne(prens+"newNum");
	}
	public void deletePro(int num) {
       sqlsession.delete(prens+"deleteArticle", num);		
	}
	
}