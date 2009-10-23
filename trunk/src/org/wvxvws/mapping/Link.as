package org.wvxvws.mapping 
{
	//{ imports
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
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
			for each (var s:String in _eventTypes)
			{
				_dispatcher.addEventListener(s, omniListener);
			}
			super.dispatchEvent(new Event("dispatcherChanged"));
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
					_dispatcher.removeEventListener(s, omniListener);
				}
			}
			_eventTypes.length = 0;
			for each (s in value) _eventTypes.push(s);
			super.dispatchEvent(new Event("eventTypesChanged"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Map;
		protected var _id:String;
		protected var _result:Object;
		protected var _fault:Object;
		protected var _dispatcher:IEventDispatcher;
		protected var _eventTypes:Vector.<String> = new <String>[];
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function omniListener(event:Event):void 
		{
			super.dispatchEvent(_document.generateEvent(
							_id, _dispatcher, _result, _fault));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}