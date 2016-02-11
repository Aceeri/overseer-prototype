package utils;

import utils.Vector2;

class Util {
  public static function AABBCollision(a_pos:Vector2, a_dim:Vector2,
                                       b_pos:Vector2, b_dim:Vector2) {
    return !( a_pos.x + a_dim.x / 2 < b_pos.x - b_dim.x / 2 ||
              a_pos.x - a_dim.x / 2 > b_pos.x + b_dim.x / 2 ||
              a_pos.y + a_dim.y / 2 < b_pos.y - b_dim.y / 2 ||
              a_pos.y - a_dim.y / 2 > b_pos.y + b_dim.y / 2 );
  }

}