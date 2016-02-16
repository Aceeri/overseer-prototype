package objs.survivor;

import openfl.display.Bitmap;
import haxe.ds.StringMap;
import objs.particles.Bullet;
import haxe.ds.EnumValueMap;

import generation.Resource;
import generation.GridType;

class Survivor extends Humanoid {
  // private:
    private var attack_cooldown: Float;
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

  public function new(x_: Float, y_: Float) : Void {
    super(x_, y_);

    image = new Bitmap(Data.image_map.get("survivor"));
    Layers.Add_Child(image, Layers.LayerType.HUMANOID);
    GameManager.survivors.push(this);
    attack_cooldown = 0;

    inventory.set(GridType.FOOD, 0);
    inventory.set(GridType.AMMO, 0);
    inventory.set(GridType.MEDICAL, 0);

    skills.set("scavenging", 0.3); // per second
    skills.set("accuracy", 50.0);
    skills.set("strength", 3.0);
    skills.set("medic", 1.0);
    skills.set("speed", 10.0);
    skills.set("melee", 15.0);
  }

  public override function update(delta: Float) {
    super.update(delta);

    if ( attack_cooldown > 0 ) attack_cooldown -= delta;

    for ( z in GameManager.zombies ) {
      if ( position.distance( z.position ) < 32*8 ) {
        trace("DETECTING ZOMBIE TO ATTACK");
        behavior = Behavior.ATTACK( z );
        break;
      }
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

      case ATTACK(humanoid):
        if ( attack_cooldown <= 0 ) {
          // for now just assume bullet.
          // create "bullet" animation
          trace("ATTACKING ZOMBIE AT " + humanoid.position.to_string());
          new Bullet(position, humanoid.position);
          attack_cooldown = 2;
        }
      default:
    }


    checks(delta);
  }

  public function die() {
    Layers.Rem_Child(image, Layers.LayerType.HUMANOID);
    GameManager.survivors.remove(this);
  }

  private function checks(delta: Float) {
    if (health <= 0) {
      die();
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