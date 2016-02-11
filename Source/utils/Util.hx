package utils;

import utils.Vector2;

class Util {
  public static function AABBCollision(a_pos:Vector2, a_dim:Vector2,
                                       b_pos:Vector2, b_dim:Vector2) {
    return !( a_pos.x + a_dim.x < b_pos.x           ||
              a_pos.x           > b_pos.x + b_dim.x ||
              a_pos.y + a_dim.y < b_pos.y           ||
              a_pos.y           > b_pos.y + b_dim.y );
  }

}