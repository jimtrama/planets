class Planet extends Object{

    float r ;
    float mass ;
    float gravity;

    Planet(float x , float y,float m){
        pos.x = x;
        pos.y = y;
        r = m/100;
        gravity = (m/100)+(m/100)*1.5;
        mass = m;
    }

    void update(){

    }

    void show(){
        fill(100,100,100,0.4);
        circle(pos.x, pos.y, mass/100);
        noFill();
        stroke(255);
        circle(pos.x, pos.y, gravity*2);
        fill(255);
    }
}