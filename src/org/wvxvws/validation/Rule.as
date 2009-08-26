package org.wvxvws.validation 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Rule 
	{
		protected var _regex:RegExp;
		protected var _enum:Dictionary;
		protected var _error:ValidationError;
		
		public function Rule(regex:RegExp = null, enum:Dictionary = null) 
		{
			super();
			_regex = regex;
			_enum = enum;
		}
		
		public function validate(text:String):Boolean
		{
			_error = null;
			//trace(">>>>> RULE", toString());
			if (_regex)
			{
				if (!text.match(_regex))
				{
					_error = new ValidationError(ValidationError.BAD_TEXT, text, _regex);
					_error.validation_internal::setContext(text, this);
					return false;
				}
				return true;
			}
			if (_enum)
			{
				var rules:String = "";
				for (var obj:Object in _enum)
				{
					if (text.match(obj)) return true;
					rules += rules ? "|" + obj.toString() : obj.toString();
				}
				_error = new ValidationError(ValidationError.BAD_TEXT, text, rules);
				_error.validation_internal::setContext(text, this);
				return false;
			}
			return true;
		}
		
		public function toString():String
		{
			if (_regex) return _regex.source;
			var s:String = "";
			for (var obj:Object in _enum)
			{
				s += s ? "|" + obj : obj;
			}
			return s;
		}
		
		public function get regex():RegExp { return _regex; }
		
		public function get enum():Dictionary { return _enum; }
		
		public function get error():ValidationError { return _error; }
	}
	
}