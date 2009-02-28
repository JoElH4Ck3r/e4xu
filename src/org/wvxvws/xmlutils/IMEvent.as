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
		
		protected var _propE4X:String;
		protected var _oldValue:Object;
		protected var _newValue:Object;
		
		public function IMEvent(type:String, propE4X:String, oldValue:Object, newValue:Object)
		{ 
			super(type);
			_propE4X = propE4X;
			_oldValue = oldValue;
			_newValue = newValue;
		} 
		
		public override function clone():Event 
		{ 
			return new IMEvent(type, _propE4X, _oldValue, _newValue);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("IMEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get oldValue():Object { return _oldValue; }
		
		public function get newValue():Object { return _newValue; }
		
	}
	
}