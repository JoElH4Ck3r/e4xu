package org.wvxvws.gui.skins 
{
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	
	/**
	 * DefaultButonProducer class.
	 * @author wvxvw
	 */
	public class DefaultButonProducer extends ButtonSkinProducer
	{
		public static const UP_STATE:String = "upState";
		public static const OVER_STATE:String = "overState";
		public static const DOWN_STATE:String = "downState";
		
		public function DefaultButonProducer(states:Vector.<String> = null, 
										stateClasses:Vector.<Class> = null, 
										stateFactories:Vector.<Function> = null)
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				super._states = new <String>[UP_STATE, OVER_STATE, DOWN_STATE];
			if (!stateFactories) 
				super._stateFactories = new <Function>[defaultStateFactory, 
													defaultStateFactory,
													defaultStateFactory];
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
					g.beginFill(0xB0B0B0);
					break;
				case OVER_STATE:
					g.beginFill(0xC0C0C0);
					break;
				case DOWN_STATE:
					g.beginFill(0xA0A0A0);
					break;
			}
			Drawings.drawRoundedCorners(g, 4, 4, 0, 0, 20, 20, 16);
			s.scale9Grid = new Rectangle(4, 4, 12, 12);
			return s;
		}
		
		public override function produce(inContext:Object, 
										state:String = null):InteractiveObject 
		{
			return super.produce(inContext, state);
		}
	}

}