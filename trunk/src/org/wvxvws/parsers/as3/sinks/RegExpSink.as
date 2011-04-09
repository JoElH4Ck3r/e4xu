package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3ReaderError;
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class RegExpSink extends Sink implements ISink
	{
		public function RegExpSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks, flags:Vector.<Function>):Boolean
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
			var collected:Vector.<String> = new <String>[];
			var collectedText:String;
			
			flags[0](false);
			flags[1](false);
			flags[2](false);
			
			current = source.charAt(position);
			collected.push(current);
			from.advanceColumn(current);
			position++;
			match = this.resetMatch(from, reEnd, position);
			do
			{
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
				collected.push(current);
				from.advanceColumn(current);
				position++;
			}
			while (keepGoing);
			// TODO: this is ugly, must find a better way.
			if (position < totalLenght || from.hasError)
			{
				for (var i:int = 1; i < match.length; i++, position++)
				{
					current = match.charAt(i);
					collected.push(current);
					from.advanceColumn(current);
				}
			}
			collectedText = collected.join("");
			if (from.onRegExp) collectedText = from.onRegExp(collectedText);
			from.appendCollectedText(collectedText);
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
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.regexStartRegExp;
			return super.isSinkStart(from);
		}
	}
}