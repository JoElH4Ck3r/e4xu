package org.wvxvws.mapping 
{
	//{ imports
	import flash.utils.Dictionary;
	//}
	
	/**
	 * Dispatcher class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class Dispatcher implements IDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _events:Dictionary/*EventType*/ = new Dictionary();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Dispatcher() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 
		 * @param	type
		 * @param	handler f:(type:EventType, caller:IDispatcher, ?params:Array -> void)
		 */
		public function addHandler(type:EventType, handler:Function):void
		{
			if (!this._events[type]) this._events[type] = new Dictionary();
			this._events[type][handler] = true;
		}
		
		/**
		 * 
		 * @param	type
		 * @param	handler f:(type:EventType, caller:IDispatcher, ?params:Array -> void)
		 */
		public function removeHandler(type:EventType, handler:Function):void
		{
			if (!this._events[type]) return;
			delete this._events[type][handler];
		}
		
		public function dispatch(type:EventType, params:Array = null):void
		{
			var d:Dictionary = this._events[type];
			for (var o:Object in d)
			{
				if (params) (o as Function)(type, this, params.concat());
				else (o as Function)(type, this);
			}
		}
		
		public function getHandlers(type:EventType = null):Dictionary/*Function*/
		{
			var d:Dictionary = new Dictionary();
			var e:Dictionary;
			var o:Object;
			if (type)
			{
				e = this._events[type] as Dictionary;
				for (o in e) d[o] = true;
			}
			else
			{
				for (o in this._events)
				{
					e = this._events[o] as Dictionary;
					for (var et:Object in e) d[et] = true;
				}
			}
			return d;
		}
		
		public function getEvents():Dictionary/*EventType*/
		{
			var d:Dictionary = new Dictionary();
			for (var o:Object in this._events) d[o] = true;
			return d;
		}
	}
}