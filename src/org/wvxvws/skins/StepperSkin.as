package org.wvxvws.skins 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.controls.NumStepper;
	import org.wvxvws.gui.skins.SkinDefaults;
	
	/**
	 * StepperSkin skin.
	 * @author wvxvw
	 */
	public class StepperSkin extends ButtonSkin
	{
		public function StepperSkin(states:Vector.<String> = null,
										stateClasses:Vector.<Class> = null, 
										stateFactories:Vector.<Function> = null) 
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				_states = new <String>[NumStepper.UP_STATE, 
										NumStepper.OVER_STATE, 
										NumStepper.DOWN_STATE, 
										NumStepper.DISABLED_STATE];
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
				case NumStepper.UP_STATE:
				default:
					g.beginFill(SkinDefaults.UP_COLOR);
					break;
				case NumStepper.OVER_STATE:
					g.beginFill(SkinDefaults.OVER_COLOR);
					break;
				case NumStepper.DOWN_STATE:
					g.beginFill(SkinDefaults.DOWN_COLOR);
					break;
				case NumStepper.DISABLED_STATE:
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
						new <Number>[8, 4, 12, 12, 4, 12, 8, 4], 
						GraphicsPathWinding.NON_ZERO);
			s.scale9Grid = new Rectangle(1, 1, 14, 14);
			return s;
		}
	}
}