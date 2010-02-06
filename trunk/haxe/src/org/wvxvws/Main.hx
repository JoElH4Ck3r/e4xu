import flash.display.Sprite;
import flash.Lib;

class Main extends Sprite
{
	/**
		new() is a special function to represent the constructor.
		you must call super() if you exend another class.
		trace() accepts 2 arguments, first is a Dynamic and second (opional)
		is a set of options for haxe.Log.trace().
		see more info here: http://haxe.org/doc/cross/trace
	**/
	public function new()
	{
		super();
		trace("Hello World!");
	}
	
	/**
		This is the program entry point.
		Lib.curent is an instance of flash.Boot class
		which is simultaneously the root display object
		of the SWF.
		NOTE: return type is optional.
		NOTE: public access is default (so public keyword is optional too)
	**/
	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}
}