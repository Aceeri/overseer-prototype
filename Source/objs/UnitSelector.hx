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
  private var highlighted_units:Array<Shape>;

  public function new() : Void {
    units = new Array<Zombie>();
    rectangle = new Shape();
    highlighted_units = new Array<Shape>();
    Data.main.addChild(rectangle);
  }

  public function update() : Void {
    if ( mouse_down ) {
      // update rectangle highlight
      var sx: Int = Std.int(sel_start.x);
      var sy: Int = Std.int(sel_start.y);
      var mx: Int = Std.int(Input.mouse_x);
      var my: Int = Std.int(Input.mouse_y);

      if ( sx < mx ) {
        sx ^= mx;
        mx ^= sx;
        sx ^= mx;
      }
      if ( sy < my ) {
        sy ^= my;
        my ^= sy;
        sy ^= my;
      }

      var wx: Int = Std.int(sx - mx);
      var wy: Int = Std.int(sy - my);

      rectangle.graphics.clear();
      rectangle.x = mx;
      rectangle.y = my;
      rectangle.graphics.beginFill(0x961B10);
      rectangle.graphics.drawRect(0, 0, Math.abs(wx), Math.abs(wy));
      rectangle.graphics.endFill();

      if ( !Input.mouse[Input.Mouse_left] ) {
        // end highlight
        rectangle.graphics.clear();
        if ( wx < 20 && wy < 20 ) { // issue a command
          var t_pos = new Vector2(Input.mouse_x, Input.mouse_y);
          trace("Instructing to move to " + t_pos.to_string());
          for ( z in units ) {
            z.set_target_pos(t_pos);
          }
        } else {
          Harvest_Zombies(wx, wy, mx, my);
        }
      }
    }
    if ( !mouse_down && Input.mouse[Input.Mouse_left] ) {
      sel_start = new Vector2(Input.mouse_x, Input.mouse_y);
    }
    mouse_down = Input.mouse[Input.Mouse_left];

    // move highlights on selected zombies
    trace(units.length);
    for ( z in 0...units.length ) {
      var pos = units[z].ret_position();
      highlighted_units[z].x = pos.x + units[z].ret_dimension().x;
      highlighted_units[z].y = pos.y + units[z].ret_dimension().y;
    }
  }

  // -- private util --
  private function Clear_Units() : Void {
    while ( units.length != 0 ) {
      units.pop();
      var t = highlighted_units.pop();
      Layers.Rem_Child(t, Layers.Highlight);
    }
  }

  private function Add_Unit(z:Zombie) : Void {
    units.push(z);
    var t: Shape = new Shape();
    t.graphics.clear();
    t.graphics.beginFill(0x961B10, 0.2);
    t.x = 40;
    t.y = 40;
    t.graphics.drawCircle(0, 0, 64);
    t.graphics.endFill();
    highlighted_units.push(t);
    Layers.Add_Child(t, Layers.Highlight);
  }

  private function Harvest_Zombies(wx:Int, wy:Int, mx:Int, my:Int):Void {
    // 'harvest' zombies into units
    var dimensions: Vector2 = new Vector2(wx, wy),
        position  : Vector2 = new Vector2(Std.int(mx), Std.int(my));
    Clear_Units();
    for ( z in GameManager.zombies ) {
      trace("Checking " + z.ret_position().x + ", " + z.ret_position().y +
            ": " + z.ret_dimension().x + "x" + z.ret_dimension().y);
      trace("To       " + position.x + ", " + position.y + ": " +
            dimensions.x + "x" + dimensions.y);
      trace("---");
      if ( Util.AABBCollision(z.ret_position(), z.ret_dimension(),
                              position, dimensions ) ) {
        Add_Unit(z);
        trace("Zombie Harvested!");
      }
    }
  }
}