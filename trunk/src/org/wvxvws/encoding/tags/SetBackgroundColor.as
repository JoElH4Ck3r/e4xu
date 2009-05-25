package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * SetBackgroundColor class.
	 * @author wvxvw
	 */
	public class SetBackgroundColor extends SWFTag
	{
		public var color:uint = 0xFFFFFF; //U24
		
		public function SetBackgroundColor() { super(9); }
		
		override protected function compileTagParams():void 
		{
			_data.writeByte(color >> 0x10);
			_data.writeByte((color >> 0x8) ^ 0xFF00);
			_data.writeByte((color | 0xFFFF00) ^ 0xFFFF00);
		}
	}
	
}