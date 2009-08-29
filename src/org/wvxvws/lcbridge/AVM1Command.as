package org.wvxvws.lcbridge 
{
	//{imports
	import flash.events.EventDispatcher;
	//}
	
	/**
	* AVM1Command class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class AVM1Command extends EventDispatcher
	{
		public static const CALL_METHOD:String = "callMethod";
		public static const SET_PROPERTY:String = "setProperty";
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get type():String { return _type; }
		
		public function get scope():String { return _scope; }
		
		public function set scope(value:String):void 
		{
			_scope = value;
		}
		
		public function get method():String { return _method; }
		
		public function set method(value:String):void 
		{
			_method = value;
		}
		
		public function get property():String { return _property; }
		
		public function set property(value:String):void 
		{
			_property = value;
		}
		
		public function get methodArguments():Array { return _methodArguments; }
		
		public function set methodArguments(value:Array):void 
		{
			_methodArguments = value;
		}
		
		public function get operationResult():* { return _operationResult; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _type:String;
		protected var _scope:String;
		protected var _method:String;
		protected var _property:String;
		protected var _methodArguments:Array;
		protected var _propertyValue:*;
		protected var _operationResult:*;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AVM1Command(type:String, scope:String, method:String = "", 
								property:String = "", propertyValue:* = undefined, 
								methodArguments:Array = null) 
		{
			super();
			_type = type;
			_scope = scope;
			if (_type === CALL_METHOD)
			{
				_method = method;
				_methodArguments = methodArguments;
			}
			else if (_type === SET_PROPERTY)
			{
				_property = property;
				_propertyValue = propertyValue;
			}
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
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}