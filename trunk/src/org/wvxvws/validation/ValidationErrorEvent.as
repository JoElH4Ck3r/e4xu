package org.wvxvws.validation 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class ValidationErrorEvent extends ErrorEvent 
	{
		protected var _type:String = "";
		protected var _error:ValidationError;
		protected var _context:XML;
		
		public function ValidationErrorEvent(error:ValidationError, context:XML, 
					bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable, error.message);
			_error = error;
		} 
		
		public override function clone():Event 
		{ 
			return new ValidationErrorEvent(_error, _context, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ValidationErrorEvent", "type", "text"); 
		}
		
		public function get error():ValidationError { return _error; }
		
		public function get context():XML { return _context; }
		
	}
	
}