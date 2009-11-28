package mx.styles 
{
	[ExcludeClass]
	
	/**
	 * StyleManagerImpl class.
	 * We need this to cut off framework dependencies.
	 * @author wvxvw
	 */
	public class StyleManagerImpl implements IStyleManager2
	{
		public function StyleManagerImpl(o:Object) { super(); }
		
		public static function getInstance():IStyleManager2 { return null; };
		
		/* INTERFACE mx.styles.IStyleManager2 */
		
		public function registerInheritingStyle(style:Object):void { }
	}

}