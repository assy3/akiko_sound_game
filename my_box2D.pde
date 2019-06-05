void setup_box2d()
{
 box2d = new Box2DProcessing(this);
 box2d.createWorld();
 box2d.setGravity(0, -8);
 // Create ArrayLists
 boxes = new ArrayList<Box>();

 boundaries = new ArrayList<Boundary>();
 //boundaries.add(new Boundary(width/4,height-5,width/2-50,10));
 //boundaries.add(new Boundary(3*width/4,height-5,width/2-50,10));

 boundaries.add(new Boundary(width-bw*0.5, 0, bw, 4*height));
 boundaries.add(new Boundary(bw*0.5, 0, bw, 4*height));
 boundaries.add(new Boundary(bw*0.5 + (width - bw)/3, 0, bw, 4*height));
 boundaries.add(new Boundary(bw*0.5 + 2*(width - bw)/3, 0, bw, 4*height));
}
