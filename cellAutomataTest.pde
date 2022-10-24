/*
note : 
enregistrer set de parametres
text inside UI
*/

//lib setup
import controlP5.*;

//global var
PGraphics pg;

boolean play = true;

int resolution = 3;
int sizeX = 1600;
int sizeY = 900;
int generation = 0;

int cols = (int)(sizeX / resolution);
int rows = (int)(sizeY / resolution);
Cell[][] matrix = new Cell[cols][rows];
int[][] matrixTemp = new int[cols][rows];

int nbRules = 3;
int[] ruleTrig = new int[nbRules];

int nbStates = 12;
int ruleSelector;

int opacity = 255;
int distortion = 0;

//cyclic rule
int tresh = 3;
int range = 2;
boolean moore = false;

//extended rule
int rangeExtended = 2;
int increment = 3;

//plasma rule
float plasmaRatio = 3.5;
float plasmaSpeed = 0.3;
boolean stateSpeed = false;

//color
int colorNumber = nbStates;
color[] palette = new color[colorNumber];
int saturationOffset = 0;
int hueOffset = 33;
int brightnessOffset = -15;
int saturationOffset2 = -255;
int hueOffset2 = -178;
int brightnessOffset2 = -53;

//UI
ControlP5 cp5;
CheckBox neighbors;
RadioButton rules;
int sliderLength = 200;
boolean visible = true;
boolean visible_back = false;
boolean ascii = false;

void setup() {
  println(moore);
  colorMode(HSB);
  background(0);
  size(1080, 720);
  setupMatrix();
  surface.setResizable(true);
  palette = genPalette(colorNumber);
  
  if(!visible) {
    cp5.hide();
    print("yo");
  }  
  surface.setSize(sizeX, sizeY);
  pg = createGraphics(width, height);
  setUI();
}

void draw() {
  for (int i = 0; i < nbRules; i++) {
    if (ruleTrig[i] == 1) ruleSelector = i;
  }

  
  pg.beginDraw();
  if(play) {
    if(visible_back) pg.background(0);
    displayMatrix();
    updateMatrix();
    generation ++;
  }
  pg.endDraw();
  image(pg, 0, 0); 
  
  if(!visible) cp5.hide();
  else cp5.show();
  cp5.draw();
}

void setupMatrix() {
  
  cols = (int)(sizeX / resolution);
  rows = (int)(sizeY / resolution);
  matrix = new Cell[cols][rows];
  noiseSeed((long)random(10000));
  for (int i = 0; i < cols; i++) {
    
    for (int j =0; j < rows; j++) {
      
      matrix[i][j] = new Cell(i, j, 
              floor(random(nbStates))); 
              //(int)map(noise(i * 20, j * 0.6), 0, 1, 0, nbStates);
    }
  }
}

void displayMatrix() {
  
  for(int i = 0; i < cols; i++) {
    
    for(int j = 0; j < rows; j++) {
     
      matrix[i][j].display();
    }
  }
}

void updateMatrix() {
  
  matrixTemp = new int[cols][rows];
  
  switch(ruleSelector) {
  case 0 : 
    cyclicRules();
    break;
  case 1 : 
    extendedRangeRule();
    break;
  case 2 : 
    plasmaRule();
    break;
  }
  
  //squareMutation(13, (int)random(1,20), 700);
  for(int i = 0; i < cols; i++) {
    
    for(int j = 0; j < rows; j++) {
      
     matrix[i][j].state = matrixTemp[i][j];
    }
  }
}

//neighbors function
int countNeighbors(Cell[][] matrix, int x, int y) {
 
  int sum = 0;
  int curState = matrix[x][y].state;
  int nextState = curState + 1 >= nbStates ? 0 : curState + 1;
  for(int i = - range; i <= range; i++) {
    
      for(int j = -range; j <= range; j++) {
        
        if(moore) {
          
          int col = (x + i + cols) % cols;
          int row = (y + j + rows) % rows;
          if (matrix[col][row].state == nextState) sum++;
        }
        else {
          
          if(i == j || i == -j) continue;
          int col = (x + i + cols) % cols;
          int row = (y + j + rows) % rows;
          if (matrix[col][row].state == nextState) sum++;
        }
      }
  }
  return sum;
}

int averageNeighbors(Cell[][] matrix, int x, int y, int range) {
 
  int sum = 0;
  int count = 0;
  int average;
  for(int i = - range; i <= range; i++) {
    
      for(int j = -range; j <= range; j++) {
        
        if(moore) {
          
          int col = (x + i + cols) % cols;
          int row = (y + j + rows) % rows;
          sum += matrix[col][row].state;
          count ++;
        }
        else {
          
          if(i == j || i == -j) continue;
          int col = (x + i + cols) % cols;
          int row = (y + j + rows) % rows;
          sum += matrix[col][row].state;
          count++;
        }
      }
  }
  average = round(sum / count);
  return average;
}

int noiseNeighbors(Cell[][] matrix,int x, int y) {
  
  int i = 0;
  int j = 0;
  int index;
  if(stateSpeed) {
    
    if (!moore) {index = int(map(noise(x * plasmaRatio * 0.001, y * plasmaRatio * 0.001, (matrix[x][y].state + generation) * plasmaSpeed * .1), 0, 1, 0, 3));}
    else index = int(map(noise(x * plasmaRatio * 0.001, y * plasmaRatio * 0.001, (matrix[x][y].state + generation) * plasmaSpeed * .1), 0, 1, 0, 7));
  }
  else {
    
    if (!moore) {index = int(map(noise(x * plasmaRatio * 0.001, y * plasmaRatio * 0.001, generation * plasmaSpeed * .1), 0, 1, 0, 3));}
    else index = int(map(noise(x * plasmaRatio * 0.001, y * plasmaRatio * 0.001, generation * plasmaSpeed * .1), 0, 1, 0, 7));
  }
  switch(index) {
    
    case 0 : 
      i = 0;
      j = 1;
      break;     
    case 1 : 
      i = 0;
      j = -1;
      break;      
    case 2 : 
      i = -1;
      j = 0;
      break;      
    case 3 : 
      i = 1;
      j = 0;
      break;     
    case 4 : 
      i = 1;
      j = 1;
      break;      
    case 5 : 
      i = 1;
      j = -1;
      break;     
    case 6 : 
      i = -1;
      j = 1;
      break;     
    case 7 : 
      i = 1;
      j = -1;
      break;
  }
  
  int col = (x + i + cols) % cols;
  int row = (y + j + rows) % rows;
  
  return matrix[col][row].state;
}

//rules

void cyclicRules() {
  
  for(int i = 0; i < cols; i++) {
    
    for(int j = 0; j < rows; j++) {
      
     int state = matrix[i][j].state;
     int neighbors = countNeighbors(matrix, i, j);
     if (neighbors >= tresh) state = (state + 1) % nbStates;
     matrixTemp[i][j] = state;
    }
  }
}

void extendedRangeRule() {
  
  for(int i = 0; i < cols; i++) {
    
    for(int j = 0; j < rows; j++) {
      
     int average = averageNeighbors(matrix, i, j, rangeExtended);
     matrixTemp[i][j] = (average + increment) % nbStates ;
    }
  }
}

void plasmaRule() {
  for(int i = 0; i < cols; i++) {
    
    for(int j = 0; j < rows; j++) {
      
      matrixTemp[i][j] = noiseNeighbors(matrix, i, j);
    }
  }
}

//mutations
void squareMutation(float chance, int range, int warp) {
  
  if(random(100) < chance){
    
    int rangeX = range;
    int rangeY = range;
    int x = (int)random(cols);
    int y = (int)random(rows);
    int newState = (int)random(nbStates);
    
    if(random(1) > 0.5) {rangeY = range + (int)random(-warp, warp); }
    else rangeX = range + (int)random(-warp, warp);
    
    for(int i = - rangeX; i <= rangeX; i++) {
    
      for(int j = -rangeY; j <= rangeY; j++) {
        
        int col = abs((x + i + cols) % cols);
        int row = abs((y + j + rows) % rows);
        
        matrixTemp[col][row] = newState;
      }
    }
  }
}

//UI event
void controlEvent(ControlEvent theControlEvent) {
  
  if (theControlEvent.isFrom("reset")) {
    
      setupMatrix();
    }
    
  if (theControlEvent.isFrom("back")) {
    
    visible_back = !visible_back;
    }  
    
  if (theControlEvent.isFrom("gen palette")) {
    
      palette = genPalette(colorNumber);
    }
    
  if (theControlEvent.isFrom("save frame")) {
    
      saveFrame("saveFrame/ca-#####.png");
    }
    
  if (theControlEvent.isFrom("Moore")) {
    
    moore = !moore;
    }
    
  if (theControlEvent.isFrom("ascii")) {
    
    ascii = !ascii;
    }
    
  if (theControlEvent.isFrom("stateSpeed")) {
    
    stateSpeed = !stateSpeed;
    }
  
  if (theControlEvent.isFrom("ruleSelector")) {
    
    print("yo");
    ruleTrig = new int[nbRules];
    for (int i = 0; i < rules.getArrayValue().length; i++) {
      
      int n = (int)rules.getArrayValue()[i];
      ruleTrig[i] = n;
      print(n);
    } 
  }
}

//color function
color[] genPalette(int nbC) {
  
  color[] palette = new color[nbC];
  int hue = (int)random(255);
  for(int i = 0; i < nbC/2; i++) {
    palette[i] = color(hue + 5 * i, int(map(noise(i * 0.01), 0, 1, 100, 255)), map(i, 0, nbC/2, 0, 255 * 2) % 255);
  }
  hue = hue + (int)random(50, 150);
  for(int i = nbC/2; i < nbC; i++) {
    palette[i] = color(hue - 5 * i, int(map(noise(i * 0.01), 0, 1, 80, 255)), map(i, 0, nbC/2, 0, 255 * 1.5) % 255);
  }
  return palette;
}

void keyPressed() {
  if (key == 'c') setupMatrix();
  if (key == 's') saveFrame("saveFrame/ca-#####.png");
  if (key == 'f') print("f");
  if (key == 'h') visible = !visible;
  if (key == ' ') play = !play;
}
