package objs;

import objs.Zombie;
import utils.Vector2;
import utils.Util;
import openfl.display.Shape;

class UnitSelector {
  private var units: Array<Zombie>;
  private var mouse_down:Bool;
  private var sel_start :Vector2;
  private var rectangle :Shape;

  public function new() : Void {
    units = new Array<Zombie>();
    rectangle = new Shape();
    Data.main.addChild(rectangle);
  }

  public function update() : Void {
    if ( mouse_down ) {
      // update rectangle highlight
      var wx: Int = Std.int(sel_start.x - Input.mouse_x);
      var wy: Int = Std.int(sel_start.y - Input.mouse_y);

      rectangle.graphics.clear();
      rectangle.graphics.moveTo(Input.mouse_x + wx/2, Input.mouse_y + wy/2);
      rectangle.graphics.beginFill(0x961B10, 100);
      rectangle.graphics.drawRect(0, 0, Math.abs(wx), Math.abs(wy));
      rectangle.graphics.endFill();

      if ( !Input.mouse[Input.Mouse_left] ) {
        // end highlight
        rectangle.graphics.clear();
        // 'harvest' zombies into units
        var dimensions: Vector2 = new Vector2(wx, wy),
            position  : Vector2 = new Vector2(Std.int(Input.mouse_x - wx/2),
                                              Std.int(Input.mouse_y - wy/2));
        while ( units.length != 0 ) units.pop();
        /*for ( i in GameManager.zombies ) {
          if ( Util.AABBCollision(i.ret_position(), i.ret_dimension(),
                                  position, dimensions ) ) {
            units.push(i);
            trace("Zombie Harvested!");
          }
        }*/
      }
    }
    trace(mouse_down);
    mouse_down = Input.mouse[Input.Mouse_left];
  }
}