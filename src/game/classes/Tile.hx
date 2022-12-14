package game.classes;

import h3d.pass.Default;
import hxd.res.DefaultFont;
import h2d.Text;
import hxd.Event;
import hxd.Res;
import h2d.Bitmap;
import hxd.res.Image;
import h2d.Interactive;

enum TileType {
	Safe;
	Mine;
}

class Tile extends Interactive {
	// Vars
	public var type:TileType = TileType.Safe;
	public var minefield:Minefield;
	public var posX:Int;
	public var posY:Int;

	// Flags
	public var marked:Bool = false;
	public var revealed:Bool = false;

	// Components
	private var gfx:Bitmap;
	private var dangerText:Text;

	public function new(minefield:Minefield, posX:Int, posY:Int) {
		super(50, 50);
		this.minefield = minefield;
		gfx = new Bitmap(null, this);
		this.posX = posX;
		this.posY = posY;
		dangerText = new Text(DefaultFont.get(), this);
		dangerText.setPosition(5, 5);
		enableRightButton = true;
	}

	override function onAdd() {
		super.onAdd();
		setImage(Res.tile);
	}

	override function onClick(e:Event) {
		switch (e.button) {
			case 0:
				minefield.revealTile(posX, posY);
			case 1:
				minefield.mark(posX, posY);
			default:
		}
	}

	public function setImage(img:Image) {
		gfx.tile = img.toTile();
	}

	public function onReveal() {
		revealed = true;

		switch (type) {
			case TileType.Safe:
				setImage(Res.tile_safe);
				setDanger(minefield.getDangerLevel(posX, posY));

			case TileType.Mine:
				setImage(Res.tile_mine);

			default:
		}
	}

	public function setDanger(danger:Int) {
		dangerText.text = danger == 0 ? "" : '${danger}';
	}

	public function onMark() {
		marked = !marked;
		if (marked) {
			setImage(Res.tile_marked);
		} else {
			setImage(Res.tile);
		}
	}
}
