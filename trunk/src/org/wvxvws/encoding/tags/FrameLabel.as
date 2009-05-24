package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * FrameLabel class.
	 * @author wvxvw
	 */
	public class FrameLabel extends SWFTag
	{
		public var label:String = ""; // must not be null
		
		public function FrameLabel() { super(43); }
		
		override protected function compileTagParams():void 
		{
			_data.writeUTFBytes(label);
			_data.writeByte(0);
		}
		
	}
	
}