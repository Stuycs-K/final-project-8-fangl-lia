int cornerX;
int cornerY;
int rectRadius;

void setup() {
  size(1000, 500);
  cornerX = 100;
  cornerY = 75;
  rectRadius = 16;
  rect(cornerX, cornerY, width - 2 * cornerX, height - 2 * cornerY, rectRadius);
  circle(cornerX + 25, cornerY + 25, 40);
  circle(width - cornerX - 25, cornerY + 25, 40);
  circle(cornerX + 25, height - cornerY - 25, 40);
  circle(width - cornerX - 25, height - cornerY - 25, 40);
}
