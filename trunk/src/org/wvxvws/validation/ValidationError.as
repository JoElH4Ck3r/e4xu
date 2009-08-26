package org.wvxvws.validation 
{
	
	/**
	 * ValidationError class. This error is thrown while validating XML using NodePattern.
	 * @author wvxvw
	 */
	public class ValidationError extends Error
	{
		public static const NOT_ALLOWED:int = 0;
		public static const CHILDREN_NOT_ALLOWED:int = 1;
		public static const BAD_CHILD:int = 2;
		public static const BAD_TYPE:int = 3;
		public static const MUST_BE_UNIQUE:int = 4;
		public static const BAD_NAMESPACE:int = 5;
		public static const MISSING_ATTRIBUTE:int = 6;
		public static const MISSING_NODE:int = 7;
		public static const MUST_BE_SINGLE:int = 8;
		public static const NON_UNIQUE_VALUES:int = 9;
		public static const BAD_VALUES:int = 10;
		public static const BAD_TEXT:int = 11;
		public static const BAD_NAME:int = 12;
		
		protected var _context:String;
		protected var _reporter:Object;
		
		private static const ERROR_TYPES:Array = 
		[
			"{0} is not allowed here.", //0
			"{0} can not have child dnodes.", //1
			"{0} can not contain node {1}.", //2
			"{0} should be of type {1}.", //3
			"Children of {0} must have unique names.", //4
			"Namespace for node {0} should be {1}.", //5
			"{0} should contain {1}.", //6
			"Missing {0} node.", //7
			"Multiple nodes not allowed after {0}.", //8
			"Values for attribute {0} must be unique.", //9
			"Values for attribute {0} must be these: {1}", //10
			"Text {0} doesn't match the rule {1}.", //11
			"Node name {0} doesn't match the rule {1}." //12
		];
		
		public function ValidationError(type:int, ...rest) 
		{
			var mess:String = bracketHelper(ERROR_TYPES[type], rest);
			super(mess, type);
		}
		
		validation_internal function setContext(context:String, reporter:Object):void
		{
			_context = context;
			_reporter = reporter;
		}
		
		protected function bracketHelper(mess:String, args:Array):String
		{
			var i:int;
			for each (var n:Object in args)
			{
				mess = mess.split("{" + i + "}").join(n);
				i++;
			}
			return mess;
		}
		
		public function get context():String { return _context; }
		
		public function get reporter():Object { return _reporter; }
		
	}
	
}