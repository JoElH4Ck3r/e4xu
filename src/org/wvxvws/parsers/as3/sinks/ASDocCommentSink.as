package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISinks;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class ASDocCommentSink extends Sink
	{
		// TODO: It could be better to reuse the sinks from the AS3Sinks
		// instead of having these here, but seems rather complex atm.
		private const _keywordSink:ASDocKeywordSink = new ASDocKeywordSink();
		private const _whitesPaceSink:WhiteSpaceSink = new WhiteSpaceSink();
		private const _lineEndSink:LineEndSink = new LineEndSink();
		
		public function ASDocCommentSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		// TODO: looks like it may be possible to make it shorter.
		public override function read(from:ISinks):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			var commentStart:RegExp = (from as AS3Sinks).settings.asdocCommentStartRegExp;
			var commentEnd:RegExp = from.sinkEndRegExp(this);
			var asdocKeyword:RegExp = from.sinkStartRegExp(this._keywordSink);
			var match:String;
			var difference:int;
			var current:String;
			var lineEnd:RegExp = from.sinkStartRegExp(this._lineEndSink);
			var white:RegExp = from.sinkStartRegExp(this._whitesPaceSink);
			var whiteAfterLine:Boolean;
			
			match = subseq.substr(0, 
				subseq.indexOf(subseq.match(commentEnd)[0]) + 2);
			
			super.clearCollected();
			
			for (var i:int; i < match.length; i++)
			{
				current = match.charAt(i);
				if (asdocKeyword.test(from.source.substr(from.column)))
				{
					this.collectAndClear(from);
					
					difference = from.column;
					this._keywordSink.read(from);
					i += (from.column - difference);
					whiteAfterLine = true;
					i--;
				}
				else if (lineEnd.test(current))
				{
					this.collectAndClear(from);
					
					difference = from.column;
					this._lineEndSink.read(from);
					i += (from.column - difference);
					whiteAfterLine = true;
					i--;
				}
				else if (whiteAfterLine && white.test(current))
				{
//					this.collectAndClear(from);
					
					difference = from.column;
					this._whitesPaceSink.read(from);
					i += (from.column - difference);
					whiteAfterLine = false;
					i--;
				}
				else 
				{
					from.advanceColumn(current);
					super._collected.push(current);
				}
				asdocKeyword.lastIndex = white.lastIndex = lineEnd.lastIndex = 0;
			}
			
			this.collectAndClear(from);
			return from.column < from.source.length;
		}
		
		private function collectAndClear(from:ISinks):void
		{
			if (super._collected.length)
			{
				super.appendParsedText(super._collected.join(""), from);
				super.clearCollected();
			}
		}
	}
}