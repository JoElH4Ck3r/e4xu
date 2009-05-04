package org.wvxvws.gui.styles 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	* ICSSClient interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface ICSSClient 
	{
		function get className():String;
		function set className(value:String):void;
		function get style():IEventDispatcher;
		function get style(value:IEventDispatcher):void;
		function refreshStyles(event:Event = null):void;
	}
	
}