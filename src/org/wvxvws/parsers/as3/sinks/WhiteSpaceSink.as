package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class WhiteSpaceSink implements ISink
	{
		
		public function WhiteSpaceSink() 
		{
			super();
		}
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks):Boolean
		{
			var source:String = from.source;
			var position:int = from.column;
			var white:RegExp = from.settings.whiteSpaceRegExp;
			var current:String;
			var keepGoing:Boolean;
			var totalLenght:int = from.source.length;
			
			do
			{
				position++;
				white.lastIndex = 0;
				if (position < totalLenght || from.hasError)
				{
					current = source.charAt(position);
				}
				else break;
				from.advanceColumn(current);
			}
			while (white.test(current));
			return totalLenght > position;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
	}

}