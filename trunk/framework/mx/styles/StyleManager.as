package mx.styles 
{
	[ExcludeClass]
	
	/**
	 * StyleManager class.
	 * We need this to cut off framework dependencies.
	 * @author wvxvw
	 */
	public class StyleManager
	{
		public function StyleManager() { super(); }
		
		public static function registerInheritingStyle(a:String):void { }
		
		public static function getStyleDeclaration(a:String):* { return null; }
	}

}