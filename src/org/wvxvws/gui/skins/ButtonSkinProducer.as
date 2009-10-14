package org.wvxvws.gui.skins 
{
	import flash.display.InteractiveObject;
	
	/**
	 * ButtonSkinProducer class.
	 * @author wvxvw
	 */
	public class ButtonSkinProducer extends AbstractProducer
	{
		protected var _states:Vector.<String>;
		protected var _stateClasses:Vector.<Class>;
		protected var _stateFactories:Vector.<Function>;
		
		public function ButtonSkinProducer(states:Vector.<String>,
											stateClasses:Vector.<Class>, 
											stateFactories:Vector.<Function> = null) 
		{
			super();
			_states = states;
			_stateClasses = stateClasses;
			_stateFactories = stateFactories;
		}
		
		public function createState(state:String, inContext:Object):InteractiveObject
		{
			var index:int = _states.indexOf(state);
			if (index < 0) return null;
			if (_stateClasses.length > index && _stateClasses[index])
				return new _stateClasses[index]();
			if (_stateFactories && _stateFactories.length > index && 
				_stateFactories[index])
				return _stateFactories[index](this);
			return null;
		}
	}

}