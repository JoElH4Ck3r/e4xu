package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.resources.XMLRegExp;
	import org.wvxvws.parsers.as3.sinks.xml.XMLReader;
	
	public class XMLSink extends Sink
	{
		private const _reader:XMLReader = new XMLReader();
		
		private var _waitForCurly:Boolean;
		private var _curlyBalance:int;
		private var _shouldContinue:Boolean;
		
		public function XMLSink() { super(); }
		
		public override function read(from:ISinks):Boolean
		{
			trace("is XML");
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
			var sinks:AS3Sinks = from as AS3Sinks;
			var subseq:String = from.remainingText();
			var lookBehind:String = from.source.substr(0, from.column);
			var lastIndex:int = lookBehind.length;
			var white:RegExp = sinks.settings.whiteSpaceRegExp;
			var line:RegExp = sinks.settings.lineEndRegExp;
			var current:String;
			var result:Boolean = true;
			var xmlRE:XMLRegExp = sinks.settings.xmlRegExp;
			var keepChecking:Boolean;
			var regexps:Vector.<RegExp> = 
				new <RegExp>[
					sinks.settings.xmlStartRegExp, 
					xmlRE.cdata, 
					xmlRE.comment, 
					xmlRE.pi];
			
			if (subseq.charAt() == "<")
			{
				// Need this to check if we aren't dealing with Vector.
				// Vector would have to have "." somewhere before the XML
				// start and the "greater then".
				while (lastIndex-- > 0)
				{
					current = lookBehind.charAt(lastIndex);
					if (!(white.test(current) || line.test(current)))
					{
						if (current == sinks.settings.vectorDelimiter)
							result = false;
						break;
					}
					white.lastIndex = line.lastIndex = 0;
				}
				if (result)
				{
					lastIndex = 0;
					do
					{
						current = super.checkAndReset(subseq, regexps[lastIndex]);
						keepChecking = !(current && subseq.indexOf(current) == 0);
						// If we didn't exit early, and the last check failed
						// then this is not an XML.
						if ((regexps.length == lastIndex + 1) && keepChecking)
							result = false;
						lastIndex++;
					}
					while (keepChecking && regexps.length > lastIndex);
				}
				if (result) this._shouldContinue = false;
			}
			else if (this._waitForCurly && subseq.charAt() == "}" && 
				(from as AS3Sinks).bracketCount("}") + 1 == this._curlyBalance)
			{
				this._shouldContinue = result = true;
				trace("count:", (from as AS3Sinks).bracketCount("}"), "remembered:", this._curlyBalance);
			}
			else result = false;
			return result;
		}
	}
}