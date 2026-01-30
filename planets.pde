//test
ArrayList<Planet> planets = new ArrayList();
ArrayList<PVector> points = new ArrayList();
Player player = new Player();
Player playerProjection = new Player();
int level = 1;
Target target = new Target();
float firingAngle = 0;
Explosion exp = new Explosion();

void setup() {
  //fullScreen();
  size(1748, 1224);
  windowMove(1300, 100);
  createLevel();
  frameRate(20);
  target.setValues();
}
boolean first = true;
void draw() {
  background(0);
  for (Planet planet : planets) {
    planet.show();
  }

  player.update(planets, false);
  float angle = playerProjection.addForceAtMouseAngle();
  ArrayList<PVector> points = playerProjection.loopUntilLost(planets, first);
  first = false;
  if (angle != 10) {
    firingAngle = angle;
  }
  //points.add(point);
  for (PVector p : points) {
    point(p.x, p.y);
  }
  if (floor(player.angle*10_000_0) != floor(firingAngle*10_000_0)) {
    points.clear();
    playerProjection.resetPlayer(player.pos.x, player.pos.y);
    first = true;
  }
  player.show();
  player.showTrail();
  target.show();
  exp.update();
  exp.show();
  checkLevelFinished();
  checkLost(planets);
  fill(255);
  textSize(30);
  text("lives: "+player.lives, 48, 48);
  fill(255);
  textSize(30);
  text("Level: "+level, 48, 108);
}

void createLevel() {
  planets.clear();
  for (int i =0; i<level+1; i++) {
    PVector pos = new PVector(random(0, width), random(0, height));
    float mass = random(6000, 12000);
    Planet p = new Planet(pos.x, pos.y, mass);
    while (player.pos.dist(pos)<p.gravity*2) {
      pos = new PVector(random(0, width), random(0, height));
      mass = random(6000, 12000);
      p = new Planet(pos.x, pos.y, mass);
    }
    planets.add(p);
  }
  target.setValues();
  level++;
}

void checkLevelFinished() {
  if (
    player.pos.x>target.pos.x&&
    player.pos.x<target.pos.x+target.w&&
    player.pos.y>target.pos.y&&
    player.pos.y<target.pos.y+target.h)
  {
    float x = target.pos.x+target.w/2;
    float y = target.pos.y+target.h/2;
    player.resetPlayer(x, y);
    playerProjection.resetPlayer(x, y);
    player.startingPos.x = x;
    playerProjection.startingPos.x = x;
    player.startingPos.y = y;
    playerProjection.startingPos.y = y;
    createLevel();
  }
}

void checkLost(ArrayList<Planet> planets) {
  if (player.pos.x<0||player.pos.y<0||player.pos.y>height||player.pos.x>width) {
    player.resetPlayer(player.startingPos.x, player.startingPos.y);
    player.lives--;
  }
  for (Planet p : planets) {
    float distance = p.pos.dist(player.pos);
    if (distance<p.r/2) {
      float angle = atan((player.pos.y - p.pos.y)/(player.pos.x - p.pos.x ));
      if (player.pos.x <  p.pos.x ) {
        angle += PI;
      }
      exp.startShowing(p.pos.x,p.pos.y,angle);
      player.resetPlayer(player.startingPos.x, player.startingPos.y);
      player.lives--;
      return;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    player.boost();
  }
}

void mousePressed() {
  player.addForceAtMouseAngle();
}

