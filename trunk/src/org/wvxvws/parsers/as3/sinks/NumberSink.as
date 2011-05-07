package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;
	
	public class NumberSink extends Sink
	{
		public function NumberSink() { super(); }
		
		public override function read(from:ISinks):Boolean
		{
			super.appendParsedText(
				super.report(
					super.pushAndReturn(from.source.substr(from.column)
						.match(from.sinkEndRegExp(this))[0]), from), from);
			return from.hasMoreText();
		}
	}
}