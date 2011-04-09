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
		
		public function read(from:AS3Sinks, flags:Vector.<Function>):Boolean
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
			var collected:Vector.<String> = new <String>[];
			var collectedText:String;
			
			flags[0](false);
			flags[1](false);
			flags[2](false);
			
			from.advanceColumn(current);
			collected.push(current);
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
				collected.push(current);
			}
			while (keepGoing);
			collectedText = collected.join("");
			if (from.onString) collectedText = from.onString(collectedText);
			from.appendCollectedText(collectedText);
			return totalLenght > position;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.quoteRegExp;
			return super.isSinkStart(from);
		}
	}
}