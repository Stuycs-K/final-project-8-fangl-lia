  public class WhiteBall extends Ball {
  public boolean isMovable; //can the player move the white ball?
  
  //constructor
  public WhiteBall(float x, float y) {
    super(0, x, y);
    isMovable = false;
  }
  
  public void show() {
    noStroke();
    fill(#F5ECCD);
    circle(position.x, position.y, size);
  }
  
  //override pot later
}
