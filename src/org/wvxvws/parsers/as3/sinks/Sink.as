package org.wvxvws.parsers.as3.sinks 
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Sink implements ISink
	{
		public function get collected():Vector.<String>
		{
			return this._collected;
		}
		
		protected var _collected:Vector.<String> = new <String>[];
		
		public function Sink() { super(); }
		
		protected function clearCollected():void
		{
			this._collected.splice(0, this._collected.length);
		}
		
		// NOTE: This is duplicated in XMLNode
		protected function appendParsedText(text:String, sinks:ISinks):void
		{
			var usingMethod:Function = sinks.readHandler(this, text);
			if (usingMethod) sinks.appendCollectedText(usingMethod(text));
			else sinks.appendCollectedText(text);
		}
		
		protected function report(match:String, from:ISinks):String
		{
			for (var position:int; position < match.length; position++)
				from.advanceColumn(match.charAt(position));
			return match;
		}
		
		protected function pushAndReturn(match:String):String
		{
			this._collected.push(match);
			return match;
		}
		
		protected function checkAndReset(text:String, expression:RegExp):String
		{
			expression.lastIndex = 0;
			return text.match(expression)[0];
		}
		
		public function read(from:ISinks):Boolean
		{
//			trace("reading:", this, from.source.substr(from.column));
			this.clearCollected();
			
			this.appendParsedText(
				this.report(
					this.pushAndReturn(
						from.source.substr(from.column)
							.match(from.sinkStartRegExp(this))[0]), from), from);
			return from.hasMoreText();
		}
		
		public function isSinkStart(from:ISinks):Boolean
		{
			var subseq:String;
			var match:String = this.checkAndReset(
				(subseq = from.source.substring(from.column)),
					from.sinkStartRegExp(this));
			return match && subseq.indexOf(match) == 0;
		}
	}
}