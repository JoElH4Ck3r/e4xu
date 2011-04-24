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
	public class AS3Sinks
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
		
		public function get word():String { return this._word; }
		
		public function get currentSink():ISink { return this._currentSink; }
		
		public function get hasError():Boolean { return this._hasError; }
		
		public function get collectedText():String { return this._collectedText; }
		
		public function get whiteSink():WhiteSpaceSink { return this._whiteSink; }
		
		public function get lineEndSink():LineEndSink { return this._lineEndSink; }
		
		private var _line:int;
		private var _column:int;
		private var _lines:Vector.<String> = new <String>[];
		private var _source:String;
		private var _lastLineEnd:int;
		private var _word:String;
		private var _settings:AS3ParserSettings;
		private var _currentSink:ISink;
		private var _hasError:Boolean;
		private var _error:AS3ReaderError;
		
		private const _stack:SinksStack = new SinksStack();
		private var _collectedText:String = "";
		private var _collectWhiteSpaces:Boolean;
		private var _collectWords:Boolean;
		private var _collectLineEnds:Boolean;
		
		private var _whiteSink:WhiteSpaceSink;
		private var _lineEndSink:LineEndSink;
		
		private var _openCurly:int;
		private var _openSquare:int;
		private var _openParens:int;
		
		public function AS3Sinks()
		{
			super();
			this.buildDictionary();
		}
		
		public function read(source:String, settings:AS3ParserSettings):void
		{
			this._source = source;
			this._settings = settings;
			this._column = 0;
			this._lastLineEnd = 0;
			this._line = 0;
			// TODO: whoops, forgot these :) have to count them and collect!
			this._lines.splice(0, this._lines.length);
			this._word = "";
			this._collectedText = "";
			this.buildDictionary();
			this.loopSinks();
		}
		
		public function advanceColumn(character:String):String
		{
			if (!this._hasError)
			{
				this._column++;
				if (this.onCharacter) this.onCharacter(character);
			}
			return character;
		}
		
		public function appendCollectedText(text:String):void
		{
			this._collectedText += text;
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
		
		private function buildDictionary():void
		{
			this._stack.clear();
			this._lineEndSink = new LineEndSink();
			this._whiteSink = new WhiteSpaceSink();
			this._stack.add(new StringSink())
				.add(new RegExpSink())
				.add(this._whiteSink)
				.add(new LineCommentSink())
				.add(new BlockCommentSink())
				.add(new ASDocCommentSink())
				.add(this._lineEndSink)
				.add(new NumberSink())
				.add(new XMLSink())
				.add(new OperatorSink())
				.add(new DefaultSink());
		}
		
		private function loopSinks():void
		{
			var nextSink:ISink;
			while (nextSink = this._stack.next())
			{
				if (nextSink.isSinkStart(this) && nextSink.read(this))
					this._stack.reset();
			}
		}
	}
}