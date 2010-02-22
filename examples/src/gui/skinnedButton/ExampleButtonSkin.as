package gui.skinnedButton
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.skins.AbstractProducer;
	import org.wvxvws.gui.skins.Slices;
	
	/**
	 * ButtonSkin skin.
	 * @author wvxvw
	 */
	public class ExampleButtonSkin extends AbstractProducer
	{
		public static const UP_STATE:String = "upState";
		public static const OVER_STATE:String = "overState";
		public static const DOWN_STATE:String = "downState";
		public static const DISABLED_STATE:String = "disabledState";
		
		[Embed(source='button/up.png')]
		private static var ButtonUpState:Class;

		[Embed(source='button/down.png')]
		private static var ButtonDownState:Class;

		[Embed(source='button/over.png')]
		private static var ButtonOverState:Class;

		[Embed(source='button/disabled.png')]
		private static var ButtonDisabledState:Class;
		
		protected var _states:Vector.<String>;
		protected var _stateClasses:Vector.<Class>;
		protected var _statesHash:Object/*Slices*/ = { };
		protected var _centralSlice:Rectangle = new Rectangle(15, 15, 1, 1);
		
		public function ExampleButtonSkin() 
		{
			super();
			this._states = 
				new <String>[UP_STATE, DOWN_STATE, OVER_STATE, DISABLED_STATE];
			this._stateClasses = 
				new <Class>[ButtonUpState, 
				ButtonDownState, ButtonOverState, ButtonDisabledState];
		}
		
		private function defaultStateFactory(state:int):Slices
		{
			var b:BitmapData = 
				(new (this._stateClasses[state] as Class)() as Bitmap).bitmapData;
			return new Slices(b, this._centralSlice);
		}
		
		public override function produce(inContext:Object, ...args):Object
		{
			var state:String = args ? args[0] : null;
			var index:int = this._states.indexOf(state);
			if (state && this._statesHash[state]) return this._statesHash[state];
			if (index > -1)
			{
				this._statesHash[state] = this.defaultStateFactory(index);
				return this._statesHash[state];
			}
			return null;
		}
	}
}