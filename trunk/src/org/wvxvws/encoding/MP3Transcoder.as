package org.wvxvws.encoding 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.wvxvws.encoding.tags.DefineSound;
	
	/**
	 * MP3Transcoder class.
	 * @author wvxvw 
	 * port of Clement Wong's SoundTranscoder.java
	 * at http://opensource.adobe.com/svn/opensource/flex/sdk/trunk/modules/compiler/src/java/flex2/compiler/media/SoundTranscoder.java
	 */
	public class MP3Transcoder 
	{
		public static function get frames():Vector.<ByteArray> { return _frames; }
		
		private static const _mp3frequencies:Vector.<Vector.<int>> = 
		Vector.<Vector.<int>>(
		[
			Vector.<int>([11025, 0, 22050, 44100]), // supported
			Vector.<int>([12000, 0, 24000, 48000]),
			Vector.<int>([8000, 0, 16000, 32000]),
			Vector.<int>([0, 0, 0, 0])
		]);
		
		private static const _mp3bitrates:Vector.<Vector.<int>> = 
		Vector.<Vector.<int>>(
		[
						//V1,L1 | V1,L2 | V1,L3 | V2,L1 | V2, L2 & L3
			Vector.<int>([0,      0,      0,      0,      0]),
			Vector.<int>([32,     32,     32,     32,     8]),
			Vector.<int>([64,     48,     40,     48,     16]),
			Vector.<int>([96,     56,     48,     56,     24]),
			Vector.<int>([128,    64,     56,     64,     32]),
			Vector.<int>([160,    80,     64,     80,     40]),
			Vector.<int>([192,    96,     80,     96,     48]),
			Vector.<int>([224,    112,    96,     112,    56]),
			Vector.<int>([256,    128,    112,    128,    64]),
			Vector.<int>([288,    160,    128,    144,    80]),
			Vector.<int>([320,    192,    160,    160,    96]),
			Vector.<int>([352,    224,    192,    176,    112]),
			Vector.<int>([384,    256,    224,    192,    128]),
			Vector.<int>([416,    320,    256,    224,    144]),
			Vector.<int>([448,    384,    320,    256,    160]),
			Vector.<int>([-1,     -1,     -1,     -1,     -1])
		]);
		
		private static const _mp3bitrateIndices:Vector.<Vector.<int>> = 
		Vector.<Vector.<int>>(
		[
			//            reserved, layer III, layer II, layer I
			Vector.<int>([-1,       4,         4,        3]), // version 2.5
			Vector.<int>([-1,      -1,        -1,       -1]), // reserved
			Vector.<int>([-1,       4,         4,        3]), // version 2
			Vector.<int>([-1,       2,         1,        0])
		]);
		
		private static var _frames:Vector.<ByteArray>;
		
		public function MP3Transcoder() { super(); }
		
		public static function transcode(input:ByteArray):DefineSound
		{
			var size:int = input.length;
			var sound:ByteArray = readFully(input, size);
			
			if (sound === null || sound.length < 0x5)
			{
				throw new Error("Not MP3");
			}

			var ds:DefineSound = new DefineSound();
			ds.soundFormat = 0x2; // MP3
			ds.soundSize = 0x1; // always 16-bit for compressed formats
			//ds.name = className;

			/**
			 * 0 - version 2.5
			 * 1 - reserved
			 * 2 - version 2
			 * 3 - version 1
			 */
			sound.position = 0x3; // MB 2?
			var version:int = sound.readUnsignedByte() >> 0x3 & 0x3;

			/**
			 * 0 - reserved
			 * 1 - layer III => 1152 samples
			 * 2 - layer II  => 1152 samples
			 * 3 - layer I   => 384  samples
			 */
			sound.position = 0x3;
			var layer:int = sound.readUnsignedByte() >> 0x1 & 0x3;
			var samplingRate:int = sound.readUnsignedByte() >> 0x2 & 0x3;

			/**
			 * 0 - stereo
			 * 1 - joint stereo
			 * 2 - dual channel
			 * 3 - single channel
			 */
			var channelMode:int = sound.readUnsignedByte() >> 0x6 & 0x3;

			var frequency:int = _mp3frequencies[samplingRate][version];
			
			switch (frequency)
			{
				case 0x2B11: //1 - 11kHz 11025
					ds.soundRate = 0x1;
					break;
				case 0x5622: //2 - 22kHz 22050
					ds.soundRate = 0x2;
					break;
				case 0xAC44: //3 - 44kHz 44100
					ds.soundRate = 0x3;
					break;
				default:
					throw new Error("Frequency " + frequency + " not supported");
			}
			
			/**
			 * 0 - mono
			 * 1 - stereo
			 */
			ds.soundType = channelMode === 0x3 ? 0x0 : 0x1;

			/**
			 * assume that the whole thing plays in one SWF frame
			 *
			 * sample count = number of MP3 frames * number of samples per MP3
			 */
			ds.sampleCount = countFrames(sound) * (layer === 0x3 ? 0x180 : 0x480);

			if (ds.sampleCount < 0x0)
			{
				// frame count == -1, error!
				throw new Error("Could not determine sample frame count");
			}
			sound.position = 0x0;
			ds.compile(sound);
			return ds;
		}
		
		public static function readFully(input:ByteArray, inLength:int):ByteArray
		{
			var baos:ByteArray = new ByteArray();
			baos.endian = Endian.LITTLE_ENDIAN;
			// write 2 bytes - number of frames to skip...
			baos.writeShort(0x0); // see if this is unsigned byte
			//baos.writeByte(0x0); // see if this is unsigned byte

			// look for the first 11-bit frame sync. skip everything before the frame sync
			var b:int;
			var state:int;
			
			//if (input.readByte() !== -0x1)
			//{
				//input.position--;
			//}
			//trace("input.readByte()", input.readByte(), input.position);
			//trace("input.readByte()", input.readByte(), input.position);
			//input.position = 0;
			// 3-state FSM
			while (input.position < input.length) // see if this is unsigned byte
			{
				//b = input.readByte();
				//if (b === -0x1)
				//{
					//trace("skipped");
					//state = 0x0;
					//continue;
				//}
				//b = uint(uint(b) << 24) >>> 24;
				b = input.readUnsignedByte();
				//trace("bytes read so far", input.position, b);
				if (state === 0x0)
				{
					if (b === 0xFF) state = 0x1;
				}
				else if (state === 0x1)
				{
					if ((b >>> 0x5 & 0x7) === 0x7)
					{
						baos.writeByte(0xFF);
						baos.writeByte(b); // see if this is unsigned byte
						state = 0x2;
					}
					else state = 0x0;
				}
				else if (state === 0x2)
				{
					baos.writeByte(b); // see if this is unsigned byte
				}
				else trace("Error reading");
			}
			return baos;
		}
		
		public static function countFrames(input:ByteArray, 
											saveFrames:Boolean = false):int
		{
			var count:int;
			var start:int;// = 0x2;
			var b1:uint;
			var b2:uint;
			var b3:uint;//, b4;
			var skipped:Boolean;
			var inputLenght:int = input.length;
			//var stopper:int = 100;
			if (saveFrames) _frames = new Vector.<ByteArray>(0, false);
			/**
			 * 0 - version 2.5
			 * 1 - reserved
			 * 2 - version 2
			 * 3 - version 1
			 */
			var version:int;
			
			/**
			 * 0 - reserved
			 * 1 - layer III => 1152 samples
			 * 2 - layer II  => 1152 samples
			 * 3 - layer I   => 384  samples
			 */
			var layer:int;
			var bits:int;
			var bitrateIndex:int;
			var bitrate:int;
			var samplingRate:int;
			var frequency:int;
			var padding:int;
			var frameLength:int;
			var formatB2:uint;
			
			var maxTraces:int = 1000;
			
			var frame:ByteArray;
			
			while (start + 0x1 < inputLenght)
			{
				input.position = start;
				b1 = input.readUnsignedByte();
				if (b1 !== 0xFF)
				{
					start++;
					continue;
				}
				b2 = input.readUnsignedByte();
				if (formatB2 && b2 != formatB2)
				{
					start++;
					continue;
				}
				else if (formatB2)
				{
					b2 = formatB2;
				}
				else if ((b2 >>> 0x5 & 0x7) !== 0x7)
				{
					start++;
					continue;
				}
				b3 = input.readUnsignedByte();
				
				version = b2 >>> 0x3 & 0x3;
				layer = b2 >>> 0x1 & 0x3;
				bits = b3 >>> 0x4 & 0xF;
				bitrateIndex = _mp3bitrateIndices[version][layer];
				if (bitrateIndex < 0x0)
				{
					if (maxTraces) trace("incorrect bitrateIndex", 
						b1.toString(16), b2.toString(16), b3.toString(16));
					start++;
					continue;
				}
				bitrate = _mp3bitrates[bits][bitrateIndex] * 0x3E8;
				samplingRate = b3 >>> 0x2 & 0x3;
				frequency = _mp3frequencies[samplingRate][version];
				if (frequency < 0x1)
				{
					if (maxTraces) trace("incorrect frequency", 
						b1.toString(16), b2.toString(16), b3.toString(16));
					start++;
					continue;
				}
				padding = b3 >>> 0x1 & 0x1;
				frameLength = layer === 0x3 ?
						(0xC * bitrate / frequency + padding) * 0x4 :
						0x90 * bitrate / frequency + padding;
				if (frameLength < 0x1)
				{
					start++;
					//trace("EARLY EXIT");
					// just in case. if we don't check frameLength, we may end up running an infinite loop!
					continue;
				}
				else
				{
					if (maxTraces)
					{
						trace("start += frameLength", start, frameLength, 
						bitrate, version, layer, 
						b1.toString(16), b2.toString(16), b3.toString(16));
						maxTraces--;
					}
					formatB2 = b2;
					start += frameLength;
				}
				skipped = false;
				if (saveFrames)
				{
					frame = new ByteArray();
					if (start < inputLenght) 
						frame.writeBytes(input, start - frameLength, frameLength);
					_frames[count] = frame;
				}
				count += 0x1;
			}
			/*
			while (start + 0x2 < inputLenght)// && stopper--)
			{
				input.position = start; // maybe start - 1
				b1 = input.readUnsignedByte();// & 0xFF;
				b2 = input.readUnsignedByte();// & 0xFF;
				b3 = input.readUnsignedByte();// & 0xFF;
				// check frame sync
				trace("check frame sync", b1, b2, b3);
				if (b1 !== 0xFF || (b2 >>> 0x5 & 0x7) !== 0x7)
				{
					if (!skipped && start > 0x0)  // LAME has a bug where they do padding wrong sometimes
					{
						b3 = b2;
						b2 = b1;
						input.position = start - 0x1; // maybe start - 2
						b1 = input.readUnsignedByte();// & 0xFF;
						if (b1 !== 0xFF || (b2 >>> 0x5 & 0x7) !== 0x7)
						{
							++start;
							//trace("1 continue");
							continue;
						}
						else
						{
							--start;
						}
					}
					else
					{
						++start;
						//trace("2 continue");
						continue;
					}
				}
				version = b2 >>> 0x3 & 0x3;
				layer = b2 >>> 0x1 & 0x3;
				//trace("version", version);
				bits = b3 >>> 0x4 & 0xF;
				bitrateIndex = _mp3bitrateIndices[version][layer];
				bitrate = (bitrateIndex !== -0x1) ? _mp3bitrates[bits][bitrateIndex] * 0x3E8 : -1;

				if (bitrate < 0x0)
				{
					skipped = true;
					++start;
					//trace("3 continue");
					continue;
				}
				samplingRate = b3 >>> 0x2 & 0x3;
				frequency = _mp3frequencies[samplingRate][version];
				//trace("samplingRate", samplingRate);
				if (frequency < 0x1)
				{
					skipped = true;
					++start;
					//trace("4 continue");
					continue;
				}
				padding = b3 >>> 0x1 & 0x1;
				frameLength = layer === 0x3 ?
						(0xC * bitrate / frequency + padding) * 0x4 :
						0x90 * bitrate / frequency + padding;
				if (frameLength < 0x1)
				{
					// just in case. if we don't check frameLength, we may end up running an infinite loop!
					break;
				}
				else
				{
					if (maxTraces)
					{
						trace("start += frameLength", start, frameLength, bitrate, version, layer);
						maxTraces--;
					}
					start += frameLength;
				}
				skipped = false;
				if (saveFrames)
				{
					frame = new ByteArray();
					frame.writeBytes(input, start - (frameLength + 0x1), frameLength);
					_frames[count] = frame;
				}
				count += 0x1;
			}*/
			//trace("start, inputLenght", start, inputLenght, count);
			return count;
		}
		
	}
}