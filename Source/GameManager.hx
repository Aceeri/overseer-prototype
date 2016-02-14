package;

import objs.zombie.Zombie;
import objs.zombie.ZombieNodeSpawner;
import objs.zombie.ZombieNodeSpawnerMenu;
import objs.zombie.UnitSelector;
import generation.City;

class GameManager {
  public static var camera: Camera;
  public static var zombies: Array<Zombie>;
  public static var zombie_spawners: Array<ZombieNodeSpawner>;
  public static var unit_select: UnitSelector;
  public static var zombie_spawner_menu: ZombieNodeSpawnerMenu;
  public static var dt: Float;
  public static var city: City;

  public static function start(camera_: Camera) {
    camera = camera_;
    unit_select = new UnitSelector();
    zombies = [];
    zombie_spawner_menu = null;
    ZombieNodeSpawnerMenu.initialize();
    zombie_spawners = [new ZombieNodeSpawner(300, 300)];
  }

  public static function update(dt_:Float) {
    // pre-update
    dt = dt_;
    // -- update --
    unit_select.update();
    for ( z in zombies )
      z.update();
    for ( z in zombie_spawners ) {
      z.update();
    }
    if ( zombie_spawner_menu != null )
      zombie_spawner_menu.update();
    // post-update
    Input.update_eof();
  }
}