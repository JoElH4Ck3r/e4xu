package org.wvxvws.parsers.as3 
{
	import org.wvxvws.parsers.as3.resources.AS3ParserSettings;
	import org.wvxvws.parsers.as3.sinks.xml.E4XNodeKind;

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
			result = XML("<pre class=\"" + 
				this._settings.styles.codeBase + "\">" + 
				this.readAsString(source) + "</pre>");
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
			return this.formatNode(this._settings.styles.classname, text);
		}
		
		protected function onKeyword(text:String):String
		{
			return this.formatNode(this._settings.styles.keyword, text);
		}
		
		protected function onReserved(text:String):String
		{
			return this.formatNode(this._settings.styles.reserved, text);
		}
		
		protected function onXML(text:String, kind:E4XNodeKind):String
		{
			var style:String;
			
			switch (kind)
			{
				case E4XNodeKind.ATTRIBUTE:
					style = this._settings.styles.xmlAttribute;
					break;
				case E4XNodeKind.CDATA:
					style = this._settings.styles.xmlCData;
					break;
				case E4XNodeKind.COMMENT:
					style = this._settings.styles.xmlComment;
					break;
				case E4XNodeKind.ELEMENT:
					style = this._settings.styles.xmlElement;
					break;
				case E4XNodeKind.PROCESSING_INSTRUCTION:
					style = this._settings.styles.xmlPI;
					break;
				case E4XNodeKind.TEXT:
					style = this._settings.styles.xmlText;
					break;
			}
			return this.formatNode(this._settings.styles.xml + " " + style, text);
		}
		
		protected function onOperator(text:String):String
		{
			return this.formatNode(this._settings.styles.operator, text);
		}
		
		protected function onWhiteSpace(text:String):String
		{
			return text.replace(/\ /g, "\u00A0")
				.replace(/\t/g, "\u00A0\u00A0\u00A0\u00A0");
		}
		
		protected function onASDocComment(text:String):String
		{
			return this.formatNode(
				this._settings.styles.asdocComment, 
				this.whitePadding(text));
		}
		
		protected function onDefault(text:String):String { return text; }
		
		protected function onASDocKeyword(text:String):String
		{
			return this.formatNode(this._settings.styles.asdocKeyword, text);
		}
		
		protected function onBlockComment(text:String):String
		{
			return this.formatNode(this._settings.styles.blockComment, text);
		}
		
		protected function onLine(text:String):String { return "<br/>"; }
		
		protected function onLineComment(text:String):String
		{
			return this.formatNode(this._settings.styles.lineComment, text);
		}
		
		protected function onNumber(text:String):String
		{
			return this.formatNode(this._settings.styles.number, text);
		}
		
		protected function onRegExp(text:String):String
		{
			return this.formatNode(this._settings.styles.regexp, text);
		}
		
		protected function onString(text:String):String
		{
			return this.formatNode(this._settings.styles.string, text);
		}
		
		private function formatNode(style:String, text:String):String
		{
			return <span class={style}>{text}</span>.toXMLString();
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