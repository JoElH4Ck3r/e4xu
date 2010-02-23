package org.wvxvws.lcbridge
{
	//{ imports
	import flash.utils.ByteArray;
	//}
	
	[Embed(source='../../../../assets/bridge.swf', mimeType='application/octet-stream')]
	
	/**
	 * AVM1SWF class.
	 * This class is the AV1 compiled SWF that proxies the calls to the loaded AVM1 SWF.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class AVM1SWF extends ByteArray
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function AVM1SWF() { super(); }
		
	}
}