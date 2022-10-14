//lib setup
import controlP5.*;

//global var
PGraphics pg;

int resolution = 2;
int sizeX = 1600;
int sizeY = 900;
int generation = 0;

int cols = (int)(sizeX / resolution);
int rows = (int)(sizeY / resolution);
Cell[][] matrix = new Cell[cols][rows];
int[][] matrixTemp = new int[cols][rows];

int nbRules = 2;
int[] ruleTrig = new int[nbRules];

int nbStates = 14;
int ruleSelector;

int opacity = 25;
int distortion = 10;

//cyclic var
int tresh = 3;
int range = 2;
boolean moore = false;

//extendedRange
int rangeExtended = 3;
int increment = 3;

//color
int colorNumber = nbStates;
color[] palette = new color[colorNumber];
int saturationOffset = 0;
int hueOffset = 0;
int brightnessOffset = 0;

//UI
ControlP5 cp5;
CheckBox neighbors;
RadioButton rules;
int sliderLength = 200;
boolean visible = true;

void setup() {
  
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
  displayMatrix();
  
  updateMatrix();
  pg.endDraw();
  image(pg, 0, 0); 
  
  if(!visible) cp5.hide();
  else cp5.show();
  cp5.draw();
  generation ++;
}

void setupMatrix() {
  
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
  case 0: 
    cyclicRules();
    break;
  case 1: 
    extendedRangeRule();
    break;
  }
  
  squareMutation(13, (int)random(1,20), 700);
  for(int i = 0; i < cols; i++) {
    
    for(int j = 0; j < rows; j++) {
      
     matrix[i][j].state = matrixTemp[i][j];
    }
  }
}

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
    
  if (theControlEvent.isFrom("gen palette")) {
    
      palette = genPalette(colorNumber);
    }
    
  if (theControlEvent.isFrom("save frame")) {
    
      saveFrame("saveFrame/ca-#####.png");
    }
    
  if (theControlEvent.isFrom("Moore")) {
    
    if ((int)neighbors.getArrayValue()[0] == 0) moore = false;
    else moore = true;
    }
  
  if (theControlEvent.isFrom("ruleSelector")) {
    
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
  if (key == 'h') {
    if(!visible) visible = true;
    else visible = false;
  }
}
