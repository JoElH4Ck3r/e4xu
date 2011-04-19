package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class StringSink extends Sink implements ISink
	{
		public function StringSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks):Boolean
		{
			var source:String = from.source.substr(from.column);
			var position:int;
			var escapeChar:String = from.settings.escapeChar;
			var sourceLenght:int = source.length;
			var escaped:Boolean;
			var isQuote:RegExp = from.settings.quoteRegExp;
			var current:String = source.match(isQuote)[0];
			var matchedQuote:String;
			
			super.clearCollected();
			// first quote
			super._collected.push(current);
			from.advanceColumn(current);
			matchedQuote = current;
			
			for (var i:int = 1; i < sourceLenght; i++)
			{
				current = source.charAt(i);
				from.advanceColumn(current);
				super._collected.push(current);
				isQuote.lastIndex = 0;
				if (matchedQuote == current && !escaped) break;
				escaped = current == escapeChar;
			}
			super.appendParsedText(
				super._collected.join(""), from, from.onString);
//			trace("parsed sting");
			return from.column < from.source.length;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
//			trace("maybe string", from.source.substr(from.column));
			super._startRegExp = from.settings.quoteRegExp;
			return super.isSinkStart(from);
		}
	}
}