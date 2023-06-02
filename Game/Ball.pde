public class Ball {
  //change these if necessary
  public static final float size = 20; //diameter for appearance

  //for physics
  public static final float mass = 0.17; //kg
  public static final float slidingMu = 0.2; //ball to table initial
  public static final float rollingMu = 0.001; //ball to table rolling threshold
  public static final float ballRestitution = 0.95; //ball to ball collision (collide())
  public static final float railRestitution = 0.75; //ball to rail collision (bounce())

  public static final float gravity = 9.81;

  //for ball colors
  public color[] ballColors = new color[] {#F5ECCD, #FFD700, #0000FF, #FF0000, #800080, #FFA500, #228B22, #800000,
    #000000, #FFD700, #0000FF, #FF0000, #800080, #FFA500, #228B22, #800000}; //ball colors by number, 0 is white

  //for ball identification
  private int number;
  private color ballColor;
  private String type;

  //for physical properties of the ball
  public PVector position;
  public PVector velocity;
  public PVector acceleration;

  public int hitTime; //to change friction; in frames
  public int originalHitTime;

  //for pool logic
  public boolean isPotted; //consider in pot()
  public boolean isMoving; //consider in collide() and bounce() and move()

  // for collision logic
  private double y0;
  private double x0;
  private double y1;
  private double x1;
  private double y;
  private double x;
  private PVector v0;
  private PVector v1;
  private PVector v;

  public Ball(int n, float x, float y) {
    //assign appearance
    number = n;
    ballColor = ballColors[number];

    //assign type
    if (n == 0) {
      type = "white";
    } else if (n < 8) {
      type = "solid";
    } else if (n == 8) {
      type = "eight";
    } else {
      type = "striped";
    }

    //assign vectors
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    hitTime = 0;
    originalHitTime = hitTime;

    //assign booleans
    isPotted = false;
    isMoving = false;
  }

  public void show() {
    noStroke();
    fill(ballColor);
    circle(position.x, position.y, size);
    textSize(12.5);
    fill(255);
    if (number < 10) {
      text("" + number, position.x - 3.5, position.y + 4);
    } else {
      text("" + number, position.x - 7, position.y + 4);
    }

    if (type == "striped") {
      fill(255);
      noStroke();
      arc(position.x, position.y, size, size, PI/5, 4*PI/5, CHORD);
      arc(position.x, position.y, size, size, 6*PI/5, 9*PI/5, CHORD);
    }
  }

  public void applyForce(PVector f) {
    acceleration.add(f.copy().div(mass));
    isMoving = true;
    hitTime = round(f.mag()*2);
    originalHitTime = hitTime;
    if(originalHitTime == 0) {
      originalHitTime = 1;
    }
  }

  public void move() {
    if (isMoving) {
      velocity.add(acceleration);
      
      //check for stop moving
      if (velocity.equals(new PVector(0, 0)) || acceleration.equals(new PVector(0, 0))) {
        reset();
      } else if (velocity.mag() < acceleration.mag() * 0.51 && Math.abs(velocity.heading() - acceleration.heading()) < 0.1) {//requires velocity and acceleration directions to be the same
        reset();
      }
      
      position.add(velocity);

      //apply friction (INCORPORATES HIT TIME)
      acceleration = velocity.copy().setMag(gravity * (rollingMu + (slidingMu - rollingMu) * hitTime/originalHitTime)).rotate(PI);
      if (hitTime > 0) {
        hitTime--;
      }
    }
  }

  public void pot() {
    //detect corners
    for (float x : pocketXs) {
      for (float y : pocketYs) {
        float d = dist(position.x, position.y, x, y);
        if (d < 0.1) {//equals threshold
          //animate and slide
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

  public void reset() {
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    isMoving = false;
  }

  public void bounce(Ball other) {
    PVector posDiff = other.position.copy().sub(position.copy()); //from this to other; x2 - x1
    if(posDiff.mag() < size) {//touching or overlapped
      //offset positions, should ensure that this only runs once per pair of balls
      PVector offset = posDiff.copy().setMag((size - posDiff.mag())/2);
      other.position.add(offset);
      position.sub(offset);
      
      //calculate difference in velocities
      PVector velDiff = other.velocity.copy().sub(velocity.copy()); //from this to other; v2 - v1
      //recalculate difference in position
      posDiff.setMag(size);
      
      //calculate applied velocities
      float magnitude = (velDiff.x * posDiff.x + velDiff.y * posDiff.y)/posDiff.mag();
      PVector applyToThis = posDiff.copy().setMag(magnitude);
      PVector applyToOther = posDiff.copy().rotate(PI).setMag(magnitude);
      
      this.applyForce(applyToThis.mult(mass * ballRestitution));
      this.hitTime = 0;
      other.applyForce(applyToOther.mult(mass * ballRestitution));
      other.hitTime = 0; //no sliding
    }
  }

  public void collide() {
    // HORIZONTAL AND VERTICAL WALLS

    // top left
    if (position.y - size / 2 <= cornerY + centerOffset + edgeThickness && position.x >= cornerX + centerOffset + pocketDiam / 2 + edgeThickness
      && position.x <= width / 2 - pocketDiam / 2 - edgeThickness) {
      position.y = cornerY + centerOffset + edgeThickness + size / 2;
      velocity.rotate(-2 * velocity.heading());
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // top right
    if (position.y - size / 2 <= cornerY + centerOffset + edgeThickness && position.x <= width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness
      && position.x >= width / 2 + pocketDiam / 2 + edgeThickness) {
      position.y = cornerY + centerOffset + edgeThickness + size / 2;
      velocity.rotate(-2 * velocity.heading());
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // bottom left
    if (position.y + size / 2 >= height - cornerY - centerOffset - edgeThickness && position.x >= cornerX + centerOffset + + pocketDiam / 2 + edgeThickness
      && position.x <= width / 2 - pocketDiam / 2 - edgeThickness) {
      position.y = height - cornerY - centerOffset - edgeThickness - size / 2;
      velocity.rotate(-2 * velocity.heading());
      velocity.setMag(velocity.mag() * railRestitution);
    }
    // bottom right
    if (position.y + size / 2 >= height - cornerY - centerOffset - edgeThickness && position.x <= width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness
      && position.x >= width / 2 + pocketDiam / 2 + edgeThickness) {
      position.y = height - cornerY - centerOffset - edgeThickness - size / 2;
      velocity.rotate(-2 * velocity.heading());
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // left
    if (position.x - size / 2 <= cornerX + centerOffset + edgeThickness && position.y >= cornerY + centerOffset + pocketDiam / 2 + edgeThickness
      && position.y <= height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness) {
      position.x = cornerX + centerOffset + edgeThickness + size / 2;
      velocity.rotate(PI - 2 * velocity.heading());
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // right
    if (position.x + size / 2 >= width - cornerX - centerOffset - edgeThickness && position.y >= cornerY + centerOffset + pocketDiam / 2 + edgeThickness
      && position.y <= height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness) {
      position.x = width - cornerX - centerOffset - edgeThickness - size / 2;
      velocity.rotate(-PI - 2 * velocity.heading());
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // --------------------------------------------------------

    // CORNER WALLS


    // top left: left (1)
    y0 = cornerY + centerOffset;
    x0 = cornerX + centerOffset + pocketDiam / 2;
    y1 = cornerY + centerOffset + edgeThickness;
    x1 = cornerX + centerOffset + pocketDiam / 2 + edgeThickness;
    y = position.y - size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    if (v.x >= v0.x && v.x <= v1.x && v.y <= v0.y) { // ball is in the region
      v.set(v.x, v0.y + size / 2);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // --------------------------------------------------------

    // top right: left (2)
    y0 = cornerY + centerOffset;
    x0 = width / 2 + pocketDiam / 2;
    y1 = cornerY + centerOffset + edgeThickness;
    x1 = width / 2 + pocketDiam / 2 + edgeThickness;
    y = position.y - size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    if (v.x >= v0.x && v.x <= v1.x && v.y <= v0.y) { // ball is in the region
      v.set(v.x, v0.y + size / 2);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // --------------------------------------------------------

    // left: bottom (3)
    y0 = height - cornerY - centerOffset - pocketDiam / 2;
    x0 = width - cornerX - centerOffset;
    y1 = y0 - edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y - size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    //
    if (v.x >= v1.x && v.x <= v0.x && v.y <= v0.y) { // ball is in the region
      v.set(v.x, v0.y + size / 2);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }


    // --------------------------------------------------------

    // bottom right: right (4)
    y0 = height - cornerY - centerOffset;
    x0 = width - cornerX - centerOffset - pocketDiam / 2;
    y1 = y0 - edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x - size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    //
    if (v.x >= v1.x && v.x <= v0.x && v.y >= v0.y) { // ball is in the region
      v.set(v.x, v0.y - size / 2);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }


    // --------------------------------------------------------

    // bottom left: right (5)
    y0 = height - cornerY - centerOffset;
    x0 = width / 2 - pocketDiam / 2;
    y1 = y0 - edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x - size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    //
    if (v.x >= v1.x && v.x <= v0.x && v.y >= v0.y) { // ball is in the region
      v.set(v.x, v0.y - size / 2);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }


    // --------------------------------------------------------

    // left: top (6)
    y0 = cornerY + centerOffset + pocketDiam / 2;
    x0 = cornerX + centerOffset;
    y1 = y0 + edgeThickness;
    x1 = x0 + edgeThickness;
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x - size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    //
    if (v.x >= v0.x && v.x <= v1.x && v.y >= v0.y) { // ball is in the region
      v.set(v.x, v0.y - size / 2);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }


    // --------------------------------------------------------

    // top left: right (7)
    y0 = cornerY + centerOffset;
    x0 = width / 2 - pocketDiam / 2;
    y1 = y0 + edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y - size / (2 * Math.sqrt(2));
    x = position.x - size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    //
    if (v.y >= v0.y && v.y <= v1.y && v.x <= v0.x) { // ball is in the region
      v.set(v0.x + size / 2, v.y);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // --------------------------------------------------------

    // top right: right (8)
    y0 = cornerY + centerOffset;
    x0 = width - cornerX - centerOffset - pocketDiam / 2;
    y1 = y0 + edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    //
    if (v.y >= v0.y && v.y <= v1.y && v.x <= v0.x) { // ball is in the region
      v.set(v0.x + size / 2, v.y);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // --------------------------------------------------------

    // left: bottom (9)
    y0 = height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness;
    x0 = cornerX + centerOffset + edgeThickness;
    y1 = y0 + edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y - size / (2 * Math.sqrt(2));
    x = position.x - size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    //
    if (v.y >= v0.y && v.y <= v1.y && v.x <= v0.x) { // ball is in the region
      v.set(v0.x + size / 2, v.y);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // --------------------------------------------------------

    // bottom left: left (10)
    y0 = height - cornerY - centerOffset - edgeThickness;
    x0 = cornerX + centerOffset + pocketDiam / 2 + edgeThickness;
    y1 = y0 + edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    //
    if (v.y >= v0.y && v.y <= v1.y && v.x >= v0.x) { // ball is in the region
      v.set(v0.x - size / 2, v.y);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }


    // --------------------------------------------------------

    // bottom right: left (11)
    y0 = height - cornerY - centerOffset - edgeThickness;
    x0 = width / 2 + pocketDiam / 2 + edgeThickness;
    y1 = y0 + edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    if (v.y >= v0.y && v.y <= v1.y && v.x >= v0.x) { // ball is in the region
      v.set(v0.x - size / 2, v.y);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }


    // --------------------------------------------------------

    // left: top (12)
    y0 = cornerY + centerOffset + pocketDiam / 2;
    x0 = width - cornerX - centerOffset;
    y1 = y0 + edgeThickness;
    x1 = x0 - edgeThickness;
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));

    v0 = rot45Neg((float)x0, (float)y0);
    v1 = rot45Neg((float)x1, (float)y1);
    v = rot45Neg((float)x, (float)y);

    if (v.y >= v0.y && v.y <= v1.y && v.x >= v0.x) { // ball is in the region
      v.set(v0.x - size / 2, v.y);
      position.set(rot45Pos(v.x, v.y));
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
      velocity.setMag(velocity.mag() * railRestitution);
    }

    // --------------------------------------------------------
  }

  public PVector rot45Neg(float i, float j) {
    return new PVector((float)((i + j) / Math.sqrt(2)), (float)((j - i) / Math.sqrt(2)));
  }

  public PVector rot45Pos(float i, float j) {
    return new PVector((float)((i - j) / Math.sqrt(2)), (float)((i + j) / Math.sqrt(2)));
  }
}
