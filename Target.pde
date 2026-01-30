class Target extends Object{
    float w;
    float h;
    
    Target(){

    }

    void setValues(){
        pos.x = random(60,width-60);
        pos.y = random(60,height-60);
        w = 100;
        h = 100;
    }

    void show(){
        fill(255);
        rect(pos.x,pos.y,w,h);
    }
}