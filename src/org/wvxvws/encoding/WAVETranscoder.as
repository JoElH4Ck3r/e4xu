package org.wvxvws.encoding 
{
	//{imports
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.wvxvws.encoding.tags.DefineSound;
	//}
	
	/**
	* WAVETranscoder class.
	* Inspired by:
	* http://etcs.ru/pre/WAVPlayer/srcview/
	* Denis Kolyako. 
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class WAVETranscoder 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
		
		private static var _channels:uint;
		private static var _sampleRate:uint;
		private static var _byteRate:uint;
		private static var _blockAlign:uint;
		private static var _bitsPerSample:uint;
		private static var _waveDataLength:uint;
		private static var _fullDataLength:uint;
        
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function WAVETranscoder() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function transcode(input:ByteArray):DefineSound
		{
			var typeArray:ByteArray = new ByteArray();
			input.readBytes(typeArray, 0, 4);
			var sound:ByteArray = new ByteArray();
			sound.endian = Endian.LITTLE_ENDIAN;
			if (typeArray.toString() != "RIFF")
			{
				throw new Error("Decode error: incorrect RIFF header.");
				return;
			}
			_fullDataLength = input.readUnsignedInt() + 8;
			input.position = 0x10;
			var chunkSize:Number = input.readUnsignedInt();
			if (chunkSize != 0x10)
			{
				throw new Error("Decode error: incorrect chunk size.");
				return;
			}
			var isPCM:Boolean = Boolean(input.readShort());
			if (!isPCM)
			{
				throw new Error("Decode error: this file is not a PCM wave file.");
				return;
			}
			var ds:DefineSound = new DefineSound();
			ds.soundFormat = 0; // TODO: Try 1 or 3
			_channels = input.readShort();
			ds.soundType = _channels - 1;
			_sampleRate = input.readUnsignedInt();
			switch (_sampleRate)
			{
				case 44100:
					ds.soundRate = 3;
					break;
				case 22050:
					ds.soundRate = 2;
					break;
				case 11025:
					ds.soundRate = 1;
					break;
				case 5512:
					ds.soundRate = 0; // TODO: Find out if we can use this frequency
					break;
				default:
					throw new Error("Decode error: incorrect sample rate");
					return;
			}
			_byteRate = input.readUnsignedInt();
			_blockAlign = input.readShort();
			_bitsPerSample = input.readShort();
			input.position += 4;
			_waveDataLength = input.readUnsignedInt();
			if (!_blockAlign) // TODO: Why do we need this?
			{
				_blockAlign = _channels * _bitsPerSample / 8;
			}
			ds.soundSize = (_bitsPerSample == 16) ? 1 : 0;
			ds.sampleCount = _waveDataLength / (_channels * _bitsPerSample); // TODO: Not sure about this
			input.position = 0;
			input.readBytes(sound, 44, _waveDataLength);
			ds.compile(sound)
			return ds;
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
	}
	
}