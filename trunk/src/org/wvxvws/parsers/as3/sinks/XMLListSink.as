package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.sinks.xml.XMLListReader;

	public class XMLListSink extends Sink
	{
		private const _reader:XMLListReader = new XMLListReader();
		
		private var _atEnd:Boolean;
		private var _waitForCurly:Boolean;
		private var _shouldContinue:Boolean;
		private var _curlyBalance:int;
		
		public function XMLListSink() { super(); }
		
		// NOTE: this is almost identical to XMLSink
		public override function read(from:ISinks):Boolean
		{
			if (this._shouldContinue)
				this._reader.continueReading(from as AS3Sinks);
			else this._reader.read(from as AS3Sinks);
			if (!this._reader.finished || this._reader.waitingToFinish) // we must wait for the matching curly
			{
				this._curlyBalance = (from as AS3Sinks).bracketCount("{");
				this._waitForCurly = true;
			}
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