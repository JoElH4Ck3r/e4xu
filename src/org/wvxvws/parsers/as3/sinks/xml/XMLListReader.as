package org.wvxvws.parsers.as3.sinks.xml
{
	import org.wvxvws.parsers.as3.ISink;

	public class XMLListReader extends XMLReader
	{
		public function XMLListReader() { super(); }
		
		public override function sinkEndRegExp(forSink:ISink):RegExp
		{
			var result:RegExp;
			
			if ((forSink as Object).constructor == DocumentNode)
				result = super._as3Sinks.settings.xmlListEndRegExp;
			else result = super.sinkEndRegExp(forSink);
			return result;
		}
		
		public override function sinkStartRegExp(forSink:ISink):RegExp
		{
			var result:RegExp;
			
			if ((forSink as Object).constructor == DocumentNode)
				result = super._as3Sinks.settings.xmlListStartRegExp;
			else result = super.sinkStartRegExp(forSink);
			return result;
		}
	}
}