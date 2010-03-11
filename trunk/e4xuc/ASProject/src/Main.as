package  {
	import flash.display.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.events.Event;
	public class Main extends Sprite 
	{
		public var test : String;
		
		public function Main()
		{
			init();
		}
		
		/**@Generated*/
		protected function init(): void
		{
			addEventListener("mouseDown", someHandler, false, 0, true);
			addEventListener("mouseUp", mouseUp_SpriteHandler);
		}
		/**@Generated*/
		protected function mouseUp_SpriteHandler(event: Event): void
		{
			trace('yo'); trace('works!');;
		}
		/**@Generated*/
		protected var someVar1 : Array=[];
		/**@Generated*/
		protected var myVar : Array=[1];
		/**@Generated*/
		protected var object0 : Object={e: 'someVar', q: 1, w: 2, es: 3};
		/**@Generated*/
		protected var textField0 : TextField=new TextField();
		/**@Generated*/
		protected var rectangle0 : Rectangle=new Rectangle(10, 10, 100, 100);
		/**@Generated*/
		protected var movieClip0 : MovieClip=new MovieClip();
		/**@Generated*/
		protected var sprite0 : Sprite=new Sprite();
		/**@Generated*/
		protected var sprite1 : Sprite=new Sprite();
	}
}