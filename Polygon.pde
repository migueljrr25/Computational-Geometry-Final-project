

class Polygon {
  
   ArrayList<Point> p     = new ArrayList<Point>();
   ArrayList<Edge>  bdry = new ArrayList<Edge>();
   ArrayList<Triangle>  Tarea = new ArrayList<Triangle>(); 
  
   ArrayList<Point>    guards     = new ArrayList<Point>();
   
   ArrayList<Edge>  vision = new ArrayList<Edge>();
   ArrayList<Edge>  visionFiltered = new ArrayList<Edge>();
   ArrayList<Point> drawguardtriangulation     = new ArrayList<Point>();


   Polygon( ){  }
   
   
   boolean isClosed(){ return p.size()>=3; }
   
   
   //cheking if the poligon is simple 
   boolean isSimple(){
     ArrayList<Edge> bdry = getBoundary();
     int iterator = 0;
     while( iterator < bdry.size())
     {
       int i=0;
       while(i < bdry.size())
       {
         
         if(iterator==i)
           {
           i++;
           continue;
         }
         //if the edge is adjacent ignore, jump until last inst of the loop
          if(adjacentComparison(bdry.get(iterator), bdry.get(i)) == true)
                {
                  i++;
                  continue;
              }
                //using the interception  test to tse ig conection is made
          if(bdry.get(iterator).intersectionTest(bdry.get(i)) == true) 
              {return false;}
         
         i++;
       }    
       iterator++;
     }
     
     return true;
   }
   //helper to find if itge edges are adgecent 
     boolean adjacentComparison(Edge num1, Edge num2)
   {
   PVector v1 , v2 , v3, v4;
//po
   v1 = new PVector(num1.p0.p.x,num1.p0.p.y);
   //p1
   v2 = new PVector(num1.p1.p.x,num1.p1.p.y);
   //p0
   v3 = new PVector(num2.p0.p.x,num2.p0.p.y);
   //p2
   v4 = new PVector(num2.p1.p.x,num2.p1.p.y);
   //cross
   if(  (v1.x ==v3.x && v1.y ==v3.y) ||  (v1.x ==v4.x && v1.y ==v4.y) || (v2.x ==v3.x && v2.y ==v3.y) || (v2.x ==v4.x && v2.y ==v4.y) )  
        { return true;}
   else
       {return false;}
   //return true;
   }
   
   
   
   // detecting if the point is inside to be a helper for diagonals 
   boolean pointInPolygon( Point point ){
     int counter = 0;
     ArrayList<Edge> bdry = getBoundary();
     // creating randon point to compare with actual edges.
       Point RandonPoint = new Point(point.p.x * 1000, point.p.y);
      // edge to test how many times intercepfrom the gicem point to a random point to depermin e if even or odd
      Edge TestEdge = new Edge(point, RandonPoint);
      
      for(int i = 0; i < bdry.size(); i++)
     {
   if(TestEdge.intersectionTest(bdry.get(i)) == true  && (TestEdge.optimizedIntersectionPoint(bdry.get(i)) != bdry.get(i).p0 || TestEdge.optimizedIntersectionPoint(bdry.get(i)) != bdry.get(i).p1))
       {
         counter = counter + 1;
       }
     }
      if(counter%2==1)
      {
       return true;
      }
     
     return false;
   }
   
   
     ArrayList<Edge> getVisionRange()
     {
 
        ArrayList<Edge> ret  = new ArrayList<Edge>();

        for( int i = 0; i < guards.size(); i++) {
       for( int j = 0; j<points.size(); j++)
       {
         vision.add(new Edge(guards.get(i), p.get(j))); 
       }
     }
     
        for(int i = 0; i<vision.size();i++)
   {
       int counter = 0;
             for(int j = 0; j< bdry.size();j++)
               {
             if(vision.get(i).optimizedIntersectionPoint(bdry.get(j)) != null)
                   {
                     counter++;
                     Point p1 = vision.get(i).optimizedIntersectionPoint(bdry.get(j));
                   // delay(500);
                       //p1.draw();
                       //delay(500);
                       println("incrementing counting===" + counter);
                       //vision.get(i).p1.draw();
                       }
                       else{println("nulllllllll\n");
                           }
       
                         }
                 if(counter==2)
                   {
                 ret.add(vision.get(i));
                   }
               }
   
  return ret;
}
   
boolean Artgallery()
{
  boolean flag = false;
  ArrayList<Edge> GuardVision = new ArrayList<Edge>();
  GuardVision = getVisionRange();
  ArrayList<Point> pointArt     = new ArrayList<Point>();
  //pointArt = getpoints();
  
  for( int k = 0 ; k < p.size();k++)
  {
  pointArt.add(p.get(k));
  }
  
  for(int i = 0; i < GuardVision.size() ; i++)
  {
    
    for( int j = 0 ; j< pointArt.size();j++)
    {
    
    if( GuardVision.get(i).p1 == pointArt.get(j))
      {
            pointArt.remove(j);
      }
    }  
  }
 if( pointArt.size() == 0)
  return true;
   
 return false;
}




ArrayList<Triangle> triangulate()
{
 ArrayList<Edge> bdry = getBoundary();
  ArrayList<Edge> diagonals = getDiagonals();
 ArrayList<Triangle>  triangulation = new ArrayList<Triangle>(); 
   
   println("number of points is===========" + p.size() + " \n");
   println("number of diagonals is===========" + diagonals.size() + " \n");
   int numberofear = 0;
   for(int i = 0; i < p.size();i++)
    {
    Edge diagonal = new Edge(p.get(((i -1 % p.size()) + p.size()) % p.size()), p.get((i+1)%p.size()));
    int counter = 0 ;
    int index =0;
        for( int j =0 ; j < bdry.size();j++)
          {
            
               if(diagonal.optimizedIntersectionPoint(bdry.get(j)) != null)
                 {
                     counter++;
                     index++;
                  }
                
          }
          println("counter========" + counter);
        if(counter%2 == 0)
                  {
                     //if(pointInPolygon(diagonal.midpoint())==true)
                     if(checkeartip(i))
                       {
                         numberofear++;
                         println("index==" + i+ "   valid diagonal");
                         //Triangle triangulito = new Triangle(p.get(((i -1 % p.size()) + p.size()) % p.size()), p.get(i), p.get((i+1)%p.size()));
                         //    Tarea.add(triangulito);
                             p.get(i).earStatus = true;
                       }
                       
                       else
                         println("index==" + i+ "   NOOOOOTTTT valid diagonal");
                         println("Ear status =====" +p.get(i).earStatus );
                  }
    }
  println("number of EARRRRRRRRRRR is===========" + numberofear + " \n");
   return triangulation;
}
  

boolean checkeartip(int i)
{
  Edge diagonal = new Edge(p.get(((i -1 % p.size()) + p.size()) % p.size()), p.get((i+1)%p.size()));
  if(pointInPolygon(diagonal.midpoint())==true)
    return true;
   else 
   return false;
}

boolean checkeartip2(int i)
{
  
  Edge diagonal = new Edge(p.get(((i -1 % p.size()) + p.size()) % p.size()), p.get((i+1)%p.size()));
  if(pointInPolygon(diagonal.midpoint())==true)
    return true;
   else 
   return false;
}

ArrayList<Triangle> earbased()
{
 ArrayList<Edge> bdry2 = new ArrayList<Edge>();
  ArrayList<Edge> diagonals2 = getDiagonals();
 ArrayList<Triangle>  triangulation2 = new ArrayList<Triangle>();
 triangulate();
 ArrayList<Point> pStatus     = new ArrayList<Point>();
 ArrayList<Point> pActive     = new ArrayList<Point>();
 
 
   for(int i = 0 ; i < bdry.size(); i ++)
 {
      bdry2.add(bdry.get(i));
 }
 
  for(int i = 0 ; i < p.size(); i ++)
 {
      pActive.add(p.get(i));
 }

 for(int i = 0 ; i < p.size(); i ++)
 {
  if( p.get(i).earStatus== true)
    {
      pStatus.add(p.get(i));
    }
 }
int j = 0;
//while( bdry2.size() > 3)
// {
  
for(int k = 0 ; k < p.size() ;k++)
{
    for(int i = 0 ; i < pActive.size() -2 ;i++)
      {
        if(pStatus.get(0)==pActive.get(i))
                {
                    Triangle triangulito = new Triangle(pActive.get(((i -1 % pActive.size()) + pActive.size()) % pActive.size()), pActive.get(i), pActive.get((i+1)%pActive.size()));
                    Tarea.add(triangulito);
                    delay(200);
                    print("ii - 1 ===" + (((i -1 % pActive.size()) + pActive.size()) % pActive.size()+1) + "  ii==" + (i+1)+ "   ii + 1 ===" + (i +1 % pActive.size()+1));
                    println("\nboundary size==" + bdry2.size());
                    println("boundary size==" + bdry.size());

                    bdry2.get(((i -1 % pActive.size()) + pActive.size()) % pActive.size()).p1 = bdry2.get((i+1)%pActive.size()).p0;
                    //print("ii - 1 ===" + (i - 1 % pActive.size() + pActive.size()) + "  ii==" + i+ "   ii + 1 ===" + (i +1 % pActive.size()));

                    println("\nboundary size before==" + bdry2.size() + "    pStatus==" + pStatus.size() + "   pActive==="   + pActive.size());

                    
                    
                    
                    //Edge diagonalls = new Edge(pActive.get(((i -1 % pActive.size()) + pActive.size()) % pActive.size()), pActive.get((i+1)%pActive.size()));
                    //int counter = 0 ;
                    //int index =0;
                    //  for( int n =0 ; n < bdry2.size();n++)
                    //      {
            
                    //       if(diagonalls.optimizedIntersectionPoint(bdry2.get(n)) != null)
                    //       {
                    //         counter++;
                    //         index++;
                    //        }
                
                    //      }
                    //      println("counter========" + counter);
                    //        if(counter%2 == 0)
                    //            {
                    //             //if(pointInPolygon(diagonal.midpoint())==true)
                    //                   if(checkeartip(i))
                    //                 {
                    //                   pStatus.add(pActive.get(i));
                    //                 }

                    //              }
    
                    
                    bdry2.remove(i); // removing old boundary crop sectiojn
                    pStatus.remove(0); //removing firts item in list 
                    pActive.remove(i);
                  
                   // pStatus.add(pActive.get(0));
                    
                    println("\nboundary size after==" + bdry2.size() + "    pStatus==" + pStatus.size() + "   pActive==="   + pActive.size());
                    println("boundary size after last5tttt==" + bdry.size());
                      //Edge diagonal = new Edge(pActive.get(((i -1 % pActive.size()) + pActive.size()) % pActive.size()), pActive.get((i+1)%pActive.size()));
                      //   if(pointInPolygon(diagonal.midpoint())==true)c
                      //       {
                             
                      //       }
                      
                    //for(int j = 0; j < pActive.size();j++)
                    //        {
                              
                    //        }
                            
                    print("J=" + j+"\n\n\n\n\n\n\n\n\n\n\n");
                    j++;   
                     // break;
                }
    
      
    }
      
      //println("\nstoped here\n");
   }  
   
    // println("\nstoped here\n");
 return triangulation2;
}
    
    
//    ArrayList<Triangle> triangulate()
//{
  
// ArrayList<Edge> bdry = getBoundary();
// ArrayList<Edge> diagonals = getDiagonals();
// ArrayList<Triangle>  triangulation = new ArrayList<Triangle>(); 
   
//   println("number of points is===========" + p.size() + " \n");
//   println("number of diagonals is===========" + diagonals.size() + " \n");

//   int numberofear = 0;
   
//   for(int i = 0; i < p.size();i++)
//    {
//    Edge diagonal = new Edge(p.get(((i -1 % p.size()) + p.size()) % p.size()), p.get((i+1)%p.size()));

//                     if(pointInPolygon(diagonal.midpoint())==true)
//                       {
//                         numberofear++;
//                         println("index==" + i+ "   valid diagonal");
//                         Triangle triangulito = new Triangle(p.get(((i -1 % p.size()) + p.size()) % p.size()), p.get(i), p.get((i+1)%p.size()));
//                         Tarea.add(triangulito);
//                       }
//                       else
//                         println("index==" + i+ "   NOOOOOTTTT valid diagonal");
//    }
//   println("number of EARRRRRRRRRRR is===========" + numberofear + " \n");
//   return triangulation;

//}





   
   // using the get potential diagonal and as long as it is not adjacent we will add to the diagonals
   ArrayList<Edge> getDiagonals(){
     // TODO: Determine which of the potential diagonals are actually diagonals
     
   ArrayList<Edge> bdry = getBoundary();
   
     ArrayList<Edge> diag = getPotentialDiagonals();
     ArrayList<Edge> ret  = new ArrayList<Edge>();

      for(int i=0; i< diag.size(); i++)
     {  
       int counter = 0;
      for(int j = 0;j<bdry.size();j++)
      {
         if(!adjacentComparison(diag.get(i),bdry.get(j)) )
         {
           if(diag.get(i).intersectionTest(bdry.get(j))==true) 
                 counter++;
         }
      }
      if(counter>0)
        continue;
      else if (pointInPolygon(diag.get(i).midpoint())==false)
                 continue;
      else ret.add(diag.get(i));
     }

     return ret;
   }
   
   
   
   boolean ccw(){
     // TODO: Determine if the polygon is oriented in a counterclockwise fashion
     float acumulator = 0;
     float total = 0;
     if( !isClosed() ) return false;
     if( !isSimple() ) return false;
     int i = 0;
     ArrayList<Edge> bdry = getBoundary();
     while(i<bdry.size())
     {
       total = (bdry.get(i).p1.p.x - bdry.get(i).p0.p.x) * (bdry.get(i).p1.p.y + bdry.get(i).p0.p.y);
       acumulator = acumulator + total;
       i++;
  }
     if(acumulator < 0)
       return true;
       
     else
       return false;
   }
   
   
   boolean cw(){
     // TODO: Determine if the polygon is oriented in a clockwise fashion
//opposite if 0 special conditio n trigeted

     if( !isClosed() ) return false;
     if( !isSimple() ) return false;

     if(!ccw())
       return true;
       
     else
       return false;
   }
   
   
   //shoelace algorith 
   
   float area(){
     int sizeOfArray= 0 ; 
     float totalArea = 0;
     float areaAdder = 0;
     int upperBount = p.size();
     sizeOfArray  = p.size();
     sizeOfArray--;
     for( int i = 0; i< upperBount;i++)
     {
       PVector v1 , v2;
       v1 = new PVector(p.get(i).x(),p.get(i).y());
       v2 = new PVector(p.get(sizeOfArray).x(),p.get(sizeOfArray).y());
      // reading the values to the total value 
       areaAdder = areaAdder + ((v1.x +v2.x) * (v2.y - v1.y));
       sizeOfArray = i;
     }
     
     totalArea = areaAdder / 2 ;
    if (totalArea < 0)
          {
          totalArea = totalArea * -1;
          }
     
     return totalArea; 
     
   }
      //for(int i = 0; i< bdry.size()-2;i++)
   //{
   //   Tarea.add(p.get(0),p.get(j), p.get(j+1);
   //   print("number of triangles");
   //   j++;
   //}
   
   
   
   
   ArrayList<Edge> getBoundary(){
     return bdry;
   }
   
    ArrayList<Point> getpoints(){
     return p;
   }

    ArrayList<Point> drawguards(){
       int counter = 0;
        for(int i = 0 ; i < p.size(); i ++)
 {
   
  
   if(p.get(i).earStatus==false){
       drawguardtriangulation.add(p.get(i));
        counter++;
      // drawguardtriangulation.get(i).draw();
     }
     

 }
         if(counter == 0)
         {
           drawguardtriangulation.add(p.get((( -1 % p.size()) + p.size()) % p.size()));

         }
     return drawguardtriangulation;
   }

   //ArrayList<Edge> getPotentialDiagonals(){
   //  ArrayList<Edge> ret = new ArrayList<Edge>();
   //  int N = p.size();
   //  for(int i = 0; i < N; i++ ){
   //    int M = (i==0)?(N-1):(N);
   //    for(int j = i+2; j < M; j++ ){
   //      ret.add( new Edge( p.get(i), p.get(j) ) );
   //    }
   //  }
   //  return ret;
   //}
   
      ArrayList<Edge> getPotentialDiagonals(){
     ArrayList<Edge> ret = new ArrayList<Edge>();
     int N = p.size();
     for(int i = 0; i < N; i++ ){
       int M = (i==0)?(N-1):(N);
       for(int j = i+2; j < M; j++ ){
         ret.add( new Edge( points.get(i), p.get(j) ) );
       }
     }
     return ret;
   }
   

   void draw(){
     //println( bdry.size() );
     for( Edge e : bdry ){
       e.draw();
     }
     for( Point g : guards ){
       g.draw();}
     
   
       // for( Point d : drawguardtriangulation ){
       //d.draw();}
     }
   void addPoint( Point _p ){ 
     p.add( _p );
     if( p.size() == 2 ){
       bdry.add( new Edge( p.get(0), p.get(1) ) );
       bdry.add( new Edge( p.get(1), p.get(0) ) );
     }
     if( p.size() > 2 ){
       bdry.set( bdry.size()-1, new Edge( p.get(p.size()-2), p.get(p.size()-1) ) );
       bdry.add( new Edge( p.get(p.size()-1), p.get(0) ) );
     }
   }
   
   void addguard(Point _p){
     guards.add(_p);
     
   }

}
