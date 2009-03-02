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
		public function XPath() 
		{
			super();
			
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns the node-name of the argument node
		 * @param	node
		 * @return	Object
		 */
		public static function nodeName(node:String):Object { }
		
		/**
		 * Returns a Boolean value indicating whether the argument node is nilled
		 * @param	node
		 * @return	Boolean
		 */
		public static function nilled(node:String):Boolean { }
		
		/**
		 * Takes a sequence of items and returns a sequence of atomic values
		 * @param	...rest
		 * @return	XMLList.
		 */
		public static function data(...rest):XMLList { }
		
		/**
		 * Returns the value of the base-uri property of the current or specified node
		 * @return	String.
		 */
		public static function baseURI(node = null):String { }
		
		/**
		 * Returns the value of the document-uri property for the specified node
		 * @param	node
		 * @return
		 */
		public static function documentURI(node:String):String { }
		
		/**
		 * Example: error(fn:QName('http://example.com/test', 'err:toohigh'), 'Error: Price is too high')
		 * Result: Returns http://example.com/test#toohigh and the string "Error: Price is too high" to the external processing environment
		 */
		public static function error(error:Error, description:String):void
		
		/**
		 * Used to debug queries
		 * @param	value
		 * @param	label
		 * @return
		 */
		public static function trace(value:Object, label:String):void { }
		
		/**
		 * Returns the numeric value of the argument. The argument could be a boolean, string, or node-set.
		 * Example: number('100')
		 * Result: 100
		 * @param	arg
		 * @return	Number.
		 */
		public static function number(arg:Object):Number

		/**
		 * Returns the absolute value of the argument
		 * Example: abs(3.14)
		 * Result: 3.14
		 * @param	num
		 * @return	Number.
		 */
		public static function abs(num:Object):Number { }
		
		/**
		 * Returns the smallest integer that is greater than the number argument
		 * Example: ceiling(3.14)
		 * Result: 4
		 * @param	num
		 * @return	Number.
		 */
		public static function ceiling(num:Object):Number { }
		
		/**
		 * Returns the largest integer that is not greater than the number argument
		 * Example: floor(3.14)
		 * Result: 3
		 * @param	num
		 * @return	Number.
		 */
		public static function floor(num:Object):Number { }
		
		/**
		 * Rounds the number argument to the nearest integer
		 * Example: round(3.14)
		 * Result: 3
		 */
		public static function round(num:Object):Number { }

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
		public static function roundHalfToEven(num:Object):Number { }
		
		/**
		 * Returns the string value of the argument. The argument could be a number, boolean, or node-set
		 * Example: string(314)
		 * Result: "314"
		 * @param	arg
		 * @return	String.
		 */
		public static function string(arg:Object):String { }
		
		/**
		 * Returns a string from a sequence of code points
		 * Example: codepoints-to-string(84, 104, 233, 114, 232, 115, 101)
		 * Result: 'Thérèse'
		 * @param	...rest
		 * @return	String.
		 */
		public static function codepointsToString(...rest):String { }
		
		/**
		 * Returns a sequence of code points from a string
		 * Example: string-to-codepoints("Thérèse")
		 * Result: 84, 104, 233, 114, 232, 115, 101
		 * @param	string
		 * @return	Array.
		 */
		public static function stringToCodepoints(string:String):Array { }
		
		/**
		 * Returns true if the value of comp1 is equal to the value of comp2, 
		 * according to the Unicode code point collation 
		 * (http://www.w3.org/2005/02/xpath-functions/collation/codepoint), 
		 * otherwise it returns false
		 * @param comp1
		 * @param comp2
		 * @return Boolean.
		 */
		public static function codepointEqual(comp1:int, comp2:int):Boolean { }
		
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
		public static function compare(comp1:int, comp2:int, collation:Boolean = false):int { }
		
		/**
		 * Returns the concatenation of the strings.
		 * Example: concat('XPath ','is ','FUN!')
		 * Result: 'XPath is FUN!'
		 * @param	...strings
		 * @return
		 */
		public static function concat(...strings):String { }
		
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
		public static function stringJoin(sep:String, ...strings):String { }
		
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
		public static function substring(string:String, start:int, len:int = 0x7FFFFFFF):String { }
		
		/**
		 * Returns the length of the specified string. 
		 * If there is no string argument it returns the length of 
		 * the string value of the current node.
		 * Example: string-length('Beatles')
		 * Result: 7
		 * @param	string
		 * @return
		 */
		public static function stringLength(string:String = null):int { }
		
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
		public static function normalizeSpace(string:String):String { }
		
		/**
		 * 
		 * @return	String.
		 */
		public static function normalizeUnicode():String { }
		
		/**
		 * Converts the string argument to upper-case.
		 * Example: upper-case('The XML')
		 * Result: 'THE XML'
		 * @param	string
		 * @return	String.
		 */
		public static function upperCase(string:String):String { }
		
		/**
		 * Converts the string argument to lower-case.
		 * Example: lower-case('The XML')
		 * Result: 'the xml'
		 * @param	string
		 * @return
		 */
		public static function lowerCase(string:String):String { }
		
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
		public static function translate(string1:String, string2:String, string3:String):String { }
		
		/**
		 * Example: escape-uri("http://example.com/test#car", true())
		 * Result: "http%3A%2F%2Fexample.com%2Ftest#car"
		 * Example: escape-uri("http://example.com/test#car", false())
		 * Result: "http://example.com/test#car"
		 * Example: escape-uri ("http://example.com/~bébé", false())
		 * Result: "http://example.com/~b%C3%A9b%C3%A9"
		 * @param	stringURI
		 * @param	reverse
		 * @return	String.
		 */
		public static function escapeUri(stringURI:String, reverse:Boolean):String { }
		
		/**
		 * Returns true if string1 contains string2, otherwise it returns false
		 * Example: contains('XML','XM')
		 * Result: true
		 * @param	string1
		 * @param	string2
		 * @return	Boolean.
		 */
		public static function contains(string1:String, string2:String):Boolean { }
		
		/**
		 * Returns true if string1 starts with string2, otherwise it returns false.
		 * Example: starts-with('XML','X')
		 * Result: true
		 * @param	string1
		 * @param	string2
		 * @return	Boolean.
		 */
		public static function startsWith(string1:String, string2:String):Boolean { }
		
		/**
		 * Returns true if string1 ends with string2, otherwise it returns false.
		 * Example: ends-with('XML','X')
		 * Result: false
		 * @param	string1
		 * @param	string2
		 * @return
		 */
		public static function endsWith(string1:String, string2:String):Boolean { }
		
		/**
		 * Returns the start of string1 before string2 occurs in it.
		 * Example: substring-before('12/10','/')
		 * Result: '12'
		 * @param	string1
		 * @param	string2
		 * @return
		 */
		public static function substringBefore(string1:String, string2:String):String { }
		
		/**
		 * Returns the remainder of string1 after string2 occurs in it.
		 * Example: substring-after('12/10','/')
		 * Result: '10'
		 * @param	string1
		 * @param	string2
		 * @return
		 */
		public static function substringAfter(string1:String, string2:String):String { }
		
		/**
		 * Returns true if the string argument matches the pattern, otherwise, it returns false
		 * Example: matches("Merano", "ran")
		 * Result: true
		 * @param	string
		 * @param	pattern
		 * @return
		 */
		public static function matches(string:String, pattern:RegExp):Boolean { }
		
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
		 * @return
		 */
		public static function replace(string:String, pattern:RegExp, replace:String):String { }
		
		/**
		 * Example: tokenize("XPath is fun", "\s+")
		 * Result: ("XPath", "is", "fun")
		 * @param	string
		 * @param	pattern
		 * @return
		 */
		public static function tokenize(string:String, pattern:RegExp):String { }

		public static function resolveUri(relative:Boolean, base:String):String { }
		
		/**
		 * Returns a boolean value for a number, string, or node-set.
		 * @param	arg
		 * @return
		 */
		public static function boolean(arg:*):Boolean { }
		
		/**
		 * The argument is first reduced to a boolean value 
		 * by applying the boolean() function. Returns true if 
		 * the boolean value is false, and false if the boolean value is true.
		 * Example: not(true())
		 * Result: false
		 * @param	arg
		 * @return
		 */
		public static function not(arg:*):Boolean { }
		
		/*
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
*/
		public static function qname():QName
		public static function localNameFromQName():String	 
		public static function namespaceUriFromQName():String
		public static function namespaceURIForPrefix():String
		public static function inScopePrefixes():Array
		public static function resolveQName():void
		
		/**
		 * Returns the name of the current node or the first node in the specified node set
		 * @param	nodeset
		 * @return
		 */
		public static function name(nodeset:XML = null):Object { }
		
		/**
		 * Returns the name of the current node or the first node in the 
		 * specified node set - without the namespace prefix
		 * @param	nodeset = null
		 * @return
		 */
		public static function localName(nodeset:XML = null):Object { }
		
		/**
		 * Returns the namespace URI of the current node or the first node 
		 * in the specified node set
		 * @param	nodeset
		 * @return
		 */
		public static function namespaceURI(nodeset:XML = null):Namespace { }
		
		/**
		 * Returns true if the language of the current node matches the language of the specified language.
		 * Example: Lang("en") is true for
		 * <p xml:lang="en">...</p>
		 * Example: Lang("de") is false for
		 * <p xml:lang="en">...</p>
		 * @param	lang
		 * @return
		 */
		public static function lang(lang:String):Boolean { }
		
		/**
		 * Returns the root of the tree to which the current node 
		 * or the specified belongs. This will usually be a document node
		 * @param	node
		 * @return
		 */
		public static function root(node:XML = null):XML { }
		
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
		 * @param	...items
		 * @return
		 */
		public static function indexOf(searchitem:Object, ...items):Array { }
		
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
		public static function remove(position:int, ...items):Array { }

		/**
		 * 
		public static function empty(item,item,...) 	Returns true if the value of the arguments IS an empty sequence, otherwise it returns false

		/**
		 * Example: empty(remove(("ab", "cd"), 1))
		 * Result: false
		public static function exists(item,item,...) 	Returns true if the value of the arguments IS NOT an empty sequence, otherwise it returns false

		/**
		 * Example: exists(remove(("ab"), 1))
		 * Result: false
		public static function distinct-values((item,item,...),collation) 	Returns only distinct (different) values

		/**
		 * Example: distinct-values((1, 2, 3, 1, 2))
		 * Result: (1, 2, 3)
		public static function insert-before((item,item,...),pos,inserts) 	Returns a new sequence constructed from the value of the item arguments - with the value of the inserts argument inserted in the position specified by the pos argument

		/**
		 * Example: insert-before(("ab", "cd"), 0, "gh")
		 * Result: ("gh", "ab", "cd")

		/**
		 * Example: insert-before(("ab", "cd"), 1, "gh")
		 * Result: ("gh", "ab", "cd")

		/**
		 * Example: insert-before(("ab", "cd"), 2, "gh")
		 * Result: ("ab", "gh", "cd")

		/**
		 * Example: insert-before(("ab", "cd"), 5, "gh")
		 * Result: ("ab", "cd", "gh")
		public static function reverse((item,item,...)) 	Returns the reversed order of the items specified

		/**
		 * Example: reverse(("ab", "cd", "ef"))
		 * Result: ("ef", "cd", "ab")

		/**
		 * Example: reverse(("ab"))
		 * Result: ("ab")
		public static function subsequence((item,item,...),start,len) 	Returns a sequence of items from the position specified by the start argument and continuing for the number of items specified by the len argument. The first item is located at position 1

		/**
		 * Example: subsequence(($item1, $item2, $item3,...), 3)
		 * Result: ($item3, ...)

		/**
		 * Example: subsequence(($item1, $item2, $item3, ...), 2, 2)
		 * Result: ($item2, $item3)
		public static function unordered((item,item,...)) 	Returns the items in an implementation dependent order

Functions That Test the Cardinality of Sequences
Name 	Description
		public static function zero-or-one(item,item,...) 	Returns the argument if it contains zero or one items, otherwise it raises an error
		public static function one-or-more(item,item,...) 	Returns the argument if it contains one or more items, otherwise it raises an error
		public static function exactly-one(item,item,...) 	Returns the argument if it contains exactly one item, otherwise it raises an error

Equals, Union, Intersection and Except
Name 	Description
		public static function deep-equal(param1,param2,collation) 	Returns true if param1 and param2 are deep-equal to each other, otherwise it returns false

Aggregate Functions
Name 	Description
		public static function count((item,item,...)) 	Returns the count of nodes
		public static function avg((arg,arg,...)) 	Returns the average of the argument values

		/**
		 * Example: avg((1,2,3))
		 * Result: 2
		public static function max((arg,arg,...)) 	Returns the argument that is greater than the others

		/**
		 * Example: max((1,2,3))
		 * Result: 3

		/**
		 * Example: max(('a', 'k'))
		 * Result: 'k'
		public static function min((arg,arg,...)) 	Returns the argument that is less than the others

		/**
		 * Example: min((1,2,3))
		 * Result: 1

		/**
		 * Example: min(('a', 'k'))
		 * Result: 'a'
		public static function sum(arg,arg,...) 	Returns the sum of the numeric value of each node in the specified node-set

Functions that Generate Sequences
Name 	Description
		public static function id((string,string,...),node) 	Returns a sequence of element nodes that have an ID value equal to the value of one or more of the values specified in the string argument
		public static function idref((string,string,...),node) 	Returns a sequence of element or attribute nodes that have an IDREF value equal to the value of one or more of the values specified in the string argument
		public static function doc(URI) 	 
		public static function doc-available(URI) 	Returns true if the doc() function returns a document node, otherwise it returns false
		public static function collection()
		public static function collection(string) 	 
Context Functions
Name 	Description
		public static function position() 	Returns the index position of the node that is currently being processed

		/**
		 * Example: //book[position()<=3]
		 * Result: Selects the first three book elements
		public static function last() 	Returns the number of items in the processed node list

		/**
		 * Example: //book[last()]
		 * Result: Selects the last book element
		public static function current-dateTime() 	Returns the current dateTime (with timezone)
		public static function current-date() 	Returns the current date (with timezone)
		public static function current-time() 	Returns the current time (with timezone)
		public static function implicit-timezone() 	Returns the value of the implicit timezone
		public static function default-collation() 	Returns the value of the default collation
		public static function static-base-uri() 	Returns the value of the base-uri
		
		
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