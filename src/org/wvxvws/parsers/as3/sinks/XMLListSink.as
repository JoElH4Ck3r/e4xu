package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.sinks.xml.XMLListReader;

	public class XMLListSink extends Sink
	{
		private const _reader:XMLListReader = new XMLListReader();
		
		private var _atEnd:Boolean;
		
		public function XMLListSink() { super(); }
		
		public override function read(from:ISinks):Boolean
		{
			var expression:RegExp;
			
			if (this._atEnd) expression = from.sinkEndRegExp(this);
			else expression = from.sinkStartRegExp(this);
			// TODO: we need to be able to read text nodes from here
			super.appendParsedText(
				super.report(
					super.pushAndReturn(
						from.remainingText()
						.match(expression)[0]), from), from);
			if (!this._atEnd) this._reader.read(from as AS3Sinks);
			return from.hasMoreText();
		}
		
		public override function isSinkStart(from:ISinks):Boolean
		{
			var result:Boolean;
			
			// TODO: maybe I'll manage w/o AS3Sinks.readXMLList()...
			if (this._atEnd = !(result = super.isSinkStart(from)))
			{
				this._atEnd = result = 
					from.sinkEndRegExp(this).test(from.remainingText());
				if (result) (from as AS3Sinks).readXMLList(false);
			}
			if (result && !this._atEnd) (from as AS3Sinks).readXMLList(true);
			return result;
		}
	}
}