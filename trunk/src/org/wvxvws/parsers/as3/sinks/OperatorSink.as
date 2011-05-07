package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISinks;
	
	public class OperatorSink extends Sink
	{
		public function OperatorSink() { super(); }
		
		public override function read(from:ISinks):Boolean
		{
			var subseq:String = from.remainingText();
			var match:String = subseq.match(from.sinkStartRegExp(this))[0];
			var as3Sinks:AS3Sinks = from as AS3Sinks;
			
			for (var i:int; i < match.length; i++)
			{
				if (as3Sinks.settings.bracketRegExp.test(
					as3Sinks.advanceColumn(match.charAt(i))))
					as3Sinks.incrementBracket();
			}
			
			super.appendParsedText(match, from);
			return from.hasMoreText();
		}
	}
}