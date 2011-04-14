package org.wvxvws.automation.logic
{
	public class LogicFunctions
	{
		public function LogicFunctions() { super(); }
		
		// TODO: throw if less then one argument
		public static function and(...values):Boolean
		{
			var result:Boolean = true;
			for each (var value:Boolean in values)
			{
				result = value;
				if (!result) break;
			}
			return result;
		}
		
		// TODO: throw if less then one argument
		public static function or(...values):Boolean
		{
			var result:Boolean = true;
			for each (var value:Boolean in values)
			{
				result = value;
				if (result) break;
			}
			return result;
		}
		
		public static function not(value:Boolean):Boolean
		{
			return !value;
		}
		
		public static function eq(...values):Boolean
		{
			var result:Boolean = true;
			
			for (var i:int; i < values.length - 1; i++)
			{
				if (values[i] != values[i + 1])
				{
					result = false;
					break;
				}
			}
			return result;
		}
		
		// Well, we don't have lazy calculations, what did you think it will do? :)
		public static function condition(value:Boolean, trueValue:Object, 
			falseValue:Object = null):Object
		{
			var result:Object;
			if (value) result = trueValue;
			else if (falseValue) result = falseValue;
			return result;
		}
	}
}