﻿package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * DoABC class.
	 * @author wvxvw
	 */
	public class DoABC extends SWFTag
	{
		public var flags:uint;
		
		// TODO: Implement real bytecode parsing and writting
		// this is a temproraly fix that will allow 
		// embedding sounds only!
		// \xbf\x14\xbc\x00\x00\x00
		private var dataStart:String = "\x01\x00\x00\x00\x00\x10\x00\x2e\x00\x00\x00\x00\x08\x00\x08";
		
		public var embeddedSoundName:String = ""; // Should be ASCII, 8 chars long only!
		
		private var dataEnd:String = "\x0b\x66\x6c\x61\x73\x68"
				+ "\x2e\x6d\x65\x64\x69\x61\x05\x53\x6f\x75\x6e\x64\x06\x4f\x62\x6a\x65\x63\x74"
				+ "\x0c\x66\x6c\x61\x73\x68\x2e\x65\x76\x65\x6e\x74\x73\x0f\x45\x76\x65\x6e\x74"
				+ "\x44\x69\x73\x70\x61\x74\x63\x68\x65\x72\x05\x16\x01\x16\x03\x18\x02\x16\x06"
				+ "\x00\x05\x07\x01\x02\x07\x02\x04\x07\x01\x05\x07\x04\x07\x03\x00\x00\x00\x00"
				+ "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x01\x02\x08\x03\x00\x01\x00\x00\x00"
				+ "\x01\x02\x01\x01\x04\x01\x00\x03\x00\x01\x01\x05\x06\x03\xd0\x30\x47\x00\x00"
				+ "\x01\x01\x01\x06\x07\x06\xd0\x30\xd0\x49\x00\x47\x00\x00\x02\x02\x01\x01\x05"
				+ "\x17\xd0\x30\x65\x00\x60\x03\x30\x60\x04\x30\x60\x02\x30\x60\x02\x58\x00\x1d"
				+ "\x1d\x1d\x68\x01\x47\x00\x00";
		
		public function DoABC() { super(82); }
		
		override protected function compileTagParams():void 
		{
			//_data.writeUnsignedInt(flags);
			var i:int = -1;
			var concatenated:String = dataStart + embeddedSoundName + dataEnd;
			while (i++ < 188)
			{
				_data.writeByte(concatenated.charCodeAt(i));
			}
		}
	}
	
}