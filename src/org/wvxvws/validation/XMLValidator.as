package org.wvxvws.validation 
{
	import flash.events.EventDispatcher;
	
	[Event(name="", type="")]
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class XMLValidator extends EventDispatcher
	{
		protected var _error:ValidationError;
		protected var _errorContext:XML;
		
		public function XMLValidator(errorHandler:Function = null)
		{
			super();
			if (errorHandler != null)
			{
				super.addEventListener(
			}
		}
		
		public function validate(xml:XML, against:Node):Boolean
		{
			_errorHandler = errorHandler;
			return against.validate(xml);
		}
		
		public function get error():ValidationError { return _error; }
		
		internal function setError(error:ValidationError, context:XML):void
		{
			_error = error;
			_errorContext = context;
			dispatchEvent(new ValidationErrorEvent(error, context));
		}
	}
	
}