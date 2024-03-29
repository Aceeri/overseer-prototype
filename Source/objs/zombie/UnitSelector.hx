package objs.zombie;

import objs.zombie.Zombie;
import utils.Vector2;
import utils.Util;
import openfl.display.Shape;

class UnitSelector {
  private var units: Array<Zombie>;
  private var mouse_down:Bool;
  private var sel_start :Vector2;
  private var rectangle :Shape;
  private var highlighted_units:Array<Shape>;
  private var do_not_select: Bool;
  private var tile_highlight :Shape;

  public function new() : Void {
    units = new Array<Zombie>();
    rectangle = new Shape();
    tile_highlight = new Shape();
    tile_highlight.graphics.clear();
    tile_highlight.graphics.beginFill(0xCC66FF);
    tile_highlight.graphics.drawRect(0, 0, Math.abs(32), Math.abs(32));
    tile_highlight.graphics.endFill();
    tile_highlight.visible = false;
    highlighted_units = new Array<Shape>();
    Data.main.addChild(rectangle);
    Layers.Add_Child(tile_highlight, Layers.LayerType.HIGHLIGHT);
  }

  public function update() : Void {
    if ( mouse_down && GameManager.zombie_spawner_menu == null ) {
      // update rectangle highlight
      var sx: Int = Std.int(sel_start.x);
      var sy: Int = Std.int(sel_start.y);
      var mx: Int = Std.int(Input.mouse_pos.x);
      var my: Int = Std.int(Input.mouse_pos.y);

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
        if ( wx < 5 && wy < 5 ) { // issue a command
          var t_pos = new Vector2(Std.int(Input.mouse_pos.x),
                                  Std.int(Input.mouse_pos.y));
          trace("Instructing to move to " + t_pos.to_string());
          for ( z in units ) {
            z.set_target_pos(t_pos);
          }
        } else {
          Harvest_Zombies(wx, wy, mx, my);
        }
      }
    }
    if ( !mouse_down && Input.mouse[Input.Mouse_left] && !do_not_select ) {
      mouse_down = true;
      sel_start = new Vector2(Std.int(Input.mouse_pos.x),
                              Std.int(Input.mouse_pos.y));
    }
    if ( !Input.mouse[Input.Mouse_left] )
      mouse_down = false;
    if ( do_not_select && !Input.mouse[Input.Mouse_left] ) {
      do_not_select = false;
    }

    // move highlights on selected zombies
    for ( z in 0...units.length ) {
      var pos = units[z].ret_position();
      highlighted_units[z].x = pos.x + units[z].ret_dimension().x;
      highlighted_units[z].y = pos.y + units[z].ret_dimension().y;
    }

    // highlight square
    if ( units.length > 0 && GameManager.zombie_spawner_menu == null ) {
      tile_highlight.visible = true;
      tile_highlight.x = Input.mouse_x - Input.mouse_x%32;
      tile_highlight.y = Input.mouse_y - Input.mouse_y%32;
    } else
      tile_highlight.visible = false;
  }

  public function clear_select() : Void {
    rectangle.graphics.clear();
    mouse_down = false;
    do_not_select = true;
  }

  // -- private util --
  private function Clear_Units() : Void {
    while ( units.length != 0 ) {
      units.pop();
      var t = highlighted_units.pop();
      Layers.Rem_Child(t, Layers.LayerType.HIGHLIGHT);
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
    Layers.Add_Child(t, Layers.LayerType.HIGHLIGHT);
  }

  private function Harvest_Zombies(wx:Int, wy:Int, mx:Int, my:Int):Void {
    // 'harvest' zombies into units
    trace("Harvesting zombies");
    var dimensions: Vector2 = new Vector2(wx, wy),
        position  : Vector2 = new Vector2(Std.int(mx), Std.int(my));
    Clear_Units();
    for ( z in GameManager.zombies ) {
      trace("Checking " + z.ret_position().x + ", " + z.ret_position().y +
            ": " + z.ret_dimension().x + "x" + z.ret_dimension().y);
      trace("To       " + position.x + ", " + position.y + ": " +
            dimensions.x + "x" + dimensions.y);
      trace("---");
      if ( Util.AABBCol(z.ret_position(), z.ret_dimension(),
                              position, dimensions ) ) {
        Add_Unit(z);
        trace("Zombie Harvested!");
      }
    }
  }
}