package components;

import components.Position;

class Collision {
// private:
  private var width: Int, height: Int, pos_ref: Position;

// public:
  public function new ( w:Int, h:Int, p_ref:Position ) {
    width = w; height = h; pos_ref = p_ref;
  }

  public function collide( coll_ref : Collision ) : Bool {
    var o_pos    = coll_ref.ret_position(),
        o_width  = coll_ref.ret_width(),
        o_height = coll_ref.ret_height();
    return !( pos_ref.x + width /2 < o_pos.x - o_width /2 ||
              pos_ref.x - width /2 > o_pos.x + o_width /2 ||
              pos_ref.y + height/2 < o_pos.y - o_height/2 ||
              pos_ref.y - height/2 > o_pos.y + o_height/2 );
  }

  public function ret_width()    : Int      { return width;   }
  public function ret_height()   : Int      { return height;  }
  public function ret_position() : Position { return pos_ref; }
};