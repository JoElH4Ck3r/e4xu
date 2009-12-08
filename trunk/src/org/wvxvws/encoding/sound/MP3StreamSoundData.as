package org.wvxvws.encoding.sound 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * MP3StreamSoundData class.
	 * @author wvxvw
	 */
	public class MP3StreamSoundData
	{
		/**
		 * SI16 Number of samples to skip.
		 */
		public var seekSamples:int;
		
		/**
		 * UI16 Number of samples
		 * represented by this block. Not
		 * affected by mono/stereo
		 * setting; for stereo sounds this
		 * is the number of sample pairs.
		 */
		public var sampleCount:int;
		
		/**
		 * Sound payload.
		 */
		public var data:ByteArray;
		
		public function MP3StreamSoundData() { super(); }
		
		public function write():ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeShort(sampleCount);
			ba.writeShort(seekSamples);
			ba.writeBytes(data);
			ba.position = 0;
			return ba;
		}
	}

}