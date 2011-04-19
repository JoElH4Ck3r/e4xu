package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class BlockCommentSink extends Sink implements ISink
	{
		
		public function BlockCommentSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		// TODO: needs cleenup
		public function read(from:AS3Sinks):Boolean
		{
			var source:String = from.source;
			var position:int = from.column;
			var totalLenght:int = from.source.length;
			var commentEnd:RegExp = from.settings.blockCommentEndRegExp;
			var commentStart:RegExp = from.settings.blockCommentStartRegExp;
			var beginning:String;
			var subseq:String;
			var i:int;
			var current:String;
			var matchIndex:int;
			var match:String;
			
			super.clearCollected();
			
			subseq = source.substring(position);
			
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
			super.appendParsedText(
				super._collected.join(""), from, from.onBlockComment);
			return position < totalLenght;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			var test:String;
			super._startRegExp = from.settings.blockCommentStartRegExp;
			result = super.isSinkStart(from);
			if (result)
			{
				test = from.source.substr(from.column, 3);
				super._startRegExp.lastIndex = 0;
				result = super._startRegExp.test(test);
			}
			return result;
		}
		
	}

}