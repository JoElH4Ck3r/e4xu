package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * DefineSound class.
	 * @author wvxvw
	 */
	public class DefineSound extends SWFTag
	{
		public var soundFormat:uint;
		public var soundRate:uint;
		public var soundSize:uint;
		public var soundType:uint;
		
		public var sampleCount:uint;
		
		public function DefineSound() { super(14); }
		
		override protected function compileTagParams():void 
		{
			var u:uint;
			u = (soundFormat | (u << 4)); // write 4 bits <SoundFormat>
			u = (soundRate | (u << 2)); // write 2 bits <SoundRate>
			u = (soundSize | (u << 1)); // write 1 bit <SoundSize>
			u = (soundType | (u << 1)); // write 1 bit <SoundType>
			_data.writeShort(symbolID);
			trace("_symbolID", symbolID);
			_data.writeByte(u);
			_data.writeUnsignedInt(sampleCount);
		}
		
	}
	
}