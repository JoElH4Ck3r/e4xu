package org.wvxvws.encoding.tags 
{
	//{ imports
	import flash.utils.ByteArray;
	import org.wvxvws.encoding.SWFTag;
	//}
	
	/**
	 * SoundStreamBlock class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SoundStreamBlock extends SWFTag
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public var streamSoundData:ByteArray;
		
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
		 * Header 			RECORDHEADER (long) 				Tag type = 19.
		 * StreamSoundData 	UI8[size of compressed data] 		Compressed sound data.
		 * 
		 * The contents of StreamSoundData vary depending on the value of the
		 * StreamSoundCompression field in the SoundStreamHead tag:
		 * ■ If StreamSoundCompression is 0 or 3, StreamSoundData contains raw, uncompressed
		 * samples.
		 * ■ If StreamSoundCompression is 1, StreamSoundData contains an ADPCM sound data
		 * record.
		 * ■ If StreamSoundCompression is 2, StreamSoundData contains an MP3 sound data record.
		 * ■ If StreamSoundCompression is 6, StreamSoundData contains a NELLYMOSERDATA
		 * record.
		 */
		public function SoundStreamBlock() { super(19); }
		
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
		 *        RECORDHEADER (MP3)     |      ?      | SeekSamples
		 * ------------------------------+-------------+-------
		 * "\xFF\x04" "\x18\x04\x00\x00" |  "\x00\x09" | ...
		 * ------------------------------+-------------+-------
		 * "\xFF\x04" "\x0E\x02\x00\x00" |  "\x80\x04" | ...
		 */
		protected override function compileTagParams():void 
		{
			this.streamSoundData.position = 0;
			super._data.writeBytes(this.streamSoundData);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}