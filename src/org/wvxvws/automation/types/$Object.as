package org.wvxvws.automation.types
{
	import org.wvxvws.automation.language.Atom;
	
	public class $Object extends Atom
	{
		protected const _immediateSuperclasses:Vector.<$Class> = new <$Class>[];
		
		public function $Object(name:String, type:Object)
		{
			super(name, type);
		}
		
		public static function makeInstance(ofClass:$Class, ...intiFrom):$Object
		{
			return ofClass.makeInstance(intiFrom);
		}
		
		public static function isA(who:$Object, what:$Class):Boolean
		{
			var result:Boolean;
			
			for each (var aClass:$Class in who._immediateSuperclasses)
			{
				if (aClass === what || isA(who, aClass))
				{
					result = true;
					break;
				}
			}
			return result;
		}
	}
}