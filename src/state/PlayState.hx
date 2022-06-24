package state;

class PlayState implements State {
  private var scene:h2d.Scene;
  
  private var tile:h2d.Tile;

  public function new(scene:h2d.Scene) {
    this.scene = scene;
  }

  public function init(sm:StateManager):Void {

    var backdrop:h2d.Tile = h2d.Tile.fromColor(50, 300, 300);

    var batch:h2d.SpriteBatch = new h2d.SpriteBatch(backdrop, scene);
    batch.hasRotationScale = true;
    batch.hasUpdate = true;

    this.tile = hxd.Res.Textures.FantasyForest_Texture_01_png.toTile();
    batch.add(new h2d.SpriteBatch.BatchElement(tile));
  }
  
  public function update(dt:Float):Void {
    this.tile.dx += 1.0 * dt;
  }

  public function render(e:h3d.Engine):Void {

  }

  public function input(event:hxd.Event):Void {

  }
}
