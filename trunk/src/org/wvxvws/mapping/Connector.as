package org.wvxvws.mapping 
{
	//{ imports
	import flash.display.Loader;
	import flash.events.Event;
	import mx.core.IMXMLObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.wvxvws.binding.EventGenerator;
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
		public function get link():String { return this._link.id; }
		
		public function set link(value:String):void 
		{
			if (this._link && this._link.id === value) return;
			var vm:Vector.<Map> = Map.getMaps(this._domain);
			for each (var m:Map in vm)
			{
				this._link = m.getLink(value);
				if (this._link) break;
			}
			if (!this._link) throw new Error("Cannot resolve the link for: " + value);
			this.addHandlers();
			if (super.hasEventListener(EventGenerator.getEventType("link")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public function get handlers():Vector.<Handler> { return this._handlers; }
		
		public function set handlers(value:Vector.<Handler>):void 
		{
			if (this._handlers === value) return;
			this._handlers = value;
			if (this._link) this.addHandlers();
			if (super.hasEventListener(EventGenerator.getEventType("handlers")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get dispatcher():IEventDispatcher
		{
			if (this._link) return this._link.dispatcher;
			return null;
		}
		
		public function get id():String { return this._id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _link:Link;
		protected var _document:Object;
		protected var _id:String;
		protected var _handlers:Vector.<Handler>;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _domain:String = (new Loader()).contentLoaderInfo.loaderURL;
		
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
			this._document = document;
			this._id = id;
		}
		
		public function dispose():void { }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function addHandlers():void
		{
			var s:String;
			var v:Vector.<Function>;
			var f:Function;
			for each (var h:Handler in this._handlers)
			{
				v = h.handlers;
				s = h.type;
				for each (f in v) this._link.addEventListener(s, f);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}