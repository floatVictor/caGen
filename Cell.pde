class Cell {
  
  int posX, posY;
  int state;
  
  Cell() {
    
    posX = 0;
    posY = 0;
    state = 0;
  }
  
  Cell(int _posX, int _posY, int _state) {
    
    posX = _posX;
    posY = _posY;
    state = _state;
  }
  
  void setState(int value) {state = value;}
  
  void update(int value, int nbStates) {
    
    state = (state + value) % nbStates;
  }
  
  void display() {
    
      int x = posX * resolution;
      int y = posY * resolution;
      
      color c = color(hue(palette[state]) + hueOffset, 
          saturation(palette[state]) + saturationOffset, 
          brightness(palette[state]) + brightnessOffset);
          
      pg.fill(c, opacity);      
      pg.noStroke();
      pg.rect(
          x + map(noise(x * .01, generation * .07), 0, 1, -distortion, distortion), 
          y + map(noise(Y * .008, generation * .1), 0, 1, -distortion, distortion), 
          resolution, resolution);
  }
}
