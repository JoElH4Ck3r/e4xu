package org.wvxvws.encoding.flv 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class H263VideoPacket 
	{
		private var _data:ByteArray
		/**
		 * PictureStartCode 			UB[17] 			Similar to H.263 5.1.1
		 * 												0000 0000 0000 0000 1
		 * --------------------------------------------------------------------------
		 * Version 						UB[5] 			Video format version Flash
		 * 												 Player 6 supports 0 and 1
		 * --------------------------------------------------------------------------
		 * TemporalReference 			UB[8] 			See H.263 5.1.2
		 * --------------------------------------------------------------------------
		 * PictureSize 					UB[3] 			000: custom, 1 byte
		 * 												001: custom, 2 bytes
		 * 												010: CIF (352x288)
		 * 												011: QCIF (176x144)
		 * 												100: SQCIF (128x96)
		 * 												101: 320x240
		 * 												110: 160x120
		 * 												111: reserved
		 * --------------------------------------------------------------------------
		 * CustomWidth 									Note: UB[16] is not the same
		 * If PictureSize = 000, 		UB[8]			as UI16; there is no byte 
		 * If PictureSize = 001, 		UB[16]			swapping. Width in pixels
		 * Otherwise absent
		 * --------------------------------------------------------------------------
		 * CustomHeight 								Note: UB[16] is not the same
		 * If PictureSize = 000, 		UB[8]			as UI16; there is no byte 
		 * If PictureSize = 001, 		UB[16]			swapping. Height in pixels
		 * Otherwise absent
		 * --------------------------------------------------------------------------
		 * PictureType 					UB[2] 			00: intra frame
		 * 												01: inter frame
		 * 												10: disposable inter frame
		 * 												11: reserved
		 * --------------------------------------------------------------------------
		 * DeblockingFlag 				UB[1] 			Requests use of deblocking
		 * 												filter (advisory only, Flash
		 * 												Player may ignore)
		 * --------------------------------------------------------------------------
		 * Quantizer 					UB[5] 			See H.263 5.1.4
		 * --------------------------------------------------------------------------
		 * ExtraInformationFlag 		UB[1] 			See H.263 5.1.9
		 * --------------------------------------------------------------------------
		 * ExtraInformation 							See H.263 5.1.10
		 * If ExtraInformationFlag = 1, UB[8]			The ExtraInformationFlag-
		 * Otherwise absent								ExtraInformation sequence  
		 * 												repeats until an  
		 * 												ExtraInformationFlag of 0 is 
		 * 												encountered
		 * --------------------------------------------------------------------------
		 * Macroblock 					MACROBLOCK 		See Macroblock
		 * --------------------------------------------------------------------------
		 * PictureStuffing 				varies 			See H.263 5.1.13
		 */
		public function H263VideoPacket() { super(); }
		
		public function compile(block:Macroblock, stuffing:ByteArray):ByteArray { }
		
		public function defineSize(flag0:Boolean, flag1:Boolean, flag2:Boolean, 
									width:uint = 320, height:uint = 240):void
		{
			
		}
	}
	
}