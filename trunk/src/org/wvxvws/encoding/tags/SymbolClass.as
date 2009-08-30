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