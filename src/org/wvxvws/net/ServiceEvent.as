package org.wvxvws.net 
{
	import flash.events.Event;
	
	/**
	 * ServiceEvent event.
	 * @author wvxvw
	 */
	public class ServiceEvent extends Event 
	{
		public static const RESULT:String = "result";
		public static const FAULT:String = "fault";
		
		public function get value():Object { return _value; }
		
		private var _value:Object;
		
		public function ServiceEvent(type:String, value:Object) 
		{ 
			super(type);
			_value = value;
		} 
		
		public override function clone():Event 
		{ 
			return new ServiceEvent(type, _value);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ServiceEvent", "type", "value"); 
		}
		
	}
	
}