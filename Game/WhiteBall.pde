public class WhiteBall extends Ball {
  public boolean isMovable; //can the player move the white ball?
  public boolean moving; //to avoid staggered movement
  
  private Ball firstContact;
  private Ball firstPot;

  //constructor
  public WhiteBall(float x, float y) {
    super(0, x, y);
    isMovable = false;
    moving = isMovable;
    
    firstContact = null;
    firstPot = null;
  }

  public Ball getFirstContact() {
     return firstContact;
  }
  public Ball getFirstPot() {
     return firstPot;
  }
  public void setFirstContact(Ball fc) {
     firstContact = fc;
  }
  public void setFirstPot(Ball fp) {
    firstPot = fp;
  }

  public void show() {
    noStroke();
    fill(#F5ECCD);
    circle(position.x, position.y, size);

    if (isMovable) {//explain movability
      fill(0);
      if (breaking) {
        text("You are breaking. You have the cue ball in hand.", cornerX, height - cornerY + edgeThickness);
      } else {
        text("You potted the cue ball. You have the cue ball in hand.", cornerX, height - cornerY + edgeThickness);
      }
    }
  }

  //override pot
  public void pot() {
    //detect corners
    for (float x : pocketXs) {
      for (float y : pocketYs) {
        float d = dist(position.x, position.y, x, y);
        if (d < 0.1) {//equals threshold, take it out
          if (allDone && processingDone) {
            isPotted = false;
            position = new PVector(250, 250);
            //not inside another ball?
            for (Ball b : balls) {
              if (b != white) {
                PVector posDiff = white.position.copy().sub(b.position.copy());
                if (posDiff.mag() < Ball.size) {
                  posDiff.setMag(Ball.size);
                  white.position = posDiff.add(b.position);
                }
              }
            }
            isMovable = true;
          }
        } else if (d < pocketDiam/2) {//in pocket?
          isPotted = true;
          reset();
          PVector shift = new PVector(x - position.x, y - position.y);
          shift.setMag(min(shift.mag(), 1));
          position.add(shift);//move into pocket
        }
      }
    }
  }
}
