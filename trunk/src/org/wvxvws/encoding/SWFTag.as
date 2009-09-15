package org.wvxvws.encoding 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * SWFTag class.
	 * @author wvxvw
	 */
	public class SWFTag
	{
		//public var name:String;
		
		private static var _generator:int;
		
		protected var _code:int;
		protected var _data:ByteArray;
		protected var _length:uint;
		
		private var _symbolID:uint = uint.MAX_VALUE;
		
		// TODO: why cannot we use other values?
		protected function get symbolID():uint { return 1; }
		
		public function get code():int { return _code; }
		
		public function get length():int { return _length; }
		
		public function get data():ByteArray { return _data; }
		
		public function SWFTag(code:int) 
		{
			super();
			_code = code;
		}
		
		public function compile(bytes:ByteArray = null):ByteArray
		{
			_data = new ByteArray()
			_data.endian = Endian.LITTLE_ENDIAN;
			var temp:ByteArray = new ByteArray();
			temp.endian = Endian.LITTLE_ENDIAN;
			compileTagParams();
			if (bytes) _data.writeBytes(bytes);
			_length = _data.length;
			_data.position = 0;
			if (_length < 63)
			{
				temp.writeShort((_code << 6) | _length);
			}
			else
			{
				temp.writeShort((_code << 6) | 63);
				temp.writeUnsignedInt(_length);
			}
			temp.writeBytes(_data);
			temp.position = 0;
			_data = temp;
			return temp;
		}
		
		/**
		 * Override this function in extending classes to
		 * place additional tag header data here.
		 */
		protected virtual function compileTagParams():void { }
		
		private static function generateSymbolID():uint { return ++_generator; }
	}
	
}