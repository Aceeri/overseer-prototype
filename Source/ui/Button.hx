package ui;

import ash.core.Entity;
import openfl.events.MouseEvent;
import openfl.display.Shape;
import ui.UserInterface;
import openfl.Vector;

enum ButtonState {
  Unhighlight;
  Highlight;
  Clicked;
}

class Button extends UserInterface {
  // private:
  private var state: ButtonState;
  private static var colour: Vector<Int>;
  private static var shapes: Vector<Shape>;
  private function activate_button() : Void {}

  // public:
  public function new() {
    // -- static init --
    if ( colour == null ) {
      colour = [0x5A607A, 0x506030, 0x500000];
      addEventListener(MouseEvent.CLICK, update_button);
      addEventListener(MouseEvent.MOUSE_OUT, update_button);
      addEventListener(MouseEvent.MOUSE_OVER, update_button);
    }
    // -- constructor --
    set_state(ButtonState.Unhighlight);
    super();
  }

  public function set_state(s:ButtonState) : Void {
    state = s;

    graphics.clear();
    graphics.beginFill( colour[s.getIndex()] );
    graphics.drawRect(0, 0, width, height);
    graphics.endFill();
  }

  public function ret_state() : ButtonState { return state; }

  public override function update(delta: Float) {
    super.update(delta);
    /*var pressed_t = Input.mouse[Input.MouseButtons.left];
    var mx: Int = Input.mouseX,
        my: Int = Input.mouseY;
    var in_range:Bool = mx > x && mx < (x + width) &&
                        my > y && my < (y + width);
    if ( !pressed && pressed_t && in_range ) // start click on button
      pressed = true;
    if ( pressed && !pressed_t && in_range ) // finish click on button
      activate_button();
    if ( !pressed_t ) // no longer clicking on button, note above will fall
      pressed = false; // into this so order of if-statements matter.*/
  }

  public function update_button(event:MouseEvent) {
    switch ( event.type ) {
      case "click":
        set_state(ButtonState.Clicked);
        activate_button();
      case "mouseOut":  set_state(ButtonState.Unhighlight);
      case "mouseOver": set_state(ButtonState.Highlight  );
    }
  }
}