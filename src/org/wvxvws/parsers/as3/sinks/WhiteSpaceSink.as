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
		
		// TODO: it's possible to optimize if we move collected and collected
		// text to the class, instead of locals.
		public function read(from:AS3Sinks, flags:Vector.<Function>):Boolean
		{
			var white:RegExp = from.settings.whiteSpaceRegExp;
			var subseq:String = from.source.substr(from.column);
			var match:String;
			match = subseq.match(white)[0];
			
			flags[0](false);
			flags[1](false);
			flags[2](false);
			
			for (var position:int; position < match.length; position++)
			{
				from.advanceColumn(match.charAt(position));
			}
			
			trace("------ whitespace returned", white, match.length);
			if (from.onWhiteSpace)
				match = from.onWhiteSpace(match);
			from.appendCollectedText(match);
			return from.source.length > position;
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