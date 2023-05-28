public class WhiteBall extends Ball {
  public boolean isMovable; //can the player move the white ball?
  
  //constructor
  public WhiteBall(float x, float y) {
    super(0, x, y);
    isMovable = false;
  }
  
  
}
