package org.wvxvws.parsers.as3.sinks.xml
{
	import org.wvxvws.parsers.as3.ISinks;

	public class TextNode extends XMLNode implements ICurlyNode
	{
		public function get finished():Boolean { return this._finished; }
		
		private var _finished:Boolean;
		
		public function TextNode() { super(); }
		
		public function appendPart(source:String):void
		{
			// It won't compile if
			// super._value += source;
			// http://bugs.adobe.com/jira/browse/ASC-4238
			super._value = super._value + source;
		}
		
		public function continueReading(from:ISinks):Boolean
		{
			return this.read(from);
		}
		
		public override function read(from:ISinks):Boolean
		{
			var subseq:String = 
				from.remainingText()
					.match(from.sinkStartRegExp(this))[0];
			var index:int = subseq.indexOf("<");
			var hasBracket:Boolean;
			
			this._finished = false;
			
			if (index < 0)
			{
				index = subseq.indexOf("{");
				if (index > -1) hasBracket = true;
			}
			if (index < 0) index = subseq.length;
			(from as XMLReader).lastNodeIn(this);
			from.appendCollectedText(
				super.report(subseq.substr(0, index), from));
			if (hasBracket) (from as XMLReader).exitOnCurly(this);
			else this._finished = true;
			return from.hasMoreText();
		}
	}
}