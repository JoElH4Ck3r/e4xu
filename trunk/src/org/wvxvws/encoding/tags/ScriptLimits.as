package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * ScriptLimits class.
	 * @author wvxvw
	 */
	public class ScriptLimits extends SWFTag
	{
		public var maxRecursionDepth:uint = 0xFF; //UI16
		public var scriptTimeoutSeconds:uint = 0xE; //UI16
		
		public function ScriptLimits() { super(65); }
		
		override protected function compileTagParams():void 
		{
			_data.writeShort(maxRecursionDepth);
			_data.writeShort(scriptTimeoutSeconds);
		}
		
	}
	
}