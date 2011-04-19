package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	public class NumberSink extends Sink implements ISink
	{
		public function NumberSink() { super(); }
		
		public function read(from:AS3Sinks):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			var match:String = subseq.match(from.settings.numberRegExp)[0];
			
			super.clearCollected();
			
			super._collected.push(match);
			for (var i:int; i < match.length; i++)
				from.advanceColumn(match.charAt(i));
			
			super.appendParsedText(
				super._collected.join(""), from, from.onNumber);
			return from.column < from.source.length;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			return false;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.numberStartRegExp;
			return super.isSinkStart(from);
		}
	}
}