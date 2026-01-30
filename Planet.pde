class Planet extends Object {

  float r ;
  float mass ;
  float gravity;

  Planet(float x, float y, float m) {
    pos.x = x;
    pos.y = y;
    r = m/30;
    gravity = 2*r;
    mass = m;
  }

  void update() {
  }

  void show() {
    fill(100, 100, 100, 0.4);
    circle(pos.x, pos.y, r);
    noFill();
    stroke(255);
    circle(pos.x, pos.y, gravity*2);
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text(floor(mass), pos.x, pos.y);
  }
}
