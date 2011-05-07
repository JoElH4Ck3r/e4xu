package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.ISinks;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class RegExpSink extends Sink
	{
		public function RegExpSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public override function read(from:ISinks):Boolean
		{
			var subseq:String = from.remainingText();
			var match:String;
			var endIndex:int;
			
			super.clearCollected();
			// this is the first slash
			from.advanceColumn(subseq.charAt());
			super._collected.push(subseq.charAt());
			subseq = subseq.substr(1);
			match = subseq.match(from.sinkEndRegExp(this))[0];
			endIndex = subseq.indexOf(match);
			if (endIndex > -1)
			{
				super.report(
					super.pushAndReturn(
						subseq.substr(0, endIndex + match.length)), from);
			}
			// TODO: later
//			else from.reportError(from.settings.errors[1]);
			
			super.appendParsedText(super._collected.join(""), from);
			return from.hasMoreText();
		}
	}
}