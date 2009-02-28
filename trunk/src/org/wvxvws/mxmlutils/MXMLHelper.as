package org.wvxvws.mxmlutils 
{
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	* MXMLHelper class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class MXMLHelper 
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
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function MXMLHelper() { super(); }
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function nameForMXMLListener(dispatcher:IEventDispatcher, 
														eventType:String):Function
		{
			if (!dispatcher.hasEventListener(eventType)) return null;
			var re:RegExp = new RegExp("_" + eventType + "$", "g");
			var listeners:XMLList = 
				describeType(dispatcher).method.(String(@name).match(re).length);
			var f:Function = Object(dispatcher)[listeners[0].@name];
			return f;
		}
		
		public static function listenerForBindedProperty(dispatcher:IEventDispatcher, 
										property:String, eventType:String):Function
		{
			return Object(dispatcher)["__" + property + "_" + eventType];
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