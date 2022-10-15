void circle() {
  background(255);
  strokeWeight(50);
  stroke(0);
  fill(255);
  circle(width/2-300,height/2,700);
  noStroke();
  fill(#FF7D03);
  circle(width/2-300, height/2-350, 50);  
  textSize(30);
  fill(#FF7D03);
  text("START", width/2-300, 130);
  text("FINISH", width/2-300, 245);
}
