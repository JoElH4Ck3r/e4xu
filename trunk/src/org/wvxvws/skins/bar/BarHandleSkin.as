package org.wvxvws.skins.bar 
{
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import org.wvxvws.gui.Bar;
	import org.wvxvws.gui.skins.Drawings;
	import org.wvxvws.gui.skins.SkinDefaults;
	import org.wvxvws.gui.StatefulButton;
	import org.wvxvws.skins.ButtonSkin;
	
	/**
	 * BarHandleSkin skin.
	 * @author wvxvw
	 */
	public class BarHandleSkin extends ButtonSkin
	{
		
		public function BarHandleSkin(states:Vector.<String> = null, 
									stateClasses:Vector.<Class> = null, 
									stateFactories:Vector.<Function> = null)
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				super._states = new <String>[Bar.UP_STATE, 
							Bar.OVER_STATE, Bar.DOWN_STATE];
			if (!stateFactories) 
				super._stateFactories = new <Function>[buttonFactory, 
													buttonFactory,
													buttonFactory];
		}
		
		private function buttonFactory(inContext:Object, ...rest):StatefulButton
		{
			var b:StatefulButton = new StatefulButton();
			var o:Object = { };
			o[Bar.UP_STATE] = defaultStateFactory(Bar.UP_STATE);
			o[Bar.OVER_STATE] = defaultStateFactory(Bar.OVER_STATE);
			o[Bar.DOWN_STATE] = defaultStateFactory(Bar.DOWN_STATE);
			b.states = o;
			return b;
		}
		
		private function defaultStateFactory(state:String):InteractiveObject
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			switch (state)
			{
				case Bar.UP_STATE:
				default:
					g.beginFill(SkinDefaults.UP_COLOR);
					break;
				case Bar.OVER_STATE:
					g.beginFill(SkinDefaults.OVER_COLOR);
					break;
				case Bar.DOWN_STATE:
					g.beginFill(SkinDefaults.DOWN_COLOR);
					break;
			}
			Drawings.circle(g, 6, new Point(0, 0));
			g.beginFill(0);
			Drawings.circle(g, 6, new Point(0, 0));
			Drawings.circle(g, 5, new Point(1, 1));
			return s;
		}
	}
}