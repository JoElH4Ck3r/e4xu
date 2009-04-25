package org.wvxvws.mapping 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	
	/**
	* CallBack class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class CallBack extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property method
		//------------------------------------
		
		[Bindable("methodChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>methodChange</code> event.
		*/
		public function get method():Function { return _method; }
		
		public function set method(value:Function):void 
		{
		   if (_method == value) return;
		   _method = value;
		   dispatchEvent(new Event("methodChange"));
		}
		
		//------------------------------------
		//  Public property parameters
		//------------------------------------
		
		[Bindable("parametersChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>parametersChange</code> event.
		*/
		public function get parameters():Array { return _parameters; }
		
		public function set parameters(value:Array):void 
		{
		   if (_parameters == value) return;
		   _parameters = value;
		   dispatchEvent(new Event("parametersChange"));
		}
		
		//------------------------------------
		//  Public property target
		//------------------------------------
		
		[Bindable("targetChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>targetChange</code> event.
		*/
		public function get target():Object { return _target; }
		
		public function set target(value:Object):void 
		{
		   if (_target == value) return;
		   _target = value;
		   dispatchEvent(new Event("targetChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _parameters:Array;
		protected var _method:Function;
		protected var _target:Object;
		
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
		
		public function CallBack() { super(); }
		
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
		
		public function call(...rest):*
		{
			if (rest.length) _parameters = rest.slice();
			if (_method != null && !_target) return _method.apply(null, _parameters);
			else if (_method != null && _target) return _method.apply(_target, _parameters);
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