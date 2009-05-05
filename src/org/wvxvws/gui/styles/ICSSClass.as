package org.wvxvws.gui.styles
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	* ICSSClass interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface ICSSClass extends IEventDispatcher
	{
		function get className():String;
		
		function get client():ICSSClient;
		function set client(value:ICSSClient):void;
		
		function get table():Dictionary;
		function set table(value:Dictionary):void;
		
		function commit():void;
	}
	
}