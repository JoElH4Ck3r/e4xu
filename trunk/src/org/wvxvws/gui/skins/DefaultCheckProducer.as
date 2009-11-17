package org.wvxvws.gui.skins 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import org.wvxvws.gui.controls.Check;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	
	/**
	 * DefaultCheckProducer class.
	 * @author wvxvw
	 */
	public class DefaultCheckProducer extends ButtonSkinProducer
	{
		
		public function DefaultCheckProducer(states:Vector.<String> = null,
										stateClasses:Vector.<Class> = null, 
										stateFactories:Vector.<Function> = null) 
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				super._states = new <String>[Check.UP_STATE, Check.OVER_STATE, 
							Check.DOWN_STATE, Check.DISABLED_STATE, 
							Check.SELECTED_STATE, Check.SELECTED_DISABLED_STATE];
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
				case Check.UP_STATE:
				default:
					g.beginFill(SkinDefaults.UP_COLOR);
					break;
				case Check.OVER_STATE:
					g.beginFill(SkinDefaults.OVER_COLOR);
					break;
				case Check.DOWN_STATE:
					g.beginFill(SkinDefaults.DOWN_COLOR);
					break;
				case Check.DISABLED_STATE:
					g.beginFill(SkinDefaults.DISABLED_COLOR);
					break;
				case Check.SELECTED_STATE:
					g.beginFill(SkinDefaults.SELECTED_COLOR);
					break;
				case Check.SELECTED_DISABLED_STATE:
					g.beginFill(SkinDefaults.DISABLED_SELECTED_COLOR);
					break;
			}
			g.drawRect(0, 0, 12, 12);
			g.beginFill(0);
			g.drawRect(0, 0, 12, 12);
			g.drawRect(1, 1, 10, 10);
			if (state === Check.SELECTED_STATE || state === Check.SELECTED_DISABLED_STATE)
			{
				g.drawPath(new <int>[GraphicsPathCommand.MOVE_TO, 
									GraphicsPathCommand.LINE_TO,
									GraphicsPathCommand.LINE_TO,
									GraphicsPathCommand.LINE_TO,
									GraphicsPathCommand.LINE_TO,
									GraphicsPathCommand.LINE_TO,
									GraphicsPathCommand.LINE_TO,
									GraphicsPathCommand.LINE_TO
									],
							new <Number>[2, 4, 5, 8, 9, 3, 9, 5, 5, 9, 2, 6, 2, 4], 
							GraphicsPathWinding.NON_ZERO);
			}
			//s.scale9Grid = new Rectangle(4, 4, 8, 8);
			return s;
		}
	}

}