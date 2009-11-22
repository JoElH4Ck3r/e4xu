package org.wvxvws.encoding.tags 
{
	//{ imports
	import org.wvxvws.encoding.SWFTag;
	//}
	
	/**
	 * SoundStreamHead class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SoundStreamHead extends SWFTag
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public var reserved:uint;				//UB[4]
		public var playBackSoundRate:uint;		//UB[2]
		public var playBackSoundSize:uint = 1;	//UB[1]
		public var playBackSoundType:uint;		//UB[1]
		
		public var streamSoundCompression:uint;	//UB[4]
		public var streamSoundRate:uint;		//UB[2]
		public var streamSoundSize:uint = 1;	//UB[1]
		public var streamSoundType:uint;		//UB[1]
		
		public var streamSoundSampleCount:uint;	//UI16
		public var latencySeek:int;				//SI16 | absent
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Header 					RECORDHEADER 		Tag type = 18.
		 * Reserved 				UB[4] 				Always zero.
		 * PlaybackSoundRate 		UB[2] 				Playback sampling rate
		 * 												0 = 5.5 kHz
		 * 												1 = 11 kHz
		 * 												2 = 22 kHz
		 * 												3 = 44 kHz
		 * PlaybackSoundSize 		UB[1] 				Playback sample size.
		 * 												Always 1 (16 bit).
		 * PlaybackSoundType 		UB[1] 				Number of playback channels:
		 * 												mono or stereo.
		 * 												0 = sndMono
		 * 												1 = sndStereo
		 * StreamSoundCompression 	UB[4] 				Format of streaming sound data.
		 * 												1 = ADPCM
		 * 												SWF 4 and later only:
		 * 												2 = MP3
		 * StreamSoundRate 			UB[2] 				The sampling rate of the
		 * 												streaming sound data.
		 * 												0 = 5.5 kHz
		 * 												1 = 11 kHz
		 * 												2 = 22 kHz
		 * 												3 = 44 kHz
		 * StreamSoundSize 			UB[1] 				The sample size of the
		 * 												streaming sound data.
		 * 												Always 1 (16 bit).
		 * StreamSoundType 			UB[1] 				Number of channels in the
		 * 												streaming sound data.
		 * 												0 = sndMono
		 * 												1 = sndStereo
		 * StreamSoundSampleCount 	UI16 				Average number of samples in
		 * 												each SoundStreamBlock. Not
		 * 												affected by mono/stereo
		 * 												setting; for stereo sounds this is
		 * 												the number of sample pairs.
		 * LatencySeek 				If StreamSoundCompression = 2
		 * 							SI16
		 * 							Otherwise absent
		 * 												See MP3 sound data. The
		 * 												value here should match the
		 * 												SeekSamples field in the first
		 * 												SoundStreamBlock for this
		 * 												stream.
		 */
		public function SoundStreamHead() { super(18); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * RECORDHEADER| Flags 1            | Flags 2           | Samples    | Latency
		 * ------------+--------------------+-------------------+------------+------------
		 *  "\x86\x04" |  "\x06"            | "\x26"            | "\x96\x03" | "\x61\x06"
		 * ------------+--------------------+-------------------+------------+------------
		 *             |  0000 01    1 0    | 0010 01    1 0    |
		 *             |       11Khz   Mono | MP3  11Khz   Mono |
		 * ------------+--------------------+-------------------+------------+------------
		 *  "\x86\x04" |  "\x06"            | "\x06"            | "\x01\x00" | "\x01\x00"
		 * ------------+--------------------+-------------------+------------+------------
		 *             |  0000 01    1 0    | 0000 01    1 0    |
		 *             |       11Khz   Mono |   ?  11Khz   Mono |
		 * 
		 */
		protected override function compileTagParams():void 
		{
			var u:uint;
			u = (this.reserved | (u << 4)); // write 4 bits <Reserved>
			u = (this.playBackSoundRate | (u << 2)); // write 2 bits <PlayBackSoundRate>
			u = (this.playBackSoundSize | (u << 1)); // write 1 bit <PlayBackSoundSize>
			u = (this.playBackSoundType | (u << 1)); // write 1 bit <PlayBackSoundType>
			_data.writeByte(u); 
			u = 0;
			u = (this.streamSoundCompression | (u << 4)); // write 4 bits <StreamSoundCompression>
			u = (this.streamSoundRate | (u << 2)); // write 2 bits <StreamSoundRate>
			u = (this.streamSoundSize | (u << 1)); // write 1 bit <StreamSoundSize>
			u = (this.streamSoundType | (u << 1)); // write 1 bit <StreamSoundType>
			super._data.writeByte(u);
			super._data.writeShort(this.streamSoundSampleCount);
			if (this.streamSoundCompression === 2) super._data.writeShort(this.latencySeek);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}