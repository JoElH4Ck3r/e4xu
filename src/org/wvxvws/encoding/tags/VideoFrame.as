﻿package org.wvxvws.encoding.tags 
{
	import flash.utils.ByteArray;
	import org.wvxvws.encoding.SWFTag;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class VideoFrame extends SWFTag
	{
		/**
		 * UI16 ID of video stream character of
		 */
		public var streamID:uint;
		
		/**
		 * UI16 Sequence number of this frame within its video stream
		 */
		public var frameNum:uint;
		
		/**
		 * if CodecID = 2
		 * 		H263VIDEOPACKET
		 * if CodecID = 3
		 * 		SCREENVIDEOPACKET
		 * if CodecID = 4
		 * 		VP6SWFVIDEOPACKET
		 * if CodecID = 5
		 * 		VP6SWFALPHAVIDEOPACKET
		 * if CodecID = 6
		 * 		SCREENV2VIDEOPACKET
		 */
		public var videoData:ByteArray;
		
		public function VideoFrame() { super(61); }
		
		// \x7F\x0F\x51\x0D\x00\x00 | \x01\x00 | \x00\x00 |
		// |----- RECORDHEADER -----|--- id ---|- frame --|
		protected override function compileTagParams():void
		{
			_data.writeShort(streamID);
			_data.writeShort(frameNum);
			videoData.position = 0;
			_data.writeBytes(videoData);
		}
	}
	
}