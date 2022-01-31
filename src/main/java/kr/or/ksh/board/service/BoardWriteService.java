package kr.or.ksh.board.service;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.ksh.board.dto.BoardDTO;
import kr.or.ksh.board.dto.PageDTO;

public interface BoardWriteService {
	public PageDTO writeArticle(PageDTO pdto);
	public void writeProArticle(BoardDTO bdto,
			MultipartHttpServletRequest mpRequest);
	public PageDTO updatePro(PageDTO pdto, BoardDTO bdto,
			MultipartHttpServletRequest mpRequest);
	public PageDTO deletePro(PageDTO pdto, int num);
	
}
