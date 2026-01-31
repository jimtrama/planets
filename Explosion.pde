class Explosion extends Object{

    int counter;
    int modedCounter;
    boolean showing;


    Explosion(){
        pos.x = 500;
        pos.y = 500;
        showing = false;
        counter = 0;
        modedCounter = 0;
    }

    void startShowing(float x,float y,float a){
        angle = a;
        pos.x = x;
        pos.y = y;
        showing = true;
        counter = 0;
        modedCounter = 10;
    }

    void update(){
        if(showing)
        counter++;
        if(counter % 5 ==0){
            modedCounter++;
        }
    }

    void show(){    
        
        if( showing && modedCounter < 20){
            noFill();
            arc(pos.x,pos.y,
                10*modedCounter -10,
                10*modedCounter -10,
                angle-PI/4,
                PI/4+angle);
            arc(pos.x,pos.y,
                10*modedCounter,
                10*modedCounter,
                angle-PI/4,
                PI/4+angle);
            arc(pos.x,pos.y,
                10*modedCounter+10,
                10*modedCounter+10,
                angle-PI/4,
                PI/4+angle);
        }
    }
}