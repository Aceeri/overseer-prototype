package ui;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.MouseEvent;
import openfl.display.FPS;

class Console extends UserInterface {
  public static var count_lines: Bool = true;
  private var fps: FPS;
  private var memory: Memory;
  private var topbar: UserInterface;
  private var bottombar: UserInterface;

  private var lines: Array<TextField> = [];
  private var text: Array<String> = [];
  private var count: Array<Int> = [];

  private var max_lines = 10;
  private var format: TextFormat;
  private var scroll: Float;
  private var speed: Float;
  private var bounds: Float;
  private var separation: Float;
  private var sidebar: Float;

  public function new() {
    super();

    format = new TextFormat(Fonts.dejavu.fontName, 14);

    background_color = 0x2D2D30;
    background_alpha = 0.9;
    size.x = 500;
    size.y = 600;
    clip = true;

    bottombar = new UserInterface();
    bottombar.size.x = size.x;
    bottombar.size.y = size.y;
    bottombar.background_color = background_color;
    bottombar.background_alpha = 0.9;
    add("bottombar", bottombar);

    scroll = 0.0;
    speed = 7.0;
    bounds = 8.0;
    //separation = 1.5;
    sidebar = 5.0;

    fps = new FPS();
    fps.width = size.x;
    fps.x = sidebar;
    fps.y = 5;
    fps.defaultTextFormat = format;
    fps.textColor = 0xEEEEEE;

    memory = new Memory();
    memory.width = size.x;
    memory.x = sidebar;
    memory.y = 20;
    memory.defaultTextFormat = format;
    memory.textColor = 0xEEEEEE;

    topbar = new UserInterface();
    topbar.size.x = size.x;
    topbar.size.y = 40;
    topbar.background_color = background_color;
    topbar.background_alpha = 1.0;

    topbar.addChild(fps);
    topbar.addChild(memory);
    add("topbar", topbar);

    visible = false;

    addEventListener(MouseEvent.MOUSE_WHEEL, wheel);
  }

  public function log(msg: String, ?color: String):Void {
    var match = false;

    if (color == null) {
      color = "#569ED8";
    }

    if (count_lines && text[0] != null && text[0] == msg) {
      count[0]++;
      lines[0].htmlText = '<font color="#00FFFF">[' + count[0] +
            ']</font><font color="' + color + '">' + text[0] + '</font>';
    } else {
      var new_line = new TextField();
      new_line.antiAliasType = "advanced";
      new_line.width = size.x - sidebar;
      new_line.text = msg;
      new_line.defaultTextFormat = format;
      new_line.multiline = true;
      new_line.wordWrap = true;
      //new_line.embedFonts = true;
      new_line.htmlText = '<font color="' + color + '>' + msg + '</font>';
      bottombar.addChild(new_line);
      lines.insert(0, new_line);
      count.insert(0, 1);
      text.insert(0, msg);

      if (lines.length > max_lines) {
        bottombar.removeChild(lines.pop());
        count.pop();
        text.pop();
      }
    }

    update(0);
  }

  public override function update(delta: Float) {
    super.update(delta);

    var total_y = 0.0;
    for (index in 0...lines.length) {
      total_y += lines[index].textHeight;
      lines[index].y = size.y + scroll - total_y - bounds;
      lines[index].x = sidebar;
      lines[index].height = lines[index].textHeight + format.size;
    }
  }

  private function wheel(event: MouseEvent) {
    if (event.delta > 3) {
      event.delta = 3;
    } else if (event.delta < -3) {
      event.delta = -3;
    }

    scroll += speed * event.delta;

    var total_y = 0.0;
    for (line in lines) {
      total_y += line.textHeight;
    }

    if (scroll < 0.0 || total_y <= size.y - topbar.size.y) {
      scroll = 0.0;
    } else if (scroll > total_y + bounds - size.y + topbar.size.y) {
      scroll = total_y + bounds - size.y + topbar.size.y;
    }
  }
}