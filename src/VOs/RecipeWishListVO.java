package VOs;

public class RecipeWishListVO {

	private int no;
	private String id;
	private int recipeNo;
	
	public RecipeWishListVO() {
	}

	public RecipeWishListVO(int no, String id, int recipeNo) {
	
		this.no = no;
		this.id = id;
		this.recipeNo = recipeNo;
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
}
