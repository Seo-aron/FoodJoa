package Controllers;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Common.DBConnector;
import VOs.CommunityShareVO;
import VOs.CommunityVO;
import VOs.MealkitVO;
import VOs.MemberVO;
import VOs.NoticeVO;
import VOs.RecipeVO;

@WebServlet("/Main/*")
public class MainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private String nextPage;
	private DBConnector dbConnector;

	public void init(ServletConfig config) throws ServletException {
		
		dbConnector = new DBConnector();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");

		String action = request.getPathInfo();
		System.out.println("action : " + action);

		switch (action) {
		case "/home": openMainCenterView(request, response); break;

		default:
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}

	public void openMainCenterView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setAttribute("recipes", getRecipeRank());
		request.setAttribute("mealkits", getMealkitRank());
		request.setAttribute("notices", getNotices());
		request.setAttribute("communities", getCommunityRank());
		request.setAttribute("shares", getShareRank());

		request.setAttribute("pageTitle", "세상의 모든 레시피 - Food Joa");
		request.setAttribute("center", "includes/center.jsp");

		nextPage = "/main.jsp";
	}
	
	private ArrayList<HashMap<String, Object>> getRecipeRank() {
		
		ArrayList<HashMap<String, Object>> recipes = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "r.no, r.title, r.thumbnail, r.category, r.views, "
				+ "COALESCE(average_table.avg_rating, 0) AS average_rating, "
				+ "m.nickname "
				+ "FROM recipe r "
				+ "JOIN ( "
				+ "SELECT "
				+ "rv.recipe_no, AVG(rating) as avg_rating "
				+ "FROM recipe_review rv "
				+ "GROUP BY rv.recipe_no "
				+ ") average_table "
				+ "ON r.no=average_table.recipe_no "
				+ "JOIN member m "
				+ "ON r.id=m.id "
				+ "ORDER BY average_rating DESC LIMIT 3";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				HashMap<String, Object> recipe = new HashMap<String, Object>();
				
				RecipeVO recipeVO = new RecipeVO();
				recipeVO.setNo(resultSet.getInt("no"));
				recipeVO.setTitle(resultSet.getString("title"));
				recipeVO.setThumbnail(resultSet.getString("thumbnail"));
				recipeVO.setCategory(resultSet.getInt("category"));
				recipeVO.setViews(resultSet.getInt("views"));
				
				float averageRating = resultSet.getFloat("average_rating");
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				
				recipe.put("recipeVO", recipeVO);
				recipe.put("averageRating", averageRating);
				recipe.put("memberVO", memberVO);
				
				recipes.add(recipe);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return recipes;
	}
	
	private ArrayList<HashMap<String, Object>> getMealkitRank() {
		
		ArrayList<HashMap<String, Object>> mealkits = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "k.no, k.title, k.pictures, k.category, k.views, k.price, "
				+ "COALESCE(average_table.avg_rating, 0) AS average_rating "
				+ "FROM mealkit k "
				+ "JOIN ( "
				+ "SELECT "
				+ "mv.mealkit_no, AVG(rating) as avg_rating "
				+ "FROM mealkit_review mv "
				+ "GROUP BY mv.mealkit_no "
				+ ") average_table "
				+ "ON k.no=average_table.mealkit_no "
				+ "ORDER BY average_rating DESC LIMIT 3";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				HashMap<String, Object> mealkit = new HashMap<String, Object>();
				
				MealkitVO mealkitVO = new MealkitVO();
				mealkitVO.setNo(resultSet.getInt("no"));
				mealkitVO.setTitle(resultSet.getString("title"));
				mealkitVO.setPictures(resultSet.getString("pictures"));
				mealkitVO.setCategory(resultSet.getInt("category"));
				mealkitVO.setViews(resultSet.getInt("views"));
				mealkitVO.setPrice(resultSet.getString("price"));
				
				float averageRating = resultSet.getFloat("average_rating");
				
				mealkit.put("mealkitVO", mealkitVO);
				mealkit.put("averageRating", averageRating);
				
				mealkits.add(mealkit);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return mealkits;
	}
	
	private ArrayList<NoticeVO> getNotices() {
		
		ArrayList<NoticeVO> notices = new ArrayList<NoticeVO>();
		
		String sql = "SELECT * "
				+ "FROM notice "
				+ "ORDER BY post_date DESC LIMIT 5";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				NoticeVO noticeVO = new NoticeVO(
						resultSet.getInt("no"), 
						resultSet.getString("title"), 
						resultSet.getString("contents"), 
						resultSet.getInt("views"), 
						resultSet.getTimestamp("post_date"));
				
				notices.add(noticeVO);
			}
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return notices;
	}
	
	private ArrayList<HashMap<String, Object>> getCommunityRank() {

		ArrayList<HashMap<String, Object>> communities = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "c.no, c.title, c.views, c.post_date, "
				+ "m.nickname "
				+ "FROM community c "
				+ "JOIN member m "
				+ "ON c.id=m.id "
				+ "ORDER BY c.views DESC LIMIT 5";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				HashMap<String, Object> community = new HashMap<String, Object>();
				
				CommunityVO communityVO = new CommunityVO();
				communityVO.setNo(resultSet.getInt("no"));
				communityVO.setTitle(resultSet.getString("title"));
				communityVO.setViews(resultSet.getInt("views"));
				communityVO.setPostDate(resultSet.getTimestamp("post_date"));
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				
				community.put("communityVO", communityVO);
				community.put("memberVO", memberVO);
				
				communities.add(community);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return communities;
	}
	
	private ArrayList<HashMap<String, Object>> getShareRank() {

		ArrayList<HashMap<String, Object>> shares = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "c.no, c.title, c.views, c.post_date, "
				+ "m.nickname "
				+ "FROM community_share c "
				+ "JOIN member m "
				+ "ON c.id=m.id "
				+ "ORDER BY c.views DESC LIMIT 5";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				HashMap<String, Object> share = new HashMap<String, Object>();
				
				CommunityShareVO shareVO = new CommunityShareVO();
				shareVO.setNo(resultSet.getInt("no"));
				shareVO.setTitle(resultSet.getString("title"));
				shareVO.setViews(resultSet.getInt("views"));
				shareVO.setPostDate(resultSet.getTimestamp("post_date"));
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				
				share.put("shareVO", shareVO);
				share.put("memberVO", memberVO);
				
				shares.add(share);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return shares;
	}
}
