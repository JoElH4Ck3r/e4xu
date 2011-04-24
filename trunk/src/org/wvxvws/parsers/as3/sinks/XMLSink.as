package org.wvxvws.parsers.as3.sinks
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.resources.XMLRegExp;
	import org.wvxvws.parsers.as3.sinks.xml.E4XNode;
	import org.wvxvws.parsers.as3.sinks.xml.E4XReadState;
	
	public class XMLSink extends Sink implements ISink
	{
		private var _currentNode:E4XNode;
		
		private var _bracketCount:int;
		
		public function XMLSink()
		{
			super();
		}
		
		public function read(from:AS3Sinks):Boolean
		{
			trace("is XML");
			var subseq:String = from.source.substr(from.column);
			var lastRead:E4XNode;
			var readState:E4XReadState;
			
			if (!this._currentNode) this._currentNode = new E4XNode(null);
			readState = this._currentNode.read(from);
			if (readState == E4XReadState.TAIL)
				this._currentNode = null;
			else if (readState == E4XReadState.BRACKET)
				this._currentNode = this._currentNode.continueFrom;
			else trace("Error reading XML:", readState);
			
			return false;
//			return from.source.length > from.column;
		}
		
		public function canFollow(from:AS3Sinks):Boolean
		{
			return false;
		}
		
		public override function isSinkStart(from:AS3Sinks):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			var lookBehind:String = from.source.substr(0, from.column);
			var lastIndex:int = lookBehind.length;
			var testString:String;
			var white:RegExp = from.settings.whiteSpaceRegExp;
			var line:RegExp = from.settings.lineEndRegExp;
			var current:String;
			var result:Boolean = true;
			var xmlRE:XMLRegExp = from.settings.xmlRegExp;
			var keepChecking:Boolean;
			var regexps:Vector.<RegExp> = 
				new <RegExp>[
					from.settings.xmlStartRegExp, 
					xmlRE.cdata, 
					xmlRE.comment, 
					xmlRE.pi];
			
			// Need this to check if we aren't dealing with Vector.
			// Vector would have to have "." somewhere before the XML
			// start and the "greater then".
			while (lastIndex-- > 0)
			{
				current = lookBehind.charAt(lastIndex);
				if (!(white.test(current) || line.test(current)))
				{
					if (current == from.settings.vectorDelimiter)
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
					super._startRegExp = regexps[lastIndex];
					super._startRegExp.lastIndex = 0;
					keepChecking = !super.isSinkStart(from);
					// If we didn't exit early, and the last check failed
					// then this is not an XML.
					if (regexps.length == lastIndex + 1 && keepChecking)
						result = false;
					lastIndex++;
				}
				while (keepChecking && regexps.length > lastIndex);
			}
			return result;
		}
	}
}