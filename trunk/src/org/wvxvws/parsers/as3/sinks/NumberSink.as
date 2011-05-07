package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.ISinks;
	
	public class NumberSink extends Sink
	{
		public function NumberSink() { super(); }
		
		public override function read(from:ISinks):Boolean
		{
			super.appendParsedText(
				super.report(
					super.pushAndReturn(from.remainingText()
						.match(from.sinkEndRegExp(this))[0]), from), from);
			return from.hasMoreText();
		}
	}
}