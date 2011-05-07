package org.wvxvws.parsers.as3.sinks.xml
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.SinksStack;

	public class ElementNode extends XMLNode implements ICurlyNode
	{
		public function get finished():Boolean { return this._finished; }
		
		protected const _attirubutes:Vector.<AttributeNode> = new <AttributeNode>[];
		
		protected const _children:Vector.<XMLNode> = new <XMLNode>[];
		
		private const _attributesStack:SinksStack = new SinksStack();
		
		private const _attributeSink:AttributeNode = new AttributeNode();
		
		private var _readingTail:Boolean;
		
		private var _finished:Boolean = true;
		
		private var _openCount:int;
		
		private var _exitState:ReadExitState;
		
		protected var _name:String;
		
		public function ElementNode() { super(); }
		
		public function continueReading(from:ISinks):Boolean
		{
			this._finished = true;
			(from as XMLReader).lastNodeIn(this);
			if (this._exitState == ReadExitState.ATTRIBUTES)
			{
				// NOTE: repeating code
				if (this.loop(from) && this._finished)
				{
					trace("--- but was not here");
					this.readNodeEnd(from);
				}
				else this._exitState = ReadExitState.ATTRIBUTES;
			}
			else
			{
				this.readNodeEnd(from);
			}
			if (this._finished && this._openCount > 0)
			{
				trace("--- second chance?");
				(from as XMLReader).loop();
			}
			return from.hasMoreText();
		}
		
		public override function read(from:ISinks):Boolean
		{
			var reader:XMLReader = from as XMLReader;
			
			if (this._readingTail) this._openCount--;
			else this._openCount++;
			
			if (this._openCount < 0)
			{
				// this is a syntax error
				// once I have a mechanism for reporting errors, will have to 
				// handle it here
			}
			else
			{
				reader.lastNodeIn(this);
				// TODO: all calls to appendCollected text should go through 
				// the same place where they ask to format input
				super.appendParsedText("<", from);
				if (this.readName(reader) && this._finished)
				{
//					from.appendCollectedText(this._name);
					trace("--- was here");
					if (this.loop(from) && this._finished)
					{
						trace("--- but was not here");
						this.readNodeEnd(from);
//						if (this.readNodeEnd(from) && this._openCount > 0)
//						{
//							
//						}
					}
					else this._exitState = ReadExitState.ATTRIBUTES;
				}
				else
				{
					this._exitState = ReadExitState.NODE_NAME;
					reader.exitOnCurly(this);
				}
			}
			
			return from.hasMoreText();
		}
		
		private function readNodeEnd(from:ISinks):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			var match:String;
			
			this._finished = true;
			switch (subseq.charAt())
			{
				case "/":
					match = subseq.substr(0, 2);
					this._openCount--;
					break;
				case ">":
					match = subseq.charAt();
					break;
				default:
					this._finished = false;
					trace("this is a syntax error");
			}
			if (match)
				super.appendParsedText(super.report(match, from), from);
			return from.hasMoreText();
		}
		
		private function readName(from:XMLReader):Boolean
		{
			var match:String = from.source.substr(from.column);
			
			this._finished = false;
			if (this._readingTail)
			{
				super.report(match.substr(0, 2), from);
			}
			else super.report(match.charAt(), from);
			match = from.source.substr(from.column);
			if (match.charAt() != "{")
			{
				this._name = 
					super.appendParsedText(
						super.report(
							match.match(
								from.as3Sinks.settings.xmlRegExp.name)[0], 
							from), from);
				this._finished = true;
			}
			// Maybe I need to set state here 
			// (need to see what happens if we try to reuse the reader).
			return from.hasMoreText();
		}
		
		private function loop(from:ISinks):Boolean
		{
			var reader:XMLReader = from as XMLReader;
			var nextSink:ISink;
			
			this._attributesStack.clear();
			this._attributesStack.add(this._attributeSink)
				.add(reader.as3Sinks.whiteSink)
				.add(reader.as3Sinks.lineEndSink);
			
			while (nextSink = this._attributesStack.next())
			{
				if (nextSink.isSinkStart(from) && 
					nextSink.read(from) && 
					(!(nextSink is AttributeNode) || 
						(nextSink as AttributeNode).finished))
					this._attributesStack.reset();
			}
			this._finished = this._attributeSink.finished;
			
			return from.hasMoreText();
		}
		
		public override function isSinkStart(from:ISinks):Boolean
		{
			var result:Boolean = super.isSinkStart(from);
			var subseq:String = from.source.substr(from.column);
			
			if (result) // NOTE: once I add "return after {}", this will need to change 
				this._readingTail = subseq.charAt(1) == "/";
			else trace("did not match:", "|" + subseq.substr(0, 20));
			if (!result && subseq.charAt() == "<")
			{
				result = from.sinkEndRegExp(this).test(subseq);
				if (result) this._readingTail = true;
				trace("--- did you even try?", result, from.sinkEndRegExp(this));
			}
			trace("--- tried to match element:", result, this._readingTail, from.source.substr(from.column, 20));
			return result;
		}
		
		public function appendName(source:String):void
		{
			this._name = source;
		}
		
		public function appendAttributeName(source:String):AttributeNode
		{
			return this._attirubutes[
				this._attirubutes.push(new AttributeNode()) - 1
			].appendName(source);
		}
		
		public function appendAttributeValue(source:String):AttributeNode
		{
			return this._attirubutes[
				this._attirubutes.length - 1].appendValue(source);
		}
		
		public function appendChild(node:XMLNode):ElementNode
		{
			this._children.push(node);
			return this;
		}
		
		public override function toString():String
		{
			return nodeToString(this);
		}
		
		protected static function nodeToString(node:ElementNode, depth:int = 1):String
		{
			var padding:String = "";
			var attributes:String = node._attirubutes.join(" ");
			var result:String;
			var pad:int = depth;
			
			while (pad-- > 0) padding += "\t";
			result = "<" + node._name;
			if (attributes) result += " " + attributes;
			if (node._children.length)
			{
				result += ">\r";
				for each (var child:XMLNode in node._children)
				{
					if (child is ElementNode)
					{
						result += padding + nodeToString(child as ElementNode, depth + 1);
					}
					else result += padding + child.toString();
					result += "\r";
				}
				result += padding.substr(1) + "</" + node._name + ">";
			}
			else result += "/>";
			return result;
		}
	}
}