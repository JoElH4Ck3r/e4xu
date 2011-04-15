package org.wvxvws.automation.utils
{
	import flash.utils.getDefinitionByName;
	
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
		
		public static function resolveClass(className:String):Class
		{
			return getDefinitionByName(className) as Class;
		}
		
		public static function slotValue(scope:Object, slotName:String):*
		{
			return scope[slotName];
		}
		
		public static function setSlot(scope:Object, slotName:String, slotValue:*):*
		{
			return scope[slotName] = slotValue;
		}
		
		public static function funcall(method:Function, ...parameters):*
		{
			return method.apply(null, parameters);
		}
	}
}