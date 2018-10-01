// Triodia 050

// code by Rupert Russell
// October 2018
// latest version on Github at: https://github.com/rupertrussell/Triodia-020
// A work in progress used to add measurements and perimeters to arial photogrpahs
// that include a scale measurement on the ground eg a 1 meter square

// Display phot of a transect with scale 
// 1) Click on top corner of transect scale in photo
// 2) click on oposite corner of transect scale eg 1 meter from first click on photo
// 3) move the mouse to the first point you eant to measure press 1
// 4) move the mouse to the second point you want to measure press 2
// 5) read the distance releative to the scape of the transct in meters
// move mouse to a new point press 1 move to another point and press 2 
// sread new distance between points

float perimiterLength = 0;
int maxNumberOfPairs = 200;
int maxNumberOfPerimeters = 200;
int numberOfPerimeters  = 0; // number of perimeters measured
int numberOfPerimeterPoints = 0;
int currentPerimeterPoint = 0; // increment for each Perimeter point for all hummocks
int[] numberOfPerimeterPointsInCurrentHummock = new int[200];

int[] pX = new int[2000]; // store x perimeter points for all hummocks
int[] pY = new int[2000]; // store y perimeter points for all hummocks

int[] sX = new int[200]; // store starting x perimeter point for all hummocks
int[] sY = new int[200]; // store starting y perimeter point for all hummocks

int[] startPerimeter = new int[200]; // remember the start of perimters point for hummock numberOfPerimeters
int[] endPerimeter = new int[200]; // end of perimters points for a hummock


int numberOfCurrentPerimeter = 0;

// uses arrays to store the x  & y coordinates of up to maxNumberOfPairs measursemetn points
int[] x = new int[maxNumberOfPairs];
int[] y = new int[maxNumberOfPairs];
int i = 3; // index of array of points  start saving points after first pair of points 

// set up global variables

int imgX = 0;
int imgY = 0;

String f = "";
float textOffset = 1.02;


int gridSize = 0;
boolean scaleSet = false;
boolean scale1 = false;
boolean scale2 = false;
boolean point1 = false;
boolean point2 = false;
boolean ready = false;
boolean justStarted = true;

int saveCounter = 0;
float distance  = 0;
float measuredDistance = 0;
float sumOfMeasuredDistance = 0;

float roundedMeasuredDistance = 0;

PImage img;  // holder for the photogaph

void setup() {
  size(800, 700);

  fill(255, 255, 0);

  img = loadImage("4000x3000.jpg");
  img.resize(0, 1000);
  image(img, imgX, imgY); // display the image on the screen
}

void draw() {

  PFont f = createFont("Arial", 20);
  textFont(f);
  textSize(20);

  ready = true;
  if (ready && justStarted) {
    println("ready");
    justStarted = false;
  }
} // end of void draw()

// each time the mouse is clicked do the following
void mouseClicked() {

  // used to measure the size of Triodia hummocks in the photo
  // Used to set the scale from the square meter in the phot
  if ((scale1 == true) && (scale2 == false)) {
    x[2] = mouseX;
    y[2] = mouseY;
    scale2 = true;
    scaleSet = true;
    fill(0, 255, 0); // Green
    ellipse(x[2], y[2], 10, 10);
    fill(255, 255, 0); // Yelow
    distance = dist(x[1], y[1], x[2], y[2]);  // calculate the distance in pixels between the first 2 clicks
    grid();
  }

  if (scale1 == false) {
    x[1] = mouseX;
    y[1] = mouseY;
    fill(0, 255, 0); // Green
    ellipse(x[1], y[1], 10, 10);
    fill(255, 255, 0); // Yelow
    scale1 = true;
    i = 3;
  }
} // end void mouseClicked()

void keyPressed() {
  if (justStarted == true) {
    println("returning from keypress");
    return;
  }

  if (key == '1' || key == '!') {
    if ((scaleSet == true) && (point1 == false)) {
      x[i] = mouseX;
      y[i] = mouseY;
      point1 = true;
      fill(255, 0, 255);
      ellipse(x[i], y[i], 10, 10);
      fill(255, 255, 0);

      i ++;  // increment i to point to next position in the array
    }
  }

  if (key == '2' || key == '@') {
    if (point1 == true) {
      x[i] = mouseX;
      y[i] = mouseY;
      point2 = true;
      point1 = false;
      fill(255, 0, 255);
      ellipse(x[i], y[i], 10, 10);
      stroke(0);
      strokeWeight(2);
      line(x[i-1], y[i-1], x[i], y[i]);
      strokeWeight(1);
      stroke(0);
      fill(255, 255, 0);
      measuredDistance = dist(x[i-1], y[i-1], x[i], y[i]);
      saveRoundedMeasuredDistance(measuredDistance);

      f = str(roundedMeasuredDistance);
      text(f, x[i] * textOffset, y[i] * textOffset);
      i ++;  // increment i to point to next position in the array
    }
  }  // end Key 2

  // =============== start a new Perimeter for a hummock ======================
  if (key == 'n' || key == 'N') {
    startPerimeter[numberOfCurrentPerimeter] = currentPerimeterPoint; // remember where this perimerter begins
    numberOfPerimeterPointsInCurrentHummock[numberOfCurrentPerimeter] = 0;
    perimiterLength = 0;
    numberOfPerimeterPoints = 0;
    pX[currentPerimeterPoint] = mouseX;
    pY[currentPerimeterPoint] = mouseY;

    // store the starting point for each perimeter
    println("numberOfCurrentPerimeter in  N = " + numberOfCurrentPerimeter);
    sX[numberOfCurrentPerimeter] = mouseX;
    sY[numberOfCurrentPerimeter] = mouseY;
    println("New numberOfCurrentPerimeter = " + numberOfCurrentPerimeter);

    fill(255, 0, 255);
    ellipse(pX[currentPerimeterPoint], pY[currentPerimeterPoint], 10, 10);

    currentPerimeterPoint = currentPerimeterPoint + 1;  // store the number of perimeters for poistion in array
    numberOfPerimeters = numberOfPerimeters + 1;
    numberOfCurrentPerimeter = numberOfCurrentPerimeter + 1;
  }

  // store 2nd and subsequent Perimeter points for a specific hummock
  if (key == 'p' || key == 'P') {
    pX[currentPerimeterPoint] = mouseX;
    pY[currentPerimeterPoint] = mouseY;
    fill(255, 0, 255);
    ellipse(pX[currentPerimeterPoint], pY[currentPerimeterPoint], 10, 10);

    strokeWeight(2);
    stroke(255, 0, 255);
    line(pX[currentPerimeterPoint-1], pY[currentPerimeterPoint-1], pX[currentPerimeterPoint], pY[currentPerimeterPoint]);

    measuredDistance = dist(pX[currentPerimeterPoint-1], pY[currentPerimeterPoint-1], pX[currentPerimeterPoint], pY[currentPerimeterPoint]);
    saveRoundedMeasuredDistance(measuredDistance);
    f = str(roundedMeasuredDistance);

    perimiterLength = perimiterLength + roundedMeasuredDistance;
    println("perimiterLength = " + perimiterLength);
    text(f, pX[currentPerimeterPoint] * textOffset, pY[currentPerimeterPoint] * textOffset);

    numberOfPerimeterPointsInCurrentHummock[numberOfCurrentPerimeter] = numberOfPerimeterPoints; // count the number of Perimeter points in the currentHummock

    numberOfPerimeterPoints = numberOfPerimeterPoints + 1;
    currentPerimeterPoint ++;  // store the number of perimeters for poistion in array
  }


  // Close the perimter for a specific hummock ***************************
  if (key == 'o' || key == 'O') {

  // next like may be redundant
    endPerimeter[numberOfCurrentPerimeter] = currentPerimeterPoint-1; // remember where this perimerter ends



    stroke(255, 0, 255);
    strokeWeight(2);
    println("*** numberOfCurrentPerimeter = " + numberOfCurrentPerimeter);
    println("*** endPerimeter[numberOfCurrentPerimeter] = " + endPerimeter[numberOfCurrentPerimeter]);
    stroke(255, 0, 0);
    strokeWeight(3);
    line(pX[currentPerimeterPoint-1], pY[currentPerimeterPoint-1], sX[numberOfCurrentPerimeter -1], sY[numberOfCurrentPerimeter -1]);

    measuredDistance = dist(pX[currentPerimeterPoint -1], pY[currentPerimeterPoint -1], sX[numberOfCurrentPerimeter -1], sY[numberOfCurrentPerimeter -1]);
    saveRoundedMeasuredDistance(measuredDistance);
    println("roundedMeasuredDistance in O = " + roundedMeasuredDistance);

    perimiterLength = perimiterLength + roundedMeasuredDistance;
    perimiterLength = float(nf((perimiterLength), 0, 2)); // round off the perimeter Length to 2 desminal poinints

    f = str(perimiterLength);
    println("perimiterLength in O = " + perimiterLength);

    textSize(30);
    fill(255, 255, 0);
    text(f, sX[numberOfCurrentPerimeter -1] * textOffset, sY[numberOfCurrentPerimeter -1] * textOffset);
  } // end Close the perimter for a specific hummock ***************************

  saveCounter ++;
  if (key == 'z' || key == 'Z') {
    save("triodia_038_" + saveCounter + ".png");
  }

  if (key == 'c' || key == 'C') {
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    fill(0, 255, 0); // Green
    ellipse(x[1], y[1], 10, 10);
    ellipse(x[2], y[2], 10, 10);


    fill(255, 255, 0); // Yelow
    scale1 = true;
    grid();
  }
  strokeWeight(1);

  // WSAD movement of lmage on screen WSAD WSAD WSAD WSAD WSAD WSAD WSAD WSAD 
  if (key == 'w' || key == 'W') {

    println("mouseX = " + mouseX);
    println("mouseY = " + mouseY);
    imgY = imgY - 100;

    for (int i = 0; i < 200; i++) {
      y[i]  = y[i]  - 100; // update the y points for every pair
      sY[i] = sY[i] - 100; // update the starting y Poinits for each perimeter
    }

    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("w");
    redraw();
  }

  if (key == 's' || key == 'S') {
    imgY = imgY + 100;
    for (int i = 0; i < 200; i++) {
      y[i] = y[i]  + 100; // update the y points for every pair
      sY[i] = sY[i] + 100; // update the starting y Poinits for each perimeter
    } 
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("s");
    redraw();
  }


  if (key == 'a' || key == 'A') {
    imgX = imgX - 100;

    for (int i = 0; i < 200; i++) {
      x[i]  = x[i]  - 100;  // update the position of each x point in the array
      sX[i] = sX[i] - 100;  // update the starting x Poinits for each perimeter
    }
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("a");
    redraw();
  }

  if (key == 'd' || key == 'D') {
    imgX = imgX + 100;
    for (int i = 0; i < 200; i++) {
      x[i]  = x[i]  + 100;  // update the x points 
      sX[i] = sX[i] + 100;  // update the starting x Poinits for each perimeter
    }
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("d");
    redraw();
  }

  if (key == 'r' || key == 'R') {
    redraw();
  }
} // end void keyPressed()

void saveRoundedMeasuredDistance(float measuredDistance) {
  roundedMeasuredDistance = float(nf((measuredDistance / distance), 0, 2));
  // println("distance in meters = " + roundedMeasuredDistance);
}

// draw a grid of dots on the screen 
void grid() {
  fill(255, 255, 0); // Yelow
  for (float i = 0; i < width; i = i + distance) {
    for (float j = 0; j < height; j = j + distance) {
      if (scaleSet == true) {
        ellipse(i, j, 4, 4);
      }
    }
  }
}


void redraw() {
  println("redrawing");
  if (scale1 == false && scale2 == false) {
    return;
  }

  fill(0, 255, 0); // Green
  ellipse(x[1], y[1], 10, 10);
  ellipse(x[2], y[2], 10, 10);




  for (int i = 3; i < maxNumberOfPairs - 2; i = i + 2) {
    ellipse(x[i], y[i], 10, 10); // first ellipse in the pair
    ellipse(x[i+1], y[i+1], 10, 10); // second ellipse in the pair
    stroke(255, 0, 255); // magenta
    strokeWeight(2);
    line(x[i], y[i], x[i+1], y[i+1]);
    strokeWeight(1);

    measuredDistance = dist(x[i], y[i], x[i+1], y[i+1]);
    saveRoundedMeasuredDistance(measuredDistance);

    //  println("distance in meters = " + roundedMeasuredDistance);
    f = str(roundedMeasuredDistance);
    stroke(255, 255, 0); // Yelow
    fill(255, 255, 0); // Yelow
    text(f, x[i+1] * textOffset, y[i+1] * textOffset);
    fill(255, 0, 255); // magenta
  }
  redrawPerimeters();
}

void redrawPerimeters() {

  //  image(img, imgX, imgY); // display the image on the screen

  println(" ** numberOfPerimeters ** = " + numberOfPerimeters);

  // redraw each perimerter set 
  for (int i = 0; i < numberOfPerimeters; i ++) {

    // start point
    fill(255, 255, 0); // magenta
    ellipse(sX[i], sY[i], 10, 10);  // draw the start point for each perimiter
    
    println("i = " + i);
    println("numberOfPerimeterPointsInCurrentHummock[i] = " + numberOfPerimeterPointsInCurrentHummock[i]);
   
    for (int j = 0; j < numberOfPerimeterPointsInCurrentHummock[i]; j ++) {
      println("inside J = " + j);
      ellipse(pX[j], pY[j], 10, 10);  // draw the start point for each perimiter
    }
  }
}
