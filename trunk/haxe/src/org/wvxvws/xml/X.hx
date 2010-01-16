/**
 * ...
 * @author wvxvw
 */
package org.wvxvws.xml;

class X 
{
	private static var LT:Int = 60;
	private static var GT:Int = 62;
	private static var SLASH:Int = 47;
	private static var SPACE:Int = 32;
	private static var EQ:Int = 61;
	private static var SINGLE_Q:Int = 39;
	private static var DOUBLE_Q:Int = 34;
	
	private static var SPACE_CHAR:String = " ";
	private static var TAB_CHAR:String = "\t";
	private static var RET_CHAR:String = "\r";
	private static var NL_CHAR:String = "\n";
	
	private static var ATT_SORTING_NONE:Int = -1;
	private static var ATT_SORTING_ALPHA:Int = 0;
	private static var ATT_SORTING_XMLNS_FIRST:Int = 1;
	private static var ATT_SORTING_XMLNS_FIRST_ALPHA:Int = 2;
	private static var ATT_SORTING_XMLNS_LAST_ALPHA:Int = 3;
	private static var ATT_SORTING_XMLNS_LAST:Int = 4;
	
	private static var _options:XOptions;
	private static var _out:String;
	
	// node-set
	private static var X_CHILD:Int = 47; // "/"
	private static var X_AMP:Int = 64; // "@"
	private static var X_ALL:Int = 42; // "*"
	private static var X_COL:Int = 58; // ":"
	private static var X_THIS:Int = 46; // "."
	
	// constructions
	private static var X_OB:Int = 91; // "[";
	private static var X_CB:Int = 93; // "]";
	private static var X_OP:Int = 40; // "(";
	private static var X_CP:Int = 41; // ")";
	private static var X_COMA:Int = 44; // ",";
	
	// bool
	private static var X_EQ:String = "=";
	private static var X_NE:String = "!=";
	private static var X_GT:String = ">";
	private static var X_LT:String = "<";
	private static var X_LTEQ:String = "<=";
	private static var X_GTEQ:String = ">=";
	private static var X_AND:String = "and";
	private static var X_OR:String = "or";
	private static var X_UN:String = "|";
	
	// math
	private static var X_PLUS:String = "+";
	private static var X_MINUS:String = "-";
	private static var X_DIV:String = "div";
	private static var X_MUL:String = "*";
	private static var X_MOD:String = "mod";
	private static var X_VAR:String = "$";
	
	private static var X_T_COMMENT:String = "comment";	
	private static var X_T_TEXT:String = "text";	
	private static var X_T_PI:String = "processing-instruction";	
	private static var X_T_NODE:String = "node";
	
	private static var _xroot:Xml;
	private static var _methods:Hash<String>;
	private static var _scope:Dynamic;
	private static var _currentNodes:Array<Xml>;
	private static var _currentAtts:Array<Hash<String>>;
	private static var _currentTexts:Array<String>;
	private static var _position:Int;
	
	public function new()
	{
		_methods = new Hash<String>();
		// node-set
		_methods.set("last", "last");
		_methods.set("position", "position");
		_methods.set("count", "count");
		_methods.set("id", "id");
		_methods.set("local-name", "localName");
		_methods.set("namespace-uri", "namespaceURI");
		_methods.set("name", "name");
		// strings
		_methods.set("string", "string");
		_methods.set("concat", "concat");
		_methods.set("starts-with", "startsWith");
		_methods.set("contains", "contains");
		_methods.set("substring-before", "substringBefore");
		_methods.set("substring-after", "substringAfter");
		_methods.set("substring", "substring");
		_methods.set("normalize-space", "normalizeSpace");
		_methods.set("translate", "translate");
		// bool
		_methods.set("boolean", "boolean");
		_methods.set("not", "not");
		_methods.set("true", "xtrue");
		_methods.set("false", "xfalse");
		_methods.set("lang", "lang");
		// number
		_methods.set("number", "number");
		_methods.set("sum", "sum");
		_methods.set("floor", "floor");
		_methods.set("ceiling", "ceiling");
		_methods.set("round", "round");
	}
	
	public static function path(input:Xml, expression:String, scope:Dynamic):Dynamic
	{
		_xroot = input;
		if (_methods == null) new X();
		_position = 0;
		_currentNodes = new Array<Xml>();
		if (input.nodeType == Xml.Document)
			_currentNodes.push(input.firstElement());
		else _currentNodes.push(input);
		evalPath(expression);
		trace(_currentNodes);
		return null;
	}
	
	private static function evalExpr(expr:String):Void
	{
		
	}
	
	private static function evalPath(expr:String):Void
	{
		var i:Int = _position;
		var len:Int = expr.length;
		
		var ch:Int = -1;
		var ch2:Int = -1;
		
		var isChild:Bool = false;
		var isParent:Bool = false;
		var isDescendant:Bool = false;
		var isAll:Bool = false;
		var isAtt:Bool = false;
		var isNS:Bool = false;
		var isThis:Bool = false;
		
		var isElemType:Bool = true;
		var isAttType:Bool = false;
		var isTextType:Bool = false;
		
		var word:String = "";
		var nodes:Array<Xml> = _currentNodes;
		var nodes2:Array<Xml> = null;
		var attributes:Array<Hash<String>> = _currentAtts;
		var attributes2:Array<Hash<String>>;
		var texts:Array<String> = _currentTexts;
		var texts2:Array<String>;
		
		while (i < len)
		{
			ch = expr.charCodeAt(i);
			if (len > i + 1) ch2 = expr.charCodeAt(i + 1);
			else ch2 = -1;
			switch (ch)
			{
				//{ Child or Descendant
				case X_CHILD: //- /
					if (isDescendant || isChild)
						throw "Illegal character at: " + i;
					isChild = false;
					isParent = false;
					isDescendant = false;
					isAll = false;
					isAtt = false;
					isNS = false;
					isThis = false;
					if (ch2 == X_CHILD)
					{
						isDescendant = true;
						i++;
						if (word != "")
						{
							selectElements(word);
							word = "";
						}
						nodes2 = new Array<Xml>();
						for (n in _currentNodes.iterator())
						{
							nodes2.push(n);
							nodes2 = nodes2.concat(getDesc(n));
						}
						_currentNodes = nodes2;
					}
					else
					{
						isChild = true;
						if (word != "")
						{
							selectElements(word);
							word = "";
						}
						nodes2 = new Array<Xml>();
						for (n in _currentNodes.iterator())
						{
							nodes2.push(n);
						}
						_currentNodes = nodes2;
					}
					isElemType = true;
					isAttType = false;
					isTextType = false;
				//}
				
				case X_AMP: //- @
					isAtt = true;
					isElemType = false;
					isAttType = true;
					isTextType = false;
				case X_ALL: //- *
					if (word.length > 0)
						throw "Illegal character at: " + i;
					isAll = true;
				case X_COL: //- :
					if (ch2 == X_COL)
					{
						isNS = true;
						i++;
					}
					else
					{
						throw "Illegal character at: " + i;
					}
					isElemType = false;
					isAttType = true;
					isTextType = false;
				
				//{ This or Parent
				case X_THIS: //- .
					if (isThis || isParent)
						throw "Illegal character at: " + i;
					isChild = false;
					isParent = false;
					isDescendant = false;
					isAll = false;
					isAtt = false;
					isNS = false;
					isThis = false;
					if (ch2 == X_THIS)
					{
						isParent = true;
						i++;
						if (word != "")
						{
							selectElements(word);
							word = "";
						}
						nodes2 = new Array<Xml>();
						for (n in _currentNodes.iterator())
						{
							nodes2.push(n.parent);
						}
						_currentNodes = nodes2;
					}
					else
					{
						isThis = true;
					}
					isElemType = true;
					isAttType = false;
					isTextType = false;
				//}
				
				//{ Word
				default:
					isChild = false;
					isParent = false;
					isDescendant = false;
					isAll = false;
					isAtt = false;
					isNS = false;
					isThis = false;
					if (word.length == 0)
					{
						if (ch < 65 || (ch > 90 && ch < 97) || ch > 122)
						{
							throw "Illegal character at: " + i;
						}
						else word += String.fromCharCode(ch);
					}
					else if ((ch < 48 && ch != 36 && ch != 45) || 
						(ch > 57 && ch < 65) || (ch > 90 && ch < 97) || ch > 122)
					{
						// End of the word
						if (ch == X_OB)
						{
							// Function
							if (!isElemType)
								throw "Illegal character at: " + i;
						}
						else if (ch == X_OP)
						{
							// Array
							selectElements(word);
							word = null;
							evalExpr(expr.substr(i));
						}
					}
					else word += String.fromCharCode(ch);
				//}
			}
			i++;
		}
		if (word != null)
		{
			selectElements(word);
		}
	}
	
	private static function selectElements(name:String):Void
	{
		trace("selecting " + name);
		var nodes:Array<Xml> = new Array<Xml>();
		for (n in _currentNodes.iterator())
		{
			if (n.nodeType != Xml.Element) continue;
			for (m in n.elementsNamed(name))
			{
				nodes.push(m);
			}
		}
		_currentNodes = nodes;
	}
	
	private static function getDesc(forNode:Xml):Array<Xml>
	{
		var ret:Array<Xml> = new Array<Xml>();
		for (n in forNode.iterator())
		{
			ret.push(n);
			if (n.nodeType == Xml.Element)
				ret = ret.concat(getDesc(n));
		}
		return ret;
	}
	
	public static function print(input:Xml, ?options:XOptions):String
	{
		var prolog:String = "";
		var space:String;
		var quot:String;
		var iter:Iterator<Xml>;
		var arr:Array<String>;
		
		if (options != null) _options = options;
		else _options = new XOptions();
		if (input.nodeType == Xml.Document)
		{
			if (_options.outputProlog)
			{
				//<?xml version="1.0" encoding="utf-8"?>
				space = _options.wrapEqWithSpaces ? SPACE_CHAR : "";
				quot = _options.useSingleQuotes ? "'" : "\"";
				arr = cast ["<?xml version", space, "=", space, quot, 
					_options.xmlVersion, quot, " encoding", space, space, 
					quot, _options.xmlEncoding, quot, "?>", _options.lineEnd];
				prolog = Xml.createProlog(arr.join("")).toString();
			}
			_out = prolog;
			iter = input.iterator();
			while (iter.hasNext())
			{
				_out += printNode(iter.next(), 0, true);
			}
		}
		else _out = printNode(input, 0, true);
		return _out;
	}
	
	private static function printNode(node:Xml, depth:Int, nl:Bool):String
	{
		var sb:StringBuf = new StringBuf();
		var attList:Array<Hash<String>>;
		var attIter:Iterator<String>;
		var chIter:Iterator<Xml>;
		var name:String;
		var line:String;
		var att:StringBuf;
		var attLines:Array<String>;
		var lineLen:Int;
		var lineBreakInd:Int;
		var i:Int = depth;
		var ind:String;
		var nextNode:Xml;
		var chars:Array<String> = new Array<String>();
		var hasAttributes:Bool;
		
		if (nl)
		{
			while (i-- > 0) chars[i] = _options.indentChar;
			ind = chars.join("");
		}
		else ind = "";
		
		switch (node.nodeType)
		{
			case Xml.Element:
				sb.add(ind);
				sb.addChar(LT);
				sb.add(node.nodeName);
				hasAttributes = false;
				switch (_options.attributeSorting)
				{
					case ATT_SORTING_NONE:
						attIter = node.attributes();
						hasAttributes = attIter.hasNext();
						while (attIter.hasNext())
						{
							if (_options.attributesOnNewLine)
							{
								sb.add(_options.lineEnd);
								sb.add(ind);
								sb.add(_options.indentChar);
							}
							else sb.addChar(SPACE);
							name = attIter.next();
							sb.add(name);
							if (_options.wrapEqWithSpaces) sb.addChar(SPACE);
							sb.addChar(EQ);
							if (_options.wrapEqWithSpaces) sb.addChar(SPACE);
							// TODO: maybe escape opposite quotes?
							if (_options.useSingleQuotes) sb.addChar(SINGLE_Q);
							else sb.addChar(DOUBLE_Q);
							sb.add(node.get(name));
							if (_options.useSingleQuotes) sb.addChar(SINGLE_Q);
							else sb.addChar(DOUBLE_Q);
						}
					//case ATT_SORTING_ALPHA:;
					//case ATT_SORTING_XMLNS_FIRST:;
					//case ATT_SORTING_XMLNS_FIRST_ALPHA:;
					//case ATT_SORTING_REVERSE:;
					//case ATT_SORTING_XMLNS_FIRST_REVERSE:;
					//case ATT_SORTING_XMLNS_LAST_REVERSE:;
					//case ATT_SORTING_XMLNS_LAST_ALPHA:;
					//case ATT_SORTING_XMLNS_LAST:;
				}
				chIter = node.iterator();
				i = hasChildren(chIter);
				if (i < 1 && !_options.alwaysExpand) sb.addChar(SLASH);
				if (_options.gtOnNewLine > 0 && hasAttributes)
				{
					sb.add(_options.lineEnd);
					sb.add(ind);
					if (_options.gtOnNewLine > 1) sb.add(_options.indentChar);
				}
				sb.addChar(GT);
				if (i < 3)
				{
					if (i != 0 || !_options.alwaysExpand)
						sb.add(_options.lineEnd);
				}
				chIter = node.iterator();
				while (chIter.hasNext())
				{
					nextNode = chIter.next();
					if (i == 3) sb.add(printNode(nextNode, (depth + 1), false));
					else sb.add(printNode(nextNode, (depth + 1), true));
				}
				if (i > 0)
				{
					if (i < 3) sb.add(ind);
					sb.addChar(LT);
					sb.addChar(SLASH);
					sb.add(node.nodeName);
					sb.addChar(GT);
					if (nl) sb.add(_options.lineEnd);
				}
				else if (i == 0 && _options.alwaysExpand)
				{
					sb.addChar(LT);
					sb.addChar(SLASH);
					sb.add(node.nodeName);
					sb.addChar(GT);
					if (nl) sb.add(_options.lineEnd);
				}
			case Xml.CData:
				sb.add(node.nodeValue);
			case Xml.PCData:
				if (_options.ignoreWhite)
				{
					line = node.toString();
					lineLen = 0;
					lineBreakInd = line.length;
					while (lineLen < lineBreakInd)
					{
						name = line.charAt(lineLen);
						if (name == SPACE_CHAR || name == TAB_CHAR || 
							name == RET_CHAR || name == NL_CHAR)
						{
							lineLen++;
							continue;
						}
						break;
					}
					if (lineLen < lineBreakInd)
					{
						while (lineBreakInd > lineLen)
						{
							lineBreakInd--;
							name = line.charAt(lineBreakInd);
							if (name == SPACE_CHAR || name == TAB_CHAR || 
							name == RET_CHAR || name == NL_CHAR)
							{
								continue;
							}
							break;
						}
					}
					if (nl && lineBreakInd > lineLen) sb.add(ind);
					sb.add(line.substr(lineLen, 1 + lineBreakInd - lineLen));
					if (nl && lineBreakInd > lineLen) sb.add(_options.lineEnd);
				}
				else sb.add(node.nodeValue);
			case Xml.Comment:
				if (!_options.ignoreComments) sb.add(node.toString());
			case Xml.Prolog:
				return "";
		}
		return sb.toString();
	}
	
	/**
		
		@param	iter
		@return 
		0 - no children
		1 - one child not text
		2 - many children
		3 - only one text child
	**/
	private static function hasChildren(iter:Iterator<Xml>):Int
	{
		var i:Int = 0;
		var isText:Bool = false;
		var node:Xml;
		while (iter.hasNext())
		{
			node = iter.next();
			isText = node.nodeType == Xml.PCData;
			i++;
			if (i > 1) break;
		}
		if (isText && i == 1) return 3;
		else return i;
	}
}
class Axis
{
	public static var SELF:String = "self";
	public static var CHILD:String = "child";
	public static var PARENT:String = "parent";
	public static var ATTRIBUTE:String = "attribute";
	public static var DESCENDANT:String = "descendant";
	public static var FOLLOWING:String = "following";
	public static var FOLLOWING_SIBLING:String = "following-sibling";
	public static var PRECEDING:String = "preceding";
	public static var PRECEDING_SIBLING:String = "preceding-sibling";
	public static var ANCESTOR_OR_SELF:String = "ancestor-or-self";
	public static var DESCENDANT_OR_SELF:String = "descendant-or-self";
	public static var NAMESPACE:String = "namespace";
	
	public var type:String;
	
	public function new(type:String, nodes:Array<Xml>)
	{
		this.type = type;
	}
	//{ Node-set processing
	/**
		The last function returns a number equal to the context size from 
		the expression evaluation context.
	**/
	public static function last():Int
	{
		
		return 0;
	}
	
	/**
		The position function returns a number equal to the context position 
		from the expression evaluation context.
	**/
	public static function position():Int
	{
		
		return 0;
	}
	
	/**
		The count function returns the number of nodes in the argument node-set.
	**/
	public static function count(nodes:Array<Xml>):Int
	{
		
		return 0;
	}
	
	/**
		The id function selects elements by their unique ID (see [5.2.1 Unique IDs]). 
		When the argument to id is of type node-set, then the result is the union 
		of the result of applying id to the string-value of each of the nodes in 
		the argument node-set. When the argument to id is of any other type, 
		the argument is converted to a string as if by a call to the string function; 
		the string is split into a whitespace-separated list of tokens 
		(whitespace is any sequence of characters matching the production S); 
		the result is a node-set containing the elements in the same document as 
		the context node that have a unique ID equal to any of the tokens in the list.
		
		id("foo") selects the element with unique ID foo
		
		id("foo")/child::para[position()=5] selects the fifth para child of the 
		element with unique ID foo
	**/
	public static function id(object:Dynamic):Array<Xml>
	{
		
		return null;
	}
	
	/**
		The local-name function returns the local part of the expanded-name of 
		the node in the argument node-set that is first in document order. 
		If the argument node-set is empty or the first node has no expanded-name, 
		an empty string is returned. If the argument is omitted, it defaults to 
		a node-set with the context node as its only member.
	**/
	public static function localName(?nodes:Array<Xml>):String
	{
		
		return null;
	}
	
	/**
		The namespace-uri function returns the namespace URI of the expanded-name of 
		the node in the argument node-set that is first in document order. 
		If the argument node-set is empty, the first node has no expanded-name, 
		or the namespace URI of the expanded-name is null, an empty string is returned. 
		If the argument is omitted, it defaults to a node-set with the context node 
		as its only member.
		
		NOTE: The string returned by the namespace-uri function will be empty 
		except for element nodes and attribute nodes.
	**/
	public static function namespaceURI(?nodes:Array<Xml>):String
	{
		
		return null;
	}
	
	/**
		
		The name function returns a string containing a QName representing the 
		expanded-name of the node in the argument node-set that is first 
		in document order. The QName must represent the expanded-name with respect 
		to the namespace declarations in effect on the node whose expanded-name 
		is being represented. Typically, this will be the QName that occurred in 
		the XML source. This need not be the case if there are namespace declarations 
		in effect on the node that associate multiple prefixes with the same namespace. 
		However, an implementation may include information about the original prefix 
		in its representation of nodes; in this case, an implementation can ensure 
		that the returned string is always the same as the QName used in the XML source. 
		If the argument node-set is empty or the first node has no expanded-name, 
		an empty string is returned. If the argument it omitted, it defaults to 
		a node-set with the context node as its only member.
		
		NOTE: The string returned by the name function will be the same as the string 
		returned by the local-name function except for element nodes and attribute nodes.
	**/
	public static function name(?nodes:Array<Xml>):String
	{
		
		return null;
	}
	//}
	
	//{ Strings
	/**
		The string function converts an object to a string as follows:
		
		A node-set is converted to a string by returning the string-value of the node 
		in the node-set that is first in document order. If the node-set is empty, 
		an empty string is returned.
		
		A number is converted to a string as follows
		
		NaN is converted to the string NaN
		positive zero is converted to the string 0
		negative zero is converted to the string 0
		positive infinity is converted to the string Infinity
		negative infinity is converted to the string -Infinity
		
		if the number is an integer, the number is represented in decimal form as a 
		Number with no decimal point and no leading zeros, preceded by a minus sign 
		(-) if the number is negative
		
		otherwise, the number is represented in decimal form as a Number including 
		a decimal point with at least one digit before the decimal point and at least 
		one digit after the decimal point, preceded by a minus sign (-) if the number 
		is negative; there must be no leading zeros before the decimal point apart 
		possibly from the one required digit immediately before the decimal point; 
		beyond the one required digit after the decimal point there must be as many, 
		but only as many, more digits as are needed to uniquely distinguish the 
		number from all other IEEE 754 numeric values.
		
		The boolean false value is converted to the string false. The boolean true 
		value is converted to the string true.
		
		An object of a type other than the four basic types is converted to a string 
		in a way that is dependent on that type.
		
		If the argument is omitted, it defaults to a node-set with the context node 
		as its only member.
		
		NOTE: The string function is not intended for converting numbers into 
		strings for presentation to users. The format-number function and 
		xsl:number element in [XSLT] provide this functionality.
	 **/
	public static function string(?object:Dynamic):String
	{
		
		return null;
	}
	
	/**
		The concat function returns the concatenation of its arguments.
	**/
	public static function concat(a:String, b:String):String
	{
		return a + b;
	}
	
	/**
		The starts-with function returns true if the first argument string starts 
		with the second argument string, and otherwise returns false.
	**/
	public static function startsWith(starts:String, with:String):Bool
	{
		return StringTools.startsWith(starts, with );
	}
	
	/**
		The contains function returns true if the first argument string contains 
		the second argument string, and otherwise returns false.
	**/
	public static function contains(who:String, whom:String):Bool
	{
		return who.indexOf(whom) > -1;
	}

	/**
		The substring-before function returns the substring of the first argument 
		string that precedes the first occurrence of the second argument string 
		in the first argument string, or the empty string if the first argument 
		string does not contain the second argument string. For example, 
		substring-before("1999/04/01","/") returns 1999.
	**/
	public static function substringBefore(from:String, delim:String):String
	{
		var i:Int = from.indexOf(delim);
		if (i < 0) return "";
		else return from.substr(0, i);
	}

	/**
		The substring-after function returns the substring of the first argument 
		string that follows the first occurrence of the second argument string 
		in the first argument string, or the empty string if the first argument 
		string does not contain the second argument string. For example, 
		substring-after("1999/04/01","/") returns 04/01, 
		and substring-after("1999/04/01","19") returns 99/04/01.
	**/
	public static function substringAfter(from:String, delim:String):String
	{
		var i:Int = from.indexOf(delim);
		if (i < 0) return "";
		else return from.substr(i, from.length - i);
	}

	/**
		The substring function returns the substring of the first argument starting 
		at the position specified in the second argument with length specified 
		in the third argument. For example, substring("12345",2,3) returns "234". 
		If the third argument is not specified, it returns the substring starting 
		at the position specified in the second argument and continuing to the end 
		of the string. For example, substring("12345",2) returns "2345".

		More precisely, each character in the string (see [3.6 Strings]) 
		is considered to have a numeric position: the position of the first 
		character is 1, the position of the second character is 2 and so on.

		NOTE: This differs from Java and ECMAScript, in which the String.substring 
		method treats the position of the first character as 0.
		The returned substring contains those characters for which the position 
		of the character is greater than or equal to the rounded value of the 
		second argument and, if the third argument is specified, less than the 
		sum of the rounded value of the second argument and the rounded value 
		of the third argument; the comparisons and addition used for the above 
		follow the standard IEEE 754 rules; rounding is done as if by a call 
		to the round function. The following examples illustrate various 
		unusual cases:

		substring("12345", 1.5, 2.6) returns "234"
		substring("12345", 0, 3) returns "12"
		substring("12345", 0 div 0, 3) returns ""
		substring("12345", 1, 0 div 0) returns ""
		substring("12345", -42, 1 div 0) returns "12345"
		substring("12345", -1 div 0, 1 div 0) returns ""
	**/
	public static function substring(from:String, start:Int, ?length:Int):String
	{
		return from.substr(start, length); 
	}

	/**
		The string-length returns the number of characters in the string 
		(see [3.6 Strings]). If the argument is omitted, it defaults to the context 
		node converted to a string, in other words the string-value of the context node.
	**/
	public static function stringLength(?input:String):Int
	{
		if (input != null) return input.length;
		return 0;
	}

	/**
		The normalize-space function returns the argument string with whitespace 
		normalized by stripping leading and trailing whitespace and replacing 
		sequences of whitespace characters by a single space. Whitespace characters 
		are the same as those allowed by the S production in XML. 
		If the argument is omitted, it defaults to the context node converted 
		to a string, in other words the string-value of the context node.
	**/
	public static function normalizeSpace(?input:String):String
	{
		var ret:String = "";
		var isSpace:Bool = false;
		var sb:StringBuf;
		var ch:Int;
		if (input != null)
		{
			ret = StringTools.rtrim(input);
			ret = StringTools.ltrim(input);
			sb = new StringBuf();
			for (i in 0...ret.length)
			{
				ch = ret.charCodeAt(i);
				if (isSpace)
				{
					if (ch != 0x20 && ch != 0x9 && ch != 0xD && ch != 0xA)
					{
						isSpace = false;
						sb.addChar(ch);
					}
				}
				else if (ch == 0x20 || ch == 0x9 || ch == 0xD || ch == 0xA)
				{
					isSpace = true;
					sb.addChar(ch);
				}
				else sb.addChar(ch);
			}
			ret = sb.toString();
		}
		return ret;
	}

	/**
		The translate function returns the first argument string with occurrences of 
		characters in the second argument string replaced by the character at 
		the corresponding position in the third argument string. For example, 
		translate("bar","abc","ABC") returns the string BAr. 
		If there is a character in the second argument string with no character at 
		a corresponding position in the third argument string (because the second 
		argument string is longer than the third argument string), then occurrences 
		of that character in the first argument string are removed. For example, 
		translate("--aaa--","abc-","ABC") returns "AAA". 
		If a character occurs more than once in the second argument string, 
		then the first occurrence determines the replacement character. 
		If the third argument string is longer than the second argument string, 
		then excess characters are ignored.
		
		NOTE: The translate function is not a sufficient solution for case 
		conversion in all languages. A future version of XPath may provide 
		additional functions for case conversion.
	**/
	public static function translate(what:String, pattern:String, pool:String):String
	{
		var sb:StringBuf = new StringBuf();
		var ch:String;
		var ind:Int;
		for (i in 0...what.length)
		{
			ch = what.charAt(i);
			ind = pattern.indexOf(ch);
			if (ind < 0) sb.addChar(ch.charCodeAt(0));
			else if (ind < pool.length) sb.addChar(pool.charCodeAt(ind));
		}
		return sb.toString();
	}
	//}
	
	//{ Booleans
	/**
		The boolean function converts its argument to a boolean as follows:
		
		a number is true if and only if it is neither positive or negative zero nor NaN
		a node-set is true if and only if it is non-empty
		a string is true if and only if its length is non-zero
		an object of a type other than the four basic types is converted to a boolean 
		in a way that is dependent on that type
	**/
	public static function boolean(object:Dynamic):Bool
	{
		var ret:Bool = false;
		if (Std.is(object, Bool))
		{
			ret = cast object;
		}
		else if (Std.is(object, Float) || Std.is(object, Int) || Std.is(object, UInt))
		{
			ret = object != 0 && !Math.isNaN(cast(object, Float));
		}
		else if (Std.is(object, String))
		{
			ret = object != "";
		}
		else ret = object != null;
		return ret;
	}

	/**
		The not function returns true if its argument is false, and false otherwise.
	**/
	public static function not(boolean:Bool):Bool { return !boolean; }
	
	/**
		The true function returns true.
	**/
	public static function xtrue():Bool { return true; }

	/**
		The true function returns false.
	**/
	public static function xfalse():Bool { return false; }

	/**
		The lang function returns true or false depending on whether the language 
		of the context node as specified by xml:lang attributes is the same as 
		or is a sublanguage of the language specified by the argument string. 
		The language of the context node is determined by the value of the 
		xml:lang attribute on the context node, or, if the context node has 
		no xml:lang attribute, by the value of the xml:lang attribute on 
		the nearest ancestor of the context node that has an xml:lang attribute. 
		If there is no such attribute, then lang returns false. If there is such 
		an attribute, then lang returns true if the attribute value is equal to 
		the argument ignoring case, or if there is some suffix starting with - 
		such that the attribute value is equal to the argument ignoring that suffix 
		of the attribute value and ignoring case. 
		For example, lang("en") would return true if the context node is any 
		of these five elements:
		<pre>
		<para xml:lang="en"/>
		<div xml:lang="en"><para/></div>
		<para xml:lang="EN"/>
		<para xml:lang="en-us"/>
		</pre>
	**/
	public static function lang(string:String):Bool
	{
		
		return false;
	}
	//}

	//{ Numbers
	/**
		The number function converts its argument to a number as follows:

		a string that consists of optional whitespace followed by an optional minus 
		sign followed by a Number followed by whitespace is converted to the 
		IEEE 754 number that is nearest 
		(according to the IEEE 754 round-to-nearest rule) to the mathematical value 
		represented by the string; any other string is converted to NaN

		boolean true is converted to 1; boolean false is converted to 0

		a node-set is first converted to a string as if by a call to the string 
		function and then converted in the same way as a string argument

		an object of a type other than the four basic types is converted to 
		a number in a way that is dependent on that type

		If the argument is omitted, it defaults to a node-set with the context 
		node as its only member.

		NOTE: The number function should not be used for conversion of numeric 
		data occurring in an element in an XML document unless the element is 
		of a type that represents numeric data in a language-neutral format 
		(which would typically be transformed into a language-specific format for 
		presentation to a user). 
		In addition, the number function cannot be used unless the language-neutral 
		format used by the element is consistent with the XPath syntax for a Number.
	**/
	public static function number(?object:Dynamic):Float
	{
		
		return Math.NaN;
	}
	
	/**
		The sum function returns the sum, for each node in the argument node-set, 
		of the result of converting the string-values of the node to a number.
	**/
	public static function sum(nodes:Array<Xml>):Float
	{
		var ret:Float = 0;
		for (n in nodes.iterator())
		{
			ret += Std.parseFloat(n.toString());
		}
		return ret;
	}

	/**
		The floor function returns the largest (closest to positive infinity) 
		number that is not greater than the argument and that is an integer.
	**/
	public static function floor(number:Float):Float
	{
		return Math.floor(number);
	}
	
	/**
		The ceiling function returns the smallest (closest to negative infinity) 
		number that is not less than the argument and that is an integer.
	**/
	public static function ceiling(number:Float):Float
	{
		return Math.ceil(number);
	}

	/**
		The round function returns the number that is closest to the argument and 
		that is an integer. If there are two such numbers, then the one that is 
		closest to positive infinity is returned. If the argument is NaN, then NaN 
		is returned. If the argument is positive infinity, then positive infinity 
		is returned. If the argument is negative infinity, then negative infinity 
		is returned. If the argument is positive zero, then positive zero is returned. 
		If the argument is negative zero, then negative zero is returned. 
		If the argument is less than zero, but greater than or equal to -0.5, 
		then negative zero is returned.
		
		NOTE: For these last two cases, the result of calling the round function 
		is not the same as the result of adding 0.5 and then calling the floor function.
	**/
	public static function round(number:Float):Float
	{
		return Math.round(number);
	}
	//}
}