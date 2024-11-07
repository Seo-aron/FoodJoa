package VOs;

import java.sql.Timestamp;

public class RecipeReviewVO {

	private int no;
	private String id;
	private int recipeNo;
	private String pictures;
	private String contents;
	private float rating;
	private int empathy;
	private Timestamp postDate;

	public RecipeReviewVO() {
	}
	
	public RecipeReviewVO(int no, String id, int recipeNo, String pictures, String contents, float rating,
			int empathy) {
		
		this.no = no;
		this.id = id;
		this.recipeNo = recipeNo;
		this.pictures = pictures;
		this.contents = contents;
		this.rating = rating;
		this.empathy = empathy;
	}

	public RecipeReviewVO(int no, String id, int recipeNo, String pictures, String contents, float rating, int empathy,
			Timestamp postDate) {

		this(no, id, recipeNo, pictures, contents, rating, empathy);
		this.postDate = postDate;
	}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getRecipeNo() {
		return recipeNo;
	}

	public void setRecipeNo(int recipeNo) {
		this.recipeNo = recipeNo;
	}

	public String getPictures() {
		return pictures;
	}

	public void setPictures(String pictures) {
		this.pictures = pictures;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public float getRating() {
		return rating;
	}

	public void setRating(float rating) {
		this.rating = rating;
	}

	public int getEmpathy() {
		return empathy;
	}

	public void setEmpathy(int empathy) {
		this.empathy = empathy;
	}

	public Timestamp getPostDate() {
		return postDate;
	}

	public void setPostDate(Timestamp postDate) {
		this.postDate = postDate;
	}
}
