package Services;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import DAOs.MealkitDAO;
import VOs.MealkitVO;

public class MealkitService {
	
	private MealkitDAO mealkitDAO;
	
	public MealkitService() {
		
		mealkitDAO = new MealkitDAO();
	}

	public ArrayList<MealkitVO> getMealkitsList() {
		
		return mealkitDAO.selectMealkits();
	}

	public MealkitVO getMealkitInfo(HttpServletRequest request) {
		
		int no = Integer.parseInt(request.getParameter("no"));
		
		return mealkitDAO.InfoMealkit(no);
	}

}
