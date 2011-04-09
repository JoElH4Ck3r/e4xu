package org.wvxvws.parsers.as3 
{
	import flash.utils.Dictionary;
	import org.wvxvws.parsers.as3.resources.AS3ParserSettings;
	import org.wvxvws.parsers.as3.sinks.ASDocKeywordSink;
	import org.wvxvws.parsers.as3.sinks.BlockCommentSink;
	import org.wvxvws.parsers.as3.sinks.LineCommentSink;
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
		
		public function get collectedText():String { return this._collectedText; }
		
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
		
		//private const _sinks:Dictionary = new Dictionary();
		//private const _cleanSinks:Dictionary = new Dictionary();
		private const _stack:SinksStack = new SinksStack();
		private var _collectedText:String = "";
		private var _collectWhiteSpaces:Boolean;
		private var _collectWords:Boolean;
		private var _collectLineEnds:Boolean;
		
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
			this._collectedText = "";
			//this.chooseNextSink();
			//this.cleanSinks();
			this.buildDictionary();
			this.loopSinks();
			//this.sinkCombinator(this._cleanSinks[StringSink], StringSink);
		}
		
		// TODO: this is becoming nasty...
		public function advanceColumn(character:String):void
		{
			var maybeCollect:String;
			
			if (!this._hasError)
			{
				this._column++;
				//trace("advanceColumn", character, this._source.charAt(this._column));
				if (this.isWhiteSpace(character))
				{
					//trace("isWhiteSpace");
					if (this.onWhiteSpace)
					{
						maybeCollect = this.onWhiteSpace(character);
						if (this._collectWhiteSpaces)
							this._collectedText += maybeCollect;
					}
					else if (this._collectWhiteSpaces)
						this._collectedText += character;
					if (this._collectWords) this.wordEndHandler();
				}
				else if (this.isLineEnd(character))
				{
					//trace("isLineEnd");
					this._lines.push(
						this._source.substr(
							this._lastLineEnd, 
							this._column - this._lastLineEnd));
					this._lastLineEnd = this._column;
					if (this._collectWords) this.wordEndHandler();
					if (this.onLine)
					{
						maybeCollect = this.onLine(character);
						if (this._collectLineEnds)
							this._collectedText += this.onLine(character);
					}
					else if (this._collectLineEnds)
						this._collectedText += character;
				}
				else if (this.isAphaNum(character))
				{
					//trace("isAphaNum", character);
					if (this._collectWords) this._word += character;
				}
				else
				{
					//trace("Else", character);
					if (this._collectWords) this.wordEndHandler();
				}
				if (this.onCharacter) this.onCharacter(character);
			}
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
		
		private function buildDictionary():void
		{
			//this._sinks[StringSink] = new StringSink();
			//this._sinks[RegExpSink] = new RegExpSink();
			//this._sinks[WhiteSpaceSink] = new WhiteSpaceSink();
			//this._sinks[LineCommentSink] = new LineCommentSink();
			//this._sinks[BlockCommentSink] = new BlockCommentSink();
			//this._sinks[ASDocKeywordSink] = new ASDocKeywordSink();
			this._stack.clear();
			this._stack.add(new StringSink())
				.add(new RegExpSink())
				.add(new WhiteSpaceSink())
				.add(new LineCommentSink())
				.add(new BlockCommentSink())
				.add(new ASDocKeywordSink());
		}
		
		private function loopSinks():void
		{
			var nextSink:ISink;
			var flags:Vector.<Function> = 
				new <Function>[
					this.collectLineEnds, 
					this.collectWhitespaces, 
					this.collectWords];
			while (nextSink = this._stack.next())
			{
				if (nextSink.isSinkStart(this) && nextSink.read(this, flags))
					this._stack.reset();
			}
		}
		
		// TODO: relying on regexp is not ideal. I will have to add a 
		// isSinkStart():Boolean instead.
		// TOD: we may eventually run out of space in call stack. Will need
		// to unroll the recursion here.
		//private function sinkCombinator(regexp:RegExp, sinkClass:Class):void
		//{
			//var subseq:String = this._source.substring(this._column);
			//var match:String = subseq.match(regexp)[0];
			//var cleanSink:Class;
			//var cleanRE:RegExp;
			//trace("sinkCombinator:", regexp, "**********", match, "||||", subseq, subseq.indexOf(match));
			//if (match && subseq.indexOf(match) == 0)
			//{
				//this._currentSink = this._sinks[sinkClass];
				//if (this._currentSink.read(this))
				//{
					//this.cleanSinks();
					//this.sinkCombinator(regexp, sinkClass);
				//}
			//}
			//else
			//{
				// TODO: This is not an ideal way to choose next sink to try.
				// Some cannot follow others, so it's useless trying them.
				//for (var sink:Object in this._cleanSinks)
				//{
					//cleanRE = this._cleanSinks[sink] as RegExp;
					//cleanSink = sink as Class;
					//break;
				//}
				//if (cleanRE)
				//{
					//delete this._cleanSinks[cleanSink];
					//this.sinkCombinator(cleanRE, cleanSink);
				//}
			//}
		//}
		
		//private function cleanSinks():void
		//{
			//this._cleanSinks[StringSink] = this._settings.quoteRegExp;
			//this._cleanSinks[RegExpSink] = this._settings.regexStartRegExp;
			//this._cleanSinks[WhiteSpaceSink] = this._settings.whiteSpaceRegExp;
			//this._cleanSinks[LineCommentSink] = this._settings.lineCommentStartRegExp;
			//this._cleanSinks[BlockCommentSink] = this._settings.blockCommentStartRegExp;
			//this._cleanSinks[ASDocKeywordSink] = this._settings.asdocCommentStartRegExp;
		//}
		
		private function wordEndHandler():void
		{
			if (this.isKeyword(this._word) && this.onKeyword)
				this._collectedText += this.onKeyword(this._word);
			else if (this.isClassName(this._word) && this.onClassName)
				this._collectedText += this.onClassName(this._word);
			else if (this.onWord && this._word)
				this._collectedText += this.onWord(this._word);
			else this._collectedText += this._word;
			this._word = "";
		}
		
		private function collectWhitespaces(value:Boolean):void
		{
			this._collectWhiteSpaces = value;
		}
		
		private function collectWords(value:Boolean):void
		{
			this._collectWords = value;
		}
		
		private function collectLineEnds(value:Boolean):void
		{
			this._collectLineEnds = value;
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