package org.wvxvws.encoding 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class FLVTranscoder 
	{
		private static var _version:int;
		private static var _hasVideo:Boolean;
		private static var _hasAudio:Boolean;
		
		private static var _pointer:int;
		private static var _error:Error;
		private static var _frames:Array;
		
		public function FLVTranscoder() { super(); }
		
		public static function read(input:ByteArray):Array
		{
			var fileStart:int;
			if (input.length < 9) 
			{
				_error = new Error("Not enough bytes");
				return;
			}
			_frames = [];
			if ((fileStart = readHeader(input)) < 9) 
			{
				_error = new Error("Cannot read header");
				return;
			}
			input.position = fileStart;
			_error = readBody(input);
			if (!_error) return _frames;
			return null;
		}
		
		/**
		 * HEADER
		 * Signature 			UI8 			Signature byte always 'F' (0x46)
		 * Signature 			UI8 			Signature byte always 'L' (0x4C)
		 * Signature 			UI8 			Signature byte always 'V' (0x56)
		 * Version 				UI8 			File version (for example, 0x01 for FLV version 1)
		 * TypeFlagsReserved 	UB[5] 			Must be 0
		 * TypeFlagsAudio 		UB[1] 			Audio tags are present
		 * TypeFlagsReserved 	UB[1] 			Must be 0
		 * TypeFlagsVideo 		UB[1] 			Video tags are present
		 * DataOffset 			UI32 			Offset in bytes from start of file to start
		 * 										of body (that is, size of header)
		 */
		private static function readHeader(input:ByteArray):uint
		{
			var headerChars:String;
			if (input.readUnsignedByte() === 0x46 &&
				input.readUnsignedByte() === 0x4C &&
				input.readUnsignedByte() === 0x56)
			{
				_version = input.readUnsignedByte();
				headerChars = input.readUnsignedByte().toString(2);
				if (headerChars.charAt(5) !== "0")
				{
					_hasAudio = true;
				}
				if (headerChars.charAt(7) !== "0")
				{
					_hasVideo = true;
				}
				_pointer = input.position + 4;
				return input.readUnsignedInt();
			}
			input.position = 0;
			_pointer = 0;
			return 0;
		}
		
		/**
		 * BODY
		 * PreviousTagSize0 	UI32 			Always 0
		 * Tag1 				FLVTAG 			First tag
		 * PreviousTagSize1 	UI32 			Size of previous tag, including its
		 * 										header. For FLV version 1, this value
		 * 										is 11 plus the DataSize of the previous tag.
		 * Tag2 				FLVTAG 			Second tag
		 * ...
		 * PreviousTagSizeN-1 	UI32 			Size of second-to-last tag
		 * TagN 				FLVTAG 			Last tag
		 * PreviousTagSizeN 	UI32 			Size of last tag
		 */
		private static function readBody(input:ByteArray):Error
		{
			var nextTagStart:uint = input.position + 4;
			var tagByres:ByteArray = new ByteArray();
			var tagLength:int;
			while (tagLength = readTag(tagByres.writeBytes(input, nextTagStart, tagLength)))
			{
				nextTagStart += nextTagStart; 
			}
			return null;
		}
		
		/**
		 * FLVTAG
		 * TagType 				UI8 			Type of this tag. Values are:
		 * 										8: audio
		 * 										9: video
		 * 										18: script data
		 * 										all others: reserved
		 * DataSize 			UI24 			Length of the data in the Data field
		 * Timestamp 			UI24 			Time in milliseconds at which the
		 * 										data in this tag applies. This value is
		 * 										relative to the first tag in the FLV
		 * 										file, which always has a timestamp of 0.
		 * TimestampExtended 	UI8 			Extension of the Timestamp field to
		 * 										form a UI32 value. This field
		 * 										represents the upper 8 bits, while
		 * 										the previous Timestamp field
		 * 										represents the lower 24 bits of the
		 * 										time in milliseconds.
		 * StreamID 			UI24 			Always 0
		 * Data 				If TagType = 8	Body of the tag
		 * 						AUDIODATA
		 * 						If TagType = 9
		 * 						VIDEODATA
		 * 						If TagType = 18
		 * 						SCRIPTDATAOBJECT
		 */
		private static function readTag(input:ByteArray, from:uint):uint
		{
			if (!input.length) return 0;
			var tagType:int;
			var dataSize:int;
			var timeStamp:uint;
			var data:ByteArray;
			
			return 11 + dataSize;
		}
		
		private static function readAudio(input:ByteArray):void
		{
			
		}
		
		/*
		 * FrameType UB[4] 1: keyframe (for AVC, a seekable frame)
		 * 2: inter frame (for AVC, a nonseekable frame)
		 * 3: disposable inter frame (H.263 only)
		 * 4: generated keyframe (reserved for server use only)
		 * 5: video info/command frame
		 * CodecID UB[4] 1: JPEG (currently unused)
		 * 2: Sorenson H.263
		 * 3: Screen video
		 * 4: On2 VP6
		 * 5: On2 VP6 with alpha channel
		 * 6: Screen video version 2
		 * 7: AVC
		 * VideoData If CodecID = 2
		 * H263VIDEOPACKET
		 * If CodecID = 3
		 * SCREENVIDEOPACKET
		 * If CodecID = 4
		 * VP6FLVVIDEOPACKET
		 * If CodecID = 5
		 * VP6FLVALPHAVIDEOPACKET
		 * If CodecID = 6
		 * SCREENV2VIDEOPACKET
		 * if CodecID = 7
		 * AVCVIDEOPACKET
		 * Video frame payload
		 * (see note following table)
		 */
		private static function readVideo(input:ByteArray):void
		{
			
		}
		
		private static function readScript(input:ByteArray):void
		{
			
		}
	}
	
}