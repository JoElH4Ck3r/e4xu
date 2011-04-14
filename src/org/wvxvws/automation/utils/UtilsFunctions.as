package org.wvxvws.automation.utils
{
	import org.wvxvws.automation.language.ParensPackage;

	public class UtilsFunctions
	{
		public function UtilsFunctions() { super(); }
		
		public static function print(...values):void
		{
			trace.apply(null, values);
		}
		
		public static function reflect(field:String, inScope:ParensPackage):*
		{
			return inScope.get(field);
		}
		
		public static function funcall(method:Function, ...parameters):*
		{
			return method.apply(null, parameters);
		}
	}
}