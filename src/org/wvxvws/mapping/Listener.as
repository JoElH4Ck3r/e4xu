package org.wvxvws.mapping 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	
	/**
	* Listener class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Listener extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		//------------------------------------
		//  Public property eventType
		//------------------------------------
		
		private var _eventType:String;
		
		[Bindable("eventTypeChange")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>eventTypeChange</code> event.
		 */
		public function get eventType():String { return _eventType; }
		
		public function set eventType(value:String):void 
		{
			if (_eventType == value) return;
			_eventType = value;
			dispatchEvent(new Event("eventTypeChange"));
		}
		
		//------------------------------------
		//  Public property listener
		//------------------------------------
		
		private var _listener:Function = null;
		
		[Bindable("listenerChange")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>listenerChange</code> event.
		 */
		public function get listener():Function { return _listener; }
		
		public function set listener(value:Function):void 
		{
			if (_listener == value) return;
			_listener = value;
			dispatchEvent(new Event("listenerChange"));
		}
		
		//------------------------------------
		//  Public property priority
		//------------------------------------
		
		private var _priority:int;
		
		[Bindable("priorityChange")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>priorityChange</code> event.
		 */
		public function get priority():int { return _priority; }
		
		public function set priority(value:int):void 
		{
			if (_priority == value) return;
			_priority = value;
			dispatchEvent(new Event("priorityChange"));
		}
		
		//------------------------------------
		//  Public property useWeakReference
		//------------------------------------
		
		private var _useWeakReference:Boolean = false;
		
		[Bindable("useWeakReferenceChange")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>useWeakReferenceChange</code> event.
		 */
		public function get useWeakReference():Boolean { return _useWeakReference; }
		
		public function set useWeakReference(value:Boolean):void 
		{
			if (_useWeakReference == value) return;
			_useWeakReference = value;
			dispatchEvent(new Event("useWeakReferenceChange"));
		}
		
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
		
		private var _document:Object;
		private var _id:String;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function Listener(eventType:String = null, listener:Function = null, 
																	priority:int = 0) 
		{
			super();
			_eventType = eventType;
			_listener = listener;
			_priority = priority;
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
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