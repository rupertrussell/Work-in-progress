// Triodia 032
// Display phot of a transect with scale 
// 1) Click on top corner of transect scale in photo
// 2) click on oposite corner of transect scale eg 1 meter from first click on photo
// 3) move the mouse to the first point you eant to measure press 1
// 4) move the mouse to the second point you want to measure press 2
// 5) read the distance releative to the scape of the transct in meters
// move mouse to a new point press 1 move to another point and press 2 
// sread new distance between points

int maxNumberOfPairs = 200;
int maxNumberOfPerimeters = 100;
int numberOfPerimeters  = 0; // number of perimeters measured
int currentPerimeterPoint = 0; // increment for each Perimeter point for all hummocks
int[] pX = new int[2000]; // store x perimeter points for all hummocks
int[] pY = new int[2000]; // store x perimeter points for all hummocks
int[] startPerimeter = new int[maxNumberOfPerimeters]; // remember the start of perimters point for hummock numberOfPerimeters
int[] endPerimeter = new int[maxNumberOfPerimeters]; // end of perimters points for a hummock
int numberOfCurrentPerimeter = 0;


// uses arrays to store the x  & y coordinates of up to maxNumberOfPairs measursemetn points
int[] x = new int[maxNumberOfPairs];
int[] y = new int[maxNumberOfPairs];
int i = 3; // index of array of points

// set up global variables

int imgX = 0;
int imgY = 0;
int imgSize = 1920;

String f = "";
float textOffset = 1.01;


int gridSize = 0;
boolean scaleSet = false;
boolean scale1 = false;
boolean scale2 = false;
boolean point1 = false;
boolean point2 = false;

int saveCounter = 0;
float distance  = 0;
float measuredDistance = 0;
float sumOfMeasuredDistance = 0;

float roundedMeasuredDistance = 0;

PImage img;  // holder for the photogaph

void setup() {
  size(1920, 1080);
  fill(255, 255, 0);

  // load and display a photo  not I have ediete the photo in photo shop to rotate the photo 
  // so that the edges of the scale are horozintal and vertical   

  //  img = loadImage("800x600.png");
  img = loadImage("4000x3000.jpg");
  img.resize(0, 1920);
  image(img, imgX, imgY); // display the image on the screen
}

void draw() {

  PFont f = createFont("Arial", 20);
  textFont(f);
  textSize(20);
  distance = dist(x[1], y[1], x[2], y[2]);  // calculate the distance in pixels between the first 2 clicks
} // end of void draw()



// each time the mouse is clicked do the following
void mouseClicked() {

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


// used to measure the size of Triodia clumps in the photo
void keyPressed() {

  if (key == '1' || key == '!') {
    if ((scaleSet == true) && (point1 == false)) {
      x[i] = mouseX;
      y[i] = mouseY;
      point1 = true;
      fill(255, 0, 255);
      ellipse(x[i], y[i], 10, 10);
      fill(255, 255, 0);

      i ++;  // in1crement i to point to next position in the array
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
      stroke(255, 0, 255);
      strokeWeight(2);
      line(x[i-1], y[i-1], x[i], y[i]);
      strokeWeight(1);
      stroke(0);
      fill(255, 255, 0);
      measuredDistance = dist(x[i-1], y[i-1], x[i], y[i]);
      saveRoundedMeasuredDistance(measuredDistance);

      println("distance in meters = " + roundedMeasuredDistance);
      f = str(roundedMeasuredDistance);
      text(f, x[i] * textOffset, y[i] * textOffset);
      i ++;  // increment i to point to next position in the array
    }
  }  // end Key 2

  // =============== start a new Perimeter for a hummock ======================
  if (key == 'n' || key == 'N') {
    startPerimeter[numberOfPerimeters] = currentPerimeterPoint; // remember where this perimerter begins

    pX[currentPerimeterPoint] = mouseX;
    pY[currentPerimeterPoint] = mouseY;
    fill(255, 0, 255);
    ellipse(pX[currentPerimeterPoint], pY[currentPerimeterPoint], 10, 10);
    fill(255, 255, 0);

    currentPerimeterPoint = currentPerimeterPoint + 1;  // store the number of perimeters for poistion in array
    numberOfPerimeters = numberOfPerimeters + 1;
  }

  // store 2nd and subsequent Perimeter points for a specific hummock
  if (key == 'p' || key == 'P') {

    pX[currentPerimeterPoint] = mouseX;
    pY[currentPerimeterPoint] = mouseY;
    fill(255, 0, 255);
    ellipse(pX[currentPerimeterPoint], pY[currentPerimeterPoint], 10, 10);
    fill(255, 255, 0);

    stroke(255, 0, 255);
    strokeWeight(2);
    line(pX[currentPerimeterPoint-1], pY[currentPerimeterPoint-1], pX[currentPerimeterPoint], pY[currentPerimeterPoint]);
    strokeWeight(1);
    stroke(0);
    currentPerimeterPoint = currentPerimeterPoint + 1;  // store the number of perimeters for poistion in array
  }


  // Close the perimter for a specific hummock
  if (key == 'o' || key == 'O') {
    endPerimeter[numberOfPerimeters] = currentPerimeterPoint-1; // remember where this perimerter ends
    stroke(255, 0, 255);
    strokeWeight(2);
    line(pX[currentPerimeterPoint-1], pY[currentPerimeterPoint-1], pX[startPerimeter[numberOfCurrentPerimeter]], pY[startPerimeter[numberOfCurrentPerimeter]]);
    strokeWeight(1);
    stroke(0);
  }


  if (key == '3' || key == '$') {
    if (point1 == true) {
      x[i] = mouseX;
      y[i] = mouseY;
      //point2 = true;
      //point1 = false;
      fill(255, 0, 255);
      ellipse(x[i], y[i], 10, 10);
      stroke(255, 0, 255);
      strokeWeight(2);
      line(x[i-1], y[i-1], x[i], y[i]);
      strokeWeight(1);
      stroke(0);
      fill(255, 255, 0);
      measuredDistance = dist(x[i-1], y[i-1], x[i], y[i]);
      saveRoundedMeasuredDistance(measuredDistance);

      println("distance in meters = " + roundedMeasuredDistance);
      f = str(roundedMeasuredDistance);
      text(f, x[i] * textOffset, y[i] * textOffset);
      i ++;  // increment i to point to next position in the array
    }
  }  // end Key 3


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
    imgY = imgY - 100;

    for (int i = 1; i < 200; i++) {
      y[i] = y[i] - 100;
    }

    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("w");
    redraw();
  }

  if (key == 's' || key == 'S') {
    imgY = imgY + 100;
    for (int i = 1; i < 200; i++) {
      y[i] = y[i] + 100;
    }
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("s");
    redraw();
  }


  if (key == 'a' || key == 'A') {
    imgX = imgX - 100;

    for (int i = 1; i < 200; i++) {
      x[i] = x[i] - 100;
    }
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("a");
    redraw();
  }

  if (key == 'd' || key == 'D') {
    imgX = imgX + 100;
    for (int i = 1; i < 200; i++) {
      x[i] = x[i] + 100;
    }
    background(0);
    image(img, imgX, imgY); // display the image on the screen
    println("d");
    redraw();
  }
} // end void keyPressed()

void saveRoundedMeasuredDistance(float measuredDistance) {
  roundedMeasuredDistance = float(nf((measuredDistance / distance), 0, 2));
  println("distance in meters = " + roundedMeasuredDistance);
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

  if (scale1 == false && scale2 == false) {
    return;
  }

  fill(0, 255, 0); // Green
  ellipse(x[1], y[1], 10, 10);
  ellipse(x[2], y[2], 10, 10);

  fill(255, 0, 255); // magenta
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
  println("numberOfPerimeters = " + numberOfPerimeters);
  // redraw each perimerter set 
  for (int i = 0; i < numberOfPerimeters; i ++) {
  }
}
