int cornerX;
int cornerY;
int rectRadius;
float pocketDiam;
float centerOffset;
float edgeThickness;
float rackSpacing;
float rackOffset;

float[] pocketXs;
float[] pocketYs;

WhiteBall white;
CueStick cue;
Ball[] balls;
int indexOf8;

int game;
final static int READY = 0;
final static int AIM = 1;
final static int FIRE = 2;
final static int END = 3;

boolean broadcast1;
int broadcast1player;
int broadcast1timer;
boolean broadcast2;
int broadcast2timer;
int announcementDuration;

int screen;
final static int MENU = 0;
final static int PLAY = 1;

int player;
final static int PLAYER1 = 0;
final static int PLAYER2 = 1;
int stripeOwner; // only applicable once groups have been made
int[] numOldPotted;
int[] numNewPotted;
int numHitRail;

PImage blueAvatar;
PImage redAvatar;
float avatarSize;
int yellowTint;
boolean yellowTintIncreasing;

int winner; // -1 if game hasn't ended, 0 if player 1, 1 if player 2
float endScreenHeight;
float endScreenWidth;

boolean foulMade;
String foulMessage;
final static String OPEN8HIT = "FOUL! You need to hit either a striped or solid ball.";
final static String NOHIT = "FOUL! The cue ball did not strike another ball.";
final static String NOSOLIDHIT = "FOUL! You must hit a solid ball.";
final static String NOSTRIPEDHIT = "FOUL! You must hit a striped ball.";
final static String POTCUE = "FOUL! You potted the cue ball.";
final static String NO8HIT = "FOUL! You must hit the 8-ball.";
final static String SOFTHIT = "FOUL! No balls struck a rail after contact.";
final static String ILLEGALBREAK = "FOUL! You made an illegal break.";
final static String BADPOT8 = "You lose! You did not hit the 8-ball first.";
final static String CUEPLUS8 = "You lose! You potted the cue ball along with the 8-ball.";
final static String WIN = "You win! You potted the 8-ball.";
final static String POT8 = "You lost! You potted the 8-ball.";

ArrayList<Integer> solids;
ArrayList<Integer> stripes;
PImage rack;
float rackX;
float rackY;
float rackWidth;
float rackHeight;
float rackRound;
float rackSpace;
float displacement;

PImage playButton;
float buttonHeight;
float buttonWidth;
float newButtonHeight;
float newButtonWidth;
boolean mouseOnNewButton;
float buttonOffset;

PImage poolLego;
float logoHeight;
float logoWidth;

boolean allDone;
boolean breaking; //first shot
boolean processingDone;

float extend; //for the CueStick's extension when firing
float borderBrightness; //to indicate the border of moving the WhiteBall

//for sounds
import processing.sound.*;
SoundFile ballToBall;
SoundFile pot;

void setup() {
  // basic pool table dimensions layout
  size(1000, 500);
  cornerX = 100;
  cornerY = 75;
  rectRadius = 16;
  pocketDiam = 40;
  centerOffset = 25;
  edgeThickness = 12;
  rackSpacing = 0.3;
  rackOffset = 0.6;

  //to make pot() easier
  pocketXs = new float[3];
  pocketYs = new float[2];

  pocketXs[0] = cornerX + centerOffset;
  pocketXs[1] = width/2;
  pocketXs[2] = width - pocketXs[0];

  pocketYs[0] = cornerY + centerOffset;
  pocketYs[1] = height - pocketYs[0];

  white = new WhiteBall(cornerX + 0.25 * (width - 2 * cornerX), 250);

  //CHANGE LATER TO INCLUDE ALL BALLS
  balls = new Ball[16];
  balls[0] = white;
  white.isMovable = true; //breaking allows movement
  breaking = true;

  // for rules implementation
  stripeOwner = -1; // -1 corresponds to open table
  numOldPotted = new int[2];
  numNewPotted = new int[2];
  numHitRail = 0;
  winner = -1;
  endScreenWidth = 150;
  endScreenHeight = 60;

  float xStart = cornerX + 0.75 * (width - 2 * cornerX);
  float yStart = 250;
  float xShift = Ball.size * sqrt(3)/2 + 0.01;
  float yShift = Ball.size * 1/2 + 0.01;

  //decide random racking
  int[] racking = randomizeRack();
  balls[1] = new Ball(racking[1], xStart, yStart);
  balls[2] = new Ball(racking[2], xStart + xShift, yStart + yShift);
  balls[3] = new Ball(racking[3], xStart + xShift, yStart - yShift);
  balls[4] = new Ball(racking[4], xStart + 2*xShift, yStart + 2*yShift);
  balls[5] = new Ball(racking[5], xStart + 2*xShift, yStart);
  balls[6] = new Ball(racking[6], xStart + 2*xShift, yStart - 2*yShift);
  balls[7] = new Ball(racking[7], xStart + 3*xShift, yStart + 3*yShift);
  balls[8] = new Ball(racking[8], xStart + 3*xShift, yStart + 1*yShift);
  balls[9] = new Ball(racking[9], xStart + 3*xShift, yStart - 1*yShift);
  balls[10] = new Ball(racking[10], xStart + 3*xShift, yStart - 3*yShift);
  balls[11] = new Ball(racking[11], xStart + 4*xShift, yStart + 4*yShift);
  balls[12] = new Ball(racking[12], xStart + 4*xShift, yStart + 2*yShift);
  balls[13] = new Ball(racking[13], xStart + 4*xShift, yStart);
  balls[14] = new Ball(racking[14], xStart + 4*xShift, yStart - 2*yShift);
  balls[15] = new Ball(racking[15], xStart + 4*xShift, yStart - 4*yShift);
  
  for (int i = 0; i < balls.length; i++) {
    if (balls[i].getNumber() == 8) {
      indexOf8 = i;
      break;
    }
  }

  allDone = true;

  borderBrightness = 0; //for WhiteBall border

  //to test CueStick
  cue = new CueStick();

  //game state
  game = READY;
  extend = 0;

  // game mega state
  screen = MENU;
  playButton = loadImage("play-button.png");
  buttonWidth = 130;
  buttonHeight = 60;
  newButtonWidth = buttonWidth * 1.1;
  newButtonHeight = buttonHeight * 1.1;
  buttonOffset = 100;

  poolLego = loadImage("pool-lego.png");
  logoWidth = 500;
  logoHeight = 250;
  
  blueAvatar = loadImage("newBlueAvatar.png");
  redAvatar = loadImage("newRedAvatar.png");
  avatarSize = 90;
  yellowTintIncreasing = true;
  
  announcementDuration = 120; // 60 frames per second
  
  rack = loadImage("rack.png");
  solids = new ArrayList<Integer>();
  stripes = new ArrayList<Integer>();
  for (int i = 1; i <= 7; i++) {
    solids.add(i);
  }
  for (int i = 9; i <= 15; i++) {
    stripes.add(i);
  }
  rackX = 220;
  rackY = 40;
  rackWidth = 200;
  rackHeight = 30;
  rackRound = 10;
  rackSpace = 5;
  displacement =  0.142 * rackWidth;

  //sounds
  ballToBall = new SoundFile(this, "BallToBall.mp3");
  pot = new SoundFile(this, "Pot.mp3");
}

void draw() {
  background(255);
  fill(0);
  if (screen == MENU) {
    image(poolLego, (width - logoWidth) / 2, (0.62 * height - logoHeight) / 2, logoWidth, logoHeight);
    if (!mouseOnNewButton) {
      image(playButton, (width - buttonWidth) / 2, ((height - buttonHeight) / 2 + buttonOffset), buttonWidth, buttonHeight);
      if (mouseX > (width - buttonWidth) / 2 && mouseX < (width + buttonWidth) / 2
        && mouseY > ((height - buttonHeight) / 2 + buttonOffset) && mouseY < ((height + buttonHeight) / 2 + buttonOffset)) {
        mouseOnNewButton = true;
      }
    } else {
      image(playButton, (width - newButtonWidth) / 2, ((height - newButtonHeight) / 2 + buttonOffset), newButtonWidth, newButtonHeight);
      if (!(mouseX > (width - newButtonWidth) / 2 && mouseX < (width + newButtonWidth) / 2
        && mouseY > ((height - newButtonHeight) / 2 + buttonOffset) && mouseY < ((height + newButtonHeight) / 2 + buttonOffset))) {
        mouseOnNewButton = false;
      }
    }
  }
  
  // for animating balls slididing into rack
  if (screen == PLAY) {
    drawRack();
    for (Ball b : balls) {
      if (b.isRolling) {
        b.slide();
        b.show();
      }
    }
    drawTable();
    
    // display avatars
    displayAvatars();
    
    // display racks
    displayRacks();
    
    allDone = true;
    for (Ball b : balls) {
      if (!b.isRolling) {
        if (b.getType().equals("white") && foulMade) {
          white.isPotted = false;
          white.resetPosition();
        }
        b.show();
      }

      if (game == FIRE) {
        b.move();
        b.collide();

        for (Ball c : balls) {
          allDone = allDone && !c.isMoving && !c.isRolling;//check for not moving and not rolling
          if (c != b && !c.isPotted && !c.isRolling) {
            b.bounce(c);
          }
        }
      }
      b.pot();
    }
    
    // for messages "You are stripes!" or "You are solids!"
    if (broadcast1 && player == broadcast1player) {
      if (broadcast1timer > 0) {
        textSize(90);
        fill(120, 120, 120);
        if (broadcast1player == stripeOwner) {
          text("You are stripes!", width / 2.0 - 270, height / 2.0 + 30);
        } else {
          text("You are solids!", width / 2.0 - 260, height / 2.0 + 30);
        }
        broadcast1timer--;
      } else {
        broadcast1 = false;
      }
    }
    if (broadcast2 && player != broadcast1player) {
      if (broadcast2timer > 0) {
        textSize(90);
        fill(120, 120, 120);
        if (broadcast1player == stripeOwner) {
          text("You are solids!", width / 2.0 - 260, height / 2.0 + 30);
        } else {
          text("You are stripes!", width / 2.0 - 270, height / 2.0 + 30);
        }
        broadcast2timer--;
      } else {
        broadcast2 = false;
      }
    }
    
    if (winner != -1) { 
      game = END; // winner screen turns on
    }
    
    if (game != END) {
      cue.show();
    }
    
    //game state
    if (game == READY) {
      if (white.moving) {//move the white ball
        //not out of bounds?
        boolean xBoundedUp = mouseX > cornerX + edgeThickness + pocketDiam + centerOffset;
        boolean xBoundedDown;
        if (breaking) {
          xBoundedDown = mouseX < 2 * (cornerX + edgeThickness + pocketDiam + centerOffset);
        } else {
          xBoundedDown = mouseX < width - cornerX - edgeThickness - centerOffset - pocketDiam;
        }
        boolean yBoundedUp = mouseY > cornerY + edgeThickness + pocketDiam + centerOffset;
        boolean yBoundedDown = mouseY < height - cornerY - edgeThickness - pocketDiam - centerOffset;
        if (xBoundedUp && xBoundedDown) {
          white.position.x = mouseX;
        } else if (xBoundedUp) {
          if (breaking) {
            white.position.x = 2 * (cornerX + edgeThickness + pocketDiam + centerOffset);
          } else {
            white.position.x = width - cornerX - edgeThickness - centerOffset - pocketDiam;
          }
        } else {
          white.position.x = cornerX + edgeThickness + pocketDiam + centerOffset;
        }

        if (yBoundedUp && yBoundedDown) {
          white.position.y = mouseY;
        } else if (yBoundedUp) {
          white.position.y = height - cornerY - edgeThickness - pocketDiam - centerOffset;
        } else {
          white.position.y = cornerY + edgeThickness + pocketDiam + centerOffset;
        }

        if (!(xBoundedUp && xBoundedDown) || !(yBoundedUp && yBoundedDown)) {
          if (borderBrightness < 100) {
            borderBrightness++;
          }
        } else {
          if (borderBrightness > 0) {
            borderBrightness--;
          }
        }

        //not inside another ball?
        for (Ball x : balls) {
          if (x != white) {
            PVector posDiff = white.position.copy().sub(x.position.copy());
            if (posDiff.mag() < Ball.size) {
              posDiff.setMag(Ball.size);
              white.position = posDiff.add(x.position);
            }
          }
        }
      }
    } else if (game == AIM) {
      drawPower();
      if (mouseX > 30 && mouseX < cornerX - 30 && mouseY > cornerY + 10 && mouseY < height - cornerY - 10) {
        extend = (height - cornerY - 10 - mouseY)/2;
      }
    } else if (game == FIRE) {
      if (extend > -5 && extend <= 5) {//runs once
        white.applyForce(cue.direction.setMag(cue.power));
        white.isMovable = false; //resets movability
        allDone = false;
        processingDone = false;
        foulMade = false;
        white.positionReset = false;

        float amp;
        if (cue.power > 1) {
          amp = 1;
        } else {
          amp = cue.power;
        }
        ballToBall.amp(amp);
        ballToBall.play();
      }
      if (extend > -5) {
        extend-=10;
      }
      
      if (extend <= -5 && allDone && !processingDone) {
        process();
      }
      
      if (extend <= -5 && allDone && !white.isPotted) {//the second boolean is changeable, only runs after applying force
        game = READY;
        extend = 0;
      }
    } else if (game == END) { // ending screen
      textSize(128);
      if (winner == player) {
        fill(255, 255, 0);
        text("You Win!", width / 2.0 - 200, height / 2.0 + 35);
      } else {
        fill(120, 120, 120);
        text("You Lose!", width / 2.0 - 230, height / 2.0 + 35);
      }
    } 
    
    if (game != READY || !white.moving) {
      if (borderBrightness > 0) {
        borderBrightness--;
      }
    }
  }
}

//smoother movement
void mousePressed() {
  if (screen == PLAY && game != END) {
    if (white.isMovable && mousePressed && dist(mouseX, mouseY, white.position.x, white.position.y) < Ball.size) {
      white.moving = true;
      cue.showable = false;
    }
  }
}

void mouseReleased() {
  if (screen == PLAY) {
    white.moving = false;
    cue.showable = true;
  }
}

void mouseClicked() {
  if (screen == PLAY) {
    if (game == READY) {
      if (dist(mouseX, mouseY, white.position.x, white.position.y) >= Ball.size) {
        game = AIM;
      }
    } else if (game == AIM) {
      //inside power?
      if (mouseX > 30 && mouseX < cornerX - 30 && mouseY > cornerY + 10 && mouseY < height - cornerY - 10) {
        cue.power = 0.5 + 3.5 * (height - cornerY - 10 - mouseY)/(height - 2*cornerY - 20);
        game = FIRE;
      } else {
        game = READY;
        extend = 0;
      }
    }
  }

  if (screen == MENU) {

    if (mouseOnNewButton) {
      if (mouseX > (width - newButtonWidth) / 2 && mouseX < (width + newButtonWidth) / 2
        && mouseY > ((height - newButtonHeight) / 2 + buttonOffset) && mouseY < ((height + newButtonHeight) / 2 + buttonOffset)) {
        screen = PLAY;
      }
    } else {
      if (mouseX > (width - buttonWidth) / 2 && mouseX < (width + buttonWidth) / 2
        && mouseY > ((height - buttonHeight) / 2 + buttonOffset) && mouseY < ((height + buttonHeight) / 2 + buttonOffset)) {
        screen = PLAY;
      }
    }
  }
}

void displayAvatars() {
  // for the yellowish glow of avatars
  if (yellowTintIncreasing) {
    if (yellowTint < 130) {
      yellowTint += 2;
    } else {
      yellowTintIncreasing = false;
    }
  } else {
    if (yellowTint > 30) {
      yellowTint -= 2;
    } else {
      yellowTintIncreasing = true;
    }
  }
  
  // avatars
  if (player == PLAYER2) {
    tint(255,255,255);
    image(blueAvatar, 52, 42, avatarSize, avatarSize);
    tint(255 - yellowTint, 255 - yellowTint, 50);
    image(redAvatar, width - 52, 42, avatarSize, avatarSize);
  } else if (player == PLAYER1) {
    tint(255,255,255);
    image(redAvatar, width - 52, 42, avatarSize, avatarSize);
    tint(255 - yellowTint, 255 - yellowTint, 150);
    image(blueAvatar, 52, 42, avatarSize, avatarSize);
  }
}

void displayRacks() {
  // rack outlines
  stroke(0);
  strokeWeight(2);
  noFill();
  if (player == PLAYER1) {
    rect(rackX - rackWidth / 2 - rackSpace, rackY - rackHeight / 2 - rackSpace, rackWidth + 2 * rackSpace, rackHeight + 2 * rackSpace, rackRound);
  } else if (player == PLAYER2) {
    rect(width - rackX - rackWidth / 2 - rackSpace, rackY - rackHeight / 2 - rackSpace, rackWidth + 2 * rackSpace, rackHeight + 2 * rackSpace, rackRound);
  }
  
  // racks 
  image(rack, rackX, rackY, rackWidth, rackHeight);
  image(rack, width - rackX, rackY, rackWidth, rackHeight);
  
  // balls
  if (stripeOwner == PLAYER1) {
    displayLeft(stripes);
    displayRight(solids);
  } else if (stripeOwner == PLAYER2) {
    displayLeft(solids);
    displayRight(stripes);
  }
}

void displayLeft(ArrayList<Integer> nums) {
  if (nums.size() == 0) {
    showBall(8, rackX - 3 * displacement, rackY);
  } else {
    for (int i = 0; i < nums.size(); i++) {
      showBall(nums.get(i), rackX + (i - 3) * displacement, rackY);
    }
  }
}

void displayRight(ArrayList<Integer> nums) {
  if (nums.size() == 0) {
    showBall(8, width - rackX + 3 * displacement, rackY);
  } else {
    for (int i = 0; i < nums.size(); i++) {
      showBall(nums.get(i), width - rackX + (3 - i) * displacement, rackY);
    }
  }
}

// precondition:  1 <= n <= 15
void showBall(int number, float x, float y) {
  float size = Ball.size * 1.35;
  noStroke();
  fill(white.ballColors[number]);
  circle(x, y, size);
  textSize(12.5);
  fill(255);
  if (number < 10) {
    text("" + number, x - 3.5, y + 4);
  } else {
    text("" + number, x - 7, y + 4);
  }

  if (number >= 9 && number <= 15) {
    fill(255);
    noStroke();
    arc(x, y, size, size, PI/5, 4*PI/5, CHORD);
    arc(x, y, size, size, 6*PI/5, 9*PI/5, CHORD);
  }
}

void drawPower() {
  stroke(1);
  fill(100);
  rect(20, cornerY, cornerX - 40, height - 2 * cornerY, rectRadius);
  fill(150);
  rect(30, cornerY + 10, cornerX - 60, height - 2 * cornerY - 20);
  for (int y = cornerY + 10; y <= height - cornerY - 10; y++) {
    stroke(255, y - (cornerY + 10), 0);
    line(30, y, cornerX - 30, y);
  }
}

void drawTable() {
  //table
  noStroke();
  fill(192);

  rect(cornerX, cornerY, width - 2 * cornerX, height - 2 * cornerY, rectRadius);
  fill(106, 182, 99); // fuzz green
  rect(cornerX + centerOffset, cornerY + centerOffset, width - 2 * cornerX - 2 * centerOffset, height - 2 * cornerY - 2 * centerOffset);
  fill(0); // black for pockets

  for (float x : pocketXs) {
    for (float y : pocketYs) {
      circle(x, y, pocketDiam);
    }
  }

  // top left
  fill(115, 147, 179);
  beginShape();
  vertex(cornerX + centerOffset + pocketDiam / 2, cornerY + centerOffset);
  vertex(width / 2 - pocketDiam / 2, cornerY + centerOffset);
  vertex(width / 2 - pocketDiam / 2 - edgeThickness, cornerY + centerOffset + edgeThickness);
  vertex(cornerX + centerOffset + pocketDiam / 2 + edgeThickness, cornerY + centerOffset + edgeThickness);
  vertex(cornerX + centerOffset + pocketDiam / 2, cornerY + centerOffset);
  endShape();

  // top right
  beginShape();
  vertex(width / 2 + pocketDiam / 2, cornerY + centerOffset);
  vertex(width - cornerX - centerOffset - pocketDiam / 2, cornerY + centerOffset);
  vertex(width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness, cornerY + centerOffset + edgeThickness);
  vertex(width / 2 + pocketDiam / 2 + edgeThickness, cornerY + centerOffset + edgeThickness);
  vertex(width / 2 + pocketDiam / 2, cornerY + centerOffset);
  endShape();

  // bottom left
  beginShape();
  vertex(cornerX + centerOffset + pocketDiam / 2, height - cornerY - centerOffset);
  vertex(width / 2 - pocketDiam / 2, height - cornerY - centerOffset);
  vertex(width / 2 - pocketDiam / 2 - edgeThickness, height - cornerY - centerOffset - edgeThickness);
  vertex(cornerX + centerOffset + pocketDiam / 2 + edgeThickness, height - cornerY - centerOffset - edgeThickness);
  vertex(cornerX + centerOffset + pocketDiam / 2, height - cornerY - centerOffset);
  endShape();

  beginShape();
  vertex(width / 2 + pocketDiam / 2, height - cornerY - centerOffset);
  vertex(width - cornerX - centerOffset - pocketDiam / 2, height - cornerY - centerOffset);
  vertex(width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness, height - cornerY - centerOffset - edgeThickness);
  vertex(width / 2 + pocketDiam / 2 + edgeThickness, height - cornerY - centerOffset - edgeThickness);
  vertex(width / 2 + pocketDiam / 2, height - cornerY - centerOffset);
  endShape();

  // left
  beginShape();
  vertex(cornerX + centerOffset, cornerY + centerOffset + pocketDiam / 2);
  vertex(cornerX + centerOffset, height - cornerY - centerOffset - pocketDiam / 2);
  vertex(cornerX + centerOffset + edgeThickness, height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness);
  vertex(cornerX + centerOffset + edgeThickness, cornerY + centerOffset + pocketDiam / 2 + edgeThickness);
  vertex(cornerX + centerOffset, cornerY + centerOffset + pocketDiam / 2);
  endShape();

  // right
  beginShape();
  vertex(width - cornerX - centerOffset, cornerY + centerOffset + pocketDiam / 2);
  vertex(width - cornerX - centerOffset, height - cornerY - centerOffset - pocketDiam / 2);
  vertex(width - cornerX - centerOffset - edgeThickness, height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness);
  vertex(width - cornerX - centerOffset - edgeThickness, cornerY + centerOffset + pocketDiam / 2 + edgeThickness);
  vertex(width - cornerX - centerOffset, cornerY + centerOffset + pocketDiam / 2);
  endShape();

  //border for white ball movability
  strokeWeight(1);
  fill(106, 182, 99);
  stroke(106 + borderBrightness, 182 + borderBrightness, 99 + borderBrightness);
  if (breaking) {
    rect(cornerX + edgeThickness + centerOffset + pocketDiam - Ball.size/2, cornerY + edgeThickness + pocketDiam + centerOffset - Ball.size/2,
      cornerX + edgeThickness + pocketDiam + centerOffset + Ball.size, height - 2*(cornerY + edgeThickness + pocketDiam + centerOffset) + Ball.size);
  } else {
    rect(cornerX + edgeThickness + centerOffset + pocketDiam - Ball.size/2, cornerY + edgeThickness + pocketDiam + centerOffset - Ball.size/2,
      width - 2*(cornerX + edgeThickness + centerOffset + pocketDiam) + Ball.size, height - 2*(cornerY + edgeThickness + pocketDiam + centerOffset) + Ball.size);
  }
}

void process() {
  if (breaking) { // break
    if (balls[indexOf8].isPotted) {
      winner = 1 - player;
      foulMade = true;
      foulMessage = POT8;
    } else if (white.isPotted) {
      foulMade = true;
      foulMessage = POTCUE;
      player = 1 - player;
    } else if (numHitRail < 4 && numNewPotted[0] + numNewPotted[1] == 0) {
      foulMade = true;
      foulMessage = ILLEGALBREAK;
      player = 1 - player;
    } else if (numNewPotted[0] + numNewPotted[1] == 0) {
      player = 1 - player;
    }
    breaking = false;
  } else if (stripeOwner == -1) { // open table
    if (balls[indexOf8].isPotted) {
      winner = 1 - player;
      foulMade = true;
      foulMessage = POT8;
    } else if (white.isPotted) {
      foulMade = true;
      foulMessage = POTCUE;
      player = 1 - player;
    } else if (white.getFirstContact() == null) {
      foulMade = true;
      foulMessage = NOHIT;
      player = 1 - player;
    } else if (white.getFirstContact().getType().equals("eight")) {
      foulMade = true;
      foulMessage = OPEN8HIT;
      player = 1 - player;
    } else if (white.getFirstPot() == null) {
      player = 1 - player;
    } else if (white.getFirstPot().getType().equals("solid")) {
      stripeOwner = 1 - player;
      broadcast1 = true;
      broadcast1player = player;
      broadcast1timer = announcementDuration;
      broadcast2 = true;
      broadcast2timer = announcementDuration;
    } else if (white.getFirstPot().getType().equals("striped")) {
      stripeOwner = player;
      broadcast1 = true;
      broadcast1player = player;
      broadcast1timer = announcementDuration;
      broadcast2 = true;
      broadcast2timer = announcementDuration;
    }
  } else { // table is not open, groups have been assigned
    if (player == stripeOwner) {
      if (numOldPotted[0] == 7) { // allowed to pot 8 ball
        if (balls[indexOf8].isPotted) {
          if (white.isPotted) {
            winner = 1 - player;
            foulMade = true;
            foulMessage = CUEPLUS8;
          } else if (!white.getFirstContact().getType().equals("eight")) {
            winner = 1 - player;
            foulMade = true;
            foulMessage = BADPOT8;
          } else {
            winner = player;
            foulMade = true;
            foulMessage = WIN;
          }
        } else if (white.isPotted) {
          foulMade = true;
          foulMessage = POTCUE;
          player = 1 - player;
        } else if (white.getFirstContact() == null) {
          foulMade = true;
          foulMessage = NOHIT;
          player = 1 - player;
        } else if (!white.getFirstContact().getType().equals("eight")) {
          foulMade = true;
          foulMessage = NO8HIT;
          player = 1 - player;
        } else if (numNewPotted[0] + numNewPotted[1] == 0 && numHitRail == 0 && !white.hitRail) {
          foulMade = true;
          foulMessage = SOFTHIT;
          player = 1 - player;
        } else {
          player = 1 - player;
        }
      } else if (balls[indexOf8].isPotted) {
        winner = 1 - player;
        foulMade = true;
        foulMessage = POT8;
      } else if (white.isPotted) {
        foulMade = true;
        foulMessage = POTCUE;
        player = 1 - player;
      } else if (white.getFirstContact() == null) {
        foulMade = true;
        foulMessage = NOHIT;
        player = 1 - player;
      } else if (!white.getFirstContact().getType().equals("striped")) {
        foulMade = true;
        foulMessage = NOSTRIPEDHIT;
        player = 1 - player;
      } else if (numNewPotted[0] + numNewPotted[1] == 0 && numHitRail == 0 && !white.hitRail) {
        foulMade = true;
        foulMessage = SOFTHIT;
        player = 1 - player;
      } else if (numNewPotted[0] == 0) {
        player = 1 - player;
      }
    } else { // player has solids
      if (numOldPotted[1] == 7) { // allowed to pot 8 ball
        if (balls[indexOf8].isPotted) {
          if (white.isPotted) {
            winner = 1 - player;
            foulMade = true;
            foulMessage = CUEPLUS8;
          } else if (!white.getFirstContact().getType().equals("eight")) {
            winner = 1 - player;
            foulMade = true;
            foulMessage = BADPOT8;
          } else {
            winner = player;
            foulMade = true;
            foulMessage = WIN;
          }
        } else if (white.isPotted) {
          foulMade = true;
          foulMessage = POTCUE;
          player = 1 - player;
        } else if (white.getFirstContact() == null) {
          foulMade = true;
          foulMessage = NOHIT;
          player = 1 - player;
        } else if (!white.getFirstContact().getType().equals("eight")) {
          foulMade = true;
          foulMessage = NO8HIT;
          player = 1 - player;
        } else if (numNewPotted[0] + numNewPotted[1] == 0 && numHitRail == 0 && !white.hitRail) {
          foulMade = true;
          foulMessage = SOFTHIT;
          player = 1 - player;
        } else {
          player = 1 - player;
        }
      } else if (balls[indexOf8].isPotted) {
        winner = 1 - player;
        foulMade = true;
        foulMessage = POT8;
      } else if (white.isPotted) {
        foulMade = true;
        foulMessage = POTCUE;
        player = 1 - player;
      } else if (white.getFirstContact() == null) {
        foulMade = true;
        foulMessage = NOHIT;
        player = 1 - player;
      } else if (!white.getFirstContact().getType().equals("solid")) {
        foulMade = true;
        foulMessage = NOSOLIDHIT;
        player = 1 - player;
      } else if (numNewPotted[0] + numNewPotted[1] == 0 && numHitRail == 0 && !white.hitRail) {
        foulMade = true;
        foulMessage = SOFTHIT;
        player = 1 - player;
      } else if (numNewPotted[1] == 0) {
        player = 1 - player;
      }
    }
  }
  
  resetVariables();
}

void resetVariables() { // after processing of rules
  numOldPotted[0] += numNewPotted[0];
  numOldPotted[1] += numNewPotted[1];
  numNewPotted[0] = 0;
  numNewPotted[1] = 0;
  
  for (Ball b : balls) {
    b.hitRail = false;
  }
  numHitRail = 0;
  
  white.setFirstContact(null);
  white.setFirstPot(null);
  
  processingDone = true;
}

void drawRack() {
  noFill();
  stroke(150);

  strokeWeight(3);
  beginShape();
  vertex(width - cornerX, cornerY + rackOffset * centerOffset);
  vertex(width - cornerX * 2 / 3.0 + 3 * rackSpacing * centerOffset, cornerY + rackOffset * centerOffset);
  vertex(width - cornerX * 2 / 3.0 + 3 * rackSpacing * centerOffset, height - cornerY);
  vertex(width - cornerX * 2 / 3.0, height - cornerY);
  vertex(width - cornerX * 2 / 3.0, cornerY + (rackOffset + 3 * rackSpacing) * centerOffset);
  vertex(width - cornerX, cornerY + (rackOffset + 3 * rackSpacing) * centerOffset);
  endShape();

  strokeWeight(1);
  beginShape();
  vertex(width - cornerX, cornerY + (rackOffset + rackSpacing) * centerOffset);
  vertex(width - cornerX * 2 / 3.0 + 2 * rackSpacing * centerOffset, cornerY + (rackOffset + rackSpacing) * centerOffset);
  vertex(width - cornerX * 2 / 3.0 + 2 * rackSpacing * centerOffset, height - cornerY);
  vertex(width - cornerX * 2 / 3.0 + rackSpacing * centerOffset, height - cornerY);
  vertex(width - cornerX * 2 / 3.0 + rackSpacing * centerOffset, cornerY + (rackOffset + 2 * rackSpacing) * centerOffset);
  vertex(width - cornerX, cornerY + (rackOffset + 2 * rackSpacing) * centerOffset);
  endShape();
}

int[] randomizeRack() {
  int[] ret = new int[16];
  for (int i = 0; i < ret.length; i++) {
    ret[i] = i;
  }

  //fisher-yates algorithm
  for (int i = ret.length - 1; i > 0; i--) { //i = 0 is redundant
    swap(ret, i, (int) (Math.random() * (i + 1))); //0 to i inclusive
  }

  if (ret[0] != 0) {
    swap(ret, 0, find(ret, 0));
  }
  if (ret[5] != 8) {
    swap(ret, 5, find(ret, 8));
  }

  if (ret[1] < 8 && ret[11] < 8 && ret[15] < 8) {//all solids
    swap(ret, 1, find(ret, 9));
  }

  if (ret[1] > 8 && ret[11] > 8 && ret[15] > 8) {//all stripes
    swap(ret, 1, find(ret, 1));
  }

  return ret;
}

int find(int[] arr, int value) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == value) {
      return i;
    }
  }
  return -1;
}

void swap(int[] arr, int i, int j) {//indexes
  if (i != j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
  }
}
