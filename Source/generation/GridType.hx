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
  TILE;
  WHITE_TILE;

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
  CHAIR;
  COUNTER;
  STUCCO;
  BED;

  // Resources
  WEAPON;
  AMMO;
  MEDICAL;
  FOOD;
}