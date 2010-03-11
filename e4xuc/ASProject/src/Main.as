package  {
	import flash.display.*;
	import flash.text.*;
	import flash.geom.*;
	public class Main extends Sprite 
	{
		public function Main()
		{
			super();
			addEventListener(someHandler, false, 0, true);
			addEventListener(mouseUp_SpriteHandler);
		}
		protected function mouseUp_SpriteHandler(): void
		{
trace('yo'); trace('works');
		}
		protected var someVar1 : Array=[];
		protected var myVar : Array=[1];
		protected var object0 : Object={e: 'someVar', q: 1, w: 2, es: 3};
		protected var textField0 : TextField=new TextField();
		protected var rectangle0 : Rectangle=new Rectangle(10, 10, 100, 100);
		protected var movieClip0 : MovieClip=new MovieClip();
		protected var sprite0 : Sprite=new Sprite();
		protected var sprite1 : Sprite=new Sprite();
	}
}