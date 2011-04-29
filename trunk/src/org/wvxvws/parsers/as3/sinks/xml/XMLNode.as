package org.wvxvws.parsers.as3.sinks.xml
{
	import flash.utils.getQualifiedClassName;
	
	import org.wvxvws.parsers.as3.ISink;
	import org.wvxvws.parsers.as3.ISinks;

	public class XMLNode implements ISink
	{
		protected var _value:String = "";
		
		public function XMLNode() { super(); }
		
		public function append(source:String):void
		{
			this._value = source;
		}
		
		protected function report(text:String, toSinks:ISinks):String
		{
			// FIXME: whitespaces and line ends...
			if (!this._value) this._value = "";
			for (var position:int; position < text.length; position++)
				this._value += toSinks.advanceColumn(text.charAt(position));
			return text;
		}
		
		public function read(from:ISinks):Boolean
		{
			(from as XMLReader).lastNodeIn(this);
			from.appendCollectedText(
				this.report(
					from.source.substr(from.column)
						.match(from.sinkStartRegExp(this))[0], from));
			trace("reading node:", this);
			return from.source.length > from.column;
		}
		
		public function isSinkStart(from:ISinks):Boolean
		{
			trace("is sink start?", getQualifiedClassName(this), from.source.substr(from.column), from.sinkStartRegExp(this).test(
				from.source.substr(from.column)));
			return from.sinkStartRegExp(this).test(
				from.source.substr(from.column));
		}
		
		public function toString():String { return this._value; }
	}
}