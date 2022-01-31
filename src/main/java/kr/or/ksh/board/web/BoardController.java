package kr.or.ksh.board.web;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.ksh.board.dto.BoardDTO;
import kr.or.ksh.board.dto.PageDTO;
import kr.or.ksh.board.service.BoardListService;
import kr.or.ksh.board.service.BoardWriteService;
import kr.or.ksh.common.ServletUpload;

@Controller
public class BoardController {
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	//DI(Dependency Injection)
	@Autowired
	private BoardListService boardListService;//getArticle(s): boardList, content
	
	//write에 해당되는 것 
	@Autowired
	private BoardWriteService boardWriteService;//getArticle(s)
	
	/*
	  DI 방법 어노테이션 @Autowired, @inject,    @Resource
	                     지원자   스프링전용        자바에서 지원    자바에서 지원
	                    연결방식 타입에 맞춰서    타입에 맞춰서    이름으로 연결
    @Autowired
    //@Qualifier("BoardWriteServiceImpl")
	private BoardWriteService boardWriteService;
	좀더 강력하다고 함	                    
	 */
	
	 
	//갱신에 관계 된거 , update, delete
	@RequestMapping(value = "/boardList.sp")
	public String boardList(HttpServletRequest request,
			                HttpServletResponse response,  
			                Model model,
			                BoardDTO bdto, PageDTO pdto) {
		// service를 DI(Dependency Injection) 하고
		// 해당 service의 메소드를 호출한 후
		// model이나 기타 DTO 저장하여 view로 전달
		// 비즈니스 로직을 적지 않음
		pdto.setAllCount(boardListService.getAllcount());
		logger.info("현재페이지: "+pdto.getCurrentPage());
		List<BoardDTO> list= 
				boardListService.getArticles(pdto);
		model.addAttribute("pdto", pdto);
		model.addAttribute("list", list);
		return "board2/boardList";
	}
	
	@RequestMapping(value="/content.sp")
	public String content(HttpServletRequest request,
			HttpServletResponse response,  
			Model model, BoardDTO bdto, PageDTO pdto) {
		Map<String, Object> cmap = 
				boardListService.getArticle(bdto,pdto);
		 /*
		   ModelAndView mav = new ModelAndView();
		   Model도 있고, view 도 있음
		   mav.addObject("pdto", pdto);
   		   mav.setView("board2/content");
   		   return mav;
		  */
		  model.addAttribute("pdto", (PageDTO)cmap.get("pdto"));
		  model.addAttribute("bdto", (BoardDTO)cmap.get("bdto"));
		return "board2/content";
	}
	
	@RequestMapping(value="/writeForm.sp")
	public String writeForm(HttpServletRequest request,
            HttpServletResponse response,  
            Model model,BoardDTO bdto, PageDTO pdto) {
		    PageDTO pdto2 = boardWriteService.writeArticle(pdto);
		    model.addAttribute("pdto", pdto2);
		    model.addAttribute("bdto", bdto); //받아온걸다시 넣어주기
		return "board2/writeForm";
	}
	@RequestMapping(value="/writePro.sp")
	public String writePro(Model model,BoardDTO bdto, PageDTO pdto, 
			    MultipartHttpServletRequest mpRequest) {
 		boardWriteService.writeProArticle(bdto, mpRequest);
 		logger.info("f"+bdto.getFileNo());
		//boardWriteService.writeProArticle(bdto);
		 if(pdto.getCurrentPage()==0) {
			 pdto.setCurrentPage(1); 
		   }
		 if(pdto.getCurrPageBlock()==0) {
			 pdto.setCurrPageBlock(1);
		   }
		 
		model.addAttribute("pdto", pdto);
		
		return "board2/writePro";
	}
	
	@RequestMapping(value="/idCheck.sp")
	public String idCheck() {
		return "board2/idCheck";
	}
	
	@RequestMapping(value="/updateForm.sp")
	public String updateForm(HttpServletRequest request,
			HttpServletResponse response,  
			Model model,BoardDTO bdto, PageDTO pdto) {
		Map<String, Object> cmap = 
				boardListService.getArticle(bdto,pdto);
		  model.addAttribute("pdto", (PageDTO)cmap.get("pdto"));
		  model.addAttribute("bdto", (BoardDTO)cmap.get("bdto"));
		return "/board2/updateForm";
	}
	
	//updatePro 처리용 하나 생성 필요
	@RequestMapping(value="/updatePro.sp")
	public String updatePro(MultipartHttpServletRequest mpRequest,  
			Model model,BoardDTO bdto, PageDTO pdto) {
		
		//서비스 호출
		PageDTO pdto2 = boardWriteService.updatePro(pdto, bdto, mpRequest);
		model.addAttribute("pdto", pdto2);
		String urlPage= "currentPage="+pdto2.getCurrentPage()+"&currPageBlock="+pdto2.getCurrPageBlock();
		return "redirect:/boardList.sp?"+urlPage;
	}

	
	@RequestMapping(value="/deletePro.sp")
	public String deletePro(Model model,BoardDTO bdto, PageDTO pdto) {
		//서비스 호출
		PageDTO pdto2 = boardWriteService.deletePro(pdto, bdto.getNum());
		model.addAttribute("pdto2", pdto2);
		logger.info("pdto2"+pdto2.getCurrentPage());
		String urlPage= "currentPage="+pdto2.getCurrentPage()+"&currPageBlock="+pdto2.getCurrPageBlock();
		return "redirect:/boardList.sp?"+urlPage;
	}
	
	@RequestMapping(value="/fileDown.sp")
	public void fileDown(HttpServletResponse response,Model model,BoardDTO bdto, PageDTO pdto) {
		try {
		byte fileByte[] = FileUtils.readFileToByteArray(new File(ServletUpload.UPLOAD_DIR+bdto.getAttachNm()));
		response.setContentType("application/octet-stream");
		response.setContentLength(fileByte.length);
		response.setHeader("Content-Disposition",  "attachment; fileName=\""+URLEncoder.encode(bdto.getOrgFileNm(), "UTF-8")+"\";");
		response.getOutputStream().write(fileByte);
		response.getOutputStream().flush();
		response.getOutputStream().close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	
}
