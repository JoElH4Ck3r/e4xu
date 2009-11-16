package org.wvxvws.binding 
{
	//{ imports
	import flash.events.Event;
	//}
	
	/**
	 * EventGenerator class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class EventGenerator
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static const _eventPool:Object = { };
		private static const _changed:String = "Changed";
		private static var _type:String;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function EventGenerator() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function getEventType(type:String):String
		{
			_type = type;
			return type + _changed;
		}
		
		public static function getEvent():Event
		{
			if (!_eventPool[_type]) _eventPool[_type] = new Event(_type + _changed);
			return _eventPool[_type];
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}