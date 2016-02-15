package objs.particles;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.geom.Rectangle;

class Rain extends Generator {
  
  public function new() {
    super();
    data = Data.image_map.get("rain");
    tilesheet = new Tilesheet(data);
    max_iterations = 4;

    tilesheet.addTileRect(new Rectangle(0, 0, 16, 16));
    tilesheet.addTileRect(new Rectangle(16, 0, 16, 16));
    tilesheet.addTileRect(new Rectangle(32, 0, 16, 16));
    tilesheet.addTileRect(new Rectangle(48, 0, 16, 16));
    tilesheet.addTileRect(new Rectangle(0, 16, 16, 16));
  }
}