package org.wvxvws.parsers.as3.sinks.xml
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.SinksStack;
	import org.wvxvws.parsers.as3.resources.XMLRegExp;

	public class E4XNode
	{
		public function get root():E4XNode { return this._root; }
		
		public function get kind():E4XNodeKind { return this._kind; }
		
		public function get hasAttributes():Boolean
		{
			return this._hasAttributes;
		}
		
		public function get hasChildren():Boolean { return this._hasChildren; }
		
		public function get parent():E4XNode { return this._parent; }
		
		public function get readState():E4XReadState
		{
			return this._readState;
		}
		
		public function get continueFrom():E4XNode { return this._continueFrom; }
		
		protected var _root:E4XNode;
		
		protected var _kind:E4XNodeKind;
		
		protected var _readState:E4XReadState;
		
		protected var _hasAttributes:Boolean;
		
		protected var _hasChildren:Boolean;
		
		protected var _parent:E4XNode;
		
		protected var _childrenProcessed:int;
		
		protected var _children:Vector.<E4XNode>;
		
		protected var _hasMoreAttributes:Boolean;
		
		protected const _whiteStack:SinksStack = new SinksStack();
		
		protected var _continueFrom:E4XNode;
		
		public function E4XNode(root:E4XNode)
		{
			super();
			if (root) this._root = root;
			else this._root = this;
		}
		
		public function readName(from:AS3Sinks, kind:E4XNodeKind):E4XReadState
		{
			var subseq:String = from.source.substr(from.column);
			var current:String = subseq.charAt();
			var match:String;
			var result:E4XReadState;
			
			if (current == "{")
			{
				// TODO:
				result = E4XReadState.BRACKET;
			}
			else
			{
				match = subseq.match(from.settings.xmlRegExp.name)[0];
				from.settings.xmlRegExp.name.lastIndex = 0;
				for (var i:int; i < match.length; i++)
					from.advanceColumn(match.charAt(i));
				this.reportCollected(
					(this._kind = kind), match, from);
				result = E4XReadState.NAME;
			}
			return result;
		}
		
		public function readAttributes(from:AS3Sinks):E4XReadState
		{
			var state:E4XReadState;
			while ((state = this.readNextAttribute(from)) ==
				E4XReadState.ATTRIBUTE) { }
			return state;
		}
		
		public function readNextAttribute(from:AS3Sinks):E4XReadState
		{
			var subseq:String;
			var match:String;
			var result:E4XReadState = this.readWhite(from);
			var i:int;
			
			if (result == E4XReadState.ATTRIBUTE)
			{
				result = this.readName(from, E4XNodeKind.ATTRIBUTE);
				if (result == E4XReadState.NAME)
				{
					result = this.readWhite(from);
					if (result == E4XReadState.ATTRIBUTE)
					{
						subseq = from.source.substr(from.column);
						match = subseq.match(from.settings.xmlRegExp.attributeEQ)[0];
						from.settings.xmlRegExp.attributeEQ.lastIndex = 0;
						
						for (i = 0; i < match.length; i++)
							from.advanceColumn(match.charAt(i));
						this.reportCollected(
							(this._kind = E4XNodeKind.ATTRIBUTE), match, from);
						result = this.readWhite(from);
						if (result == E4XReadState.ATTRIBUTE)
						{
							subseq = from.source.substr(from.column);
							if (subseq.charAt() == "{")
							{
								// TODO:
								result = E4XReadState.BRACKET;
							}
							else
							{
								match = subseq.match(from.settings.xmlRegExp.attributeValue)[0];
								from.settings.xmlRegExp.attributeEQ.lastIndex = 0;
								for (i = 0; i < match.length; i++)
									from.advanceColumn(match.charAt(i));
								this.reportCollected(
									(this._kind = E4XNodeKind.ATTRIBUTE), match, from);
								result = this.readWhite(from);
							}
						}
					}
				}
			}
			
			return result;
		}
		
		public function readWhite(from:AS3Sinks):E4XReadState
		{
			var subseq:String;
			var nextSink:ISink;
			var afterWhite:String;
			var result:E4XReadState;
			
			this._whiteStack.clear();
			this._whiteStack.add(from.whiteSink).add(from.lineEndSink);
			
			while (nextSink = this._whiteStack.next())
			{
				if (nextSink.isSinkStart(from) && nextSink.read(from))
					this._whiteStack.reset();
			}
			subseq = from.source.substr(from.column);
			if (from.settings.xmlRegExp.gt.test(subseq))
			{
				result = E4XReadState.GT;
				from.settings.xmlRegExp.gt.lastIndex = 0;
			}
			else if (subseq.charAt() == "{")
				result = E4XReadState.BRACKET;
			else result = E4XReadState.ATTRIBUTE;
			return result;
		}
		
		public function readChildern(from:AS3Sinks):E4XReadState
		{
			var node:E4XReadState;
			
			return node;
		}
		
		public function readNextChild(from:AS3Sinks):E4XReadState
		{
			var node:E4XReadState;
			
			return node;
		}
		
		public function readLt(from:AS3Sinks):E4XReadState
		{
			var subseq:String = from.source.substr(from.column);
			var current:String = subseq.charAt();
			var result:E4XReadState;
			var xmlRE:XMLRegExp = from.settings.xmlRegExp;
			var match:String;
			
			if (current == "<")
			{
				if (xmlRE.cdata.test(subseq))
				{
					result = this.readCData(from);
					xmlRE.cdata.lastIndex = 0;
				}
				else if (xmlRE.comment.test(subseq))
				{
					result = this.readComment(from);
					xmlRE.comment.lastIndex = 0;
				}
				else if (xmlRE.pi.test(subseq))
				{
					result = this.readPI(from);
					xmlRE.pi.lastIndex = 0;
				}
				else result = E4XReadState.NAME;
				this._readState = E4XReadState.LT;
				from.advanceColumn(current);
				this.reportCollected(
					(this._kind = E4XNodeKind.ELEMENT), current, from);
			}
			else
			{
				result = this.readText(from);
				if (result != E4XReadState.BRACKET)
					result = this.readLt(from);
			}
			return result;
		}
		
		public function readGt(from:AS3Sinks):E4XReadState
		{
			var result:E4XReadState;
			var subseq:String = from.source.substr(from.column);
			var current:String = subseq.charAt();
			var match:String;
			var i:int;
			
			match = from.advanceColumn(current);
			if (current == "/")
			{
				current = subseq.charAt((i = 1));
				match += from.advanceColumn(current);
				// up level and then either "brother" or up
				result = E4XReadState.BACK;
			}
			else result = E4XReadState.CONTINUE;
			if (subseq.charAt(i + 1) == "{")
				result = E4XReadState.BRACKET;
			return result;
		}
		
		public function readTail(from:AS3Sinks):E4XReadState
		{
			var node:E4XReadState;
			
			return node;
		}
		
		public function readText(from:AS3Sinks):E4XReadState
		{
			var node:E4XReadState;
			
			return node;
		}
		
		public function readCData(from:AS3Sinks):E4XReadState
		{
			var node:E4XReadState;
			
			return node;
		}
		
		public function readComment(from:AS3Sinks):E4XReadState
		{
			var node:E4XReadState;
			
			return node;
		}
		
		public function readPI(from:AS3Sinks):E4XReadState
		{
			var node:E4XReadState;
			
			return node;
		}
		
		public function moveToParent(from:AS3Sinks):E4XNode
		{
			var node:E4XNode;
			
			return node;
		}
		
		public function moveToChild(from:AS3Sinks):E4XNode
		{
			var node:E4XNode = new E4XNode(this._root);
			node._parent = this;
			return node;
		}
		
		public function read(from:AS3Sinks):E4XReadState
		{
			var child:E4XNode;
			var result:E4XReadState;
			
			result = this.readLt(from);
			trace("-- <");
			if (result == E4XReadState.NAME)
			{
				trace("-- name");
				result = this.readName(from, E4XNodeKind.ELEMENT);
				if (result != E4XReadState.BRACKET)
				{
					trace("-- body");
					result = this.readWhite(from);
					trace("-- body 1");
					if (result != E4XReadState.BRACKET && result != E4XReadState.GT)
					{
						result = this.readAttributes(from);
						trace("-- attributes");
						if (result != E4XReadState.BRACKET)
						{
							trace("-- >");
							result = this.readGt(from);
							trace("-- after >", result);
							if (result == E4XReadState.CONTINUE)
							{
								this.moveToChild(from).read(from);
							}
							else if (result == E4XReadState.BACK && this._parent)
							{
								this.moveToParent(from).read(from);
							}
						}
					}
					else if (result == E4XReadState.GT)
					{
						trace("-- > 1");
						result = this.readGt(from);
					}
					this.moveToParent(from);
				}
			}
			else if (result == E4XReadState.BRACKET)
			{
				
			}
			else result = this.readTail(from);
			
			return result;
		}
		
		protected function reportCollected(kind:E4XNodeKind, text:String, from:AS3Sinks):void
		{
			if (from.onXML)
			{
				if (from.onXML.length > 1)
					from.appendCollectedText(from.onXML(text, kind));
				else from.appendCollectedText(from.onXML(text));
			}
			else from.appendCollectedText(text);
		}
	}
}