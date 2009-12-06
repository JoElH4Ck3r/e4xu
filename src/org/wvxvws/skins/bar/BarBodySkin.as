package org.wvxvws.skins.bar 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.Bar;
	import org.wvxvws.gui.skins.Drawings;
	import org.wvxvws.gui.skins.SkinDefaults;
	import org.wvxvws.gui.skins.Slices;
	import org.wvxvws.skins.ButtonSkin;
	
	/**
	 * BarBodySkin skin.
	 * @author wvxvw
	 */
	public class BarBodySkin extends ButtonSkin
	{
		
		public function BarBodySkin(states:Vector.<String> = null, 
									stateClasses:Vector.<Class> = null, 
									stateFactories:Vector.<Function> = null)
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				super._states = new <String>[Bar.UP_STATE, 
							Bar.OVER_STATE, Bar.DOWN_STATE];
			else _states = states;
			if (!stateFactories) 
				super._stateFactories = new <Function>[defaultStateFactory, 
													defaultStateFactory,
													defaultStateFactory];
			else _stateFactories = stateFactories;
		}
		
		private function defaultStateFactory(inContext:Object, 
										state:String = null):InteractiveObject
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			var slices:Slices;
			var bd:BitmapData = new BitmapData(20, 20, true, 0x00FFFFFF);
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
			Drawings.roundedRectangle(g, 4, 4, 0, 0, 20, 20, 16);
			bd.draw(s);
			slices = new Slices(bd, new Rectangle(4, 4, 12, 12));
			return slices;
		}
	}
}