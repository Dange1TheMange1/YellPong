import oscP5.*;
import netP5.*;

OscP5 oscP5;

//gameplay stuff
float x, y, speedX, speedY; //speed parameters
float diam = 15;            //diameter of ball
float rectSize = 200;       //size of our paddle

//puredata stuff
String string;              //our data is sent like a string, we change this later
int port = 12001;           //our port

void setup() {
  fullScreen();
  fill(0);
  reset();
  
  //pd stuff
  oscP5 = new OscP5(this, port);
}

//resets balls location
void reset() {
  x = width/2;
  y = height/2;
  speedX = random(3, 5);
  speedY = random(3, 5);
}

void draw() { 
  if(string != null){
  float yell = (float(string) / 100) + 1;
  //yell maths

  background(255);
  
  //Numbers display
  textSize(64);
  textAlign(LEFT);
  
  text("Current volume is",100,100);
  rect(100, 105, (yell*100)-1, 50); //we do the inverse
  
  text("Current speed is: " + nf(abs(speedX)+abs(speedY),0,2), 100, 250);
  
  
  //Movement of ball
  ellipse(x, y, diam, diam);

  rect(0, 0, 20, height);
  rect(width-30, mouseY-rectSize/2, 10, rectSize);

  x += speedX;
  y += speedY;


  //Hitreg for mouse bar, and make so it reflects using yell force
  if ( x > width-30 && x < width -10 && y > mouseY-rectSize/2 && y < mouseY+rectSize/2 ) {
    speedX = speedX * -1 * yell;
    speedY = speedY * 1 * yell;
  } 

  //Change direction when wall
  if (x < 25) {
    speedX *= -1; 
    x += speedX;
  }

  //Change direction when ceiling or floor
  if ( y > height || y < 0 ) {
    speedY *= -1;
    }
  }
}

void oscEvent(OscMessage message) 
{
  if (message.addrPattern().equals("/float"))
  {
     string =  message.arguments()[0].toString();
     println(string);
  }
}
