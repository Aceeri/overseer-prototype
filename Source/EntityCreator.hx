package EntityCreator {
  import ash.core.Entity;
  class EntityCreator {
    private var engine_ref: Engine;

    public function EntityCreator(_engine: Engine) {
      engine_ref = _engine;
    }

    // Replace with something we will use
    /*public function create_player(): Entity {
      var player : Entity = new Entity(Entities.PLAYER);
      engine.addEntity(player);
      return player;
    }

    public function create_mob(): Entity {
      var mobDef: MobDefinition = mobDefs.ret_choice();
      var mob: Entity = new Entity();
      mob.add(new Array(
        new Renderable(...),
        new Position(),
        new Actor,
        new Statistics(mobDef.health, mobDef.strength));
      mob.add(new Inventory(mob_def.inventory));
      switch ( mobDefs.AI_Type ) {
        case Mob::Type::Zombie:
          mob.add(new ZombieAI());
        break;
        case Mob::Type::Human:
          mob.add(new HumanAI());
        break;
      }
      engine.addEntity(mob);
      return mob;
    }

    // -- private typedefs
    private typedef MobDefinition = {
      var amount: Int;
      var power: Int;
      var defense: Int;
    }*/
  };
};
