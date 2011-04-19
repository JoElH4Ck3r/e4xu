package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	public class LineEndSink extends Sink implements ISink
	{
		public function LineEndSink() { super(); }
		
		public function read(from:AS3Sinks):Boolean
		{
			var match:String = 
				from.source.substr(from.column).match(from.settings.lineEndRegExp)[0];
			var matchLenght:int = match.length;
			
			for (var i:int; i < matchLenght; i++)
				from.advanceColumn(match.charAt(i));
			super.appendParsedText(match, from, from.onLine);
			return from.column < from.source.length;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			return false;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.lineEndRegExp;
			return super.isSinkStart(from);
		}
	}
}