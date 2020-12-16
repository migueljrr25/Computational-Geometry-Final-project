

class Point {
  
   public PVector p;
    boolean earStatus = false;
   public Point( float x, float y ){
     p = new PVector(x,y);
     earStatus = false;
     
   }

   public Point(PVector _p0 ){
     p = _p0;
     earStatus = false;
   }
   
   public void draw(){
     ellipse( p.x,p.y, 10,10);
   }
   
   float getX(){ return p.x; }
   float getY(){ return p.y; }
   
   float x(){ return p.x; }
   float y(){ return p.y; }
   
   public float distance( Point o ){
     return PVector.dist( p, o.p );
   }
   
   public String toString(){
     return p.toString();
   }
}
