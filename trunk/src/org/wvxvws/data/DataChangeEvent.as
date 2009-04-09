package org.wvxvws.data 
{
	import flash.events.Event;
	
	/**
	* DataChangeEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class DataChangeEvent extends Event 
	{
		public static const DATA_CHANGE:String = "dataChange";
		public static const PUSH:String = "push";
		public static const UNSHIFT:String = "unshift";
		public static const SPLICE:String = "splice";
		public static const POP:String = "pop";
		public static const SHIFT:String = "shift";
		public static const REFRESH:String = "refresh";
		public static const SORT:String = "sort";
		
		protected var _operation:String;
		protected var _data:*;
		
		public function DataChangeEvent(type:String, operation:String, data:*) 
		{ 
			super(type);
			_operation = operation;
			_data = data;
		} 
		
		public override function clone():Event 
		{ 
			return new DataChangeEvent(type, _operation, _data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DataChangeEvent", "type", "operation", "data"); 
		}
		
		public function get operation():String { return _operation; }
		
		public function get data():* { return _data; }
		
	}
	
}