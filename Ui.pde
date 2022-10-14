void setUI() {

  //UI
  cp5 = new ControlP5(this);
  
  //global control
  int globalGrpX = 20;
  int globalGrpY = 20;
  
  Group GLOBAL = cp5.addGroup("GLOBAL")
             .setPosition(globalGrpX, globalGrpY);
  
  cp5.addButton("reset")
     .setValue(0)
     .setPosition(0, 5)
     .setSize(99,10)
     .setGroup(GLOBAL);
     
   cp5.addButton("gen palette")
     .setValue(0)
     .setPosition(102, 5)
     .setSize(99,10)
     .setGroup(GLOBAL);
     
  cp5.addButton("save frame")
     .setValue(0)
     .setPosition(0, 20)
     .setSize(200,10)
     .setGroup(GLOBAL);
     
  cp5.addSlider("resolution", 1, 10, resolution, 0, 35, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(GLOBAL);
             
  cp5.addSlider("nbStates", 5, 25, nbStates, 0, 50, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(GLOBAL);
             
  cp5.addSlider("opacity", 0, 255, opacity, 0, 65, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(GLOBAL);
             
  cp5.addSlider("distortion", 0, 100, distortion, 0, 80, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(GLOBAL);
             
  neighbors = cp5.addCheckBox("Moore")
      .setValue(1)
      .setSize(20,20)
      .setPosition(0, 95)
      .addItem("Moore neighbors", 0)
      .setGroup(GLOBAL);
             
  //cyclic control
  int cyclicGrpX = 20;
  int cyclicGrpY = 160;
  
  Group CYCLIC = cp5.addGroup("cyclic rule")
             .setPosition(cyclicGrpX, cyclicGrpY);
  
  cp5.addSlider("tresh", 1, 10, tresh, 0, 5, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(CYCLIC);
             
  cp5.addSlider("range", 1, 10, range, 0, 25, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(CYCLIC);     
             
  //extended range control
  int extendedRangeGrpX = 20;
  int extendedRangeGrpY = 230;
  
  Group EXTENDED = cp5.addGroup("extended range rule")
             .setPosition(extendedRangeGrpX, extendedRangeGrpY);
  
  cp5.addSlider("rangeExtended", 0, 30, rangeExtended, 0, 5, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(EXTENDED);
             
  cp5.addSlider("increment", 0, 30, increment, 0, 25, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(EXTENDED);  
             
  //global control
  int colorGrpX = 250;
  int colorGrpY = 20;
  
  Group COLOR = cp5.addGroup("COLOR")
             .setPosition(colorGrpX, colorGrpY);
  
  cp5.addSlider("hueOffset", -255, 255, hueOffset, 0, 5, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(COLOR);
             
  cp5.addSlider("saturationOffset", -255, 255, saturationOffset, 0, 20, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(COLOR); 
             
  cp5.addSlider("brightnessOffset", -255, 255,brightnessOffset, 0, 35, sliderLength, 10)
             .setColorCaptionLabel(255)
             .setGroup(COLOR);   
             
  //rule selector
  int rulesGrpX = 20;
  int rulesGrpY = height - 100;
  
  Group RULES = cp5.addGroup("RULE SELECTOR")
             .setPosition(rulesGrpX, rulesGrpY);
  
  rules = cp5.addRadioButton("ruleSelector")
      .setValue(1)
      .setSize(13,13)
      .setItemsPerRow(1)
      .setSpacingColumn(20)
      
      .setPosition(0, 0)
      .addItem("cyclic", 0)
      .addItem("extended range", 50)
      .addItem("100", 100)
      .addItem("150", 150)
      .addItem("200", 200)
      .addItem("255", 255)
      .setGroup(RULES);          
             
  cp5.setAutoDraw(false);
}
