package game.classes;

import hxd.res.DefaultFont;
import h2d.Text;
import game.classes.Tile.TileType;
import hxd.Rand;
import h2d.Object;

class Minefield extends Object {
	private var sizeX:Int;
	private var sizeY:Int;
	private var step:Int;
	private var field:Array<Array<Tile>>;
	private var mineCount:Int;
	private var rng:Rand;
	private var firstClick:Bool;
	private var mines:Array<Tile>;
	private var message:Text;
	private var tiles:Array<Tile>;
	private var alive: Bool;

	public function new(sizeX:Int, sizeY:Int, mineCount:Int) {
		super();
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.mineCount = mineCount;
		this.step = 50;
		this.firstClick = true;
		this.mines = [];
		this.alive = true;
		this.message = new Text(DefaultFont.get());
		this.message.setPosition(10,10);
		rng = new Rand(Date.now().getSeconds());
		Game.instance.window.resize(sizeX * step, sizeY * step);
	}

	override function onAdd() {
		super.onAdd();
		generateField();
		showMinefield();
	}

	public function generateField() {
		var field = [];
		for (y in 0...sizeY) {
			var row = [];
			for (x in 0...sizeX) {
				row.push(new Tile(this, x, y));
			}
			field.push(row);
		}

		this.field = field;
	}

	public function showMinefield() {
		for (y in 0...sizeY) {
			for (x in 0...sizeX) {
				var tile = getTile(x, y);
				tile.setPosition(x * step, y * step);
				addChild(tile);
			}
		}

		addChild(message);
	}

	public function addMines(count:Int) {
		var tiles = [];
		for (row in field) {
			for (tile in row) {
				tiles.push(tile);
			}
		}

		this.tiles = tiles.copy();

		while (count > 0) {
			var n = rng.random(tiles.length);
			var tile = tiles[n];
			if (!tile.revealed) {
				tile.type = TileType.Mine;
				mines.push(tile);
				tiles.remove(tiles[n]);
				count--;
			}
		}
	}

	public function getTile(posX:Int, posY:Int):Tile {
		var tile:Tile;
		try {
			tile = field[posY][posX];
		} catch (err) {
			tile = null;
		}
		return tile;
	}

	public function revealTile(posX:Int, posY:Int) {
		if(!alive){
			return;
		}

		var tile = getTile(posX, posY);

		if(tile.marked){
			return;
		}

		tile.onReveal();

		if (firstClick) {
			addMines(mineCount);
			var danger = getDangerLevel(posX, posY);
			tile.setDanger(danger);
		}
		firstClick = false;

		if(tile.type == TileType.Mine){
			onGameOver();
			return;
		}

		var neighbours = getNeighbours(posX, posY);

		for (tile in neighbours) {
			if (!tile.revealed && getDangerLevel(posX, posY) == 0 && !tile.marked) {
				revealTile(tile.posX, tile.posY);
			}
		}

		checkWinCondition();
	}

	public function getDangerLevel(posX:Int, posY:Int):Int {
		var dangerLevel = 0;

		for (tile in getNeighbours(posX, posY)) {
			if (tile != null && tile.type == TileType.Mine) {
				dangerLevel++;
			}
		}

		return dangerLevel;
	}

	public function getNeighbours(posX:Int, posY:Int):Array<Tile> {
		var neighbours = [];

		for (y in posY - 1...posY + 2) {
			for (x in posX - 1...posX + 2) {
				var tile = getTile(x, y);
				if (tile != null) {
					neighbours.push(tile);
				}
			}
		}

		neighbours.remove(getTile(posX, posY));

		return neighbours;
	}

	public function mark(posX:Int, posY:Int){
		if(!alive){
			return;
		}

		var tile = getTile(posX, posY);
		if(!tile.revealed){
			tile.onMark();
		}
	}

	public function checkWinCondition(){
		var count = tiles.filter(tile -> !tile.revealed).length;
		if(count == mines.length){
			alive = false;
			setMessage("You win! Press R to play again.");
		}
	}

	public function onGameOver(){
		alive = false;
		setMessage("Game over, press R to restart!");
	}

	public function setMessage(message: String){
		this.message.text = message;
	}
}
