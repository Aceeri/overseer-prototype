package haxeAStar;

/**
 * 整数坐标。
 *
 * @author statm
 */

class IntPoint {
	public var x:Int;
	public var y:Int;

	public function new(x_:Int = 0, y_:Int = 0) {
		x = x_;
		y = y_;
	}

	public function equals(pt:IntPoint):Bool
	{
		return (x == pt.x && y == pt.y);
	}

	public function toString():String
	{
		return "(" + this.x + "," + this.y + ")";
	}
}