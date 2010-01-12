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
		while (i-- > 0) sb.addChar(_options.indentChar);
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
								sb.addChar(_options.lineEnd);
								sb.add(ind);
								sb.addChar(_options.indentChar);
							}
							else if (_options.lineMaxLength < 0)
							{
								sb.addChar(SPACE);
							}
							else
							{
								line = sb.toString();
								lineLen = _options.lineMaxLength;
								lineBreakInd = line.lastIndexOf("\r");
								if (lineBreakInd < 0)
								{
									lineBreakInd = line.lastIndexOf("\n");
								}
								else
								{
									lineBreakInd = 
										cast (Math.max(lineBreakInd, 
										line.lastIndexOf("\n")), Int);
								}
							}
							name = attIter.next();
							att = new StringBuf()
							att.add(name);
							if (_options.wrapEqWithSpaces)
							{
								att.addChar(SPACE);
							}
							att.addChar(EQ);
							if (_options.wrapEqWithSpaces)
							{
								att.addChar(SPACE);
							}
							att.add(node.get(name));
							attLines = _nlRE.split(att.toString());
							if (lineLen - lineBreakInd + attLines[0].length > 
								_options.lineMaxLength)
							{
								sb.addChar(_options.lineEnd);
							}
							else sb.addChar(SPACE);
							sb.add(attLines.join(
								String.fromCharCode(_options.lineEnd)));
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
				while (chIter.hasNext())
				{
					sb.add(printNode(chIter.next(), depth + 1));
				}
		}
		return sb.toString();
	}
}