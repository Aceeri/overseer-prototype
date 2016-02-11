package components;

import components.AABBCollision;
import components.Position;
import openfl.Vector;
import utils.CollisionInfo;
import utils.Vector2;

// TODO:
// Build_Transform
// R_Transformed_Vertices
// New
// test that it works
class PolyCollision {
// private:
  private var vertices: Array<Vector2>,
              vertices_transform: Array<Vector2>,
              transformed: Bool;
  private function Build_Transform() : Void {}
// public:
  public function new() {} /* empty poly*/
  public funciton new(verts: Array<Vector2>, off: Vector2) {}

  // -- ret/set --
  public function Set_Vertices(verts:Array<Vector2>, reorder:Bool = 1) {
    vertices = verts;
    if ( reorder ) {
      Order_Vertices(verts);
    }
    Build_Transform();
  }
  public function R_Vertices(): Array<Vector2> { return vertices; }
  public function R_Transformed_Vertices(force:Bool = 0) {s
    if ( transformed || force ) {
      transformed = 0;
      // todo ...
    }
  }

  // -- utility --
  // Returns CollisionInfo based off passed in poly and velocity.
  // Velocity only takes a part in tracking if it will collide,
  // and if it will the translation Vector2.
  CollisionInfo collide(poly: PolyCollision, velocity: Vector2) {
    var min_dist: Float = 10000000000000;
    var trans_vec: Vector2 = Vector2(0, 0);

    var vertsA = R_Transformed_Vertices(),
        vertsB = poly.R_Transformed_Vertices();

    CollisionInfo ci;
    ci.will_collide = true;

    // loop throughl all vertices
    for ( var i : Int = 0; i != vertsA.length() + vertsB.length(); ++ i ) {
      var vA: Bool = (i<vertsA.length());
      // get the axis from the edge
      var axis: Vector2 = Get_Axis((vA?vertsA:vertsB),
                                  (vA?i: i - vertsA.size()));
      // project onto axis
      var minA: Float, minB: Float, maxA: Float, maxB: Float;
      Project_Poly(axis, vertsA, minA, maxA);
      Project_Poly(axis, vertsB, minB, maxB);

      if ( Project_Dist(minA, maxA, minB, maxB) > 0 ) {
        ci.collision = false;
      }

      // get velocity's projection
      var velP: Float = axis.dot_product( velocity );
      if ( velP < 0 ) minA += velP;
      else            maxA += velP;

      float dist = Project_Dist(minA, maxA, minB, maxB);
      if ( dist > 0 ) ci.will_collide = false;

      if ( !ci.will_collide && !ci.collision ) break;

      // check if minimum translation
      dist = abs(dist);
      if ( dist < min_dist ) {
        min_dist = dist;
        trans_vec = axis;
        ci.projection = axis;
        var d: utils.Vector2 = Vector2(polyA.x - polyB.x, polyA.y - polyB.y);
        if ( d.dot_product( trans_vec ) < 0 )
            trans_vec *= -1;
      }
    }

    // -- collision occured, (hoor|na)ay --
    if ( ci.will_collide )
      ci.translation = trans_vec * min_dist;
    return ci;
  }
  CollisionInfo Collide(aabb: AABBCollision, velocity: Vector2) {
    // todo ...
  }

// private utility:
  private function Ret_Axis(verts:Array<Vector2>, i:Int) {
    var vec1: Vector2 = verts[i],
        vec2: Vector2 = verts[(i+1)%verts.length()];

    var axis: Vector2 = Vector2( -(vec2.y - vec1.y), vec2.x - vec1.x );
    axis.Normalize();
    return axis;
  }
  private function Project_Poly(axis:Vector2, poly:Array<Vector2>,
                                min:Float, max:Float) {
    min = axis.dot_product(
  }
  private function Project_Dist(minA:Float, maxA:Float,
                                minB:Float, maxB:Float) {
    if ( minA < minB ) return minB - maxA;
    return minA - maxB;
  }
  // orders vertices according to centroid algorithm, will
  // place ordered vertices back into verts
  private function Order_Vertices(verts:Array<Vector2>):Void {
    // get centroid, same time preparing to calculate angle of verts
    var centx: Float = 0, cent: Float = 0;

    typedef Pair<A, B> = {a: A, b: B };
    Array<Float, Vector2> va;
    for ( var i : Int = 0; i != verts.length(); ++ i ) {
      centx += i.x;
      centy += i.y;
      va.push({a: 0, b: i});
    }
    centx /= verts.length();
    centy /= verts.length();

    for ( var i: Int = 0; i != va.length(); ++ i ) {
      i.a = atan2(i.b.y - centy, i.b.x - centx);
    }
    // -- sort ...

    // -- end sort
    // put everything back into vector
    while ( verts.length() != 0 ) verts.pop();
    for ( var i : Int = 0; i != va.length(); ++ i )
      verts.push_back ( i.b );
  }
};