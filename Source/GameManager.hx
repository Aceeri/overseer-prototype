package;

class GameManager {

  public static var zombies: Array<objs.Zombie>;
  public static var unit_select: objs.UnitSelector;

  public static function start() {
    unit_select = new objs.UnitSelector();
    zombies = [];
  }

  public static function update() {
    unit_select.update();
    for ( z in zombies )
      z.update();
  }
}