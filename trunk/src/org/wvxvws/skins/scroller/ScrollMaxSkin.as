package org.wvxvws.skins.scroller
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.Scroller;
	import org.wvxvws.gui.skins.SkinDefaults;
	import org.wvxvws.gui.StatefulButton;
	import org.wvxvws.skins.ButtonSkin;
	
	/**
	 * ScrollBody skin.
	 * @author wvxvw
	 */
	public class ScrollMaxSkin extends ButtonSkin
	{
		public function ScrollMaxSkin(states:Vector.<String> = null,
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
				_stateFactories = new <Function>[buttonFactory, 
												buttonFactory,
												buttonFactory,
												buttonFactory];
		}
		
		private function buttonFactory(inContext:Object, ...rest):StatefulButton
		{
			var b:StatefulButton = new StatefulButton();
			var o:Object = { };
			o[Scroller.UP_STATE] = defaultStateFactory(Scroller.UP_STATE);
			o[Scroller.OVER_STATE] = defaultStateFactory(Scroller.OVER_STATE);
			o[Scroller.DOWN_STATE] = defaultStateFactory(Scroller.DOWN_STATE);
			o[Scroller.DISABLED_STATE] = defaultStateFactory(Scroller.DISABLED_STATE);
			b.states = o;
			return b;
		}
		
		private function defaultStateFactory(state:String):InteractiveObject
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
			g.beginFill(0);
			g.drawPath(new <int>[GraphicsPathCommand.MOVE_TO,
								GraphicsPathCommand.LINE_TO,
								GraphicsPathCommand.LINE_TO,
								GraphicsPathCommand.LINE_TO],
						new <Number>[8, 12, 12, 4, 4, 4, 8, 12], 
						GraphicsPathWinding.NON_ZERO);
			s.scale9Grid = new Rectangle(1, 1, 14, 14);
			return s;
		}
	}
}