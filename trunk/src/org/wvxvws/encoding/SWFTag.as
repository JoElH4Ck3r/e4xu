package org.wvxvws.encoding 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class SWFTag
	{
		private var _code:int;
		private var _data:ByteArray;
		private var _length:uint;
		
		public function SWFTag(code:int) 
		{
			super();
			_code = code;
		}
		
		public function compile(bytes:ByteArray):ByteArray
		{
			_data = new ByteArray()
			_data.endian = Endian.LITTLE_ENDIAN;
			_data.position = 0;
			_length = bytes.length;
			if (_length < 63)
			{
				_data.writeShort((_code << 10) | _length);
			}
			else
			{
				_data.writeShort((_code << 10) | 63);
				_data.writeUnsignedInt(_length);
			}
			_data.writeBytes(bytes, _data.length, bytes.length);
			return _data;
		}
		
		public function get code():int { return _code; }
		
		public function get length():int { return _length; }
		
		public function get data():ByteArray { return _data; }
		
	}
	
}