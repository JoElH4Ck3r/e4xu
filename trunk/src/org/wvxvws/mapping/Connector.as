package org.wvxvws.mapping 
{
	//{ imports
	import flash.events.Event;
	import mx.core.IMXMLObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	//}
	
	[DefaultProperty("handlers")]
	
	/**
	 * Connector class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Connector extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property link
		//------------------------------------
		
		[Bindable("linkChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>linkChanged</code> event.
		*/
		public function get link():String { return _link.id; }
		
		public function set link(value:String):void 
		{
			if (_link && _link.id == value) return;
			var vm:Vector.<Map> = Map.instances;
			for each (var m:Map in vm)
			{
				_link = m.getLink(value);
				if (_link) break;
			}
			if (!_link) throw new Error("Cannot resolve the link for: " + value);
			_link.addEventListener(value, linkHandler);
			super.dispatchEvent(new Event("linkChanged"));
		}
		
		//------------------------------------
		//  Public property handlers
		//------------------------------------
		
		[Bindable("handlersChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>handlersChanged</code> event.
		*/
		public function get handlers():Vector.<Function> { return _handlers.concat(); }
		
		public function set handlers(value:Vector.<Function>):void 
		{
			if (_handlers == value) return;
			_handlers.length = 0;
			for each (var f:Function in value)
			{
				if (_handlers.indexOf(f) < 0)
					_handlers.push(f);
			}
			super.dispatchEvent(new Event("handlersChanged"));
		}
		
		public function get dispatcher():IEventDispatcher
		{
			if (_link) return _link.dispatcher;
			return null;
		}
		
		public function get id():String { return _id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _link:Link;
		protected var _document:Object;
		protected var _id:String;
		protected var _handlers:Vector.<Function> = new <Function>[];
		
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
		
		public function Connector() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
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
		
		protected function linkHandler(event:MappingEvent):void 
		{
			for each (var f:Function in _handlers) f(event);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}