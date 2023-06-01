public class CueStick {
  public PImage stick;
  public PVector direction;
  public float power;
  public boolean showable; //for the purpose of disappearing when something happens to the white ball

  public CueStick() {
    stick = loadImage("cue-stick.png");
    stick.resize(300, 35);
    direction = new PVector(0, 0);
    power = 0;
    showable = true;
  }

  public void show() {
    if ((game != FIRE || extend > -5) && showable) {//things are not moving
      //to rotate, if aiming, don't move the cue
      if (game == READY) {
        direction = new PVector(mouseX - white.position.x, mouseY - white.position.y); //towards the mouse as well as the cue
      }

      translate(white.position.x, white.position.y);

      rotate(direction.heading());
      imageMode(CENTER);
      image(stick, -165 - extend, 0); //correct position to the ball

      //reverse transformations of the plane
      rotate(-1 * direction.heading());
      translate(-1 * white.position.x, -1 * white.position.y);
    }
  }
}
