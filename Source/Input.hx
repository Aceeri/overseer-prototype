package;

import openfl.Vector;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import utils.Vector2;

class Input {
  private static var stage: DisplayObject;
  public static var keys: Vector<Bool>;
  public static var mouse: Vector<Bool>;
  public static var mouse_prev: Vector<Bool>;
  public static inline var Mouse_left  :Int = 0;
  public static inline var Mouse_right :Int = 1;
  public static inline var Mouse_middle:Int = 2;
  public static var mouse_pos: Vector2;
  public static var mouse_x : Int;
  public static var mouse_y : Int;

  public static function initialize(stage_: DisplayObject) {
    stage = stage_;

    Input.keys = new Vector<Bool>(200);
    mouse_pos  = new Vector2(0, 0);
    mouse      = [false, false, false];
    mouse_prev = [false, false, false];

    stage.addEventListener(MouseEvent.MOUSE_DOWN,        mouse_event);
    stage.addEventListener(MouseEvent.MOUSE_UP,          mouse_event);
    stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouse_event);
    stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,   mouse_event);
    stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,  mouse_event);
    stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,    mouse_event);
  }

  // Updates mouse_prev
  public static function update_eof() {
    mouse_prev[0] = mouse[0];
    mouse_prev[1] = mouse[1];
    mouse_prev[2] = mouse[2];
  }

  private static function mouse_event(event: MouseEvent):Void {
    switch ( event.type ) {
      case "mouseDown":       Input.mouse[Input.Mouse_left  ] = true;
      case "mouseUp":         Input.mouse[Input.Mouse_left  ] = false;
      case "middleMouseDown": Input.mouse[Input.Mouse_middle] = true;
      case "middleMouseUp":   Input.mouse[Input.Mouse_middle] = false;
      case "rightMouseDown":  Input.mouse[Input.Mouse_right ] = true;
      case "rightMouseUp":    Input.mouse[Input.Mouse_right ] = false;
    }

    trace(event.type);
  }
}