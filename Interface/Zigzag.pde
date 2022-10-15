void zigzag() {
  background(255);
  smooth();
  strokeWeight(50);
  line(width/2+100, height/2+400, width/2-600, height/2+300);
  line(width/2-600, height/2+300, width/2+100, height/2+200);
  line(width/2+100, height/2+200, width/2-600, height/2+100);
  line(width/2-600, height/2+100, width/2+100, height/2);
  line(width/2+100, height/2, width/2-600, height/2-100);
  line(width/2-600, height/2-100, width/2+100, height/2-200);
  line(width/2+100, height/2-200, width/2-600, height/2-300);
  line(width/2-600, height/2-300, width/2+100, height/2-400);
 
  textSize(30);
  fill(#FF7D03);
  text("START", width/2+100, height/2-460);
  text("FINISH", width/2+100, height/2+460);
  noStroke();
  circle(width/2+100, height/2-400, 50);
  circle(width/2+100, height/2+400, 50);
}
