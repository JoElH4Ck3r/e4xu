package org.wvxvws.encoding.sound 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * MP3SoundData class.
	 * @author wvxvw
	 */
	public class MP3SoundData
	{
		public var seekSamples:int; //SI16 Number of samples to skip.
		public var data:ByteArray;
		
		public function MP3SoundData() { super(); }
		
		public function write():ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeShort(seekSamples);
			ba.writeBytes(data);
			ba.position = 0;
			return ba;
		}
	}

}