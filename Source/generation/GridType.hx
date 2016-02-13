package generation;

enum GridType {
  // Special
  NONE;
  BLOCK;
  UNKNOWN;

  // Floor
  FLOOR;
  DUSTY_FLOOR;
  CROSSWALK;
  SIDEWALK;
  ROAD;
  GRASS;

  // Objects
  STONEWALL;
  WALL;
  DOOR;
  LINKED_DOOR;
  FENCE;
  TREE;
  WATER;
  CRATE;
  CRATE_BIG;
  BARREL;

  // Resources
  WEAPON;
  AMMO;
  MEDICAL;
  FOOD;
}