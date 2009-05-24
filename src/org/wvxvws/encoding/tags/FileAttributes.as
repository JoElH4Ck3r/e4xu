package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * FileAttributes class.
	 * @author wvxvw
	 */
	public class FileAttributes extends SWFTag
	{
		public var resrved1:uint; //UB1
		public var useDirectBit:uint; //UB1 0 for FP9, 1 for FP 10
		public var useGPU:uint; //UB1 0 for FP9, 1 for FP 10
		public var hasMetadata:uint; //UB1 we don't care about metadata
		public var actionScript3:uint = 1;
		public var reserved2:uint; //UB2
		public var useNetwork:uint = 1; //UB1
		public var reserved3:uint; //UB24
		
		public function FileAttributes() { super(69); }
		
		override protected function compileTagParams():void 
		{
			var u:uint;
			u = (resrved1 | (u << 1)); // write 1 bits <Resrved1>
			u = (useDirectBit | (u << 1)); // write 1 bits <UseDirectBit>
			u = (useGPU | (u << 1)); // write 1 bit <UseGPU>
			u = (hasMetadata | (u << 1)); // write 1 bit <HasMetadata>
			u = (actionScript3 | (u << 1)); // write 1 bit <ActionScript3>
			u = (reserved2 | (u << 2)); // write 1 bit <Reserved2>
			u = (useNetwork | (u << 1)); // write 1 bit <Reserved2>
			_data.writeByte(u);
			_data.writeByte(0);
			_data.writeByte(0);
			_data.writeByte(0);
		}
		
	}
	
}