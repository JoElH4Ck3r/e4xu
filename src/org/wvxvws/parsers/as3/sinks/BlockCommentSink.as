package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISinks;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class BlockCommentSink extends Sink
	{
		public function BlockCommentSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		// TODO: needs cleenup
		public override function read(from:ISinks):Boolean
		{
			var source:String = from.source;
			var position:int = from.column;
			var totalLenght:int = from.source.length;
			var commentEnd:RegExp = from.sinkEndRegExp(this);
			var commentStart:RegExp = from.sinkStartRegExp(this);
			var beginning:String;
			var subseq:String;
			var i:int;
			var current:String;
			var matchIndex:int;
			var match:String;
			
			super.clearCollected();
			
			subseq = from.remainingText();
			
			beginning = subseq.match(commentStart)[0];
			super._collected.push(beginning);
			while (i < beginning.length)
			{
				from.advanceColumn(beginning.charAt(i));
				i++;
			}
			position += i;
			match = subseq.match(commentEnd)[0];
			matchIndex = subseq.indexOf(match) + match.length - i;
			super._collected.push(subseq.substr(i, matchIndex));
			do
			{
				current = subseq.charAt(i);
				i++;
				matchIndex--;
				position++;
				from.advanceColumn(current);
			}
			while (matchIndex > 0 && position < totalLenght);
			super.appendParsedText(super._collected.join(""), from);
			return from.hasMoreText();
		}
		
		public override function isSinkStart(from:ISinks):Boolean
		{
			return super.isSinkStart(from) && 
				super.checkAndReset(from.source.substr(from.column, 3), 
					from.sinkStartRegExp(this));
		}
	}
}