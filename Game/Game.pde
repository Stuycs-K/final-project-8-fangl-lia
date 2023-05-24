int cornerX;
int cornerY;
int rectRadius;
int pocketDiam;
int centerOffset;
int edgeThickness;
Ball eight;

void setup() {
  // basic pool table dimensions layout
  size(1000, 500);
  cornerX = 100;
  cornerY = 75;
  rectRadius = 16;
  pocketDiam = 40;
  centerOffset = 25;
  edgeThickness = 12;
  
  //to test ball physics
  eight = new Ball(8, 300, 200);
  eight.show();
}

void draw() {
  background(250);
  eight.move();
  eight.show();
}

void mouseClicked() {
  accelerateTest(eight, mouseX - eight.position.x, mouseY - eight.position.y);
}

void accelerateTest(Ball b, float x, float y) {
  b.isMoving = true;
  b.acceleration = new PVector(x, y).setMag(1); //changeable
  b.friction = b.acceleration.copy().setMag(Ball.frictionMagnitude).rotate(PI);
}

void drawTable() {
  //pockets
  fill(255);
  stroke(2);
  rect(cornerX, cornerY, width - 2 * cornerX, height - 2 * cornerY, rectRadius);
  circle(cornerX + centerOffset, cornerY + centerOffset, pocketDiam);
  circle(width - cornerX - centerOffset, cornerY + centerOffset, pocketDiam);
  circle(cornerX + centerOffset, height - cornerY - centerOffset, pocketDiam);
  circle(width - cornerX - centerOffset, height - cornerY - centerOffset, pocketDiam);
  
  //walls
  fill(115, 147, 179);
  beginShape();
  vertex(cornerX + centerOffset + pocketDiam / 2, cornerY + centerOffset);
  vertex(width - cornerX - centerOffset - pocketDiam / 2, cornerY + centerOffset);
  vertex(width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness, cornerY + centerOffset + edgeThickness);
  vertex(cornerX + centerOffset + pocketDiam / 2 + edgeThickness, cornerY + centerOffset + edgeThickness);
  vertex(cornerX + centerOffset + pocketDiam / 2, cornerY + centerOffset);
  endShape();

  beginShape();
  vertex(cornerX + centerOffset + pocketDiam / 2, height - cornerY - centerOffset);
  vertex(width - cornerX - centerOffset - pocketDiam / 2, height - cornerY - centerOffset);
  vertex(width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness, height - cornerY - centerOffset - edgeThickness);
  vertex(cornerX + centerOffset + pocketDiam / 2 + edgeThickness, height - cornerY - centerOffset - edgeThickness);
  vertex(cornerX + centerOffset + pocketDiam / 2, height - cornerY - centerOffset);
  endShape();

  beginShape();
  vertex(cornerX + centerOffset, cornerY + centerOffset + pocketDiam / 2);
  vertex(cornerX + centerOffset, height - cornerY - centerOffset - pocketDiam / 2);
  vertex(cornerX + centerOffset + edgeThickness, height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness);
  vertex(cornerX + centerOffset + edgeThickness, cornerY + centerOffset + pocketDiam / 2 + edgeThickness);
  vertex(cornerX + centerOffset, cornerY + centerOffset + pocketDiam / 2);
  endShape();

  beginShape();
  vertex(width - cornerX - centerOffset, cornerY + centerOffset + pocketDiam / 2);
  vertex(width - cornerX - centerOffset, height - cornerY - centerOffset - pocketDiam / 2);
  vertex(width - cornerX - centerOffset - edgeThickness, height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness);
  vertex(width - cornerX - centerOffset - edgeThickness, cornerY + centerOffset + pocketDiam / 2 + edgeThickness);
  vertex(width - cornerX - centerOffset, cornerY + centerOffset + pocketDiam / 2);
  endShape();
}
