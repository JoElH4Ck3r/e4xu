package org.wvxvws.skins.scroller
{
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.Scroller;
	import org.wvxvws.gui.skins.SkinDefaults;
	import org.wvxvws.skins.ButtonSkin;
	
	/**
	 * ScrollBody skin.
	 * @author wvxvw
	 */
	public class ScrollBodySkin extends ButtonSkin
	{
		public function ScrollBodySkin(states:Vector.<String> = null,
										stateClasses:Vector.<Class> = null, 
										stateFactories:Vector.<Function> = null) 
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				_states = new <String>[Scroller.UP_STATE, 
										Scroller.OVER_STATE, 
										Scroller.DOWN_STATE, 
										Scroller.DISABLED_STATE];
			if (!stateFactories) 
				_stateFactories = new <Function>[defaultStateFactory, 
												defaultStateFactory,
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
				case Scroller.UP_STATE:
				default:
					g.beginFill(SkinDefaults.UP_COLOR);
					break;
				case Scroller.OVER_STATE:
					g.beginFill(SkinDefaults.OVER_COLOR);
					break;
				case Scroller.DOWN_STATE:
					g.beginFill(SkinDefaults.DOWN_COLOR);
					break;
				case Scroller.DISABLED_STATE:
					g.beginFill(SkinDefaults.DISABLED_COLOR);
					break;
			}
			g.drawRect(0, 0, 16, 16);
			g.beginFill(0);
			g.drawRect(0, 0, 16, 16);
			g.drawRect(1, 1, 14, 14);
			s.scale9Grid = new Rectangle(1, 1, 14, 14);
			return s;
		}
	}
}