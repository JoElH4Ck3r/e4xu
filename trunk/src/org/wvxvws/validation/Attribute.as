package org.wvxvws.validation 
{
	import org.wvxvws.validation.validation_internal;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Attribute 
	{
		protected var _rule:Rule;
		protected var _index:int;
		protected var _nameSpace:String;
		protected var _values:Rule;
		protected var _error:ValidationError;
		protected var _uniqueValues:Boolean;
		protected var _uniqueKeys:Dictionary;
		
		public function Attribute(name:Rule, values:Rule = null, 
						nameSpace:String = "", uniqueValues:Boolean = false) 
		{
			super();
			_rule = name;
			_values = values;
			_nameSpace = nameSpace;
			_uniqueValues = uniqueValues;
		}
		
		public function startValidate():void
		{
			if (_uniqueValues) _uniqueKeys = new Dictionary();
		}
		
		public function validate(name:String, value:String):Boolean
		{
			_error = null;
			if (_rule && !_rule.validate(name))
			{
				_error = new ValidationError(
					ValidationError.BAD_NAME, name, _rule.toString());
				_error.validation_internal::setContext(name, this);
				return false;
			}
			if (_values && !_values.validate(value))
			{
				_error = _values.error;
				return false;
			}
			if (_uniqueKeys && _uniqueKeys[value])
			{
				_error = new ValidationError(ValidationError.NON_UNIQUE_VALUES, value);
				_error.validation_internal::setContext(name, this);
				return false;
			}
			else if (_uniqueKeys)
			{
				_uniqueKeys[value] = value;
			}
			return true;
		}
		
		validation_internal function setIndex(index:int):void { _index = index; }
		
		public function get index():int { return _index; }
		
		public function get nameSpace():String { return _nameSpace; }
		
		public function get error():ValidationError { return _error; }
		
		public function toString():String
		{
			return "Attribute-<" + _rule + " = " + _values + ">";
		}
	}
	
}