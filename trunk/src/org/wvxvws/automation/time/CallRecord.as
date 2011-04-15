package org.wvxvws.automation.time
{
	public final class CallRecord
	{
		public var method:Function;
		public var parameters:Array;
		public var callCount:int;
		public var maxCalls:uint = uint.MAX_VALUE;
		
		public function CallRecord() { super(); }
		
	}
}