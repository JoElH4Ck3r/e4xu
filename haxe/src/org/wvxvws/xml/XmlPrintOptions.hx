/**
 * ...
 * @author wvxvw
 */
package org.wvxvws.xml;

class XmlPrintOptions 
{
	public var indent:UInt;
	public var lineEnd:String;
	public var indentChar:Int;
	public var inlineTags:Array<String>;
	public var attributeSorting:Int;
	public var attributesOnNewLine:Bool;
	public var gtOnNewLine:Int;
	public var ignorePIs:Bool;
	public var ignoreComments:Bool;
	public var unicodeToCodepoints:Bool;
	public var outputXmlNsSettings:Bool;
	public var ignoreWhite:Bool;
	public var outputProlog:Bool;
	public var xmlVersion:String;
	public var xmlEncoding:String;
	public var useSingleQuotes:Bool;
	public var wrapEqWithSpaces:Bool;
	
	public function new() 
	{
		this.indent = 1;
		this.lineEnd = "\r";
		this.indentChar = 9;
		this.attributeSorting = -1;
		this.attributesOnNewLine = false;
		this.gtOnNewLine = 0;
		this.ignorePIs = false;
		this.ignoreComments = false;
		this.unicodeToCodepoints = false;
		this.outputXmlNsSettings = false;
		this.ignoreWhite = true;
		this.outputProlog = false;
		this.xmlVersion = "1.0";
		this.xmlEncoding = "utf-8";
		this.useSingleQuotes = false;
		this.wrapEqWithSpaces = false;
	}
}