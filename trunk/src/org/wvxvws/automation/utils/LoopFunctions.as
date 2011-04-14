package org.wvxvws.automation.utils
{
	public class LoopFunctions
	{
		public function LoopFunctions() { super(); }
		
		public static function dotimes(times:uint, what:Function, ...values):void
		{
			while (times--)
			{
				// TODO: should use LanguageFunctions to resolve the scope properly.
				what.apply(null, values);
			}
		}
	}
}