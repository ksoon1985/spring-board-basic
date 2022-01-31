package kr.or.ksh.board.service;

import java.util.List;
import java.util.Map;

import kr.or.ksh.board.dto.BoardDTO;
import kr.or.ksh.board.dto.PageDTO;

public interface BoardListService {
   public int getAllcount();
   public List<BoardDTO> getArticles(PageDTO pdto);
   public Map<String, Object> getArticle(BoardDTO bdto, PageDTO pdto);
}




