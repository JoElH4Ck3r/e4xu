package org.wvxvws.lcbridge 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	/**
	* AVM1ErrorEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class AVM1ErrorEvent extends ErrorEvent 
	{
		public static const CONNECTION_ERROR:String = "connectionError";
		
		private var _id:int;
		
		public function AVM1ErrorEvent(type:String, text:String, id:int) 
		{ 
			super(type, false, false, text);
		} 
		
		public override function clone():Event 
		{ 
			return new AVM1ErrorEvent(type, text, _id);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AVM1ErrorEvent", "type", "text"); 
		}
		
		public function get id():int { return _id; }
		
	}
	
}