package org.wvxvws.mapping 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	
	/**
	* Invoker class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Invoker extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property callbacks
		//------------------------------------
		
		[Bindable("callbacksChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>callbacksChange</code> event.
		*/
		public function get callbacks():Array { return _callbacks; }
		
		public function set callbacks(value:Array):void 
		{
		   if (_callbacks == value) return;
		   _callbacks = value;
		   dispatchEvent(new Event("callbacksChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _callbacks:Array = null;
		protected var _document:Object;
		private var _id:String;
		
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
		
		public function Invoker() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function call(event:Event = null):void
		{
			for each (var cb:CallBack in _callbacks) cb.call();
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