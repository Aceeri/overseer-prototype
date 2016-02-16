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

import path.Pathfinder;
import path.Node;

import utils.Grid;

import objs.particles.Rain;
import objs.particles.Generator;

class Main extends Sprite {
  var camera: Camera;
  var console: Console;
  var pathfinder: Pathfinder;
  var prev_time: Int;
  var weather: Generator;

  public function new() {
    super();
    console = new Console();
    console.update(0);
    #if js
      haxe.Log.trace = function(v: Dynamic, ?i):Void {
        var msg = (i != null) ? i.fileName + ":" +
                              i.lineNumber + ": " + v : v;
        console.log(v);
        untyped __js__("console").log(msg);
      }
    #else
      haxe.Log.trace = function(v: Dynamic, ?i):Void {
        var msg = (i != null) ? i.fileName + ":"
                              + i.lineNumber + ": " + v : v;
        console.log(msg);
      }
    #end

    init();
  }

  public function init() {
    camera = new Camera();
    addChild(camera);

    Data.load_data(camera);
    Layers.initialize();
    Input.initialize(camera);

    prev_time = lime.system.System.getTimer();

    var city = new generation.City(10, 10);
    GameManager.city = city;
    city.draw(camera);

    weather = new Rain();
    Layers.Add_Child(weather.canvas, Layers.LayerType.WEATHER);

    stage.addEventListener(KeyboardEvent.KEY_DOWN, key_down);
    stage.addEventListener(KeyboardEvent.KEY_UP, key_up);
    addEventListener(Event.ENTER_FRAME, update);

    Interface.add_interface(console);
    Interface.add_to(this);
    GameManager.start(camera);
  }

  private function key_down(event: KeyboardEvent) {
    if (!Input.keys[event.keyCode]) {
      if (event.keyCode == Keyboard.BACKQUOTE) {
        console.visible = !console.visible;
      }
    }

    Input.keys[event.keyCode] = true;
  }

  private function key_up(event: KeyboardEvent) {
    Input.keys[event.keyCode] = false;
  }

  private function update(event: Event):Void {
    var current_time = lime.system.System.getTimer();
    var delta = (current_time - prev_time) / 1000.0;
    prev_time = current_time;

    Input.mouse_pos.x = Std.int(mouseX - camera.x);
    Input.mouse_pos.y = Std.int(mouseY - camera.y);
    Input.mouse_x     = Std.int(Input.mouse_pos.x);
    Input.mouse_y     = Std.int(Input.mouse_pos.y);
    
    weather.update(delta);
    camera.update(delta);
    console.update(delta);
    GameManager.update(delta);
  }
}