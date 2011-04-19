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
		
		public function read(from:AS3Sinks):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			var commentStart:RegExp = from.settings.asdocCommentStartRegExp;
			var commentEnd:RegExp = from.settings.blockCommentEndRegExp;
			var asdocKeyword:RegExp = from.settings.asdocKeywordRegExp;
			var match:String;
			var nextKeyword:int = -1;
			var keywordMatch:String;
			var difference:int;
			var current:String;
			
			match = subseq.substr(0, 
				subseq.indexOf(subseq.match(commentEnd)[0]) + 2);
			
			super.clearCollected();
			
			keywordMatch = match.match(asdocKeyword)[0];
			if (keywordMatch)
				nextKeyword = match.indexOf(keywordMatch);
			
			for (var i:int; i < match.length; i++)
			{
				if (i == nextKeyword)
				{
					difference = from.column;
					this._keywordSink.read(from);
					i += (from.column - difference);
					keywordMatch = match.match(asdocKeyword)[0];
					super._collected.push(this._keywordSink.collected[0]);
					if (keywordMatch)
						nextKeyword = match.indexOf(keywordMatch);
				}
				current = match.charAt(i);
				from.advanceColumn(current);
				super._collected.push(current);
			}
			
			super.appendParsedText(
				super._collected.join(""), from, from.onASDocComment);
			return from.column < from.source.length;
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