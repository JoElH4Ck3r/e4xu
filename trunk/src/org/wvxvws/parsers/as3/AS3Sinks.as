package org.wvxvws.parsers.as3 
{
	import flash.utils.Dictionary;
	import org.wvxvws.parsers.as3.resources.AS3ParserSettings;
	import org.wvxvws.parsers.as3.sinks.RegExpSink;
	import org.wvxvws.parsers.as3.sinks.StringSink;
	import org.wvxvws.parsers.as3.sinks.WhiteSpaceSink;
	
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
		public var onWord:Function;
		public var onKeyword:Function;
		public var onParens:Function;
		public var onCurlyBrackets:Function;
		public var onSquareBrackets:Function;
		public var onWhiteSpace:Function;
		public var onCharacter:Function;
		public var onLine:Function;
		public var onClassName:Function;
		public var onError:Function;
		
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
		
		private var _line:int;
		private var _column:int;
		private var _lines:Vector.<String> = new <String>[];
		private var _source:String;
		private var _lastLineEnd:int;
		private var _word:String;
		private var _settings:AS3ParserSettings;
		private var _currentSink:ISink;
		private var _hasError:Boolean;
		private var _sinks:Dictionary = new Dictionary();
		private var _cleanSinks:Dictionary = new Dictionary();
		private var _error:AS3ReaderError;
		
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
			this._lines.splice(0, this._lines.length);
			this._word = "";
			//this.chooseNextSink();
			this.cleanSinks();
			this.sinkCombinator(this._cleanSinks[StringSink], StringSink);
		}
		
		public function advanceColumn(character:String):void
		{
			if (!this._hasError)
			{
				this._column++;
				//trace("advanceColumn", character, this._source.charAt(this._column));
				if (this.isWhiteSpace(character))
				{
					//trace("isWhiteSpace");
					if (this.onWhiteSpace) this.onWhiteSpace();
					this.wordEndHandler();
				}
				else if (this.isLineEnd(character))
				{
					//trace("isLineEnd");
					this._lines.push(
						this._source.substr(
							this._lastLineEnd, 
							this._column - this._lastLineEnd));
					this._lastLineEnd = this._column;
					this.wordEndHandler();
					if (this.onLine) this.onLine();
				}
				else if (this.isAphaNum(character))
				{
					//trace("isAphaNum", character);
					this._word += character;
				}
				else
				{
					//trace("Else", character);
					this.wordEndHandler();
				}
				if (this.onCharacter) this.onCharacter();
			}
		}
		
		public function reportError(message:String):void
		{
			this._hasError = true;
			this._error = new AS3ReaderError(message, this._line, this._column);
			if (this.onError && this.onError(this._error))
				this._hasError = false;
			else throw this._error;
		}
		
		private function buildDictionary():void
		{
			this._sinks[StringSink] = new StringSink();
			this._sinks[RegExpSink] = new RegExpSink();
			this._sinks[WhiteSpaceSink] = new WhiteSpaceSink();
		}
		
		// TODO: This is ugly, must think of a better way of doing it.
		//private function chooseNextSink():void
		//{
			//var quote:RegExp = this._settings.quoteRegExp;
			//var regexStart:RegExp = this._settings.regexStartRegExp;
			//var white:RegExp = this._settings.whiteSpaceRegExp;
			//var subseq:String = 
				//this._source.substring(this._column, this._source.length);
			//var match:String;
			//match = subseq.match(quote)[0];
			//if (match && subseq.indexOf(match) == 0)
			//{
				//quote.lastIndex = 0;
				//this._currentSink = this._sinks[StringSink];
				//if (this._currentSink.read(this))
				//{
					//this.chooseNextSink();
					//return;
				//}
			//}
			//
			//match = subseq.match(white)[0];
			//if (match && subseq.indexOf(match) == 0)
			//{
				//white.lastIndex = 0;
				//this._currentSink = this._sinks[WhiteSpaceSink];
				//if (this._currentSink.read(this))
				//{
					//this.chooseNextSink();
					//return;
				//}
			//}
			//
			//match = subseq.match(regexStart)[0];
			//if (match && subseq.indexOf(match) == 0)
			//{
				//regexStart.lastIndex = 0;
				//this._currentSink = this._sinks[RegExpSink];
				//if (this._currentSink.read(this))
				//{
					//this.chooseNextSink();
				//}
			//}
		//}
		
		private function sinkCombinator(regexp:RegExp, sinkClass:Class):void
		{
			var subseq:String = 
				this._source.substring(this._column, this._source.length);
			var match:String = subseq.match(regexp)[0];
			var cleanSink:Class;
			var cleanRE:RegExp;
			
			if (match && subseq.indexOf(match) == 0)
			{
				this._currentSink = this._sinks[sinkClass];
				if (this._currentSink.read(this))
				{
					this.cleanSinks();
					this.sinkCombinator(regexp, sinkClass);
				}
			}
			else
			{
				// TODO: This is not an ideal way to choose next sink to try.
				// Some cannot follow others, so it's useless trying them.
				for (var sink:Object in this._cleanSinks)
				{
					cleanRE = this._cleanSinks[sink] as RegExp;
					cleanSink = sink as Class;
					break;
				}
				if (cleanRE)
				{
					delete this._cleanSinks[cleanSink];
					this.sinkCombinator(cleanRE, cleanSink);
				}
			}
		}
		
		private function cleanSinks():void
		{
			this._cleanSinks[StringSink] = this._settings.quoteRegExp;
			this._cleanSinks[RegExpSink] = this._settings.regexStartRegExp;
			this._cleanSinks[WhiteSpaceSink] = this._settings.whiteSpaceRegExp;
		}
		
		private function wordEndHandler():void
		{
			if (this.isKeyword(this._word) && this.onKeyword)
				this.onKeyword();
			if (this.isClassName(this._word) && this.onClassName)
				this.onClassName();
			if (this.onWord && this._word) this.onWord();
			this._word = "";
		}
		
		private function isClassName(word:String):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		private function isKeyword(word:String):Boolean
		{
			var result:Boolean;
			
			return result;
		}
		
		private function isAphaNum(character:String):Boolean
		{
			return this.settings.alphaNumRegExp.test(character);
		}
		
		private function isLineEnd(character:String):Boolean
		{
			return this.settings.lineEndRegExp.test(character);
		}
		
		private function isWhiteSpace(character:String):Boolean
		{
			return this.settings.whiteSpaceRegExp.test(character);
		}
	}
}