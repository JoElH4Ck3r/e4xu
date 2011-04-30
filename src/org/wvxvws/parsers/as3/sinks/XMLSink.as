package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.resources.XMLRegExp;
	import org.wvxvws.parsers.as3.sinks.xml.XMLReader;
	
	public class XMLSink extends Sink
	{
		private const _reader:XMLReader = new XMLReader();
		
		public function XMLSink() { super(); }
		
		public override function read(from:ISinks):Boolean
		{
			trace("is XML");
			this._reader.read(from as AS3Sinks);
			return from.source.length > from.column;
		}
		
		public override function isSinkStart(from:ISinks):Boolean
		{
			var sinks:AS3Sinks = from as AS3Sinks;
			var subseq:String = from.source.substr(from.column);
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
			}
			else result = false;
			return result;
		}
	}
}