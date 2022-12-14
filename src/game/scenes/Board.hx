package game.scenes;

import game.classes.Minefield;
import h2d.Scene;

enum Difficulty {
	Easy;
	Medium;
	Hard;
}

class Board extends Scene {
	private var difficulty:Difficulty;

	public function new(difficulty:Difficulty) {
		this.difficulty = difficulty;
		super();
	}

	override function onAdd() {
		super.onAdd();
		switch (difficulty) {
			case Difficulty.Easy:
				addChild(new Minefield(8, 8, 5));

			case Difficulty.Medium:
				addChild(new Minefield(10, 10, 20));

			case Difficulty.Hard:
				addChild(new Minefield(15, 15, 50));

			default:
		}
	}
}
