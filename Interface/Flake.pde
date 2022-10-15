void flake() {
  background(255);
  strokeWeight(50);
  line(width/2+85, height/2+250+100, width/2-385-200, height/2-250-100);
  line(width/2-385-200, height/2+250+100, width/2+85, height/2-250-100);
  line(width/2-150-100, height/2-250-200, width/2-150-100, height/2+250+200);
  line(width/2-385-300, height/2, width/2+185, height/2);
  strokeWeight(5);
  stroke(#FF7D03);
  line(width/2-400-300, height/2+40, width/2-350-250, height/2+40 );
  line(width/2-350-250, height/2+40, width/2-360-250, height/2+40-10 );
  line(width/2-350-250, height/2+40, width/2-360-250, height/2+40+10 );
  line(width/2-400-300, height/2-40, width/2-350-250, height/2-40 );
  line(width/2-400-300, height/2-40, width/2-390-300, height/2-40-10 );
  line(width/2-400-300, height/2-40, width/2-390-300, height/2-40+10 );
  textSize(30);
  fill(#FF7D03);
  text("START", width/2-400-250, height/2+80);
  text("FINISH", width/2-400-250, height/2-90);
  noStroke();
  circle(width/2-385-300, height/2, 50);
}
