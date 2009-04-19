package org.wvxvws.net 
{
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
	
	/**
	* IService interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface IService extends IEventDispatcher, IMXMLObject
	{
		function send(method:String = null, parameters:ServiceArguments = null):void;
		function cancel(method:String = null):void;
		
		function get sending():Boolean;
		
		function get resultCallBack():Function;
		function set resultCallBack(value:Function):void;
		
		function get faultCallBack():Function;
		function set faultCallBack(value:Function):void;
		
		function get baseURL():String;
		function set baseURL(value:String):void;
		
		function get methods():Array;
		function set methods(value:Array):void;
		
		function get parameters():ServiceArguments;
		function set parameters(value:ServiceArguments):void;
	}
	
}