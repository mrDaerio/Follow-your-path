//Serial Communication
import processing.serial.*;
import grafica.*;

/*file
  String fileName = "C:\\Users\\Dario\\Downloads\\Interface\\History.txt";
  String fileLines[];
  StringList history;
*/

//Graph
GPlot plot1;
int plot1MaxDataLen=100;

boolean dataReceived = false; //serial data received - flag
int plot1DataLen; //serial data used - counter


Serial myPort;


int sensorValue;


//Thumbnails
int rectOver = 0; // 0 = nothumb, 1 = path1, 2 = path2, 3 = path3, 4 = path4
//--appearance
int thumbX, thumbY; //thumbnail's position and dimension (it's a square)
int thumbLength=300, dim=1000;
int alpha=255, beta=100; //thumbnail's opacity
PImage paths[] = new PImage [4];
String thumbLabels[] = {"EASY MODE","MEDIUM MODE","HARD MODE","EXTREME MODE"};
boolean statOver = false;
    
PImage Spiral;

//results
//--emoji
PImage perfect, excellent, good, bad;
int emojiDimension = 275;
//--menu button
int menuX, menuY, resX, resY;
int menuW=125, menuH=50;
boolean menuOver=false, restartOver=false;
    
//BACK button
int backX=1820, backY=1000;
boolean backOver=false;

//Analysing variables
int  countBlack=0, countWhite=0; //counters for results on black or white
int pBlack, pWhite; //percentages for results on black or white
float sumColor;
//--stopwatch
float start=0, time=0;
String stime;

//Scripting variables
int status = -1;  //-1 = first setup, 0 = main, 1-4 = path 1-4, 5 = statistics
boolean trackStarted=false;
boolean openResults=false;

//Results graph
  GPlot plotRes;
  GPointsArray points;
  
//statistics
  GPlot plotStat;
  Table table;
  GPointsArray stats;
  int save;

//Create Processing window
void settings() {
  fullScreen();
  //size(1900,1000);
}

void setup() {  //initialize things
  if (status ==-1) { //First setup, run only once
    table = new Table();
  
    table.addColumn("ID_run");
    table.addColumn("pBlack");
    table.addColumn("Time");
    table.addColumn("Path");
    /* file handling
    //forse da spostare in setup status 0 (main)? Quando torno al menu leggo la lista?
    history = new StringList();
    fileNames = listFileNames(folderName);
    if (fileNames!=null)
    {
      for (String file : fileNames){
        println(file);
        fileLines = loadStrings(folderName+"\\"+file);
        for (String line : fileLines)
        {
          println("\t"+line);
        }
        history.append(file);
        history.append(fileLines[0]);
        history.append(fileLines[1]);
      }
      printArray(history);
    }
    */
    
    //Establish serial communication
    //----- UNCOMMENT ONLY IF ARDUINO IS CONNECTED!!! OTHERWISE LEAVE COMMENTED -----
   /* String portName=Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
    */

    frameRate(60);
  
    rectMode(CENTER);
    imageMode(CENTER);
  
    //Defines some fixed variables
    thumbX=width/2;
    thumbY=height/2-thumbLength/2+100;
    
    menuX=width/2-75;
    menuY=height/2+450;
    resX=width/2+75;
    resY=height/2+450;
  
    //Load path thumbnails
    paths[0]=loadImage("Circle.PNG");
    paths[1]=loadImage("Spiral.PNG");
    paths[2]=loadImage("Flake.PNG");
    paths[3]=loadImage("Zigzag.PNG");
    
    Spiral=loadImage("Spirale.PNG");
    
    perfect=loadImage("love.png");
    excellent=loadImage("verygood.png");
    good=loadImage("good.png");
    bad=loadImage("grr.png");
    
    status = 0;
  }
  else if (openResults==true)  //results setup
  {
    plotRes = new GPlot(this);  //initializing the object plotRes
    plotRes.setPos(width/2-725,height/2-140); //set position of the plot (x,y)
    plotRes.setDim(1350,450); //set the inner dimension of the plot (width, height)
    plotRes.setTitleText("Last Run's Statistics"); //set the title of the plot
    plotRes.getTitle().setFontSize(20);
    plotRes.getXAxis().setAxisLabelText("Time [s]"); //set x-axis label
    plotRes.getYAxis().setAxisLabelText("Color");//set y-axis label
    plotRes.getXAxis().setFontSize(15); //set x-axis label dimension
    plotRes.getXAxis().getAxisLabel().setFontSize(25); //set x-axis label dimension
    plotRes.getXAxis().getAxisLabel().setFontColor(100);
    plotRes.getYAxis().setFontSize(15); //set x-axis label dimension
    plotRes.getYAxis().getAxisLabel().setFontSize(25); //set x-axis label dimension
    plotRes.getYAxis().getAxisLabel().setOffset(25);
    plotRes.getYAxis().getAxisLabel().setFontColor(100);
    plotRes.setYLim(0,255);
    plotRes.setXLim(0,time);
    plotRes.setLineWidth(5);
    plotRes.setLineColor(color(0,204,0));
    plotRes.getYAxis().setDrawTickLabels(true);
    plotRes.getXAxis().setDrawTickLabels(true);
    plotRes.setAxesOffset(4);
    plotRes.setTicksLength(4);
    plotRes.getYAxis().setTicksSeparation(255);
    plotRes.getXAxis().setTicksSeparation(1);
    plotRes.setBoxBgColor(color(250,255,250));
    
    plotRes.setPoints(points); //add the points to the plot
    String[] newLabels = {"WHITE", "BLACK"};
    plotRes.getYAxis().setTickLabels(newLabels);
    plotRes.getYAxis().setRotateTickLabels(false);
  }
  else if (status==0)
    rectOver=0;
  else if (status>=1&&status<=4)  //path setup
  {
    //initialize record
    points = new GPointsArray();
    
    //Initialize graph
    plot1=new GPlot(this);
    plot1.setPos(width/2+300, height/2-75);
    plot1.setDim(500, 400);
    plot1.getTitle().setText("ARE YOU FOLLOWING THE PATH?");
    plot1.getTitle().setFontSize(20);
    plot1.getXAxis().getAxisLabel().setText("Time [s]");
    plot1.getYAxis().getAxisLabel().setText("Color");
    plot1.getXAxis().setFontSize(15); //set x-axis label dimension
    plot1.getXAxis().getAxisLabel().setFontSize(25); //set x-axis label dimension
    plot1.getXAxis().getAxisLabel().setFontColor(100);
    plot1.getYAxis().setFontSize(15); //set x-axis label dimension
    plot1.getYAxis().getAxisLabel().setFontSize(25); //set x-axis label dimension
    plot1.getYAxis().getAxisLabel().setOffset(25);
    plot1.getYAxis().getAxisLabel().setFontColor(100);
    plot1.setYLim(0,255);
    plot1.setPointSize(1);
    plot1.setPointColor(color(0,204,0));
    plot1.setLineColor(color(0,204,0));
    plot1.setLineWidth(5);
    plot1.getYAxis().setDrawTickLabels(true);
    plot1.getXAxis().setDrawTickLabels(true);
    plot1.setAxesOffset(4);
    plot1.setTicksLength(4);
    plot1.getYAxis().setTicksSeparation(255);
    plot1.getXAxis().setTicksSeparation(1);
    plot1.setBoxBgColor(color(250,255,250));
    String[] newLabels = {"WHITE", "BLACK"};
    plot1.getYAxis().setTickLabels(newLabels);
    plot1.getYAxis().setRotateTickLabels(false);
    
    //initialize counters
    countWhite=0;
    countBlack=0;
    pBlack=0;
    pWhite=0;
    time=0;
    plot1DataLen = 0;
  }
  else if (status==5) //statistics setup: the drawing happens only once so it's all here
  {
    //draw background
    background(255);
    
    //read table
    table = loadTable("statistics.csv","header");
    
    stats = new GPointsArray();
    
    int[] ID = new int[table.getRowCount()];
    int[] percentage = new int[table.getRowCount()];
    String[] totalTime = new String[table.getRowCount()];
    //int[] percorsi = new int[table.getRowCount()];
    int i=0;
    
    //Saves values from specific row to ID, percentage, totalTime
    for (TableRow row : table.rows()) {
      ID[i] = row.getInt("ID_run");
      percentage[i] = row.getInt("pBlack");
      totalTime [i]= row.getString("Time");
      //percorsi [i] = row.getInt("Path");
      stats.add(ID[i],percentage[i]);
      i++;
    }
    
    //Adds values to "stats" GPoints array
    //for (i=0;i<table.getRowCount();i++){
    //  stats.add(ID[i],percentage[i]);
    //}
    
    println(percentage);
    
    //initialize plot
    plotStat = new GPlot(this);  //initializing the object plotStat
    plotStat.setPos(85,130); //set position of the plot (x,y)
    plotStat.setDim(1680,750); //set the inner dimension of the plot (width, height)
    //plotStat.setTitleText("Statistics"); //set the title of the plot
    plotStat.getXAxis().setAxisLabelText("Runs"); //set x-axis label
    plotStat.getXAxis().setFontSize(25); //set x-axis label dimension
    plotStat.getXAxis().getAxisLabel().setFontSize(50); //set x-axis label dimension
    plotStat.getXAxis().getAxisLabel().setFontColor(100);
    plotStat.getYAxis().setAxisLabelText("Accuracy [%]");//set y-axis label
    plotStat.getYAxis().setFontSize(25); //set x-axis label dimension
    plotStat.getYAxis().getAxisLabel().setFontSize(50); //set x-axis label dimension
    plotStat.getYAxis().getAxisLabel().setOffset(65);
    plotStat.getYAxis().getAxisLabel().setFontColor(100);
    plotStat.setLineWidth(2);
    plotStat.setYLim(0,100);
    plotStat.setXLim(1,table.getRowCount());
    plotStat.setLineColor(color(0,204,0));
    plotStat.getYAxis().setDrawTickLabels(true);
    plotStat.getXAxis().setDrawTickLabels(true);
    plotStat.setAxesOffset(4);
    plotStat.setTicksLength(4);
    plotStat.getYAxis().setTicksSeparation(10);
    plotStat.getXAxis().setTicksSeparation(1);
    plotStat.setPointColor(color(0,153,0));
    plotStat.setPointSize(15);
    plotStat.setBoxBgColor(color(250,255,250));
    plotStat.getYAxis().setRotateTickLabels(false);
            
    plotStat.setPoints(stats); //add the points to the plot
    // for (int j : percorsi)
    //{
    //  switch(j){
    //    case 1:
    //      plotStat.setPointColor(color(0,204,0));
    //    case 2:
    //      plotStat.setPointColor(color(0,0,204));
    //    case 3:
    //      plotStat.setPointColor(color(204,204,0));
    //    case 4:
    //      plotStat.setPointColor(color(204,0,0));
    //  }
    //}
    
      //Draw plot
    plotStat.beginDraw();
    plotStat.drawBackground();
    plotStat.drawBox();
    plotStat.drawXAxis();
    plotStat.drawYAxis();
    plotStat.drawTitle();
    plotStat.drawGridLines(GPlot.BOTH);
    plotStat.drawLines();
    plotStat.drawPoints();
    plotStat.endDraw();
    
    
    
    
    textSize(100);
    textAlign(CENTER);
    fill(0,204,0);
    for (int x = -1; x < 8; x++) {
      text("STATISTICS", width/2+x, height/2-430+x);
    }
    fill(0, 153, 0);
    text("STATISTICS", width/2, height/2-430);
  }
}

void draw() {

  if (status == 0) { //sono nel main
    //Calls the update() function (see below)
    update();
    
    background(255);
    tint(255, 100);

    //Writes the main title
    textSize(100);
    textAlign(CENTER);
    fill(0,204,0);
    for (int x = -1; x < 8; x++) {
      text("CHOOSE YOUR PATH", width/2+x, height/2-300+x);
    }
    fill(0, 153, 0);
    text("CHOOSE YOUR PATH", width/2, height/2-300);

    //If mouse passes on a thumbnail, it writes a description text, enlarges the thumbnail and changes its opacity
    for (int i=0;i<4;i++){
      if (i==(rectOver-1)){
        textSize(30);
        textAlign(CENTER);
        fill(0);
        text(thumbLabels[i], thumbX-600+400*i, thumbY+200);
        tint(255, alpha);
        image(paths[i], thumbX-600+400*i, thumbY, thumbLength+20, thumbLength+20);
      }
      else
      {
        tint(255, beta);
        image(paths[i],thumbX-600+400*i,thumbY,thumbLength,thumbLength);
      }
    }
    
    if (overRect(thumbX, thumbY+400, menuW*4, menuH*2)) {
      statOver=true;
    } else statOver=false;
    noStroke();
    if (statOver) {
      fill(0, 204, 0);
      rect(thumbX, thumbY+400, menuW*4, menuH*2,5);
      textSize(70);
      textAlign(CENTER, CENTER);
      fill(255);
      text("STATISTICS", thumbX, thumbY+390);
    } else {
      fill(0, 153, 0);
      rect(thumbX, thumbY+400, menuW*4, menuH*2, 5);
      textSize(70);
      textAlign(CENTER, CENTER);
      fill(255);
      text("STATISTICS", thumbX, thumbY+390);
    }

  } 
  else if (status>=1&&status<=4){ //sono in una path
    path();
  }
  else if (status==5){//sono nelle statistiche
  //BACK TO MAIN MENU
    if (overRect(backX, backY, menuW, menuH)) {
      backOver=true;
    } else backOver=false;
  
    if (backOver) {
      fill(0, 204, 0);
      rect(backX, backY, menuW, menuH, 5);
      textSize(30);
      textAlign(CENTER, CENTER);
      fill(255);
      text("BACK", backX, backY-3);
    } else {
      fill(0, 153, 0);
      rect(backX, backY, menuW, menuH, 5);
      textSize(30);
      textAlign(CENTER, CENTER);
      fill(255);
      text("BACK", backX, backY-3);
    }
  }
}

//Whenever something is written in the serial port the serialEvent function is called and it reads the sensorValue
//----- UNCOMMENT ONLY IF ARDUINO IS CONNECTED!!! OTHERWISE LEAVE COMMENTED -----
/*
void serialEvent(Serial myPort) {
  //println("Dato ricevuto: "+sensorValue);
  if (trackStarted&&dataReceived==false){
    sensorValue=myPort.read();
    dataReceived=true;
  }
  else
    dataReceived=false;
}
*/


//Every loops checks whether the mouse has passed on a determined thumbnail (see overRect() function below) and return 'true' for thumbnail 'rectOver' (1,2,3 or 4)
void update() {
  rectOver=0;
  for (int i=0;i<4&&rectOver==0;i++)
  {
    if (overRect(thumbX-600+400*i, thumbY, thumbLength, thumbLength))
      rectOver=i+1;
  }
}

//If mouse passes on a thumbnail's coordinates returns 'true', else 'false'
boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x-width/2 && mouseX <= x+width/2 && 
    mouseY >= y-height/2 && mouseY <= y+height/2) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  if (status==0){//ho premuto il mouse nel main
      update(); //controllo dov'è il mouse
      if (rectOver!=0){ //ho premuto mentre ero sopra una path
        status = rectOver; //passo alla path;
        time=0;
        setup();
      }
      else if (statOver){
        status=5;
        setup();
      }
  }
  else if (status>=1&&status<=4){ //ho premuto il mouse nella path
    if (backOver)
    {
      status = 0;
      openResults=false;
      trackStarted=false;
      setup();
    }
    if (openResults){
      if (menuOver)
      {
        openResults=false;
        status=0;
        setup();
      }
      else if (restartOver)
      {
        openResults=false;
        setup();
      }
    }
  }
  else if (status==5){
    if (backOver)
    {
      status = 0;
      setup();
    }
  }
}
