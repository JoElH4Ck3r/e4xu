package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class ASDocCommentSink extends Sink implements ISink
	{
		private const _keywordSink:ASDocKeywordSink = new ASDocKeywordSink();
		
		public function ASDocCommentSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks, flags:Vector.<Function>):Boolean
		{
			var source:String = from.source;
			var position:int = from.column;
			var totalLenght:int = from.source.length;
			var commentEnd:RegExp = from.settings.asdocCommentStartRegExp;
			var commentStart:RegExp = from.settings.blockCommentStartRegExp;
			var asdocKeyword:RegExp = from.settings.asdocKeywordRegExp;
			var beginning:String;
			var subseq:String;
			var i:int;
			var current:String;
			var matchIndex:int;
			var match:String;
			var possibleKeyword:String;
			var keywordPosition:int = -1;
			var hasKeywords:Boolean;
			var kewordLength:int;
			
			flags[0](false);
			flags[1](false);
			flags[2](false);
			
			subseq = source.substring(position);
			possibleKeyword = subseq.match(asdocKeyword)[0];
			if (possibleKeyword)
				keywordPosition = subseq.indexOf(possibleKeyword);
			beginning = subseq.match(commentStart)[0];
			while (i < beginning.length)
			{
				from.advanceColumn(beginning.charAt(i));
				i++;
			}
			position += i;
			match = subseq.match(commentEnd)[0];
			matchIndex = subseq.indexOf(match) + match.length - i;
			hasKeywords = keywordPosition > 0 && keywordPosition < matchIndex;
			do
			{
				if (hasKeywords && i == keywordPosition)
				{
					// TODO: returned value not used. Not sure if I'd need 
					// to check it here, probably the former check for 
					// comment completeness would fail, if the keyword ends
					// the comment, as there won't be block comment end.
					this._keywordSink.read(from);
					kewordLength = position;
					position = from.column;
					kewordLength = position - kewordLength;
					i += kewordLength;
					matchIndex -= kewordLength;
					// TODO: this should be a separate function.
					possibleKeyword = subseq.match(asdocKeyword)[0];
					if (possibleKeyword)
						keywordPosition = subseq.indexOf(possibleKeyword);
					hasKeywords = keywordPosition > 0 && keywordPosition < matchIndex;
				}
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
			super._startRegExp = from.settings.asdocCommentStartRegExp;
			return super.isSinkStart(from);
		}
	}
}