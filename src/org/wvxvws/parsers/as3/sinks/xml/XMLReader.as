package org.wvxvws.parsers.as3.sinks.xml
{
	import flash.utils.getQualifiedClassName;
	
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.SinksBase;
	import org.wvxvws.parsers.as3.SinksStack;
	import org.wvxvws.parsers.as3.sinks.LineEndSink;
	import org.wvxvws.parsers.as3.sinks.WhiteSpaceSink;

	public class XMLReader extends SinksBase implements ISinks
	{
		public function get column():int { return this._as3Sinks.column; }
		
		public function get source():String { return this._as3Sinks.source; }
		
		public function get as3Sinks():AS3Sinks { return this._as3Sinks; }
		
		protected const _whiteStack:SinksStack = new SinksStack();
		
		private var _currentNode:XMLNode;
		
		private var _as3Sinks:AS3Sinks;
		
		private var _lineEndSink:LineEndSink;
		
		private var _whiteSink:WhiteSpaceSink;
		
		public function XMLReader() { super(); }
		
		public function read(sinks:AS3Sinks):void
		{
			this._as3Sinks = sinks;
			super.readInternal();
		}
		
		public function lastNodeIn(node:XMLNode):void
		{
			this._currentNode = node;
		}
		
		public function exitOnCurly():void
		{
			super._stack.clear();
		}
		
		public function readHandler(forSink:ISink, forWord:String = null):Function
		{
			return this._as3Sinks.onXML;
		}
		
		public function advanceColumn(character:String):String
		{
			return this._as3Sinks.advanceColumn(character);
		}
		
		public function appendCollectedText(text:String):void
		{
			this.reportCollected(this._currentNode, text);
		}
		
		public function sinkStartRegExp(forSink:ISink):RegExp
		{
			var result:RegExp;
			
			switch ((forSink as Object).constructor)
			{
				case ElementNode:
					result = this._as3Sinks.settings.xmlStartRegExp;
					break;
				case AttributeNode:
					result = this._as3Sinks.settings.xmlAttributeStartRegExp;
					break;
				case CDataNode:
					result = this._as3Sinks.settings.xmlRegExp.cdata;
					break;
				case CommentNode:
					result = this._as3Sinks.settings.xmlRegExp.comment;
					break;
				case PINode:
					result = this._as3Sinks.settings.xmlRegExp.pi;
					break;
				case TextNode:
					result = this._as3Sinks.settings.xmlRegExp.pcdata;
					break;
				default:
					result = this._as3Sinks.sinkStartRegExp(forSink);
			}
			result.lastIndex = 0;
			trace(getQualifiedClassName(forSink), result);
			return result;
		}
		
		public function sinkEndRegExp(forSink:ISink):RegExp
		{
			return null;
		}
		
		public function readWhite():Boolean
		{
			var nextSink:ISink;
			
			this._whiteStack.clear();
			this._whiteStack.add(this._lineEndSink).add(this._lineEndSink);
			
			while (nextSink = this._whiteStack.next())
			{
				if (nextSink.isSinkStart(this._as3Sinks) && 
					nextSink.read(this._as3Sinks))
					this._whiteStack.reset();
			}
			return this._as3Sinks.source.length > this._as3Sinks.column;
		}
		
//		public function readNode(sinks:AS3Sinks):void
//		{
//			switch (sinks.source.charAt(sinks.column))
//			{
//				case "{":
//					this.readCurly(sinks);
//					break;
//				case " ":
//				case "\t":
//				case "\r":
//				case "\n":
//					this.readWhite(sinks);
//					break;
//				case "<":
//					this.readElement(sinks);
//					break;
//				default:
//					this.readText(sinks);
//			}
//		}
//		
//		public function readWhite(sinks:AS3Sinks):void
//		{
//			var nextSink:ISink;
//			var current:String;
//			
//			this._whiteStack.clear();
//			this._whiteStack.add(from.whiteSink).add(from.lineEndSink);
//			
//			while (nextSink = this._whiteStack.next())
//			{
//				if (nextSink.isSinkStart(from) && nextSink.read(from))
//					this._whiteStack.reset();
//			}
//			
//			current = sinks.source.charAt(sinks.column);
//			
//			switch (current)
//			{
//				case "{":
//					this.readCurly(sinks);
//					break;
//				case "<":
//					this.readElement(sinks);
//					break;
//				case "/":
//					if (sinks.source.charAt(sinks.column + 1) == ">")
//						this.closeElement(sinks);
//					else this.readText(sinks);
//					break;
//				default:
//					this.readText(sinks);
//			}
//		}
//		
//		public function readElement(sinks:AS3Sinks):void
//		{
//			var current:String = sinks.source.charAt(sinks.column + 1);
//			
//			switch (current)
//			{
//				case "/":
//					this.readTail(sinks);
//					break;
//				case "{":
//					this.readCurly(sinks);
//					break;
//				case "!":
//					if (sinks.source.charAt(sinks.column + 2) == "[")
//						this.readCdata(sinks);
//					else this.readComment(sinks);
//					break;
//				case "?":
//					this.readPI(sinks);
//					break;
//				default:
//					this.readName(sinks);
//			}
//		}
		
		public function reportCollected(kind:ISink, text:String):void
		{
			if (this._as3Sinks.onXML)
			{
				if (this._as3Sinks.onXML.length > 1)
					this._as3Sinks.appendCollectedText(this._as3Sinks.onXML(text, kind));
				else this._as3Sinks.appendCollectedText(this._as3Sinks.onXML(text));
			}
			else this._as3Sinks.appendCollectedText(text);
		}
		
		protected override function buildDictionary():void
		{
			super.buildDictionary();
			this._lineEndSink = this._as3Sinks.lineEndSink;
			this._whiteSink = this._as3Sinks.whiteSink;
			this._stack.add(new ElementNode())
				.add(this._whiteSink)
				.add(this._lineEndSink)
				.add(new CDataNode())
				.add(new CommentNode())
				.add(new PINode())
				.add(new TextNode());
		}
	}
}