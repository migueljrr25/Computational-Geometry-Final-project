
import java.util.*;

ArrayList<Point>    points     = new ArrayList<Point>();
ArrayList<Point>    guards     = new ArrayList<Point>();
ArrayList<Edge>     edges      = new ArrayList<Edge>();
ArrayList<Triangle> triangles  = new ArrayList<Triangle>();
Polygon             poly       = new Polygon();


boolean saveImage = false;
boolean showPotentialDiagonals = false;
boolean showDiagonals = false;
boolean addguard = false;
boolean triangulate = false;
boolean T1 = false;
void setup(){
  size(800,800,P3D);
  frameRate(30);
}


void draw(){
  background(51);
  
  translate( 0, height, 0);
  scale( 1, -1, 1 );
  
  strokeWeight(3);
  
  fill(0);
  noStroke();
  for( Point p : points ){
    p.draw();
  }
  
  noFill();
  stroke(100);
  for( Edge e : edges ){
    e.draw();
  }
  
  noStroke();
  for( Triangle t : triangles ){
    fill( 100, 100, 100 );
    if( t.ccw() ) fill( 200, 100, 100 );
    if( t.cw()  ) fill( 100, 200, 100 ); 
    t.draw();
  }
  
  stroke( 100, 100, 100 );
  if( poly.ccw() ) stroke( 100, 200, 100 );
  if( poly.cw()  ) stroke( 200, 100, 100 ); 
  poly.draw();
  
   noFill();
  stroke(250);
  for( Triangle t : poly.Tarea ){
    delay(100);
    t.draw();
  }
  
  
  
  if( showPotentialDiagonals ){
    strokeWeight(1);
    stroke(100,100,100);
    fill(0,0,200);
    for( Edge e : poly.getPotentialDiagonals() ){
        e.drawDotted();
    }
  }
  
  if(addguard)
  {
    strokeWeight(4);
    stroke(100,100,200);
    for( Edge v : poly.getVisionRange() ){
        v.draw();
  }
  }
  if(T1)
      {
        strokeWeight(15);
    stroke(200,102,0);
          for( Point gd : poly.drawguards() ){
        gd.draw();
        
      }
      }
  
  
  //  if( showPotentialDiagonals ){
  //  strokeWeight(1);
  //  stroke(100,100,100);
  //  fill(0,0,200);
  //  for( Edge guards : poly.getPotentialDiagonals() ){
  //      e.drawDotted();
  //  }
  //}
  
  if(addguard)
  {
    for( int i =0 ; i < guards.size();i++)
  {
   //guards.get(i).draw(); 
  }
  
  }
  
  if( showDiagonals ){
    strokeWeight(6);
    stroke(204,102,0);
    for( Point p1 : poly.drawguards() ){
        p1.draw();
    }
  }
  
  fill(0);
  stroke(0);
  textSize(18);
  
  textRHC( "Controls", 10, height-20 );
  textRHC( "g: to add guards ", 10, height-40 );
  //textRHC( "d: Show/Hide Diagonals", 10, height-40 );
  textRHC( "t: to acivate triangulation", 10, height-60 );
  textRHC( "c: Clear Polygon", 10, height-80 );
  textRHC( "s: Save Image", 10, height-100 );
  
 textRHC( "Art gallery solved: " + ((poly.Artgallery()||T1)?"True":"False"), 550, 120 );
  textRHC( "Clockwise: " + (poly.cw()?"True":"False"), 550, 80 );
  textRHC( "Counterclockwise: " + (poly.ccw()?"True":"False"), 550, 60 );
  textRHC( "Closed Boundary: " + (poly.isClosed()?"True":"False"), 550, 40 );
  textRHC( "Simple Boundary: " + (poly.isSimple()?"True":"False"), 550, 20 );
  textRHC( "Area: " + poly.area() + " px", 550, 100 );
  
  //poly.Artgallery();
  
  for( int i = 0; i < points.size(); i++ ){
    textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
  }
  
  if( saveImage ) saveFrame( ); 
  saveImage = false;
  

  
}


void keyPressed(){
  if( key == 's' ) saveImage = true;
  if( key == 'c' ){ points.clear();guards.clear(); poly = new Polygon(); poly.drawguardtriangulation.clear(); T1 = false; }
  if( key == 'p' ) showPotentialDiagonals = !showPotentialDiagonals;
  if( key == 'd' ) showDiagonals = !showDiagonals;
  if( key == 'g' ) addguard = !addguard;
  //if( key == 't' ) {poly.triangulate();}
  if( key == 't' ) {
                    T1 = ! T1;
                    poly.earbased(); 
                    textRHC( "Areas were high concentaion on diagonals would need a guardc", 20, height-200 );
                      poly.drawguards();
                      
                      //strokeWeight(15);
                      //  stroke(200,102,0);
                      //for( Point gd : poly.drawguards() ){
                      //          gd.draw();
                      //        }

                          }
}


void textRHC( int s, float x, float y ){
  textRHC( Integer.toString(s), x, y );
}


void textRHC( String s, float x, float y ){
  pushMatrix();
  translate(x,y);
  scale(1,-1,1);
  text( s, 0, 0 );
  popMatrix();
}

Point sel = null;

void mousePressed(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  
 if(!addguard) { 
  float dT = 6;
  for( Point p : points ){
    float d = dist( p.p.x, p.p.y, mouseXRHC, mouseYRHC );
    if( d < dT ){
      dT = d;
      sel = p;
    }
  } 
  
  if( sel == null && !addguard){
    sel = new Point(mouseXRHC,mouseYRHC);
    points.add( sel );
    poly.addPoint( sel );
  }
 }
 
if(addguard)
{
    float dsT = 6;
  for( Point g : guards ){
    float f = dist( g.p.x, g.p.y, mouseXRHC, mouseYRHC );
    if( f < dsT ){
      dsT = f;
      sel = g;
    }
  }
  
   if( sel == null){
    sel = new Point(mouseXRHC,mouseYRHC);
    if(poly.pointInPolygon(sel))
    {
    guards.add( sel );
    poly.addguard( sel );
    }
  }

}
 
}


void mouseDragged(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  if( sel != null ){
    sel.p.x = mouseXRHC;   
    sel.p.y = mouseYRHC;   
  }
}

void mouseReleased(){
  sel = null;
}




  
