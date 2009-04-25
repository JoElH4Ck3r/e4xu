package org.wvxvws.mapping 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	
	/**
	* Handler class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Handler extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property events
		//------------------------------------
		
		[Bindable("eventsChange")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>eventsChange</code> event.
		 */
		public function get events():Array
		{
			var ret:Array = [];
			for (var p:String in _listeners) ret.push(p);
			return ret.length ? ret : null;
		}
		
		public function set events(value:Array):void 
		{
			var changed:Boolean;
			for each (var s:String in value)
			{
				if (!(s in _listeners))
				{
					_listeners[s] = [];
					changed = true;
				}
			}
			if (changed) dispatchEvent(new Event("eventsChange"));
		}
		
		//------------------------------------
		//  Public property listeners
		//------------------------------------
		
		private var _listeners:Object = {};
		
		[Bindable("listenersChange")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding. 
		 * When this property is modified, it dispatches the <code>listenersChange</code> event.
		 */
		public function get listeners():Object { return _listeners; }
		
		public function set listeners(value:Object):void 
		{
			if (_listeners == value) return;
			var changed:Boolean;
			for each(var list:Listener in value)
			{
				changed = true;
				if (!(list.eventType in _listeners)) _listeners[list.eventType] = [];
				_listeners[list.eventType].splice(list.priority, 0, list);
			}
			if (changed) dispatchEvent(new Event("listenersChange"));
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
		
		public function Handler() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function addEventListener(type:String, listener:Function, 
										useCapture:Boolean = false, priority:int = 0, 
										useWeakReference:Boolean = false):void 
		{
			if (!(type in listener)) listener[type] = [];
			var list:Listener = new Listener(type, listener, priority);
			_listeners[type].splice(priority, 0, list);
		}
		
		public override function dispatchEvent(event:Event):Boolean 
		{
			var group:Array = _listeners[event.type];
			for each (var list:Listener in group) list.listener(event);
			return false;
		}
		
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