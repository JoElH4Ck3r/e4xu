package org.wvxvws.encoding.tags 
{
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * SoundStreamHead2 class.
	 * @author wvxvw
	 */
	public class SoundStreamHead2 extends SWFTag
	{
		public var reserved:uint; // UB4
		public var playBackSoundRate:uint; //UB2
		public var playBackSoundSize:uint; //UB1
		public var playBackSoundType:uint; //UB1
		
		public var streamSoundCompression:uint; //UB4
		public var streamSoundRate:uint; //UB2
		public var streamSoundSize:uint; //UB1
		public var streamSoundType:uint; //UB1
		
		public var streamSoundSampleCount:uint; //UI16
		public var latencySeek:int; //SI16
		
		public function SoundStreamHead2() { super(45); }
		
		protected override function compileTagParams():void 
		{
			var u:uint;
			u = (reserved | (u << 4)); // write 4 bits <Reserved>
			u = (playBackSoundRate | (u << 2)); // write 2 bits <PlayBackSoundRate>
			u = (playBackSoundSize | (u << 1)); // write 1 bit <PlayBackSoundSize>
			u = (playBackSoundType | (u << 1)); // write 1 bit <PlayBackSoundType>
			// TODO: figure out why \x26?
			//_data.writeByte(u); 
			_data.writeByte(0x26);
			u = 0;
			u = (streamSoundCompression | (u << 4)); // write 4 bits <StreamSoundCompression>
			u = (streamSoundRate | (u << 2)); // write 2 bits <StreamSoundRate>
			u = (streamSoundSize | (u << 1)); // write 1 bit <StreamSoundSize>
			u = (streamSoundType | (u << 1)); // write 1 bit <StreamSoundType>
			_data.writeByte(u);
			_data.writeShort(streamSoundSampleCount);
			if (latencySeek) _data.writeShort(latencySeek);
		}
	}
	
}