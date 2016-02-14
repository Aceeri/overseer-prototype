package objs;

enum Behavior {
	STAY;
	MOVE(x: Int, y: Int);
	MOVING;
	ATTACK(target: Humanoid);
}