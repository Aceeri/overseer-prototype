package utils;

class Grid<T> {
    public var width(default, null): Int;
    public var height(default, null): Int;

    private var content: Array<T>;

    public function new(width: Int, height: Int, fillValue: T = null) {
        this.width = width;
        this.height = height;
        clear(fillValue);
    }

    public inline function get(x: Int, y: Int): T {
        return content[y * width + x];
    }

    public inline function set(x: Int, y: Int, value: T) {
        content[y * width + x] = value;
    }

    public inline function in_range(x: Int, y: Int):Bool {
        return x >= 0 && x < width && y >= 0 && y < height;
    }

    public function clear(fillValue: T = null) {
        content = [for (i in 0...width * height) fillValue];
    }

    public function fill(x1: Int, y1: Int, x2: Int, y2: Int, value: T) {
    	for (x in x1...x2) {
    		for (y in y1...y2) {
    			set(x, y, value);
    		}
    	}
    }
}