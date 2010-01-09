package org.wvxvws.skins 
{
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.skins.AbstractProducer;
	import org.wvxvws.gui.skins.Drawings;
	import org.wvxvws.gui.skins.SkinDefaults;
	
	/**
	 * ButtonSkin skin.
	 * @author wvxvw
	 */
	public class ButtonSkin extends AbstractProducer
	{
		public static const UP_STATE:String = "upState";
		public static const OVER_STATE:String = "overState";
		public static const DOWN_STATE:String = "downState";
		
		protected var _states:Vector.<String>;
		protected var _stateClasses:Vector.<Class>;
		protected var _stateFactories:Vector.<Function>;
		
		public function ButtonSkin(states:Vector.<String> = null, 
									stateClasses:Vector.<Class> = null, 
									stateFactories:Vector.<Function> = null) 
		{
			super();
			if (!states) 
				this._states = new <String>[UP_STATE, OVER_STATE, DOWN_STATE];
			else this._states = states;
			this._stateClasses = stateClasses;
			if (!stateFactories) 
				this._stateFactories = new <Function>[defaultStateFactory, 
													defaultStateFactory,
													defaultStateFactory];
			else this._stateFactories = stateFactories;
		}
		
		private function defaultStateFactory(inContext:Object, 
										state:String = null):InteractiveObject
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			switch (state)
			{
				case UP_STATE:
				default:
					g.beginFill(SkinDefaults.UP_COLOR);
					break;
				case OVER_STATE:
					g.beginFill(SkinDefaults.OVER_COLOR);
					break;
				case DOWN_STATE:
					g.beginFill(SkinDefaults.DOWN_COLOR);
					break;
			}
			Drawings.roundedRectangle(g, 4, 4, 0, 0, 20, 20, 16);
			s.scale9Grid = new Rectangle(4, 4, 12, 12);
			return s;
		}
		
		public override function produce(inContext:Object, ...args):Object
		{
			var index:int;
			var state:String = args ? args[0] : null;
			if (this._states && this._states.length)
			{
				if (state === null) state = _states[0];
				index = this._states.indexOf(state);
			}
			else index = 0;
			if (index < 0) index = 0;
			if (this._stateClasses && this._stateClasses.length > index && 
				this._stateClasses[index])
				return new this._stateClasses[index]();
			if (this._stateFactories && this._stateFactories.length > index && 
				this._stateFactories[index])
				return this._stateFactories[index](inContext, state);
			return null;
		}
	}

}