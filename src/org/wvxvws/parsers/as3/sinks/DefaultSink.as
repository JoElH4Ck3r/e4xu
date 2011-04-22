package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	public class DefaultSink extends Sink implements ISink
	{
		public function DefaultSink() { super(); }
		
		public function read(from:AS3Sinks):Boolean
		{
			var word:String;
			var subseq:String = from.source.substr(from.column);
			word = subseq.match(from.settings.wordRegExp)[0];
						
			for (var i:int; i < word.length; i++)
				from.advanceColumn(word.charAt(i));
			
			super.appendParsedText(word, from, this.hasHandler(word, from));
			return from.column < from.source.length;
		}
		
		private function hasHandler(forWord:String, from:AS3Sinks):Function
		{
			var result:Function;
			if (from.settings.isKeyword(forWord) && from.onKeyword)
				result = from.onKeyword;
			else if (from.settings.isClassName(forWord) && from.onClassName)
				result = from.onClassName;
			else if (from.settings.isReserved(forWord) && from.onReserved)
				result = from.onReserved;
			else if (from.onDefault)
				result = from.onDefault;
			return result;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			return false;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.wordRegExp
			return super.isSinkStart(from);
		}
	}
}