package org.wvxvws.automation.strings
{
	public class StringFunctions
	{
		public function StringFunctions() { super(); }
		
		public static function concat(...params):String
		{
			trace("concatenating:", params);
			return params.join("");
		}
	}
}