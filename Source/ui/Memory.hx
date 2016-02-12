package ui;

import openfl.text.TextField;
import openfl.events.Event;
import openfl.system.System;

class Memory extends TextField {
  public var mem_peak: Float = 0;

  public function new() {
    super();

    addEventListener(Event.ENTER_FRAME, enter);
  }

  public function enter(event: Event) {
    var mem: Float = Math.round(System.totalMemory / 1024);

    if (mem > mem_peak) {
      mem_peak = mem;
    }

    text = "MEM: " + mem + "kb";
  }
}