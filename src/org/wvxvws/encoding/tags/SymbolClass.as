package org.wvxvws.encoding.tags 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * SymbolClass class.
	 * @author wvxvw
	 */
	public class SymbolClass extends SWFTag
	{
		// TODO: figure out why this tag may have long RECORDHEADER
		// when it's shorter than 63 bytes.
		// should it always be of a long type?
		public var numSymbols:uint;
		public var tagIDs:Array /* of uint */;
		public var classNames:Array /* of String */;
		
		/*
		 * \x3F\x13\x1E\x00\x00\x00  - RECORDHEADER
		 * \x01\x00 				 - numSymbols
		 * [\x00\x00] 				 - tagIDs
		 * ----------------------------------------
		 * [\x65\x6D\x62\x65\x64\x64 - classNames
		 *   e    m   b   e   d   d
		 *  \x65\x64\x5F\x66\x6C\x61
		 *    e   d   _   f   l   a
		 *  \x2E\x4D\x61\x69\x6E\x54
		 *    .   M   a   i   n   T 
		 *  \x69\x6D\x65\x6C\x69\x6E\x65
		 *    i   m   e   l   i   n   e
		 * \x00]
		 */
		public function SymbolClass() { super(76); }
		
		override public function compile(bytes:ByteArray = null):ByteArray 
		{
			_data = new ByteArray()
			_data.endian = Endian.LITTLE_ENDIAN;
			var temp:ByteArray = new ByteArray();
			temp.endian = Endian.LITTLE_ENDIAN;
			compileTagParams();
			if (bytes) _data.writeBytes(bytes);
			_length = _data.length;
			_data.position = 0;
			temp.writeShort((_code << 6) | 63);
			temp.writeUnsignedInt(_length);
			temp.writeBytes(_data);
			temp.position = 0;
			return temp;
		}
		
		protected override function compileTagParams():void 
		{
			var i:int;
			var il:int = tagIDs.length;
			//_data.writeShort(_symbolID);
			_data.writeShort(numSymbols);
			for (i = 0; i < il; i++)
			{
				_data.writeShort(tagIDs[i]);
				_data.writeUTFBytes(classNames[i]);
			}
			_data.writeByte(0);
		}
	}
	
}