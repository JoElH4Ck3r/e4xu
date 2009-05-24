package org.wvxvws.encoding.tags 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * DefineSceneAndFrameLabelData class.
	 * @author wvxvw
	 */
	public class DefineSceneAndFrameLabelData extends SWFTag
	{
		public var sceneCount:uint; // EncodedUI32
		public var offsets:Array /* of uint */; // EncodedUI32
		public var names:Array /* of String */;
		public var frameLabelCount:uint; // EncodedUI32
		public var frameNums:Array /* uint */; // EncodedUI32
		public var frameLabels:Array /* String */; // EncodedUI32
		
		// \xBF\x15\x0B\x00\x00\x00
		private var _temp:String = "\x01\x00\x53\x63\x65\x6e\x65\x20\x31\x00\x00";
		
		public function DefineSceneAndFrameLabelData() { super(86); }
		
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
		
		override protected function compileTagParams():void 
		{
			var i:int = -1;
			while (i++ < 10)
			{
				_data.writeByte(_temp.charCodeAt(i));
			}
		}
		
		// TODO: Need to implement this
		// orginal function signature: int GetEncodedU32(unsigned char*& pos)
		protected function getEncodedU32(char:uint, bits:Array /* of uint */):int
		{
			var pos:int;
			var result:int = bits[0];
			if (!(result & 0x00000080))
			{
				pos++;
				return result;
			}
			result = (result & 0x0000007f) | bits[1] << 7;
			if (!(result & 0x00004000))
			{
				pos += 2;
				return result;
			}
			result = (result & 0x00003fff) | bits[2] << 14;
			if (!(result & 0x00200000))
			{
				pos += 3;
				return result;
			}
			result = (result & 0x001fffff) | bits[3] << 21;
			if (!(result & 0x10000000))
			{
				pos += 4;
				return result;
			}
			result = (result & 0x0fffffff) | bits[4] << 28;
			pos += 5;
			return result;
		}
	}
	
}