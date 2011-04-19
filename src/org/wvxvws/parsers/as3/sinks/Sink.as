package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Sink
	{
		public function get collected():Vector.<String>
		{
			return this._collected;
		}
		
		protected var _startRegExp:RegExp;
		
		protected var _collected:Vector.<String> = new <String>[];
		
		public function Sink() { super(); }
		
		protected function clearCollected():void
		{
			this._collected.splice(0, this._collected.length);
		}
		
		protected function appendParsedText(text:String, 
			sinks:AS3Sinks, usingMethod:Function):void
		{
			if (usingMethod) sinks.appendCollectedText(usingMethod(text));
			else sinks.appendCollectedText(text);
		}
		
		public function isSinkStart(from:AS3Sinks):Boolean
		{
			var subseq:String;
			var match:String;
			this._startRegExp.lastIndex = 0;
			subseq = from.source.substring(from.column);
			match = subseq.match(this._startRegExp)[0];
			return match && subseq.indexOf(match) == 0;
		}
	}

}