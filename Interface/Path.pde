void path() {
  //----------DRAWING CODE----------//
  background(255);
  switch (status) {//draw path
  case 1:
    circle();
    break;
  case 2:
    tint(255, alpha);
    image(Spiral, width/2-250, height/2, 900, 900);
    break;
  case 3:
    flake();
    break;
  case 4:
    zigzag();
    break;
  }
  
  strokeWeight(0);
  stroke(0);
  //Shows the time elapsed since the start of the path mode
  textSize(100);
  fill(0, 204, 0);
  for (int x = -1; x < 8; x++) {
    text("Time: "+stime+"s", 0.75*width+140+x, 175+x);
  }
  fill(0, 153, 0);
  text("Time: "+stime+"s", 0.75*width+140, 175);  
  //Shows the percentage of black and white
  textSize(50);
  fill(0);
  text("Time on black:  "+pBlack+"%", 0.75*width+140, 300);
  text("Time on white:  "+pWhite+"%", 0.75*width+140, 400);

  //Draw plot
  plot1.beginDraw();
  plot1.drawBackground();
  plot1.drawBox();
  plot1.drawXAxis();
  plot1.drawYAxis();
  plot1.drawTitle();
  plot1.drawGridLines(GPlot.BOTH);
  plot1.drawPoints();
  plot1.drawLines();
  plot1.endDraw();
  
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
  //----------DRAWING CODE END----------//

  if (keyPressed && openResults==false) {
    if ((key==ENTER || key==RETURN) && !trackStarted) {  //Path started when enter is pressed
      setup();
      trackStarted=true;
      start=millis();      
      //myPort.write(65);        //Write 'a' on the serial port --> ARDUINO reads
      points = new GPointsArray();
    } else if (key==32 && trackStarted) {    //Path finished when SPACE (ASCII code 32) is pressed
      trackStarted=false;
      //myPort.write(66);        //Write 'b' on the serial port --> ARDUINO reads
      save = 1;
      openResults=true;      //openResults triggers the pop-up results window
      setup();
    }
  }
  if (trackStarted) { //what to do during session
    time=(millis()-start)/1000;
    //manage plot data-window
    if (dataReceived==true) {   //when a data from the serial port is available
      dataReceived = false;
      myPort.clear();
      plot1.addPoint(time, sensorValue);  //add this data to the array of points "points"
      points.add(time, sensorValue);
      //println("Dato aggiunto "+sensorValue);
      if (sensorValue==0)
        countWhite++;
      else
        countBlack++;
      sumColor=(countWhite+countBlack);
      pBlack = round((countBlack/sumColor)*100);
      pWhite = round((countWhite/sumColor)*100);
      if (plot1DataLen>=plot1MaxDataLen) { //when the array is full (100 points) ...
        plot1.removePoint(0);
      } else plot1DataLen++; //increment the index of the aray
    }
  }

  //Rounds "time" to the second decimal
  //NB "stime" is a string
  stime=nf(time, 0, 2);
  if (openResults) {//Pop-Up window
      results();
  }
}
