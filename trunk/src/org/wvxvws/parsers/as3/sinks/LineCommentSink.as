package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.ISinks;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class LineCommentSink extends Sink
	{
		public function LineCommentSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public override function read(from:ISinks):Boolean
		{
			var match:String;
			var subseq:String = from.remainingText();
			var i:int = -1;
			
			super.clearCollected();
			
			match = subseq.match(from.sinkStartRegExp(this))[0];
			if (match) i = subseq.indexOf(match);
			else i = subseq.length;
			
			super.appendParsedText(
				super.report(
					super.pushAndReturn(subseq.substr(0, i)), from), from);
			
			return from.hasMoreText();
		}
	}
}