package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Sink
	{
		protected var _startRegExp:RegExp;
		
		public function Sink() { super(); }
		
		public function isSinkStart(from:AS3Sinks):Boolean
		{
			var subseq:String = from.source.substring(from.column);
			var match:String = subseq.match(this._startRegExp)[0];
			return match && subseq.indexOf(match) == 0;
		}
	}

}