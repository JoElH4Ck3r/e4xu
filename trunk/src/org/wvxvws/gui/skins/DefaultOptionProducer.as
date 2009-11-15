package org.wvxvws.gui.skins 
{
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.controls.Option;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	
	/**
	 * DefaultOptionProducer class.
	 * @author wvxvw
	 */
	public class DefaultOptionProducer extends ButtonSkinProducer
	{
		public function DefaultOptionProducer(states:Vector.<String> = null, 
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
			Drawings.circle(g, 8, new Point(4, 4));
			g.beginFill(0);
			Drawings.circle(g, 8, new Point(4, 4));
			Drawings.circle(g, 7, new Point(5, 5));
			if (state === Option.SELECTED_STATE || state === Option.SELECTED_DISABLED_STATE)
			{
				Drawings.circle(g, 3, new Point(9, 9));
			}
			trace(s.width, s.height);
			//s.scale9Grid = new Rectangle(4, 4, 8, 8);
			return s;
		}
	}

}