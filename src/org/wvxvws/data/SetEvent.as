package org.wvxvws.data
{
	import flash.events.Event;
	
	/**
	* DataChangeEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class SetEvent extends Event 
	{
		public static const ADD:String = "add";
		public static const REMOVE:String = "remove";
		public static const CHANGE:String = "change";
		public static const SORT:String = "sort";
		
		public function get data():Object { return _data; }
		
		public function get index():int { return _index; }
		
		protected var _data:Object;
		protected var _index:int;
		
		public function SetEvent(type:String, data:Object, index:int = -1) 
		{ 
			super(type);
			_data = data;
		} 
		
		public override function clone():Event { return this; } 
		
		public override function toString():String 
		{ 
			return formatToString("DataChangeEvent", "type", "data"); 
		}
	}
	
}