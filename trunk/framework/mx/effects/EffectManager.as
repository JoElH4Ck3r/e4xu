package mx.effects 
{
	import mx.core.mx_internal;
	
	[ExcludeClass]
	
	/**
	 * EffectManager class. 
	 * We need this to cut off framework dependencies.
	 * @author wvxvw
	 */
	public class EffectManager
	{
		public function EffectManager() { super(); }
		
		mx_internal static function registerEffectTrigger(a:String, b:String):void {}
	}

}