package org.wvxvws.skins 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.controls.Option;
	import org.wvxvws.gui.skins.Drawings;
	import org.wvxvws.gui.skins.SkinDefaults;
	
	/**
	 * StepperSkin skin.
	 * @author wvxvw
	 */
	public class OptionSkin extends ButtonSkin
	{
		public function OptionSkin(states:Vector.<String> = null,
										stateClasses:Vector.<Class> = null, 
										stateFactories:Vector.<Function> = null) 
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				super._states = new <String>[Option.UP_STATE, Option.OVER_STATE, 
							Option.DOWN_STATE, Option.DISABLED_STATE, 
							Option.SELECTED_STATE, Option.SELECTED_DISABLED_STATE];
			if (!stateFactories) 
				super._stateFactories = new <Function>[defaultStateFactory, 
													defaultStateFactory,
													defaultStateFactory,
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
				case Option.UP_STATE:
				default:
					g.beginFill(SkinDefaults.UP_COLOR);
					break;
				case Option.OVER_STATE:
					g.beginFill(SkinDefaults.OVER_COLOR);
					break;
				case Option.DOWN_STATE:
					g.beginFill(SkinDefaults.DOWN_COLOR);
					break;
				case Option.DISABLED_STATE:
					g.beginFill(SkinDefaults.DISABLED_COLOR);
					break;
				case Option.SELECTED_STATE:
					g.beginFill(SkinDefaults.SELECTED_COLOR);
					break;
				case Option.SELECTED_DISABLED_STATE:
					g.beginFill(SkinDefaults.DISABLED_SELECTED_COLOR);
					break;
			}
			Drawings.circle(g, 6, new Point(0, 0));
			g.beginFill(0);
			Drawings.circle(g, 6, new Point(0, 0));
			Drawings.circle(g, 5, new Point(1, 1));
			if (state === Option.SELECTED_STATE || state === Option.SELECTED_DISABLED_STATE)
			{
				Drawings.circle(g, 2, new Point(4, 4));
			}
			//s.scale9Grid = new Rectangle(4, 4, 8, 8);
			return s;
		}
	}
}