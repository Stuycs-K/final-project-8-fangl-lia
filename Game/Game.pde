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

int game;
final static int READY = 0;
final static int AIM = 1;
final static int FIRE = 2;
final static int END = 3;

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
  balls[1] = new Ball(1, xStart, yStart);
  balls[2] = new Ball(2, xStart + xShift, yStart + yShift);
  balls[3] = new Ball(3, xStart + xShift, yStart - yShift);
  balls[4] = new Ball(4, xStart + 2*xShift, yStart + 2*yShift);
  balls[5] = new Ball(5, xStart + 3*xShift, yStart + 1*yShift);
  balls[6] = new Ball(6, xStart + 2*xShift, yStart - 2*yShift);
  balls[7] = new Ball(7, xStart + 3*xShift, yStart + 3*yShift);
  balls[8] = new Ball(8, xStart + 2*xShift, yStart);
  balls[9] = new Ball(9, xStart + 3*xShift, yStart - 1*yShift);
  balls[10] = new Ball(10, xStart + 3*xShift, yStart - 3*yShift);
  balls[11] = new Ball(11, xStart + 4*xShift, yStart + 4*yShift);
  balls[12] = new Ball(12, xStart + 4*xShift, yStart + 2*yShift);
  balls[13] = new Ball(13, xStart + 4*xShift, yStart);
  balls[14] = new Ball(14, xStart + 4*xShift, yStart - 2*yShift);
  balls[15] = new Ball(15, xStart + 4*xShift, yStart - 4*yShift);

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

  if (screen == PLAY) {
    drawRack();
    for (Ball b : balls) {
      if (b.isRolling) {
        b.slide();
        b.show();
      }
    }
    drawTable();
    
    // TEXT FOR DEBUGGING
    textSize(12);
    text("Old striped and solids " + numOldPotted[0] + " " + numOldPotted[1], 5, 10);
    text("New striped and solids " + numNewPotted[0] + " " + numNewPotted[1], 5, 25);
    text("numHitRail = " + numHitRail, 200, 10);
    text("white.hitRail = " + white.hitRail, 200, 25);
    if (white.getFirstContact() == null) {
      text("white no contact", 400, 10);
    } else {
      text("white's first contact: " + white.getFirstContact().getNumber(), 400, 10);
    }
    if (white.getFirstPot() == null) {
      text("white no pot", 400, 25);
    } else {
      text("white's first pot: " + white.getFirstPot().getNumber(), 400, 25);
    }
    if (winner == -1) {
      text("game in progress", 600, 10);
    } else {
      text("game winner is Player " + (winner + 1), 600, 10);
    }
    text("foul made: " + foulMade, 600, 25);
    text("player turn: " + (player + 1), 800, 10);
    text("breaking: " + breaking, 800, 25);
    if (stripeOwner == -1) {
      text("table open", 600, 40);
    } else {
      text("stripe owner: Player " + (stripeOwner + 1), 600, 40);
    }
    
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
    if (balls[8].isPotted) {
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
    if (balls[8].isPotted) {
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
    } else if (white.getFirstPot().getType().equals("striped")) {
      stripeOwner = player;
    }
  } else { // table is not open, groups have been assigned
    if (player == stripeOwner) {
      if (numOldPotted[0] == 7) { // allowed to pot 8 ball
        if (balls[8].isPotted) {
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
      } else if (balls[8].isPotted) {
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
        if (balls[8].isPotted) {
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
      } else if (balls[8].isPotted) {
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

void drawAvatars() {
  //
}
