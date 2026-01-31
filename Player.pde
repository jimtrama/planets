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
      angle = aggleBetween(new PVector(mouseX, mouseY), pos);
      float d = pos.dist(new PVector(mouseX, mouseY))/100;
      clicked = true;
      speed.set(0, 0);
      float forceX = cos(angle) * d;
      float forceY = sin(angle) * d;
      addForce(new PVector(forceX, forceY));
      return angle;
    }
    return 10;
  }

  void boost() {
    clicked = true;
    speed.set(0,0);
    acceleration.add(8 * cos(this.angle), 8 * sin(this.angle));
  }

  PVector update(ArrayList<Planet> planets, boolean isProjection) {

    for (Planet p : planets) {
      float distance = pos.dist(p.pos);
      float force = this.mass * p.mass * 6.674 * 0.3 / (distance*distance);
      float angleOfP = atan((pos.y - p.pos.y)/(pos.x - p.pos.x));
      if (p.pos.x < pos.x) {
        angleOfP += PI;
      }

      float forceX = cos(angleOfP) * force;
      float forceY = sin(angleOfP) * force;

      if (distance>p.r && clicked) { //&& distance < p.gravity) {
        addForce(new PVector(forceX, forceY));
      }
    }
    // if(clicked)
    // acceleration.add(0,0.05);
    speed.add(acceleration);
    pos.add(speed);
    acceleration.set(0, 0);
    if (!isProjection) {
      angle = aggleBetween(new PVector(mouseX, mouseY), pos);
    }

    points.add(pos.copy());
    return pos.copy();
  }

  ArrayList<PVector> loopUntilLost(ArrayList<Planet> planets, boolean first) {

    if (first) {
      toReturn.clear();
      boolean planeHit = false;
      while (pos.x<width&&pos.x>0&&pos.y>0&&pos.y<height&&!planeHit) {
        toReturn.add(update(planets, true));
        planeHit = checkPlanetHit(planets);
      }
    }

    return toReturn;
  }

  boolean checkPlanetHit(ArrayList<Planet> planets) {
    for (Planet p : planets) {
      float distance = p.pos.dist(pos);
      if (distance<p.r/2) {
        return true;
      }
    }
    return false;
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
