package org.wvxvws.encoding 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.wvxvws.encoding.tags.SoundStreamHead;
	
	/**
	 * FLVTranscoder class.
	 * @author wvxvw
	 */
	public class FLVTranscoder 
	{
		public static function get videoCodec():int { return _videoCodec; }
		
		public static function get deblocking():int { return _deblocking; }
		
		public static function get smoothing():int { return _smoothing; }
		
		public static function get width():int { return _width; }
		
		public static function get height():int { return _height; }
		
		public static function get soundFrames():Vector.<ByteArray> { return _soundFrames; }
		
		public static function get soundPayLoad():ByteArray { return _soundPayLoad; }
		
		public static function get soundStreamHead():SoundStreamHead { return _soundStreamHead; }
		
		public static function get seekSamples():Vector.<int> { return _seekSamples; }
		
		public static function get sampleCounter():Vector.<int> { return _sampleCounter; }
		
		public static const CODEC_JPEG:int = 1;
		public static const CODEC_H263:int = 2;
		public static const CODEC_SCREEN_VIDEO:int = 3;
		public static const CODEC_VP6:int = 4;
		public static const CODEC_VP6_ALPHA:int = 5;
		public static const CODEC_SCREEN_VIDEO_2:int = 6;
		public static const CODEC_AVC:int = 7;
		
		private static var _version:int;
		private static var _hasVideo:Boolean;
		private static var _hasAudio:Boolean;
		private static var _videoCodec:int;
		private static var _deblocking:int;
		private static var _smoothing:int;
		private static var _width:int = 320;
		private static var _height:int = 240;
		
		private static var _pointer:int;
		private static var _error:Error;
		private static var _frames:Vector.<ByteArray>;
		private static var _soundFrames:Vector.<ByteArray>;
		private static var _soundStreamHead:SoundStreamHead;
		private static var _soundPayLoad:ByteArray;
		private static var _seekSamples:Vector.<int>;
		private static var _sampleCounter:Vector.<int>;
		
		public function FLVTranscoder() { super(); }
		
		public static function read(input:ByteArray):Vector.<ByteArray>
		{
			var fileStart:int;
			if (input.length < 9)
			{
				_error = new Error("Not enough bytes");
				return null;
			}
			_frames = new Vector.<ByteArray>(0, false);
			_soundFrames = new Vector.<ByteArray>(0, false);
			_soundStreamHead = null;
			_seekSamples = null;
			_soundPayLoad = new ByteArray();
			if ((fileStart = readHeader(input)) < 9)
			{
				_error = new Error("Cannot read header");
				return null;
			}
			input.position = fileStart;
			_error = readBody(input);
			if (!_error)
			{
				if (_soundStreamHead && 
					_soundStreamHead.streamSoundCompression === 0x2)
				{
					_soundFrames = new Vector.<ByteArray>(0, false);
					distributeAudioFrames();
				}
				return _frames;
			}
			return null;
		}
		
		/**
		 * <pre>
		 * HEADER
		 * -------------------------------------------------------------------------
		 * Signature 			UI8 			Signature byte always 'F' (0x46)
		 * -------------------------------------------------------------------------
		 * Signature 			UI8 			Signature byte always 'L' (0x4C)
		 * -------------------------------------------------------------------------
		 * Signature 			UI8 			Signature byte always 'V' (0x56)
		 * -------------------------------------------------------------------------
		 * Version 				UI8 			File version (for example, 
		 * 										0x01 for FLV version 1)
		 * -------------------------------------------------------------------------
		 * TypeFlagsReserved 	UB[5] 			Must be 0
		 * -------------------------------------------------------------------------
		 * TypeFlagsAudio 		UB[1] 			Audio tags are present
		 * -------------------------------------------------------------------------
		 * TypeFlagsReserved 	UB[1] 			Must be 0
		 * -------------------------------------------------------------------------
		 * TypeFlagsVideo 		UB[1] 			Video tags are present
		 * -------------------------------------------------------------------------
		 * DataOffset 			UI32 			Offset in bytes from start of file 
		 * 										to start of body (that is, 
		 * 										size of header)
		 * </pre>
		 */
		private static function readHeader(input:ByteArray):uint
		{
			var headerChars:String;
			if (input.readUnsignedByte() === 0x46 &&
				input.readUnsignedByte() === 0x4C &&
				input.readUnsignedByte() === 0x56)
			{
				_version = input.readUnsignedByte();
				headerChars = input.readUnsignedByte().toString(0x2);
				while (headerChars.length < 0x8) headerChars = "0" + headerChars;
				if (headerChars.charAt(0x5) !== "0")
				{
					_hasAudio = true;
				}
				if (headerChars.charAt(0x7) !== "0")
				{
					_hasVideo = true;
				}
				_pointer = input.position + 0x4;
				return input.readUnsignedInt();
			}
			input.position = 0;
			_pointer = 0;
			return 0;
		}
		
		/**
		 * <pre>
		 * BODY
		 * -------------------------------------------------------------------------
		 * PreviousTagSize0 	UI32 			Always 0
		 * -------------------------------------------------------------------------
		 * Tag1 				FLVTAG 			First tag
		 * -------------------------------------------------------------------------
		 * PreviousTagSize1 	UI32 			Size of previous tag, including its
		 * 										header. For FLV version 1, this 
		 * 										value is 11 plus the DataSize of the 
		 * 										previous tag.
		 * -------------------------------------------------------------------------
		 * Tag2 				FLVTAG 			Second tag
		 * ...
		 * -------------------------------------------------------------------------
		 * PreviousTagSizeN-1 	UI32 			Size of second-to-last tag
		 * -------------------------------------------------------------------------
		 * TagN 				FLVTAG 			Last tag
		 * -------------------------------------------------------------------------
		 * PreviousTagSizeN 	UI32 			Size of last tag
		 * -------------------------------------------------------------------------
		 * </pre>
		 */
		private static function readBody(input:ByteArray):Error
		{
			var nextTagStart:uint = input.position + 0x4;
			var tagLength:uint;
			var previousTag:uint;
			while (tagLength = readTag(input, nextTagStart))
			{
				nextTagStart += tagLength + 0x4;
				previousTag = input.readUnsignedInt();
			}
			return null;
		}
		
		/**
		 * <pre>
		 * FLVTAG
		 * -------------------------------------------------------------------------
		 * TagType 				UI8 			Type of this tag. Values are:
		 * 										8: audio
		 * 										9: video
		 * 										18: script data
		 * 										all others: reserved
		 * -------------------------------------------------------------------------
		 * DataSize 			UI24 			Length of the data in the Data field
		 * -------------------------------------------------------------------------
		 * Timestamp 			UI24 			Time in milliseconds at which the
		 * 										data in this tag applies. This value
		 * 										is relative to the first tag in the 
		 * 										FLV file, which always has a 
		 * 										timestamp of 0.
		 * -------------------------------------------------------------------------
		 * TimestampExtended 	UI8 			Extension of the Timestamp field to
		 * 										form a UI32 value. This field
		 * 										represents the upper 8 bits, while
		 * 										the previous Timestamp field
		 * 										represents the lower 24 bits of the
		 * 										time in milliseconds.
		 * -------------------------------------------------------------------------
		 * StreamID 			UI24 			Always 0
		 * -------------------------------------------------------------------------
		 * Data 				If TagType = 8	Body of the tag
		 * 							AUDIODATA
		 * 						If TagType = 9
		 * 							VIDEODATA
		 * 						If TagType = 18
		 * 							SCRIPTDATAOBJECT
		 * </pre>
		 * @param	input
		 * @param	from
		 * @return
		 */
		private static function readTag(input:ByteArray, from:uint):uint
		{
			if (from + 0xB >= input.length) return 0x0;
			input.position = from;
			var tagType:int = input.readUnsignedByte();
			if (tagType !== 0x8 && tagType !== 0x9 && tagType !== 0x12) return 0x0;
			var dataSize:int = ((input.readUnsignedByte() << 0x8) | 
								input.readUnsignedByte() << 0x8) | 
								input.readUnsignedByte();
			var timeStamp:uint = ((input.readUnsignedByte() << 0x8) | 
								input.readUnsignedByte() << 0x8) | 
								input.readUnsignedByte();
			var timestampExtended:uint = input.readUnsignedByte();
			var data:ByteArray;
			var streamID:uint = ((input.readUnsignedByte() << 0x8) | 
								input.readUnsignedByte() << 0x8) | 
								input.readUnsignedByte();
			switch (tagType)
			{
				case 0x8:
					readAudio(input, input.position, dataSize);
					break;
				case 0x9:
					readVideo(input, input.position, dataSize);
					break;
				case 0x12:
					readScript(input, input.position, dataSize);
					break;
			}
			return 0xB + dataSize;
		}
		
		/**
		 * <pre>
		 * AUDIODATA
		 * -------------------------------------------------------------------------
		 * SoundFormat 	UB[4]								Format of SoundData
		 * 				0 = Linear PCM, platform endian		Formats 7, 8, 14, and 15 
		 * 				1 = ADPCM							are reserved for 
		 * 				2 = MP3								internal use. Format 10 
		 * 				3 = Linear PCM, little endian		(AAC) is supported in 
		 * 				4 = Nellymoser 16-kHz mono			Flash Player 9,0,115,0
		 * 				5 = Nellymoser 8-kHz mono			and higher.
		 * 				6 = Nellymoser
		 * 				7 = G.711 A-law logarithmic PCM
		 * 				8 = G.711 mu-law logarithmic PCM
		 * 				9 = reserved
		 * 				10 = AAC
		 * 				14 = MP3 8-Khz
		 * 				15 = Device-specific sound
		 * -------------------------------------------------------------------------
		 * SoundRate 	UB[2]								Sampling rate
		 * 				0 = 5.5-kHz							For AAC: always 3
		 * 				1 = 11-kHz
		 * 				2 = 22-kHz
		 * 				3 = 44-kHz
		 * -------------------------------------------------------------------------
		 * SoundSize 	UB[1]								Size of each sample
		 * 				0 = snd8Bit							For AAC: always 1
		 * 				1 = snd16Bit
		 * -------------------------------------------------------------------------
		 * SoundType 	UB[1]								Mono or stereo sound
		 * 				0 = sndMono							For Nellymoser: always 0
		 * 				1 = sndStereo						For AAC: always 1
		 * -------------------------------------------------------------------------
		 * SoundData 	UI8[size of sound data] 
		 * 				if SoundFormat == 10
		 * 				AACAUDIODATA
		 * 				else
		 * 				Sound data—varies by format
		 * </pre>
		 * @param	input
		 * @param	from
		 * @param	dataLength
		 */
		private static function readAudio(input:ByteArray, 
											from:uint, dataLength:uint):void
		{
			var soundData:ByteArray;
			var syncByte:uint;
			var syncByte2:uint;
			var pad:int;
			if (!_soundStreamHead)
			{
				_soundStreamHead = new SoundStreamHead();
				input.position = from;
				var flags:uint = input.readUnsignedByte();
				
				var soundFormat:uint = flags >>> 0x4;
				var soundRate:uint = 3;// (flags >>> 0x2) & 0x3;
				var soundSize:uint = (flags >>> 0x1) & 0x1;
				var soundType:uint = 1;// flags & 0x1;
				
				//2 3 1 1
				//2 2 1 0
				trace(soundFormat, soundRate, soundSize, soundType);
				
				_soundStreamHead.playBackSoundRate = soundRate;
				_soundStreamHead.playBackSoundType = soundType;
				
				_soundStreamHead.streamSoundCompression = soundFormat;
				_soundStreamHead.streamSoundRate = soundRate;
				_soundStreamHead.streamSoundType = soundType;
				_soundStreamHead.streamSoundSampleCount;
				
				_soundStreamHead.latencySeek;
			}
			if (_soundStreamHead.streamSoundCompression === 0x2)
			{
				_soundPayLoad.writeBytes(input, from + 0x1, dataLength - 0x1);
			}
			else
			{
				soundData = new ByteArray();
				soundData.writeBytes(input, from + 0x1, dataLength - 0x1);
				_soundFrames.push(soundData);
			}
		}
		
		/**
		 * <pre>
		 * VIDEODATA
		 * -------------------------------------------------------------------
		 * FrameType 	UB[4] 
		 * 				1: keyframe (for AVC, a seekable frame)
		 * 				2: inter frame (for AVC, a nonseekable frame)
		 * 				3: disposable inter frame (H.263 only)
		 * 				4: generated keyframe (reserved for server use only)
		 * 				5: video info/command frame
		 * -------------------------------------------------------------------
		 * CodecID 		UB[4] 
		 * 				1: JPEG (currently unused)
		 * 				2: Sorenson H.263
		 * 				3: Screen video
		 * 				4: On2 VP6
		 * 				5: On2 VP6 with alpha channel
		 * 				6: Screen video version 2
		 * 				7: AVC
		 * -------------------------------------------------------------------
		 * VideoData 	If CodecID = 2
		 * 					H263VIDEOPACKET
		 * 				If CodecID = 3
		 * 					SCREENVIDEOPACKET
		 * 				If CodecID = 4
		 * 					VP6FLVVIDEOPACKET
		 * 				If CodecID = 5
		 * 					VP6FLVALPHAVIDEOPACKET
		 * 				If CodecID = 6
		 * 					SCREENV2VIDEOPACKET
		 * 				if CodecID = 7
		 * 					AVCVIDEOPACKET
		 * </pre>
		 * @param	input
		 * @param	from
		 * @param	lenght
		 */
		private static function readVideo(input:ByteArray, 
											from:uint, lenght:uint):void
		{
			input.position = from;
			var flags:uint = input.readUnsignedByte(); //00100100
			var frameType:uint = flags >>> 0x4;
			var codecID:uint = flags & 0xF;
			_videoCodec = codecID;
			var videoData:ByteArray = new ByteArray();
			// CHECK!
			if (codecID !== 0x2)
			{
				videoData.writeBytes(input, from + 0x2, lenght - 0x1);
			}
			else
			{
				videoData.writeBytes(input, from + 0x1, lenght - 0x1);
			}
			videoData.position = 0;
			_frames.push(videoData);
		}
		
		// TODO: Need better algorithm to do distribution
		// TODO: How do we know samples per frame?
		private static function distributeAudioFrames():void
		{
			_soundPayLoad.position = 0;
			var frames:int = MP3Transcoder.countFrames(_soundPayLoad, true);
			var sFrames:Vector.<ByteArray> = MP3Transcoder.frames;
			
			//-------frames------- 1132 736 473129 // OK
			//-------frames------- 2134 844 406950 // BAD
			//2131
			trace("-------frames-------", frames, _frames.length, _soundPayLoad.length);
			
			// TODO: how do we get samples per MP3 frame?
			var samples:int = 0x480; // 1152 or 576
			// 2458368 Alpha.flv - total samples
			// 2912.7582938388625592417061611374 - Alpha.flv avg samples per frame.
			//2458572
			// ~2.5 MP3 frames per SWF frame
			//samplesCount 2304 2458572 2131
			var samplesWritten:int;
			var samplesToWrite:int = samples * frames;
			var destLength:int = _frames.length;
			var samplesPerSWFFrame:int = Math.round(samplesToWrite / destLength);
			//if (_soundStreamHead.playBackSoundType === 0x0)
				//samples >>= 0x1;
			_soundStreamHead.streamSoundSampleCount = samplesPerSWFFrame;
			trace("samplesPerSWFFrame", samplesPerSWFFrame); // 2913
			var isFirstBlock:Boolean = true;
			
			var result:Vector.<ByteArray> = new Vector.<ByteArray>(0x0, false);
			_seekSamples = new Vector.<int>(0x0, false);
			_sampleCounter = new Vector.<int>(0x0, false);
			
			var temp:ByteArray;
			var position:int;
			var samplesCount:int;
			
			while (result.length < destLength)
			{
				temp = new ByteArray();
				samplesCount = 0;
				do
				{
					samplesWritten += samples;
					temp.writeBytes(sFrames[position]);
					position++;
					samplesCount += samples;
				}
				while (samplesWritten + samples < (result.length + 1) * samplesPerSWFFrame)
				result.push(temp);
				
				_sampleCounter.push(samplesCount);
				if (isFirstBlock)
				{
					_seekSamples.push(0);
					_soundStreamHead.latencySeek = _sampleCounter[0];
					isFirstBlock = false;
				}
				else
				{
					_seekSamples.push(result.length * samplesPerSWFFrame - samplesWritten);
				}
				trace("samplesCount", samplesCount, samplesWritten, 
					result.length * samplesPerSWFFrame, 
					result.length, position, _seekSamples[_seekSamples.length - 1]);
			}
			while (position < frames)
			{
				temp.writeBytes(sFrames[position]);
				position++;
			}
			_soundFrames = result;
		}
		
		private static function readScript(input:ByteArray, 
												from:uint, lenght:uint):void
		{
			//trace("reading script", from, lenght);
		}
	}
	
}