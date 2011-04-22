package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class ASDocKeywordSink extends Sink implements ISink
	{
		
		public function ASDocKeywordSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks):Boolean
		{
			var word:String = from.source.substr(from.column);
			word = word.match(from.settings.asdocKeywordRegExp)[0];
			
			super.clearCollected();
			
			for (var i:int; i < word.length; i++)
				from.advanceColumn(word.charAt(i));
			
			super.appendParsedText(word, from, from.onASDocKeyword);
			return true;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.asdocKeywordRegExp;
			return super.isSinkStart(from);
		}
	}
}