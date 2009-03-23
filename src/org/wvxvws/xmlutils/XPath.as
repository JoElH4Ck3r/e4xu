package org.wvxvws.xmlutils 
{
	
	/**
	 * XPath class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
	 */
	public class XPath 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------ selectors -------------//
		public static const ROOT:String = "/"; //  	Selects from the root node
		public static const LIST:String = "//"; // 	Selects nodes in the document from the current node that match the selection no matter where they are
		public static const CURRENT:String = "."; // 	Selects the current node
		public static const UP:String = ".."; // 	Selects the parent of the current node
		public static const ATTRIBUTES:String = "@"; // 	Selects attributes
		
		public static const ANCESTOR:String = "ancestor"; //  	Selects all ancestors (parent, grandparent, etc.) of the current node
		public static const ANCESTOR_OR_SELF:String = "ancestor-or-self"; // 	Selects all ancestors (parent, grandparent, etc.) of the current node and the current node itself
		public static const ATTRIBUTE:String = "attribute"; // 	Selects all attributes of the current node
		public static const CHILD:String = "child"; // 	Selects all children of the current node
		public static const DESCENDANT:String = "descendant"; // 	Selects all descendants (children, grandchildren, etc.) of the current node
		public static const DESCENDANT_OR_SELF:String = "descendant-or-self"; // 	Selects all descendants (children, grandchildren, etc.) of the current node and the current node itself
		public static const FOLLOWING:String = "following"; // 	Selects everything in the document after the closing tag of the current node
		public static const FOLLOWING_SIBLING:String = "following-sibling"; // 	Selects all siblings after the current node
		public static const NAMESPACE:String = "namespace"; // 	Selects all namespace nodes of the current node
		public static const PARENT:String = "parent"; // 	Selects the parent of the current node
		public static const PRECEDING:String = "preceding"; // 	Selects everything in the document that is before the start tag of the current node
		public static const PRECEDING_SIBLING:String = "preceding-sibling"; // 	Selects all siblings before the current node
		public static const SELF:String = "self"; // Selects the current node

		
		//------------ operators ---------------//
		public static const PIPE:String = "|"; //  	Computes two node-sets  	 //book | //cd  	 Returns a node-set with all book and cd elements
		public static const PLUS:String = "+"; // 	Addition 	6 + 4 	10
		public static const MINUS:String = "-"; // 	Subtraction 	6 - 4 	2
		public static const MULTIPLICATION:String = "*";  //	Multiplication 	6 * 424
		public static const DIVISION:String = "div"; // 	Division 	8 div 4 	2
		public static const EQUAL:String = "="; // 	Equal 	price = 9.80 	true if price is 9.80 false if price is 9.90
		public static const NOT_EQUAL:String = "!="; // 	Not equal 	price != 9.80 	true if price is 9.90 false if price is 9.80
		public static const LESS_THAN:String = "<"; // 	Less than 	price < 9.80 	true if price is 9.00 false if price is 9.80
		public static const LESS_THAN_OR_EQUAL:String = "<="; // 	Less than or equal to 	price <= 9.80 	true if price is 9.00 false if price is 9.90
		public static const GREATER_THAN:String = ">"; // 	Greater than 	price > 9.80 	true if price is 9.90 false if price is 9.80
		public static const GREATER_THAN_OR_EQUAL:String = ">="; // 	Greater than or equal to 	price >= 9.80 	true if price is 9.90 false if price is 9.70
		public static const OR:String =	"or"; // 	price = 9.80 or price = 9.70 	true if price is 9.80 false if price is 9.50
		public static const AND:String = "and"; // 	price > 9.00 and price < 9.90 	true if price is 9.80 false if price is 8.50
		public static const MODULUS:String = "mod"; // 	Modulus (division remainder) 	5 mod 2 	1
		public static const SELECTOR:String = "::";
		public static const FUNCTION:String = "fn:";
		public static const OPERATOR:String = "op:";
		
		private static const W3C_XML:Namespace = new Namespace("xml", "http://www.w3.org/XML/1998/namespace");
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function XPath() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Mix-ins
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns the value of the base-uri property of the current or specified node
		 * @return	String.
		 */
		public static var baseURI:Function = function(node:InteractiveModel = null):String
		{
			if (node !== null) return node.namespace().uri;
			return InteractiveModel(this).namespace().uri;
		}
		
		/**
		 * Returns the value of the document-uri property for the specified node
		 * @param	node
		 * @return
		 */
		public static var documentURI:Function = function(node:InteractiveModel = null):String
		{
			if (node !== null) return node.root().namespace().uri;
			return InteractiveModel(this).root().namespace().uri;
		}
		
		/**
		 * Returns the length of the specified string. 
		 * If there is no string argument it returns the length of 
		 * the string value of the current node.
		 * Example: string-length('Beatles')
		 * Result: 7
		 * @param	string
		 * @return
		 */
		public static var stringLength:Function = function(string:String = null):int
		{
			if (string) return string.length;
			return InteractiveModel(this).toXMLString().length;
		}
		
		/**
		 * Returns absolute URL
		 * @param	relative
		 * @param	base
		 * @return
		 */
		public static var resolveUri:Function = function(relative:Boolean, base:String = null):String
		{
			if (!base) return InteractiveModel(this).url() + ROOT + relative;
			return base + ROOT + relative;
		}
		
		public static var qname:Function = function(name:String):QName
		{
			var na:Array = name.split(":");
			var ns:Namespace = new Namespace(na[0], InteractiveModel(this).url());
			return new QName(na[0], ns);
		}
		
		public static var localNameFromQName:Function = function():String
		{
			return QName(InteractiveModel(this).name()).localName;
		}
		
		public static var namespaceUriFromQName:Function = function():String
		{
			return QName(InteractiveModel(this).name()).uri;
		}
		
		public static var namespaceURIForPrefix:Function = function(prefix:String):String
		{
			var nss:Array = InteractiveModel(this).namespaceDeclarations();
			for each(var ns:Namespace in nss)
			{
				if (ns.prefix == prefix) return ns.uri;
			}
			return "";
		}
		
		public static var inScopePrefixes:Function = function():Array
		{
			var nss:Array = InteractiveModel(this).namespaceDeclarations();
			var ra:Array = [];
			for each(var ns:Namespace in nss) ra.push(ns.prefix);
			return ra;
		}
		
		/**
		 * Returns the name of the current node or the first node in the specified node set
		 * @param	nodeset
		 * @return
		 */
		public static var name:Function = function(nodeset:InteractiveModel = null):QName
		{
			if (nodeset) return QName(nodeset.name());
			return QName(InteractiveModel(this).name());
		}
		
		/**
		 * Returns the name of the current node or the first node in the 
		 * specified node set - without the namespace prefix
		 * @param	nodeset = null
		 * @return
		 */
		public static var localName:Function = function(nodeset:InteractiveModel = null):String
		{
			if (nodeset) return nodeset.localName();
			return InteractiveModel(this).localName();
		}
		
		/**
		 * Returns the namespace URI of the current node or the first node 
		 * in the specified node set
		 * @param	nodeset
		 * @return
		 */
		public static var namespaceURI:Function = function(nodeset:InteractiveModel = null):String
		{
			if (nodeset) return nodeset.namespace().uri;
			return InteractiveModel(this).namespace().uri;
		}
		
		/**
		 * Returns true if the language of the current node matches the language of the specified language.
		 * Example: Lang("en") is true for
		 * <p xml:lang="en">...</p>
		 * Example: Lang("de") is false for
		 * <p xml:lang="en">...</p>
		 * @param	lang
		 * @return
		 */
		public static var lang:Function = function(lang:String):Boolean
		{
			return InteractiveModel(this).W3C_XML::lang() == lang;
		}
		
		public static var nodeKind:Function = function():String
		{
			return InteractiveModel(this).nodeKind();
		}
		
		
		/**
		 * Returns the root of the tree to which the current node 
		 * or the specified belongs. This will usually be a document node
		 * @param	node
		 * @return
		 */
		public static var root:Function = function(node:InteractiveModel = 
															null):InteractiveModel
		{
			if (node) return node.root();
			return InteractiveModel(this).root();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function eval(expression:String, model:InteractiveModel):Boolean
		{
			var exp:Array = expression.split(/(|)/g);
			var fn:Function = XPath[exp[0]];
			var ret:Boolean;
			if (fn == null) throw new XPathError(1, exp[0]);
			if (fn.apply != null)
			{
				if (exp[1])
				{
					ret = fn.apply(model, exp[1].split(","));
				}
				else
				{
					ret = fn.call(model);
				}
			}
			else
			{
				if (exp[1])
				{
					ret = fn(exp[1].split(","));
				}
				else
				{
					ret = fn();
				}
			}
			return ret;
		}
		
		/**
		 * Returns the node-name of the argument node
		 * @param	node
		 * @return	Object
		 */
		public static function nodeName(node:InteractiveModel):Object { return node.name(); }
		
		/**
		 * Returns a Boolean value indicating whether the argument node is nilled
		 * @param	node
		 * @return	Boolean
		 */
		public static function nilled(node:InteractiveModel):Boolean
		{
			var declarations:Array = node.namespaceDeclarations();
			for each(var ns:Namespace in declarations)
			{
				if (ns.prefix == "xsi" && node.ns::["@nil"] == "true" &&
													node.@*.length() == 1)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Takes a sequence of items and returns a sequence of atomic values
		 * @param	...rest
		 * @return	InteractiveList.
		 */
		public static function data(...rest):InteractiveList
		{
			var list:XMLList = XMLList(rest.shift());
			while (rest.length) list += XMLList(rest.shift());
			var ilist:InteractiveList = new InteractiveList(null, null, list);
			return ilist;
		}
		
		/**
		 * Example: error(fn:QName('http://example.com/test', 'err:toohigh'), 'Error: Price is too high')
		 * Result: Returns http://example.com/test#toohigh and the string "Error: Price is too high" to the external processing environment
		 */
		public static function error(description:String):void
		{
			throw new Error(description);
		}
		
		/**
		 * Used to debug queries
		 * @param	value
		 * @param	label
		 * @return
		 */
		public static function xtrace(value:Object, label:String):void { }
		
		/**
		 * Returns the numeric value of the argument. The argument could be a boolean, string, or node-set.
		 * Example: number('100')
		 * Result: 100
		 * @param	arg
		 * @return	Number.
		 */
		public static function number(arg:Object):Number { return Number(arg); }

		/**
		 * Returns the absolute value of the argument
		 * Example: abs(3.14)
		 * Result: 3.14
		 * @param	num
		 * @return	Number.
		 */
		public static function abs(num:Object):Number { return Math.abs(Number(num)); }
		
		/**
		 * Returns the smallest integer that is greater than the number argument
		 * Example: ceiling(3.14)
		 * Result: 4
		 * @param	num
		 * @return	Number.
		 */
		public static function ceiling(num:Object):Number { return Math.ceil(Number(num)); }
		
		/**
		 * Returns the largest integer that is not greater than the number argument
		 * Example: floor(3.14)
		 * Result: 3
		 * @param	num
		 * @return	Number.
		 */
		public static function floor(num:Object):Number { return Number(num) >> 0; }
		
		/**
		 * Rounds the number argument to the nearest integer
		 * Example: round(3.14)
		 * Result: 3
		 */
		public static function round(num:Object):Number { return Math.round(Number(num)); }

		/**
		 * Example: round-half-to-even(0.5)
		 * Result: 0
		 * Example: round-half-to-even(1.5)
		 * Result: 2
		 * Example: round-half-to-even(2.5)
		 * Result: 2
		 * @param	num
		 * @return	Number.
		 */
		public static function roundHalfToEven(num:Object):Number
		{
			return ((Math.ceil(Number(num)) / 2) >> 0) * 2;
		}
		
		/**
		 * Returns the string value of the argument. The argument could be a number, boolean, or node-set
		 * Example: string(314)
		 * Result: "314"
		 * @param	arg
		 * @return	String.
		 */
		public static function string(arg:Object):String { return arg.toString() }
		
		/**
		 * Returns a string from a sequence of code points
		 * Example: codepoints-to-string(84, 104, 233, 114, 232, 115, 101)
		 * Result: 'Thérèse'
		 * @param	...rest
		 * @return	String.
		 */
		public static function codepointsToString(...rest):String
		{
			var i:int = rest.length;
			var rs:String = "";
			while (i--) rs = String.fromCharCode(rest[i]) + rs;
			return rs;
		}
		
		/**
		 * Returns a sequence of code points from a string
		 * Example: string-to-codepoints("Thérèse")
		 * Result: 84, 104, 233, 114, 232, 115, 101
		 * @param	string
		 * @return	Array.
		 */
		public static function stringToCodepoints(string:String):Array
		{
			var ra:Array = [];
			var i:int = string.length;
			while (i--) ra.unshift(string.charCodeAt(i));
			return ra;
		}
		
		// TODO: Figure out what's this :)
		/**
		 * Returns true if the value of comp1 is equal to the value of comp2, 
		 * according to the Unicode code point collation 
		 * (http://www.w3.org/2005/02/xpath-functions/collation/codepoint), 
		 * otherwise it returns false
		 * @param comp1
		 * @param comp2
		 * @return Boolean.
		 */
		public static function codepointEqual(comp1:int, comp2:int):Boolean { return false; }
		
		// TODO: Figure out what's this :)
		/**
		 * Returns -1 if comp1 is less than comp2, 0 if comp1 is equal to comp2,
		 * or 1 if comp1 is greater than comp2 
		 * (according to the rules of the collation that is used)
		 * Example: compare('ghi', 'ghi')
		 * Result: 0
		 * @param	comp1
		 * @param	comp2
		 * @param	collation
		 * @return
		 */
		public static function compare(comp1:int, comp2:int, collation:Boolean = false):int { return -1; }
		
		/**
		 * Returns the concatenation of the strings.
		 * Example: concat('XPath ','is ','FUN!')
		 * Result: 'XPath is FUN!'
		 * @param	...strings
		 * @return
		 */
		public static function concat(...strings):String { return strings.join(""); }
		
		/**
		 * Returns a string created by concatenating the string arguments 
		 * and using the sep argument as the separator
		 * Example: string-join(('We', 'are', 'having', 'fun!'), ' ')
		 * Result: ' We are having fun! '
		 * Example: string-join(('We', 'are', 'having', 'fun!'))
		 * Result: 'Wearehavingfun!'
		 * Example:string-join((), 'sep')
		 * Result: ''
		 * @param	sep
		 * @param	...strings
		 * @return	String.
		 */
		public static function stringJoin(sep:String, ...strings):String
		{
			return strings.join(sep);
		}
		
		/**
		 * Example: substring('Beatles',1,4)
		 * Result: 'Beat'
		 * Example: substring('Beatles',2)
		 * Result: 'eatles'
		 * @param	string
		 * @param	start
		 * @param	len
		 * @return
		 */
		public static function substring(string:String, start:int, len:int = 0x7FFFFFFF):String
		{
			return string.substr(start, len);
		}
		
		/**
		 * Removes leading and trailing spaces from the specified string, 
		 * and replaces all internal sequences of white space with one and 
		 * returns the result. If there is no string argument it does the 
		 * same on the current node
		 * Example: normalize-space(' The   XML ')
		 * Result: 'The XML'
		 * @param	string
		 * @return	String.
		 */
		public static function normalizeSpace(string:String):String
		{
			return string.replace(/(\s|\t)+/gm, " ");
		}
		
		// TODO: Figure out what's this :)
		/**
		 * 
		 * @return	String.
		 */
		public static function normalizeUnicode():String { return ""; }
		
		/**
		 * Converts the string argument to upper-case.
		 * Example: upper-case('The XML')
		 * Result: 'THE XML'
		 * @param	string
		 * @return	String.
		 */
		public static function upperCase(string:String):String { return string.toUpperCase(); }
		
		/**
		 * Converts the string argument to lower-case.
		 * Example: lower-case('The XML')
		 * Result: 'the xml'
		 * @param	string
		 * @return
		 */
		public static function lowerCase(string:String):String { return string.toLowerCase(); }
		
		/**
		 * Converts string1 by replacing the characters in string2 with 
		 * the characters in string3
		 * Example: translate('12:30','30','45')
		 * Result: '12:45'
		 * Example: translate('12:30','03','54')
		 * Result: '12:45'
		 * Example: translate('12:30','0123','abcd')
		 * Result: 'bc:da'
		 * @param	string1
		 * @param	string2
		 * @param	string3
		 * @return	String.
		 */
		public static function translate(string1:String, string2:String, string3:String):String
		{
			if (string2.length != string3.length)
				throw new XPathError(1, string2 + " and " + string3);
			var result:Array = string1.split();
			var inArr:Array = string2.split();
			var outArr:Array = string3.split();
			var i:int;
			while (i++ < string1.length)
			{
				if (string1.charAt(i) == inArr[0])
				{
					result[i] = outArr.shift();
					inArr.shift();
				}
			}
			return result.join();
		}
		
		/**
		 * Example: escape-uri("http://example.com/test#car", true())
		 * Result: "http%3A%2F%2Fexample.com%2Ftest#car"
		 * Example: escape-uri("http://example.com/test#car", false())
		 * Result: "http://example.com/test#car"
		 * Example: escape-uri ("http://example.com/~bébé", false())
		 * Result: "http://example.com/~b%C3%A9b%C3%A9"
		 * @param	stringURI
		 * @param	reverse
		 * @default	<code>false</code>
		 * 
		 * @return	String.
		 */
		public static function escapeUri(stringURI:String, reverse:Boolean = false):String
		{
			if (reverse) return encodeURI(stringURI);
			return unescape(stringURI);
		}
		
		/**
		 * Returns true if string1 contains string2, otherwise it returns false
		 * Example: contains('XML','XM')
		 * Result: true
		 * @param	string1
		 * @param	string2
		 * @return	Boolean.
		 */
		public static function contains(string1:String, string2:String):Boolean
		{
			return string1.indexOf(string2) > -1;
		}
		
		/**
		 * Returns true if string1 starts with string2, otherwise it returns false.
		 * Example: starts-with('XML','X')
		 * Result: true
		 * @param	string1
		 * @param	string2
		 * @return	Boolean.
		 */
		public static function startsWith(string1:String, string2:String):Boolean
		{
			return string1.indexOf(string2) == 0;
		}
		
		/**
		 * Returns true if string1 ends with string2, otherwise it returns false.
		 * Example: ends-with('XML','X')
		 * Result: false
		 * @param	string1
		 * @param	string2
		 * @return
		 */
		public static function endsWith(string1:String, string2:String):Boolean
		{
			return string1.lastIndexOf(string2) == string1.length - string2.length;
		}
		
		/**
		 * Returns the start of string1 before string2 occurs in it.
		 * Example: substring-before('12/10','/')
		 * Result: '12'
		 * @param	string1
		 * @param	string2
		 * @return
		 */
		public static function substringBefore(string1:String, string2:String):String
		{
			return string1.substr(0, string1.indexOf(string2));
		}
		
		/**
		 * Returns the remainder of string1 after string2 occurs in it.
		 * Example: substring-after('12/10','/')
		 * Result: '10'
		 * @param	string1
		 * @param	string2
		 * @return
		 */
		public static function substringAfter(string1:String, string2:String):String
		{
			var i:int = string1.lastIndexOf(string2);
			return string1.substr(i, string1.length - i);
		}
		
		/**
		 * Returns true if the string argument matches the pattern, otherwise, it returns false
		 * Example: matches("Merano", "ran")
		 * Result: true
		 * @param	string
		 * @param	pattern
		 * 
		 * @return	Boolean
		 */
		public static function matches(string:String, pattern:RegExp):Boolean
		{
			return Boolean(string.match(pattern));
		}
		
		/**
		 * Returns a string that is created by replacing the given pattern 
		 * with the replace argument
		 * Example: replace("Bella Italia", "l", "*")
		 * Result: 'Be**a Ita*ia'
		 * Example: replace("Bella Italia", "l", "")
		 * Result: 'Bea Itaia'
		 * @param	string
		 * @param	pattern
		 * @param	replace
		 * 
		 * @return	String
		 */
		public static function replace(string:String, pattern:RegExp, replace:String):String
		{
			return string.replace(pattern, replace);
		}
		
		/**
		 * Example: tokenize("XPath is fun", "\s+")
		 * Result: ("XPath", "is", "fun")
		 * @param	string
		 * @param	pattern
		 * @return
		 */
		public static function tokenize(string:String, pattern:RegExp):Array
		{
			return string.split(pattern);
		}
		
		/**
		 * Returns a boolean value for a number, string, or node-set.
		 * @param	arg
		 * @return
		 */
		public static function boolean(arg:*):Boolean { return Boolean(arg); }
		
		/**
		 * The argument is first reduced to a boolean value 
		 * by applying the boolean() function. Returns true if 
		 * the boolean value is false, and false if the boolean value is true.
		 * Example: not(true())
		 * Result: false
		 * @param	arg
		 * @return
		 */
		public static function not(arg:*):Boolean { return !arg; }
		
		/**
		 * Returns <code>true</code>.
		 * @return	<code>true</code>
		 */
		public static function xtrue():Boolean { return true; }
		
		/**
		 * Returns <code>false</code>.
		 * @return	<code>false</code>
		 */
		public static function xfalse():Boolean { return false; }
		
		// TODO: Figure out what's this.
		public static function resolveQName():void { }
		
		/**
		 * Returns the positions within the sequence of items 
		 * that are equal to the searchitem argument
		 * Example: index-of ((15, 40, 25, 40, 10), 40)
		 * Result: (2, 4)
		 * Example: index-of (("a", "dog", "and", "a", "duck"), "a")
		 * Result (1, 4)
		 * Example: index-of ((15, 40, 25, 40, 10), 18)
		 * Result: ()
		 * @param	searchitem
		 * @param	items
		 * @return
		 */
		public static function indexOf(searchitem:Object, items:Array):Array
		{
			var i:int;
			var ra:Array = [];
			do
			{
				i = items.indexOf(searchitem, i);
				if (i > -1) ra.push(i);
			}
			while (i > -1);
			return ra;
		}
		
		/**
		 * Returns a new sequence constructed from the value of the 
		 * item arguments - with the item specified by the position 
		 * argument removed
		 * Example: remove(("ab", "cd", "ef"), 0)
		 * Result: ("ab", "cd", "ef")
		 * Example: remove(("ab", "cd", "ef"), 1)
		 * Result: ("cd", "ef")
		 * Example: remove(("ab", "cd", "ef"), 4)
		 * Result: ("ab", "cd", "ef")
		 * @param	position
		 * @param	...items
		 * @return
		 */
		public static function remove(position:int, ...items):InteractiveList { return null; }

		/**
		 * Returns true if the value of the arguments IS an empty sequence, 
		 * otherwise it returns false.
		 * Example: empty(remove(("ab", "cd"), 1))
		 * Result: false
		 * @param	...items
		 * @return
		 */
		public static function empty(...items):Boolean { return true; }

		/**
		 * Returns true if the value of the arguments IS NOT an empty sequence, 
		 * otherwise it returns false
		 * Example: exists(remove(("ab"), 1))
		 * Result: false
		 * @param	...items
		 * @return
		 */
		public static function exists(...items):Boolean { return true; }

		/**
		 * Returns only distinct (different) values.
		 * Example: distinct-values((1, 2, 3, 1, 2))
		 * Result: (1, 2, 3)
		 * @param	...items
		 * @return	Array.
		 */
		public static function distinctValues(...items):InteractiveList
		{
			return null;
		}

		/**
		 * Returns a new sequence constructed from the value of the item 
		 * arguments - with the value of the inserts argument inserted 
		 * in the position specified by the pos argument
		 * Example: insert-before(("ab", "cd"), 0, "gh")
		 * Result: ("gh", "ab", "cd")
		 * Example: insert-before(("ab", "cd"), 1, "gh")
		 * Result: ("gh", "ab", "cd")
		 * Example: insert-before(("ab", "cd"), 2, "gh")
		 * Result: ("ab", "gh", "cd")
		 * Example: insert-before(("ab", "cd"), 5, "gh")
		 * Result: ("ab", "cd", "gh")
		 * @param	pos
		 * @param	inserts
		 * @param	...items
		 * @return	Array.
		 */
		public static function insertBefore(pos:int, inserts:XML, 
										...items):InteractiveList
		{
			return null;
		}

		/**
		 * Returns the reversed order of the items specified.
		 * Example: reverse(("ab", "cd", "ef"))
		 * Result: ("ef", "cd", "ab")
		 * Example: reverse(("ab"))
		 * Result: ("ab")
		 * @param	...items
		 * @return
		 */
		public static function reverse(...items):InteractiveList
		{
			return null;
		}
		
		/**
		 * Returns a sequence of items from the position specified 
		 * by the start argument and continuing for the number 
		 * of items specified by the len argument. 
		 * The first item is located at position 1
		 * Example: subsequence(($item1, $item2, $item3,...), 3)
		 * Result: ($item3, ...)
		 * Example: subsequence(($item1, $item2, $item3, ...), 2, 2)
		 * Result: ($item2, $item3)
		 * @param	start
		 * @param	len
		 * @param	...items
		 * @return
		 */
		public static function subsequence(start:int, len:int, ...items):InteractiveList
		{
			return null;
		}

		/**
		 * Returns the items in an implementation dependent order.
		 * @param	...items
		 * @return
		 */
		public static function unordered(...items):InteractiveList
		{
			return null;
		}
		
		/**
		 * Returns the argument if it contains zero or one items, 
		 * otherwise it raises an error
		 * @param	...items
		 * @return
		 * 
		 * @throws XPathError.
		 */
		public static function zeroOrOne(...items):InteractiveList
		{
			return null;
		}
		
		/**
		 * Returns the argument if it contains one or more items, 
		 * otherwise it raises an error
		 * @param	...items
		 * @return
		 * 
		 * @throws XPathError.
		 */
		public static function oneOrMore(...items):InteractiveList
		{
			return null;
		}
		
		/**
		 * Returns the argument if it contains exactly one item, 
		 * otherwise it raises an error
		 * @param	...items
		 * @return
		 * 
		 * @throws XPathError.
		 */
		public static function exactlyOne(...items):InteractiveList
		{
			return null;
		}
		
		/**
		 * Returns true if param1 and param2 are deep-equal 
		 * to each other, otherwise it returns false
		 * @param	...items
		 * @return
		 */
		public static function deepEqual(...items):Boolean
		{
			return true;
		}
		
		/**
		 * Returns the count of nodes
		 * @param	...items
		 * @return
		 */
		public static function count(...items):int
		{
			return 0;
		}
		
		/**
		 * Returns the average of the argument values.
		 * Example: avg((1,2,3))
		 * Result: 2
		 * @param	...numbers
		 * @return
		 */
		public static function avg(...numbers):Number
		{
			return 0;
		}
		

		/**
		 * Returns the argument that is greater than the others.
		 * Example: max((1,2,3))
		 * Result: 3
		 * Example: max(('a', 'k'))
		 * Result: 'k'
		 * @param	...numbers
		 * @return
		 */
		public static function max(...numbers):Number
		{
			return 0;
		}
		
		/**
		 * Returns the argument that is less than the others.
		 * Example: min((1,2,3))
		 * Result: 1
		 * Example: min(('a', 'k'))
		 * Result: 'a'
		 * @param	...numbers
		 * @return
		 */
		public static function min(...numbers):Number
		{
			return 0;
		}

		/**
		 * Returns the sum of the numeric value of each node in the specified node-set.
		 * @param	...numbers
		 * @return
		 */
		public static function sum(...numbers):Number
		{
			return 0;
		}
		
		/**
		 * Returns a sequence of element nodes that have an ID value 
		 * equal to the value of one or more of the values specified 
		 * in the string argument
		 * @param	...ids
		 * @return
		 */
		public static function id(...ids):InteractiveList
		{
			return null;
		}
		
		/**
		 * Returns a sequence of element or attribute nodes that have 
		 * an IDREF value equal to the value of one or more of the values 
		 * specified in the string argument
		 * @param	...idrefs
		 * @return
		 */
		public static function idref(...idrefs):InteractiveList
		{
			return null;
		}
		
		public static function doc(URI:String):InteractiveModel { return null; }
		
		/**
		 * Returns true if the doc() function returns a document node, 
		 * otherwise it returns false
		 * @param	URI
		 * @return
		 */
		public static function docAvailable(URI:String):Boolean
		{
			return true;
		}
		
		public static function collection(string:String = null):InteractiveList
		{
			return null;
		}
		
		/**
		 * Returns the index position of the node that is currently being processed.
		 * Example: //book[position()<=3]
		 * Result: Selects the first three book elements
		 * @return
		 */
		public static function position():int { return 0; }
		

		/**
		 * Returns the number of items in the processed node list.
		 * Example: //book[last()]
		 * Result: Selects the last book element
		 * @return
		 */
		public static function last():int { return 0; }
		
/* 8.469
		public static function dateTime(date,time) 	Converts the arguments to a date and a time
		public static function years-from-duration(datetimedur) 	Returns an integer that represents the years component in the canonical lexical representation of the value of the argument
		public static function months-from-duration(datetimedur) 	Returns an integer that represents the months component in the canonical lexical representation of the value of the argument
		public static function days-from-duration(datetimedur) 	Returns an integer that represents the days component in the canonical lexical representation of the value of the argument
		public static function hours-from-duration(datetimedur) 	Returns an integer that represents the hours component in the canonical lexical representation of the value of the argument
		public static function minutes-from-duration(datetimedur) 	Returns an integer that represents the minutes component in the canonical lexical representation of the value of the argument
		public static function seconds-from-duration(datetimedur) 	Returns a decimal that represents the seconds component in the canonical lexical representation of the value of the argument
		public static function year-from-dateTime(datetime) 	Returns an integer that represents the year component in the localized value of the argument

		/**
		 * Example: year-from-dateTime(xs:dateTime("2005-01-10T12:30-04:10"))
		 * Result: 2005
		public static function month-from-dateTime(datetime) 	Returns an integer that represents the month component in the localized value of the argument

		/**
		 * Example: month-from-dateTime(xs:dateTime("2005-01-10T12:30-04:10"))
		 * Result: 01
		public static function day-from-dateTime(datetime) 	Returns an integer that represents the day component in the localized value of the argument

		/**
		 * Example: day-from-dateTime(xs:dateTime("2005-01-10T12:30-04:10"))
		 * Result: 10
		public static function hours-from-dateTime(datetime) 	Returns an integer that represents the hours component in the localized value of the argument

		/**
		 * Example: hours-from-dateTime(xs:dateTime("2005-01-10T12:30-04:10"))
		 * Result: 12
		public static function minutes-from-dateTime(datetime) 	Returns an integer that represents the minutes component in the localized value of the argument

		/**
		 * Example: minutes-from-dateTime(xs:dateTime("2005-01-10T12:30-04:10"))
		 * Result: 30
		public static function seconds-from-dateTime(datetime) 	Returns a decimal that represents the seconds component in the localized value of the argument

		/**
		 * Example: seconds-from-dateTime(xs:dateTime("2005-01-10T12:30:00-04:10"))
		 * Result: 0
		public static function timezone-from-dateTime(datetime) 	Returns the time zone component of the argument if any
		public static function year-from-date(date) 	Returns an integer that represents the year in the localized value of the argument

		/**
		 * Example: year-from-date(xs:date("2005-04-23"))
		 * Result: 2005
		public static function month-from-date(date) 	Returns an integer that represents the month in the localized value of the argument

		/**
		 * Example: month-from-date(xs:date("2005-04-23"))
		 * Result: 4
		public static function day-from-date(date) 	Returns an integer that represents the day in the localized value of the argument

		/**
		 * Example: day-from-date(xs:date("2005-04-23"))
		 * Result: 23
		public static function timezone-from-date(date) 	Returns the time zone component of the argument if any
		public static function hours-from-time(time) 	Returns an integer that represents the hours component in the localized value of the argument

		/**
		 * Example: hours-from-time(xs:time("10:22:00"))
		 * Result: 10
		public static function minutes-from-time(time) 	Returns an integer that represents the minutes component in the localized value of the argument

		/**
		 * Example: minutes-from-time(xs:time("10:22:00"))
		 * Result: 22
		public static function seconds-from-time(time) 	Returns an integer that represents the seconds component in the localized value of the argument

		/**
		 * Example: seconds-from-time(xs:time("10:22:00"))
		 * Result: 0
		public static function timezone-from-time(time) 	Returns the time zone component of the argument if any
		public static function adjust-dateTime-to-timezone(datetime,timezone) 	If the timezone argument is empty, it returns a dateTime without a timezone. Otherwise, it returns a dateTime with a timezone
		public static function adjust-date-to-timezone(date,timezone) 	If the timezone argument is empty, it returns a date without a timezone. Otherwise, it returns a date with a timezone
		public static function adjust-time-to-timezone(time,timezone) 	If the timezone argument is empty, it returns a time without a timezone. Otherwise, it returns a time with a timezone

		public static function current-dateTime() 	Returns the current dateTime (with timezone)
		public static function current-date() 	Returns the current date (with timezone)
		public static function current-time() 	Returns the current time (with timezone)
		public static function implicit-timezone() 	Returns the value of the implicit timezone
		public static function default-collation() 	Returns the value of the default collation
		public static function static-base-uri() 	Returns the value of the base-uri
		*/
		
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}