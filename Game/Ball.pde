public class Ball {
  //change these if necessary
  public static final int size = 20; //diameter for appearance
  
  //for physics
  public static final float mass = 0.17; //kg
  public static final float slidingMu = 0.2; //ball to table initial
  public static final float rollingMu = 0.01; //ball to table rolling
  public static final float ballRestitution = 0.95; //ball to ball collision (collide())
  public static final float railRestitution = 0.75; //ball to rail collision (bounce())

  //for ball colors
  public color[] ballColors = new color[] {#FFFFFF, #FFD700, #0000FF, #FF0000, #800080, #FFA500, #228B22, #800000,
    #000000, #FFD700, #0000FF, #FF0000, #800080, #FFA500, #228B22, #800000}; //ball colors by number, 0 is white
  
  //for ball identification
  private int number;
  private color ballColor;
  private String type;

  //for physical properties of the ball
  public PVector position;
  public PVector velocity;
  public PVector acceleration;
  public PVector friction; //?
  
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

  public void move() {
    if (isMoving) {
      position.add(velocity);
      velocity.add(acceleration);
      /*velocity = new PVector(0, 0);
      acceleration = new PVector(0, 0);
      friction = new PVector(0, 0);
      isMoving = false;*/
    }
  }
}
