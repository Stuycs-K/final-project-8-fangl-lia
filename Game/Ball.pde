class Ball {
  //change these if necessary
  public final static int size = 20; //diameter
  public final static int mass = 1; //for physics
  public final static color[] ballColors = new color[] {#FFFFFF, #FFD700, #0000FF, #FF0000, #800080, #FFA500, #228B22, #800000,
                                                        #000000, #FFD700, #0000FF, #FF0000, #800080, #FFA500, #228B22, #800000}; //ball colors by number, 0 is white
  
  private int number;
  private color ballColor;
  private String type;
  public PVector position;
  public PVector velocity;
  public PVector acceleration;
  public boolean isPotted;
  public boolean isMoving;
  
  public Ball(int n, float x, float y) {
    //assign appearance
    number = n;
    ballColor = ballColors[number];
    
    //assign type
    
    //assign vectors
    
    //assign booleans
  }
}
