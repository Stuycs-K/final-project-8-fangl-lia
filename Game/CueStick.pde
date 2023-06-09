public class CueStick {
  public PImage stick;
  public PVector direction;
  public float power;
  public boolean showable; //for the purpose of disappearing when something happens to the white ball

  public CueStick() {
    stick = loadImage("cue-stick.png");
    stick.resize(300, 35);
    direction = new PVector(0, 0);
    power = 0;
    showable = true;
  }

  public void show() {
    if ((game != FIRE || extend > -5) && showable) {//things are not moving
      //to rotate, if aiming, don't move the cue
      if (game == READY) {
        direction = new PVector(mouseX - white.position.x, mouseY - white.position.y); //towards the mouse as well as the cue
      }

      translate(white.position.x, white.position.y);

      rotate(direction.heading());
      imageMode(CENTER);
      image(stick, -165 - extend, 0); //correct position to the ball\

      //reverse transformations of the plane
      rotate(-1 * direction.heading());
      translate(-1 * white.position.x, -1 * white.position.y);

      //calculate if aiming will hit a ball
      Ball c = null; //null if nothing, then set to closest one
      float distanceToBall = -1; //-1 if nothing, then set to closest one
      float largeAngle = -1; //-1 if nothing, then set to closest one

      for (Ball b : balls) {
        if (b != white && !b.isPotted && !(mouseX == white.position.x && mouseY == white.position.y)) {//can't be the white ball itself, and weird lines come out if mouse is on white ball fsr
          PVector towards = b.position.copy().sub(white.position.copy());
          float angle = Math.abs(towards.heading() - direction.heading());
          if (angle >= 1.5*PI) {
            angle = 2*PI - angle;
          } //mod things
          if (angle < PI/2 && sin(angle) < Ball.size/(towards.mag())) { //trig, checks for colliding with another ball
            //law of sines
            float ratio = sin(angle)/Ball.size;
            float secondAngle = PI - asin(ratio * towards.mag());
            float thirdAngle = PI - angle - secondAngle;
            float distance = sin(thirdAngle)/ratio;
            if (ratio == 0) {//undefined stuff
              distance = towards.mag() - Ball.size;
            }

            if (distanceToBall == -1 || distance < distanceToBall) {
              distanceToBall = distance;
              c = b; //set the ball to be the colliding one
              largeAngle = secondAngle;
            }
          }
        }
      }

      if (c == null) { //no collisions
        float distanceToWall = -1; //-1 if none
        //check the 6 main walls
        float check = 0;
        //top left and right
        if (white.position.y - Ball.size / 2 > cornerY + centerOffset + edgeThickness) {//not inside a pocket
          if (direction.heading() < 0) {
            check = -1 * (white.position.y - Ball.size / 2 - (cornerY + centerOffset + edgeThickness))/sin(direction.heading());
            float newX;
            newX = white.position.x + check * cos(direction.heading());
            if (newX >= cornerX + centerOffset + pocketDiam / 2 + edgeThickness && newX <= width / 2 - pocketDiam / 2 - edgeThickness ||
              newX <= width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness && newX >= width / 2 + pocketDiam / 2 + edgeThickness) {//left and right
              if (distanceToWall == -1 || distanceToWall > check) {
                distanceToWall = check;
              }
            }
          }
        }

        //bottom left and right
        if (white.position.y + Ball.size / 2 < height - cornerY - centerOffset - edgeThickness) {//not inside a pocket
          if (direction.heading() > 0) {
            check = -1 * (white.position.y + Ball.size / 2 - (height - cornerY - centerOffset - edgeThickness))/sin(direction.heading());
            float newX;
            newX = white.position.x + check * cos(direction.heading());
            if (newX >= cornerX + centerOffset + pocketDiam / 2 + edgeThickness && newX <= width / 2 - pocketDiam / 2 - edgeThickness ||
              newX <= width - cornerX - centerOffset - pocketDiam / 2 - edgeThickness && newX >= width / 2 + pocketDiam / 2 + edgeThickness) {//left and right
              if (distanceToWall == -1 || distanceToWall > check) {
                distanceToWall = check;
              }
            }
          }
        }

        //left
        if (white.position.x - Ball.size / 2 > cornerX + centerOffset + edgeThickness) {//not inside a pocket
          if (direction.heading() > PI/2 || direction.heading() < -1 * PI/2) {
            check = -1 * (white.position.x - Ball.size / 2 - (cornerX + centerOffset + edgeThickness))/cos(direction.heading());
            float newY;
            newY = white.position.y + check * sin(direction.heading());
            if (newY >= cornerY + centerOffset + pocketDiam / 2 + edgeThickness && newY <= height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness) {
              if (distanceToWall == -1 || distanceToWall > check) {
                distanceToWall = check;
              }
            }
          }
        }

        //right
        if (white.position.x + Ball.size / 2 < width - cornerX - centerOffset - edgeThickness) {//not inside a pocket
          if (direction.heading() < PI/2 && direction.heading() > -1 * PI/2) {
            check = -1 * (white.position.x + Ball.size / 2 - (width - cornerX - centerOffset - edgeThickness))/cos(direction.heading());
            float newY;
            newY = white.position.y + check * sin(direction.heading());
            if (newY >= cornerY + centerOffset + pocketDiam / 2 + edgeThickness && newY <= height - cornerY - centerOffset - pocketDiam / 2 - edgeThickness) {
              if (distanceToWall == -1 || distanceToWall > check) {
                distanceToWall = check;
              }
            }
          }
        }

        if (distanceToWall != -1) {
          PVector out = direction.copy().setMag(distanceToWall);
          strokeWeight(1.5);
          stroke(240);
          noFill();

          //to wall
          circle(white.position.x + out.x, white.position.y + out.y, Ball.size);
          line(white.position.x, white.position.y, white.position.x + out.x, white.position.y + out.y);
        }
      } else { //collides
        PVector out = direction.copy().setMag(distanceToBall);
        strokeWeight(1.5);
        stroke(240);
        noFill();

        boolean good;
        if (stripeOwner == -1) {
          good = !c.getType().equals("eight");
        } else if (stripeOwner == player) {
          if (numOldPotted[0] == 7) {
            good = c.getType().equals("eight");
          } else {
            good = c.getType().equals("striped");
          }
        } else {
          if (numOldPotted[1] == 7) {
            good = c.getType().equals("eight");
          } else {
            good = c.getType().equals("solid");
          }
        }

        if (good) {
          //from cue ball to ball
          line(white.position.x, white.position.y, white.position.x + out.x, white.position.y + out.y);
          //circle
          circle(white.position.x + out.x, white.position.y + out.y, Ball.size);

          //into ball
          PVector outer = white.position.copy().add(out.copy());
          PVector in = c.position.copy().sub(outer.copy());
          line(outer.x, outer.y, outer.x + in.x * -2 * cos(largeAngle), outer.y + in.y * -2 * cos(largeAngle));

          //perpendicular
          //check farther
          PVector test1 = in.copy().rotate(PI/2).add(outer.copy());
          PVector test2 = in.copy().rotate(-1 * PI/2).add(outer.copy());
          PVector normal;
          if (dist(white.position.x, white.position.y, test1.x, test1.y) >= dist(white.position.x, white.position.y, test2.x, test2.y)) {
            normal = test1;
          } else {
            normal = test2;
          }

          line(outer.x, outer.y, outer.x + (normal.x - outer.x) * 2 * sin(largeAngle), outer.y + (normal.y - outer.y) * 2 * sin(largeAngle));
        } else {
          if (out.mag() >= Ball.size/2) {
            out.setMag(out.mag() - Ball.size/2);
            line(white.position.x, white.position.y, white.position.x + out.x, white.position.y + out.y);
            out.setMag(out.mag() + Ball.size/2);
          }
          //circle
          stroke(255, 0, 0);
          circle(white.position.x + out.x, white.position.y + out.y, Ball.size);
          line(white.position.x + out.x - Ball.size/2/sqrt(2), white.position.y + out.y - Ball.size/2/sqrt(2),
            white.position.x + out.x + Ball.size/2/sqrt(2), white.position.y + out.y + Ball.size/2/sqrt(2));
        }
      }
    }
  }
}
