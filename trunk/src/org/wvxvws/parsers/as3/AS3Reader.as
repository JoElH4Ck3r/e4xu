package org.wvxvws.parsers.as3 
{
	import org.wvxvws.parsers.as3.resources.AS3ParserSettings;

	/**
	 * ...
	 * @author wvxvw
	 */
	public class AS3Reader
	{
		public function get settings():AS3ParserSettings { return this._settings; }
		
		protected var _sinks:AS3Sinks = new AS3Sinks();
		
		protected var _settings:AS3ParserSettings = new AS3ParserSettings();
		
		public function AS3Reader()
		{
			super();
			this._sinks.onASDocComment = this.onASDocComment;
			this._sinks.onASDocKeyword = this.onASDocKeyword;
			this._sinks.onBlockComment = this.onBlockComment;
			this._sinks.onLine = this.onLine;
			this._sinks.onLineComment = this.onLineComment;
			this._sinks.onNumber = this.onNumber;
			this._sinks.onRegExp = this.onRegExp;
			this._sinks.onString = this.onString;
			this._sinks.onWhiteSpace = this.onWhiteSpace;
			this._sinks.onDefault = this.onDefault;
			this._sinks.onOperator = this.onOperator;
			this._sinks.onXML = this.onXML;
			this._sinks.onKeyword = this.onKeyword;
			this._sinks.onClassName = this.onClassName;
			this._sinks.onReserved = this.onReserved;
		}
		
		public function readAsXML(source:String):XML
		{
			var before:Object = XML.settings();
			var result:XML;
			XML.prettyIndent = 0;
			XML.prettyPrinting = false;
			XML.ignoreWhitespace = false;
			result = XML("<pre class=\"code-base\">" + this.readAsString(source) + "</pre>");
			XML.setSettings(before);
			return result;
		}
		
		public function readAsString(source:String):String
		{
			var before:Object = XML.settings();
			var result:String;
			XML.prettyIndent = 0;
			XML.prettyPrinting = false;
			XML.ignoreWhitespace = false;
			this._sinks.read(source, this._settings);
			XML.setSettings(before);
			return this._sinks.collectedText;
		}
		
		protected function onClassName(text:String):String
		{
			return <span class="classname">{text}</span>.toXMLString();
		}
		
		protected function onKeyword(text:String):String
		{
			return <span class="keyword">{text}</span>.toXMLString();
		}
		
		protected function onReserved(text:String):String
		{
			return <span class="reserved">{text}</span>.toXMLString();
		}
		
		protected function onXML(text:String):String
		{
			return <span class="xml">{XMLList(text)}</span>.toXMLString();
		}
		
		protected function onOperator(text:String):String
		{
			return <span class="operator">{text}</span>.toXMLString();
		}
		
		protected function onWhiteSpace(text:String):String
		{
			return text.replace(/\ /g, "\u00A0")
				.replace(/\t/g, "\u00A0\u00A0\u00A0\u00A0");
		}
		
		protected function onASDocComment(text:String):String
		{
			return <span class="asdoc-comment">{
				this.whitePadding(text)}</span>.toXMLString();
		}
		
		protected function onDefault(text:String):String { return text; }
		
		protected function onASDocKeyword(text:String):String
		{
			return <span class="asdoc-keyword">{text}</span>.toXMLString();
		}
		
		protected function onBlockComment(text:String):String
		{
			return <span class="block-comment">{text}</span>.toXMLString();
		}
		
		protected function onLine(text:String):String { return "<br/>"; }
		
		protected function onLineComment(text:String):String
		{
			return <span class="line-comment">{text}</span>.toXMLString();
		}
		
		protected function onNumber(text:String):String
		{
			return <span class="number">{text}</span>.toXMLString();
		}
		
		protected function onRegExp(text:String):String
		{
			return <span class="regexp">{text}</span>.toXMLString();
		}
		
		protected function onString(text:String):String
		{
			return <span class="string">{text}</span>.toXMLString();
		}
		
		/**
		 * @private
		 * This is because XML.ignoreWhite = false will trim 
		 * whitespaces anyway.
		 * 
		 * @param text
		 * @return 
		 */
		private function whitePadding(text:String):String
		{
			var middle:String = text.replace(/^[\s]*(.*\S)[\s]*$/, "$1");
			var result:String;
			
			if (text == middle) result = text;
			else if (!middle) result = this.onWhiteSpace(text);
			else
			{
				result = this.onWhiteSpace(
					text.substr(0, text.indexOf(middle))) + 
					middle + this.onWhiteSpace(text.substr(
						text.indexOf(middle) + middle.length, text.length));
			}
			return result; 
		}
	}
}