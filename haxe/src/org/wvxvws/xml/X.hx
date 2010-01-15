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
	
	public function new() { }
	
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