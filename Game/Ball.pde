public class Ball {
  //change these if necessary
  public static final int size = 20; //diameter for appearance

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
    acceleration = f.copy().div(mass);
    isMoving = true;
    hitTime = round(f.mag()*2);
    originalHitTime = hitTime;
  }

  public void move() {
    if (isMoving) {
      velocity.add(acceleration);

      println(position.x + ", " + position.y);

      //check for stop moving
      if (velocity.mag() < acceleration.mag() * 0.51 && Math.abs(velocity.heading() - acceleration.heading()) < 0.1) {//requires velocity and acceleration directions to be the same
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
          isPotted = true;
          //animate and slide
        } else if (d < pocketDiam/2) {//in pocket?
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

  public void collide() {
    // HORIZONTAL AND VERTICAL WALLS

    // top left
    if (position.y - size / 2 <= cornerY + centerOffset + edgeThickness && position.x >= cornerX + centerOffset + pocketDiam / 2 + edgeThickness
      && position.x <= width / 2 - pocketDiam / 2 - edgeThickness) {
      velocity.rotate(-2 * velocity.heading());
    }
    // top right
    if (position.y - size / 2 <= cornerY + centerOffset + edgeThickness && position.x <= width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness
      && position.x >= width / 2 + pocketDiam / 2 + edgeThickness) {
      velocity.rotate(-2 * velocity.heading());
    }

    // bottom left
    if (position.y + size / 2 >= height - cornerY - centerOffset - edgeThickness && position.x >= cornerX + centerOffset + + pocketDiam / 2 + edgeThickness
      && position.x <= width / 2 - pocketDiam / 2 - edgeThickness) {
      velocity.rotate(-2 * velocity.heading());
    }
    // bottom right
    if (position.y + size / 2 >= height - cornerY - centerOffset - edgeThickness && position.x <= width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness
      && position.x >= width / 2 + pocketDiam / 2 + edgeThickness) {
      velocity.rotate(-2 * velocity.heading());
    }

    // left
    if (position.x - size / 2 <= cornerX + centerOffset + edgeThickness && position.y >= cornerY + centerOffset + pocketDiam / 2 + edgeThickness
      && position.y <= height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness) {
      velocity.rotate(PI - 2 * velocity.heading());
    }

    // right
    if (position.x + size / 2 >= width - cornerX - centerOffset - edgeThickness && position.y >= cornerY + centerOffset + pocketDiam / 2 + edgeThickness
      && position.y <= height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness) {
      velocity.rotate(-PI - 2 * velocity.heading());
    }
    
    
    
    
    
    // CORNER WALLS
    int threshold = 7;
    
    // top left: left
    if (position.y - size / (2 * Math.sqrt(2)) <= position.x + size / (2 * Math.sqrt(2)) - (cornerX + centerOffset + pocketDiam / 2) +  (cornerY + centerOffset) 
      && position.x + size / (2 * Math.sqrt(2)) >= cornerX + centerOffset + pocketDiam / 2 - threshold
      && position.x + size / (2 * Math.sqrt(2)) <= cornerX + centerOffset + pocketDiam / 2 + edgeThickness + threshold) {
      println(true);
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
    }
    // top right: left
    if (position.y - size / (2 * Math.sqrt(2)) <= position.x + size / (2 * Math.sqrt(2)) - (width/2 + pocketDiam / 2) +  (cornerY + centerOffset) 
      && position.x + size / (2 * Math.sqrt(2)) >= width/2 + pocketDiam / 2 - threshold
      && position.x + size / (2 * Math.sqrt(2)) <= width/2 + pocketDiam / 2 + edgeThickness + threshold) {
      println(true);
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
    }
    // bottom left: left
    if (position.y + size / (2 * Math.sqrt(2)) - (height - cornerY - centerOffset) >= -(position.x + size / (2 * Math.sqrt(2))) + (cornerX + centerOffset + pocketDiam / 2)  
      && position.x + size / (2 * Math.sqrt(2)) >= cornerX + centerOffset + pocketDiam / 2 - threshold
      && position.x + size / (2 * Math.sqrt(2)) <= cornerX + centerOffset + pocketDiam / 2 + edgeThickness + threshold) {
      println(true);
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
    }
    // bottom right: left
    if (position.y + size / (2 * Math.sqrt(2)) - (height - cornerY - centerOffset) >= -(position.x + size / (2 * Math.sqrt(2))) + (width/2 + pocketDiam / 2)  
      && position.x + size / (2 * Math.sqrt(2)) >= width/2 + pocketDiam / 2 - threshold
      && position.x + size / (2 * Math.sqrt(2)) <= width/2 + pocketDiam / 2 + edgeThickness + threshold) {
      println(true);
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
    }
    
    
    // top left: right
    double y = position.y - size / (2 * Math.sqrt(2));
    double x = position.x - size / (2 * Math.sqrt(2));
    double y0 = cornerY + centerOffset;
    double x0 = width / 2 - pocketDiam / 2;
    if (y - y0 <= -(x - x0) 
      && x >= x0 - edgeThickness - threshold
      && x <= x0 + threshold) {
      println(true);
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
    }
    // top right: right
    y0 = cornerY + centerOffset;
    x0 = width - cornerX - centerOffset - pocketDiam / 2;
    if (y - y0 <= -(x - x0) 
      && x >= x0 - edgeThickness - threshold
      && x <= x0 + threshold) {
      println(false);
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
    }
    // bottom left: right
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x - size / (2 * Math.sqrt(2));
    y0 = width / 2 - cornerY - centerOffset;
    x0 = width / 2 - pocketDiam / 2;
    if (y - y0 >= x - x0 
      && x >= x0 - edgeThickness - threshold
      && x <= x0 + threshold) {
      println(true);
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
    }
    // bottom right: right
    y0 = width / 2 - cornerY - centerOffset;
    x0 = width - cornerX - centerOffset - pocketDiam / 2;
    if (y - y0 >= x - x0 
      && x >= x0 - edgeThickness - threshold
      && x <= x0 + threshold) {
      println(true);
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
    }
    
    
    // left: top
    y0 = cornerY + centerOffset + pocketDiam / 2;
    x0 = cornerX + centerOffset;
    if (y - y0 >= x - x0 
      && y >= y0 - threshold
      && y <= y0 + edgeThickness + threshold) {
      println(true);
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
    }
    // left: bottom
    y = position.y - size / (2 * Math.sqrt(2));
    x = position.x - size / (2 * Math.sqrt(2));
    y0 = height - cornerY - centerOffset - pocketDiam / 2;
    x0 = cornerX + centerOffset;
    if (y - y0 <= -(x - x0) 
      && y >= y0 - edgeThickness - threshold
      && y <= y0 + threshold) {
      println(true);
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
    }
    // right: top
    y = position.y + size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));
    y0 = cornerY + centerOffset + pocketDiam / 2;
    x0 = width - cornerX - centerOffset;
    if (y - y0 >= -(x - x0)
      && y >= y0 - threshold
      && y <= y0 + edgeThickness + threshold) {
      println(true);
      velocity.rotate(2 * (-PI / 4 - velocity.heading()));
    }
    // right: bottom
    y = position.y - size / (2 * Math.sqrt(2));
    x = position.x + size / (2 * Math.sqrt(2));
    y0 = height - cornerY - centerOffset - pocketDiam / 2;
    x0 = width - cornerX - centerOffset;
    if (y - y0 <= x - x0 
      && y >= y0 - edgeThickness - threshold
      && y <= y0 + threshold) {
      println(true);
      velocity.rotate(2 * (PI / 4 - velocity.heading()));
    }
    
    
    
    
  }
  
  
}
