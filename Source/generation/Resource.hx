package generation;

class Resource {
  private var available: Int;
  private var type: GridType;

  public function new(amount_: Int, type_: GridType) {
    available = amount;
    type = type_;
  }

  // for survivor implementation
  /*public function harvest(target: Survivor) {
    available -= survivor.skills.scavenging;
    survivor.inventory[type] += survivor.skills.scavenging;
  }*/
}