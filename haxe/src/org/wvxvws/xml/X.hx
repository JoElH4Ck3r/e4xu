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
	private static var ATT_SORTING_REVERSE:Int = 3;
	private static var ATT_SORTING_XMLNS_FIRST_REVERSE:Int = 3;
	private static var ATT_SORTING_XMLNS_LAST_REVERSE:Int = 4;
	private static var ATT_SORTING_XMLNS_LAST_ALPHA:Int = 5;
	private static var ATT_SORTING_XMLNS_LAST:Int = 6;
	
	private static var _options:XmlPrintOptions;
	private static var _out:String;
	private static var _outBuff:StringBuf;
	private static var _nlRE:EReg = ~/[\r\n]+/gm;
	
	public function new() { }
	
	public static function print(input:Xml, ?options:XmlPrintOptions):String
	{
		var prolog:String = "";
		var space:String;
		var quot:String;
		var iter:Iterator<Xml>;
		if (options != null) _options = options;
		else _options = new XmlPrintOptions();
		if (input.nodeType == Xml.Document)
		{
			if (_options.outputProlog)
			{
				//<?xml version="1.0" encoding="utf-8"?>
				space = _options.wrapEqWithSpaces ? SPACE_CHAR : "";
				quot = _options.useSingleQuotes ? "'" : "\"";
				prolog = Xml.createProlog(
					"<?xml version" + space + "=" + space + quot + 
					_options.xmlVersion + quot + " encoding" + space + 
					space + quot + _options.xmlEncoding + quot + "?>").toString();
			}
			_out = prolog;
			iter = input.iterator();
			while (iter.hasNext())
			{
				_out += printNode(iter.next(), 0);
			}
		}
		else _out = printNode(input, 0);
		return _out;
	}
	
	private static function printNode(node:Xml, depth:Int):String
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
		while (i > 0)
		{
			sb.addChar(_options.indentChar);
			i--;
		}
		var ind:String = sb.toString();
		switch (node.nodeType)
		{
			case Xml.Element:
				sb.addChar(LT);
				sb.add(node.nodeName);
				switch (_options.attributeSorting)
				{
					case ATT_SORTING_NONE:
						attIter = node.attributes();
						while (attIter.hasNext())
						{
							if (_options.attributesOnNewLine)
							{
								sb.add(_options.lineEnd);
								sb.add(ind);
								sb.addChar(_options.indentChar);
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
				if (!chIter.hasNext()) sb.addChar(SLASH);
				sb.addChar(GT);
				sb.add(_options.lineEnd);
				i = 0;
				while (chIter.hasNext())
				{
					i++;
					sb.add(printNode(chIter.next(), depth + 1));
				}
				if (i > 0)
				{
					sb.add(ind.substr(1));
					sb.addChar(LT);
					sb.addChar(SLASH);
					sb.add(node.nodeName);
					sb.addChar(GT);
					sb.add(_options.lineEnd);
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
					i = lineLen;
					if (lineLen < lineBreakInd)
					{
						while (lineBreakInd > lineLen)
						{
							name = line.charAt(lineBreakInd);
							if (name == SPACE_CHAR || name == TAB_CHAR || 
							name == RET_CHAR || name == NL_CHAR)
							{
								lineBreakInd--;
								continue;
							}
							break;
						}
					}
					sb.add(line.substr(lineLen, lineBreakInd - lineLen));
				}
				else sb.add(node.nodeValue);
			case Xml.Comment:
				if (!_options.ignoreComments) sb.add(node.toString());
			case Xml.Prolog:
				return "";
		}
		return sb.toString();
	}
}