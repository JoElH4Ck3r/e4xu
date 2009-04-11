package org.wvxvws.gui 
{
	import flash.events.IEventDispatcher;
	
	/**
	* Ipreloader interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface IPreloader 
	{
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
		
		function get classAlias():String;
		function set classAlias(value:String):void;
		
		function get percent():int;
		function set percent(value:int):void;
		
	}
	
}