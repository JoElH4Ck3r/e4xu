package org.wvxvws.mapping 
{
	import flash.utils.Dictionary;
	
	/**
	 * IDispatcher interface.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public interface IDispatcher 
	{		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * @param	type
		 * @param	handler f:(type:EventType, caller:IDispatcher, params:Array -> void)
		 */
		function addHandler(type:EventType, handler:Function):void;
		
		/**
		 * 
		 * @param	type
		 * @param	handler f:(type:EventType, caller:IDispatcher, params:Array -> void)
		 */
		function removeHandler(type:EventType, handler:Function):void;
		
		function dispatch(type:EventType, params:Array = null):void;
		
		function getHandlers(type:EventType = null):Dictionary/*Function*/;
		
		function getEvents():Dictionary/*EventType*/;
	}
}