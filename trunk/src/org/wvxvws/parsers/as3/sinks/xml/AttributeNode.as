package org.wvxvws.parsers.as3.sinks.xml
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.resources.XMLRegExp;

	public class AttributeNode extends XMLNode implements ICurlyNode
	{
		public function get finished():Boolean { return this._finished; }
		
		private var _name:String;
		
		private var _finished:Boolean = true;
		
		private var _exitState:ReadExitState;
		
		private const _stack:Vector.<Function> = new <Function>[];
		
		public function AttributeNode() { super(); }
		
		public function appendName(source:String):AttributeNode
		{
			this._name = source;
			return this;
		}
		
		public function appendValue(source:String):AttributeNode
		{
			super._value = source;
			return this;
		}
		
		public function continueReading(from:ISinks):Boolean
		{
			// TODO:
			return from.hasMoreText();
		}
		
		public override function read(from:ISinks):Boolean
		{
			var expressions:XMLRegExp = 
				(from as XMLReader).as3Sinks.settings.xmlRegExp;
			var reader:XMLReader = from as XMLReader;
			
			this._stack.splice(0, this._stack.length);
			this._stack.push(
				this.readName,
				reader.readWhite,
				this.readEQ,
				reader.readWhite,
				this.readValue);
			
			reader.lastNodeIn(this);
			
			this._finished = false;
			
			for each (var next:Function in this._stack)
			{
				if ((next.length && !next(from, expressions)) || 
					(!next.length && !next()))
					break;
			}
			
			return from.hasMoreText();
		}
		
		public override function isSinkStart(from:ISinks):Boolean
		{
			trace("--- testing for attribute:", from.source.substr(from.column, 20));
			return (from.source.charAt(from.column) == "{") || 
				super.isSinkStart(from);
		}
		
		private function readEQ(from:ISinks, expressions:XMLRegExp):Boolean
		{
			super.appendParsedText(
				super.report(
					this.resetAndMatch(
						from.source.substr(from.column), 
						expressions.attributeEQ), from), from);
			return from.hasMoreText();
		}
		
		private function readName(from:ISinks, expressions:XMLRegExp):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			var result:Boolean;
			
			if (subseq.charAt() != "{")
			{
				super.appendParsedText(
					super.report(
						(this._name = this.resetAndMatch(
							subseq, expressions.name)), from), from);
				result = true;
			}
			else
			{
				this.exit(ReadExitState.NODE_NAME, from);
			}
			return result && from.hasMoreText();
		}
		
		private function readValue(from:ISinks, expressions:XMLRegExp):Boolean
		{
			var subseq:String = from.source.substr(from.column);
			
			if (subseq.charAt() != "{")
			{
				super.appendParsedText(
					super.report(
						(this._value = this.resetAndMatch(
							subseq, expressions.attributeValue)), from), from);
				this._finished = true;
			}
			else this.exit(ReadExitState.NODE_VALUE, from);
			return from.hasMoreText();
		}
		
		private function exit(kind:ReadExitState, from:ISinks):void
		{
			this._exitState = kind;
			(from as XMLReader).exitOnCurly(this);
		}
		
		private function resetAndMatch(seq:String, expression:RegExp):String
		{
			expression.lastIndex = 0;
			return seq.match(expression)[0];
		}
		
		public override function toString():String
		{
			return this._name + "=" + super._value;
		}
	}
}