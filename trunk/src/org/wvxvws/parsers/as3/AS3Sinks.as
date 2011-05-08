package org.wvxvws.parsers.as3 
{
	import flash.utils.Dictionary;
	
	import org.wvxvws.parsers.as3.resources.AS3ParserSettings;
	import org.wvxvws.parsers.as3.resources.BracketsInfo;
	import org.wvxvws.parsers.as3.sinks.ASDocCommentSink;
	import org.wvxvws.parsers.as3.sinks.ASDocKeywordSink;
	import org.wvxvws.parsers.as3.sinks.BlockCommentSink;
	import org.wvxvws.parsers.as3.sinks.DefaultSink;
	import org.wvxvws.parsers.as3.sinks.LineCommentSink;
	import org.wvxvws.parsers.as3.sinks.LineEndSink;
	import org.wvxvws.parsers.as3.sinks.NumberSink;
	import org.wvxvws.parsers.as3.sinks.OperatorSink;
	import org.wvxvws.parsers.as3.sinks.RegExpSink;
	import org.wvxvws.parsers.as3.sinks.StringSink;
	import org.wvxvws.parsers.as3.sinks.WhiteSpaceSink;
	import org.wvxvws.parsers.as3.sinks.XMLListSink;
	import org.wvxvws.parsers.as3.sinks.XMLSink;
	
	/**
	 * Note that in order for this class to compile without warnings, you would
	 * have to edit flex-config.xml in your SDK.
	 * Find this line:
	 * <pre>&lt;warn-unlikely-function-value&gt;true&lt;/warn-unlikely-function-value&gt;</pre>
	 * and change it to:
	 * <pre>&lt;warn-unlikely-function-value&gt;false&lt;/warn-unlikely-function-value&gt;</pre>
	 * And this is how you should be working in general ;)
	 * Alternatively you could add this parameter elsewhere in your project setup:
	 * <pre>-warn-unlikely-function-value=false</pre>
	 * 
	 * @author wvxvw
	 */
	public class AS3Sinks extends SinksBase implements ISinks
	{
		public var onASDocComment:Function;
		public var onASDocKeyword:Function;
		public var onBlockComment:Function;
		public var onLineComment:Function;
		public var onString:Function;
		public var onNumber:Function;
		public var onRegExp:Function;
		public var onXML:Function;
		public var onOperator:Function;
		public var onKeyword:Function;
		public var onWhiteSpace:Function;
		public var onDefault:Function;
		public var onCharacter:Function;
		public var onLine:Function;
		public var onClassName:Function;
		public var onError:Function;
		public var onReserved:Function;
		
		public function get line():int { return this._line; }
		
		public function get column():int { return this._column; }
		
		public function get source():String { return this._source; }
		
		public function get settings():AS3ParserSettings
		{
			return this._settings;
		}
		
		public function get hasError():Boolean { return this._hasError; }
		
		public function get collectedText():String { return this._collectedText; }
		
		public function get whiteSink():WhiteSpaceSink { return this._whiteSink; }
		
		public function get lineEndSink():LineEndSink { return this._lineEndSink; }
		
		public function get xmlSink():XMLSink { return this._xmlSink; }
		
		// TODO: some of these will habe to go into base class.
		private var _line:int;
		private var _column:int;
		private var _lines:Vector.<String> = new <String>[];
		private var _source:String;
		private var _settings:AS3ParserSettings;
		private var _hasError:Boolean;
		private var _error:AS3ReaderError;
		
		private var _collectedText:String = "";
		private var _whiteSink:WhiteSpaceSink;
		private var _lineEndSink:LineEndSink;
		private var _operatorSink:OperatorSink;
		private var _xmlSink:XMLSink;
		private var _xmlListSink:XMLListSink;
		
		private var _openCurly:int;
		private var _openSquare:int;
		private var _openParens:int;
		private var _readingXMLList:Boolean;
		
		public function AS3Sinks() { super(); }
		
		public function read(source:String, settings:AS3ParserSettings):void
		{
			this._source = source;
			this._settings = settings;
			this._column = 0;
			this._line = 0;
			// TODO: whoops, forgot these :) have to count them and collect!
			this._lines.splice(0, this._lines.length);
			this._collectedText = "";
			super.readInternal();
		}
		
		public function hasMoreText():Boolean { return this._source.length > this._column; }
		
		public function remainingText():String { return this._source.substr(this._column); }
		
		public function advanceColumn(character:String):String
		{
			if (!this._hasError)
			{
				this._column++;
				if (this.onCharacter) this.onCharacter(character);
			}
			return character;
		}
		
		public function readXMLList(state:Boolean):Boolean
		{
			return this._readingXMLList = state;
		}
		
		public function appendCollectedText(text:String):void
		{
			this._collectedText += text;
		}
		
		// TODO: there should be a better way...
		public function readClosingCurly():AS3Sinks
		{
			var formerSource:String = this._source;
			var formerCoulumn:int = this._column;
			this._column = 0;
			this._source = "}";
			this._operatorSink.read(this);
			this._source = formerSource;
			this._column = formerCoulumn + 1;
			return this;
		}
		
		public function readHandler(forSink:ISink, forWord:String = null):Function
		{
			var result:Function;
			
			switch ((forSink as Object).constructor)
			{
				case ASDocCommentSink:
					result = this.onASDocComment;
					break;
				case ASDocKeywordSink:
					result = this.onASDocKeyword;
					break;
				case BlockCommentSink:
					result = this.onBlockComment;
					break;
				case DefaultSink:
					result = this.selectDefaultHandler(forWord);
					break;
				case LineCommentSink:
					result = this.onLineComment;
					break;
				case lineEndSink:
					result = this.onLine;
					break;
				case NumberSink:
					result = this.onNumber;
					break;
				case OperatorSink:
					result = this.onOperator;
					break;
				case RegExpSink:
					result = this.onRegExp;
					break;
				case StringSink:
					result = this.onString;
					break;
				case WhiteSpaceSink:
					result = this.onWhiteSpace;
					break;
				case XMLSink:
				case XMLListSink:
					result = this.onXML;
					break;
			}
			return result;
		}			
		
		public function sinkEndRegExp(forSink:ISink):RegExp
		{
			var result:RegExp;
			
			switch ((forSink as Object).constructor)
			{
				case ASDocCommentSink:
				case BlockCommentSink:
					result = this._settings.blockCommentEndRegExp;
					break;
				case NumberSink:
					result = this._settings.numberRegExp;
					break;
				case RegExpSink:
					result = this._settings.regexEndRegExp;
					break;
				case XMLListSink:
					result = this._settings.xmlListEndRegExp;
					break;
			}
			return result;
		}
		
		private function selectDefaultHandler(forWord:String):Function
		{
			var result:Function;
			
			if (this._settings.isKeyword(forWord) && this.onKeyword)
				result = this.onKeyword;
			else if (this._settings.isClassName(forWord) && this.onClassName)
				result = this.onClassName;
			else if (this._settings.isReserved(forWord) && this.onReserved)
				result = this.onReserved;
			else if (this.onDefault)
				result = this.onDefault;
			return result;
		}
		
		public function sinkStartRegExp(forSink:ISink):RegExp
		{
			var result:RegExp;
			
			switch ((forSink as Object).constructor)
			{
				case ASDocCommentSink:
					result = this._settings.asdocCommentStartRegExp;
					break;
				case ASDocKeywordSink:
					result = this._settings.asdocKeywordRegExp;
					break;
				case BlockCommentSink:
					result = this._settings.blockCommentStartRegExp;
					break;
				case DefaultSink:
					result = this._settings.wordRegExp;
					break;
				case LineCommentSink:
					result = this._settings.lineCommentStartRegExp;
					break;
				case LineEndSink:
					result = this._settings.lineEndRegExp;
					break;
				case NumberSink:
					result = this._settings.numberStartRegExp;
					break;
				case OperatorSink:
					result = this._settings.operatorRegExp;
					break;
				case RegExpSink:
					result = this._settings.regexStartRegExp;
					break;
				case StringSink:
					result = this._settings.quoteRegExp;
					break;
				case WhiteSpaceSink:
					result = this._settings.whiteSpaceRegExp;
					break;
				case XMLSink:
					result = this._settings.xmlStartRegExp;
					break;
				case XMLListSink:
					result = this._settings.xmlListStartRegExp;
					break;
			}
			return result;
		}
		
		public function reportError(message:String):void
		{
			this._hasError = true;
			this._error = new AS3ReaderError(message, this._line, this._column);
			if (this.onError && this.onError(this._error))
				this._hasError = false;
			else throw this._error;
		}
		
		public function incrementBracket():void
		{
			var info:BracketsInfo = this._settings.bracketInfo;
			
			switch (this._source.charAt(this._column - 1))
			{
				case info.curlyOpen:
					this._openCurly++;
					break;
				case info.curlyClose:
					this._openCurly--;
					break;
				case info.parenOpen:
					this._openParens++;
					break;
				case info.parenClose:
					this._openParens--;
					break;
				case info.squareOpen:
					this._openSquare++;
					break;
				case info.squareClose:
					this._openSquare--;
					break;
			}
		}
		
		public function bracketCount(bracket:String):int
		{
			var info:BracketsInfo = this._settings.bracketInfo;
			var result:int;
			
			switch (bracket)
			{
				case info.curlyOpen:
					result = this._openCurly;
					break;
				case info.curlyClose:
					result = -this._openCurly;
					break;
				case info.parenOpen:
					result = this._openParens;
					break;
				case info.parenClose:
					result = -this._openParens;
					break;
				case info.squareOpen:
					result = this._openSquare;
					break;
				case info.squareClose:
					result = -this._openSquare;
					break;
			}
			return result;
		}
		
		protected override function buildDictionary(stack:SinksStack = null):SinksStack
		{
			var result:SinksStack = super.buildDictionary();
			this._stack.add(new StringSink())
				.add(new RegExpSink())
				.add(this._whiteSink = new WhiteSpaceSink())
				.add(new LineCommentSink())
				.add(new BlockCommentSink())
				.add(new ASDocCommentSink())
				.add(this._lineEndSink = new LineEndSink())
				.add(new NumberSink())
				.add(this._xmlListSink = new XMLListSink())
				.add(this._xmlSink = new XMLSink())
				.add(this._operatorSink = new OperatorSink())
				.add(new DefaultSink());
			return result;
		}
	}
}