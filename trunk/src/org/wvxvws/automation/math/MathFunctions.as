package org.wvxvws.automation.math
{
	public class MathFunctions
	{
		public function MathFunctions() { super(); }
		
		public static function plus(...rest):Number
		{
			var result:Number;
			var i:int;
			
			if (rest && rest.length)
			{
				for (i = 1, result = rest[0]; i < rest.length; i++)
					result += rest[i];
			}
			return result;
		}
		
		public static function minus(...rest):Number
		{
			var result:Number;
			var i:int;
			
			if (rest && rest.length)
			{
				for (i = 1, result = rest[0]; i < rest.length; i++)
					result -= rest[i];
			}
			return result;
		}
		
		public static function random(space:uint):uint
		{
			return Math.random() * space;
		}
		
		public static function greater(a:Number, b:Number):Boolean
		{
			return a > b;
		}
		
		public static function less(a:Number, b:Number):Boolean
		{
			return a < b;
		}
	}
}