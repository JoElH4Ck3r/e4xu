package mx.styles 
{
	[ExcludeClass]
	
	/**
	 * IStyleManager2 interface.
	 * We need this to cut off framework dependencies.
	 * @author wvxvw
	 */
	public interface IStyleManager2 
	{
		function registerInheritingStyle(style:Object):void;
	}
	
}