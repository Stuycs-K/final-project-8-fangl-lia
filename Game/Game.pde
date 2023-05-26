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
  drawTable();
  eight.move();
  eight.show();
}

void mouseClicked() {
  eight.applyForce(new PVector(mouseX - eight.position.x, mouseY - eight.position.y).setMag(1.7));
}

void drawTable() {
  //pockets
  background(255);
  fill(192);
  
  rect(cornerX, cornerY, width - 2 * cornerX, height - 2 * cornerY, rectRadius);
  fill(106, 182, 99); // fuzz green
  rect(cornerX + centerOffset, cornerY + centerOffset, width - 2 * cornerX - 2 * centerOffset, height - 2 * cornerY - 2 * centerOffset);
  fill(0); // black for pots
  circle(cornerX + centerOffset, cornerY + centerOffset, pocketDiam);
  circle(width - cornerX - centerOffset, cornerY + centerOffset, pocketDiam);
  circle(cornerX + centerOffset, height - cornerY - centerOffset, pocketDiam);
  circle(width - cornerX - centerOffset, height - cornerY - centerOffset, pocketDiam);
  
  circle(width / 2, cornerY + centerOffset, pocketDiam);
  circle(width / 2, height - cornerY - centerOffset, pocketDiam);
  
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
