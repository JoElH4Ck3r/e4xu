package org.wvxvws.encoding.tags 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class DefineVideoStream extends SWFTag
	{
		/**
		 * UI16 ID for this video character.
		 */
		public var characterID:uint;
		
		/**
		 * UI16 Number of VideoFrame tags that makes up this stream.
		 */
		public var numFrames:uint;
		
		/**
		 * UI16 Width in pixels.
		 */
		public var width:int;
		
		/**
		 * UI16 Height in pixels.
		 */
		public var height:int;
		
		/**
		 * UB[4] Must be 0.
		 */
		public var videoFlagsReserved:int;
		
		/**
		 * UB[3] 	000 = use VIDEOPACKET value
		 * 			001 = off
		 * 			010 = Level 1 (Fast deblocking filter)
		 * 			011 = Level 2 (VP6 only, better deblocking filter)
		 * 			100 = Level 3 (VP6 only, better deblocking plus fast deringing filter)
		 * 			101 = Level 4 (VP6 only, better deblocking plus better deringing filter)
		 * 			110 = Reserved
		 * 			111 = Reserved
		 */
		public var videoFlagsDeblocking:int;
		
		/**
		 * UB[1] 	0 = smoothing off (faster)
		 * 			1 = smoothing on (higher quality)
		 */
		public var videoFlagsSmoothing:int;
		
		/**
		 * UI8 		2 = Sorenson H.263
		 * 			3 = Screen video (SWF 7 and later only)
		 * 			4 = VP6 (SWF 8 and later only)
		 * 			5 = VP6 video with alpha channel (SWF 8 and later only)
		 */
		public var codecID:int;
		
		public function DefineVideoStream() { super(60); }
		
		
		public override function compile(bytes:ByteArray = null):ByteArray
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
			_data = temp;
			return temp;
		}
		
		/**
		 * "\x0A\x0F"                 | "\x01\x00" | "\x9E\x01" | "\x40\x01"  | "\xF0\x00" | "\x00"  | "\x04" |
		 * "\x3F\x0F\x0A\x00\x00\x00" | "\x01\x00" | "\x9E\x01" | "\x40\x01"  | "\xF0\x00" | "\x00"  | "\x04" |
		 * |------ define tag --------|---- id ----|-- frames --|--- width ---|-- height --|- flags -|- codec |
		 */
		protected override function compileTagParams():void
		{
			_data.writeShort(characterID);
			_data.writeShort(numFrames);
			_data.writeShort(width);
			_data.writeShort(height);
			var flags:uint = (videoFlagsDeblocking << 3) | videoFlagsSmoothing;
			_data.writeByte(flags);
			_data.writeByte(codecID);
		}
	}
	
}