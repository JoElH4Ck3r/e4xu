package org.wvxvws.automation
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	import org.wvxvws.automation.display.DisplayFunctions;
	import org.wvxvws.automation.language.DefunFunctions;
	import org.wvxvws.automation.language.LanguageFunctions;
	import org.wvxvws.automation.language.LetFunctions;
	import org.wvxvws.automation.language.ParensPackage;
	import org.wvxvws.automation.logic.LogicFunctions;
	import org.wvxvws.automation.math.MathFunctions;
	import org.wvxvws.automation.nodes.ComplexNode;
	import org.wvxvws.automation.nodes.EvalNode;
	import org.wvxvws.automation.nodes.LazyNode;
	import org.wvxvws.automation.nodes.Lexer;
	import org.wvxvws.automation.nodes.NamedSymbol;
	import org.wvxvws.automation.nodes.Node;
	import org.wvxvws.automation.strings.StringFunctions;
	import org.wvxvws.automation.time.TimeFunctions;
	import org.wvxvws.automation.utils.LoopFunctions;
	import org.wvxvws.automation.utils.UtilsFunctions;
	
	public class ParensParser
	{
		public function get language():LanguageFunctions { return this._language; }
		
		private var _input:String;
		private var _position:int;
		private var _currentNode:Node;
		private var _word:String;
		private var _isMethodName:Boolean;
		// TODO: global errors
		private var _inputError:String = "Input error";
		private var _roots:Vector.<Node>;
		private var _isFunctionEnd:Boolean;
		private var _lastRoot:Node;
		private var _language:LanguageFunctions;
		private var _lexer:Lexer;
		private var _defuns:DefunFunctions;
		private var _lets:LetFunctions;
		
		public function ParensParser()
		{
			super();
			this.buildScopes();
		}
		
		// NOTE: should decide whether to restrict identical lables.
		// Possibly should not allow.
		public function pushContext(context:Object, alias:String):void
		{
			var pack:ParensPackage;
			this._language.defpackage(alias);
			pack = this._language.getpackage(alias);
			var methods:XMLList = describeType(context).method;
			for each (var meta:XML in methods)
			{
				pack.extern(meta.@name, context[meta.@name]);
			}
			// Automatically populate "this" variable.
			this._language.inpackage(alias);
			this._language.defvar("this", context);
//			var pack:ParensPackage = this._parser.language.getpackage("test-runner");
//			pack.extern("this", this);
		}
		
		public function read(programs:String):Array
		{
			this._roots = new <Node>[];
			
			var pos:int;
			var len:int = programs.length;
			var values:Array = [];
			
			while (pos < len)
			{
				this.readFunction(programs.substr(pos))
				pos += this._position + 1;
				this._roots.push(this._lastRoot);
				if (this._lastRoot) values.push(this._lastRoot.value);
			}
			return values;
		}
		
		public function readFunction(program:String):void
		{
			var inputLenght:int;
			
			this._lexer = new Lexer();
			this._isFunctionEnd = false;
			this._position = 0;
			this._input = program;
			this._currentNode = null;
			this._word = "";
			inputLenght = this._input.length;
			this._lexer.closeHandler = this.closeHandler;
			this._lexer.defaultHandler = this.defaultHandler;
			this._lexer.delimiterHandler = this.delimiterHandler;
			this._lexer.openHandler = this.openHandler;
			
			while (this._position < inputLenght && !this._isFunctionEnd)
			{
				this._lexer.process(this._input.charAt(this._position));
				this._position++;
			}
			this._lastRoot = this._currentNode;
		}
		
		private function closeHandler():void
		{
			if (!this._currentNode || !(this._currentNode is ComplexNode)
				|| !(this._currentNode as ComplexNode).method)
			{
				// This must be the single method without parameters
				if ((this._currentNode is ComplexNode) && this._word)
				{
					(this._currentNode as ComplexNode).method = this._word;
					this._word = "";
				}
				else throw this._inputError;
			}
			if (this._word)
			{
				if (this._isMethodName) this.methodHandler();
				else this.valueHandler();
			}
			if (this._currentNode.parent)
				this._currentNode = this._currentNode.parent;
			else this._isFunctionEnd = true;
			this._isMethodName = false;
		}
		
		private function valueHandler():void
		{
			if (this._currentNode && this._word)
			{
				if (this._currentNode is ComplexNode)
				{
					(this._currentNode as ComplexNode)
					.add(new Node(this.inferValueType(this._word), 
						this.resolveContext, this.resolveMethod,
						this.propertyResolver));
				}
				else throw this._inputError;
			}
			this._word = "";
		}
		
		private function inferValueType(value:String):*
		{
			// TODO: this will get more complex some time...
			var real:*;
			var maybeString:String = value.replace(/^"([^"]*)"$/, "$1");
			var maybeNumber:Number = parseFloat(value);
			if (value != maybeString) real = maybeString;
			else if (!isNaN(maybeNumber)) real = maybeNumber;
			else if (value == "true") real = true;
			else if (value == "false") real = false;
			else if (value == "null") real = null;
			else real = new NamedSymbol(value, 
				this.resolveContext, this.resolveMethod,
				this.propertyResolver);
			return real;
		}
		
		private function methodHandler():void
		{
			if (this._currentNode && this._currentNode is ComplexNode)
			{
				// TODO: this is a quick patch, there should be a better way.
				// Maybe once I'll try to make macros and macroexpand...
				if (this._word == "bool:if")
				{
					var cond:LazyNode = 
						new LazyNode(undefined, this.resolveContext, 
							this.resolveMethod, this.propertyResolver);
					if (this._currentNode.parent)
					{
						(this._currentNode.parent as ComplexNode)
							.remove(this._currentNode);
						(this._currentNode.parent as ComplexNode).add(cond);
					}
					else this._currentNode = cond;
				}
				(this._currentNode as ComplexNode).method = this._word;
				this._isMethodName = false;
			}
			else throw this._inputError;
			this._word = "";
		}
		
		// TODO: should use different paths for functions and variables.
		// we don't care about the scope for a variable and it is meaningless
		// for statics or class methods, but anonymous functions do need it.
		private function resolveContext(packageName:String):ParensPackage
		{
			return this._language.resolvePackage(packageName);
		}
		
		private function resolveMethod(methodName:String):Function
		{
			var parts:Array = methodName.split(":");
			var method:String = parts.pop();
			var context:String = parts[0];
//			trace("resolving method", methodName);
			return this.resolveContext(context).get(method, this._language.currentPackage());
		}
		
		private function propertyResolver(symbol:NamedSymbol):*
		{
			return this._language.getvar(symbol.value);
		}
		
		private function buildScopes():void
		{
			var pack:ParensPackage;
			
			this._language = new LanguageFunctions(this);
			this._defuns = new DefunFunctions(this);
			this._lets = new LetFunctions(this);
			
			this._language.defpackage("lang");
			pack = this._language.getpackage("lang");
			pack.extern("defpackage", this._language.defpackage);
			pack.extern("defvar", this._language.defvar);
			pack.extern("getvar", this._language.getvar);
			pack.extern("inpackage", this._language.inpackage);
			pack.extern("setvar", this._language.setvar);
			pack.extern("getpackage", this._language.getpackage);
			pack.extern("defun", this._defuns.defun);
			pack.extern("arguments", this._defuns.makeFunctionArguments);
			pack.extern("body-form", this._defuns.makeFunctionBody);
			pack.extern("new", this._language.makeInstance);
			pack.extern("package", this._language.currentPackage);
			pack.extern("extern", this._language.externInCurrent);
			pack.extern("let", this._lets.bind);
			pack.extern("variables", this._lets.makeBindingsList);
			
			this._language.defpackage("math");
			pack = this._language.getpackage("math");
			pack.extern("+", MathFunctions.plus);
			pack.extern("-", MathFunctions.minus);
			pack.extern("random", MathFunctions.random);
			pack.extern("<", MathFunctions.less);
			pack.extern(">", MathFunctions.greater);
			pack.extern("++", MathFunctions.increment);
			
			this._language.defpackage("bool");
			pack = this._language.getpackage("bool");
			pack.extern("and", LogicFunctions.and);
			pack.extern("or", LogicFunctions.or);
			pack.extern("not", LogicFunctions.not);
			pack.extern("if", LogicFunctions.condition);
			pack.extern("=", LogicFunctions.eq);
			
			this._language.defpackage("string");
			pack = this._language.getpackage("string");
			pack.extern("+", StringFunctions.concat);
			
			this._language.defpackage("time");
			pack = this._language.getpackage("time");
			pack.extern("interval", TimeFunctions.interval);
			pack.extern("stop", TimeFunctions.stop);
			pack.extern("timeout", TimeFunctions.timeout);
			
			this._language.defpackage("utils");
			pack = this._language.getpackage("utils");
			pack.extern("print", UtilsFunctions.print);
			pack.extern("reflect", UtilsFunctions.reflect);
			pack.extern("dotimes", LoopFunctions.dotimes);
			pack.extern("funcall", UtilsFunctions.funcall);
			pack.extern("resolve-class", UtilsFunctions.resolveClass);
			pack.extern("slot-value", UtilsFunctions.slotValue);
			pack.extern("set-slot", UtilsFunctions.setSlot);
			
			this._language.defpackage("display");
			pack = this._language.getpackage("display");
			pack.extern("init", DisplayFunctions.init);
			pack.extern("click", DisplayFunctions.click);
			
			this._language.inpackage("lang");
		}
		
		private function delimiterHandler():void
		{
			if (this._isMethodName && this._word) this.methodHandler();
			else if (this._word) this.valueHandler();
		}
		
		private function defaultHandler():void
		{
			var char:String = this._input.charAt(this._position);
			this._word += this._input.charAt(this._position);
		}
		
		private function openHandler():void
		{
			var newNode:ComplexNode;
			if (this._lexer.nextIsQuote)
			{
				newNode = new EvalNode(undefined, 
					this.resolveContext, this.resolveMethod,
					this.propertyResolver);
			}
			else
			{
				newNode = new ComplexNode(undefined, 
					this.resolveContext, this.resolveMethod, this.propertyResolver);
			}
			if (this._word)
			{
				if (!this._isMethodName) this.valueHandler();
				else this.methodHandler();
			}
			this._isMethodName = true;
			if (this._currentNode) (this._currentNode as ComplexNode).add(newNode);
			newNode.parent = this._currentNode;
			this._currentNode = newNode;
		}
	}
}