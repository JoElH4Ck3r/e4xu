package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3ReaderError;
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class RegExpSink implements ISink
	{
		public function RegExpSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks):Boolean
		{
			var source:String = from.source;
			var position:int = from.column;
			var current:String;
			var backSlash:Boolean;
			var reEnd:RegExp = from.settings.regexEndRegExp;
			var escapeChar:String = from.settings.escapeChar;
			var keepGoing:Boolean;
			var totalLenght:int = from.source.length;
			var remaining:String;
			var match:String;
			position++;
			match = this.resetMatch(from, reEnd, position);
			
			do
			{
				position++;
				if (position < totalLenght || from.hasError)
				{
					current = source.charAt(position);
					remaining = source.substr(position);
					backSlash = !backSlash && current == escapeChar;
					keepGoing = remaining.indexOf(match) != 0;
					if (!keepGoing && backSlash)
					{
						keepGoing = true;
						match = this.resetMatch(from, reEnd, position);
					}
				}
				else break;
				from.advanceColumn(current);
			}
			while (keepGoing);
			// TODO: this is ugly, must find a better way.
			if (position < totalLenght || from.hasError)
			{
				for (var i:int; i < match.length; i++, position++)
				{
					trace("Regexp tail:", match.charAt(i));
					from.advanceColumn(match.charAt(i));
				}
			}
			trace("Finished regexp:", match, i);
			return totalLenght > position;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		private function resetMatch(sinks:AS3Sinks, regexp:RegExp, 
			position:int):String
		{
			var match:String;
			var subseq:String = 
				sinks.source.substring(position, sinks.source.length);
			match = subseq.match(regexp)[0];
			trace("----------subseq:", subseq);
			if (!match || !match.length)
				sinks.reportError(sinks.settings.errors.regexp[0]);
			return match;
		}
	}
}