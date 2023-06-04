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
      image(stick, -165 - extend, 0); //correct position to the ball\

      //reverse transformations of the plane
      rotate(-1 * direction.heading());
      translate(-1 * white.position.x, -1 * white.position.y);

      //calculate if aiming will hit a ball
      Ball c = null; //null if nothing, then set to closest one
      float distanceToBall = -1; //-1 if nothing, then set to closest one

      for (Ball b : balls) {
        if (b != white && !b.isPotted) {//can't be the white ball itself
          PVector towards = b.position.copy().sub(white.position.copy());
          float angle = Math.abs(towards.heading() - direction.heading());
          if (angle < PI/2 && sin(angle) < Ball.size/(towards.mag())) { //trig, checks for colliding with another ball
            //law of sines
            float ratio = sin(angle)/Ball.size;
            float secondAngle = PI - asin(ratio * towards.mag());
            float thirdAngle = PI - angle - secondAngle;
            float distance = sin(thirdAngle)/ratio;
            if(ratio == 0) {//undefined stuff
              distance = towards.mag() - Ball.size;
            }
            
            if (distanceToBall == -1 || distance < distanceToBall) {
              distanceToBall = distance;
              c = b; //set the ball to be the colliding one
            }
          }
        }
      }

      if (c == null) { //no collisions
        
      } else { //collides
        PVector out = direction.copy().setMag(distanceToBall);
        strokeWeight(2);
        stroke(240);
        fill(106, 182, 99);
        
        circle(white.position.x + out.x, white.position.y + out.y, Ball.size);
        line(white.position.x, white.position.y, white.position.x + out.x, white.position.y + out.y);
        
        PVector outer = white.position.copy().add(out.copy());
        PVector in = c.position.copy().sub(outer);
        line(outer.x, outer.y, outer.x + in.x, outer.y + in.y);
      }
    }
  }
}
