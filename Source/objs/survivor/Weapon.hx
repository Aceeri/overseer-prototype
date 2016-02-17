package objs.survivor;

enum Type {
  Pistol;
  Submachine;
  Rifle;
  Shotgun;
  Melee;
  Explosive;
}

class Weapon {
  private var name       : String;
  private var file_name  : String;
	private var rate       : Float; // shots per second
	private var range      : Int;   // 1 range = 1 grid
	private var accuracy   : Float; // in percent
  private var damage     : Int;
  private var clip_ammo  : Int;
  private var reload_time: Float;
  private var noise      : Float;
  private var weight     : Float;
  private var type       : Type;

	public function new(type_:Type, name_:String, rate_:Float, range_:Float,
                      clip_ammo_:Int, accuracy_:Float, damage_:Int,
                      reload_time_:Float, weight_ : Float) {
    rate        = rate_;
    range       = range_;
    accuracy    = accuracy_;
    damage      = damage_;
    weight      = weight_;
    reload_time = reload_time_;
    type        = type_;
    file_name   = "weapons\\" + name + ".png";
    name        = name_;
	}

  inline public static var weapons : Array<Weapon> = [
    // -------------------- default --------------------
    new Weapon(Type.Melee, "Fists",       0.5,  1,  0, 80.0,  1, 0.0, 0.0),
    // -------------------- pistols --------------------
    new Weapon(Type.Pistol, "Five-SeveN", 0.8,  8, 20, 80.0,  3, 2.5, 5.0),
    new Weapon(Type.Pistol, "Glock-18",   2.0,  7, 20, 70.0,  4, 2.3, 4.0),
    new Weapon(Type.Pistol, "P2000",      0.9, 10, 13, 80.0,  3, 2.5, 5.0),
    new Weapon(Type.Pistol, "Revolver",   0.3, 12,  8, 95.0, 15, 7.3, 6.0),
    new Weapon(Type.Pistol, "Deagle",     0.5, 10,  7, 80.0, 10, 2.8, 5.0),
    // -------------------- submachine guns ------------
    new Weapon(Type.Submachine, "P90",    3.3, 10, 50, 65.0, 7, 3.2, 10.0),
    new Weapon(Type.Submachine, "MAC-10", 5.2,  8, 30, 60.0, 6, 2.5, 10.0),
    new Weapon(Type.Submachine, "UMP-45", 2.8, 13, 25, 73.0, 8, 2.5, 10.0),
    new Weapon(Type.Submachine, "MP-7",   3.5, 11, 30, 55.0, 7, 1.8, 10.0)?,
    // -------------------- rifles ---------------------
    new Weapon(Type.Rifle, "Galil AR", ),
    new Weapon(Type.Rifle, "M4A4", ),
    new Weapon(Type.Rifle, "Schmidt Scout", ),
    new Weapon(Type.Rifle, "AWP", ),
    new Weapon(Type.Rifle, "FAMAS", ),
    new Weapon(Type.Rifle, "AK-47", ),
    // -------------------- shotgun --------------------
    new Weapon(Type.Shotgun, "Nova", ),
    new Weapon(Type.Shotgun, "Sawed-Off", ),
    new Weapon(Type.Shotgun, "XM1014", ),
    new Weapon(Type.Shotgun, "Boomstick", ),
    new Weapon(Type.Shotgun, "12 Gauge", ),
    // -------------------- melee --------------------
    new Weapon(Type.Melee, "Bayonet", ),
    new Weapon(Type.Melee, "Butterfly knife", ),
    new Weapon(Type.Melee, "Crowbar", ),
    new Weapon(Type.Melee, "Sledgehammer", ),
    new Weapon(Type.Melee, "Machete", ),
    new Weapon(Type.Melee, "Claymore", ),
    new Weapon(Type.Melee, "Katana", ),
    // -------------------- explosives --------------------
    new Weapon(Type.Explosive, "Molotov", ),
    new Weapon(Type.Explosive, "HE", ),
    new Weapon(Type.Explosive, "Decoy", ),*/
  ];
}