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
      if(velocity.mag() < acceleration.mag() * 0.51 && Math.abs(velocity.heading() - acceleration.heading()) < 0.1) {//requires velocity and acceleration directions to be the same
        reset();
      }
      
      position.add(velocity);
      
      //apply friction (INCORPORATES HIT TIME)
      acceleration = velocity.copy().setMag(gravity * (rollingMu + (slidingMu - rollingMu) * hitTime/originalHitTime)).rotate(PI);
      if(hitTime > 0) {
        hitTime--;
      }
    }
  }

  public void reset() {
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    isMoving = false;
  }
}
