package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class StringSink extends Sink
	{
		public function StringSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public override function read(from:ISinks):Boolean
		{
			var source:String = from.source.substr(from.column);
			var position:int;
			var escapeChar:String = (from as AS3Sinks).settings.escapeChar;
			var sourceLenght:int = source.length;
			var escaped:Boolean;
			var isQuote:RegExp = from.sinkStartRegExp(this);
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
			super.appendParsedText(super._collected.join(""), from);
//			trace("parsed sting");
			return from.hasMoreText();
		}
	}
}