class Player extends Object {

  PVector speed;
  PVector acceleration;
  ArrayList<PVector> points;
  float mass;
  PVector startingPos;
  boolean clicked;
  int lives;
  ArrayList<PVector> toReturn;


  Player() {
    startingPos = new PVector(900, 900);
    pos.x = startingPos.x;
    pos.y = startingPos.y;
    angle = 0;
    speed = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    points = new ArrayList();
    mass = 1;
    clicked = false;
    lives = 5;
    toReturn = new ArrayList();
  }

  void speedUp() {
    this.speed.add(this.acceleration);
  }

  void addForce(PVector force) {
    this.acceleration.add(force);
  }

  float addForceAtMouseAngle() {
    if (!clicked) {
      angle = atan((pos.y - mouseY)/(pos.x - mouseX));
      if (mouseX < pos.x) {
        angle += PI;
      }
      clicked = true;
      speed.set(0, 0);
      float forceX = cos(angle) * 5;
      float forceY = sin(angle) * 5;
      addForce(new PVector(forceX, forceY));
      return angle;
    }
    return 10;
  }

  void boost() {
    acceleration.add(10 * cos(this.angle), 10 * sin(this.angle));
  }

  PVector update(ArrayList<Planet> planets, boolean isProjection) {

    for (Planet p : planets) {
      float distance = pos.dist(p.pos);
      float force = this.mass * p.mass * 6.674 * 0.1 / (distance*distance);
      float angleOfP = atan((pos.y - p.pos.y)/(pos.x - p.pos.x));
      if (p.pos.x < pos.x) {
        angleOfP += PI;
      }

      float forceX = cos(angleOfP) * force;
      float forceY = sin(angleOfP) * force;

      if (distance>p.r && distance < p.gravity) {
        addForce(new PVector(forceX, forceY));
      }
    }
    speed.add(acceleration);
    pos.add(speed);
    acceleration.set(0, 0);
    if (!isProjection) {
      angle = atan((pos.y - mouseY)/(pos.x - mouseX));
      if (mouseX < pos.x) {
        angle += PI;
      }
    }

    points.add(pos.copy());
    return pos.copy();
  }

  ArrayList<PVector> loopUntilLost(ArrayList<Planet> planets, boolean first) {

    if (first) {
      toReturn.clear();
      while (pos.x<width&&pos.x>0&&pos.y>0&&pos.y<height) {
        toReturn.add(update(planets,true));
      }
    }

    return toReturn;
  }



  void resetPlayer(float x, float y) {
    pos.x = x;
    pos.y = y;
    speed.set(0, 0);
    clicked = false;
  }

  void show() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(this.angle);
    triangle(20, 0, -20, -15, -20, 15);
    popMatrix();
  }

  void showTrail() {
    for (PVector p : points) {
      point(p.x, p.y);
    }
    if (points.size()>150) {
      points.remove(0);
    }
  }
}
