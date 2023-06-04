int cornerX;
int cornerY;
int rectRadius;
float pocketDiam;
float centerOffset;
float edgeThickness;

float[] pocketXs;
float[] pocketYs;

WhiteBall white;
CueStick cue;
Ball[] balls;

int game;
final static int READY = 0;
final static int AIM = 1;
final static int FIRE = 2;

boolean allDone;

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
  float xStart = cornerX + 0.75 * (width - 2 * cornerX);
  float yStart = 250;
  float xShift = Ball.size * sqrt(3)/2;
  float yShift = Ball.size * 1/2;
  balls[1] = new Ball(1, xStart, yStart);
  balls[2] = new Ball(2, xStart + xShift, yStart + yShift);
  balls[3] = new Ball(3, xStart + xShift, yStart - yShift);
  balls[4] = new Ball(4, xStart + 2*xShift, yStart + 2*yShift);
  balls[5] = new Ball(5, xStart + 2*xShift, yStart);
  balls[6] = new Ball(6, xStart + 2*xShift, yStart - 2*yShift);
  balls[7] = new Ball(7, xStart + 3*xShift, yStart + 3*yShift);
  balls[8] = new Ball(8, xStart + 3*xShift, yStart + 1*yShift);
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
}

void draw() {
  background(250);
  drawTable();

  allDone = true;
  for (Ball b : balls) {
    b.show();

    if (game == FIRE) {
      b.move();
      b.collide();

      //bounce testing
      for (Ball c : balls) {
        allDone = allDone && !c.isMoving;//check for not moving
        if (c != b && !c.isPotted) {
          b.bounce(c);
        }
      }
    }
    b.pot();
  }

  cue.show();

  //game state
  if (game == READY) {
    if (white.moving) {//move the white ball
      //not out of bounds?
      boolean xBoundedUp = mouseX > cornerX + edgeThickness + pocketDiam + centerOffset;
      boolean xBoundedDown = mouseX < width - cornerX - edgeThickness - centerOffset - pocketDiam;
      boolean yBoundedUp = mouseY > cornerY + edgeThickness + pocketDiam + centerOffset;
      boolean yBoundedDown = mouseY < height - cornerY - edgeThickness - pocketDiam - centerOffset;
      if (xBoundedUp && xBoundedDown) {
        white.position.x = mouseX;
      } else if (xBoundedUp) {
        white.position.x = width - cornerX - edgeThickness - centerOffset - pocketDiam;
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
      for(Ball x: balls) {
        if(x != white) {
          PVector posDiff = white.position.copy().sub(x.position.copy());
          if(posDiff.mag() < Ball.size) {
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
    }
    if (extend > -5) {
      extend-=10;
    }

    if (extend <= -5 && allDone && !white.isPotted) {//the second boolean is changeable, only runs after applying force
      game = READY;
      extend = 0;
    }
  }

  if (game != READY || !white.moving) {
    if (borderBrightness > 0) {
      borderBrightness--;
    }
  }
}

//smoother movement
void mousePressed() {
  if (white.isMovable && mousePressed && dist(mouseX, mouseY, white.position.x, white.position.y) < Ball.size) {
    white.moving = true;
    cue.showable = false;
  }
}

void mouseReleased() {
  white.moving = false;
  cue.showable = true;
}

void mouseClicked() {
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
  background(255);
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
  rect(cornerX + edgeThickness + centerOffset + pocketDiam - Ball.size/2, cornerY + edgeThickness + pocketDiam + centerOffset - Ball.size/2,
    width - 2*(cornerX + edgeThickness + centerOffset + pocketDiam) + Ball.size, height - 2*(cornerY + edgeThickness + pocketDiam + centerOffset) + Ball.size);
}
