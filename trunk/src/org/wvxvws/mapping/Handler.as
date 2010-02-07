package org.wvxvws.mapping 
{
	//{ imports
	import flash.events.Event;
	import mx.core.IMXMLObject;
	import flash.events.EventDispatcher;
	import org.wvxvws.binding.EventGenerator;
	//}
	
	[DefaultProperty("handlers")]
	
	/**
	 * Handler class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Handler extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property type
		//------------------------------------
		
		[Bindable("typeChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>typeChanged</code> event.
		*/
		public function get type():String { return _type; }
		
		public function set type(value:String):void 
		{
			if (this._type === value) return;
			this._type = value;
			if (super.hasEventListener(EventGenerator.getEventType("type")))
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
		public function get handlers():Vector.<Function>
		{
			return this._handlers.concat();
		}
		
		public function set handlers(value:Vector.<Function>):void 
		{
			if (this._handlers === value) return;
			this._handlers.length = 0;
			for each (var f:Function in value)
			{
				if (this._handlers.indexOf(f) < 0) this._handlers.push(f);
			}
			this._handlers = value;
			if (super.hasEventListener(EventGenerator.getEventType("handlers")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _id:String;
		protected var _type:String;
		protected var _handlers:Vector.<Function> = new <Function>[];
		
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
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void { this._id = id; }
		
		public function dispose():void { }
	}
}