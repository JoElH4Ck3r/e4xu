package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class StringSink implements ISink
	{
		public function StringSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks):Boolean
		{
			var source:String = from.source;
			var position:int = from.column;
			var current:String = source.charAt(position);
			var backSlash:Boolean;
			var quotes:RegExp = from.settings.quoteRegExp;
			var escapeChar:String = from.settings.escapeChar;
			var keepGoing:Boolean;
			var totalLenght:int = from.source.length;
			var matchingQuote:String = current;
			
			from.advanceColumn(current);
			do
			{
				position++;
				if (position < totalLenght || from.hasError)
				{
					current = source.charAt(position);
					backSlash = !backSlash && current == escapeChar;
					keepGoing = !(matchingQuote == current);
					if (!keepGoing && backSlash) keepGoing = true;
				}
				else break;
				from.advanceColumn(current);
			}
			while (keepGoing);
			return totalLenght > position;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
	}
}