package;

import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.Assets;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.*;
import openfl.ui.Keyboard;

import ui.Console;
import ui.Button;

class Main extends Sprite {
  var console: Console;
  var button: Button;
  var fps: FPS;
  var prev_time: Int;

  public function new() {
    super();
    console = new Console();
    console.update(0);

    #if js
      haxe.Log.trace = function(v: Dynamic, ?i):Void {
        var msg = (i != null) ? i.fileName + ":" + i.lineNumber + ": " + v : v;
        console.log(v);
        untyped __js__("console").log(msg);
      }
    #else
      haxe.Log.trace = function(v: Dynamic, ?i):Void {
        var msg = (i != null) ? i.fileName + ":" + i.lineNumber + ": " + v : v;
        console.log(msg);
      }
    #end

    init();
  }

  public function init() {
    Data.Load_Data(this);
    Layers.initialize();
    Input.initialize();

    prev_time = lime.system.System.getTimer();

    var bitmap = new Bitmap(Assets.getBitmapData("assets/openfl.png"));
    bitmap.x = (stage.stageWidth - bitmap.width) / 2;
    bitmap.y = (stage.stageHeight - bitmap.height) / 2;
    addChild(bitmap);

    fps = new FPS();
    addChild(fps);

    var city = new generation.City(2, 2);

    button = new Button();
    button.addEventListener(MouseEvent.CLICK, function(event: MouseEvent) {
      trace("left clicked " + fps);
    });
    Interface.add_interface(button);

    stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
    stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
    addEventListener(Event.ENTER_FRAME, update);

    Interface.add_interface(console);

    Interface.add_to(this);
    GameManager.start();
  }

  private function key_down(event: KeyboardEvent):Void {
    if (!Input.keys[event.keyCode]) {
      if (event.keyCode == Keyboard.BACKQUOTE) {
        console.visible = !console.visible;
      }
    }

    Input.keys[event.keyCode] = true;
    GameManager.zombies.push(new objs.Zombie(300, 200));
  }

  private function key_up(event: KeyboardEvent):Void {
    Input.keys[event.keyCode] = false;
  }

  private function update(event: Event):Void {
    var current_time = lime.system.System.getTimer();
    var delta = (current_time - prev_time) / 1000.0;
    prev_time = current_time;

    Input.mouse_x = Std.int(mouseX);
    Input.mouse_y = Std.int(mouseY);
    console.update(delta);
    button.update(delta);
    GameManager.update();
  }
}