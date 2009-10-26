package org.wvxvws.gui.skins 
{
	import flash.display.InteractiveObject;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	
	/**
	 * DefaultButonProducer class.
	 * @author wvxvw
	 */
	public class DefaultButonProducer extends ButtonSkinProducer
	{
		
		public function DefaultButonProducer(states:Vector.<String> = null, 
										stateClasses:Vector.<Class> = null, 
										stateFactories:Vector.<Function> = null)
		{
			super(states, stateClasses, stateFactories);
			if (!states) 
				super._states = new <String>["upState", "overState", "downState"];
			if (!stateFactories) 
				super._stateFactories = new <String>[defaultStateFactory, 
													defaultStateFactory,
													defaultStateFactory];
		}
		
		private function defaultStateFactory(inContext:Object, 
										state:String = null):InteractiveObject
		{
			
		}
		
		public override function produce(inContext:Object, 
										state:String = null):InteractiveObject 
		{
			return super.produce(inContext, state);
		}
	}

}