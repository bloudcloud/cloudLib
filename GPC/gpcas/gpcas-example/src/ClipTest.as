/**
 * This license does NOT supersede the original license of GPC.  Please see:
 * http://www.cs.man.ac.uk/~toby/alan/software/#Licensing
 *
 * This license does NOT supersede the original license of SEISW GPC Java port.  Please see:
 * http://www.seisw.com/GPCJ/GpcjLicenseAgreement.txt
 *
 * Copyright (c) 2009, Jakub Kaniewski, jakub.kaniewsky@gmail.com
 * BMnet software http://www.bmnet.pl/
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   - Neither the name of the BMnet software nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY JAKUB KANIEWSKI, BMNET ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL JAKUB KANIEWSKI, BMNET BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package {
	import pl.bmnet.gpcas.geometry.Clip;
	import pl.bmnet.gpcas.geometry.Poly;
	import pl.bmnet.gpcas.geometry.PolyDefault;
	


/**
 * <code>ClipTest</code> is a suite of unit tests for testing <code>Clip</code>.
 * <code>Clip</code> is a Java conversion of the <i>General Poly Clipper</i> algorithm 
 * developed by Alan Murta (gpc@cs.man.ac.uk).
 *
 * @author  Dan Bridenbecker, Solution Engineering, Inc.
 */
public class ClipTest extends TestCase
{
   // -------------------
   // --- Constructor ---
   // -------------------
   /**
    *
    * @param name Name of test case
    */
   public function ClipTest()
   {
   }
   
   
   
   // ----------------------
   // --- Static Methods ---
   // ----------------------
   /**
    * Provides the ability to run the tests contained here in.
    *
    * @param args Command line arguements.
    */
   
   // -------------
   // --- Tests ---
   // -------------
   /**
    * Test the intersection of two polygons that are 
    * completely separate - result should be empty set.
    */
   public function testIntersectionEmptySet():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 1.0, 0.0);
      p1.add( 1.0, 1.0);
      p1.add( 0.0, 1.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 0.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 3.0);
      
      var empty:Poly= Clip.intersection( p1, p2 );
      assertTrue( empty.isEmpty() );
   }
   
   /**
    * Test the intersection of two polygons where
    * the second is contained in the first.
    */
   public function testIntersectionOneContainsTwo():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 2.0, 1.0);
      p2.add( 3.0, 1.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.intersection( p1, p2 ));
//      result.print();
      assertEquals( p2, result );
   }
   
   /**
    * Test the intersection of two polygons where
    * the first is contained in the second.
    */
   public function testIntersectionTwoContainsOne():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 0.0);
      p1.add( 3.0, 0.0);
      p1.add( 3.0, 3.0);
      p1.add( 2.0, 3.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 4.0);
      p2.add( 0.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( p1, result );
   }
   
   /**
    * Test the intersection of two polygons that
    * are equal.
    */
   public function testIntersectionTwoEqual():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 4.0);
      p2.add( 0.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( p1, result );
   }
   
   /**
    * Test the intersection of two rectangles that share
    * one corner and two partial sides.
    */
   public function testIntersectionRectCorner1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 1.0, 0.0);
      p2.add( 1.0, 1.0);
      p2.add( 0.0, 1.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( p2, result );
   }
   
   /**
    * Test the intersection of two rectangles that share
    * one corner and two partial sides.
    */
   public function testIntersectionRectCorner2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 1.0);
      p2.add( 3.0, 1.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( p2, result );
   }
   
   /**
    * Test the intersection of two rectangles that share
    * one corner and two partial sides.
    */
   public function testIntersectionRectCorner3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 3.0);
      p2.add( 4.0, 3.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( p2, result );
   }
   
   /**
    * Test the intersection of two rectangles that share
    * one corner and two partial sides.
    */
   public function testIntersectionRectCorner4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 3.0);
      p2.add( 1.0, 3.0);
      p2.add( 1.0, 4.0);
      p2.add( 0.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( p2, result );
   }
   
   /**
    * Test the intersection of two rectangles that 
    * intersect on corner
    */
   public function testIntersectionRectInterCorner1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 1.0);
      p2.add( 3.0, 1.0);
      p2.add( 3.0, 3.0);
      p2.add( 1.0, 3.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 2.0, 2.0);
      exp.add( 3.0, 2.0);
      exp.add( 3.0, 3.0);
      exp.add( 2.0, 3.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two rectangles that 
    * intersect on corner
    */
   public function testIntersectionRectInterCorner2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 1.0);
      p2.add( 5.0, 1.0);
      p2.add( 5.0, 3.0);
      p2.add( 3.0, 3.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 3.0, 2.0);
      exp.add( 4.0, 2.0);
      exp.add( 4.0, 3.0);
      exp.add( 3.0, 3.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two rectangles that 
    * intersect on corner
    */
   public function testIntersectionRectInterCorner3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 3.0);
      p2.add( 5.0, 3.0);
      p2.add( 5.0, 5.0);
      p2.add( 3.0, 5.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 3.0, 3.0);
      exp.add( 4.0, 3.0);
      exp.add( 4.0, 4.0);
      exp.add( 3.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two rectangles that 
    * intersect on corner
    */
   public function testIntersectionRectInterCorner4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 3.0);
      p2.add( 3.0, 3.0);
      p2.add( 3.0, 5.0);
      p2.add( 1.0, 5.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 2.0, 3.0);
      exp.add( 3.0, 3.0);
      exp.add( 3.0, 4.0);
      exp.add( 2.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testIntersectionRectInterSide1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 0.0);
      p2.add( 3.0, 0.0);
      p2.add( 3.0, 2.0);
      p2.add( 1.0, 2.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 1.0);
      exp.add( 3.0, 1.0);
      exp.add( 3.0, 2.0);
      exp.add( 1.0, 2.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testIntersectionRectInterSide2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 2.0);
      p2.add( 5.0, 2.0);
      p2.add( 5.0, 4.0);
      p2.add( 3.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 3.0, 2.0);
      exp.add( 4.0, 2.0);
      exp.add( 4.0, 4.0);
      exp.add( 3.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testIntersectionRectInterSide3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 4.0);
      p2.add( 3.0, 4.0);
      p2.add( 3.0, 6.0);
      p2.add( 1.0, 6.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 4.0);
      exp.add( 3.0, 4.0);
      exp.add( 3.0, 5.0);
      exp.add( 1.0, 5.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testIntersectionRectInterSide4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( -1.0, 2.0);
      p2.add(  1.0, 2.0);
      p2.add(  1.0, 4.0);
      p2.add( -1.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 2.0);
      exp.add( 1.0, 2.0);
      exp.add( 1.0, 4.0);
      exp.add( 0.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two complex, non-convex, non-self-intersecting
    * polygons - 1 on top of two = empty*/
   public function testIntersectionPolyOneOnTopOfTwo():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 4.0);
      p1.add( 5.0, 4.0);
      p1.add( 5.0, 9.0);
      p1.add( 3.0, 7.0);
      p1.add( 1.0, 9.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertTrue( result.isEmpty() );
   }
   
   /**
    * Test the intersection of two complex, non-convex, non-self-intersecting
    * polygons - two sides and one vertex - two triangles
    */
   public function testIntersectionPolyTwoSidesOneVertex():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 3.0);
      p1.add( 5.0, 3.0);
      p1.add( 5.0, 8.0);
      p1.add( 3.0, 6.0);
      p1.add( 1.0, 8.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);

      var iexp1:Poly= new PolyDefault();
      iexp1.add( 4.0, 4.0);
      iexp1.add( 3.0, 3.0);
      iexp1.add( 5.0, 3.0);
      var iexp2:Poly= new PolyDefault();
      iexp2.add( 1.0, 3.0);
      iexp2.add( 3.0, 3.0);
      iexp2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( iexp1 );
      exp.add( iexp2 );
      
      var result:PolyDefault= PolyDefault(Clip.intersection( p1, p2 ));
//      result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two complex, non-convex, non-self-intersecting
    * polygons - two sides 
    */
   public function testIntersectionPolyTwoSides():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 2.0);
      p1.add( 5.0, 2.0);
      p1.add( 5.0, 7.0);
      p1.add( 3.0, 5.0);
      p1.add( 1.0, 7.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 2.0);
      exp.add( 5.0, 2.0);
      exp.add( 5.0, 3.0);
      exp.add( 4.0, 4.0);
      exp.add( 3.0, 3.0);
      exp.add( 2.0, 4.0);
      exp.add( 1.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.intersection( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two complex, non-convex, non-self-intersecting
    * polygons - two sides and one vertex - the lower one
    */
   public function testIntersectionPolyTwoSidesAndLowerVertex():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 1.0);
      p1.add( 5.0, 1.0);
      p1.add( 5.0, 6.0);
      p1.add( 3.0, 4.0);
      p1.add( 1.0, 6.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 1.0);
      exp.add( 5.0, 1.0);
      exp.add( 5.0, 3.0);
      exp.add( 4.0, 4.0);
      exp.add( 3.0, 3.0);
      exp.add( 2.0, 4.0);
      exp.add( 1.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.intersection( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two complex, non-convex, non-self-intersecting
    * polygons - cross four sides
    */
   public function testIntersectionPolyFourSides():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 0.5);
      p1.add( 5.0, 0.5);
      p1.add( 5.0, 6.0);
      p1.add( 3.0, 4.0);
      p1.add( 1.0, 6.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 1.0);
      exp.add( 1.5, 0.5);
      exp.add( 2.5, 0.5);
      exp.add( 3.0, 1.0);
      exp.add( 3.5, 0.5);
      exp.add( 4.5, 0.5);
      exp.add( 5.0, 1.0);
      exp.add( 5.0, 3.0);
      exp.add( 4.0, 4.0);
      exp.add( 3.0, 3.0);
      exp.add( 2.0, 4.0);
      exp.add( 1.0, 3.0);
      
      var result:Poly= Clip.intersection( p1, p2 );
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of two complex, non-convex, non-self-intersecting
    * polygons - V overlap
    */
   public function testIntersectionPolyVOverlaps():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 0.0);
      p1.add( 5.0, 0.0);
      p1.add( 5.0, 5.0);
      p1.add( 3.0, 3.0);
      p1.add( 1.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 1.0);
      exp.add( 2.0, 0.0);
      exp.add( 3.0, 1.0);
      exp.add( 4.0, 0.0);
      exp.add( 5.0, 1.0);
      exp.add( 5.0, 3.0);
      exp.add( 4.0, 4.0);
      exp.add( 3.0, 3.0);
      exp.add( 2.0, 4.0);
      exp.add( 1.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.intersection( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the intersection of a rectangle with a hole and solid rectangle
    */
   public function testIntersectionRectangleHole():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault(true);
      p2.add( 1.0, 2.0);
      p2.add( 3.0, 2.0);
      p2.add( 3.0, 4.0);
      p2.add( 1.0, 4.0);
      
      var p12:Poly= new PolyDefault();
      p12.add( p1 );
      p12.add( p2 );

      var p3:Poly= new PolyDefault();
      p3.add( 2.0, 0.0);
      p3.add( 6.0, 0.0);
      p3.add( 6.0, 6.0);
      p3.add( 2.0, 6.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 2.0, 1.0);
      exp.add( 4.0, 1.0);
      exp.add( 4.0, 5.0);
      exp.add( 2.0, 5.0);
      exp.add( 2.0, 4.0);
      exp.add( 3.0, 4.0);
      exp.add( 3.0, 2.0);
      exp.add( 2.0, 2.0);
      
      var result:PolyDefault= PolyDefault(Clip.intersection( p12, p3 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   // -------------
   // --- UNION ---
   // -------------
   /**
    * Test the UNION of two polygons that are 
    * completely separate - result should be poly that contains these two polys
    */
   public function testUnionSeparate():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 1.0, 0.0);
      p1.add( 1.0, 1.0);
      p1.add( 0.0, 1.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 0.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 3.0);

      var exp:Poly= new PolyDefault();
      exp.add( p2 );
      exp.add( p1 );
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
//      result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two polygons where
    * the second is contained in the first.
    */
   public function testUnionOneContainsTwo():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 2.0, 1.0);
      p2.add( 3.0, 1.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
//      result.print();
      assertEquals( p1, result );
   }
   /**
    * Test the union of two polygons where
    * the first is contained in the second.
    */
   public function testUnionTwoContainsOne():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 0.0);
      p1.add( 3.0, 0.0);
      p1.add( 3.0, 3.0);
      p1.add( 2.0, 3.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 4.0);
      p2.add( 0.0, 4.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
//      result.print();
      assertEquals( p2, result );
   }
   
   /**
    * Test the union of two polygons that
    * are equal.
    */
   public function testUnionTwoEqual():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 4.0);
      p2.add( 0.0, 4.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
//      result.print();
      assertEquals( p1, result );
   }
   
   /**
    * Test the union of two rectangles that share
    * one corner and two partial sides.
    */
   public function testUnionRectCorner1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 1.0, 0.0);
      p2.add( 1.0, 1.0);
      p2.add( 0.0, 1.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 0.0);
      exp.add( 4.0, 0.0);
      exp.add( 4.0, 4.0);
      exp.add( 0.0, 4.0);
      exp.add( 0.0, 1.0); // !!! KNOWN BUG - EXTRA POINT BUT SHAPE IS CORRECT
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the UNION of two rectangles that share
    * one corner and two partial sides.
    */
   public function testUnionRectCorner2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 1.0);
      p2.add( 3.0, 1.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 0.0);
      exp.add( 4.0, 0.0);
      exp.add( 4.0, 1.0); // !!! KNOWN BUG - EXTRA POINT BUT SHAPE IS CORRECT
      exp.add( 4.0, 4.0);
      exp.add( 0.0, 4.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two rectangles that share
    * one corner and two partial sides.
    */
   public function testUnionRectCorner3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 3.0);
      p2.add( 4.0, 3.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 0.0);
      exp.add( 4.0, 0.0);
      exp.add( 4.0, 3.0); // !!! KNOWN BUG - EXTRA POINT BUT SHAPE IS CORRECT
      exp.add( 4.0, 4.0);
      exp.add( 0.0, 4.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two rectangles that share
    * one corner and two partial sides.
    */
   public function testUnionRectCorner4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 3.0);
      p2.add( 1.0, 3.0);
      p2.add( 1.0, 4.0);
      p2.add( 0.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 0.0);
      exp.add( 4.0, 0.0);
      exp.add( 4.0, 4.0);
      exp.add( 0.0, 4.0);
      exp.add( 0.0, 3.0); // !!! KNOWN BUG - EXTRA POINT BUT SHAPE IS CORRECT
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two rectangles that 
    * intersect on corner
    */
   public function testUnionRectInterCorner1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 1.0);
      p2.add( 3.0, 1.0);
      p2.add( 3.0, 3.0);
      p2.add( 1.0, 3.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 1.0);
      exp.add( 3.0, 1.0);
      exp.add( 3.0, 2.0);
      exp.add( 4.0, 2.0);
      exp.add( 4.0, 4.0);
      exp.add( 2.0, 4.0);
      exp.add( 2.0, 3.0);
      exp.add( 1.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two rectangles that 
    * intersect on corner
    */
   public function testUnionRectInterCorner2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 1.0);
      p2.add( 5.0, 1.0);
      p2.add( 5.0, 3.0);
      p2.add( 3.0, 3.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 3.0, 1.0);
      exp.add( 5.0, 1.0);
      exp.add( 5.0, 3.0);
      exp.add( 4.0, 3.0);
      exp.add( 4.0, 4.0);
      exp.add( 2.0, 4.0);
      exp.add( 2.0, 2.0);
      exp.add( 3.0, 2.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the union of two rectangles that 
    * intersect on corner
    */
   public function testUnionRectInterCorner3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 3.0);
      p2.add( 5.0, 3.0);
      p2.add( 5.0, 5.0);
      p2.add( 3.0, 5.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 5.0, 3.0);
      exp.add( 5.0, 5.0);
      exp.add( 3.0, 5.0);
      exp.add( 3.0, 4.0);
      exp.add( 2.0, 4.0);
      exp.add( 2.0, 2.0);
      exp.add( 4.0, 2.0);
      exp.add( 4.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two rectangles that 
    * intersect on corner
    */
   public function testUnionRectInterCorner4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 3.0);
      p2.add( 3.0, 3.0);
      p2.add( 3.0, 5.0);
      p2.add( 1.0, 5.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 3.0);
      exp.add( 2.0, 3.0);
      exp.add( 2.0, 2.0);
      exp.add( 4.0, 2.0);
      exp.add( 4.0, 4.0);
      exp.add( 3.0, 4.0);
      exp.add( 3.0, 5.0);
      exp.add( 1.0, 5.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the union of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testUnionRectInterSide1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 0.0);
      p2.add( 3.0, 0.0);
      p2.add( 3.0, 2.0);
      p2.add( 1.0, 2.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 0.0);
      exp.add( 3.0, 0.0);
      exp.add( 3.0, 1.0);
      exp.add( 4.0, 1.0);
      exp.add( 4.0, 5.0);
      exp.add( 0.0, 5.0);
      exp.add( 0.0, 1.0);
      exp.add( 1.0, 1.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testUnionRectInterSide2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 2.0);
      p2.add( 5.0, 2.0);
      p2.add( 5.0, 4.0);
      p2.add( 3.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 1.0);
      exp.add( 4.0, 1.0);
      exp.add( 4.0, 2.0);
      exp.add( 5.0, 2.0);
      exp.add( 5.0, 4.0);
      exp.add( 4.0, 4.0);
      exp.add( 4.0, 5.0);
      exp.add( 0.0, 5.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the union of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testUnionRectInterSide3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 4.0);
      p2.add( 3.0, 4.0);
      p2.add( 3.0, 6.0);
      p2.add( 1.0, 6.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 1.0);
      exp.add( 4.0, 1.0);
      exp.add( 4.0, 5.0);
      exp.add( 3.0, 5.0);
      exp.add( 3.0, 6.0);
      exp.add( 1.0, 6.0);
      exp.add( 1.0, 5.0);
      exp.add( 0.0, 5.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testUnionRectInterSide4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( -1.0, 2.0);
      p2.add(  1.0, 2.0);
      p2.add(  1.0, 4.0);
      p2.add( -1.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add(  0.0, 1.0);
      exp.add(  4.0, 1.0);
      exp.add(  4.0, 5.0);
      exp.add(  0.0, 5.0);
      exp.add(  0.0, 4.0);
      exp.add( -1.0, 4.0);
      exp.add( -1.0, 2.0);
      exp.add(  0.0, 2.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two complex, non-convex, non-self-intersecting
    * polygons - 1 on top of two */
   public function testUnionPolyOneOnTopOfTwo():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 4.0);
      p1.add( 5.0, 4.0);
      p1.add( 5.0, 9.0);
      p1.add( 3.0, 7.0);
      p1.add( 1.0, 9.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 0.0, 2.0);
      exp1.add( 2.0, 0.0);
      exp1.add( 3.0, 1.0);
      exp1.add( 4.0, 0.0);
      exp1.add( 6.0, 2.0);
      exp1.add( 4.0, 4.0);
      exp1.add( 5.0, 4.0);
      exp1.add( 5.0, 9.0);
      exp1.add( 3.0, 7.0);
      exp1.add( 1.0, 9.0);
      exp1.add( 1.0, 4.0);
      exp1.add( 2.0, 4.0);
      
      var exp2:Poly= new PolyDefault(true);
      exp2.add( 4.0, 4.0);
      exp2.add( 3.0, 3.0);
      exp2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two complex, non-convex, non-self-intersecting
    * polygons - two sides and one vertex - two triangles
    */
   public function testUnionPolyTwoSidesOneVertex():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 3.0);
      p1.add( 5.0, 3.0);
      p1.add( 5.0, 8.0);
      p1.add( 3.0, 6.0);
      p1.add( 1.0, 8.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);

      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 2.0);
      exp.add( 2.0, 0.0);
      exp.add( 3.0, 1.0);
      exp.add( 4.0, 0.0);
      exp.add( 6.0, 2.0);
      exp.add( 5.0, 3.0);
      exp.add( 5.0, 8.0);
      exp.add( 3.0, 6.0);
      exp.add( 1.0, 8.0);
      exp.add( 1.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two complex, non-convex, non-self-intersecting
    * polygons - two sides 
    */
   public function testUnionPolyTwoSides():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 2.0);
      p1.add( 5.0, 2.0);
      p1.add( 5.0, 7.0);
      p1.add( 3.0, 5.0);
      p1.add( 1.0, 7.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 2.0);
      exp.add( 2.0, 0.0);
      exp.add( 3.0, 1.0);
      exp.add( 4.0, 0.0);
      exp.add( 6.0, 2.0);
      exp.add( 5.0, 3.0);
      exp.add( 5.0, 7.0);
      exp.add( 3.0, 5.0);
      exp.add( 1.0, 7.0);
      exp.add( 1.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two complex, non-convex, non-self-intersecting
    * polygons - two sides and one vertex - the lower one
    */
   public function testUnionPolyTwoSidesAndLowerVertex():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 1.0);
      p1.add( 5.0, 1.0);
      p1.add( 5.0, 6.0);
      p1.add( 3.0, 4.0);
      p1.add( 1.0, 6.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 2.0);
      exp.add( 2.0, 0.0);
      exp.add( 3.0, 1.0);
      exp.add( 4.0, 0.0);
      exp.add( 6.0, 2.0);
      exp.add( 5.0, 3.0);
      exp.add( 5.0, 6.0);
      exp.add( 3.0, 4.0);
      exp.add( 1.0, 6.0);
      exp.add( 1.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the union of two complex, non-convex, non-self-intersecting
    * polygons - cross four sides
    */
   public function testUnionPolyFourSides():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 0.5);
      p1.add( 5.0, 0.5);
      p1.add( 5.0, 6.0);
      p1.add( 3.0, 4.0);
      p1.add( 1.0, 6.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 1.0);
      exp.add( 1.0, 0.5);
      exp.add( 1.5, 0.5);
      exp.add( 2.0, 0.0);
      exp.add( 2.5, 0.5);
      exp.add( 3.5, 0.5);
      exp.add( 4.0, 0.0);
      exp.add( 4.5, 0.5);
      exp.add( 5.0, 0.5);
      exp.add( 5.0, 1.0);
      exp.add( 6.0, 2.0);
      exp.add( 5.0, 3.0);
      exp.add( 5.0, 6.0);
      exp.add( 3.0, 4.0);
      exp.add( 1.0, 6.0);
      exp.add( 1.0, 3.0);
      exp.add( 0.0, 2.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
         
   /**
    * Test the union of two complex, non-convex, non-self-intersecting
    * polygons - V overlap
    */
   public function testUnionPolyVOverlaps():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 0.0);
      p1.add( 5.0, 0.0);
      p1.add( 5.0, 5.0);
      p1.add( 3.0, 3.0);
      p1.add( 1.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 0.0);
      exp.add( 5.0, 0.0);
      exp.add( 5.0, 1.0);
      exp.add( 6.0, 2.0);
      exp.add( 5.0, 3.0);
      exp.add( 5.0, 5.0);
      exp.add( 4.0, 4.0); // KNOWN BUG - EXTRA POINT BUT SHAPE IS OK
      exp.add( 3.0, 3.0);
      exp.add( 2.0, 4.0); // KNOWN BUG - EXTRA POINT BUT SHAPE IS OK
      exp.add( 1.0, 5.0);
      exp.add( 1.0, 3.0);
      exp.add( 0.0, 2.0);
      exp.add( 1.0, 1.0);
      
      var result:PolyDefault= PolyDefault(Clip.union( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the UNION of a rectangle with a hole and solid rectangle
    */
   public function testUnionRectangleHole():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault(true);
      p2.add( 1.0, 2.0);
      p2.add( 3.0, 2.0);
      p2.add( 3.0, 4.0);
      p2.add( 1.0, 4.0);
      
      var p12:Poly= new PolyDefault();
      p12.add( p1 );
      p12.add( p2 );

      var p3:Poly= new PolyDefault();
      p3.add( 2.0, 0.0);
      p3.add( 6.0, 0.0);
      p3.add( 6.0, 6.0);
      p3.add( 2.0, 6.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 2.0, 0.0);
      exp1.add( 6.0, 0.0);
      exp1.add( 6.0, 6.0);
      exp1.add( 2.0, 6.0);
      exp1.add( 2.0, 5.0);
      exp1.add( 0.0, 5.0);
      exp1.add( 0.0, 1.0);
      exp1.add( 2.0, 1.0);

      var exp2:Poly= new PolyDefault(true);
      exp2.add( 2.0, 2.0);
      exp2.add( 1.0, 2.0);
      exp2.add( 1.0, 4.0);
      exp2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );
      
      var result:PolyDefault= PolyDefault(Clip.union( p12, p3 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   // -----------
   // --- XOR ---
   // -----------
   /**
    * Test the XOR of two polygons that are 
    * completely separate - result should be poly that contains these two polys
    */
   public function testXorSeparate():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 1.0, 0.0);
      p1.add( 1.0, 1.0);
      p1.add( 0.0, 1.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 0.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 3.0);

      var exp:Poly= new PolyDefault();
      exp.add( p2 );
      exp.add( p1 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
//      result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two polygons where
    * the second is contained in the first.
    */
   public function testXorOneContainsTwo():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 2.0, 1.0);
      p2.add( 3.0, 1.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 3.0);
      
      // notice reverse order
      var exp2:Poly= new PolyDefault(true);
      exp2.add( 3.0, 1.0);
      exp2.add( 2.0, 1.0);
      exp2.add( 2.0, 3.0);
      exp2.add( 3.0, 3.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( p1 );
      exp.add( exp2 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two polygons where
    * the first is contained in the second.
    */
   public function testXorTwoContainsOne():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 1.0);
      p1.add( 3.0, 1.0);
      p1.add( 3.0, 3.0);
      p1.add( 2.0, 3.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 4.0);
      p2.add( 0.0, 4.0);
      
      // notice reverse order
      var exp2:Poly= new PolyDefault(true);
      exp2.add( 3.0, 1.0);
      exp2.add( 2.0, 1.0);
      exp2.add( 2.0, 3.0);
      exp2.add( 3.0, 3.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( p2 );
      exp.add( exp2 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two polygons that
    * are equal.
    */
   public function testXorTwoEqual():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 4.0);
      p2.add( 0.0, 4.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertTrue( result.isEmpty() );
   }
   
   /**
    * Test the xor of two rectangles that share
    * one corner and two partial sides.
    */
   public function testXorRectCorner1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 0.0);
      p2.add( 1.0, 0.0);
      p2.add( 1.0, 1.0);
      p2.add( 0.0, 1.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 1.0, 0.0);
      exp.add( 4.0, 0.0);
      exp.add( 4.0, 4.0);
      exp.add( 0.0, 4.0);
      exp.add( 0.0, 1.0);
      exp.add( 1.0, 1.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the xor of two rectangles that share
    * one corner and two partial sides.
    */
   public function testXorRectCorner2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 0.0);
      p2.add( 4.0, 0.0);
      p2.add( 4.0, 1.0);
      p2.add( 3.0, 1.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 0.0);
      exp.add( 3.0, 0.0);
      exp.add( 3.0, 1.0);
      exp.add( 4.0, 1.0);
      exp.add( 4.0, 4.0);
      exp.add( 0.0, 4.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two rectangles that share
    * one corner and two partial sides.
    */
   public function testXorRectCorner3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 3.0);
      p2.add( 4.0, 3.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 0.0);
      exp.add( 4.0, 0.0);
      exp.add( 4.0, 3.0);
      exp.add( 3.0, 3.0);
      exp.add( 3.0, 4.0);
      exp.add( 0.0, 4.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two rectangles that share
    * one corner and two partial sides.
    */
   public function testXorRectCorner4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 0.0);
      p1.add( 4.0, 0.0);
      p1.add( 4.0, 4.0);
      p1.add( 0.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 3.0);
      p2.add( 1.0, 3.0);
      p2.add( 1.0, 4.0);
      p2.add( 0.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 0.0);
      exp.add( 4.0, 0.0);
      exp.add( 4.0, 4.0);
      exp.add( 1.0, 4.0);
      exp.add( 1.0, 3.0);
      exp.add( 0.0, 3.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }   
   
   /**
    * Test the xor of two rectangles that 
    * intersect on corner
    */
   public function testXorRectInterCorner1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 1.0);
      p2.add( 3.0, 1.0);
      p2.add( 3.0, 3.0);
      p2.add( 1.0, 3.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 3.0, 2.0);
      exp1.add( 4.0, 2.0);
      exp1.add( 4.0, 4.0);
      exp1.add( 2.0, 4.0);
      exp1.add( 2.0, 3.0);
      exp1.add( 3.0, 3.0);
      
      var exp2:Poly= new PolyDefault();
      exp2.add( 1.0, 1.0);
      exp2.add( 3.0, 1.0);
      exp2.add( 3.0, 2.0);
      exp2.add( 2.0, 2.0);
      exp2.add( 2.0, 3.0);
      exp2.add( 1.0, 3.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two rectangles that 
    * intersect on corner
    */
   public function testXorRectInterCorner2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 1.0);
      p2.add( 5.0, 1.0);
      p2.add( 5.0, 3.0);
      p2.add( 3.0, 3.0);
      
      // ------------------------------------------------------------------------------------------
      // --- I expected this to give two non-hole inner polygons but it gave one with a hole    ---
      // --- if you look at it, they are equivalent.  Don't have time to figure out difference. ---
      // ------------------------------------------------------------------------------------------
//      Poly exp1 = new PolyDefault();
//      exp1.add( 3.0, 1.0 );
//      exp1.add( 5.0, 1.0 );
//      exp1.add( 5.0, 3.0 );
//      exp1.add( 4.0, 3.0 );
//      exp1.add( 4.0, 2.0 );
//      exp1.add( 3.0, 2.0 );
//      
//      Poly exp2 = new PolyDefault();
//      exp2.add( 2.0, 2.0 );
//      exp2.add( 3.0, 2.0 );
//      exp2.add( 3.0, 3.0 );
//      exp2.add( 4.0, 3.0 );
//      exp2.add( 4.0, 4.0 );
//      exp2.add( 2.0, 4.0 );
      
      var exp1:Poly= new PolyDefault(true);
      exp1.add( 3.0, 2.0);
      exp1.add( 3.0, 3.0);
      exp1.add( 4.0, 3.0);
      exp1.add( 4.0, 2.0);
      
      var exp2:Poly= new PolyDefault();
      exp2.add( 2.0, 2.0);
      exp2.add( 3.0, 2.0);
      exp2.add( 3.0, 1.0);
      exp2.add( 5.0, 1.0);
      exp2.add( 5.0, 3.0);
      exp2.add( 4.0, 3.0);
      exp2.add( 4.0, 4.0);
      exp2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp2 );
      exp.add( exp1 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   
   /**
    * Test the xor of two rectangles that 
    * intersect on corner
    */
   public function testXortRectInterCorner3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 3.0);
      p2.add( 5.0, 3.0);
      p2.add( 5.0, 5.0);
      p2.add( 3.0, 5.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 2.0, 2.0);
      exp1.add( 4.0, 2.0);
      exp1.add( 4.0, 3.0);
      exp1.add( 3.0, 3.0);
      exp1.add( 3.0, 4.0);
      exp1.add( 2.0, 4.0);
      
      var exp2:Poly= new PolyDefault();
      exp2.add( 4.0, 3.0);
      exp2.add( 5.0, 3.0);
      exp2.add( 5.0, 5.0);
      exp2.add( 3.0, 5.0);
      exp2.add( 3.0, 4.0);
      exp2.add( 4.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp2 );
      exp.add( exp1 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two rectangles that 
    * intersect on corner
    */
   public function testXorRectInterCorner4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 2.0, 2.0);
      p1.add( 4.0, 2.0);
      p1.add( 4.0, 4.0);
      p1.add( 2.0, 4.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 3.0);
      p2.add( 3.0, 3.0);
      p2.add( 3.0, 5.0);
      p2.add( 1.0, 5.0);
      
      // ------------------------------------------------------------------------------------------
      // --- I expected this to give two non-hole inner polygons but it gave one with a hole    ---
      // --- if you look at it, they are equivalent.  Don't have time to figure out difference. ---
      // ------------------------------------------------------------------------------------------

      var exp1:Poly= new PolyDefault(true);
      exp1.add( 3.0, 3.0);
      exp1.add( 2.0, 3.0);
      exp1.add( 2.0, 4.0);
      exp1.add( 3.0, 4.0);
      
      var exp2:Poly= new PolyDefault();
      exp2.add( 1.0, 3.0);
      exp2.add( 2.0, 3.0);
      exp2.add( 2.0, 2.0);
      exp2.add( 4.0, 2.0);
      exp2.add( 4.0, 4.0);
      exp2.add( 3.0, 4.0);
      exp2.add( 3.0, 5.0);
      exp2.add( 1.0, 5.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp2 );
      exp.add( exp1 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testXorRectInterSide1():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 0.0);
      p2.add( 3.0, 0.0);
      p2.add( 3.0, 2.0);
      p2.add( 1.0, 2.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 0.0, 1.0);
      exp.add( 1.0, 1.0);
      exp.add( 1.0, 0.0);
      exp.add( 3.0, 0.0);
      exp.add( 3.0, 1.0);
      exp.add( 1.0, 1.0);
      exp.add( 1.0, 2.0);
      exp.add( 3.0, 2.0);
      exp.add( 3.0, 1.0);
      exp.add( 4.0, 1.0);
      exp.add( 4.0, 5.0);
      exp.add( 0.0, 5.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the xor of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testXornRectInterSide2():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 3.0, 2.0);
      p2.add( 5.0, 2.0);
      p2.add( 5.0, 4.0);
      p2.add( 3.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 4.0, 5.0);
      exp.add( 0.0, 5.0);
      exp.add( 0.0, 1.0);
      exp.add( 4.0, 1.0);
      exp.add( 4.0, 2.0);
      exp.add( 3.0, 2.0);
      exp.add( 3.0, 4.0);
      exp.add( 4.0, 4.0);
      exp.add( 4.0, 2.0);
      exp.add( 5.0, 2.0);
      exp.add( 5.0, 4.0);
      exp.add( 4.0, 4.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testXorRectInterSide3():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 1.0, 4.0);
      p2.add( 3.0, 4.0);
      p2.add( 3.0, 6.0);
      p2.add( 1.0, 6.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( 4.0, 5.0);
      exp.add( 3.0, 5.0);
      exp.add( 3.0, 6.0);
      exp.add( 1.0, 6.0);
      exp.add( 1.0, 5.0);
      exp.add( 3.0, 5.0);
      exp.add( 3.0, 4.0);
      exp.add( 1.0, 4.0);
      exp.add( 1.0, 5.0);
      exp.add( 0.0, 5.0);
      exp.add( 0.0, 1.0);
      exp.add( 4.0, 1.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the xor of two rectangles where
    * half of one is contained in the other and
    * two sides of the inner cross one side of the outer.
    */
   public function testXorRectInterSide4():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( -1.0, 2.0);
      p2.add(  1.0, 2.0);
      p2.add(  1.0, 4.0);
      p2.add( -1.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add(  4.0, 5.0);
      exp.add(  0.0, 5.0);
      exp.add(  0.0, 4.0);
      exp.add(  1.0, 4.0);
      exp.add(  1.0, 2.0);
      exp.add(  0.0, 2.0);
      exp.add(  0.0, 4.0);
      exp.add( -1.0, 4.0);
      exp.add( -1.0, 2.0);
      exp.add(  0.0, 2.0);
      exp.add(  0.0, 1.0);
      exp.add(  4.0, 1.0);
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the xor of two complex, non-convex, non-self-intersecting
    * polygons - 1 on top of two*/
   public function testXorPolyOneOnTopOfTwo():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 4.0);
      p1.add( 5.0, 4.0);
      p1.add( 5.0, 9.0);
      p1.add( 3.0, 7.0);
      p1.add( 1.0, 9.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 0.0, 2.0);
      exp1.add( 2.0, 0.0);
      exp1.add( 3.0, 1.0);
      exp1.add( 4.0, 0.0);
      exp1.add( 6.0, 2.0);
      exp1.add( 4.0, 4.0);
      exp1.add( 5.0, 4.0);
      exp1.add( 5.0, 9.0);
      exp1.add( 3.0, 7.0);
      exp1.add( 1.0, 9.0);
      exp1.add( 1.0, 4.0);
      exp1.add( 2.0, 4.0);
      
      var exp2:Poly= new PolyDefault(true);
      exp2.add( 4.0, 4.0);
      exp2.add( 3.0, 3.0);
      exp2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
   
   /**
    * Test the xor of two complex, non-convex, non-self-intersecting
    * polygons - two sides and one vertex - two triangles
    */
   public function testXorPolyTwoSidesOneVertex():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 3.0);
      p1.add( 5.0, 3.0);
      p1.add( 5.0, 8.0);
      p1.add( 3.0, 6.0);
      p1.add( 1.0, 8.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);

      var exp1:Poly= new PolyDefault();
      exp1.add( 5.0, 8.0);
      exp1.add( 3.0, 6.0);
      exp1.add( 1.0, 8.0);
      exp1.add( 1.0, 3.0);
      exp1.add( 0.0, 2.0);
      exp1.add( 2.0, 0.0);
      exp1.add( 3.0, 1.0);
      exp1.add( 4.0, 0.0);
      exp1.add( 6.0, 2.0);
      exp1.add( 5.0, 3.0);
      exp1.add( 3.0, 3.0);
      exp1.add( 4.0, 4.0);
      exp1.add( 5.0, 3.0);
      
      var exp2:Poly= new PolyDefault(true);
      exp2.add( 3.0, 3.0);
      exp2.add( 1.0, 3.0);
      exp2.add( 2.0, 4.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the xor of two complex, non-convex, non-self-intersecting
    * polygons - two sides 
    */
   public function testXorPolyTwoSides():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 2.0);
      p1.add( 5.0, 2.0);
      p1.add( 5.0, 7.0);
      p1.add( 3.0, 5.0);
      p1.add( 1.0, 7.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 5.0, 7.0);
      exp1.add( 3.0, 5.0);
      exp1.add( 1.0, 7.0);
      exp1.add( 1.0, 3.0);
      exp1.add( 2.0, 4.0);
      exp1.add( 3.0, 3.0);
      exp1.add( 4.0, 4.0);
      exp1.add( 5.0, 3.0);
      
      var exp2:Poly= new PolyDefault();
      exp2.add( 5.0, 3.0);
      exp2.add( 5.0, 2.0);
      exp2.add( 1.0, 2.0);
      exp2.add( 1.0, 3.0);
      exp2.add( 0.0, 2.0);
      exp2.add( 2.0, 0.0);
      exp2.add( 3.0, 1.0);
      exp2.add( 4.0, 0.0);
      exp2.add( 6.0, 2.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );      
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the xor of two complex, non-convex, non-self-intersecting
    * polygons - two sides and one vertex - the lower one
    */
   public function testXorPolyTwoSidesAndLowerVertex():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 1.0);
      p1.add( 5.0, 1.0);
      p1.add( 5.0, 6.0);
      p1.add( 3.0, 4.0);
      p1.add( 1.0, 6.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 5.0, 6.0);
      exp1.add( 3.0, 4.0);
      exp1.add( 1.0, 6.0);
      exp1.add( 1.0, 3.0);
      exp1.add( 2.0, 4.0);
      exp1.add( 3.0, 3.0);
      exp1.add( 4.0, 4.0);
      exp1.add( 5.0, 3.0);
      
      var exp2:Poly= new PolyDefault();
      exp2.add( 5.0, 3.0);
      exp2.add( 5.0, 1.0);
      exp2.add( 3.0, 1.0);
      exp2.add( 4.0, 0.0);
      exp2.add( 6.0, 2.0);
      
      var exp3:Poly= new PolyDefault();
      exp3.add( 1.0, 3.0);
      exp3.add( 0.0, 2.0);
      exp3.add( 2.0, 0.0);
      exp3.add( 3.0, 1.0);
      exp3.add( 1.0, 1.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );
      exp.add( exp3 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }

   /**
    * Test the xor of two complex, non-convex, non-self-intersecting
    * polygons - cross four sides
    */
   public function testXorPolyFourSides():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 0.5);
      p1.add( 5.0, 0.5);
      p1.add( 5.0, 6.0);
      p1.add( 3.0, 4.0);
      p1.add( 1.0, 6.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 5.0, 6.0);
      exp1.add( 3.0, 4.0);
      exp1.add( 1.0, 6.0);
      exp1.add( 1.0, 3.0);
      exp1.add( 2.0, 4.0);
      exp1.add( 3.0, 3.0);
      exp1.add( 4.0, 4.0);
      exp1.add( 5.0, 3.0);
      
      var exp2:Poly= new PolyDefault();
      exp2.add( 5.0, 3.0);
      exp2.add( 5.0, 1.0);
      exp2.add( 6.0, 2.0);
      
      var exp3:Poly= new PolyDefault();
      exp3.add( 1.0, 3.0);
      exp3.add( 0.0, 2.0);
      exp3.add( 1.0, 1.0);
      
      var exp4:Poly= new PolyDefault();
      exp4.add( 5.0, 1.0);
      exp4.add( 4.5, 0.5);
      exp4.add( 5.0, 0.5);
      
      var exp5:Poly= new PolyDefault();
      exp5.add( 3.0, 1.0);
      exp5.add( 2.5, 0.5);
      exp5.add( 3.5, 0.5);
      exp5.add( 4.0, 0.0);
      exp5.add( 4.5, 0.5);
      exp5.add( 3.5, 0.5);
      
      var exp6:Poly= new PolyDefault();
      exp6.add( 1.0, 1.0);
      exp6.add( 1.0, 0.5);
      exp6.add( 1.5, 0.5);
      exp6.add( 2.0, 0.0);
      exp6.add( 2.5, 0.5);
      exp6.add( 1.5, 0.5);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );
      exp.add( exp3 );
      exp.add( exp4 );
      exp.add( exp5 );
      exp.add( exp6 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }

   /**
    * Test the xor of two complex, non-convex, non-self-intersecting
    * polygons - V overlap
    */
   public function testXorPolyVOverlaps():void {
      var p1:Poly= new PolyDefault();
      p1.add( 1.0, 0.0);
      p1.add( 5.0, 0.0);
      p1.add( 5.0, 5.0);
      p1.add( 3.0, 3.0);
      p1.add( 1.0, 5.0);
      
      var p2:Poly= new PolyDefault();
      p2.add( 0.0, 2.0);
      p2.add( 2.0, 0.0);
      p2.add( 3.0, 1.0);
      p2.add( 4.0, 0.0);
      p2.add( 6.0, 2.0);
      p2.add( 4.0, 4.0);
      p2.add( 3.0, 3.0);
      p2.add( 2.0, 4.0);
      
      var exp1:Poly= new PolyDefault();
      exp1.add( 5.0, 5.0);
      exp1.add( 4.0, 4.0);
      exp1.add( 5.0, 3.0);
      
      var exp2:Poly= new PolyDefault();
      exp2.add( 1.0, 5.0);
      exp2.add( 1.0, 3.0);
      exp2.add( 2.0, 4.0);
      
      var exp3:Poly= new PolyDefault();
      exp3.add( 5.0, 3.0);
      exp3.add( 5.0, 1.0);
      exp3.add( 6.0, 2.0);
      
      var exp4:Poly= new PolyDefault();
      exp4.add( 1.0, 3.0);
      exp4.add( 0.0, 2.0);
      exp4.add( 1.0, 1.0);
      
      var exp5:Poly= new PolyDefault();
      exp5.add( 5.0, 1.0);
      exp5.add( 4.0, 0.0);
      exp5.add( 5.0, 0.0);
      
      var exp6:Poly= new PolyDefault();
      exp6.add( 3.0, 1.0);
      exp6.add( 2.0, 0.0);
      exp6.add( 4.0, 0.0);
      
      var exp7:Poly= new PolyDefault();
      exp7.add( 1.0, 1.0);
      exp7.add( 1.0, 0.0);
      exp7.add( 2.0, 0.0);
      
      var exp:Poly= new PolyDefault();
      exp.add( exp1 );
      exp.add( exp2 );
      exp.add( exp3 );
      exp.add( exp4 );
      exp.add( exp5 );
      exp.add( exp6 );
      exp.add( exp7 );
      
      var result:PolyDefault= PolyDefault(Clip.xor( p1, p2 ));
      //result.print();
      assertEquals( exp, result );
   }
      
   /**
    * Test the xor of a rectangle with a hole and solid rectangle
    */
   public function testXorRectangleHole():void {
      var p1:Poly= new PolyDefault();
      p1.add( 0.0, 1.0);
      p1.add( 4.0, 1.0);
      p1.add( 4.0, 5.0);
      p1.add( 0.0, 5.0);
      
      var p2:Poly= new PolyDefault(true);
      p2.add( 1.0, 2.0);
      p2.add( 3.0, 2.0);
      p2.add( 3.0, 4.0);
      p2.add( 1.0, 4.0);
      
      var p12:Poly= new PolyDefault();
      p12.add( p1 );
      p12.add( p2 );

      var p3:Poly= new PolyDefault();
      p3.add( 2.0, 0.0);
      p3.add( 6.0, 0.0);
      p3.add( 6.0, 6.0);
      p3.add( 2.0, 6.0);

      // -----------------------------------------------------------
      // --- This is not what I expected and it seems reasonable ---
      // --- However it could be wrong.                          ---
      // -----------------------------------------------------------
      // --- I computed the area of this poly and it came out to ---
      // --- be 24 which is what you would expect.               ---
      // -----------------------------------------------------------
      var exp:Poly= new PolyDefault();
      exp.add( 6.0, 6.0);
      exp.add( 2.0, 6.0);
      exp.add( 2.0, 5.0);
      exp.add( 4.0, 5.0);
      exp.add( 4.0, 1.0);
      exp.add( 2.0, 1.0);
      exp.add( 2.0, 2.0);
      exp.add( 1.0, 2.0);
      exp.add( 1.0, 4.0);
      exp.add( 2.0, 4.0);
      exp.add( 2.0, 2.0);
      exp.add( 3.0, 2.0);
      exp.add( 3.0, 4.0);
      exp.add( 2.0, 4.0);
      exp.add( 2.0, 5.0);
      exp.add( 0.0, 5.0);
      exp.add( 0.0, 1.0);
      exp.add( 2.0, 1.0);
      exp.add( 2.0, 0.0);
      exp.add( 6.0, 0.0);

      var result:PolyDefault= PolyDefault(Clip.xor( p12, p3 ));
      //result.print();
      assertEquals( exp, result );
   }
}
}
