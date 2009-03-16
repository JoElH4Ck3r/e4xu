package org.wvxvws.tests 
{
	import flash.events.Event;
	
	/**
	* TestEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class TestEvent extends Event 
	{
		public static const TEST:String = "test";
		
		public function TestEvent(type:String) 
		{ 
			super(type);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TestEvent(type);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TestEvent", "type"); 
		}
		
	}
	
}