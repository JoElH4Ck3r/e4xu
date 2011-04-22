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
		
		public function read(from:AS3Sinks):Boolean
		{
			var match:String;
			var subseq:String = from.source.substr(from.column);
			var i:int = -1;
			var current:String;
			
			super.clearCollected();
			
			match = subseq.match(from.settings.lineEndRegExp)[0];
			if (match) i = subseq.indexOf(match);
			else i = subseq.length;
			
			match = subseq.substr(0, i);
			super._collected.push(match);
			
			for (i = 0; i < match.length; i++)
				from.advanceColumn(match.charAt(i));
			super.appendParsedText(
				super._collected.join(""), from, from.onLineComment);
			
			return from.column < from.source.length;
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