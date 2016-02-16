package objs;

import objs.Humanoid;
import generation.Resource;
import generation.GridType;

enum Behavior {
	STAY;
	MOVE(x: Int, y: Int);
	ATTACK(target: Humanoid);
	HARVEST(target: Resource);
	FIND(target: GridType);
}