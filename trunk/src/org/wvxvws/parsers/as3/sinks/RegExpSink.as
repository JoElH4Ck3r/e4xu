package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3ReaderError;
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class RegExpSink extends Sink implements ISink
	{
		public function RegExpSink() { super(); }
		
		/* INTERFACE org.wvxvws.parsers.as3.ISink */
		
		public function read(from:AS3Sinks):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			var match:String;
			var endIndex:int;
			
			super.clearCollected();
			// this is the first slash
			from.advanceColumn(subseq.charAt());
			super._collected.push(subseq.charAt());
			subseq = subseq.substr(1);
			match = subseq.match(from.settings.regexEndRegExp)[0];
			endIndex = subseq.indexOf(match);
			if (endIndex > -1)
			{
				endIndex += match.length;
				super._collected.push(subseq.substr(0, endIndex));
				for (var i:int; i < endIndex; i++)
					from.advanceColumn(subseq.charAt(i));
			}
			else from.reportError(from.settings.errors[1]);
			
			super.appendParsedText(
				super._collected.join(""), from, from.onRegExp);
			return from.column > from.source.length;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			super._startRegExp = from.settings.regexStartRegExp;
			return super.isSinkStart(from);
		}
	}
}