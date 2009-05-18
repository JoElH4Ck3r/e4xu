package org.wvxvws.encoding 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author wvxvw 
	 * port of Clement Wong's SoundTranscoder.java
	 * at http://opensource.adobe.com/svn/opensource/flex/sdk/trunk/modules/compiler/src/java/flex2/compiler/media/SoundTranscoder.java
	 */
	public class MP3Transcoder 
	{
		private static const mp3frequencies:Array /* of Array */ =
		[
			[11025, 0, 22050, 44100],
			[12000, 0, 24000, 48000],
			[8000, 0, 16000, 32000],
			[0, 0, 0, 0]
		];
		
		private static const mp3bitrates:Array /* of Array */ =
		[
			[0, 0, 0, 0, 0],
			[32, 32, 32, 32, 8],
			[64, 48, 40, 48, 16],
			[96, 56, 48, 56, 24],
			[128, 64, 56, 64, 32],
			[160, 80, 64, 80, 40],
			[192, 96, 80, 96, 48],
			[224, 112, 96, 112, 56],
			[256, 128, 112, 128, 64],
			[288, 160, 128, 144, 80],
			[320, 192, 160, 160, 96],
			[352, 224, 192, 176, 112],
			[384, 256, 224, 192, 128],
			[416, 320, 256, 224, 144],
			[448, 384, 320, 256, 160],
			[-1, -1, -1, -1, -1]
		];
		
		private static const mp3bitrateIndices:Array /* of Array */ =
		[
			// reserved, layer III, layer II, layer I
			[-1, 4, 4, 3], // version 2.5
			[-1, -1, -1, -1], // reserved
			[-1, 4, 4, 3], // version 2
			[-1, 2, 1, 0]
		];
		
		public function MP3Transcoder() { super(); }
		
		public static function transcode(source:ByteArray, className:String):ByteArray
		{
			var results:ByteArray;
			results = mp3(source, className);
			return results;
		}
		
		private static function mp3(input:ByteArray, className:String):ByteArray
		{
			var size:int = input.length;
			var sound:ByteArray = readFully(input, size);
			
			if (sound == null || sound.length < 5)
			{
				throw new Error("Not MP3");
			}

			var ds:DefineSound = new DefineSound();
			ds.format = 2; // MP3
			ds.writeBytes(sound);
			ds.size = 1; // always 16-bit for compressed formats
			ds.name = className;

			/**
			 * 0 - version 2.5
			 * 1 - reserved
			 * 2 - version 2
			 * 3 - version 1
			 */
			ds.position = 3; // MB 2?
			var version:int = ds.readUnsignedByte() >> 3 & 0x3;

			/**
			 * 0 - reserved
			 * 1 - layer III => 1152 samples
			 * 2 - layer II  => 1152 samples
			 * 3 - layer I   => 384  samples
			 */
			ds.position = 3; // MB 2?
			var layer:int = ds.readUnsignedByte() >> 1 & 0x3;
			
			ds.position = 4; // MB 3?
			var samplingRate:int = ds.readUnsignedByte() >> 2 & 0x3;

			/**
			 * 0 - stereo
			 * 1 - joint stereo
			 * 2 - dual channel
			 * 3 - single channel
			 */
			ds.position = 5; // MB 4?
			var channelMode:int = ds.readUnsignedByte() >> 6 & 0x3;

			var frequency:int = mp3frequencies[samplingRate][version];

			/**
			 * 1 - 11kHz
			 * 2 - 22kHz
			 * 3 - 44kHz
			 */
			switch (frequency)
			{
				case 11025:
					ds.rate = 1;
					break;
				case 22050:
					ds.rate = 2;
					break;
				case 44100:
					ds.rate = 3;
					break;
				default:
					throw new Error("Frequency " + frequency + " not supported");
			}
			
			/**
			 * 0 - mono
			 * 1 - stereo
			 */
			ds.type = channelMode == 3 ? 0 : 1;

			/**
			 * assume that the whole thing plays in one SWF frame
			 *
			 * sample count = number of MP3 frames * number of samples per MP3
			 */
			ds.sampleCount = countFrames(ds) * (layer == 3 ? 384 : 1152);

			if (ds.sampleCount < 0)
			{
				// frame count == -1, error!
				throw new Error("Could not determine sample frame count");
			}
			return ds;
		}
		
		private static function readFully(input:ByteArray, inLength:int):ByteArray
		{
			//BufferedInputStream in = new BufferedInputStream(inputStream);
			var baos:ByteArray = new ByteArray();
			baos.endian = Endian.LITTLE_ENDIAN;
			// write 2 bytes - number of frames to skip...
			baos.writeByte(0); // see if this is unsigned byte
			baos.writeByte(0); // see if this is unsigned byte

			// look for the first 11-bit frame sync. skip everything before the frame sync
			var b:int;
			var state:int = 0;

			// 3-state FSM
			while (input.position < input.length && (b = input.readUnsignedByte()) != -1) // see if this is unsigned byte
			{
				if (state == 0)
				{
					if (b == 255)
					{
						state = 1;
					}
				}
				else if (state == 1)
				{
					if ((b >> 5 & 0x7) == 7)
					{
						baos.writeByte(255); // see if this is unsigned byte
						baos.writeByte(b); // see if this is unsigned byte
						state = 2;
					}
					else
					{
						state = 0;
					}
				}
				else if (state == 2)
				{
					baos.writeByte(b); // see if this is unsigned byte
				}
				else
				{
					// assert false;
				}
			}

			return baos;
		}
		
		private static function countFrames(input:ByteArray):int
		{
			var count:int = 0;
			var start:int = 2;
			var b1:int;
			var b2:int;
			var b3:int;//, b4;
			var skipped:Boolean;

			while (start + 2 < input.length)
			{
				input.position = start; // maybe start - 1
				b1 = input.readUnsignedByte() & 0xff;
				b2 = input.readUnsignedByte() & 0xff;
				b3 = input.readUnsignedByte() & 0xff;

				// check frame sync
				if (b1 != 255 || (b2 >> 5 & 0x7) != 7)
				{
					if (!skipped && start > 0)  // LAME has a bug where they do padding wrong sometimes
					{
						b3 = b2;
						b2 = b1;
						input.position = start - 1; // maybe start - 2
						b1 = input.readUnsignedByte() & 0xff;
						if (b1 != 255 || (b2 >> 5 & 0x7) != 7)
						{
							++start;
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
						continue;
					}
				}

				/**
				 * 0 - version 2.5
				 * 1 - reserved
				 * 2 - version 2
				 * 3 - version 1
				 */
				var version:int = b2 >> 3 & 0x3;

				/**
				 * 0 - reserved
				 * 1 - layer III => 1152 samples
				 * 2 - layer II  => 1152 samples
				 * 3 - layer I   => 384  samples
				 */
				var layer:int = b2 >> 1 & 0x3;

				var bits:int = b3 >> 4 & 0xf;
				var bitrateIndex:int = mp3bitrateIndices[version][layer];
				var bitrate:int = (bitrateIndex != -1) ? mp3bitrates[bits][bitrateIndex] * 1000 : -1;

				if (bitrate == -1)
				{
					skipped = true;
					++start;
					continue;
				}

				var samplingRate:int = b3 >> 2 & 0x3;

				var frequency:int = mp3frequencies[samplingRate][version];

				if (frequency == 0)
				{
					skipped = true;
					++start;
					continue;
				}
				var padding:int = b3 >> 1 & 0x1;
				var frameLength:int = layer == 3 ?
						(12 * bitrate / frequency + padding) * 4 :
						144 * bitrate / frequency + padding;
				if (frameLength == 0)
				{
					// just in case. if we don't check frameLength, we may end up running an infinite loop!
					break;
				}
				else
				{
					start += frameLength;
				}
				skipped = false;
				count += 1;
			}
			return count;
		}
	}
}

import flash.utils.ByteArray;
import flash.utils.Endian;

internal final class DefineSound extends ByteArray
{
	public var code:int;
	public var format:int;
	public var rate:int;
	public var size:int;
	public var type:int;
	public var sampleCount:uint; // U32
	public var name:String;
	
	public function DefineSound()
	{
		super();
		endian = Endian.LITTLE_ENDIAN;
	}
	
	public function compile():ByteArray
	{
		return this;
	}
}