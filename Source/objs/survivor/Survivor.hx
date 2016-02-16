package objs.survivor;

import openfl.display.Bitmap;
import haxe.ds.StringMap;
import objs.particles.Bullet;
import haxe.ds.EnumValueMap;
import objs.survivor.Weapon;

import generation.Resource;
import generation.GridType;

class Survivor extends Humanoid {
  // private:
  // public:
  public var inventory: EnumValueMap<GridType, Int>;
  public var skills: StringMap<Float>;
  // scavenging - harvest faster
  // accuracy - shoot more accurately
  // strength - carry more

  //public var gun: Gun;
  //public var melee: Melee;

  public var health: Float = 100.0; // reach 0 die
  public var hunger: Float = 100.0; // reach 0 lose health
  public var sanity: Float = 100.0; // reach less than 10 and goes
                                    // insane (possibly shoots allies)
  public var fright: Float = 0.0; // reach 20+, lose sanity

  private var harvest: Float = 0.0; // timer

  private var weapon : Int = -1;

  public function new(x_: Float, y_: Float) : Void {
    super(x_, y_);

    image = new Bitmap(Data.image_map.get("survivor"));
    Layers.Add_Child(image, Layers.LayerType.HUMANOID);
    GameManager.survivors.push(this);
    attack_cooldown = 0;

    inventory.set(GridType.FOOD, 0);
    inventory.set(GridType.AMMO, 0);
    inventory.set(GridType.MEDICAL, 0);

    skills.set("scavenging", 0.3);
    skills.set("accuracy", 50.0);
    skills.set("strength", 3.0);
    skills.set("medic", 1.0);
    skills.set("speed", 10.0);
    skills.set("melee", 15.0);
  }

  public function destroy() : Void {
    super.destroy();
    Layers.Rem_Child(image, Layers.LayerType.HUMANOID);
    GameManager.survivors.remove(this);
  }

  public override function update(delta: Float) {
    for ( z in GameManager.zombies ) {
      if ( position.distance( z.position ) <= 32*Weapon.weapons[weapon] ) {
        behavior = Behavior.ATTACK( z );
        break;
      }
    }
    super.update(delta);

    if ( frame_attacked_humanoid != null ) {
      frame_attacked_humanoid.add_health(-3);
      frame_attacked_humanoid = null;
      new Bullet(position, humanoid.position);
      zattack_timer = 2.0;
    }

    switch (behavior) {
      case HARVEST(resource):
        var grid_dist = position.scalar(1/32).distance(resource.position);
        if (grid_dist <= 1) { // next to
          harvest += delta;
        } else {
          harvest = 0; // reset if too far
        }

        if (harvest * skills.get("scavenging") >= 1.0) {
          var current = inventory.get(resource.type);
          if (current != null) {
            inventory.set(resource.type, current + 1);
          }
        }
      case FIND(type):
    }


    checks(delta);
  }

  private function checks(delta: Float) {
    if (health <= 0) {
      destroy();
    }

    if (hunger > 0) {
      hunger -= delta / 5.0; // 500 seconds minutes until starving
    } else {
      hunger = 0;
      health -= delta / 3.0; // 300 until dead from starvation
    }

    if (fright > 20.0) {
      sanity -= delta / 5.0;
    }
  }
}