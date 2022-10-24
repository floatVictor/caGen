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
      color c;
      pg.textSize(resolution);
      
      if(state < nbStates/2) {
        c = color(hue(palette[state]) + hueOffset, 
            saturation(palette[state]) + saturationOffset, 
            brightness(palette[state]) + brightnessOffset);
      }
      else {
        c = color(hue(palette[state]) + hueOffset2, 
            saturation(palette[state]) + saturationOffset2, 
            brightness(palette[state]) + brightnessOffset2);
      }
          
      pg.fill(c, opacity);      
      pg.noStroke();
      if(ascii) pg.text(str(state), 
          x + map(noise(x * .004, generation * .07), 0, 1, -distortion, distortion), 
          y + map(noise(Y * .008, generation * .01), 0, 1, -distortion, distortion));
      else pg.rect(
          x + map(noise(x * .004, generation * .07), 0, 1, -distortion, distortion), 
          y + map(noise(Y * .008, generation * .01), 0, 1, -distortion, distortion), 
          resolution, resolution);
  }
}
