package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	public class OperatorSink extends Sink implements ISink
	{
		public function OperatorSink() { super(); }
		
		public function read(from:AS3Sinks):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			var match:String = subseq.match(from.settings.operatorRegExp)[0];
			for (var i:int; i < match.length; i++)
				from.advanceColumn(match.charAt(i));
			
			super.appendParsedText(match, from, from.onOperator);
			return from.column < from.source.length;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			return false;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.operatorRegExp;
			return super.isSinkStart(from);
		}
	}
}