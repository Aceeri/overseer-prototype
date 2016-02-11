package components;

class AI {
  private var sight_radius: Int;
  private var sight_direction: Vector;
  private var last_known_enemy_position: Vector;

  public function new(_sight_radius:Int) {
    sight_radius = _sight_radius;
    sight_direction = {x: 0, y: 0};
  }

  public inline function set_last_known_enemy_position(x: Int, y: Int) {
    if (last_known_enemy_position == null )
      last_known_enemy_position = {x: x, y: y};
  }

  public inline function clear_last_known_enemy_position(): Void {
    last_known_enemy_position = null;
  }


  public inline function set_sight_direction(x: Int, y: Int) {
    sight_direction = {x: x, y: y};
    Vector2.normalize(sight_direction);
  }
};
