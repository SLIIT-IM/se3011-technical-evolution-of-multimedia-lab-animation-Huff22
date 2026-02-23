//game state and timer variables
int state = 0; // 0 = Start, 1 = Play, 2 = End
int startTime;
int duration = 30; // 30-second timer
int score = 0;

boolean trails = false;

//player variables
float px, py;
float step = 6;
float pr = 20;

//helper variables
float hx, hy;
float ease = 0.10;

//orb variables
float ox, oy;
float oxs, oys;
float or = 15;

void setup() {
  size(700, 350);
  resetGame(); //set initial positions and speeds
}

//custom function to set or reset the game variables
void resetGame() {
  score = 0;
  px = width / 2;
  py = height / 2;
  hx = px;
  hy = py;
  
  //reset Orb speed and position
  oxs = 4;
  oys = 3;
  resetOrbPosition();
}

//custom function to teleport the orb to a random spot
void resetOrbPosition() {
  ox = random(or, width - or);
  oy = random(or, height - or);
}

void draw() {

  //start screen
  if (state == 0) {
    background(#091F29);
    textAlign(CENTER, CENTER);
    fill(#6ED4E8);
    textSize(60);
    text("Catch the Orb!", width/2, height/2 - 30);
    fill(#091F29);
    stroke(#97E3D0);
    rect(width/2 - 100, height/2 + 25, 200, 50);
    fill(#6ED4E8);
    textSize(18);
    text("Press ENTER to Start", width/2, height/2 + 50);
  }
  
  //play screen
  else if (state == 1) {
    
    //trails toggle
    if (!trails) {
      background(#091F29); //clear screen completely
    } else {
      noStroke();
      fill(#091F29, 50);   //draw semi-transparent background for trails
      rect(0, 0, width, height);
    }

    //timer logic
    int elapsed = (millis() - startTime) / 1000;
    int left = duration - elapsed;
    if (left <= 0) {
      state = 2; //move to End Screen when time runs out
    }

    //player Movement
    if (keyPressed) {
      if (keyCode == RIGHT) px += step;
      if (keyCode == LEFT)  px -= step;
      if (keyCode == DOWN)  py += step;
      if (keyCode == UP)    py -= step;
    }
    //keep player on screen
    px = constrain(px, pr, width - pr);
    py = constrain(py, pr, height - pr);

    //helper Movement (Easing)
    hx = hx + (px - hx) * ease;
    hy = hy + (py - hy) * ease;

    //orb Movement and Bouncing
    ox += oxs;
    oy += oys;
    if (ox > width - or || ox < or) oxs *= -1;
    if (oy > height - or || oy < or) oys *= -1;

    //collision Detection (Catching the Orb)
    //if the distance between player and orb is less than their combined radius
    if (dist(px, py, ox, oy) < (pr + or)) {
      score++;
      resetOrbPosition();
      //increase orb speed by 10% each catch
      oxs *= 1.1; 
      oys *= 1.1;
    }

    //drawing the Shapes
    //helper
    noStroke();
    fill(80, 200, 120);
    ellipse(hx, hy, 16, 16);

    //player
    fill(#FFE131);
    ellipse(px, py, pr*2, pr*2);

    //orb
    fill(#FF8031);
    ellipse(ox, oy, or*2, or*2);

    //user interface (UI)
    fill(#6ED4E8);
    textAlign(LEFT, TOP);
    textSize(15);
    text("Time Left: " + left, 20, 20);
    text("Score: " + score, 20, 45);
    text("Trails: " + (trails ? "ON" : "OFF") + " (Press T)", 20, 70);
  }
  
  //end screen
  else if (state == 2) {
    background(#091F29);
    textAlign(CENTER, CENTER);
    fill(#6ED4E8);
    textSize(40);
    text("TIME OVER!", width/2, height/2 - 50);
    textSize(24);
    text("Final Score: " + score, width/2, height/2 -10);
    
    fill(#091F29);
    stroke(#97E3D0);
    rect(width/2 - 100, height/2 + 25, 200, 50);
    fill(#6ED4E8);
    textSize(18);
    text("Press R to Restart", width/2, height/2 + 50);
  }
}

//keyboard controls
void keyPressed() {
  //start the game
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    startTime = millis(); //start the timer exactly when entering play state
    resetGame();          //ensure everything is set to default
  }
  
  //toggle trails
  if (state == 1 && (key == 't' || key == 'T')) {
    trails = !trails;
  }
  
  //restart the game
  if (state == 2 && (key == 'r' || key == 'R')) {
    state = 0; //send back to start screen
  }
}
