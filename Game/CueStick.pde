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
      image(stick, 500, 250);
    }
  }
}
