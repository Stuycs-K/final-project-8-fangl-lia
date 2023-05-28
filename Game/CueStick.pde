public class CueStick {
  public PImage stick;
  public PVector direction;
  public float power;
  public boolean isShowing;
  
  public CueStick() {
    stick = loadImage("cue-stick.png");
    stick.resize(300, 35);
    direction = new PVector(0, 0);
    power = 0;
    isShowing = true;
  }
  
  public void show() {
    if(isShowing) {
      //to rotate
      direction = new PVector(mouseX - white.position.x, mouseY - white.position.y); //towards the mouse as well as the cue
      
      translate(white.position.x, white.position.y);
      
      rotate(direction.heading() - PI);
      imageMode(CENTER);
      image(stick, 0, 0); //correct position to the ball
      
      //reverse transformations of the plane
      
    }
  }
}
