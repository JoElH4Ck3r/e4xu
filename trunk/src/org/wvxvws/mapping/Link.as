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
		
		public function get id():String { return this._id; }
		
		//------------------------------------
		//  Public property dispatcher
		//------------------------------------
		
		[Bindable("dispatcherChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>dispatcherChanged</code> event.
		*/
		public function get dispatcher():IEventDispatcher { return this._dispatcher; }
		
		public function set dispatcher(value:IEventDispatcher):void 
		{
			if (this._dispatcher == value) return;
			this._dispatcher = value;
			if (this._dispatcher) this.addUnamangedHandlers();
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
		public function get eventTypes():Vector.<String> { return this._eventTypes; }
		
		public function set eventTypes(value:Vector.<String>):void 
		{
			if (this._eventTypes === value) return;
			var s:String;
			if (this._dispatcher)
			{
				for each (s in this._eventTypes)
				{
					this._dispatcher.removeEventListener(s, super.dispatchEvent);
				}
			}
			this._eventTypes.length = 0;
			for each (s in value) this._eventTypes.push(s);
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
			this._document = document as Map;
			this._id = id;
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
					if (this._dispatcher)
					{
						this._dispatcher.addEventListener(type, listener, 
							useCapture, priority, useWeakReference);
					}
					else
					{
						if (!this._unmanagedHandlers)
							this._unmanagedHandlers = new <Array>[];
						this._unmanagedHandlers.push(arguments);
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
			for each (var a:Array in this._unmanagedHandlers)
				this.addEventListener.apply(this, a);
			this._unmanagedHandlers.length = 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}