package objs.particles;

import openfl.display.Tilesheet;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

class Generator {
  private var data: BitmapData;
  private var tilesheet: Tilesheet;
  public var canvas: Sprite;
  private var next_drop: Float;
  private var per_drop: Int;
  private var particles: Array<Particle>;
  private var max_iterations: Int;

  public function new() {
    particles = [];
    canvas = new Sprite();
    max_iterations = 0;
    next_drop = Math.random() / 50;
    per_drop = 4;
  }

  public function update(delta: Float) {
    //trace("UPDATING PARTICLE GENERATOR: " + particles.length);

    next_drop -= delta;

    // create particles
    if (next_drop <= 0.0) {
      next_drop = Math.random() / 50;

      for (i in 0...per_drop) {
        var offset = GameManager.camera.Ret_Offset();
        var x = Std.int(Std.random(GameManager.camera.screen_x + 200) - offset.x - 100);
        var y = Std.int(Std.random(GameManager.camera.screen_y + 200) - offset.y - 100);
        var particle = new Particle(x, y);
        particle.speed = 0.3;

        particles.push(particle);
      }
    }


    canvas.graphics.clear();
    var tile_data: Array<Float> = [];
    // update particles
    for (particle in particles) {
      if (particle.iteration == max_iterations) {
        particles.remove(particle);
      } else {
        particle.timer += delta;

        if (particle.timer > particle.speed) {
          particle.iteration++;
          particle.timer = 0.0;
        }

        tile_data = tile_data.concat([particle.x, particle.y, particle.iteration]);
      }
    }

    //trace("TILE_DATA: " + tile_data);
    tilesheet.drawTiles(canvas.graphics, tile_data);
  }
}