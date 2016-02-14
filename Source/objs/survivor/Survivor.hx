package objs.survivor;

import openfl.display.Bitmap;
import haxe.ds.StringMap;

import generation.Resource;
import generation.GridType;

class Survivor extends Humanoid {
  public var inventory: StringMap<Resource>;
  public var skills: StringMap<Float>;
  // scavenging - harvest faster
  // accuracy - shoot more accurately
  // strength - carry more

  //public var gun: Gun;
  //public var melee: Melee;

  public var health: Float = 100.0; // reach 0 die
  public var hunger: Float = 100.0; // reach 0 lose health
  public var sanity: Float = 100.0; // reach less than 10 and goes insane (possibly shoots allies)
  public var fright: Float = 0.0; // reach 20+, lose sanity

  public function new(x_: Float, y_: Float) {
    super(x_, y_);

    image = new Bitmap(Data.image_map.get("survivor"));
    Layers.Add_Child(image, Layers.LayerType.HUMANOID);
    GameManager.survivors.push(this);

    inventory.set("food", new Resource(0, GridType.FOOD));
    inventory.set("ammo", new Resource(0, GridType.AMMO));
    inventory.set("medical", new Resource(0, GridType.MEDICAL));

    skills.set("scavenging", 1.0);
    skills.set("accuracy", 50.0);
    skills.set("strength", 3.0);
    skills.set("medic", 1.0);
    skills.set("speed", 10.0);
    skills.set("melee", 15.0);
  }

  public override function update(delta: Float) {
    super.update(delta);

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

  public function die() {
    Layers.Rem_Child(image, Layers.LayerType.HUMANOID);
    GameManager.survivors.remove(this);
  }

  private function harvest(resource: Resource) {
   // resource.available 
  }
}