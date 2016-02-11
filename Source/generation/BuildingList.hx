package generation;

import openfl.Assets;
import openfl.Assets.AssetType;
import generation.City.GridType;
import utils.Grid;
import haxe.ds.StringMap;

class BuildingList {
	private var count_map: StringMap<Int>;
	private var size_map: StringMap<Array<String>>;

	public function new() {
		size_map = new StringMap();
		count_map = new StringMap();

		var files = Assets.list(AssetType.TEXT);
		for (index in 0...files.length) {
			var path = files[index];
			var regex = ~/assets\/layouts\/(\d+x\d+)\/.+/;
			regex.match(path);

			if (regex.matched(1) != null) {
				if (size_map.get(regex.matched(1)) == null) {
					size_map.set(regex.matched(1), [ path ]);
				} else {
					size_map.get(regex.matched(1)).push(path);
				}
			}
		}
	}

	public function get_layout(size: String): String {
		var layouts = size_map.get(size);

		if (layouts == null || layouts.length == 0) {
			return "";
		}

		return layouts[Std.random(layouts.length)];
	}
}