package org.wvxvws.parsers.as3.sinks.xml
{
	import org.wvxvws.parsers.as3.AS3Sinks;
	import org.wvxvws.parsers.as3.ISinks;
	import org.wvxvws.parsers.as3.resources.XMLRegExp;

	public class AttributeNode extends XMLNode
	{
		public function get finished():Boolean { return this._finished; }
		
		private var _name:String;
		
		private var _finished:Boolean = true;
		
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
		
		// TODO: Needs cleanup
		public override function read(from:ISinks):Boolean
		{
			var expressions:XMLRegExp = 
				(from as XMLReader).as3Sinks.settings.xmlRegExp;
			var subseq:String = from.source.substr(from.column);
			var reader:XMLReader = from as XMLReader;
			
			reader.lastNodeIn(this);
			
			this._finished = false;
			
			if (subseq.charAt() != "{")
			{
				super.appendParsedText(
					super.report(
						(this._name = this.resetAndMatch(
							subseq, expressions.name)), from), from);
				
				if (reader.readWhite())
				{
					super.appendParsedText(
						super.report(
							this.resetAndMatch(
								from.source.substr(from.column), 
								expressions.attributeEQ), from), from);
					if (reader.readWhite())
					{
						subseq = from.source.substr(from.column);
						if (subseq.charAt() != "{")
						{
							super.appendParsedText(
								super.report(
									(this._value = this.resetAndMatch(
										subseq, expressions.attributeValue)),
										from), from);
							this._finished = true;
						}
						else reader.exitOnCurly(this);
					}
				}
			}
			else reader.exitOnCurly(this);
			
			return from.source.length > from.column;
		}
		
		public override function isSinkStart(from:ISinks):Boolean
		{
			trace("--- testing for attribute:", from.source.substr(from.column, 20));
			return (from.source.charAt(from.column) == "{") || 
				super.isSinkStart(from);
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