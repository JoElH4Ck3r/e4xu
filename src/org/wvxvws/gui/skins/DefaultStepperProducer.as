package org.wvxvws.gui.skins 
{
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import org.wvxvws.gui.controls.NumStepper;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	
	/**
	 * DefaultStepperProducer class.
	 * @author wvxvw
	 */
	public class DefaultStepperProducer extends ButtonSkinProducer
	{
		
		public function DefaultStepperProducer(states:Vector.<String> = null,
										stateClasses:Vector.<Class> = null, 
										stateFactories:Vector.<Function> = null)
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				super._states = new <String>[NumStepper.UP_STATE, 
											NumStepper.OVER_STATE, 
											NumStepper.DOWN_STATE, 
											NumStepper.DISABLED_STATE];
			if (!stateFactories) 
				super._stateFactories = new <Function>[defaultStateFactory, 
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
			//s.scale9Grid = new Rectangle(4, 4, 8, 8);
			return s;
		}
	}

}