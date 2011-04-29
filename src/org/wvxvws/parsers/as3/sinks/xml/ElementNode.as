package org.wvxvws.parsers.as3.sinks.xml
{
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.SinksStack;

	public class ElementNode extends XMLNode
	{
		public function get finished():Boolean { return this._finished; }
		
		protected var _name:String;
		
		protected const _attirubutes:Vector.<AttributeNode> = new <AttributeNode>[];
		
		protected const _children:Vector.<XMLNode> = new <XMLNode>[];
		
		private var _openCount:int;
		
		private const _attributesStack:SinksStack = new SinksStack();
		
		private const _attributeSink:AttributeNode = new AttributeNode();
		
		private var _readingTail:Boolean;
		
		private var _finished:Boolean;
		
		public function ElementNode() { super(); }
		
		public override function read(from:ISinks):Boolean
		{
			if (this._readingTail) this._openCount--;
			else this._openCount++;
			
			return from.source.length > from.column;
		}
		
		private function loop(from:ISinks):void
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
					nextSink.read(from))
					this._attributesStack.reset();
			}
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