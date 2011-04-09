package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class LineCommentSink extends Sink implements ISink
	{
		public function LineCommentSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks, flags:Vector.<Function>):Boolean
		{
			var source:String = from.source;
			var position:int = from.column;
			var totalLenght:int = from.source.length;
			var lineEnd:RegExp = from.settings.lineEndRegExp;
			var commentStart:RegExp = from.settings.lineCommentStartRegExp;
			var beginning:String;
			var subseq:String;
			var i:int;
			var current:String;
			var matchIndex:int;
			
			flags[0](false);
			flags[1](false);
			flags[2](false);
			
			subseq = source.substring(position);
			
			beginning = subseq.match(commentStart)[0];
			while (i < beginning.length)
			{
				from.advanceColumn(beginning.charAt(i));
				i++;
			}
			position += i;
			matchIndex = subseq.indexOf(subseq.match(lineEnd)[0]);
			if (matchIndex < 0) matchIndex = subseq.length;
			do
			{
				current = subseq.charAt(i);
				i++;
				matchIndex--;
				position++;
				from.advanceColumn(current);
			}
			while (matchIndex > 0 && position < totalLenght);
			return position < totalLenght;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.lineCommentStartRegExp;
			return super.isSinkStart(from);
		}
		
	}

}