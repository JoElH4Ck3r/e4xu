package org.wvxvws.automation.syntax
{
	public class NumberReader
	{
		
		/**
		 * numeric-token  ::=  integer |
		 * 				   ratio   |
		 * 				   float       
		 * integer        ::=  [sign]
		 * 				   decimal-digit+
		 * 				   decimal-point |
		 * 				   [sign]
		 * 				   digit+      
		 * ratio          ::=  [sign]
		 * 				   {digit}+
		 * 				   slash
		 * 				   {digit}+    
		 * float          ::=  [sign]
		 * 				   {decimal-digit}*
		 * 				   decimal-point
		 * 				   {decimal-digit}+
		 * 				   [exponent]  
		 *                     | 
		 * 				   [sign]
		 * 				   {decimal-digit}+
		 * 				   [decimal-point
		 * 					   {decimal-digit}*]
		 * 				   exponent    
		 * exponent       ::=  exponent-marker
		 * 				   [sign]
		 * 				   {digit}+   
		 * 
		 */
		public function NumberReader() { }
		
		public static function isNumeric(input:String):Boolean
		{
			return input.length && 
				(isInteger(input) || isRatio(input) || isFloat(input));
		}
		
		public static function isInteger(input:String):Boolean
		{
			return isPointInteger(input) || isNoPointInteger(input);
		}
		
		public static function isRatio(input:String):Boolean
		{
			var read:int = signedPart(input);
			
			return read && isSlash(input.substr(read)) &&
				isNoPointInteger(input.substr(read + 1));
		}
		
		public static function isFloat(input:String):Boolean
		{
			return isExponentFloat(input) || isNoExponentFloat(input);
		}
		
		private static function isPointInteger(input:String):Boolean
		{
			var index:int = oneOrLess(input, isSign);
			var decimals:int = oneOrMore(input.substr(index), isDecimalDigit);
			
			return decimals + 
				int(isDecimalPoint(input.substr(index + decimals))) == input.length;
		}
		
		private static function isNoPointInteger(input:String):Boolean
		{
			return signedPart(input) == input.length;
		}
		
		private static function signedPart(input:String):int
		{
			var sign:int = oneOrLess(input, isSign);
			return sign + oneOrMore(input.substr(sign), isDigit);
		}
		
		private static function isExponentFloat(input:String):Boolean
		{
			var result:Boolean;
			var index:int = oneOrLess(input, isSign);
			var decimals:int = oneOrMore(input.substr(index), isDecimalDigit);
			
			if (isDecimalPoint(input.substr(index + decimals)))
			{
				decimals += index + 1;
				index = oneOrMore(input.substr(index), isDecimalDigit);
				if (index) result = isExponent(input.substr(index + decimals));
			}
			return result;
		}
		
		private static function isNoExponentFloat(input:String):Boolean
		{
			var result:Boolean;
			var index:int = oneOrLess(input, isSign);
			var decimals:int = oneOrMore(input.substr(index), isDecimalDigit);
			
			if (isDecimalPoint(input.substr(index + decimals)))
			{
				decimals += index + 1;
				result = decimals + 
					oneOrMore(input.substr(index), isDecimalDigit) == input.length;
			}
			else result = decimals + index == input.length;
			return result;
		}
		
		private static function isExponent(input:String):Boolean
		{
			return isExponentMarker(input.charAt()) && 
				isNoPointInteger(input.substr(1));
		}
		
		private static function isDigit(input:String):Boolean
		{
			return "0123456789ABCDEFGHIJKLMOPQRSTUVWXYZ".substr(
				0, Reader.currentInputRadix).indexOf(
					input.charAt().toUpperCase()) > -1;
		}
		
		private static function isDecimalPoint(input:String):Boolean
		{
			return input.charAt() == ".";
		}
		
		private static function isSlash(input:String):Boolean
		{
			return input.charAt() == "/";
		}
		
		private static function isSign(input:String):Boolean
		{
			return input == "+" || input == "-";
		}
		
		private static function isDecimalDigit(input:String):Boolean
		{
			return "1234567890".indexOf(input) > -1;
		}
		
		private static function isExponentMarker(input:String):Boolean
		{
			return "DEFLS".indexOf(input.toUpperCase()) > -1;
		}
		
		private static function oneOrLess(input:String, tester:Function):int
		{
			return int(tester(input.charAt()));
		}
		
		private static function oneOrMore(input:String, tester:Function):int
		{
			var result:Boolean = tester(input.charAt());
			var spaces:int;
			
			while (result && input.length > spaces)
			{
				spaces++;
				result = tester(input.charAt(spaces));
			}
			return spaces;
		}
	}
}