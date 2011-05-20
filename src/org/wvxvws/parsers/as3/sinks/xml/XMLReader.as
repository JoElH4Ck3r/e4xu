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
		
		public function get finished():Boolean { return this._finished; }
		
		public function get waitingToFinish():int { return this._unfinishedStacks.length; }
		
		protected const _whiteStack:SinksStack = new SinksStack();
		
		protected var _as3Sinks:AS3Sinks;
		
		private var _currentNode:XMLNode;
		
		private var _lineEndSink:LineEndSink;
		
		private var _whiteSink:WhiteSpaceSink;
		
		private var _elementSink:ElementNode;
		
		private var _finished:Boolean;
		
		private const _unfinishedStacks:Vector.<SinksStack> = new <SinksStack>[];
		
		public function XMLReader() { super(); }
		
		public function read(sinks:AS3Sinks):void
		{
			this._as3Sinks = sinks;
			super.readInternal();
		}
		
		public function continueReading(sinks:AS3Sinks):void
		{
			this._as3Sinks = sinks.readClosingCurly();
			
			(this._stack.restore(this._unfinishedStacks.pop())
				.back().next() as ICurlyNode).continueReading(this);
			super.loopSinks();
			trace("--- continued");
		}
		
		public function loop():void
		{
			this._stack.reset();
			trace("--- reset stack");
			super.loopSinks();
		}
		
		// TODO: Why do I need this?
		public function lastNodeIn(node:XMLNode):void
		{
			this._currentNode = node;
		}
		
		public function exitOnCurly(sink:ISink):void
		{
			trace("--- was meant to exit", getQualifiedClassName(sink));
			this._finished = false;
			this._unfinishedStacks.push(super._stack.clear());
			this._as3Sinks.appendCollectedText("|||");
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
			this._as3Sinks.appendCollectedText(text);
		}
		
		public function sinkStartRegExp(forSink:ISink):RegExp
		{
			var result:RegExp;
			
			// TODO: we could cache the regexps.
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
			trace("sink requested regexp:", getQualifiedClassName(forSink), result);
			return result;
		}
		
		public function sinkEndRegExp(forSink:ISink):RegExp
		{
			var result:RegExp;
			
			switch ((forSink as Object).constructor)
			{
				case ElementNode:
					result = this._as3Sinks.settings.xmlEndRegExp;
					break;
				// there will be more...
			}
			return result;
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
		
		public function hasMoreText():Boolean { return this._as3Sinks.hasMoreText(); }
		
		public function remainingText():String { return this._as3Sinks.remainingText(); }
		
		protected override function buildDictionary(stack:SinksStack = null):SinksStack
		{
			// TODO: Once we finish reading on a "{" we should save the stack
			// And then when we come back another time we should try
			// to discover wether we are continuing to read the old stack
			// or are we opening a new one.
			var result:SinksStack = super.buildDictionary(stack);
			this._stack.add(this._elementSink = new ElementNode())
				.add(this._whiteSink = this._as3Sinks.whiteSink)
				.add(this._lineEndSink = this._as3Sinks.lineEndSink)
				.add(new CDataNode())
				.add(new CommentNode())
				.add(new PINode())
				.add(new TextNode());
			return result;
		}
	}
}