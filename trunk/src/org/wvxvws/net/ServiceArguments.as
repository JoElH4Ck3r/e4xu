package org.wvxvws.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.core.IMXMLObject;
	
	[DefaultProperty("parameters")]
	
	/**
	* ServiceArguments class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public dynamic class ServiceArguments extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _parameters:Array;
		
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
		public function ServiceArguments() { super(); }
		
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
		
		public function toArgumentString():String
		{
			trace(_parameters.length);
			var temp:String = "";
			for (var p:String in _parameters)
			{
				if (_parameters[p] !== undefined && _parameters[p] !== null && 
					_parameters[p].hasOwnProperty("id"))
				{
					temp += (temp ? "&" : "") + 
							_parameters[p].id + "=" + _parameters[p];
				}
				else
				{
					temp += (temp ? "&" : "") + "p" + p + "=" + _parameters[p];
				}
			}
			return temp;
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