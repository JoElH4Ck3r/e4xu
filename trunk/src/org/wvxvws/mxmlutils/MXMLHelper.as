package org.wvxvws.mxmlutils 
{
	import flash.events.IEventDispatcher;
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
			var id:String = "_" + getQualifiedClassName(dispatcher) + "_" +
				getQualifiedSuperclassName(dispatcher).match(/[^:]+$/g)[0];
			var i:int;
			while (!Object(dispatcher).hasOwnProperty(["__" + id + i.toString() +
															"_" + eventType])) i++;
			var f:Function = Object(dispatcher)["__" + id + i.toString() + "_" + 
							eventType];
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