import format.flv.Data;
import hxd.Key;
import hxd.Event;
import hxd.Res;
import hxd.Window;
import hxd.App;
import game.scenes.Board;

class Game extends App {
    public static var instance:Game;

    public var window: Window;
    public var difficulty: Difficulty;

    override function init() {
        instance = this;
        window = Window.getInstance();
        window.addEventTarget(onEvent);
        difficulty = Difficulty.Medium;
        Res.initLocal();
        setScene(new Board(difficulty));
    }

    public static function main() {
        new Game();
    }

    private function onEvent(e:Event){
        switch(e.kind){
            case EventKind.EKeyUp:
                onKey(e.keyCode);
            default:
        }
    }

    private function onKey(keyCode: Int){
        switch(keyCode){
            case Key.R:
                reload();

            case Key.E:
                difficulty = Difficulty.Easy;
                reload();

            case Key.M:
                difficulty = Difficulty.Medium;
                reload();

            case Key.H:
                difficulty = Difficulty.Hard;
                reload();
            default:
        }
    }

    private function reload(){
        setScene(new Board(difficulty));
    }

}