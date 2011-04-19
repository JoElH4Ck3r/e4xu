package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class WhiteSpaceSink extends Sink implements ISink
	{
		
		public function WhiteSpaceSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks):Boolean
		{
			var white:RegExp = from.settings.whiteSpaceRegExp;
			var subseq:String = from.source.substr(from.column);
			var match:String;
			match = subseq.match(white)[0];
			
			for (var position:int; position < match.length; position++)
				from.advanceColumn(match.charAt(position));
			
			super.appendParsedText(match, from, from.onWhiteSpace);
			return from.column < from.source.length;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.whiteSpaceRegExp;
			return super.isSinkStart(from);
		}
		
	}

}