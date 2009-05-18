package org.wvxvws.encoding 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	//{imports
	
	//}
	/**
	* SWFCompiler class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class SWFCompiler 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static var signature:String = "\x46\x57\x53";
		public static var version:uint = 0x9;
		public static var fileLength:uint = 0;
		public static var frameRect:String = "\x78\x00\x07\xD0\x00\x00\x17\x70\x00";
		public static var frameRate:uint = 0x1F;
		public static var frameCount:uint = 0x1;
		public static var fileAttributes:String = 
		"\x44\x11\x08\x00\x00\x00\x43\x02\xFF\xFF\xFF\xBF\x15\x0B\x00\x00\x00\x01\x00";
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var swf:ByteArray;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SWFCompiler() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function compileDictionary(input:ByteArray, 
									tagType:uint, complete:Boolean = true):ByteArray
		{
			swf = new ByteArray();
			swf.endian = Endian.LITTLE_ENDIAN;
			writeFromString(signature, swf);
			swf.writeByte(version);
			swf.writeUnsignedInt(fileLength);
			writeFromString(frameRect, swf);
			swf.writeShort(frameRate);
			swf.writeShort(frameCount);
			writeFromString(fileAttributes, swf);
			// need to put proper tag header here
			input.writeBytes(swf, swf.position, input.length);
			if (complete) // end tag
			{
				swf.writeByte(0);
				swf.writeByte(0);
				swf.writeByte(0);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function writeFromString(input:String, data:ByteArray):void
		{
			var i:int = -1;
			var il:int = input.length - 1;
			while (i++ < il) data.writeByte(input.charCodeAt(i));
		}
	}
	
}