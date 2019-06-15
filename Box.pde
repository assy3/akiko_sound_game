float ts;

class Box {
 Body body;
 // Constructor
 Box(float x, float y) {
 // Add the box to the box2d world
 makeBody(new Vec2(x,y), box_w, box_h);
 }
 void killBody() {
 box2d.destroyBody(body);
 sum += 100; //得点追加
 }
 boolean done() {
 Vec2 pos = box2d.getBodyPixelCoord(body);
 //pos.y is the box current positon
 if (pos.y > height + box_w + box_h) {
 killBody();
 
 return true;
 }
 return false;
 }
 boolean compare() {
 Vec2 pos = box2d.getBodyPixelCoord(body);
 //pos.y is the box current positon
 // abs(pos.x / 2) < box_w &&
 if (abs(pos.y - goal_y) < box_h/2.0 + box_h && 0 < pos.x && pos.x < 180 && keyPressed && key == 'b')
 {
   fill(255);
   ts = 20;
   textSize(ts);
   text("GREAT", pos.x, pos.y - box_h);
   killBody();
   return true;
 }else if(abs(pos.y - goal_y) < box_h/2.0 + box_h && 180 < pos.x && pos.x < 360 && keyPressed && key == 'n')
 {
   fill(255);
   ts = 20;
   textSize(ts);
   text("GREAT", pos.x, pos.y - box_h);
   killBody();
   return true;
 }else if(abs(pos.y - goal_y) < box_h/2.0 + box_h && 360 < pos.x && pos.x < 480 && keyPressed && key == 'm')
 {
   fill(255);
   ts = 20;
   textSize(ts);
   text("GREAT", pos.x, pos.y - box_h);
   killBody();
   return true;
 }
 return false;
 }
 void display() {
 Vec2 pos = box2d.getBodyPixelCoord(body);
 rectMode(CENTER);
 pushMatrix();
 translate(pos.x,pos.y);
 fill(0, 255, 0, 200);
 stroke(0, 255, 0, 128);
 rect(0,0, box_w, box_h);
 popMatrix();
 }
 void display_goal()
 {
 Vec2 pos = box2d.getBodyPixelCoord(body);

 float a = map(goal_y - pos.y, 2.0*box_h, 0, 80, 255);
 bww = box_w;
 bhh = map(goal_y - pos.y, 0.0, 2.0*box_h, 0.0, 2.5*box_h);

 if (goal_y - pos.y >= 0 && goal_y - pos.y < 2.0* box_h)
 {
 rectMode(CENTER);
 pushMatrix();
 translate(pos.x , goal_y - box_h/2);
 fill(255, 255, 0, a);
 noStroke();
 rect(0,0, bww, bhh);
 popMatrix();
 }
 }
 void makeBody(Vec2 center, float w_, float h_) {
 PolygonShape sd = new PolygonShape();
 float box2dW = box2d.scalarPixelsToWorld(w_/2);
 float box2dH = box2d.scalarPixelsToWorld(h_/2);
 sd.setAsBox(box2dW, box2dH);
 // Define a fixture
 FixtureDef fd = new FixtureDef();
 fd.shape = sd;
 fd.density = 4.8;
 fd.friction = 0.5;
 fd.restitution = 0.5;
 // Define the body and make it from the shape
 BodyDef bd = new BodyDef();
 bd.type = BodyType.DYNAMIC;
 bd.position.set(box2d.coordPixelsToWorld(center));
 body = box2d.createBody(bd);
 body.createFixture(fd);
 }
}
void add_box(int type)
{
 Box p = new Box(goal_x[type], start_y);
 boxes.add(p);
}
