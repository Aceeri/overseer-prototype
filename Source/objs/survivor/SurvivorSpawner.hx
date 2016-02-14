package objs.survivor;

import openfl.geom.Point;

class SurvivorSpawner {
	public var position: Point;
	
	public function new() {
		position = new Point(0.0, 0.0);
	}

	public function spawn() {
		var survivor = new Survivor(position.x, position.y);
	}
}