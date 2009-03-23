package org.wvxvws.xmlutils 
{
	import flash.events.Event;
	
	/**
	* IMEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class IMEvent extends Event 
	{
		public static const IMCHANGE:String = "imchange";
		
		protected var _oldValue:Object;
		protected var _newValue:Object;
		protected var _model:InteractiveModel;
		
		public function IMEvent(type:String, oldValue:Object, 
								newValue:Object, model:InteractiveModel)
		{ 
			super(type);
			_oldValue = oldValue;
			_newValue = newValue;
			_model = model;
		} 
		
		public override function clone():Event 
		{ 
			return new IMEvent(type, _oldValue, _newValue, _model);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("IMEvent", "type", "oldValue", "newValue"); 
		}
		
		public function get oldValue():Object { return _oldValue; }
		
		public function get newValue():Object { return _newValue; }
		
		public function get model():InteractiveModel { return _model; }
		
	}
	
}