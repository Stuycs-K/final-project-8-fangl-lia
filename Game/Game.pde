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

float extend;
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
  
  //to test ball physics
  white = new WhiteBall(250, 250);
  
  //CHANGE LATER TO INCLUDE ALL BALLS
  balls = new Ball[2];
  balls[0] = white;
  balls[1] = new Ball(1, 500, 250);
  allDone = true;
  
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
  for(Ball b: balls) {
    b.show();
    b.move();
    b.collide();
    b.pot();
    allDone = allDone && !b.isMoving; //to check if everything is no longer moving
  }
  
  cue.show();
  
  //game state
  if(game == READY) {
    if(white.isMovable && mousePressed && dist(mouseX, mouseY, white.position.x, white.position.y) < Ball.size) {//move the white ball
      white.position = new PVector(mouseX, mouseY);
    }
  } else if (game == AIM) {
    drawPower();
    if(mouseX > 30 && mouseX < cornerX - 30 && mouseY > cornerY + 10 && mouseY < height - cornerY - 10) {
      extend = (height - cornerY - 10 - mouseY)/2;
    }
  } else if (game == FIRE) {
    if(extend > -5 && extend <= 5) {//runs once
      white.applyForce(cue.direction.setMag(cue.power));
      white.isMovable = false; //resets movability
      allDone = false;
    }
    if(extend > -5) {extend-=10;}
    
    if(extend <= -5 && allDone && !white.isPotted) {//the second boolean is changeable, only runs after applying force
      game = READY;
      extend = 0;
    }
  }
  println(mouseX + ", " + mouseY);
}

void mouseClicked() {
  if(game == READY) {
    if(dist(mouseX, mouseY, white.position.x, white.position.y) >= Ball.size) {
       game = AIM;
    }
  } else if(game == AIM) {
    //inside power?
    if(mouseX > 30 && mouseX < cornerX - 30 && mouseY > cornerY + 10 && mouseY < height - cornerY - 10) {
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
  for(int y = cornerY + 10; y <= height - cornerY - 10; y++) {
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
  
  for(float x: pocketXs) {
    for(float y: pocketYs) {
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
}
