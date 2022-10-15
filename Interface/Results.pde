void results(){ //this is a drawing function only
  fill(255,245);
  rect(width/2, height/2, 1500, 1000, 5);
  
  textAlign(CENTER);
  textSize(100);
  
  fill(0, 204, 0);
  for (int x = -1; x < 8; x++) {
    text("RESULTS", width/2+x, height/2-375+x);
  }
  fill(0, 153, 0);
  text("RESULTS", width/2, height/2-375);

  textSize(50);      // Showing the run results
  textAlign(LEFT);
  fill(0);
  text("Total time: "+stime+"s", width/2-700, height/2-300);    
  text("Time on black:  "+pBlack+"%", width/2-700, height/2-250);
  text("Time on white:  "+pWhite+"%", width/2-700, height/2-200);
  
  tint(255,alpha);
  if (pBlack>=95){
    image(perfect, width/2+450, height/2-300, emojiDimension, emojiDimension);
  } else if (pBlack < 95 && pBlack >= 80){
    image(excellent, width/2+450, height/2-300, emojiDimension, emojiDimension);
  } else if (pBlack < 80 && pBlack >= 70){
    image(good, width/2+450, height/2-300, emojiDimension, emojiDimension);
  } else {
    image(bad, width/2+450, height/2-300, emojiDimension, emojiDimension);
  }
  
  if (overRect(menuX, menuY, menuW, menuH)) {
    menuOver=true;
    restartOver=false;
  } else if (overRect(resX, resY, menuW, menuH)) {
    menuOver=false;
    restartOver=true;
  } else {
    menuOver=restartOver=false;
  }
  if (menuOver)
    fill(0, 204, 0);
  else
    fill(0, 153, 0);
    
  rect(menuX, menuY, menuW, menuH, 5);
  textSize(30);
  textAlign(CENTER, CENTER);
  fill(255);
  text("MENU", menuX, menuY-3);
  
  if (restartOver)
    fill(0, 204, 0);
  else
    fill(0, 153, 0);
  rect(resX, resY, menuW, menuH, 5);
  textSize(30);
  textAlign(CENTER, CENTER);
  fill(255);
  text("AGAIN", resX, resY-3);
  
  //Draw plot
  plotRes.beginDraw();
  plotRes.drawBox();
  //plotRes.drawBackground();
  plotRes.drawXAxis();
  plotRes.drawYAxis();
  plotRes.drawTitle();
  plotRes.drawGridLines(GPlot.BOTH);
  plotRes.drawLines();
  plotRes.endDraw();
  
  //STATISTICS//
  //Insert results to the table obj in a new row and then save the .csv file
  
  if (save==1){
    table = loadTable("statistics.csv","header");
    TableRow newRow = table.addRow();
    newRow.setInt("ID_run", table.lastRowIndex()+1);
    newRow.setInt("pBlack", pBlack);
    newRow.setString("Time", stime);
    //newRow.setInt("Path",status);
    saveTable(table, "statistics.csv");
    save=0;
  }
}
