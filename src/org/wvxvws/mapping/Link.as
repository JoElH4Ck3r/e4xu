package org.wvxvws.mapping 
{
	//{ imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	//}
	
	[DefaultProperty("eventTypes")]
	
	/**
	 * Link class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 9.0.115
	 */
	public class Link extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const DISPATCHER:String = "dispatcher";
		public static const EVENT_TYPES:String = "eventTypes";
		
		public function get id():String { return _id; }
		
		//------------------------------------
		//  Public property dispatcher
		//------------------------------------
		
		[Bindable("dispatcherChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>dispatcherChanged</code> event.
		*/
		public function get dispatcher():IEventDispatcher { return _dispatcher; }
		
		public function set dispatcher(value:IEventDispatcher):void 
		{
			if (_dispatcher == value) return;
			_dispatcher = value;
			if (_dispatcher) this.addUnamangedHandlers();
			if (super.hasEventListener(EventGenerator.getEventType(DISPATCHER)))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property eventTypes
		//------------------------------------
		
		[Bindable("eventTypesChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>eventTypesChanged</code> event.
		*/
		public function get eventTypes():Vector.<String> { return _eventTypes; }
		
		public function set eventTypes(value:Vector.<String>):void 
		{
			if (_eventTypes === value) return;
			var s:String;
			if (_dispatcher)
			{
				for each (s in _eventTypes)
				{
					_dispatcher.removeEventListener(s, super.dispatchEvent);
				}
			}
			_eventTypes.length = 0;
			for each (s in value) _eventTypes.push(s);
			if (super.hasEventListener(EventGenerator.getEventType(EVENT_TYPES)))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Map;
		protected var _id:String;
		protected var _dispatcher:IEventDispatcher;
		protected var _eventTypes:Vector.<String> = new <String>[];
		protected var _unmanagedHandlers:Vector.<Array>;
		
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
		
		public function Link() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document as Map;
			_id = id;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function addEventListener(type:String, listener:Function, 
								useCapture:Boolean = false, priority:int = 0, 
								useWeakReference:Boolean = false):void 
		{
			switch (type)
			{
				case EVENT_TYPES:
				case DISPATCHER:
					super.addEventListener(type, listener, 
						useCapture, priority, useWeakReference);
					break;
				default:
					if (_dispatcher)
					{
						_dispatcher.addEventListener(type, listener, 
							useCapture, priority, useWeakReference);
					}
					else
					{
						if (!_unmanagedHandlers) _unmanagedHandlers = new <Array>[];
						_unmanagedHandlers.push(arguments);
					}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function addUnamangedHandlers():void
		{
			for each (var a:Array in _unmanagedHandlers)
				this.addEventListener.apply(this, a);
			_unmanagedHandlers.length = 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}